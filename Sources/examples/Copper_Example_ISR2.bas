'!ORG=32768
' quick example for parallax scrolling using the copper 
' emk20

border 0 	
#define CUSTOMISR
#define IM2	
#define NOAYFX
#include <nextlib.bas>
		
asm 
	nextreg TURBO_CONTROL_NR_07,3						; 28mhz 
	nextreg PALETTE_VALUE_NR_41,0						;   trans black 
	nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0			; trans black 
	nextreg ULA_CONTROL_NR_68,%10010000					; ULA CONTROL REGISTER disable ula 
	NextReg SPRITE_CONTROL_NR_15,%00010011				; sprites on border, SUL 
	nextreg PERIPHERAL_3_NR_08,%01001010                ; disable ram contention, enable specdrum, turbosound
	nextreg LAYER2_RAM_BANK_NR_12,16
end asm        

paper 0 : ink 7 : flash 0 : border 0 : cls 

ShowLayer2(1)
LoadBMP2("amiga3256.bmp")						

dim a,b,c,flap,timername,timername2 as ubyte 
dim add,copperx,coppery as uinteger 
a = 0
b=0

SetUpIM()                           ' Call the interrupt setup, which will call MyCustomISR()
ISR()                               ' Call the ISR once 
SetCopper()						    ' init the copper 

do 
	WaitRetrace(1)

loop 
a=peek(coppery)
sub MyCustomISR()
    ' add = x  offset 
    ' add+2 = line to
    flap = 1 - flap 
    add=@firstindex+1						' point to the bit in the copper data we want to adjust 
    b=9
    for l = 0 to 22
        position(a,c,90,cast(uinteger,l))
        poke add,cast(ubyte,copperx)<<2
   
        poke add+2,(b+(l<<2))	
        add=add+4
       ' b=b+16
       if  timername =  4
           ' timer triggered 
            timername = 0
            a=a+1
       else 
            timername =  timername + 1 
       endif 
       if  timername2 =  8
           ' timer triggered 
            timername2 = 0
            c=c+1
       else 
            timername2 =  timername2 + 1 
       endif        
    next l 
    ' b = 9 
    ' for l = 11 to 22
    '     position(90,a,90,cast(uinteger,l))
    '     poke add,cast(ubyte,copperx) 
   
    '     poke add+2,(b+(l<<3))	
    '     add=add+4
    '     b=b+16
    '     a=a+1  	
    ' next l 
    SetCopper()							' rerun the copper 
    							' general x offset 
    
end sub

sub SetCopper()

' WAIT	 %1hhhhhhv %vvvvvvvv	Wait for raster line v (0-311) and horizontal position h*8 (h is 0-55)
' MOVE	 %0rrrrrrr %vvvvvvvv	Write value v to Next register r
' https://wiki.specnext.dev/Copper

	NextReg($61,0)	' set index 0
	NextReg($62,0)	' set index 0

	asm 
	
	ld hl,copperdata						; ' coppper data address 
	ld b,endcopperdata-copperdata ;' length of data to upload

copperupload:
	ld a,(hl)										; put first byte of copper buffer in to a 
	dw $92ED										; nextreg a, sends a to 
rval:	
	DB $60										  ; this register, $60 = copper data 
	inc hl											; and loop 
	djnz copperupload

end asm							
	
	'NextReg($61,%00000000)
	NextReg($62,%11000000)


end sub 
 
asm: 	
copperdata:
	; ' T+V h  v  r  pal val 
	; ' h = horizontal line, v vertical , r = reg , pal = 
	;%1hhhhhhv 
	
	; WAIT 0,0 
	index equ 0
	regxoffset equ $16
	
	db %10000000,0						; 1HHHHHHV VVVVVVVV
	db 0,0
	
	db %11001000,0

end asm 
firstindex: 
asm 
	db regxoffset,129               ; scr offset 
	db %11001000,16                 ; line 
	db regxoffset,65
	db %11001000,32
	db regxoffset,33
	db %11001000,48
	db regxoffset,1
	db %11001000,64
	db regxoffset,1
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,140
	db regxoffset,0
	db %11001000,254
	db regxoffset,161
	db $ff,$ff

endcopperdata:	
end asm 

Sub ConvertRGB(byval bank as ubyte)

	asm 
		PROC 
		LOCAL tstack, outstack , outbank, convertout, nbpalhl
			di 
			ld (outstack+1),sp
			ld sp,tstack
			push ix 
			push af  
			getreg($52)						; a = current $4000 bank 
			ld (outbank+3),a 					; 
			pop af 
			nextreg $52,a 
		
remapcolours:
			nextreg $43,%00010001
			nextreg $40,0
			; ld (palfade),a 							; number of shifts for fade def = 5
			ld c,a 									; store this in c  
			ld hl,$4000								; get hl = start of palette, RGB format. 
			;ld de,palettenext 						; where to put our next palette 
			ld b,0									; number of entries to walk through
			
indexloop:
			push bc 								; save our loop counter on stack 
			push de 								; save our next palette addres 

			ld a,(hl)
			; ' BLUE 
			; b9>>5
			
			ld d,0 : ld e,a : ld b,5 : bsrl de,b 	; b9>>5
			ld a,e : ld (tempbytes+2),a 			; store at tempbytes+2
			
			inc hl : ld a,(hl)						; more to green byte put in a 
		
			; ' GREEN 
			; ((g9 >> 5) << 3)
			
			ld d,0 : ld e,a : ld b,5 : bsrl de,b 	; g9>>5
			ld b,3 : bsla de,b : ld a,e 			; << 3
			ld (tempbytes+1),a 						; store at tempbytes+1
		
			inc hl 									; move to next bit 

			; ' RED 
			; ((r9>>5) << 6)
			
			ld d,0 									; make sure d = 0 
			ld e,(hl)								; get red in to hl 
			ld b,5									; shift right c times 
			bsrl de,b  								; r9>>5
			ld b,6									; and right 
			bsla de,b 								; << 6
			push de 								; result will be 16bit, store on stack 
		
			inc hl : inc hl 						; move to next rgb block 
			
			; now OR r16 g8 b8, hl = red16, de points to green/blue bytes 
			exx  									; use shadow regs 
			pop hl 									; pop back red from stack into hl  
			ld de,(tempbytes+1)						; point de to green and blue 
			ld a,l	
			or d 									; or e & l into a 
			or e									; or d & a into a 
			ld l,a 									; put result in a 
			ld (nbpalhl+1),hl						; store at nb_pal_hl 
		
			exx										; back to normal regs 
			pop de 									; pop back palette address 
			push hl 								; save hl as its the offset into rgb palette 
			
nbpalhl:
			ld hl,0000								; smc from above 
			ld b,l 
			srl h 									; shift hl right 
			rr l 
			ld a,l 									; result in a 
			 
			nextreg $44,a
			ld (de),a 								; store first byte into or nextpalette ram 
			inc de 								; us commented out but could be used 
			; next byte 						 	; 
			ld a,b   
			and 1								; and 1 and store blue bit 
			ld (de),a 
			inc de 								; move de to next byte in memory 
			nextreg $44,a 
			 
			pop hl 									; get back the rgb palette address 
			pop bc									; get loop counter back 
		
			djnz indexloop		

outbank:
			nextreg $52,0
			pop ix 
outstack: 
			ld sp,0
			
			jp convertout		
tempbytes:
			dw 0,0
space:
			ds 8
tstack: 	db 0 		
convertout:
		
		ENDP 
	
	end asm 

end sub 

sub LoadBMP2(byval fname as STRING)

	'dim pos as ulong
	
	'pos = 1024+54+16384*2

	asm 
		PROC 
		LOCAL outstack, eosadd, outbank, loadbmploop, flip_layer2lines, copyloop, decd
		LOCAL startoffset, L2offsetpos, thandle, offset, loadbmpend
			di 
			push ix  
			getreg($52)						; a = current $4000 bank 
			ld (outbank+3),a 					; 
			ld a,(IX+7)
			ld (flip),a 
			;
			; hl address 
			ld a,(hl)
			add hl,2 
			push hl		
			add hl,a 
			ld (eosadd+1),hl
			ld a,(hl)
			ld (eosadd+4),a  
			ld (hl),0 
			pop ix 
		
			ld a, '*' 						; use current drive
			ld b, FA_READ 					; set mode
			ESXDOS : db F_OPEN 	
			; a = handle 	
			ld (thandle),a 	
			getreg($12) 						; get L2 start 
			add a,a 	
			ld (startbank),a 					; start bank of L2 
			ld b,7							; loops 8 times 
			ld c,a 
		
loadbmploop:
			ld a,c							; get the bank in c and put in a 
			nextreg $52,a					; set mmu slot 2 to bank L2bank ($4000-5fff)
			inc c	
			push bc 
			
			; now seek 
			ld a,(thandle)
			ld ixl,0 
			ld l,0 
			ld bc,0
			ld de,(L2offsetpos)
			ESXDOS : db F_SEEK
			
			; now read 
			ld a,(thandle)
			ld ix,$4000
			ld bc,$2000
			ESXDOS : db F_READ 
			
			;ld a,(flip)
			;or a 
			call flip_layer2lines
			
			ld hl,(L2offsetpos)
			ld de,$2000	
			sbc hl,de
			ld (L2offsetpos),hl
			
			pop bc 
			djnz loadbmploop 
			
			ld a,(thandle)
			ESXDOS : db F_CLOSE
			
			ld hl,startoffset
			ld (L2offsetpos),hl 
			
outbank:
			nextreg $52,0
eosadd:
			ld hl,000
			ld (hl),0 
			pop ix 
outstack: 
		;	ld sp,0
			
			jp loadbmpend

flip_layer2lines:
	
			; $4000 - $5fff Layer2 BMP data loaded 
			; the data is upside down so we need to flip line 0 - 32
			; hl = top line first left pixel, de = bottom line, first left pixel 
			ld hl,$4000 : ld de,$5f00 : ld bc,$1000
	
copyloop:	
			ld a,(hl)						; hl is the top lines, get the value into a
			ex af,af'						; swap to shadow a reg 
			ld a,(de)						; de is bottom lines, get value in a 
			ld (hl),a						; put this value into hl 
			ex af,af'						; swap back shadow reg 
			ld (de),a 						; put the value into de 
			inc hl							; inc hl to next byte 
			inc e							; only inc e as we have to go left to right then up with d 
			ld a,e							; check e has >255
			or a							
			call z,decd					; it did do we need to dec d 
			dec bc							; dec bc for our loop 
			ld a,b							; has bc = 0 ?
			or c
			jp nz,copyloop					; no carry on until it does 
			ret 
decd:
			dec d 							; this decreases d to move a line up 
			ret					

startoffset equ 1078+16384+16384+8192		
		
L2offsetpos:
			dw startoffset
	
startbank:
			db 32
			db 0 
flip: 		db 0 
			
thandle:
			db 0 
offset:	
			dw 0 
loadbmpend:
		ENDP 
	end asm 
			
end sub  

sub position(angle as ubyte, radius as ubyte, x as uinteger, y as uinteger) 
    asm
        ;  ----------------------------------------------------------------------
        ;  position on the edge of a circle
        ; 
        ;  input    a,angle
        ;  input    h,radius
        ;  input    bc y center of the circle
        ;  input    de x center of the circle
        ;  output    bc x position on the circle
        ;  output    de y position on the circle
        ; 
        ;  dirty everything
        ; ----------------------------------------------------------------------
        ; a = angle 
        ;BREAK 

        ld h,a 
        ld a,(ix+7)         ; radius 
        ld (radius),a 
        ld a,h

        ld b,(ix+11)
        ld c,(ix+10)         ; x 
        ld d,(ix+9)
        ld e,(ix+8)        ; y 

        call posOnCircle
        ;ld a,c 
        ld (._copperx),bc
        ;ld a,e  
        ld (._coppery),de 
        jp posOnCircleEnd

        posOnCircle:  
            cp  64              ;  ae we less than 64
            jp  m,jumpparta        ;  yes but for some reason its not right so we will need another check
            cp  128             ;  are we between 64 and 128
            jp  m,jumppartb      ;  yup
            cp  192             ;  are we between 128 and 192
            jp  m,jumppartc     ;  yarp so do that code
            ret
        jumppartd:  
            push  bc            ;  save the x center
            sub  192            ;  take off 192 making it 0-64
            ld  b,a             ;  now reverse the angle 
            ld  a,64            ;  making it
            sub  b              ;  64-0
            push  de            ;  save the y center  
            call  getSinCos     ;  get the cos and sin for this angle
            pop  hl             ;  get the y center  
            ; sub  hl,bc          ;  take y center from the cos result  
            or a : sbc hl,bc
            ; ld  bc,hl           ;  and stick it in y return pos
            ld b,h : ld c,l
            pop  hl             ;  now get the x center
            add  hl,de          ;  add the sin result 
           ; ld  de,hl           ;  stick it in the x return pos
            ld d,h : ld e,l 
            ret                 ;  and return
        jumppartc:  
            sub  128  
            push  bc    
            push  de        
            call  getSinCos      ;  get the cos and sin for this angle
            pop  hl             ;  get the y center
            ; sub  hl,bc          ;  take y center from the cos result  
            or a : sbc hl,bc
            ; ld  bc,hl           ;  and stick it in y return pos
            ld b,h : ld c,l
            pop  hl             ;  now get the x center
            ; sub  hl,de          ;  take off the sin result 
            or a : sbc hl,de
            ; ld  de,hl           ;  stick it in the x return pos
            ld d,h : ld e,l 
            ret  
        jumppartb:    
            push  bc
            sub  64
            ld  b,a
            ld  a,64
            sub  b  
            push  de        
            call  getSinCos     ;  get the cos and sin for this angle
            pop  hl             ;  get the y center  
            add  hl,bc          ;  add y center to the cos result  
            ; ld  bc,hl           ;  and stick it in y return pos
            ld b,h : ld c,l
            pop  hl             ;  now get the x center
            ; sub  hl,de          ;  take off the sin result  
            or a : sbc hl,de
            ; ld  de,hl           ;  stick it in the x return pos
            ld d,h : ld e,l 
            ret  
        jumpparta:    
            bit  7,a            ;  test to see if its negative by bit testing bit 7
            jp  nz,jumppartd  
            push  bc    
            push  de        
            call  getSinCos     ;  get the cos and sin for this angle
            pop  hl             ;  get the y center    
            add  hl,bc          ;  add y center to the cos result
            ; ld  bc,hl           ;  and stick it in y return pos
            ld b,h : ld c,l
            pop  hl             ;  now get the x center
            add  hl,de          ;  add the sin result   
            ; ld  de,hl           ;  stick it in the x return pos
            ld d,h : ld e,l 
            ret
        ; ----------------------------------------------------------------------
        ;  calculate the x y pos
        ; ----------------------------------------------------------------------
        getSinCos:  
            call  sinp           ;  get the sin(angle) in e
            ld  hl,radius    
            ld  d,(hl)          ;   radius
            mul  d,e            ;  multiply sin by the radius    
            ld  b,6             ;  2.6 fixed point 
            bsrf  de,b          ;  do down shift the result
            push  de            ;  save x pos
            call  cosp           ;  get the cos(angle) in e
            ld  hl,radius    
            ld  d,(hl)          ;  radius
            mul  d,e            ;  multiply sin by the radius    
            ld  b,6             ;  2.6 fixed point 
            bsrf  de,b          ;   do down shift the result
            pop  bc             ;  get the x pos
            ret  
    
    radius:    db  3

    posOnCircleEnd:
    end asm
end sub 




Sprites:
asm 
Plane1:
	db  $E3, $E3, $E3, $E3, $E3, $00, $92, $B6, $B6, $00, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $92, $92, $FF, $FF, $B6, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $92, $B6, $B6, $FF, $B6, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $00, $00, $00, $00, $92, $BB, $12, $BB, $B6, $00, $00, $00, $00, $E3, $E3;
	db  $00, $92, $92, $92, $92, $92, $12, $12, $12, $DA, $B6, $B6, $B6, $B6, $00, $E3;
	db  $92, $92, $B6, $B6, $6D, $92, $B6, $B6, $FF, $DA, $B6, $B6, $FF, $FF, $B6, $00;
	db  $92, $B6, $B6, $B6, $6D, $92, $B6, $B6, $FF, $DA, $B6, $B6, $B6, $B6, $92, $00;
	db  $00, $92, $B6, $B6, $6D, $92, $B6, $B6, $FF, $DA, $B6, $92, $92, $92, $00, $E3;
	db  $E3, $00, $00, $00, $92, $92, $B6, $B6, $B6, $92, $92, $00, $00, $00, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $6D, $92, $BB, $B6, $6D, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $00, $92, $B6, $B6, $00, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $00, $00, $92, $00, $00, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $00, $92, $B6, $6D, $B6, $B6, $B6, $B6, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $00, $92, $92, $B6, $6D, $B6, $B6, $B6, $B6, $B6, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $00, $00, $00, $92, $92, $B6, $00, $00, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $00, $92, $00, $E3, $E3, $E3, $E3, $E3, $E3, $E3;



Plane2:
	db  $E3, $E3, $E3, $E3, $E3, $00, $80, $A0, $A0, $00, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $80, $80, $FF, $A0, $60, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $80, $B6, $B6, $FF, $60, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $00, $00, $00, $00, $80, $BB, $12, $BB, $60, $00, $00, $00, $00, $E3, $E3;
	db  $00, $80, $80, $80, $80, $80, $12, $12, $12, $80, $A0, $A0, $A0, $A0, $00, $E3;
	db  $80, $80, $A0, $A0, $60, $80, $A0, $A0, $C0, $80, $A0, $A0, $FF, $FF, $A0, $00;
	db  $80, $A0, $A0, $A0, $60, $80, $A0, $A0, $C0, $80, $A0, $A0, $A0, $A0, $80, $00;
	db  $00, $80, $A0, $A0, $60, $80, $A0, $A0, $C0, $80, $A0, $80, $80, $80, $00, $E3;
	db  $E3, $00, $00, $00, $80, $80, $A0, $A0, $A0, $80, $80, $00, $00, $00, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $60, $80, $BB, $A0, $60, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $00, $80, $A0, $A0, $00, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $00, $00, $80, $00, $00, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $00, $80, $A0, $60, $A0, $A0, $A0, $A0, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $00, $80, $80, $A0, $60, $A0, $A0, $A0, $A0, $A0, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $00, $00, $00, $80, $80, $A0, $00, $00, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $00, $80, $00, $E3, $E3, $E3, $E3, $E3, $E3, $E3;



Plane3:
	db  $E3, $E3, $E3, $E3, $E3, $00, $90, $0C, $10, $00, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $90, $90, $FF, $10, $10, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $90, $B6, $B6, $FF, $10, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $00, $00, $00, $00, $90, $BB, $12, $BB, $10, $00, $00, $00, $00, $E3, $E3;
	db  $00, $90, $90, $90, $90, $90, $12, $12, $12, $08, $18, $18, $18, $18, $00, $E3;
	db  $90, $C2, $C2, $D8, $90, $90, $D8, $10, $1C, $08, $18, $18, $E0, $E0, $10, $00;
	db  $90, $61, $61, $D8, $90, $90, $D8, $1C, $1C, $08, $18, $18, $80, $80, $08, $00;
	db  $00, $48, $D8, $D8, $90, $90, $D8, $10, $1C, $08, $18, $08, $08, $08, $00, $E3;
	db  $E3, $00, $00, $00, $90, $90, $D8, $1C, $18, $08, $08, $00, $00, $00, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $90, $90, $BB, $18, $10, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $00, $90, $18, $18, $00, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $00, $00, $48, $00, $00, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $00, $90, $D8, $90, $D8, $18, $18, $18, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $00, $90, $90, $D8, $90, $D8, $18, $18, $18, $18, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $00, $00, $00, $48, $48, $18, $00, $00, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $00, $0C, $00, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
end asm 

asm 
ALIGN 256
    sinTable:  
        db  $00,$02,$03,$05,$06,$08,$09,$0b,$0c,$0e
        db  $10,$11,$13,$14,$16,$17,$18,$1a,$1b,$1d
        db  $1e,$20,$21,$22,$24,$25,$26,$27,$29,$2a
        db  $2b,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$34
        db  $35,$36,$37,$38,$38,$39,$3a,$3b,$3b,$3c
        db  $3c,$3d,$3d,$3e,$3e,$3e,$3f,$3f,$3f,$40
        db  $40,$40,$40,$40,$40
    cosTable:   
        db  $40,$40,$40,$40,$40,$40,$3f,$3f,$3f,$3e
        db  $3e,$3e,$3d,$3d,$3c,$3c,$3b,$3b,$3a,$39
        db  $38,$38,$37,$36,$35,$34,$33,$32,$31,$30
        db  $2f,$2e,$2d,$2c,$2b,$2a,$29,$27,$26,$25
        db  $24,$22,$21,$20,$1e,$1d,$1b,$1a,$18,$17
        db  $16,$14,$13,$11,$10,$0e,$0c,$0b,$09,$08
        db  $06,$05,$03,$02,$02
    ; ----------------------------------------------------------------------
    ;  sin  function
    ; 
    ;  in  a   degrees
    ; 
    ;  out  e   contains the sine 2.6 format
    ; 
    ;  dirty  hl,de
    ; ----------------------------------------------------------------------
    sinp:    
        ld  h,0      ;  ;  clear the high part of hl
        ld  l,a      ;  ;  move the angle into the low part of hl
        ld  de,sinTable    ;  ;  get the base of the sin table
        add  hl,de      ;  ;  add the angle to the base to get the index into the sin Table
        ld  e,(hl)      ;  ;  get the SIN
        ret           ; ;  e contains the sine in 2.6 format
    ; ----------------------------------------------------------------------
    ;  cosine function
    ;  in  a  degrees
    ; 
    ;  out  e   contains the cosine 2.6 format
    ; 
    ;  dirty  hl,de
    ; ----------------------------------------------------------------------
    cosp:    
        ld  h,0       ; ;  clear the high part of hl
        ld  l,a        ; ;  move the angle into the low part of hl
        ld  de,cosTable      ; ;  get the base of the cos table
        add  hl,de       ; ;  add the angle to the base to get the index into the cos Table
        ld  e,(hl)       ; ;  get the COS
        ret          ; ;  e contains the sine in 2.6 format
end asm 