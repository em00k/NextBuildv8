' ------------------------------------------------------------------------------
' - BankManager Sample v.2.0 ---------------------------------------------------
' ------------------------------------------------------------------------------
' - Sample module 2 ------------------------------------------------------------
' ------------------------------------------------------------------------------

' ORG 24576 - $6000
' Fixed bank located at $6000 to $7fff
' Usable memory from $6000 to $dd00 minus Heap size 32kB yeah
'!master=Sample.NEX
'!copy=h:\Modules\Module4.bin
'!org=24576
'!heap=2048
'!module 
'!noemu

' MARK: - Init and Main 

Init()
Main()

End 		' Exit module 


#define IM2							' we need IM2 enable for AY/CTC effects
#include <nextlib.bas>				' stanbdard nextlib include 
#include <nextlib_ints_ctc2.bas>	' We're using CTC AY Effects 
#include "inc-Common.bas"			' Common routines used in all modules 
#include "inc-mouse.bas"			' mouse incldue 

' This is the intialisation of the module 

Sub Init()
	asm 
		nextreg SPRITE_CONTROL_NR_15,%00000011			; ensure sprites are on 
		ei												; ensure interrupts are on 
	end asm 
	PlayMusic()											; ensure music is playing on entry 

end sub 

Sub Main()
	
	' Main module routine 

	dim		mouse_sfx	as ubyte = 0 

	InitSprites2(16,0,26)								' init sprites in bank 26 for mouse 
	L2Text(0,0,"MODULE 4",29,0)							' show some infos 
	L2Text(0,1,"MOUSE "+NStr(mox)+NStr(moy),29,0)

	Do 

		ProcessMouse()									' process mouse position 
		UpdatePointer()        							' updates the mouse pointer 
		WaitRetrace(1)									' wait vblank

		if mouse_mbutt band 3 =1  						' if mouse button make an ayfx sound
			PlaySFX(mouse_sfx)			
            mouse_sfx = mouse_sfx + 1
			if mouse_sfx > 90 : mouse_sfx = 0 : enddif 
		endif 

        if mouse_mbutt band 3 =2 						' mouse button 2, start exit 
            VarLoadModule=ModuleSample1					' module to load next 
			copper_stop()								' stop copper 
			ScrollLayer(0,0)							' reset L2 position 
			reset_palette()								' reset palette to next default 
            exit do 									' exit loop 
        endif 

		a = GetKey2

		if a = code "1"
			StopMusic()					' stops music'
		elseif a = code "2"
			PlayMusic()					' continues music'
		elseif a = code "4"
			NewMusic(57)				' new tune in bank 56'
		elseif a = code "5"
			NewMusic(56)				' new tune in bank 57'
		elseif a = code "6"
			NewMusic(58)				' new tune in bank 57'
		elseif a = code "7"	and key = 0 
			L2Text(0,7,"SAMPLE "+NStr(b),29,0)
			poke $fd3f,b
			if b < 5
				b = b + 1
			else 
				b = 1 
			endif 
			key = 1
		elseif a = code "8"	and key = 0 
			L2Text(0,8,"AY "+NStr(c),29,0)
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
