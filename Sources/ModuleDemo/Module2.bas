' ------------------------------------------------------------------------------
' - BankManager Sample v.2.0 ---------------------------------------------------
' ------------------------------------------------------------------------------
' - Sample module 2 ------------------------------------------------------------
' ------------------------------------------------------------------------------

' ORG 24576 - $6000
' Fixed bank located at $6000 to $7fff
' Usable memory from $6000 to $dd00 minus Heap size 32kB yeah
'!master=Sample.nex
'!copy=h:\Modules\Module2.bin
'!org=24576
'#!heap=1024
'!module 



' border 3: PAPER 0 : INK 7 : CLS 
' BBREAK

Init()
Main()

'DisableIM()
End 


#define IM2
'#define NOSP 
#include <nextlib.bas>
#include <nextlib_ints_ctc2.bas>
#include "inc-Common.bas"
#include "inc-mouse.bas"

' for modules we're going to need something different that the NB7 InitMusic etc 
' Main module should initailis the IM2 and 


Sub Init()
	asm 
		nextreg SPRITE_CONTROL_NR_15,%00000011
		ei
	end asm 

	PlayMusic()
end sub 

Sub Main()
	' Show parameters
	dim	key as ubyte 
	dim b 	as ubyte
	dim c 	as ubyte
    dim mox as ubyte 
    dim sinoff as ubyte
    dim sinspeed as ubyte 
	CLS256(0) 
	
	L2Text(0,0,"MODULE 2",29,0)
	L2Text(0,1,"MOUSE "+Str(mox)+Str(moy),29,0)


	L2Text(0,3,"1 - STOP, 2 - PLAY",29,0)
	L2Text(0,4,"4 - TUNE 2, 5 - TUNE 1",29,0)
	
	InitSprites2(64,0,26)		' init sprites in bank 26
    
	Do 
		asm 
			nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,255
		end asm 
		ProcessMouse()
		UpdatePointer(0)                               ' sprite 16
		
		L2Text(6,2,Str(mouse_mox>>3)+Str(mouse_moy>>3),29,0)
		L2Text(6,1,Str(mouse_mbutt band 3),29,0)
		asm 
			nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0
		end asm 
		WaitRetrace2(90)

		if mouse_mbutt band 3 =1  
			PlaySFX(49)				' test sound fx '
            
		endif 
        if mouse_mbutt band 3 =2 
            VarLoadModule=ModuleSample3
			' BBREAK
            exit do 
        endif 

		a = GetKey2

		if a = code "1"
			StopMusic()					' stops music'
		elseif a = code "2"
			PlayMusic()					' continues music'
		elseif a = code "4" 
			NewMusic(57,0)				' new tune in bank 56'
		elseif a = code "5"
			NewMusic(56,0)				' new tune in bank 57'
		elseif a = code "6"
			NewMusic(80,3814)				' new tune in bank 57'
		elseif a = code "7"	and key = 0 
			L2Text(0,7,"SAMPLE "+Str(b),29,255)
			poke $fd3f,b
			if b < 5
				b = b + 1
			else 
				b = 1 
			endif 
			key = 1
		elseif a = code "8"	and key = 0 
			L2Text(0,8,"AY "+Str(c),29,0)
			PlaySFX(c)
			if c < 95
				c = c + 1
			else 
				c = 1 
			endif 
			key = 1 
		elseif a = 0 
			key = 0 
		endif 
        
	Loop 

END SUB

sub barvus()
	dim x,sprvol,sval as ubyte
    sval =0 

	a = peek(uinteger, 0x0000EA79) '
    NextRegA($56,65)

    for x = 8 to 127+8 step 4
        if a >= peek(uinteger, $c000+cast(uinteger,x))    
            exit for 
        endif  
    next 
    a = x-8 >> 2' 32-(cast(uinteger,sval)) band 31

	out 65533,8 
    poke @bardata+cast(uinteger,a),(peek @bardata+cast(uinteger,a) bor (in 65533 band 15 ) ) band $f
	a = peek(uinteger, 0x0000EA7B) '
	hhj
    for x = 8 to 127+8 step 4
        if a >= peek(uinteger, $c000+cast(uinteger,x))    
            exit for 
        endif  
    next 
    a = x-8 >> 2' 32-(cast(uinteger,sval)) band 31
	out 65533,9
    poke @bardata+cast(uinteger,a),(peek @bardata+cast(uinteger,a) bor (in 65533 band 15 ) ) band $f
	a = peek(uinteger, 0x0000EA7D) '
	
    for x =8 to 127+8 step 4
        if a >= peek(uinteger, $c000+cast(uinteger,x))    
            exit for 
        endif  
    next 
    a = x-8 >> 2' 32-(cast(uinteger,sval)) band 31
	out 65533,10
	poke @bardata+cast(uinteger,a),(peek @bardata+cast(uinteger,a) bor (in 65533 band 15 ) ) band $f
    dim y as ubyte 

	for x = 0 to 31

        sinoff = (sinoff + 1) band 63 
        y = peek (@sindata+cast(uinteger,sinoff))
		sprvol=peek(@bardata+cast(uinteger,x))
		UpdateSprite(cast(uinteger,(x<<3))+32,192+32-y,x+1,sprvol,1<<6,%00000000)
        
	next x 
    sinoff = (sinoff + sinspeed) band 63 
	asm 
	 	ld hl,bardata
	 	ld b,32 
	 decloop:
	 	ld a,(hl)
	 	or a : jr z,nodec 
	 	dec (hl)
	; 	ld a,(hl)
	; 	or a : jr z,nodec 
	; 	dec (hl)
	 nodec:
	 	inc hl 
	 	djnz decloop
	 end asm 
end sub 
bardata:
asm 
	bardata:
	ds 64,0
end asm 
sindata:
    asm 
    db 8,7,6,5,4,4,3,2,2,1,1,0,0,0,0,0
    db 0,0,0,0,0,1,1,2,2,3,3,4,5,6,6,7
    db 8,9,9,10,11,12,12,13,13,14,14,15,15,15,15,15
    db 15,15,15,15,15,14,14,13,13,12,11,11,10,9,8,8
    end asm 

'#include "inc-copper.bas"

InitMusic(0,0,0)