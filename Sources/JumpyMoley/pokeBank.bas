#include <nextlib.bas>

dim map(32,32) as ubyte 
dim add as uinteger
dim a,x as ubyte 
add = @map

asm 
    nextreg SPRITE_CONTROL_NR_15,%001_010_11          ; ULA/TM / Sprites / L2
    nextreg GLOBAL_TRANSPARENCY_NR_14,0             ; Set global transparency to BLACK
    nextreg TURBO_CONTROL_NR_07,3                   ; 28mhz 
    nextreg PERIPHERAL_3_NR_08,254                  ; contention off
    ;nextreg ULA_CONTROL_NR_68,%10101000				; Tilemap Control on & on top of ULA,  80x32 
    ;nextreg LAYER2_CONTROL_NR_70,%00010000			; L2 320x256
    di                                              ; disable ints as we dont want IM1 running as we're using the area that sysvars would live in
end asm 

do 
        WaitRetrace2(1)
        Test1()
        Test2()
        'for x = 0 to 23
        'print at x,0;map(0,x) 
        'next 
loop 



sub Test1()
        ' 49 bytes , 65
        asm 
	        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,224   ; reed 
	end asm 

        for x = 0 to 31
                a = map(0,x)
                map(0,x)=x 
                map(x,0)=x 
        next 

        asm 
	        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0   ; reed 
	end asm 
        
end sub 


sub Test2()
        ' 40 bytes , 57
        asm 
                nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,156   ; reed 
        end asm 
        
        for x = 0 to 31
                a = peek(add+cast(uinteger,x))
                poke(add+cast(uinteger,x),x)
                poke(add+cast(uinteger,x<<5),x)
        next 

        asm 
	        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0   ; reed 
	end asm 
end sub 

sub fastcall pokeBank(bank as ubyte, value as ubyte, address as uinteger)

	asm 
        exx : pop hl  : exx 
        ; a = bank 
        ; hl address 
        nextreg $52,a 
        pop     af 
        add     hl,$4000
        ld      (hl),a
        nextreg $52,2
        exx : push hl : exx 
	end asm 

end sub 

do 
pokeBank(24,$ff,128)
loop 
