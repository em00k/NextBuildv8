'!ORG=32768
' Event Sprite Engine 
' Part of NextBuild 
' 
' This code will manage a list of sprites and move according to defined simple movement scripts
'

#include <nextlib.bas>                                          ' inlcude the nextlib 
#INCLUDE <keys.bas>

asm
    nextreg SPRITE_CONTROL_NR_15,%00001011                     	; ' Enable sprite visibility & Sprite ULA L2 order 
    nextreg TURBO_CONTROL_NR_07,3                               ; 28 mhz 
end asm

declare FUNCTION fSin(num as ubyte) as byte                     ' declared for quick sin / cos 
declare FUNCTION fCos(num as ubyte) as byte
 
paper 0: border 0 : bright 0: ink 7 : cls                       ' paint it black 

' -- define types 
dim frame,mx,my,yy,xx,count,f as ubyte 
dim offset as fixed 
DIM add as fixed=2.799
dim cevent,scount,keypressed as ubyte 
dim vecX,vecY,dir,interia,movecar,y,control,speed,wait,d,amount as ubyte 
dim x,a,b,eventoffset as uinteger

' -- Set variables, some of this is done to prevent variables being optimized .ie scrubber
' and we may reference them in an asm block...
vecX=80:vecY=0: dir = 4 : d = 4 : cevent = 0 		
a= cast(uinteger,vecX): if vecX>250-10 : vecX = 249-10 : endif : if vecX<10 : vecX = 10 : endif 
b= cast(uinteger,vecY) : if vecY<3 : vecY = 3 : endif : if vecY>185 : vecY = 184 : endif 
x= 90 : y = 160 

' -- Init the sprite 
InitSprites(1,@Sprites) : ShowLayer2(1)
UpdateSprite(120,120,0,0,0,0)		                            ' show our sprite 

dim playersprite,spriteid,attrib3,attrib4 as ubyte

' -- Initialise Script 

SetScript(@script1)                                             ' "upload" script1 


' -- Main loop 
do  

    WaitRetrace(1)

	' input 
    ReadKeys()
    
    ' process 
	border 2
	ReadEvents()
	border 0 
	
    ' output 
    UpdateSprite(x,y,spriteid,playersprite,attrib3,attrib4)
 	
loop  

' -- Subroutines 

sub ReadKeys()
    ' process key movement 

    if GetKeyScanCode()=KEY1 and keypressed = 0 
        SetScript(@script1)
        keypressed = 1 
    elseif GetKeyScanCode()=KEY2 and keypressed = 0  
        SetScript(@script2)
        keypressed = 1 
    elseif GetKeyScanCode()=0 
        keypressed = 0 
    endif 
end sub 

sub fastcall SetScript(address as uinteger)
    ' this will copy the script from address to the event array
    asm 
        ; BREAK 
        PROC 
            LOCAL ssuploadloop
            ld de,eventarray
        ssuploadloop:
            ld a,(hl) : cp $ff : ret z 
            ldi 
            jp ssuploadloop        
        ENDP 
    end asm 


end sub 

sub ReadEvents()

	' event can be 4 byte packets.
	' 0	 control 
	'   - 0 no movement 
	' 	- 1 right 
	' 	- 2 up
	'   - 3 left 
	'   - 4 down 
	'   
	' 1	 amount 
	'		- how many times to loop 0-255 
	'
	' 2  speed 
	'		- delay before next evet 
	'
	' 3  wait 
	' 	- wait before running next event 0 - 255 
	' 
	' current event counter, will be in sprite array 
	' cevent = 0 		

	const CONT as ubyte = 0
	const AMOUNT as ubyte = 1
	const SPEED as ubyte = 2
	const WAIT as ubyte = 3
	
	
	if peek(@eventarray+1) = 0                  ' ; if second byte of array = 0 
		' first get the offset start 
		
		eventoffset = @eventarray+4+(cast(uinteger,cevent) *4)  ' we get the event
		control = peek(eventoffset)                             ' control byte 
		amount  = peek(eventoffset+1)                           ' amount 
		speed	  = peek(eventoffset+2)                         ' speed 
		wait 	  = peek(eventoffset+3)                         ' delay / wait 
		
		' make a copy of our event bar wait 
		poke @eventarray+1,control                              ' copy to first 4 bytes 
		poke @eventarray+2,amount 
		poke @eventarray+3,speed
		
		
	else                                                        ' array[0]>0
			control = peek(@eventarray+1)
			amount = peek(@eventarray+2)		                ' repeats 
			speed = peek(@eventarray+3)			                ' delay 
			
			if amount = 0                                       ' if amount = 0 
				' set control to wait 
				'poke @eventarray+1,0
				if control = 5                                  ' was control 5?
					border 1                                    ' border blue 
					cevent = cevent + 1                         ' cevent + 1 this is a global variable that sets the current event
					if cevent > peek(@eventarray)               ' bigger than control?
						cevent = 0                              ' reset
						scount=0                                ' reset 
					endif 
					poke @eventarray+1,0                        ' reset amount
					print cevent                                ' print cevent 
				else                                            ' control <>5
					border 2                                    ' border red 
					poke @eventarray+1,5                        ' put 5 into control
					poke @eventarray+2,speed                    ' save speed in amount
				endif 
			else                                                ' amount > 0 
				if control band 16 = 16                         ' check for directions
					x=x+cast(uinteger,(fSin(scount))>>2)                            ' sin movement 
					y=y+cast(uinteger,(fCos(scount))>>2)
					scount=scount+1                             ' sin count + 1
				else 	                    
					if control band %1 = 1 ' right              ' move right
						x=x+1 
						 'vectMove(vecX,vecY,1)
						 'x=x+vecX
					endif 
					if control BAND 2 = 2                       ' up 
						y=y-1
					endif 
					if control BAND 4 = 4                       ' left            
						x=x-1

					endif
					if control BAND 8 = 8                       ' down 
						y=y+1 
					endif 
				endif 
			    poke @eventarray+2,amount-1                     ' save amount - 1 into speed?
			endif 

	endif 	

	print at 2,0;x;" ";y;" ";control;" ";" ";scount
	

end sub 

eventarray:
asm 
    eventarray:
    ; space where script is copied to 
    defs 4*32                   ; we can always make this bigger if needed later 

    ; first four bytes are a temp area 
	; DB 1,0,0,0 							;' nuimber of event , event active , blank , blank 
	;  Command Amount Delay Wait  
    ; DB RT,AM*100,DL*55,WA*13			;' right for 10 loops delay 3, at end wait 20 
	; DB SI,AM*200,DL*50,WA*30
	; DB DN+LT,AM*5,DL*20,WA*1
	; DB RT,AM*5,DL*20,WA*1
	; DB UP+LT,AM*5,DL*20,WA*1
    ; DB RT,AM*100,DL*25,WA*25
    ; DB LT,AM*100,DL*25,WA*25
	
end asm 

script1:
asm 
    script1:	
    ; first four bytes are a temp area 
	DB 1,0,0,0
    DB RT,AM*100,DL*250,WA*205
    DB LT,AM*100,DL*25,WA*25
    DB 255  ; end marker 
end asm 

script2:
asm 
    script2:	
    ; first four bytes are a temp area 
	DB 1,0,0,0
    DB UP,AM*100,DL*25,WA*25
    DB DN,AM*100,DL*25,WA*25
    DB 255  ; end marker 
end asm 
FUNCTION fSin(num as ubyte) as byte


return PEEK (@sinetable+num)


sinetable:
asm
    ; better 
    db 0,0,0,-1,-1,-1,-2,-2,-3,-3,-3,-4,-4,-5,-5,-5
    db -6,-6,-6,-7,-7,-7,-8,-8,-8,-9,-9,-9,-10,-10,-10,-11
    db -11,-11,-11,-12,-12,-12,-12,-13,-13,-13,-13,-13,-14,-14,-14,-14
    db -14,-14,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15
    db -15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-14
    db -14,-14,-14,-14,-14,-13,-13,-13,-13,-13,-12,-12,-12,-12,-11,-11
    db -11,-10,-10,-10,-10,-9,-9,-9,-8,-8,-8,-7,-7,-7,-6,-6
    db -5,-5,-5,-4,-4,-4,-3,-3,-2,-2,-2,-1,-1,0,0,0
    db 0,0,0,1,1,2,2,2,3,3,4,4,4,5,5,5
    db 6,6,7,7,7,8,8,8,9,9,9,10,10,10,10,11
    db 11,11,12,12,12,12,13,13,13,13,13,14,14,14,14,14
    db 14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
    db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,14,14
    db 14,14,14,14,13,13,13,13,13,12,12,12,12,11,11,11
    db 11,10,10,10,9,9,9,8,8,8,7,7,7,6,6,6
    db 5,5,5,4,4,3,3,3,2,2,1,1,1,0,0,0
end asm
END FUNCTION

FUNCTION fCos(num as ubyte) as byte
    return fSin(32-num) 
END FUNCTION

sub fastcall vectMove(vecX as ubyte, vecY as ubyte, vecDir as ubyte)
	' Requires dim vecX,vecY as ubyte 
	asm 
	;move sprite in direction defined in a
		
		
		;BREAK 
		; Vec movement by Allan Turvey, adapted by David Saphier
		;' ret address and load regs with arguments 
		;
		pop bc : ld d,a : pop af  :	ld e,a : 	pop af 
movdir	
		and 15 : ld hl,vectab : add a,l	: ld l,a : ld a,(hl) : add a,d : ld (._vecX),a 
		ld a,l : add a,4 : ld l,a : ld a,(hl) : add a,e : ld (._vecY),a : push bc
		ret 
		;20 byte lookup table for 16 directions + 4 for 90 degree rotation (for y axis)
vectab 
		defb 254,254,254,255,0,1,2,2,2,2,2,1,0,255,254,254,254,254,254,255

	;this table would allow 32 directions, change code to AND 31 and add 8 instead of 4 to l.
	;vectab 
	;defb 0,255,254,253,252,251,251,250,250,250,251,251,252,253,254,255,0,1,2,3,4,5,5,6,6,6,5,5,4,3,2,1,0,255,254,253,252,251,251,250	
	end asm 
end sub        

Sprites:
ASM 
Sprite1:
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $0F, $13, $13, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $0F, $0F, $0F, $0F, $13, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $A0, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $C0, $C0, $A0, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $C0, $C0, $C0, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $C0, $C0, $C0, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $C0, $C0, $C0, $A0, $60, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $60, $60, $A0, $C0, $C0, $A0, $60, $60, $60, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $92, $EC, $CC, $EC, $EC, $A8, $A8, $A8, $92, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $88, $88, $EC, $EC, $EC, $EC, $EC, $EC, $A8, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $92, $88, $88, $EC, $EC, $EC, $EC, $A8, $6D, $92, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $92, $88, $88, $88, $EC, $A8, $A8, $A8, $6D, $92, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $92, $88, $88, $88, $88, $88, $A8, $A8, $6D, $92, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $6D, $E3, $88, $88, $88, $A8, $A8, $E3, $6D, $6D, $E3, $E3;

end asm           

asm 
    RT	EQU 1
    UP	EQU 2
    LT	EQU 4 
    DN	EQU 8
    SI	EQU 16
    AM  EQU 1 
    WA  EQU 1 
    DL  EQU 1 
end asm 