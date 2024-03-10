
' nextbuild string arrays using banks em00k july 2022/updated 2024
'!org=32768


' @Array memory space of array (set at end of source)
' array position is 16bit
'
' Array1 is defined at the end of the source code. 
' This contains the banks to use and memory address to use
' There are 256 array slots of 251 chars in length 
' 8 * 8192kb banks are used so if the base bank is 24, 24-36 would
' be assign to @Array1 - multiple arrays can be set up using different banks
' when getting the array string "ArrayStr" will be set with result. 

' PutElement(array pointer to use, string to store, position ) - store element
' GetArrar(array pointer, position) - result will be in ArrayStr$
' ClearArry(array pointer) - Clears an array bank block - note you must clear before use!


#include <nextlib.bas>

dim ArrayStr       as string = "EMPTY"           ' used in GetArray so must be defined 

asm 
     nextreg     TURBO_CONTROL_NR_07, %11    ; 28mhz 
     di 
end asm 

ClearArray(@Array1)                         ' ensure Array1 is cleared 

' ' some test elements 

For x = 0 to 250
    
    PutElement(@Array1,str(x)+" this is a very big string that we are storing in RAM - thank you good night xxx ",x)    

next x 

' delete every even entry 
for x = 0 to 250 step 2
    DeleteElement(@Array1,x)
next 

' every fourth entry 
For x = 0 to 250 step 4
    
    PutElement(@Array1," PATCHED "+str(x),x)     ' pointer to array data, string, position, 0 start, -1 end, n insert setposition

next x 

dim tr as uinteger

do 
   
    tr = tr + 1 band 255 'int (rnd*250)
    print tr;" element to get:"
    GetElement(@Array1, cast(ubyte,tr))
    if ArrayStr = "" 
        print " - empty"
    else 
        print ArrayStr
    endif 
    WaitKey()
loop 


' These are not written yet 
' SearchArray(@Array1,"text",var as uinteger) ' array, text to find, byte to return position -1 if not found


sub GetElement(memory_pointer as uinteger,string_position as ubyte)
    ' expects a pointer to the Array to use and position to get the element
    ' this routine will set ArrayStr$ to the element string on exit 
    ' 
    asm 
         
        ; on entry 
        ; (ix+4/5)= memory pointer 
        ; 6/7 = string position 
         
        ld      l, (ix+4)                   ; array memory address of array
        ld      h, (ix+5)
        BREAK 
        ld      h, (hl)                      ; get desired start bank eg 24 

        ld      a, (ix+7)                   ; get element number 
        swapnib                             ; 0000xxxx > xxxx0000
        and     %0001111                    ; xxxx0000
        srl     a 
        srl     a
        add     a, a 
        add     a, h                        ; add to start bank eg 24 + 

        nextreg MMU0_0000_NR_50, a           ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a           ; set next bank 
        
        ld      a,(ix+7)                    ; get element again 
        and     63                          ; ensure it wraps around 
        ld      h, a                        ; our banks 
        ld      l, 0                        ; start 

        
        ld      a, (hl)                     ; is it enable?
        or      a 
        jp      nz,garray_not_null           ; not enable exit - maybe send empty string
        ld      hl, garry_empty_arraystr
        jp      gempty_array_position

garray_not_null:
        inc     hl                          ; skip over enable byte 
        inc     hl                          ; skip over var bytes
        inc     hl                          ; skip over var bytes

        ; hl = source string 

    gempty_array_position: 

        ld      de, ._ArrayStr              ; point to ArrayStr$ pointer
        ex      de, hl                      ; swap 
        call    .core.__STORE_STR           ; store in ArrayStr$
        ; hl should be the exit string pointer 

        nextreg MMU0_0000_NR_50, $ff        ; return rom banks 
        nextreg MMU1_2000_NR_51, $ff 

        jr      _GetElement__leave

    garry_empty_arraystr:
        db      0, 0,"",0

    garray_str_position:
        dw      0000 
    garray_str_pointer:
        dw      0000 

    end asm 

end sub 

sub PutElement(memory_pointer as uinteger,array_string as string,string_position as uinteger) 

    asm 
         
        ; on entry 
        ; ix+4/5)   = memory pointer 
        ; 6/7       = array string 
        ; 8/9       = string position 
        ; h         = element 
     
        ld      l, (ix+6)                   ; get string in memory, 2 bytes = length 
        ld      h, (ix+7)
        ld      e, (ix+4)                   ; fetch the pointer for the array config 
        ld      d, (ix+5)
        ld      c, (ix+8)                    ; get element offset 

        call    _put_array
        jp      ._PutElement__leave 

_put_array:
        ld      a,(hl)
        inc     hl 
        ld      h,(hl)
        ld      l, a 
        ld      (array_str_length), hl      ; store string length to array_str_length
        
        ld      a, (de)

        ld      h, a
        ; now we get the bank from the pointer array 
         
        ld      a, c 
        swapnib                             ; 0000xxxx > xxxx0000
        and     %00001111                   ; xxxx0000
        srl     a 
        srl     a 
        add     a, a                        ; x 2 because we're using 2 banks 
        add     a, h 

        nextreg MMU0_0000_NR_50, a          ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a          ; set next bank 
        
        ld      a,(ix+8)                    ; get element again 
        and     63                          ; ensure it wraps around 
        ld      h, a                        ; our banks 

        ; add the string at string_position 

        ld      l, 0                        ; start of data

        ld      (hl), 1                     ; element enable 
        inc     hl 
        inc     hl                          ; two var bytes 
        inc     hl 

        ld      bc,(array_str_length)       ; get the length of the string 
        inc     bc 
        inc     bc                          ; add 2 to include size when copying 
        ld      b, 0                        ; cap to 256 max

        ld      e, (ix+6)                   ; get array pointer address  [SIZE][STRING.....]
        ld      d, (ix+7)
        ex      de, hl                      ; exchange array with string pointers

        ldir                                ; copy string 

        nextreg MMU0_0000_NR_50,$ff
        nextreg MMU1_2000_NR_51,$ff         ; restore bank 
        ret 

    end asm 

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

sub DeleteElement(memory_pointer as uinteger,string_position as ubyte)

    asm 

    ; disables an element in an array 
    ; memory_pointer points to @Array
    ; string_position is element number 

    ld      l, (ix+4)                   ; array memory address of array
    ld      h, (ix+5)
    
    ld      h, (hl)                      ; get desired start bank eg 24 

    ld      a, (ix+7)                   ; get element number 
    swapnib                             ; 0000xxxx > xxxx0000
    and     %0001111                    ; xxxx0000
    srl     a 
    srl     a
    add     a, a 
    add     a, h                        ; add to start bank eg 24 + 

    nextreg MMU0_0000_NR_50, a           ; set bank 
    inc     a 
    nextreg MMU1_2000_NR_51, a           ; set next bank 
    
    ld      a,(ix+7)                    ; get element again 
    and     63                          ; ensure it wraps around 
    ld      h, a                        ; our banks 
    ld      l, 0                        ; start 
    
    ld      (hl), 0 

    nextreg MMU0_0000_NR_50, $ff        ; return rom banks 
    nextreg MMU1_2000_NR_51, $ff 

    end asm 

end sub 

sub fastcall ClearArray(array_as as uinteger)

    asm 
         

        ld      b, 4            ; 4 loops 
        ld      a, (hl)
.clear_arry_loop:
        push    bc 
        push    af 
        nextreg MMU0_0000_NR_50, a 
        inc     a 
        nextreg MMU1_2000_NR_51, a 
        ld      hl, 0 
        ld      (hl), 0 
        ld      de, 1 
        ld      bc, $4000 
        ldir 
        pop     af 
        inc     a 
        inc     a 
        pop     bc 
        djnz    .clear_arry_loop

        nextreg MMU0_0000_NR_50, $ff 
        nextreg MMU1_2000_NR_51, $ff 
    end asm 

end sub 

Array1:
    asm 
        ; this is array number 1
        asm_array:
        ; start bank, map address 
        db      $24     ; banks 24 + 8 * 8192kb = 65536kb
        dw      $0000

    end asm 
