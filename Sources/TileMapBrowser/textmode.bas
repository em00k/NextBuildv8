'!org=24576
'#!asm 
'!heap=512
'!copy=h:\tiletest.nex
' NextBuild Layer2 Template 

#define NEX 

#include <nextlib.bas>

asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11        ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$1    ; black 
    nextreg CLIP_TILEMAP_NR_1B,0                        ; Tilemap clipping 
    nextreg CLIP_TILEMAP_NR_1B,159
    nextreg CLIP_TILEMAP_NR_1B,0
    nextreg CLIP_TILEMAP_NR_1B,255
    NextReg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000        ; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_CONTROL_NR_6B,%11001001				; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_BASE_ADR_NR_6E,$44				    ; tilemap data $6000
    NextReg TILEMAP_GFX_ADR_NR_6F,$40				    ; tilemap blocks 4 bit tiles $4000
    NextReg PALETTE_CONTROL_NR_43,%00110000				; pick the tilemap palette 
	di 
end asm 

dim c,b,y as ubyte 
dim x as uinteger

zx7Unpack(@palettezx7,$4000)                                    ' 'LoadSD("out.pal",$7000,512,0)
PalUpload($4000,64,0)											' upload the palette 
zx7Unpack(@fontzx7,$4000)                                       ' 'LoadSD("font.bin",$4000,4096,0) '; font 
ClearTilemap() 

c = 0

do 
	for x = 0 to 31
	TextBlock(0,y,"NEXTLIB TILEMAP CONTROL WITH BORIELS ZX BASIC COMPILER ",c)
	c=c+1 : if c = 32 : c = 0 : endif 
	y=y+1 : if y = 31 : y = 0 : endif
	next 
	'WaitRetrace2(253)
loop 


sub TextBlock(txx as ubyte, tyy as ubyte, helptextin as string, col as ubyte)

	asm 
		; cant be fast call due to bug in freeing string 
		push namespace textblock 
		;BREAK 
		add a,a
		ld (xpos+1),a 						; save the xpos 
		ld a,(ix+7)
		and 31 								; line 32 is max line 
		ld e,a 								; save in e 
		ld hl,$4400 						; point hl to start of textmap area 
		ld d,160							; text map is 160 bytes wide (tile + attribute * 80)
		mul d,e  							; multiply this with the ypos 
		add hl,de 							; add to start of textmap 
	xpos:
		ld a,0								; xpos set with smc 
		add hl,a 							; add to hl 
		ex de,hl 							; swap hl into de 
		ld h,(ix+9)							; get string address off ix 
		ld l,(ix+8)
		ld b,(hl)							; save string len in b
		add hl,2 
		ld a,(ix+11) 						; get colour
		ld (col+1),a 						; save with smc 
	lineloop:
		push bc 							; save loop size 
		ldi 								; copy hl to de then inc both  
	col:
		ld a,0								; colour set with smc 
		and %01111111						; and 6 bits 
		rlca								; rotate left 
		ld (de),a 							; save in attribute location 
		inc de 								; inc de
		pop bc								; get back string len 
		djnz lineloop 						; repeat while b<>0
	done: 
		pop namespace
	
	end asm 

end sub 

' sub  TextBlock(txx as ubyte, tyy as ubyte,byref helptextin as string,byval col as ubyte)

' 	asm 
		
' 		exx : pop hl : exx 					; save return address 
' 		push namespace textblock 
' 		ld (xpos+1),a 						; save the xpos 
' 		pop af 								; get y pos off stack 
' 		and 31 								; line 32 is max line 
' 		ld e,a 								; save in e 
' 		ld hl,$4400 						; point hl to start of textmap area 
' 		ld d,160							; text map is 160 bytes wide (tile + attribute * 80)
' 		mul d,e  							; multiply this with the ypos 
' 		add hl,de 							; add to start of textmap 
' 	xpos:
' 		ld a,0								; xpos set with smc 
' 		add hl,a 							; add to hl 
' 		ex de,hl 							; swap hl into de 
' 		pop hl 								; get string byref 
' 		ld a,(hl)							; convert ref to address 
' 		inc hl 
' 		ld h,(hl)
' 		ld l,a 
' 		ld b,(hl)							; save string len in b
' 		add hl,2 
' 		pop af 								; get colour
' 		ld (col+1),a 						; save with smc 
' 	lineloop:
' 		push bc 							; save loop size 
' 		ldi 								; copy hl to de then inc both  
		
' 	col:
' 		ld a,0								; colour set with smc 
' 		and %01111111						; and 6 bits 
' 		rlca								; rotate left 
' 		ld (de),a 							; save in attribute location 
' 		inc de 								; inc de
' 		pop bc								; get back string len 
' 		djnz lineloop 						; repeat while b<>0
' 	done: 
' 		exx : push hl : exx 				; pop back return address 
' 		pop namespace
' 		;ret 								; ret 

	
' 	end asm 

' end sub 

sub ClearTilemap()
	asm 
		ld hl,$4400
		ld de,$4401
		ld bc,2560*2
		ld (hl),0
		ldir 
	end asm 
end sub 

sub fastcall UpdateMap(ux as ubyte, uy as ubyte, uv as ubyte, ucol as ubyte)
	asm 
		 
		exx : pop hl : exx 
		ld hl,$4400 : add a,a : ADD_HL_A		; add x * 2 because map is (char,attrib) x 80 
		; hl = $6000+x
		pop de : ld a,e : ld e,160 : MUL_DE		; mul 160 because map is 2 x 80 
		add hl,de : pop af						; get char to print 
		ld (hl),a : inc hl : 	pop af			; get colour 
		; SWAPNIB 
		and %01111111
		rlca; : and %11111110
		ld (hl),a
outme:
		exx : push hl : exx 
		end asm 	
end sub   

Sub fastcall CopyToBanks(startb as ubyte, destb as ubyte, nrbanks as ubyte)
 	asm 
		exx : pop hl : exx 
		; a = start bank 			

		call _checkints
		;di 
		ld c,a 						; store start bank in c 
		pop de 						; dest bank in e 
		ld e,c 						; d = source e = dest 
		pop af 
		ld b,a 						; number of loops 

		copybankloop:	
		push bc : push de 
		ld a,e : nextreg $50,a : ld a,d : nextreg $51,a 
		ld hl,$0000
		ld de,$2000
		ld bc,$2000
		ldir 
		pop de : pop bc
		inc d : inc e
		djnz copybankloop
		
		nextreg $50,$ff : nextreg $51,$ff
		;ReenableInts
		exx : push hl : exx : ret 

 	end asm  
end sub  

fontzx7:
asm 
	incbin ".\data\topan.fnt.zx7"
	defs 6,0
end asm 

palettezx7:
asm 
	incbin ".\data\mm.pal.zx7"
	defs 6,0
end asm   