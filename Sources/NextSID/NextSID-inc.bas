'!ORIGIN=PWMwithMouse-patterninfo.bas
' ------------------------------------------------------------------------------
' - Sprite Test ----------------------------------------------------------------
' ------------------------------------------------------------------------------
'
'!sna "h:\test.snx" -a
'#!noemu 
'
dim wave(3) as uinteger
dim pos as ubyte 
dim oldx,cval as ubyte 
dim keydown,position as ubyte
dim keytimer as ubyte=5
dim prescaler as ubyte=50
dim phase as ubyte=0
dim wsize as ubyte=32
dim startsamp as ubyte=0 
dim instvolume as ubyte=80
dim instvolumepos as ubyte=0
dim editmode as ubyte = 0 
dim samplestart as uinteger at $e000
' wave(0,0)=1
' wave(0,1)=2
' wave(2,0)=3
' BBREAK 


sub checkkeys()
	' keyboard handling and move pos/change wave 
	k$= inkey$
	if k$=" " and keydown = 0 
	'	pos=pos-2 band 63 
		keydown = 1 
		keytimer=10
		if playing = 0 
			asm 
				call nextsid_play
			end asm 
			playing=1
		else 
			asm 
				call nextsid_stop 
			end asm 
			playing=0
		endif 

	elseif k$="1" and keydown = 0 
		cha_state=1-cha_state
		enable_cha()
		keydown = 1	
		keytimer=25

	elseif k$="2" and keydown = 0 
		chb_state=1-chb_state
		enable_chb()
		keytimer=25
		keydown = 1	

	elseif k$="3" and keydown = 0 
		chc_state=1-chc_state
		enable_chc()
		keytimer=25
		keydown = 1	

	elseif k$="4" and keydown = 0 
		asm 
			ld	hl,muted_waveform ; Duty cycle ON
			ld a,16-1
			call	nextsid_set_waveform_A
		end asm 
		keydown = 1	

	elseif k$="5" and keydown = 0 
		asm 
			ld	hl,muted_waveform ; Duty cycle ON
			ld a,16-1
			call	nextsid_set_waveform_B
		end asm 
		keydown = 1		

	elseif k$="6" and keydown = 0 
		asm 
			ld	hl,muted_waveform ; Duty cycle ON
			ld a,16-1
			call	nextsid_set_waveform_C
		end asm 
		keydown = 1		

	elseif k$="7" and keydown = 0 
        sinspeed =sinspeed +1
		keydown = 1		

	elseif k$="8" and keydown = 0 
        sinspeed=sinspeed-1
        keydown = 1		

	elseif k$="q" and keydown = 0 
		keydown = 1		
		adjustwavelength(chan_select,0)

	elseif k$="w" and keydown = 0 					'; increase wave lenght 
		adjustwavelength(chan_select,1)
		keydown = 1		

	elseif k$="z" and keydown = 0 
		keydown = 1		
		adjustshiftlength(chan_select,0)
		refreshsettings()

	elseif k$="x" and keydown = 0 					'; increase wave lenght 
		adjustshiftlength(chan_select,1)
		refreshsettings()
		keydown = 1		
		
	elseif k$="l" and keydown = 0 					'; increase wave lenght 
		loadnt3()
		setnt3()
		keydown = 1		
		


	elseif k$="s" and keydown = 0 

		keydown = 1 	
		savent3()
		
	elseif k$="t" and keydown = 0 
		debugv = debugv + 12*3
		keydown = 1 
	elseif k$="y" and keydown = 0 
		debugv = debugv - 12*3
		keydown = 1 
	elseif k$="n" and keydown = 0 
		if position<max-1
			position=position+1 
			lastclick=lastclick+1
			loadpt3(position)
			if loadstate>0
				DrawColours()
			else	
				print at 23,0;"                    "
				refreshsettings()
			endif 

		endif 
		keydown = 1 
	elseif keydown = 1
		keytimer = keytimer - 1 
		if keytimer < 1
			keydown = 0 
			keytimer=5
		endif 
	endif

end sub

sub loadpt3(position as ubyte)
	' needs fname$ and position to work 
	asm 
							
		call nextsid_stop
		di 
		;	ld (oldloadsp+1),sp 
		;ld sp,.LABEL._filename+255
		;call	nextsid_reset
		nextreg $52,34

	end asm 

	fname$=files$(position)
	if len(fname$)>0
		dim tempsize as ubyte 
		dim offset as ulong
		tempsize = size(position) / 8192
		offset = 0
		for l = 0 to tempsize 
			LoadSD(fname$( to ),$4000,8192,offset)
			offset=offset+8192
			asm : nextreg $52,35 : end asm 
		next l 
		loadnt3()
		if peek (uinteger,@filesize) > 0 
			setnt3()
		endif 

		asm 
			nextreg $52,10	
			nextreg $55,34
			nextreg $56,35
			
			ld	hl,$a000 	; Init the PT3 player.
			ld	a,34		; Bank8k a 1st 8K
			ld	b,35		; Bank8k b 2nd 8K
			
			call	nextsid_set_pt3
		end asm 

		asm 
			push ix 
			;push bc 
			call	init		; VT1-MFX init as normal
			;pop bc 
			pop ix 
		end asm 

		asm 

			nextreg $55,5
			nextreg $56,0
			nextreg $57,33
			
			call	nextsid_play	; Start playback
		oldloadsp:
		;	ld sp,0
			ei 

		end asm
	endif 
	asm 
		di 
		nextreg $50,34 
	end asm 
		PeekMemLen(30,69,songinfo$)
	asm 
		nextreg $50,$FF
		ei
	end asm 
end sub 

sub savent3()
	if timing = 7 			'; hdmi 
	'	psgclock=psgclock+hdmi 
	endif 
	asm 
		ld hl,_psgclock
		ld de,header+18			; psg clock 
		ldi : ldi 				; copy 2 bytes 
		ldi : ldi 				; copy 2 bytes 
		
		ld hl,_audiomask 		; copy audio mask 
		ldi 

		ld hl,_cha_wave_len	; copy chan a len 	
		ldi 

		ld hl,test_waveforma
		ld bc,32 : ldir 		; copy wav 1 

		ld hl,_chb_wave_len	; copy chan b len 	
		ldi 

		ld hl,test_waveformb
		ld bc,32 : ldir 		; copy wav 2 

		ld hl,_chc_wave_len	; copy chan c len 	
		ldi 

		ld hl,test_waveformc
		ld bc,32 : ldir 		; copy wav 3

		ld hl,_cha_state 		; chan a enable 
		ldi 
		
		ld hl,$E1FF				; chan a shift 
		ldi 

		ld hl,_detune_a			; chan a detune 
		ldi : ldi 				; copy 2 bytes 


		ld hl,_chb_state 		; chan b enable 
		ldi 

		ld hl,$E226				; b 
		ldi 

		ld hl,_detune_b			; chan b detune 
		ldi : ldi 				; copy 2 bytes 


		ld hl,_chc_state 		; chan c enable 
		ldi 

		ld hl,$E24D				; c 
		ldi 

		ld hl,_detune_c			; chan c detune 
		ldi : ldi 				; copy 2 bytes 	
		
		; save channel shifts 





	end asm 
'	nt3file$=fname$

	nt3file$=fname$( to len(fname$)-4)+"nt3"
	printat64(23,2) : print64(nt3file$(to 31))
	SaveSD(nt3file$,@header,134)
	if timing = 7 			'; hdmi 
	'	psgclock=psgclock-hdmi 
	endif 
end sub 

sub loadnt3()
	nt3file$=fname$( to len(fname$)-4)+"nt3"
	'print at 0,0;nt3file$
	LoadSD(nt3file$,@header,134,0)

end sub 

sub setnt3()

	asm 

		ld hl,header+18			; just accept header for now 
		ld de,_psgclock			; psg clock 
		ldi : ldi : ldi : ldi 	

		ld de,_audiomask 		; copy audio mask 
		ldi 
		
		ld de,_cha_wave_len	; copy chan a len 	
		ldi 

		ld de,test_waveforma
		ld bc,32 : ldir 		; copy wav 1 

		ld de,_chb_wave_len	; copy chan b len 	
		ldi 

		ld de,test_waveformb
		ld bc,32 : ldir 		; copy wav 2 

		ld de,_chc_wave_len	; copy chan c len 	
		ldi 

		ld de,test_waveformc
		ld bc,32 : ldir 		; copy wav 3

		ld de,_cha_state 		; chan a enable 
		ldi 
		
		ld de,$E1FF				; chan a shift 
		ldi

		ld de,_detune_a			; chan a detune 
		ldi : ldi 				; copy 2 bytes 

		ld de,_chb_state 		; chan b enable 
		ldi 

		ld de,$E226				; chan b shift 
		ldi 

		ld de,_detune_b			; chan b detune 
		ldi : ldi 				; copy 2 bytes 


		ld de,_chc_state 		; chan c enable 
		ldi 

		ld de,$E24D				; chan c shift 
		ldi 

		ld de,_detune_c			; chan c detune 
		ldi : ldi 				; copy 2 bytes 	

	end asm 
	'drawwave()
	enable_cha()
	enable_chb()
	enable_chc()
	detune_cha_a(0)
	detune_cha_b(0)
	detune_cha_c(0)
	'if timing = 7 			'; hdmi 
	'	psgclock=psgclock-hdmi 
	'endif 
	setpsgclock(psgclock)
	cha_shift=peek(0x0000E1FF)
	chb_shift=peek(0x0000E226)
	chc_shift=peek(0x0000E076)
	'
end sub 

sub adjustwavelength(byval wave as ubyte, mode as ubyte)

	if chan_select = 0 
		' get pointer to number 
		temp_wav_add=$e341 	 ' nextsid_wavelen_A
		temp_ch_len=@cha_wave_len
	elseif chan_select = 1
		temp_wav_add=$e36c   ' nextsid_wavelen_B
		temp_ch_len=@chb_wave_len
	elseif chan_select = 2 
		temp_wav_add=$e397   ' nextsid_wavelen_c
		temp_ch_len=@chc_wave_len
	endif 
	
	temp_wav_len=peek(temp_ch_len)

	'border temp_wav_len band 0 

	if mode = 0
		temp_wav_len=temp_wav_len-1
	elseif mode = 1
		temp_wav_len=temp_wav_len+1
	endif 

	poke temp_wav_add,temp_wav_len
	poke temp_ch_len,temp_wav_len
	
	printat42(9,39) : print42(hex8(temp_wav_len))
	
end sub 

sub adjustshiftlength(byval wave as ubyte, mode as ubyte)

	if wave = 0 
		' get pointer to number 
		temp_wav_add=$E1FF 	 ' nextsid_shift a
		'temp_ch_len=@cha_wave_len
	elseif wave = 1
		temp_wav_add=$E226   '  nextsid_shift b
		'temp_ch_len=@chb_wave_len
	elseif wave = 2 
		temp_wav_add=$E24D  ' nextsid_shift c
		'temp_ch_len=@chc_wave_len
	endif 
	
	temp_wav_len=peek(temp_wav_add)

	border temp_wav_len band 0 

	if mode = 0
		temp_wav_len=temp_wav_len-1
	elseif mode = 1
		temp_wav_len=temp_wav_len+1
	endif 

	poke temp_wav_add,temp_wav_len

	
'printat42(9,39) : print42(hex8(temp_wav_len))
	
end sub 

sub drawwave()
	' redraw full wave 
	ink 6
	asm 
		ld a,22 
		rst 16 
		ld a,11
		rst 16 
		ld a,0 
		rst 16 
		ld bc,288
	prnloop:
	    push bc 
		ld a,' '
		rst 16 
		pop bc 
		dec bc 
		ld a,b 
		or c 
		jr nz,prnloop 
	end asm 
	refreshsettings()
end sub 

sub refreshsettings()
	'setnt3()
	print at 2,2;paper 2-(cha_state<<1);"    "
	print at 4,2;paper 2-(chb_state<<1);"    "
	print at 6,2;paper 2-(chc_state<<1);"    "
	detune_cha_a(0)
	detune_cha_b(0)
	detune_cha_c(0)
	setpsgclock(psgclock)
	printat42(2,38)
	print42(hex16(detune_a))
	printat42(4,38)
	print42(hex16(detune_b))
	printat42(6,38)
	print42(hex16(detune_c))

	printat42(23,34) : print42("       ")
	printat42(23,34) : print42(str(psgclock))
	if max>2
		printat64(23,2) : print64(fname$(to 31)+"  "+str(position-1)+"/"+str(max-2))
	endif 
	'adjustwavelength(0,3)
	'displaywaveform(chan_select)
	printat64(0,0):print64("Song:"+songinfo$(to 32))
	printat64(0,32):print64("|"+songinfo$(36 to 36+30))
	printat64(2,1) : print64(hex8(peek($E1FF)))
	printat64(4,1) : print64(hex8(peek($E226)))
	printat64(6,1) : print64(hex8(peek($E24D)))
end sub 

sub drawlenght()

	print at 23,0;rx2;" "

	printat42(23,34) : print42("       ")
	printat42(23,34) : print42(str(psgclock))
	
end sub 

sub displaywaveform(wave as ubyte)
 	drawwave()

	dim wavadd as uinteger
	dim value as ubyte 
	if wave = 0 
		wavadd = @wavea
	elseif wave = 1
		wavadd = @waveb
	elseif wave = 2
		wavadd = @wavec
	endif 
	printat42(9,5) : print42(chr((wave)+65))
	for x = 0 to 31
		value = peek(wavadd+cast(uinteger,x))
		'print at 1,x<<2;value 
		print at 11+(value/16),x;"\::"
		
		'printat64(11,x*2)
		'print64(str(value))
	next x 
	adjustwavelength(wave,3)				' display the len

end sub 

sub drawwavpartial(byval doX as ubyte)
	' redraw partial wave 
	' x is 0 - 63 
	dim r as ubyte 
	x = doX>>1 
	r = ry <<2
	' wave(x,0) = ry<<3
	' wave(x,1) = ry<<3
	'print at 21,10;x
	'print at 22,10;wave(x,0)
	dim wavadd as uinteger
	dim value as ubyte 
	if chan_select = 0 
		wavadd = @wavea
	elseif chan_select = 1
		wavadd = @waveb
	elseif chan_select = 2
		wavadd = @wavec
	endif 
	poke wavadd+cast(uinteger,x),80+(r*4)
'	print at 0,0;80+(r*4),x 
	for y = 11 to 21
		if y = ry 
			print at y,x;"\::" 
			else 
			print at y,x;" "
		endif
	next y 
end sub 

' sub ADSR()
	
' '	if instvolumepos<254 : instvolumepos=instvolumepos+1 : else : instvolumepos=0 : endif 
' '	instvolume=(peek(@voltable+cast(uinteger,instvolumepos))) band 15
' 	' instvolume=15
	
' 	asm 
' 	;straigh copy 
' 	ld a,(waveb+31)
' 	ld hl,waveb
' 	ld de,waveb+1
' 	ld bc,31
' 	ldir 
' 	ld (waveb),a 

' ;	ld a,(._instvolume)
' ;	ld c,a 
' ;	; mix with volume 
' ;	ld hl,$e000+256
' ;	ld b,63
	
' applyvol:

' ;	ld a,c 		; inst volume
' ;	ld e,a 		; put in e 
' ;	ld a,(hl)
	
' ;	ld d,a 		; pu samp vol into d 
' ;	mul d,e 
' ;	push bc 
' ;	ld b,6
' ;	bsra de,b 
' ;	pop bc 
' ;	ld a,e 
' ;	ld (hl),a  
' ;	dec c 
' ;	ld a,c 
' ;	or a 
' ;	inc hl
' ;	jr nz,applyvol 
' ;	ld hl,$e000+256
' ;	ld de,$e000+128
' ;	ld bc,63
' ;	ldir 
' 	end asm 
	
' end sub 

' sub DMAControl(byval dmainstruct as ubyte )
' 	' 0 stop 1 start 
' 	if dmainstruct=0
' 		asm 
' 			ld bc,107		; dma port 
' 			ld a,$83			; disable DMA
' 			out (c),a 
' 		end asm 
' 	else 
' 		asm 
' 			ld bc,107		; dma port 
' 			;ld a,$c0			; ready 
' 			;out (c),a 
' 			ld a,$87			; START DMA
' 			out (c),a 
' 		end asm 
' 	endif 
' end sub

' SUB DMAUpdate(byval scaler as ubyte)
' 	'
' 	asm 
	
' 		; quick sets DMA 
' 		; a = new value on entry 
' 		ld e,a
' 		ld bc,$6b		; DMAPORT
' 		ld a,$68		; R2-PORT B ADDRESS
' 		out (c),a
' 		ld a,$22		; CYCLE LENGTH PORT
' 		out (c),a
' 		ld a,e			;new prescaler value 
' 		out (c),a
' 		;ld a,$cf		; R6-LOAD we will now start from the begining 
' 		;out (c),a
' 		ld a,$87		; R6-ENABLE DMA
' 		out (c),a
		
' 		ld bc,65533
' 		ld a,8 : out (c),a 

' 	end asm 
	
' end sub 

' Sub fastcall DMAPlay(byval address as uinteger,dmalen as uinteger, byval scaler as ubyte,byval repeat as ubyte)

' 	asm  
' 	Z80DMAPORT EQU 107
' 	SPECDRUM EQU $FFDF
' 	BUFFER_SIZE	EQU 8192
' 	;BREAK
' PLAY:
' 	ld (dmaaddress), HL 
' 	pop hl 
' 	EXX 
' 	pop hl : ld (dmadlength), hl 
' 	pop af : ld (dmascaler),a
' 	pop af : ; repeat flag 
' 	; deal with setting repeat flag
' 	cp 1 : jr z,setrepeaton
' 	ld a,$82 : jr setrepeaton+2
' setrepeaton:
' 	ld a,$b2

' 	ld (dmarepeat),a
	
' 	; LOAD DMA 

' 	LD HL,DMA
' 	LD B,DMAEND-DMA
' 	LD C,Z80DMAPORT
' 	OTIR
	
' LOOPA:
			
' ld bc,65533
' ld a,8 : out (c),a 
' 	JP DMAEND
	
' 	LD C,Z80DMAPORT
' WAITFBA:
' 	IN A,(C)
' 	BIT 2,A
' 	JR NZ,WAITFBA
	
' DMA:

' 	DEFB $C3			;R6-RESET DMA
' 	DEFB $C7			;R6-RESET PORT A TIMING
' 	DEFB $CA			;R6-SET PORT B TIMING SAME AS PORT A

' 	DEFB $7D 			;R0-TRANSFER MODE, A -> B
' dmaaddress:
' 	DEFW $e000	;R0-PORT A, START ADDRESS
' dmadlength:
' 	DEFW 8192	;R0-BLOCK LENGTH

' 	DEFB $54 			;R1-PORT A ADDRESS INCREMENTING, VARIABLE TIMING
' 	DEFB $3			;R1-CYCLE LENGTH PORT B

' 	DEFB $68			;R2-PORT B ADDRESS FIXED, VARIABLE TIMING
' 	DEFB $22			;R2-CYCLE LENGTH PORT B 2T WITH PRE-ESCALER
' 	;DEFB 27			;R2-PORT B PRE-ESCALER
' dmascaler:
' 	DEFB 100			;R2-PORT B PRE-ESCALER
' 	;		  DEFB 255			;R2-PORT B PRE-ESCALER

' 	;		  DEFB $AD 		;R4-CONTINUOUS MODE
' 	DEFB $CD 			;R4-BURST MODE
' 	DEFW 49149		;R4-PORT B, START ADDRESS

' 	;DEFB $B2			;R5-RESTART ON END OF BLOCK, /CE + /WAIT, RDY ACTIVE LOW
' 	;DEFB $A2			;R5-RESTART ON END OF BLOCK, RDY ACTIVE LOW
' dmarepeat:			; $B2 for short burst $82 for one shot 
' 	DEFB $82			;R5-STOP ON END OF BLOCK, RDY ACTIVE LOW
' 	;
' 	DEFB $BB			;READ MASK FOLLOWS
' 	DEFB $100			;MASK - ONLY PORT A HI BYTE

' 	DEFB $CF			;R6-LOAD
' 	DEFB $B3			;R6-FORCE READY
' 	DEFB $87			;R6-ENABLE DMA
		  
' DMAEND:
' 	exx 
' 	push hl
	
' 	end asm 

' end sub 
sub newmouse()
	asm 
	; Jim bagley mouse routines, clamps mouse and dampens x & y 
	ld	de,(nmousex)
	ld (omousex),de
	ld	a,(mouseb)
	ld (omouseb),a
	
	call getmouse
	ld (mouseb),a
	ld (nmousex),hl

	ld a,l
	sub e
	ld e,a
	ld a,h
	sub d
	ld d,a
	ld (dmousex),de	;delta mouse
	
	ld d,0
	bit 7,e
	jr z,bl
	dec d
bl: 
	ld hl,(rmousex)
	add hl,de
	ld bc,4*256
	call rangehl
	ld (rmousex),hl
	sra  h
	rr l
	sra h
	rr l
	ld a,l
	ld (mousex),a
	ld de,(dmousey)
	ld d,0
	bit 7,e
	jr z,bd
	dec d
bd: 
	ld hl,(rmousey)
	add hl,de
	ld bc,4*192+64
	call rangehl
	ld (rmousey),hl
	sra  h
	rr l
	sra h
	rr l
	ld a,l
	ld (mousey),a

	jp mouseend
	
getmouse:
	ld	bc,64479
	in a,(c)
	ld l,a
	ld	bc,65503
	in a,(c)
	cpl
	ld h,a
	ld (nmousex),hl
	ld	bc,64223
	in a,(c)
	ld (mouseb),a
	ret
rangehl:
	bit 7,h
	jr nz,mi
	or a
	push hl
	sbc hl,bc
	pop hl
	ret c
	ld	h,b
	ld l,c
	dec hl
	ret
mi:
	ld hl,0
	ret

mousex:
	db	0
mousey:
	db	0
omousex:
	db	0
omousey:
	db	0
nmousex:
	db	0
nmousey:
	db	0
mouseb:
	db	0
omouseb:
	db	0
rmousex:
	dw	0
rmousey:
	dw	0
dmousex:
	db	0
dmousey:
	db	0

mouseend:
	ld a,(mouseb)
	ld (Mouse),a
	ld a,(mousex)
	ld (Mouse+1),a
	ld a,(mousey)
	ld (Mouse+2),a
	
	end asm 
end sub 

Mouse:
ASM
Mouse:
			db	0
			db	0
			db	0
end asm 


' sub drawallchars()
	' s$=""
	
	' for my=0 to 23
	' for mx=0 to 41 
		' printat42(my,mx)
		' p=peek(ubyte,@ScreenData+moff)
		' s$=str$(p)
		' print42(s$)
		' moff=moff+1
		' next mx 
	' next my 

	' moff=0
' end sub 

' Sub RightClick()
	' menu = 1
	' DrawPanel(0,9,20,6,0)
	' beep .001,3
	' AddMenuOption(1,2,10,"1 = HELLO")
	' AddMenuOption(2,2,11,"2 = Menu Options")
	' AddMenuOption(3,2,12,"3 = Another Option")
	' AddMenuOption(4,2,13,"4 = Testing")
	' AddMenuOption(5,2,14,"5 = I can't code")
' end sub 

' Sub RightClickTwo()
	' asm 
		' ;BREAK 
		' ld hl,.__LABEL__ScreenData
		' ld (hl),0
		' ld de,__LABEL__ScreenData+1
		' ld bc,42*24
		' ldir 
	' end asm 
	' cls 
	' menu = 1

	' xx=mox/8 : yy = moy/8
	' w=13 : h=6
	' if xx+w>30 : xx = 30-w : endif 
	' if yy+h>23 : yy = 23-h : endif 
	' DrawPanel(0,9,20,6,0)
	' DrawPanel(xx,yy,w,h,0)
	' xx=xx*8/6
	' xx=xx+2 : yy = yy + 1
	' AddMenuOption(1,xx,yy,"Change Border")
	' AddMenuOption(2,xx,yy+1,"Change Paper")
	' AddMenuOption(3,xx,yy+2,"Change Ink")
	' AddMenuOption(4,xx,yy+3,"Beep")
	' AddMenuOption(5,xx,yy+4,"Reset")
' end sub 

' Sub DrawPanel(x as ubyte, y as ubyte, w as ubyte, h as ubyte, e as ubyte)

 	' print at y,x;"\a"
	' for c=x+1 to x+w+1
		' print at y,c;"\b"
		' print at y+h,c;"\h"
	' next 
	' print at y,c-1;"\c"
	' for d=y+1 to y+h-1
		' print at d,c-1;"\f"
		' print at d,x;"\d"
	' next 
	' print at d,x;"\g"
	' print at d,c-1;"\i"
' end sub 

' sub AddMenuOption(id as ubyte, tx as ubyte, ty as ubyte, m$ as string)
	
	'strlen = len(m$)		' length of msg
	' printat42(ty,tx)
	' print42(chr(17)+chr(6)+m$)
	' addr=cast(uinteger,ty)*42+tx
	' mapaddr=@ScreenData+addr
	' poke ubyte mapaddr,id
	' asm 	

		' ld b,0
		' ld l,(IX+10)
		' ld h,(IX+11)
		' ld a,(hl) ; length 
		' dec a 
		' ld hl,(._mapaddr)
		' ld c,a
		' ld d,h
		' ld e,l
		' inc de 
		' ldir
	' end asm 
' end sub 

' ScreenData:
	' ASM 
		' DEFS 1048,0
	' end asm 
' sub doay(uint as uinteger)
' 	asm 
' 			ld hl,(._toneaddress)
' 			ld (snddat),hl
' 		w8912: 
' 			ld hl,snddat         ; start of AY-3-8912 register data.
' 			ld e,0             ; start with register 0.
' 			ld d,14         ; 14 to write.
' 			ld c,253         ; low byte of port to write.
' 		w8912a:
' 			ld b,255         ; 255*256+253 = port 65533 = select soundchip register.
' 			out (c),e         ; tell chip which register we're writing.
' 			ld a,(hl)         ; value to write.
' 			ld b,191         ; 191*256+253 = port 49149 = write value to register.
' 			out (c),a         ; this is what we're putting there.
' 			inc e             ; next sound chip register.
' 			inc hl             ; next byte to write.
' 			dec d             ; decrement loop counter.
' 			jp nz,w8912a         ; repeat until done.
' 			jr aysubdone
			
' 		snddat:
' 			defw 1018/2             ; tone registers, channel A.
' 			defw 0             ; channel B tone registers.
' 			defw 0             ; as above, channel C.
' 		sndwnp:        
' 			defb 0             ; white noise period.
' 		sndmix;         
' 			defb 60         ; tone/noise mixer control.
' 		sndv1:        
' 			defb 15             ; channel A amplitude/envelope generator.
' 		sndv2:        
' 			defb 0             ; channel B amplitude/envelope.
' 		sndv3:       
' 			defb 0             ; channel C amplitude/envelope.
' 		sndenv:
' 			defw 600         ; duration of each note.
' 			defb 0
' 		aysubdone:

' 	end asm 
' end sub 

' tonetable:
' 	asm 
' 		dw $0C21,$0B73,$0ACE,$0A33,$09A0,$0916,$0893,$0818,$07A4,$0736,$06CE,$066D
' 		dw $0610,$05B9,$0567,$0519,$04D0,$048B,$0449,$040C,$03D2,$039B,$0367,$0336
' 		dw $0308,$02DC,$02B3,$028C,$0268,$0245,$0224,$0206,$01E9,$01CD,$01B3,$019B
' 		dw $0184,$016E,$0159,$0146,$0134,$0122,$0112,$0103,$00F4,$00E6,$00D9,$00CD
' 		dw $00C2,$00B7,$00AC,$00A3,$009A,$0091,$0089,$0081,$007A,$0073,$006C,$0066
' 		dw $0061,$005B,$0056,$0051,$004D,$0048,$0044,$0040,$003D,$0039,$0036,$0033
' 		dw $0030,$002D,$002B,$0028,$0026,$0024,$0022,$0020,$001E,$001C,$001B,$0019
' 		dw $0018,$0016,$0015,$0014,$0013,$0012,$0011,$0010,$000F,$000E,$000D,$000C
' 	end asm 