#include <nextlib.bas>

asm
    BREAK 
    ld  hl,$1234
    ld (loop+1),hl 
    ld  de,299

loop:
    ld hl,000
    sbc hl,de 
    ; if de > hl carry is set, else nc = true 
    jr nc,playing 
    ld de,5
    jr loop 

    playing:
    inc de 
    jp loop 

end asm