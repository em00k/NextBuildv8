'!ORG=24576
'#!copy=h:\l2320.nex
'!asm 

#include <nextlib.bas>


function fastcall checkints() as ubyte 
asm 

start:    
   ; BREAK 
    ; The value of IFF2 is copied to the P/V flag by LD A,I and LD A,R.
    ld a,i 
    ld b,a 
    ld a,r 

    jp po,intsenable 
    ld a,1 
    ld (itbuff),a
    ret 
intsenable:
    xor a 
    ld (itbuff),a    
    ret 
itbuff:
    db 0 
end asm 
end function

do 

    asm 
        ld a,(itbuff)
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
    elseif inkey="0"
        asm : di : end asm 
    endif 

  ''  next 
    
loop 

asm 
intbugger:
    db 0
end asm 