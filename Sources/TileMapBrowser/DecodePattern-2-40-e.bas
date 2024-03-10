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
    nextreg TILEMAP_YOFFSET_NR_31,-40
    nextreg TILEMAP_XOFFSET_LSB_NR_30,0
    nextreg TILEMAP_XOFFSET_MSB_NR_2F,0

    nextreg CLIP_ULA_LORES_NR_1A,0                        ; Tilemap clipping 
    nextreg CLIP_ULA_LORES_NR_1A,0
    nextreg CLIP_ULA_LORES_NR_1A,0
    nextreg CLIP_ULA_LORES_NR_1A,0

    NextReg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000        ; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_CONTROL_NR_6B,%11001001				; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_BASE_ADR_NR_6E,$44				    ; tilemap data $6000
    NextReg TILEMAP_GFX_ADR_NR_6F,$40				    ; tilemap blocks 4 bit tiles $4000
    NextReg PALETTE_CONTROL_NR_43,%00110000
end asm 

paper 0 : ink 7 : border 0 : cls 
LoadSDBank("TURRII.MOD",0,1084,0,31)                     ' load mod pattern data 
LoadSDBank("TURRII.MOD",0,0,1084,32)                     ' load mod pattern data 

LoadSDBank("ATASCII.spr",0,0,0,12)							' 1 bit font to bank 20
'LoadSDBank("topan.fnt",0,0,0,12)							' 1 bit font to bank 20
LoadSDBank("mm.pal",1024,0,0,12)								' palette to bank 20 + $0200

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

Dim row,trow,p,t as ubyte
Dim keydown,play as ubyte 
dim slen as ubyte 
dim pattern, position as ubyte 

pattern = 1

colour_pattern()
Show_Row(0,pattern)
get_position(1)
TextLine(0,24,str(pattern)+" "+str(position),0)
TextLine(0,25,str(slen),0)

do 
    k = GetKeyScanCode()
    if keydown = 0 and k = KEYA
		t = 0 
        row = (row + 1) band 63
		
        asm 
        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,3
        end asm 
        Show_Row(row,pattern)
        asm 
        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0
        end asm 
        keydown = 1 

    elseif keydown = 0 and k = KEYQ 

        row = row - 1 band 63 
        Show_Row(row,pattern)
        keydown = 1 
	elseif keydown = 0 and k = KEYP
		' if 	row + 16 < 63
        ' row = row + 16 band 63 
		' else 
		' row = 63
		' endif 
		pattern = pattern + 1
        Show_Row(row,pattern)
        keydown = 1
	elseif keydown = 0 and k = KEYO
		pattern=pattern-1 band 63 
        Show_Row(row,pattern)
        keydown = 1 
	elseif keydown = 0 and k = KEYSPACE 
		row = 0 
		Show_Row(row,pattern)
		play = 1 - play 
		keydown = 1 
    elseif keydown = 1

        WaitRetrace(40)
        keydown = 0 

    endif 

	if t >= 4 and play = 1 
		row = row + 1 
		if row = 64
			position = position + 1 
			if position=slen 
				position=0 
			endif 
			get_position(position)
			row = 0 
		endif 
		Show_Row(row,position)
		TextLine(0,24,"Pattern  : " +str(pattern)+" ",0)
		TextLine(6,25,"Position : " +str(position)+" "+str(slen)+" ",0)
		t = 0 
	endif 

	t = t + 1 

    WaitRetrace2(1)
    

loop 

sub fastcall colour_pattern()
	asm 

		call 	color_pattern_table

	end asm 
end sub 

sub fastcall sety(row as ubyte)
    asm 
        
        ; a = new row 
        def_cur_y       EQU     cur_y
        ld      (def_cur_y),a 

    end asm 
end sub 

sub	fastcall get_position(count as ubyte)
	asm 
		; a index of position, return pattern 
		
		nextreg	$52, 31 		; mod data 
		ld 		hl, $4000+950	; song length address
		ld 		b, (hl)			; save len in b 
		
		; cp 		b				; compare count with song lenght

		; jr 		nz, continuesong 
		; xor 	a				; end if song 
		continuesong:
		ld 		hl, $4000+952	; pattern order 
		add		hl,a 			; add a 
		ld 		a, (hl)			
		ld 		(._pattern), a 		; save it in p 
		ld 		a, b 
		ld 		(._slen), a 
		nextreg $52,10 
	end asm 
end sub 

sub Show_Row(row as ubyte, pattern as ubyte)
    asm 
		
		ROWLENGTH	equ 	80 

        push    ix 
		ld		hl, $4400
		ld 		(cursor_position), hl 
        call    draw_row
        pop     ix 
        jp      _Show_Row__leave 


    draw_row:
        ;       a is the row  
		ld 		a, (._pattern)
		and		7
		add		a, a
		add		a, a
		ld 		h, a 

		ld 		a, (IX+5)
		sub 	7 		; middle line 
		 
		ld      ixl, a  ; save row to start at 	
		
		cp 		64
		jr		c, skipand192
		xor 	a
	skipand192:
		ld      d, a 
			
		call 	getPatternRow
        ; 	hl set from getPatternRow 

        ; Iterate through patterns (64 patterns)
        ; ld b, 1
        PatternLoop:    ; not used 
        
        ; Iterate through 15 rows
        ld c, 15
		
		
        RowLoop:

			push    bc 		; save loop counter c 

            ld      a,ixl           ; get row 

            cp      64	            ; does it cp 
            jp      nc, printblank 	; not between 0-64 so print blank line

			push 	hl 				; save pattern+row address 
            call    printnumber		; print row number

			ld      hl,cursor_position  ; 10
			inc     (hl) ; 11 		; space after row 
			inc     (hl) ; 11 32 

			pop 	hl 				; restore pattern+row address 

		; chan 1 
             
            push    hl      ; save position in pattern 

            call    DecodePatternData

            call    printhl             ; pring note
			; hl is at last char 
             
			ld      a, e
            call    printhex_XX    		; print sample XX 
            
            ld      a, c 
            call    printhex_X    		; print effect X 

            ld      a, d 
            call    printhex_XX    		; effect param  XX 

			add 	hl, 2
            ld 		(cursor_position), hl 
			; ld      hl,cursor_position  ; 10	; space between channels 
			; inc     (hl) ; 11 
			; inc     (hl) ; 11 32 

            pop     hl
            
            ; Update the offset
            
            add hl, 4

		; chan 2 

            push    hl      ; save position in pattern 
            call    DecodePatternData
   
            call    printhl             ; print note
            
            ld      a, e
            call    printhex_XX    		; print sample 
            
            ld      a, c 
            call    printhex_X    		; print effect 

            ld      a, d 
            call    printhex_XX    		; effect param 
			
			add 	hl, 2
            ld 		(cursor_position), hl 

			;ld 		(cursor_position), hl 
			;ld      hl,cursor_position  ; 10
			;inc     (hl) ; 11 
			;inc     (hl) ; 11 32 

            pop     hl

            ; Update the offset

            add     hl,4 

		; chan 3 
            
            push    hl      ; save position in pattern 
            call    DecodePatternData

            call    printhl             ; pring note

            ld      a, e
            call    printhex_XX    		; print sample 

            ld      a, c 
            call    printhex_X    		; print effect 

            ld      a, d 
            call    printhex_XX    		; effect param 
			
			add 	hl, 2
            ld 		(cursor_position), hl 

			; ld      hl,cursor_position  ; 10
			;inc     (hl) ; 11 
			;inc     (hl) ; 11 32 

            pop     hl

            ; Update the offset
            
            add hl, 4

		; chan 4 
            
            push    hl      ; save position in pattern 
            call    DecodePatternData

            call    printhl             ; pring note

            ld      a, e
            call    printhex_XX    		; print sample 

            ld      a, c 
            call    printhex_X    		; print effect 
            
            ld      a, d 
            call    printhex_XX    		; effect param 

			
            ld 		(cursor_position), hl 

			; ld 		hl,(cursor_position)
			; hl still set from printhex_XX 

			ld 		a, ROWLENGTH
			cp 		80
			jr 		z, charsperline_80
			add 	hl, 4
			jr		charperline_skip
		charsperline_80:
			add 	hl, 84
		charperline_skip:
			ld 		(cursor_position), hl 
			
            pop     hl					; bring back pattern+row address 

            ; Update the offset
            
            add hl, 4

	back:
			inc     ix              	; inc row						
			
			pop     bc					; bring back c for counter 

            ; Decrement row counter
            dec c
            jp nz, RowLoop
            

        ; Decrement pattern counter nor used 
    	; dec b
		; xor 	a
		; ld      (cur_y), a

        ret

getPatternRow:
		; 	d > row  d*16+$4000 
		; 	hl < row address
        ld      e, 16	; 7 
        mul     d, e 	; 8 
		add 	hl,$4000; 16 
		add		hl,de 
        ret 

printblank: 
		; 	nothing in
		; 	uses de, a, b set current position 
		ld 		de, (cursor_position)
		ld 		a, ' ' ; space  
		ld 		b, 80
    wipeloop:
		ld 		(de), a 
		inc 	de
		inc 	de
        djnz    wipeloop
		ld 		(cursor_position), de
        jp      back 

DecodePatternData:
		; hl > pointer to pattern+row  
		ld 		a, (._pattern)	; get pattern number  
		and	%00111000
		rrca
		rrca
		rrca
		add 	a, 32 
		nextreg $52,a 			; bring in pattern bank 

        ; Load bytes a, b, c, d from memory at address (HL)
        ; reads a channel row of data, 4 bytes for note,sample,effect,effectparam  

        ld 		e, (hl)       		; e = byte0
        inc 	hl
        ld 		b, (hl)       		; b = byte1
        inc 	hl
        ld 		c, (hl)       		; c = byte2 
        inc 	hl
        ld 		d, (hl)       		; d = byte3 
        
        ; Get 8-bit sample number
        ld 		a, e             	; get byte0
        add 	a, c            	; samp = a + c >> 4
        swapnib             		; Shift right by 4 bits
        and     $1f         		; mask 31  
        push    af          		; save sample on stack for later 

        
        ; Calculate 12-bit period
        ld  	a, e            	; get byte 0 into a 
        and 	$f	             	; mask off a & %00001111 
        ld 		h, a            	; store MSB in h 
        ld 		l, b            	; byte 1 into l 
        
        ; Now get the effect - regs b / a free 
        ld 		a, c            	; get byte 2 
        and 	$f 					; mask 0-15 
        ld 		c,a 				; save effect into c 

        pop     af          		; bring back sample into e 
        ld      e, a 

        ; At this point:
        ; b = not used 
        ; c = effect
        ; d = effect param 
        ; e = samp
        ; hl = 12-bit period

		nextreg $52,10				; restore bank in slot 2 

        jp    period_to_string
    
printhex_X: 
		; a > number to print in HEX X
		; hl < cursor position 
        ; uses a, hl 

		or 		$f0
		daa
		add 	a, $a0
		adc 	a, $40 				
		; ld 		hl, (cursor_position)
		ld		(hl), a 			; put ascii char into tilemap 
		inc 	hl
		inc 	hl					; skip attrib 
		; ld      (cursor_position), hl  ; save new cursor position 
		ret 


printhex_XX: 
		; a > double digit number to print in HEX XX
		; hl < cursor position 
		; uses a, e , hl 

		ld 		e, a        ; save number
		swapnib
		or 		$f0
        daa
        add 	a, $a0
        adc 	a, $40 
		; ld 		hl, (cursor_position)
		ld		(hl), a 			; put first char into map 
		inc 	hl
		inc 	hl 					; skip attribute 
	char2:
		ld 		a, e				; get back original number 
		or 		$f0
		daa
		add 	a, $a0
		adc 	a, $40 
		ld		(hl), a				; second char into tilemap  
		inc 	hl
		inc 	hl					; skip attribute  	
		; ld 		(cursor_position), hl 
		ret 

printnumber:
		; 		
		ld 		hl, (cursor_position)
		ld 		e, -10 
		call 	Na1 
		ld 		e, -1 
Na1:	
		ld 		b, '0'-1 
Na2: 
		inc 	b 
		add 	a, e 
		jr 		c, Na2
		sub 	e  
		ld		(hl), b 			; put first char into map 
		inc 	hl
		inc 	hl 					; skip attribute 
		ld 		(cursor_position), hl 
		ret 

skipglyph:
		ld 		hl, (cursor_position)
		ld 		(hl),32
		inc 	hl 	: inc 	hl 	
		jr		char2 

printhl:
		; uses de, hl, a
		push 	de 
		ld      de, (cursor_position)
		ex      de, hl 
		;   hl = currentposition in tile map 
		;   de = points the char  
.pr_lp:
		ld      a, (de)         ; fetch char 
		or      a               ; was it 0 
		jr      z,.pr_done      ; yes done 
		ld      (hl), a         ; else place into tilemap 
		inc     hl              ; move to attrib
		ld      (hl), b         ; place in tilemapo 
		inc     hl              ; inc cursor 
		inc     de              ; move to next char 
		jr      .pr_lp          ; loop 
pr_done:
		pop 	de 
		; ld      (cursor_position), hl  ; save new cursor position 
		ret 
	

cursor_position:
		dw 	$4400 

        cur_x:      db 0 
        cur_y:      db 0

    BANK8K_FINETUNE   equ     24

    period_to_string: 

		; hl > period 
		; hl < address of note string 
		; uses hl, a, b 

    	nextreg	$50,BANK8K_FINETUNE ; $4000
            
        ; set	6,h		; Period + 16384 (MM2)
        ld		a,(hl)
        ld		hl,note_tab
        add		a,a		; Pre-multiplied by 2
        add		hl,a
		rrca 
        cp      72		; is it no note? 
        jr      nz, normalcolour 
        ld      b, 1
        jr      darkcolour
    normalcolour:
        ld      b, 8
    darkcolour:
        nextreg	$50,$ff 
        ret

	color_pattern_table:
		ld 		de, $4401 	; first attrib
		ld 		c, 15 		; rows 
	colour_start:
		ld 		b, ROWLENGTH		; chars 
		ld 		hl, colourtable 
	colourloop: 
		ld 		a, (hl)
		and 	%01111111
		rlca   
		ld 		(de),a
		inc 	hl 
		inc 	de 
		inc 	de 
		djnz 	colourloop 	; does one row 
		ld 		a, ROWLENGTH
		cp 		40
		jr 		z, charsperline_40 

		; add 	de, 80
		
	charsperline_40:
		
		ld 		a, c 
		cp 		9 
		jr		nz,notmiddle 
		ld		b, ROWLENGTH
		ld 		hl, middle 
		dec 	c
		jr 		colourloop
		
	notmiddle:
		dec 	c		
		jr 		nz, colour_start
		ret 



	colourtable: 
			   ;row - 
		db 		0,0
;				- c - 3 s  s  e e e - c - 3  s  s e e e 
		db 		0,0,0,0,$a,$a,6,6,6,0,0,0,0,$a,$a,6,6,6
		db 		0,0,0,0,$a,$a,6,6,6,0,0,0,0,$a,$a,6,6,6,0,0

	middle:
		defs 	ROWLENGTH,18

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
        db	" - "
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