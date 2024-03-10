'!org=25088
'asm
'!copy=h:\fixed.nex
' NextBuild Layer2 Template 

#define NEX 
#define IM2 

#include <nextlib.bas>
#include <keys.bas>

asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg CLIP_TILEMAP_NR_1B,0                        ; Tilemap clipping 
    nextreg CLIP_TILEMAP_NR_1B,159
    nextreg CLIP_TILEMAP_NR_1B,0
    nextreg CLIP_TILEMAP_NR_1B,255
    NextReg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000        ; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_CONTROL_NR_6B,%11001001				; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_BASE_ADR_NR_6E,$44				    ; tilemap data $6000
    NextReg TILEMAP_GFX_ADR_NR_6F,$40				    ; tilemap blocks 4 bit tiles $4000
    NextReg PALETTE_CONTROL_NR_43,%00110000
end asm 

LoadSDBank("DKSprite.spr",0,0,0,25)

zx7Unpack(@palettezx7,$4000)                                    ' 'LoadSD("out.pal",$7000,512,0)
PalUpload($4000,0,0)
zx7Unpack(@fontzx7,$4000)                                       ' 'LoadSD("font.bin",$4000,4096,0) '; font 
ClearTilemap() 
InitSprites2(64,0,25)

dim ab as uinteger = 0
dim b = 0 
dim c = 0
dim dir = 0 

dim px  as uinteger  = 60
dim py  as uinteger  = 164


UpdateSprite(px,py,0,0,0,0)

ab = px << 8 

do 
    WaitRetrace2(192)

    if GetKeyScanCode()=KEYP 
        dir = 1
        if c < 256-8
            c = c + 8
        endif 
    elseif GetKeyScanCode()=KEYO
        dir = 0 
        if c < 256-8
            c = c + 8
        endif 
    elseif GetKeyScanCode()=0 
        if c>=8
            c = c - 8
        endif 
    endif 

    TextLine(0,4,str(ab>>8)+"."+str(cast(ubyte,ab))+"   ",3)
   ' ' TextLine(0,5,str(b)+" ",3)
    TextLine(0,6,str(c)+" ",3)
    
    asm 
        ;   128 64 32 16 8 4 2 1 . 1/2 1/4 1/8 1/16 1/32 1/64 1/128 1/256
        ;       h                   l 
    ;     BREAK 
        ld          ix, (._ab)          ; get the value of ab 16bit 
        ld          a, (._c)
        add         a, ixl 
        ld          ixl, a 
    ;    BREAK 
        jr          nc, norollover      ; > 255 ?  no then goto norolover 
        ld          a, (._dir)
        or          a                   ; left 
        jr          z, moveright 
        inc         ixh     
        jr          norollover
    moveright:
        dec         ixh 
    norollover:    
        
        ld          (._ab), ix            ; store new value 

    end asm 

    UpdateSprite(px,py,0,0,0,0)

    b=b+1 
loop 

border ab + c + b +dir 



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
		ld 		hl,$44*256			            ; point hl to start of textmap area 
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

		ld      hl,$4400                ; tm start address 
        add     a,a                     ; add x * 2 because map is (char,attrib) x 80 
        add     hl, a	
		pop     de                      ; get the X in e 
        ld      a,e
        ld      e,160
        mul     d,e 		            ; mul 160 because map is 2 x 80 

		add     hl,de 
        pop     af						; get char to print 
		
        ld      (hl),a 
        inc     hl                      ; move along 
        pop     af			            ; get colour 
		
        and     %01111111
		rlca
		ld      (hl),a                  ; write the attrib 

outme:
		exx : push hl : exx 
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