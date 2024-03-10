'!ORG=32768
'!HEAP=2048
'!copy=h:\ctcplayer.nex

#define IM2
#define NEX
'#define CUSTOMISR
#include <nextlib.bas>
#include <nextlib_ints_ctc2.bas>
#include <keys.bas>

asm 
	; nextreg PERIPHERAL_3_NR_08,%11111000
	nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0
end asm 
 border 5
LoadSDBank("forest.pt3",0,0,0,24) 				' load music.pt3 into bank 
LoadSDBank("ts4000.bin",0,0,0,37) 				' load the music replayer into bank 
LoadSDBank("game.afb",0,0,0,38) 				' load music.pt3 into bank 
LoadSDBank("output.dat",0,0,0,57) 				' load music.pt3 into bank 

dim x as ubyte 

InitInterupts(38,37,24)	

StopMusic()

do 
	if x < 6 
		x=x+1
		PlaySample(x)
	else 
		x = 0
	endif
	WaitKey()

loop 

sub InitInterupts(byval sfxbank as ubyte, byval plbank as ubyte, byval musicbank as ubyte)
	 
	InitSFX(sfxbank)						        ' init the SFX engine, sfx are in bank 36
	InitMusic(plbank,musicbank,0000)		        ' init the music engine 33 has the player, 34 the pt3, 0000 the offset in bank 34
	' SetUpIM()							            ' init the IM2 code 
	SetUPCTC()

	PlaySFX(3)                                    	' Plays SFX 
	EnableMusic
	EnableSFX
end sub 

asm 
ctc_sample_table: 

	dw $3900,0,4417 ; 0jump.pcm
	dw $3900,4417,7516 ; 1pickup.pcm
	dw $3a00,11933-8192,7086 ; 3punch.pcm
	dw $3b00,2635,3238 ; 4dead.pcm
	dw $3b00,5873,11000 ; complete.pcm
end asm 