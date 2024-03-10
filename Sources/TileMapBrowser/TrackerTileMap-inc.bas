

dim 	pat_p	as ubyte 

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
		ld 		d,80							; text map is 160 bytes wide (tile + attribute * 80)
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
