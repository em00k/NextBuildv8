'!headerless 

asm 

        org    $ff00 
        
		push af : push bc : push hl : push de : push ix : push iy 	
		ex af,af'
		push af
        exx : push bc : push hl : push de :	exx



        ld      a,(sfxenablednl)					;' are the fx enabled?
        or      a : jr z,skipfxplayernl

        ; call    _CallbackSFX						;' if so call the SFX callback 

    skipfxplayernl:		
        ld      a,(sfxenablednl+1) 							;' is music enabled?
        or      a : jr z,skipmusicplayer

        call    playmusicnl						;' if so player frame of music 

        skipmusicplayer:		
	
		exx 
        pop de : pop hl : pop bc
		exx 

        pop af : ex af,af'
		pop iy : pop ix : pop de : pop hl : pop bc : pop af 

		ei
		ret 									;' standard reg pops ei and reti

        playmusicnl:
		; DB $c5,$DD,$01,$0,$0,$c1
		getreg($52)                             ; save bank in slot 2
        ld      (exitplayernl+3),a              ; save the bank below 
		ld      hl,bankbuffersplayernl
        ld      a,(hl)
		nextreg $52,a
        inc     hl 
        ld      a,(hl)
        nextreg $50,a
        inc     a
        nextreg $51,a
		ld      a,(sfxenablednl+1)
        cp      2
        jr      z,mustplayernl

        push    ix 
		call    $4005					; play frame of music 
        pop ix 
        ; push    ix 

exitplayernl:
		nextreg $52,$0a
		nextreg $50,$00
		nextreg $51,$01

ayrepairestack2:

		ret 
end asm 