'orf=32768
'#!asm 

'#include <nextlib.bas>

 ink 7 : paper 0 : cls 

dim stars_x,stars_y,stars_s,stars_cx,stars_cy,stars_cs as ubyte 
dim stars_fc,stars_c,stars_add as uinteger
stars_cx = stars_cs : stars_cs= stars_cy : stars_cy=stars_cs : stars_cs = stars_add : stars_add = stars_cx 

for stars_c=0 to 240
    stars_x=int(stars_c)+1
	stars_y=8+int(rnd*183)
	stars_s=1+int(rnd*3)
	poke ubyte (@Stardata+stars_fc),stars_x
	poke ubyte (@Stardata+stars_fc+1),stars_y
	poke ubyte (@Stardata+stars_fc+2),stars_s
	stars_fc=stars_c*3
next 

sub makestars()
    stars_fc=0
    for stars_c=0 to 240        
        stars_x=peek (@Stardata+stars_fc)
        stars_y=peek (@Stardata+stars_fc+1)
        stars_s=peek (@Stardata+stars_fc+2)
        stars_fc=cast(uinteger,stars_c)*3
        fplot(stars_x,stars_y)
        ' pause 0
    next stars_c
end sub 


sub updatestars()
    stars_fc=0
    for stars_c=0 to 239*3 step 3

        stars_cx=peek  (ubyte,@Stardata+stars_c)
        stars_cy=peek (ubyte,@Stardata+stars_c+1)
        stars_cs=peek (ubyte,@Stardata+stars_c+2)
        stars_add=@Stardata+stars_c

        asm 
            ld de,(._stars_cx)
            PIXELADD
            SETAE 
            xOr (hl)
            Ld (hl),a
            ld a,(._stars_cx)
            ld bc,(._stars_cs)
            add a,c 
            ld (._stars_cx),a
            ld hl,(._stars_add)
            ld (hl),a
            ld de,(._stars_cx)
            PIXELADD
            SETAE 
            xOr (hl)
            Ld (hl),a
        end asm 

    next 
end sub 


SUB fplot(byval x as ubyte, byval y as ubyte)
	asm 
    ;    BREAK 

		Ld d, (IX+7)
		Ld e, (IX+5)
		PIXELADD
		SETAE 
		xOr (hl)
		Ld (hl),a
	end asm 
end sub 
