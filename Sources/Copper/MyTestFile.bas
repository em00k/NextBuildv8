'!org=24576
'

#define NEX 
#define IM2 

#include <nextlib.bas>

asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg SPRITE_CONTROL_NR_15,%00000011  ; %000    S L U, %11 sprites on over border
    nextreg LAYER2_CONTROL_NR_70,%00000000  ; 5-4 %01 = 320x256x8bpp
end asm 

LoadSDBank("ts4000.bin",0,0,0,24)
LoadSDBank("tesko.pt3",0,0,0,25)

asm 

    di
    nextreg $50, 25 
    nextreg $51, 26
    nextreg $52, 24

    ld      hl, 0 
    ld      de, 3815
    ; ld      de, 0 
    ld      a, %0001_0000       ; works!
    ld      ($400A), a 
    call    $4003 

    lp:
        call    $4005
        ld      a, 192 
        call    ._WaitRetrace2
    jp lp 

    
end asm 

WaitRetrace2(192)
