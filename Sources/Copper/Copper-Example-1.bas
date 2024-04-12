'!org=24576
' NextBuild Layer2 Template 
'#!asm 
#define NEX 
#define IM2 

#include <nextlib.bas>

#define COP_MOVE(reg, value) \ 
        db  HI($0000+(( reg &$ff)<<8)+( value &$ff)) \
        db  LO($0000+(( reg &$ff)<<8)+( value &$ff)) 


#define WAIT(vpos, hpos) \
        db	HI($8000+( vpos & $1ff)+(( ( hpos /8) &$3f)<<9)) \
        db	LO($8000+( vpos & $1ff)+(( (( hpos /8) >>3) &$3f)<<9))
            
#define GETHIGH(value) \
         HI (value / 256 )

asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg SPRITE_CONTROL_NR_15,%00000011  ; %000    S L U, %11 sprites on over border
    nextreg LAYER2_CONTROL_NR_70,%00000000  ; 5-4 %01 = 320x256x8bpp
    BREAK 
;    WAIT 10, 10
    ld  hl, GETHIGH($7d00)
end asm 



asm 

    ;
    ; Copper stuff
    ;
    ; ZX Spectrum Next Framework V0.1 by Mike Dailly, 2018
    ;
    COP_NOP                 equ     0
    COP_PER_1               equ     5
    COP_PER_2               equ     6
    COP_TURBO               equ     7        
    COP_PER_3               equ     8
    COP_LAYER2_BANK         equ     18      ; layer 2 bank
    COP_LAYER2_SBANK        equ     19      ; layer 2 shadow bank
    COP_TRANSPARENT         equ     20      ; Global transparency color
    COP_SPRITE              equ     21      ; Sprite and Layers system
    COP_LAYER2_XOFF         equ     22
    COP_LAYER2_YOFF         equ     23
    COP_LAYER2_CLIP         equ     24
    COP_SPRITE_CLIP         equ     25
    COP_ULA_CLIP            equ     26
    COP_CLIP_CNT            equ     28
    COP_IRQ                 equ     34
    COP_IRQ_RAST_LO         equ     35
    COP_TILEMAP_X_MSB       equ     47
    COP_TILEMAP_X_LSB       equ     48
    COP_TILEMAP_Y_OFF       equ     49
    COP_LOWRES_XOFF         equ     50
    COP_LOWRES_YOFF         equ     51
    COP_PALETTE_INDEX       equ     64
    COP_PALETTE_COLOUR      equ     65      ; 8 bit palette colour
    COP_PALETTE_FORMAT      equ     66      
    COP_PALETTE_CONTROL     equ     67       
    COP_PALETTE_COLOUR_9    equ     68      ; 9 bit palette colour
    COP_MMU0                equ     80
    COP_MMU1                equ     81
    COP_MMU2                equ     82
    COP_MMU3                equ     83
    COP_MMU4                equ     84
    COP_MMU5                equ     85
    COP_MMU6                equ     86
    COP_MMU7                equ     87
    COP_DATA                equ     96
    COP_CONTROL_LO          equ     97
    COP_CONTROL_HI          equ     98
    COP_FALLBACK_COLOUR     equ     $4a

            
end asm 