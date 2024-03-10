
' stringarray

'!org=32768
'!copy=h:/testnex/testarray.nex

' @Array memory space of array 
' array position can be 16bit
#include <nextlib.bas>

dim ArrayStr       as string = ""

asm 
    nextreg     TURBO_CONTROL_NR_07, %11 
    di 
end asm 

ClearArray(@Array1)

For x = 0 to 350 

    PutArray(@Array1,str(x)+" this is a very big string",0)     ' pointer to array data, string, position, 0 start, -1 end, n insert setposition

next x 


do 
    tr = 1 + int (rnd*300)
    print tr  
    GetArray(@Array1, tr)
    print ArrayStr$

    ' WaitKey()

loop 

'PutArray(@Array1,"put my pants",0)

'PutArray(@Array1,"partypooer",0)

GetArray(@Array1,0) ' pointer, position 0 start insert, -1 next position on end, n absolute position

'DeleteArray(@Array1,0) ' pointer, position 0 start insert, -1 next position on end, n absolute position

'SearchArray(@Array1,"text",var as uinteger) ' array, text to find, byte to return position -1 if not found

sub fastcall PeekString2(address as uinteger,byref outstring as string)
    asm  
         
        ex      de, hl 
        pop     hl 
        ex      (sp), hl
        jp      .core.__STORE_STR 
    end asm 
end sub

sub GetArray(memory_pointer as uinteger,string_position as uinteger)

    asm 
        ; BREAK 
        ; on entry 
        ; (ix+4/5)= memory pointer 
        ; 6/7 = string position 


        ; ld      l, (ix+6)                   ; get offset 
        ; ld      h, (ix+7)
        ; ld      (garray_str_position), hl    ; store 
        ld      c, (ix+6)                   ; element offset 
        ld      b, (ix+7)

       ; ld      l, (ix+4)                   ; get array pointer address  
       ; ld      h, (ix+5)
       ; ld      (garray_str_pointer), hl     ; store 
        

        ; ld      hl, (garray_str_pointer)     ; get pointer data 
        ld      a, (hl)                      ; get desired bank 
        nextreg MMU0_0000_NR_50, a           ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a           ; set next bank 
        ; ld      (array_patch_bank+1), a 

        ld      hl, 0                        ; start at 0     

        ;   already set above
        ; ld      bc, (garray_str_position)     ; number to count

    find_array_element:

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

        ld      de, ._ArrayStr
        ex      de, hl 
        call    .core.__STORE_STR 

    gempty_array_position: 


        ; hl should be the exit string pointer 

        nextreg MMU0_0000_NR_50, $ff 
        nextreg MMU1_2000_NR_51, $ff 

        jp      _GetArray__leave

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
        ; (ix+4/5)= memory pointer 
        ; 6/7 = array string 
        ; 8/9 = string position 

        ld      l, (ix+6)                   ; get string in memory, 2 bytes = length 
        ld      h, (ix+7)
        ld      (array_str_length), hl      ; store 
        
        ld      l, (ix+4)                   ; get array pointer address  
        ld      h, (ix+5)
;        ld      (array_str_pointer), hl     ; store 



        ; ld      l, (ix+6)                   ; get offset 
        ; ld      h, (ix+7)
        ; ld      (array_str_position), hl    ; store 
        
        ; now we want to put our string    

 ;       ld      hl, (array_str_pointer)     ; get pointer data 
        ld      a, (hl)                     ; get desired bank 
        nextreg MMU0_0000_NR_50, a          ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a          ; set next bank 
        ld      (array_patch_bank+1), a 

        ld      hl, 0                       ; start at 0 

    find_array_next_free_element:

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
        ; BREAK 
        nextreg MMU0_0000_NR_50, a 
        inc     a 
        nextreg MMU1_2000_NR_51, a 
        ld      (array_patch_bank+1), a 
        ld      h, 0 

    skip_remapping:
        ; now loop to 
        jr      find_array_next_free_element    

    empty_array_position:

        ; hl = next free element + 2 
        dec     hl 
        dec     hl 
        ; now we can copy the array 
        ex      de, hl  
        ld      hl, (array_str_length)     ; point de to string 
        ld      a, (hl)                     ; get the size into bc
        ld      c, a 
        ld      (de), a 
        inc     de 
        inc     hl 
        ld      a, (hl)
        ld      b, a 
        ld      (de), a 


        ; inc     hl
        ld      b, (hl)
        inc     de 
        inc     hl 
        ; ex      de, hl                      ; now swap hl,de and copy 
        ldir    
        
    max_position_reached:

        nextreg MMU0_0000_NR_50, $ff 
        nextreg MMU1_2000_NR_51, $ff 


    end asm 

    Return 

    asm 
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
        asm_array:
        ; start bank, map address 
        db      $24
        dw      $0000

    end asm 
