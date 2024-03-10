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

dim ab as uinteger = 320
dim ah as ubyte at @ab+1
dim al as ubyte at @ab

dim b as ubyte = 0 
dim c as ubyte = 0
dim dir as ubyte = 0 
dim ldir as ubyte = 0 

dim k  as uinteger
dim px  as uinteger  = 60
dim py  as ubyte  = 164
dim timer as ubyte = 0 
dim cframe as ubyte = 0 
dim button as ubyte = 0 
dim p_anime as ubyte = 0 
dim jump_mode as ubyte = 0 
dim jump_pos as ubyte = 0 

UpdateSprite(px,py,0,0,0,0)

ab = 0

do 
    WaitRetrace2(192)
    border 2

    ' check keys 
    k = GetKeyScanCode()
    button = 0 

    if k = KEYP or in 31 band 1 = 1 : button = 1 : endif 
    if k = KEYO or in 31 band 2 = 2 : button = 2 : endif 

    if button = 1       ' right / P 
        dir = 1
       
    elseif button = 2   ' left / O 
        dir = 0 

    elseif button = 0 
        ' slow down to a stop  
        if c>=8
            c = c - 8
            if c>250: c=0:endif
        else 
            p_anime = 0
            cframe = 0 
        endif 
        if ab > 64
            ab = ab - 64
            p_anime = 0
            cframe = 1
        elseif c = 0 
            ab = 0 
        endif 
        if ah=0 : ab = 0 : endif 
    endif 

    if button > 0 
        if c < 64 and jump_mode =0 
            c = c + 2
            
        endif 
        if ah=0 : ah = 1 : endif 
        p_anime = 1
    endif 

    if MultiKeys(KEYSPACE) or in 31 band 16 = 16 

        if jump_mode = 0 and jump_pos = 0 
            jump_mode=1 
            cframe = 3
        endif 

    endif 

  '  TextLine(0,4,str(ah)+"."+str(cast(ubyte,ab))+"   ",3)
  '  TextLine(0,5,str(ah)+"."+str(cast(ubyte,ab))+"   ",3)
  '  TextLine(0,5,str(c)+" ",3)
  '  TextLine(0,6,str(py)+" ",3)

    if jump_mode > 0 
        if jump_pos < 32
            jump_pos=jump_pos + 1 
            py = py + peek(@jump_table+cast(UINTEGER, jump_pos>>1))
            p_anime = 0 
            cframe = 1
        elseif jump_pos=32
            if MultiKeys(KEYSPACE) = 0
                jump_pos = 0 
                jump_mode = 0 
            endif 
        endif
    endif 

    if py <= 191
        py = py + 2
    endif 

    border 3

    if ldir <> dir 
        c = 0 
        border 7
    endif 

    if p_anime = 1 
        if timer = 0
            timer = 5-ah
            cframe = 1 - cframe
        else 
            timer = timer - 1 
        endif 
        p_anime = 0 
    endif 

    border 4
    domovement()
    border 5 

    ldir = dir 

    if dir = 1 
        px = px + ah
    else
        px = px - ah
    endif 

    border 0 
    UpdateSprite(px,py,0,cframe,8-(dir<<3),0)

loop 

border ab + c + b +dir 

jump_table:

asm 
   ; db  -8,-8,-6,-6,-5,-4,-3,-2,-1,1,0
    db  -16,-10,-7,-4,-3,-2,-1,-1,-1,1,2,3,4,0,0,0,0,0,0,0
end asm 



sub fastcall domovement()

    asm 
        ;   128 64 32 16 8 4 2 1 . 1/2 1/4 1/8 1/16 1/32 1/64 1/128 1/256
        ;       h                   l 
        ;     BREAK 
        ld          ix, (._ab)          ; get the value of ab 16bit 
        ld          a, (._c)            ; add value 
        add         a, ixl              ; add to xb 
        ld          ixl, a              ; save back nb 
        ;    BREAK 
        jr          nc, norollover      ; did > 255 ?  no then goto norolover 
        ld          a, ixh 
        cp          4
        jr          z, norollover
        inc         ixh     

        norollover:    

        ld          (._ab), ix            ; store new value 
        ret 
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