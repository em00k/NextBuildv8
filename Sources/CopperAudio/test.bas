
' -- Load block 
LoadSDBank("music.pt3",0,0,0,34) 				' load music.pt3 into bank 34
LoadSDBank("vt24000.bin",0,0,0,33) 				' load the music replayer into bank 33
' -- 

InitSFX(36)							            ' init the SFX engine, sfx are in bank 36
InitMusic(33,34,0000)				            ' init the music engine 33 has the player, 34 the pt3, 0000 the offset in bank 34
SetUpIM()							            ' init the IM2 code 
EnableSFX							            ' Enables the AYFX, use DisableSFX to top
EnableMusic 						            ' Enables Music, use DisableMusic to stop 
'PlaySFX(nr)                                    ' Plays SFX 
