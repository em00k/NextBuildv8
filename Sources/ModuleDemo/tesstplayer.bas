'!org=57344	
'!heap=768
'!nosys 
'!copy=h:\modules\sample.nex

#define NOSP 					' This tells nextbuild to no set a stack pointer 
#define IM2
#define DEBUG  					' This will display an error when a file is not found
#define NEX 					' We want to build into Sample.NEX
#include <nextlib.bas>
#include <nextlib_ints_ctc2.bas>
#include "inc-Common.bas"

border 7

LoadSDBank("mouse.spr",0,0,0,26)	' This is the mouse sprite in bank 26/27
LoadSDBank("aterix_font.fnt",0,0,0,28)	' This is the text font in bank 28/29
LoadSDBank("sfzii.nxt",0,0,0,29)	' This is the text font in bank 28/29
LoadSDBank("forest.pt3",0,0,0,56) 				' load music.pt3 into bank 
'#LoadSDBank("lemotree.pt3",0,0,0,57) 				' load music.pt3 into bank 
LoadSDBank("music.pt3",0,0,0,58) 				' load music.pt3 into bank 
LoadSDBank("ts4000.bin",0,0,0,37) 				' load the music replayer into bank 
LoadSDBank("game.afb",0,0,0,38) 				' load music.pt3 into bank 
LoadSDBank("output.dat",0,0,0,57) 
asm 
    di 
end asm 

L2Text(0,0,"MODULE 2",29,0)
InitInterupts(38,37,56)			' set up interrupts sfxbank, playerbank, music bank 

dim a as ubyte = 0 
dim b as ubyte = 0 
dim d as ubyte = 0 
dim key as ubyte = 0 

do 
    border a 
    b = GetKey2()
    if b = code " " and key = 0 
        poke $fd3f,a
        if a < 5
            a = a + 1
        else 
            a = 1 
        endif 
        key = 1 
    elseif b = code "1" and key = 0 
        PlaySFX(d)
        if d < 94
            d = d + 1
        else 
            d = 1 
        endif 
        key = 1 
    elseif b = 0  
        key = 0 
    endif

loop 



sub InitInterupts(byval sfxbank as ubyte, byval plbank as ubyte, byval musicbank as ubyte)
	'' BBREAK 
	InitSFX(sfxbank)						        ' init the SFX engine, sfx are in bank 36
	InitMusic(plbank,musicbank,$000)		        ' init the music engine 33 has the player, 34 the pt3, 0000 the offset in bank 34
	SetUpCTC()							            ' init the IM2 code 
	 
	PlaySFX(3)                                    	' Plays SFX 
	EnableMusic
    EnableSFX

end sub 


ctc_sample_table:
asm 
ctc_sample_table:

	dw $3900,0,4417 ; 0jump.pcm
	dw $3900,4417,7516 ; 1pickup.pcm
	dw $3a00,11933-8192,7086 ; 3punch.pcm
	dw $3b00,2635,3238 ; 4dead.pcm
	dw $3b00,5873,11000 ; complete.pcm
end asm 
