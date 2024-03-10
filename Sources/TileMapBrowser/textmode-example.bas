'!org=24576
'#!asm 
'!opt=4
'!heap=4096
'!copy=h:\a_readdir.nex
' NextBuild TileMap

#define NEX 

#include <nextlib.bas>
#include <keys.bas>
#include <string.bas>

dim ArrayStr       as string = ""

asm 

	TILE_GFXBASE 		equ 	$40 
	TILE_MAPBASE 		equ 	$44

    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11        ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg CLIP_TILEMAP_NR_1B,0                        ; Tilemap clipping 
    nextreg CLIP_TILEMAP_NR_1B,159
    nextreg CLIP_TILEMAP_NR_1B,0
    nextreg CLIP_TILEMAP_NR_1B,255
    NextReg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000        ; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_CONTROL_NR_6B,%11001001				; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_BASE_ADR_NR_6E,TILE_MAPBASE		    ; tilemap data $6000
    NextReg TILEMAP_GFX_ADR_NR_6F,TILE_GFXBASE		    ; tilemap blocks 4 bit tiles $4000
    NextReg PALETTE_CONTROL_NR_43,%00110000				; pick the tilemap palette 
	di 
end asm 

dim c,b,y 			as ubyte  
dim x 				as uinteger
dim pat_x, pat_y 	as ubyte 
dim pat_p, curr_pat as ubyte 
dim curr_chan		as ubyte 
dim patt_accum		as ubyte 
dim cur_x, cur_y	as ubyte 							' holds cursor X/Y
dim size(128) 		as ulong
dim count, tsize	as ubyte 
dim files$(255)		as string 
'--------------------------------------------------------
' Set up 
'------------------------

LoadSDBank("topan.fnt",0,0,0,20)							' 1 bit font to bank 20
LoadSDBank("mm.pal",1024,0,0,20)								' palette to bank 20 + $0200
NextReg($57,20)													' page bank 20 to $e000, slot 7 
PalUpload($e400,64,0)											' upload the palette 
CopyToBanks(20,10,1,1024)										' copy bank 20 > 2 with 1 bank of length 1024 bytes 
NextReg($57,1)
ClearTilemap() 
pat_p = 8 
' BBREAK
c = 0

'--------------------------------------------------------
' Main Loop 
'------------------------

ReSetPatterBuffer()
for x = 0 to 7 
	DrawRownDown()
next 


Read_Dir()


' for y = 0 to count-1
'   	TextLine(cur_x,cur_y,files$(x)( to ),11)
'   	cur_y = cur_y + 1
' next y 
TextLine(0,1,"OK",09)
do 
	' for x = 0 to 31
	' TextLine(0,y,"NEXTLIB TILEMAP CONTROL WITH BORIELS ZX BASIC COMPILER ",c)
	' c=c+1 ' : if c = 32 : c = 0 : endif 
	' y=y+1 : if y = 31 : y = 0 : endif
	' next 
	Check_Input()
	
	WaitRetrace(100)
loop 


'--------------------------------------------------------
' Check Input 
'------------------------

sub Check_Input()
	

	if MultiKeys(KEY7) AND MultiKeys(KEYSYMBOL)
		DrawRowUp()
	elseif MultiKeys(KEY6) AND MultiKeys(KEYSYMBOL)
		DrawRownDown()
	endif 	

end sub


'--------------------------------------------------------
' Draw Pattern 
'------------------------

sub DrawRowUp
	TextLine(0,0,"KEY UP  ",10)
	ColourRow(0)
	pat_p = pat_p - 1 
	if pat_p > 13+9 
		ScrollPatternDown()
		SubPatterBuffer()
		' DrawPattern()
		TextLine(0,8,str(pat_p-23),12)
	elseif pat_p>8 +9 
		ScrollPatternDown()
		pat_p=pat_p+1 
	'else 
		
		' pat_p = 0
	endif 
	ColourRow(12)
end sub 

sub DrawRownDown()
		ColourRow(0)
		TextLine(0,0,"KEY DOWN",11)
		pat_p = pat_p + 1 
		if pat_p < 64+9
			ScrollPatternUp()
			AddPatterBuffer()
			DrawPattern()
			TextLine(0,22,str(pat_p-9),12)
		elseif pat_p< 64+16
			ScrollPatternUp()
			pat_p=pat_p-1 
		'else 
		'	pat_p=pat_p-1 
		endif 
		ColourRow(12)
end sub 

sub fastcall ScrollPatternUp()
	asm 
		ld 		hl, TILE_MAPBASE*256 + ( 9 * 160 )
		ld 		de, TILE_MAPBASE*256 + ( 8 * 160 )
		ld 		bc, 2400
		ldir
	end asm 
end sub 

sub fastcall ScrollPatternDown()
	asm 
		; BREAK 
		ld 		hl, TILE_MAPBASE*256 + ( 21 * 160 ) +159
		ld 		a,'Z'
		ld 		(hl),a 
		ld 		de, TILE_MAPBASE*256 + ( 22 * 160 ) +159
		ld 		bc, 2400
		lddr 
	end asm 
end sub 

sub fastcall AddPatterBuffer()
	asm 
		ld 		hl, (pattern_buffer_add)
		add		hl, 32 							; size of row 8 bytes * 4 
		ld 		(pattern_buffer_add), hl 
		ret 
	end asm 
end sub 

sub fastcall SubPatterBuffer()
	asm 
		ld 		hl, (pattern_buffer_add)
		add		hl, $FFE0						; size of row 8 bytes * 4 
		ld 		(pattern_buffer_add), hl 
		ld 		de, 160*8+PATT_X_OFF+TILE_MAPBASE*256
		call 	upper_pattern 
		ret 
	end asm 
end sub 

sub fastcall ReSetPatterBuffer()
	asm 
		ld 		hl, pattern_buffer
		ld 		(pattern_buffer_add), hl 
		ret 
	
	pattern_buffer_add:
		dw 		0000 
	end asm 
end sub 

sub fastcall DrawPattern()

	asm 
		PATT_Y_OFF			equ 	160 * 22
		PATT_X_OFF			equ 	4 * 2  

		ld 		de,PATT_Y_OFF+PATT_X_OFF+TILE_MAPBASE*256			; start of position to draw on screen 
	
	upper_pattern:

		ld 		hl,(pattern_buffer_add)								; point to start of buffer 
		


		ld 		bc,$0100 						; draw 1 row 

	row_loop:

		push 	bc 
		
		ld		bc,$0500						; loop 4 times for each channel + 1 as ldi will cause $04FF
		
	chan_loop: 
		 
		ldi 									; copy note value to screen 
		inc 	de 								; attribute skip 

		inc 	de 								; space 
		inc 	de 								; space 

		ldi 									; draw octave 
		inc 	de 								; attribute skip 
		
		
		add 	de,4

		ldi 									; volume 
		inc 	de 								; attribute skip 
		ldi 									; 2 bytes 
		inc 	de 								; attribute skip

		inc 	de 								; another space 
		inc 	de 								; another space 

		ldi 
		inc 	de 								; attribute skip 
		ldi 
		inc 	de 								; attribute skip 
		ldi 
		inc 	de 								; attribute skip 
		ldi 									; 4 effect bytes 
		inc 	de 								; attribute skip 

		add 	de, 16							; geuss to next line for now 

		djnz	chan_loop						; loop for each channel 

		pop 	bc 

		djnz	row_loop

		ret 
	end asm 

end sub 


sub ColourRow(colour as ubyte)
	
	asm 
	
		push af 
		ld 		hl, TILE_MAPBASE*256
		;ld 		a,(._pat_p)
		ld 		a, 15 
		ld 		d,a
		ld 		e,160
		mul 	d, e
		add 	hl,de			; start of row
		pop 	af 				; get colour
		; SWAPNIB : and %11111000
        and 	%01111111
		ld 		b,80
	rowloop:		
		inc 	hl 
        ld 		a,(hl)
        xor 	32         ; adds to the colour 
		ld 		(hl),a 
		inc 	hl 
		djnz rowloop
		end asm 	

end sub
'--------------------------------------------------------
' Subroutines  
'------------------------

sub Read_Dir()
	count = 0 
	ink 6
	border 0 
	
	TextLine(0,0,"Reading dir...",13)
	asm 
	;; BREAK 
	f_esxdos					 equ $08
	m_getsetdrv 			 equ $89
	f_opendir          equ $a3 ;(163) open directory for reading 
	f_Read_Dir          equ $a4 ;(164) read directory entry 
	f_rewinddir        equ $a7 ; (167) Rewind the dir 
	f_getcwd		       equ $a8 ; (167) get current working directory 
	f_close						 equ $9b
	;di
		push ix 
initdrive:
		;ld a,$81 : 	out ($e3),a 	
		;ld a,0
		;rst f_esxdos : DB f_close 
		
		;ld a,0
		;rst f_esxdos : db m_getsetdrv					
		;ld (handle),a
		; BREAK
		;' get current work dir
		ld a,'*'
		ld ix,dirbuffer
		rst f_esxdos : DB f_getcwd
		; BREAK
		
		ld b,$10
		ld a,'*'
		ld ix,dirbuffer
		rst f_esxdos : db f_opendir
		
		ld (handle),a				; a = dir handle 
		rst f_esxdos : db f_rewinddir
dirloop:		

		ld a,(handle)
		ld ix,dirbuffer
		rst f_esxdos : db f_Read_Dir				
		
		

		or 		a
		jp 		z,donedir			; no more entries
		jp 		c,donedir 			; fail, a = error code 


		
		ld 		bc, 0 
		ld 		hl,dirbuffer+1			; first char of string

		 
		genlenthtloop:;

		
		ld 		a,(hl) 					; get the char
		or 		a 						; was it 0
		jp 		z,donelength 			; yes then end of check 
		inc 	bc 						; no lets increase the bc counter
		inc 	hl 						; and move along to next byte 
		jr 		genlenthtloop 			; now loop 

donelength:
		; 		bc = string lenght 
		push 	bc 						; save string length 
		add		hl,5					; move past date&timestamp
		; 		hl now points to 32bit size 
		
		 
		
		ld 		a, (hl)					; (hl) = hl 
		inc 	hl 						; hl = first of 32bit number
		push 	hl 						; save hl+1 on stack 
		ld		h, (hl)					
		ld 		l, a 					; how hl = first 16bits

		;ld		e,	h 
		;ld 		d,	l 

		ex		de, hl 

		pop 	hl 						; get back hl+1 address
		inc 	hl 						; mover to next 16bits 
		ld 		a, (hl)					; (hl) = hl 
		inc 	hl 
		ld		h, (hl)
		ld 		l , a 					; now DEHL = 32bit number 
		ex		de, hl 

		BREAK
		call 	B2D32
		
		pop		bc 
		

		;ld hl,string_temp : ld a,c : ld (hl),a : inc hl : ld a,b : ld (hl),a : inc hl 
		;ld hl,dirbuffer
		;ex de,hl 
		;ldir 

		jp dirloop		; 3 

	handle:
			db 0 					; 1
	; Buffer format:
	; 1 byte file attributes (MSDOS format)
	; ? bytes file/directory name(s), null-terminated
	; 2 bytes timestamp (MSDOS format)
	; 2 bytes datestamp (MSDOS format)
	; 4 bytes file siz
	dirbuffer:
			defs 255,0
	dir: 
			DB "c:/"
			
	print_fname:
			ld a,(hl):inc hl:cp 0:ret z:rst 16:jr print_fname
			
	donedir:
			ld a,(handle) : rst f_esxdos : db f_close
			pop 	ix 

	end asm 
	if count>114 : max = 114 : else max = count : endif 
end sub 
asm 


; Combined routine for conversion of different sized binary numbers into
; directly printable ASCII(Z)-string
; Input value in registers, number size and -related to that- registers to fill
; is selected by calling the correct entry:
;
;  entry  inputregister(s)  decimal value 0 to:
;   B2D8             A                    255  (3 digits)
;   B2D16           HL                  65535   5   "
;   B2D24         E:HL               16777215   8   "
;   B2D32        DE:HL             4294967295  10   "
;   B2D48     BC:DE:HL        281474976710655  15   "
;   B2D64  IX:BC:DE:HL   18446744073709551615  20   "
;
; The resulting string is placed into a small buffer attached to this routine,
; this buffer needs no initialization and can be modified as desired.
; The number is aligned to the right, and leading 0's are replaced with spaces.
; On exit HL points to the first digit, (B)C = number of decimals
; This way any re-alignment / postprocessing is made easy.
; Changes: AF,BC,DE,HL,IX
; P.S. some examples below

; by Alwin Henseler


B2D8:    LD H,0
         LD L,A
B2D16:   LD E,0
B2D24:   LD D,0
B2D32:   LD BC,0
B2D48:   LD IX,0          ; zero all non-used bits
B2D64:   LD (B2DINV),HL
         LD (B2DINV+2),DE
         LD (B2DINV+4),BC
         LD (B2DINV+6),IX ; place full 64-bit input value in buffer
         LD HL,B2DBUF
         LD DE,B2DBUF+1
         LD (HL),' '
B2DFILC  EQU $-1         ; address of fill-character
         LD BC,18
         LDIR            ; fill 1st 19 bytes of buffer with spaces
         LD (B2DEND-1),BC ;set BCD value to "0" & place terminating 0
         LD E,1          ; no. of bytes in BCD value
         LD HL,B2DINV+8  ; (address MSB input)+1
         LD BC,$0909
         XOR A
B2DSKP0: DEC B
         JR Z,B2DSIZ     ; all 0: continue with postprocessing
         DEC HL
         OR (HL)         ; find first byte <>0
         JR Z,B2DSKP0
B2DFND1: DEC C
         RLA
         JR NC,B2DFND1   ; determine no. of most significant 1-bit
         RRA
         LD D,A          ; byte from binary input value
B2DLUS2: PUSH HL
         PUSH BC
B2DLUS1: LD HL,B2DEND-1  ; address LSB of BCD value
         LD B,E          ; current length of BCD value in bytes
         RL D            ; highest bit from input value -> carry
B2DLUS0: LD A,(HL)
         ADC A,A
         DAA
         LD (HL),A       ; double 1 BCD byte from intermediate result
         DEC HL
         DJNZ B2DLUS0    ; and go on to double entire BCD value (+carry!)
         JR NC,B2DNXT
         INC E           ; carry at MSB -> BCD value grew 1 byte larger
         LD (HL),1       ; initialize new MSB of BCD value
B2DNXT:  DEC C
         JR NZ,B2DLUS1   ; repeat for remaining bits from 1 input byte
         POP BC          ; no. of remaining bytes in input value
         LD C,8          ; reset bit-counter
         POP HL          ; pointer to byte from input value
         DEC HL
         LD D,(HL)       ; get next group of 8 bits
         DJNZ B2DLUS2    ; and repeat until last byte from input value
B2DSIZ:  LD HL,B2DEND    ; address of terminating 0
         LD C,E          ; size of BCD value in bytes
         OR A
         SBC HL,BC       ; calculate address of MSB BCD
         LD D,H
         LD E,L
         SBC HL,BC
         EX DE,HL        ; HL=address BCD value, DE=start of decimal value
         LD B,C          ; no. of bytes BCD
         SLA C           ; no. of bytes decimal (possibly 1 too high)
         LD A,'0'
         RLD             ; shift bits 4-7 of (HL) into bit 0-3 of A
         CP '0'          ; (HL) was > 9h?
         JR NZ,B2DEXPH   ; if yes, start with recording high digit
         DEC C           ; correct number of decimals
         INC DE          ; correct start address
         JR B2DEXPL      ; continue with converting low digit
B2DEXP:  RLD             ; shift high digit (HL) into low digit of A
B2DEXPH: LD (DE),A       ; record resulting ASCII-code
         INC DE
B2DEXPL: RLD
         LD (DE),A
         INC DE
         INC HL          ; next BCD-byte
         DJNZ B2DEXP     ; and go on to convert each BCD-byte into 2 ASCII
         SBC HL,BC       ; return with HL pointing to 1st decimal
         RET

B2DINV:  DS 8            ; space for 64-bit input value (LSB first)
B2DBUF:  DS 20           ; space for 20 decimal digits
B2DEND:  DS 1            ; space for terminating 0

end asm 
sub fastcall PeekMem(address as uinteger,delimeter as ubyte,byref outstring as string)
    ' assign a string from a memory block until delimeter 
    asm 
        push namespace peekmem 
main:        
        ex de, hl 
        pop hl 
        pop af          ; delimeter 
        ex (sp),hl         
        ;' de string ram 
        ;' hl source data 
        ;' now copy to string temp
		push bc 
        push hl 
        ex de, hl 
        ld de,.LABEL._string_temp+2
        ld bc,0 
    copyloop:
        cp (hl)                 ; compare with a / delimeter 
        jr z,endcopy            ; we matched 
        push bc 
        ldi 
        pop bc 
        inc c
        jr nz,copyloop          ; loop while c<>0
        dec c 
    endcopy:
        ld (.LABEL._string_temp),bc 
        pop hl 
        ld de,.LABEL._string_temp
        ; de = string data 
        ; hl = string
		pop bc  
        pop namespace
        jp .core.__STORE_STR
    end asm 

end sub 



sub TextLine(byval txx as ubyte,byval tyy as ubyte,helptextin as string,byval col as ubyte)

	asm 
		; cant be fast call due to bug in freeing string 
		push 	namespace TextLine 
		; BREAK 
		add 	a,a
		ld 		(xpos+1),a 						; save the xpos 
		ld 		a,(ix+7)
		and 	31 								; line 32 is max line 
		ld 		e,a 							; save in e 
		ld 		hl,.TILE_MAPBASE*256			; point hl to start of textmap area 
		ld 		d,160							; text map is 160 bytes wide (tile + attribute * 80)
		mul 	d,e  							; multiply this with the ypos 
		add 	hl,de 							; add to start of textmap 

	xpos:
		ld 		a,0								; xpos set with smc 
		add 	hl,a 							; add to hl 
		ex 		de,hl 							; swap hl into de 
		ld		h,(ix+9)						; get string address off ix 
		ld 		l,(ix+8)
		ld 		b,(hl)							; save string len in b
		add 	hl,2 
		ld 		a,(ix+11) 						; get colour
		ld 		(col+1),a 						; save with smc 
	lineloop:
		push 	bc 								; save loop size 
		ldi 									; copy hl to de then inc both  
	col:
		ld 		a,0								; colour set with smc 
		and 	%01111111						; and 6 bits 
		rlca									; rotate left 
		ld 		(de),a 							; save in attribute location 
		inc 	de 								; inc de
		pop 	bc								; get back string len 
		djnz 	lineloop 						; repeat while b<>0
	done: 
		pop 	namespace
	
	end asm 

end sub 


sub ClearTilemap()
	asm 
		ld 		hl,TILE_MAPBASE*256
		ld 		de,1+TILE_MAPBASE*256
		ld 		bc,2560*2
		ld 		(hl),0
		ldir 
	end asm 
end sub 

sub fastcall UpdateMap(ux as ubyte, uy as ubyte, uv as ubyte, ucol as ubyte)
	asm 
		 
		exx : pop hl : exx 
		ld 		hl,TILE_MAPBASE*256
		add 	a,a
		add		hl,a							; add x * 2 because map is (char,attrib) x 80 
		; hl = $6000+x
		pop 	de
		ld 		a,e
		ld 		e,160
		mul 	d,e		; mul 160 because map is 2 x 80 
		add 	hl,de
		pop 	af						; get char to print 
		ld 		(hl),a
		inc 	hl
		pop 	af			; get colour 
		; SWAPNIB 
		and 	%01111111
		rlca; : and %11111110
		ld 		(hl),a
outme:
		exx : push hl : exx 
		end asm 	
end sub   


Sub fastcall CopyToBanks(startb as ubyte, destb as ubyte, nrbanks as ubyte, copylen as uinteger)
 	asm 
		exx : pop hl : exx 
		; a = start bank 			

		call 	_checkints
		;di 
		ld 		c,a 					; store start bank in c 
		pop 	de 						; dest bank in e 
		ld 		e,c 					; d = source e = dest 
		pop 	af 
		ld 		b,a 					; number of loops 
		pop 	hl						; get copy length
		ld 		(copysize+1),hl 			; SMC for LDIR copy length 

		copybankloop:	
		push 	bc
		push 	de 
		ld 		a,e
		nextreg $50,a
		ld 		a,d
		nextreg $51,a 

		ld 		hl,$0000
		ld 		de,$2000
copysize:		
		ld 		bc,$2000
		ldir 
		pop 	de
		pop	 	bc
		inc 	d
		inc 	e
		djnz 	copybankloop
		
		nextreg $50,$ff : nextreg $51,$ff
		;ReenableInts
		exx : push hl : exx : ret 

 	end asm  
end sub  


' Going to need a pattern buffer? 
pattern_buffer:
asm
	pattern_buffer:
	;        0             1              2             3
	; 
	;  _____byte 1_____   byte2_    _____byte 3_____   byte4_
	; /                \ /      \  /                \ /      \
	; 0000          0000-00000000  0000          0000-00000000
	; 
	; Upper four    12 bits for    Lower four    Effect command.
	; bits of sam-  note period.   bits of sam-
	; ple number.                  ple number.


	; D-0 -- ----	D-0 -- ----	D-0 -- ----	D-0 -- ----
	; 0 1 23 4567    8 bytes per channel row * 4 = 32 bytes per line * 64 line = 2048
	db 		"00000000","11111111","22222222","33333333"
	defs 	2048,'0'
end asm 


string_temp:
asm 
	string_temp:
			defs 80,0
end asm 


sub GetArray(memory_pointer as uinteger,string_position as uinteger)
    ' expects a pointer to the Array to use and position to get the element
    ' this routine will set ArrayStr$ to the element string on exit 
    ' 
    asm 
        ; BREAK 
        ; on entry 
        ; (ix+4/5)= memory pointer 
        ; 6/7 = string position 


        ld      c, (ix+6)                   ; element offset 
        ld      b, (ix+7)
        
        ld      a, (hl)                      ; get desired bank 
        nextreg MMU0_0000_NR_50, a           ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a           ; set next bank 
        ld      hl, 0                        ; start at 0     

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

        ld      de, ._ArrayStr              ; point to ArrayStr$ pointer
        ex      de, hl                      ; swap 
        call    .core.__STORE_STR           ; store in ArrayStr$

    gempty_array_position: 

        ; hl should be the exit string pointer 

        nextreg MMU0_0000_NR_50, $ff        ; return rom banks 
        nextreg MMU1_2000_NR_51, $ff 

        jr      _GetArray__leave

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
        ; ix+4/5)   = memory pointer 
        ; 6/7       = array string 
        ; 8/9       = string position 

        ld      l, (ix+6)                   ; get string in memory, 2 bytes = length 
        ld      h, (ix+7)
        ld      (array_str_length), hl      ; store 
        
        ld      l, (ix+4)                   ; get array pointer address  
        ld      h, (ix+5)
        
        ; now we want to put our string    

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
        nextreg MMU0_0000_NR_50, a 
        inc     a 
        nextreg MMU1_2000_NR_51, a 
        ld      (array_patch_bank+1), a     ; store last bank 
        ld      h, 0 

    skip_remapping:
        ; now loop to 
        jr      find_array_next_free_element    

    empty_array_position:

        ; hl = next free element + 2 
        dec     hl 
        dec     hl 
        ; now we can copy the element 
        ex      de, hl  
        ld      hl, (array_str_length)          ; point de to string 
        ld      a, (hl)                         ; get the size into bc
        ld      c, a                            
        ld      (de), a                         ; save it in de - max size so far is 255
        inc     de                              ; move two bytes along 
        inc     hl 
        ld      a, (hl)                             
        ld      b, a                            ; bc now is length of string 
        ld      (de), a 

        ld      b, (hl)
        inc     de 
        inc     hl 
        ldir                                    ; copy the string into the array 
        
    max_position_reached:

        nextreg MMU0_0000_NR_50, $ff            ; restore banks
        nextreg MMU1_2000_NR_51, $ff 

    end asm 

    Return 

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
        ; this is array number 1
        asm_array:
        ; start bank, map address 
        db      $24
        dw      $0000

    end asm 
