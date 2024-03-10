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

LoadSDBank("ATASCII.spr",0,0,0,12)							' 1 bit font to bank 20
'LoadSDBank("topan.fnt",0,0,0,12)							' 1 bit font to bank 20
LoadSDBank("mm.pal",1024,0,0,12)								' palette to bank 20 + $0200

LoadSDBank("finetune.dat",0,0,0,24)

NextReg($50,12)													' page bank 20 to $e000, slot 7 
PalUpload($0400,64,0)											' upload the palette 
CopyToBanks(12,10,1,1024)										' copy bank 20 > 2 with 1 bank of length 1024 bytes 
NextReg($50,$ff)
ClearTilemap() 

Dim row,trow as ubyte
Dim keydown as ubyte 


Show_Row(-7,0)

do 
    k = GetKeyScanCode()
    if keydown = 0 and k = KEYA 

        row = row + 1 band 63 
        trow = row - 7
        sety(0)
        asm 
        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,3
        end asm 
        Show_Row(trow,0)
        asm 
        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0
        end asm 
        keydown = 1 

    elseif keydown = 0 and k = KEYQ 

        row = row - 1 band 63 
        trow = row - 7
        sety(0)
        Show_Row(trow,0)
        keydown = 1 
    elseif keydown = 1

       ' WaitRetrace(20)
        keydown = 0 

    endif 

    WaitRetrace2(1)
    

loop 

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
        
        
        ; Iterate through patterns (64 patterns)
        ; ld b, 1
        PatternLoop:    ; not used 
        
        ; Iterate through rows (64 rows in each pattern)
        ld c, 15

        RowLoop:
             
            ; Call the decoding subroutine
             
            ld      a,ixl           ; get row 
            inc     ix              ; inc rom 
            cp      64              ; does it cp 
            jp      nc, printblank 
            ld      b, 8

		; chan 1 
             
            push    bc 
            push    hl      ; save position in pattern 

            call    DecodePatternData

            ld      b, 0 
            call    printhl             ; pring note
            
            ; ld      hl,cur_x : inc     (hl)
            
            ld      b, e 
            ld      a, e
            call    printhex    ; print sample 
            
            ; ld      hl,cur_x : inc     (hl)

            ld      b, 1
            ld      a, c 
            call    printhex2    ; print effect 

            ld      a, d 
            call    printhex    ; effect param 
            
            ld      hl,cur_x : inc     (hl) 

            pop     hl
            ; pop     bc
            
            ; Update the offset
            
            add hl, 4

		; chan 2 

            ; push    bc 
            push    hl      ; save position in pattern 
            call    DecodePatternData

            ld      b, 0 
            call    printhl             ; pring note
            ; ld      hl,cur_x : inc     (hl)

            ld      b, 2 
            ld      a, e
            call    printhex    ; print sample 
            
            ; ld      hl,cur_x : inc     (hl)

            ld      b, 1 
            ld      a, c 
            call    printhex2    ; print effect 


            ld      a, d 
            call    printhex    ; effect param 

            ld      hl,cur_x  :inc     (hl)

            pop     hl
            ; pop     bc
            
            ; Update the offset

            add     hl,4 

		; chan 3 
            
            ; push    bc 
            push    hl      ; save position in pattern 
            call    DecodePatternData

            ld      b, 0 
            call    printhl             ; pring note

           ; ld      hl,cur_x : inc     (hl)

            ld      b, 2 
            ld      a, e
            call    printhex    ; print sample 

           ; ld      hl,cur_x : inc     (hl)

            ld      b, 1 
            ld      a, c 
            call    printhex2    ; print effect 


            ld      a, d 
            call    printhex    ; effect param 

            ld      hl,cur_x  :inc     (hl)

            pop     hl
           ; pop     bc
            
            ; Update the offset
            
            add hl, 4

		; chan 4 
            
           ; push    bc 
            push    hl      ; save position in pattern 
            call    DecodePatternData

            ld      b, 0 
            call    printhl             ; pring note

          ;  ld      hl,cur_x : inc     (hl)

            ld      b, 2 
            ld      a, e
            call    printhex    ; print sample 

          ;  ld      hl,cur_x : inc     (hl)

            ld      b, 1 
            ld      a, c 
            call    printhex2    ; print effect 

            
            ld      a, d 
            call    printhex    ; effect param 
            
            ld      hl,cur_x :inc     (hl)


            xor     a 
            ld      (cur_x), a 

            pop     hl
            pop     bc
            
            ; Update the offset
            
            add hl, 4

            ld      a, (cur_y)
            inc     a 
            ld      (cur_y), a

        back:


            ; Decrement row counter
            dec c
            jp nz, RowLoop
            

        ; Decrement pattern counter
    ; dec b

        ret

getPatternRow:
        ld      hl, pattern0
        ld      e, 16 
        mul     d, e 
        add     hl, de              ; address of row 
        ret 

printblank: 
        ld      d, c 
        ld      bc , 64
        ld      a, 0 
        ld      (cur_x), a
    wipeloop:
        push    bc
        ld      b, 0 
        ld      a, 32 ; space
        call    print_tilemap

        pop     bc 
        djnz    wipeloop
        ld      c, d 
        ld      a, (cur_y)
        inc     a 
        ld      (cur_y), a


        jp      back 



    DecodePatternData:

        ; Load bytes a, b, c, d from memory at address HL
        ; reads on track row of data     
        ld e, (hl)       ; a.a = PeekA(temp) 
        inc hl
        ld b, (hl)       ; b.a = PeekA(temp+1) 
        inc hl
        ld c, (hl)       ; c.a = PeekA(temp+2)
        inc hl
        ld d, (hl)       ; d.a = PeekA(temp+3)
        
        ; Get 8-bit sample number
        ld a, e             ; get a.a from e 
        add a, c            ; samp = a + c >> 4
        SWAPNIB             ; Shift right by 4 bits
        and     $1f         ; mask 31  
        push    af          ; push on stack for later 

        
        ; Calculate 12-bit period
        ld  a, e            ; get back a.a from e 
        and $0F             ; a & %00001111
        ld h, a             ; Move result to H
        ld l, b             ; Move B to L
                            ; period = (a & %00001111) * 256 + b
        
        ; Now get the effect - b / a free 
        ld a, c             ; store a & %00001111 in c 
        and $f 
        ld c,a 

        pop     af          ; bring back sample into e 
        ld      e, a 


        ; calc paramA + paramb 
        ; ld  a, d            ; d  
        ; ld  d, a


        ; At this point:
        ; B = b
        ; C = effect
        ; D = effect param 
        ; E = samp
        ; HL = 12-bit period

        call    period_to_string

        ; HL now points to note string 

        ret
    printhex2: 
        ; uses de, c, a 
        ;push bc 
        push de 
        ld c, a 
        call Num2
        ; rst 16
        call print_tilemap
        pop de
        ;pop bc 
        ret  ; return with hex number in de

    printhex: 
        ; uses de, c, a 
        push bc 
        push de 
        ld c, a        ; cav char 
        call Num1
        ;rst 16
        call print_tilemap
        ld a, c
        call Num2
        ;rst 16
        call print_tilemap
        pop de
        pop bc 
        ret  ; return with hex number in de

    Num1:
        swapnib 
        and %00001111        
        ;rra
        ;rra
        ;rra
        ;rra
        
    Num2:
        or $F0
        daa
        add a, $A0
        adc a, $40 ; Ascii hex at this point (0 to F)   
        ret

    printhl:
        ld      a, (hl)
        or      a 
        ret     z 
        ;rst     16 
        call    print_tilemap
        inc     hl 
        jr      printhl
	

    print_tilemap_old: 
            ;       in bc a = char, b = colour 
            ; uses hl, a, de, bc 
            
            push    bc : push de : push hl 
            ld 		hl, (current_position)          ; a is the char to print, save in b
			ld 		(hl), a 
			inc 	hl 
			ld      a,b                            ; 
            and 	%01111111
            rlca   
            ld 		(hl),a
			ld 		(current_position), hl 
            ; SWAPNIB 
            pop     hl : pop de : pop bc 
            ret 

	; old routine 
            ;       in bc a = char, b = colour 
            ; uses hl, a, de, bc 
            
            push    bc : push de : push hl
            ld      c, a 
            ld 		hl,.TILE_MAPBASE*256            ; a is the char to print, save in b
            ld 	    a,(cur_x)                       ; get x co-ord 
            add     a, a                            ; double it 
            add		hl,a							; add x * 2 because map is (char,attrib) x 80 

            ld      de,(cur_y)                       ; get ypos  
            ld 		d,80                           ; 160 chars per line * y 
            mul 	d,e		                        ; mul 160 because map is 2 x 80 
            add 	hl,de                           ; add to hl 
            ld 		(hl),c                          ; put char into hl 
            inc     hl                              ; move to attrib byte 
            ld      a,b                            ; 
            and 	%01111111
            rlca    ;   : and %11111110
            ld 		(hl),a
            ld      hl,cur_x : inc     (hl)

            ; SWAPNIB 
            pop     hl : pop de : pop bc 
            ret 

		current_position:
				dw 	$4400 

        cur_x:      db 0 
        cur_y:      db 0

    BANK8K_FINETUNE   equ     24

    period_to_string: 

    nextreg	$50,BANK8K_FINETUNE ; $4000
            
        ;set	6,h		; Period + 16384 (MM2)
        ld	a,(hl)
        ld	hl,note_tab
        add	a,a		; Pre-multiplied by 2
        add	hl,a
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



do : loop 


asm 
    pattern0:
    incbin "./data/finetune2.dat"
end asm 