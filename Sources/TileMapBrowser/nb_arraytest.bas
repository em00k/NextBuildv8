
' nextbuild string arrage using banks em00k july 2022

'!org=32768
'#!heap=8192
'#!copy=h:/testarray.nex

' @Array memory space of array 
' array position can be 16bit
'
' Array1 is defined at the end of the source code. 
' This contains the banks to use and memory address to use

' PutArray(array pointer to use, string to store, position )  - note position is currently not used and will add to the end 
' GetArrar(array pointer, position) - this currently will set ArraySty to the element string. 


#include <nextlib.bas>

dim ArrayStr       as string = ""           ' used in GetArray so must be defined 


asm 
    nextreg     TURBO_CONTROL_NR_07, %11    ; 28mhz 
    di 
end asm 

ClearArray(@Array1)                         ' ensure Array1 is cleared 

' some test elements 

For x = 0 to 350 

    PutArray(@Array1,str(x)+" this is a very big string",0)     ' pointer to array data, string, position, 0 start, -1 end, n insert setposition

next x 

' now pick a random value and retrieve the array 
dim tr as uinteger
do 
    tr = 1 + int (rnd*300)
    print tr;" element to get:"
   GetArray(@Array1, tr)
   print ArrayStr
   'BBREAK 
    'print ZXArray(tr)
    ' WaitKey()
loop 


' These are not written yet 
' DeleteArray(@Array1,0) ' pointer, position 0 start insert, -1 next position on end, n absolute position
' SearchArray(@Array1,"text",var as uinteger) ' array, text to find, byte to return position -1 if not found


sub GetArray(memory_pointer as uinteger,string_position as uinteger)
    ' expects a pointer to the Array to use and position to get the element
    ' this routine will set ArrayStr$ to the element string on exit 
    ' 
    asm 
         
        ; on entry 
        ; (ix+4/5)= memory pointer 
        ; 6/7 = string position 


        ld      c, (ix+6)                   ; element offset 
        ld      b, (ix+7)
        
        ld      a, (hl)                      ; get desired bank 
        nextreg MMU0_0000_NR_50, a           ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a           ; set next bank 
        ld      hl, 0                        ; start at 0     

    find_array_element:

        add     hl, 5                       ; add HEADER bytes to 

        ld      e, (hl)                     ; get first string size 
        inc     hl 
        ld      d, (hl)                     ; de = now element string size 
        inc     hl       

        ; is it 0?
        ld      a, d 
        or      e         
        jr      z, gempty_array_position     ; then jump to add the entry 

        ; move along 
        add     hl, de                      ; add hl to de 

        ; check we are not > $4000 
        ld      a, h                        ; check a > $40 
        cp      $40     
        jr      z, gempty_array_position     ; no more space     
        
        dec     bc 
        ld      a, b 
        or      c 
        jr      nz, find_array_element

        ; now set string 
        ; hl = source string 

        add     hl, 5                       ; add HEADER bytes to 
        ld      de, ._ArrayStr              ; point to ArrayStr$ pointer
        ex      de, hl                      ; swap 
        call    .core.__STORE_STR           ; store in ArrayStr$

    gempty_array_position: 

        ; hl should be the exit string pointer 

        nextreg MMU0_0000_NR_50, $ff        ; return rom banks 
        nextreg MMU1_2000_NR_51, $ff 

        jr      _GetArray__leave

    garray_str_position:
        dw      0000 
    garray_str_pointer:
        dw      0000 

    end asm 

end sub 

sub PutArray(memory_pointer as uinteger,array_string as string,string_position as uinteger)     ' pointer to array data, string, position, 0 start, -1 end, n insert setposition

    asm 
        ; BREAK 
        ; on entry 
        ; ix+4/5)   = memory pointer 
        ; 6/7       = array string 
        ; 8/9       = string position 

        ld      l, (ix+6)                   ; get string in memory, 2 bytes = length 
        ld      h, (ix+7)
        ld      (array_str_length), hl      ; store string length to array_str_length
        
        ld      l, (ix+4)                   ; get array pointer address  
        ld      h, (ix+5)
        
        ; now we get the bank from the pointer array 

        ld      a, (hl)                     ; get desired bank 
        nextreg MMU0_0000_NR_50, a          ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a          ; set next bank 
        ld      (array_patch_bank+1), a 


        ; BREAK 
        ; ld      hl, (array_str_last_position)  ; read the first array : start at 0 
        ld      hl, 0 
    find_array_next_free_element:

        ; HEADER  equ     5                   ; 5 byte header on each array for general use 

        add     hl, 5                       ; add HEADER bytes to 

        ld      e, (hl)                     ; get first string size 
        inc     hl 
        ld      d, (hl)                     ; de = now element string size 
        inc     hl 

        ; is it 0?
        ld      a, d 
        or      e         
        jr      z, empty_array_position     ; then jump to add the entry 

        ; its not free 
        add     hl, de                      ; add hl to de 

        ; check we are not > $4000 
        ld      a, h                        ; check a > $40 
        cp      $40     
        jr      z, max_position_reached     ; no more space 

        ;       if we're > $2000 remap banks 
        cp      $20 
        jr      nz, skip_remapping 

    array_patch_bank:
        ld      a, 0 
        nextreg MMU0_0000_NR_50, a 
        inc     a 
        nextreg MMU1_2000_NR_51, a 
        ld      (array_patch_bank+1), a     ; store last bank 
        ld      h, 0 

    skip_remapping:
        ; now loop to 
        jr      find_array_next_free_element    

    empty_array_position:

        ; hl = next free element + 2 

         
        dec     hl 
        dec     hl 
        
        ; push    hl 
        ; add     hl,-5
        ; ld      (array_str_last_position), hl   ; store last position 
        ; pop     hl 

        ; now we can copy the element 
        ex      de, hl  
        ld      hl, (array_str_length)          ; point de to string 
        ld      a, (hl)                         ; get the size into bc
        ld      c, a                            
        ld      (de), a                         ; save it in de - max size so far is 255
        inc     de                              ; move two bytes along 
        inc     hl 
        ld      a, (hl)                             
        ld      b, a                            ; bc now is length of string 
        ld      (de), a 

        ld      b, (hl)
        inc     de 
        inc     hl 
        ldir                                    ; copy the string into the array 
        
         
        

    max_position_reached:

        nextreg MMU0_0000_NR_50, $ff            ; restore banks
        nextreg MMU1_2000_NR_51, $ff 

    end asm 

    Return 

    asm 
        ; not all are used 
        array_str_length:
            dw      0000
        array_str_last_position:
            dw      0000        
        array_str_position:
            dw      0000 
        arra_str_size:
            dw      0000 
        array_str_pointer:
            dw      0000 

    end asm 

end sub 

sub fastcall ClearArray(array_as as uinteger)

    asm 
         
        ld      a, (hl)
        nextreg MMU0_0000_NR_50, a 
        inc     a 
        nextreg MMU1_2000_NR_51, a 

        ld      hl, 0 
        ld      (hl), 0 
        ld      de, 1 
        ld      bc, $4000 
        ldir 

        nextreg MMU0_0000_NR_50, $ff 
        nextreg MMU1_2000_NR_51, $ff 
    end asm 

end sub 

Array1:
    asm 
        ; this is array number 1
        asm_array:
        ; start bank, map address 
        db      $24
        dw      $0000

    end asm 
