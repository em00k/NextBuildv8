'!org=32768
'!copy=h:\decode.nex
' NextBuild Layer2 Template 

#define NEX 
#define IM2 

#include <nextlib.bas>
#include "GetInTileMap-inc.bas"
#include <keys.bas>

asm 
    TILE_GFXBASE 		equ 	$40 
    TILE_MAPBASE 		equ 	$44
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,0    ; black 
    nextreg SPRITE_TRANSPARENCY_I_NR_4B,0    ; black 
    nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,$0    ; black 
    nextreg SPRITE_CONTROL_NR_15,%00000011  ; %000    S L U, %11 sprites on over border
    nextreg LAYER2_CONTROL_NR_70,%00000000  ; 5-4 %01 = 320x256x8bpp

    nextreg CLIP_TILEMAP_NR_1B,0                        ; Tilemap clipping 
    nextreg CLIP_TILEMAP_NR_1B,159
    nextreg CLIP_TILEMAP_NR_1B,0
    nextreg CLIP_TILEMAP_NR_1B,255

    nextreg TILEMAP_YOFFSET_NR_31,-32
    nextreg TILEMAP_XOFFSET_LSB_NR_30,0
    nextreg TILEMAP_XOFFSET_MSB_NR_2F,0
    nextreg CLIP_ULA_LORES_NR_1A,0                        ; Tilemap clipping 
    nextreg CLIP_ULA_LORES_NR_1A,0
    nextreg CLIP_ULA_LORES_NR_1A,0
    nextreg CLIP_ULA_LORES_NR_1A,0

    NextReg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000        ; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_CONTROL_NR_6B,%10001001				; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_BASE_ADR_NR_6E,$44				    ; tilemap data $6000
    NextReg TILEMAP_GFX_ADR_NR_6F,$40				    ; tilemap blocks 4 bit tiles $4000
    NextReg PALETTE_CONTROL_NR_43,%00110000
end asm 

paper 0 : ink 7 : border 0 : cls 
LoadSDBank("complica.mod",0,0,1084,32)                     ' load mod pattern data 

LoadSDBank("ATASCII.spr",0,0,0,12)							' 1 bit font to bank 20
LoadSDBank("topan.fnt",0,0,0,13)							' 1 bit font to bank 20
LoadSDBank("font2.pal",1024,0,0,12)								' palette to bank 20 + $0200

LoadSDBank("finetune.dat",0,0,0,24)
LoadSDBank("cursor.spr",0,0,0,14)
InitSprites2(1,0,14)

UpdateSprite(0,95,0,0,0,%11000)
UpdateSprite(128,95,1,0,0,%11000)
UpdateSprite(256,95,2,0,0,%11000)

NextReg($50,12)													' page bank 20 to $e000, slot 7 
PalUpload($0400,64,0)											' upload the palette 
CopyToBanks(12,10,1,1024)										' copy bank 20 > 2 with 1 bank of length 1024 bytes 
NextReg($50,$ff)
ClearTilemap() 

Dim row,trow    as ubyte
Dim keydown     as ubyte 

' first row 

for x = 0 to 7 
    copyup()
    sety(15)
    Show_Row(x,0)
next 

do 
    k = GetKeyScanCode()
    if keydown = 0 and k = KEYA 'or t = 5 
    asm 
     ;   nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,3
    end asm 
        row     = row + 1 band 63
        trow    = row + 7
        if row = 0 
            copyup()
            for x = 0 to 7 
                copyup()
                sety(15)
                Show_Row(x,0)
            next 
            
        else 
            sety(15)
            copyup()
            Show_Row(trow,0)
        endif 

        asm 
       ;     nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0
        end asm 

        keydown = 1 
        t = 0 
    elseif keydown = 0 and k = KEYQ 

        copydown()
        row     = row - 1 band 63 
        trow    = row - 7
        sety(0)
        Show_Row(trow,0)
        keydown = 1 
        t = 0 
    elseif keydown = 0 and k = KEYSPACE 
        
        changeFont()
        keydown = 1 

    elseif keydown = 1 'and k = 0 

        WaitRetrace(20)
        keydown = 0 

    endif 
WaitRetrace(20)
    WaitRetrace2(1)
    t = t + 1 

loop 

sub fastcall changeFont()
    asm  
        ld      a, (fontnumber)
        add     a, 1 
        and     1 
        ld      (fontnumber), a 
        jr      z, font1 
        nextreg $57,13      
        jr      font2 
    font1: 
        nextreg $57,12
    font2: 
        ld      hl, $e000 
        ld      de, $4000 
        ld      bc, 768 
        call    dmaCopyCore
        ret 
    fontnumber: 
        db      0 
    end asm 
end sub 

sub fastcall copyup()
    asm 
        ld      hl, $4400+80
        ld      de, $4400 
        ld      bc, 17*80
        call    dmaCopyCore 
    end asm 
end sub 

sub fastcall copydown()
    asm 
        ld      hl, $4400 + 14*80
        ld      de, $4400 + 15*80
        ld  bc, 14*82
        call    dmaCopyCoreUP 
    end asm 
end sub 

sub fastcall sety(row as ubyte)
    asm 
        
        ; a = new row 
        def_cur_y       EQU     cur_y
        ld      (def_cur_y),a 

    end asm 
end sub 


sub Show_Row(row as ubyte, pattern as ubyte)
    asm 

        push    ix 
    
        call    draw_row
     
        pop     ix 
        jp      _Show_Row__leave 


    draw_row:
        ;       a is the row 
        ld      d, a 
        ld      ixl, a  ; save row 
        ; call    printhex 
        call getPatternRow
        
        ; Iterate through rows (64 rows in each pattern)

        RowLoop:        ; we dont loop only draw 1 row 
             
            ; Call the decoding subroutine
    
            ld      a,ixl           ; get row 
            inc     ix              ; inc rom 
            cp      64              ; does it cp 
            jp      nc, printblank 
            ld      b, 0            
            call    printhex        ; prints the row number 

            ; chan 1 

            ld      a, (cur_x)
            inc     a 
            ld      (cur_x), a

            push    hl              ; save position in pattern 

            call    DecodePatternData

            ; ld      b, a
            call    printhl         ; print note
            
            ; ld      hl,cur_x : inc     (hl)
            
            ld      b, 6
            ld      a, e
            call    printhex            ; print sample 
            
            ; ld      hl,cur_x : inc     (hl)
             
            ld      a, c 
            ; or      a 
          ;  jr      nz,coloureffect
          ;  ld      b, 0
          ;  jr      $+2
    coloureffect:
            ld      b, $0c 
            call    printhex2           ; print effect 

            ld      a, d 
            call    printhex            ; effect param 
            
            ld      hl,cur_x : inc     (hl) 

            pop     hl
               
            ; Update the offset
            
            add hl, 4

        ; chan 2 

            push    bc 
            push    hl      ; save position in pattern 
            call    DecodePatternData

            ; ld      b, 4 
            call    printhl             ; pring note
            ; ld      hl,cur_x : inc     (hl)

            ld      b, $a
            ld      a, e
            call    printhex    ; print sample 
            
           ; ld      hl,cur_x : inc     (hl)

            ld      b, 6 
            ld      a, c 
            call    printhex2    ; print effect 


            ld      a, d 
            call    printhex    ; effect param 

            ld      hl,cur_x : inc     (hl) 

            pop     hl
            pop     bc
            
            ; Update the offset

            add     hl,4 

        ; chan 3 
            
            push    hl      ; save position in pattern 
            call    DecodePatternData

            ; ld      b, 4 
            call    printhl             ; pring note

            ; ld      hl,cur_x : inc     (hl)

            ld      b, $a 
            ld      a, e
            call    printhex    ; print sample 

            ; ld      hl,cur_x : inc     (hl)

            ld      b, 6
            ld      a, c 
            call    printhex2    ; print effect 


            ld      a, d 
            call    printhex    ; effect param 

            ld      hl,cur_x : inc     (hl)

            pop     hl
            
            ; Update the offset
            
            add hl, 4

        ; chan 4 
            
            push    hl      ; save position in pattern 
            call    DecodePatternData

            ; ld      b, 4 
            call    printhl             ; pring note

            ; ld      hl,cur_x : inc     (hl)

            ld      b, $a
            ld      a, e
            call    printhex    ; print sample 

            ; ld      hl,cur_x : inc     (hl)

            ld      b, 6
            ld      a, c 
            call    printhex2    ; print effect 

            
            ld      a, d 
            call    printhex    ; effect param 
            
            ld      hl,cur_x : inc     (hl)

            ld      a, 1
            ld      (cur_x), a 

            pop     hl
            
            ; Update the offset
            
            add hl, 4

            ld      a, (cur_y)
            inc     a 
            ld      (cur_y), a

        back:

            ; Decrement row counter
            ; dec c
            ; jp nz, RowLoop
            
        ; Decrement pattern counter
        ; dec b no used 

        ret

getPatternRow:
        ld      hl, $4000      ; 10
        ld      e, 16 			; 7 
        mul     d, e 			; 8
        add     hl, de          ; 11   36 ; address of row 
        ret 

printblank: 

        ; use the dma to wipe the line 
        ld      hl,$4400 + 15*80
        ld      d, h 
        ld      e, l 
        inc     de 
        ld      (hl), 0
        ld      bc, 79
        ldir    
        ret 

; over version 
;      ; ld      d, c 
;       ld      bc , 64
;       ld      a, 0 
;       ld      (cur_x), a
;   wipeloop:
;       push    bc
;       ld      b, 0 
;       ld      a, 32 ; space
;       call    print_tilemap
;
;       pop     bc 
;       djnz    wipeloop
;      ; ld      c, d 
;
;       ret 

    DecodePatternData:
        nextreg $52,32
        ; Load bytes a, b, c, d from memory at address HL
        ; reads on track row of data     
        ld      e, (hl)       ; a.a = PeekA(temp) 
        inc     hl
        ld      b, (hl)       ; b.a = PeekA(temp+1) 
        inc     hl
        ld      c, (hl)       ; c.a = PeekA(temp+2)
        inc     hl
        ld      d, (hl)       ; d.a = PeekA(temp+3)
        
        ; Get 8-bit sample number
        ld      a, e            ; get a.a from e 
        add     a, c            ; samp = a + c >> 4
        swapnib                 ; Shift right by 4 bits
        and     $1f             ; mask 31  
        push    af              ; push on stack for later 
        
        ; Calculate 12-bit period
        ld      a, e            ; get back a.a from e 
        and     $0F             ; a & %00001111
        ld      h, a            ; Move result to H
        ld      l, b            ; Move B to L
                                ; period = (a & %00001111) * 256 + b
        
        ; Now get the effect - b / a free 
        ld      a, c             ; store a & %00001111 in c 
        and     $f 
        ld      c,a 

        pop     af              ; bring back sample into e 
        ld      e, a 

        ; At this point:
        ; B = b
        ; C = effect
        ; D = effect param 
        ; E = samp
        ; HL = 12-bit period

        call    period_to_string

        ; hl now points to note string 
        
        nextreg $52,10

        ret

    printhex2: 
        ; uses de, c, a 
        push    bc 
        push    de 
        ld      c, a 
        call    Num2
        call    print_tilemap
        pop     de
        pop     bc 
        ret     ; return with hex number in de

    printhex: 
        ; uses de, c, a 
        push    bc 
        push    de 
        ld      c, a        ; get char 
        call    Num1
        call    print_tilemap
        ld      a, c
        call    Num2
        call    print_tilemap
        pop     de
        pop     bc 
        ret     ; return with hex number in de

    Num1:        

        rra
        rra
        rra
        rra
        
    Num2:

        or      $F0
        daa
        add     a, $A0
        adc     a, $40      ; Ascii hex at this point (0 to F)   
        ret

    printhl:

        ld      a, (hl)
        or      a 
        ret     z 
        call    print_tilemap
        inc     hl 
        jr      printhl


    print_tilemap: 
        ;       in bc a = char, b = colour 
        ; uses hl, a, de, bc 
        
        push    bc : push de : push hl
        ld      c, a 
        ld 		hl,.TILE_MAPBASE*256            ; a is the char to print, save in b
        ld 	    a,(cur_x)                       ; get x co-ord 
        add     a, a                            ; double it 
        add		hl,a							; add x * 2 because map is (char,attrib) x 80 

        ld      de,(cur_y)                       ; get ypos  
        ld 		d,80                            ; 160 chars per line * y 
        mul 	d,e		                        ; mul 160 because map is 2 x 80 
        add 	hl,de                           ; add to hl 
        ld 		(hl),c                          ; put char into hl 
        inc     hl                              ; move to attrib byte 
        ld      a,b                            ; 
        and 	%01111111
        rlca    ;   : and %11111110
        ld 		(hl),a
        ld      hl,cur_x : inc     (hl)

        pop     hl : pop de : pop bc 
        ret 

        cur_x:      db 1 
        cur_y:      db 0

    BANK8K_FINETUNE   equ     24

    period_to_string: 

        nextreg	$50,BANK8K_FINETUNE ; $4000
        
        ; set	6,h		; Period + 16384 (MM2)
         
        ld	    a,(hl)
        ld	    hl,note_tab
        add	    a,a		; Pre-multiplied by 2
        add	    hl,a

        rrca 
        cp      72
        jr      nz, normalcolour 
        ld      b, 8
        jr      darkcolour
    normalcolour:
        ld      b, 2
    darkcolour:
        nextreg	$50,$ff 
        ret


    ; --------------------------------------------------------------------------
    ; --------------------------------------------------------------------------
    ; --------------------------------------------------------------------------


    ; Note strings using 4K lookup table (See period_to_note_tab)


    ;                C   C#  D   D#  E   F   F#  G   G#  A   A#  B
    ;     Octave 1: 856,808,762,720,678,640,604,570,538,508,480,453
    ;     Octave 2: 428,404,381,360,339,320,302,285,269,254,240,226
    ;     Octave 3: 214,202,190,180,170,160,151,143,135,127,120,113


    ;		NOTE     INDEX  AMIGA HZ
    ;		----------------------------
    note_tab:
        db	"C-1"
        db 0  ; 00 - 04181.71 C-1
        db	"C#1"
        db 0  ; 02 - 04430.12 C#1
        db	"D-1"
        db 0  ; 04 - 04697.56 D-1
        db	"D#1"
        db 0  ; 06 - 04971.59 D#1
        db	"E-1"
        db 0  ; 08 - 05279.56 E-1
        db	"F-1"
        db 0  ; 10 - 05593.03 F-1
        db	"F#1"
        db 0  ; 12 - 05926.39 F#1
        db	"G-1"
        db 0  ; 14 - 06279.90 G-1
        db	"G#1"
        db 0  ; 16 - 06690.73 G#1
        db	"A-1"
        db 0  ; 18 - 07046.34 A-1
        db	"A#1"
        db 0  ; 20 - 07457.38 A#1
        db	"B-1"
        db 0  ; 22 - 07901.86 B-1
        db	"C-2"
        db 0  ; 24 - 08363.42 C-2
        db	"C#2"
        db 0  ; 26 - 08860.25 C#2
        db	"D-2"
        db 0  ; 28 - 09395.13 D-2
        db	"D#2"
        db 0  ; 30 - 09943.18 D#2
        db	"E-2"
        db 0  ; 32 - 10559.12 E-2
        db	"F-2"
        db 0  ; 34 - 11186.07 F-2
        db	"F#2"
        db 0  ; 36 - 11852.79 F#2
        db	"G-2"
        db 0  ; 38 - 12559.80 G-2
        db	"G#2"
        db 0  ; 40 - 13306.85 G#2
        db	"A-2"
        db 0  ; 42 - 14092.69 A-2
        db	"A#2"
        db 0  ; 44 - 14914.77 A#2
        db	"B-2"
        db 0  ; 46 - 15838.69 B-2
        db	"C-3"
        db 0  ; 48 - 16726.84 C-3
        db	"C#3"
        db 0  ; 50 - 17720.51 C#3
        db	"D-3"
        db 0  ; 52 - 18839.71 D-3
        db	"D#3"
        db 0  ; 54 - 19886.36 D#3
        db	"E-3"
        db 0  ; 56 - 21056.14 E-3
        db	"F-3"
        db 0  ; 58 - 22372.15 F-3
        db	"F#3"
        db 0  ; 60 - 23705.59 F#3
        db	"G-3"
        db 0  ; 62 - 25031.78 G-3
        db	"G#3"
        db 0  ; 64 - 26515.14 G#3
        db	"A-3"
        db 0  ; 66 - 28185.39 A-3
        db	"A#3"
        db 0  ; 68 - 29829.54 A#3
        db	"B-3"
        db 0  ; 70 - 31677.38 B-3
        db	"---"
        db 0  ; 72 - -----.-- ---

    inkred:

        ret 

    end asm 
end sub 

sub fastcall dmaCopy(source as uinteger, dest as uinteger, length as uinteger)

    asm 

        pop     ix          ; save ret 
        pop     hl 
        pop     de 
        pop     bc 
        Z80DMAPORT EQU 107
dmaCopyCore:
        ld      (DMASource),hl
        ld      (DMADest),de
        ld      (DMALength),bc
        ld      hl,DMACode
        ld      b,DMACode_Len
        ld      c,Z80DMAPORT
        otir
    
        ret 

DMACode:
        db $83                        ; disable DMA 

        db %01111101                  ; R0-Transfer mode, A -> B, write adress 
                                      ; + block length
DMASource: 
        dw 0                          ; R0-Port A, Start address 
                                      ; (source address)
DMALength:
        dw 0                          ; R0-Block length (length in bytes)
        db %01010100                  ; R1-write A time byte, increment, to 
                                      ; memory, bitmask
        db %00000010                  ; 2t
        db %01010000                  ; R2-write B time byte, increment, to 
                                      ; memory, bitmask
        db %00000010                  ; R2-Cycle length port B
        db %10101101                  ; R4-Continuous mode (use this for block 
                                      ; transfer), write dest adress
DMADest:
        dw 0                          ; R4-Dest address (destination address)
        db %10000010                  ; R5-Restart on end of block, RDY active 
                                      ; LOW
        db $cf                        ; R6-Load
        db $87                        ; R6-Enable DMA
        
    DMACode_Len                    equ $-DMACode


    dmaCopyCoreUP:
    ld      (DMASourceUP),hl
    ld      (DMADestUP),de
    ld      (DMALengthUP),bc
    ld      hl,DMACodeUP
    ld      b,DMACode_LenUP
    ld      c,Z80DMAPORT
    otir

    ret 


DMACodeUP:
    db $83                        ; disable DMA 

    db %01111101                  ; R0-Transfer mode, A -> B, write adress 
                                  ; + block length
DMASourceUP: 
    dw 0                          ; R0-Port A, Start address 
                                  ; (source address)
DMALengthUP:
    dw 0                          ; R0-Block length (length in bytes)
    db %01000100                  ; R1-write A time byte, increment, to 
                                  ; memory, bitmask
    db %00000010                  ; 2t
    db %01000000                  ; R2-write B time byte, increment, to 
                                  ; memory, bitmask
    db %00000010                  ; R2-Cycle length port B
    db %10101101                  ; R4-Continuous mode (use this for block 
                                  ; transfer), write dest adress
DMADestUP:
    dw 0                          ; R4-Dest address (destination address)
    db %10000010                  ; R5-Restart on end of block, RDY active 
                                  ; LOW
    db $cf                        ; R6-Load
    db $87                        ; R6-Enable DMA
    
DMACode_LenUP                    equ $-DMACodeUP
    end asm 

end sub 

do : loop 

dmaCopy(0,0,0)

asm 
    pattern0:
  ;  incbin "./data/finetune2.dat"
end asm 