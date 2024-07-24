'!ORG=24576
'#!copy=h:\l2320.nex
'#!asm 

#include <nextlib.bas>


function fastcall checkints() as ubyte 
asm 
    start:    
        ; Detect if interrupts were enabled 
        ; The value of IFF2 is copied to the P/V flag by LD A,I and LD A,R.
        ld a,i 
        ld a,r 
        jp po,intsdisable 
        ld a,1              ; ints on 
        ld (itbuff),a
        ret 
    intsdisable:
        xor a               ; ints off 
        ld (itbuff),a    
        ret 
    itbuff:
        db 0 
end asm 
end function

do 

    asm 
        call _checkints
        di 
        ; do stuff 
        ld a,(itbuff) : or a : jr z,$+3 : ei 
    end asm 

    ints = checkints()
    
    if ints = 1 
            print at 0,0;"   ints on  "
        else 
            print at 0,0;"ints off    "
    endif 

    'WaitRetrace(100)

    count = count + 1 

    if inkey="1"
        asm : ei : end asm 
        BBREAK 
    elseif inkey="0"
        asm : di : end asm 
        BBREAK 
    endif 

  ''  next 
    
loop 

asm 
intbugger:
    db 0
end asm 