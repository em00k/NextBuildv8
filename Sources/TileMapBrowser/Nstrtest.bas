'!org=24576
' NextBuild Layer2 Template 

#define NEX 
#define IM2 

#include <nextlib.bas>

asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg SPRITE_CONTROL_NR_15,%00000011  ; %000    S L U, %11 sprites on over border
    nextreg LAYER2_CONTROL_NR_70,%00000000  ; 5-4 %01 = 320x256x8bpp
end asm 


sub TextLine(byval txx as ubyte,byval tyy as ubyte,helptextin as string,byval col as ubyte)

	asm 
		; cant be fast call due to bug in freeing string 
		push 	namespace TextLine 
		BREAK 
		add 	a,a
		ld 		(xpos+1),a 						; save the xpos 
		ld 		a,(ix+7)
		and 	31 								; line 32 is max line 
		ld 		e,a 							; save in e 
		ld 		hl,$44*256			; point hl to start of textmap area 
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

dim m as ubyte = 10

BBREAK
test$=NStr(m)
test$=common$
test$="HELLO "+test$

print test$
print common$ 

TextLine(0,0," "+NStr(m),0)

do 

loop 
