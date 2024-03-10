'!origin=Tracker-NXMOD-2-with-decode.bas

dim 	pat_p	as ubyte = 0 

sub RollIn()
    dim y as ubyte

    for y = 0 to 127 step 2
        NextReg(CLIP_TILEMAP_NR_1B,0)
        
        NextReg(CLIP_TILEMAP_NR_1B,255)
        NextRegA(CLIP_TILEMAP_NR_1B,127-y)
        NextRegA(CLIP_TILEMAP_NR_1B,127+y)
        
        
        NextReg(CLIP_LAYER2_NR_18,0)
        NextReg(CLIP_LAYER2_NR_18,255)
        NextRegA(CLIP_LAYER2_NR_18,127-y)
        NextRegA(CLIP_LAYER2_NR_18,127+y)
        WaitRetrace2(200)
    next y 

end sub 

sub RollOut()
    NextReg(CLIP_TILEMAP_NR_1B,0)
    NextRegA(CLIP_TILEMAP_NR_1B,0)
    NextReg(CLIP_TILEMAP_NR_1B,0)
    NextRegA(CLIP_TILEMAP_NR_1B,0)
    NextReg(CLIP_LAYER2_NR_18,0)
    NextRegA(CLIP_LAYER2_NR_18,0)
    NextReg(CLIP_LAYER2_NR_18,0)
    NextRegA(CLIP_LAYER2_NR_18,0)
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
		; ld      a,(hl)
		
		ldi 									; copy hl to de then inc both  
        
        ; sub     93
        ; ld      (de),a 
        ; inc     hl 
        ; inc     de 
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

sub fastcall TextNumber(x as ubyte, y as ubyte, value as ubyte)
    asm 
        ;   a 
        ;   y 
        ;  value on stack 
        PROC 
        LOCAL Na1, Na2, skpinc, number_buffer
         
        exx 
        pop     hl                                ; save ret address
        exx 

        pop     hl                              ; y 

        ld      l, a                            ; save a / x 

        ld      e, h                            ; mul y * 160 
        ld      d, 160 
        mul     d, e                            ; 

        ld      a, l                            ; bring back x 
        add     a, a 
        ld      hl, $4400                       ; tilemap start address
        add     hl, de                          ; add y * 160 to de 
        add     hl, a                           ; now + x 
        pop     af                              ; get value off stack 
       

        push    hl                              ; save screen address 

        ld      hl, number_buffer               ; text buffer 
        call    CharToAsc                       ; convert the chars 
        
        ld      hl, number_buffer
        pop     de                              ; screen address 

        ldi                                     ; copy to screen 
        inc     de                              ; skip attrib 
        ldi     
        inc     de 
        ldi          

        jp      _textnum_end                    ; rountine complete 


        CharToAsc:		

		; hl still pointing to pointer of memory 
		ld 		hl, number_buffer
		ld		c, -100
		call	Na1
		ld		c, -10
		call	Na1
		ld		c, -1

	Na1:

		ld		b, '0'-1

	Na2:

		inc		b
		add		a, c
		jr		c, Na2
		sub		c					; works as add 100/10/1
		push 	af					; safer than ld c,a
		ld		a, b				; char is in b

		ld 		(hl), a				; save char in memory 
		inc 	hl 					; move along one byte 

	skpinc:

		pop 	af					

		ret
    number_buffer:
        db      0,0,0,32
    _textnum_end:
        exx 
        push    hl 
        exx 
        ret 
        ENDP
    end asm 


end sub 

sub ColourRow(colour as ubyte)
	
	asm 
	
		push af 
		ld 		hl, TILE_MAPBASE*256
		;ld 		a,(._pat_p)
		ld 		a, 30-7
		ld 		d,a
		ld 		e,160
		mul 	d, e
		add		hl, 10
		add 	hl,de			; start of row
		pop 	af 				; get colour
		; SWAPNIB : and %11111000
        and 	%01111111
		ld 		b,80-20
	rowloop:		
		inc 	hl 
        ld 		a,(hl)
        xor 	32         ; adds to the colour 
		ld 		(hl),a 
		inc 	hl 
		djnz rowloop
		end asm 	

end sub

sub fastcall DrawPattern()

	asm 
		PATT_Y_OFF			equ 	160 * 31
		PATT_X_OFF			equ 	10 * 2  

		ld 		de,PATT_Y_OFF+PATT_X_OFF+(TILE_MAPBASE*256)			; start of position to draw on screen 
	
	upper_pattern:

		ld 		hl,(pattern_buffer_add)								; point to start of buffer 
		


		ld 		bc,$0100 						; draw 1 row 

	row_loop:

		push 	bc 
		
		ld		bc,$0500						; loop 4 times for each channel + 1 as ldi will cause $04FF
		
	chan_loop: 
		 
		ldi 									; copy note value to screen 
		inc 	de 								; attribute skip 

		ld 		a, '-'
		ld 		(de), a 
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

		add 	de, 4							; geuss to next line for now 

		djnz	chan_loop						; loop for each channel 

		pop 	bc 

		djnz	row_loop

		ret 
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

	end asm 
end sub 

sub DrawRownDown()
		ColourRow(0)
		' TextLine(0,0,"KEY DOWN",11)

		for yy = 0 to 7
			DrawPattern()
			AddPatterBuffer()
			ScrollPatternUp()
			lineno$=Hex16(yy)
			TextLine(5,30,lineno$(2 to ),12)
		next 

		' if pat_p <8
		' 	' ScrollPatternUp()
		' 	AddPatterBuffer()
		' 	DrawPattern()
		' 	TextLine(0,22,str(pat_p-9),12)
		' elseif pat_p< 64+16
		' 	ScrollPatternUp()
		' 	pat_p=pat_p-1 
		' 'else 
		' '	pat_p=pat_p-1 
		' endif 
		ColourRow(30-7)
end sub 

sub fastcall ScrollPatternUp()
	asm 
		ld 		hl, TILE_MAPBASE*256 + ( 20 * 160 )
		ld 		de, TILE_MAPBASE*256 + ( 19 * 160 )
		ld 		bc, 2048
		ldir
	end asm 
end sub 

asm	
	pattern_buffer_add:
		dw 		pattern_buffer
end asm 