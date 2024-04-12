'!ORG=24576
'!HEAP=4096 
'#!copy=h:\nextsidplayer.nex

' Press F6 and choose Run In CSpect
' NextSIDPlayer     - em00k 
' NextSID Engine    - 9bitcolor
' 

#define NEX
#include <nextlib.bas>
#include <print42.bas>
#include <hex.bas>
#include <string.bas>

backupsysvar() 

asm 
	; set up some standard nextregs 
	nextreg NEXT_RESET_NR_02,128			; silence esp 
	nextreg PERIPHERAL_3_NR_08,$FE			; contention off 
	nextreg TURBO_CONTROL_NR_07,3			; 28mhz 
	nextreg PALETTE_VALUE_NR_41,0 			; ' Global transparency bits 7-0 = Transparency color value (0xE3 after a reset)
	nextreg LAYER2_RAM_BANK_NR_12,12
	nextreg PALETTE_CONTROL_NR_43,1
	nextreg LAYER2_RAM_SHADOW_BANK_NR_13,15 
	nextreg SPRITE_CONTROL_NR_15,%000011011
	nextreg PALETTE_FORMAT_NR_42,7
	nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0	; fall back trans colour 
	nextreg GLOBAL_TRANSPARENCY_NR_14,0
end asm 

LoadSDBank("nextsid.bin",0,0,0,33)          ' the NextSID engine
LoadSDBank("newsprites3.spr",0,0,0,31)      ' pointer and vumeters
LoadSDBank("/pt3/lemotree.pt3",0,0,0,34)         ' initial tune
LoadSDBank("mainbk5.nxp",0,0,0,23)          ' palette 
LoadSDBank("notetable.bin",0,0,0,65)        ' notetable for barvus
LoadSDBank("mainbk5.sl2",0,0,0,24)          ' back ground 

paper 0 : ink 6: border 0 : cls

asm 
	nextreg PALETTE_CONTROL_NR_43, %00010001
end asm 


PalUpload($c000,0,0,23)                     ' init the palette 
InitSprites(31,0,31)                        ' init the sprites 

' variables 

dim x,y,mbutt,oldmox, oldmoy, mousemapid, menu,rx,ry, click, rx2  as ubyte
dim b,p,i,xx,yy,ex as ubyte
dim temp_ch_len,moff,my,mx,addr,moy,mox,count as uinteger
dim s$ as string
dim temp_wav_len,playing, tempbyte,tsize  as ubyte
dim tlen, detune_a, detune_b, detune_c, temp_wav_add, debugv as uinteger
dim off as uinteger
dim ticker,oldw as ubyte 
dim sequence,updated,clicktimer,timing as ubyte 
dim tempo as ubyte =3  ' 4 ticks
dim patternpos as ubyte 
dim patternposlast,inkcol,showdebug,audiomask,lastclick as ubyte 
dim psgclock as ulong = 1750000
dim hdmi as ulong = 0
dim notes$,file$,t$,fname$,songinfo$ as string 
dim cha_shift, chb_shift, chc_shift as ubyte 
dim files$(256)
dim size(256) as ulong
dim selxx, selyy,opx,opy,ppx,ppy,col,max,maxoffset,oldcolour,newcol as ubyte 
dim cha_state, chb_state, chc_state as ubyte 
dim cha_wave_len, chb_wave_len, chc_wave_len, chan_select as ubyte 
dim loadstate as ubyte = 0 
dim sinoff as ubyte = 0
dim sinspeed as ubyte = 2

t$="                                "
sequence = 0 : patternpos = 0 

' includes 
#include <..\NextSID-inc.bas>
#include <..\stars.bas>

menu = 0 

asm 

    ; this is require to setup the NextSID engine 

	nextsid_init EQU 0x0000E098

	nextsid_set_waveform_A  EQU 0x0000E07A
	nextsid_set_waveform_B  EQU 0x0000E081
	nextsid_set_waveform_C  EQU 0x0000E088
	nextsid_set_detune_A    EQU 0x0000E056
	nextsid_set_detune_B    EQU 0x0000E05A
	nextsid_set_detune_C    EQU 0x0000E05E
	nextsid_wavelen_A       EQU 0x0000E341
	nextsid_wavelen_B       EQU 0x0000E36C
	nextsid_wavelen_C       EQU 0x0000E397
	nextsid_shift_C         EQU 0x0000E24D
	nextsid_set_shift_C     EQU 0x0000E076
	nextsid_shift_B         EQU 0x0000E226
	nextsid_set_shift_B     EQU 0x0000E072
	nextsid_shift_A         EQU 0x0000E1FF
	nextsid_set_shift_A     EQU 0x0000E06E

	nextsid_play            EQU 0x0000E007
	nextsid_stop            EQU 0x0000E011
	nextsid_mode            EQU 0x0000E2D7
	nextsid_pause           EQU 0x0000E000
	nextsid_reset           EQU 0x0000E38C
	nextsid_set_pt3         EQU 0x0000E025

	init                    EQU 0x0000E3F9
	nextsid_set_psg_clock   EQU 0x0000E04E
	nextsid_vsync           EQU 0x0000E08F

	nextreg     $57,33					        ; put nextsid in place
	irq_vector	            equ	65022			;     2 BYTES Interrupt vector
	stack		            equ	65021		    ;   252 BYTES System stack
	vector_table	        equ	64512           ;   257 BYTES Interrupt vector table	
	startup:	di                              ; Set stack and interrupts
	ld	    sp,stack                            ; System STACK

	nextreg	TURBO_CONTROL_NR_07,%00000011       ; 28Mhz / 27Mhz

	ld      hl,vector_table	; 252 (FCh)
	ld      a,h
	ld      i,a
	im      2

	inc     a                                   ; 253 (FDh)

	ld      b,l                                 ; Build 257 BYTE INT table
	.irq:	
    ld      (hl),a
	inc	    hl
	djnz    .irq                                ; B = 0
	ld      (hl),a

	ld      a,$FB                               ; EI
	ld      hl,$4DED                            ; RETI
	ld      (irq_vector-1),a
	ld      (irq_vector),hl

	ld      bc,0xFFFD                           ; Turbosound PSG #1
	ld      a,%11111111
	out     (c),a


	nextreg VIDEO_INTERUPT_CONTROL_NR_22,%00000100
	nextreg VIDEO_INTERUPT_VALUE_NR_23,255

	ld      sp,stack                            ; System STACK
	ei

	; Init the NextSID sound engine, setup the variables and the timers.

	ld      de,0                                ; LINE (0 = use NextSID)
	ld      bc,192                              ; Vsync line
	call    nextsid_init                        ; Init sound engine

	; Setup a duty cycle and set a PT3.

	call    nextsid_stop                        ; Stop playback
	
	; channel b 
	ld      hl,test_waveformb
	ld      a,16-1                              ; 16 BYTE waveform
	call    nextsid_set_waveform_B

	ld      hl,16                               ; Slight detune
	call    nextsid_set_detune_B

	; channel a 
	ld      hl,test_waveforma
	ld      a,16-1                              ; 16 BYTE waveform
	call    nextsid_set_waveform_A

	ld      hl,3                                ; Slight detune
	call    nextsid_set_detune_A

	ld      hl,$a000                            ; Init the PT3 player.
	ld      a,34                                ; Bank8k a 1st 8K
	ld      b,35                                ; Bank8k b 2nd 8K
	
	call    nextsid_set_pt3

	nextreg $55,34
	nextreg $56,35
	
	call    init                                ; VT1-MFX init as normal

	nextreg $55,5 
	nextreg $56,0
	nextreg $57,33

	call    nextsid_play                        ; Start playback

end asm 


' setup 
' 
    timing      =GetReg($11)	' video timing 
    cha_wave_len=15
    chb_wave_len=15 
    chc_wave_len=15
    cha_state   =0
    chb_state   =0
    chc_state   =1
    detune_a    =15 
    detune_b    =3 
    detune_c    =0
    temp_wav_add=0000
    temp_wav_len=cha_state
    displaywaveform(0)
    adjustwavelength(0,3)
    ShowLayer2(1)
    playing     =1 
    cha_shift   =0
    chb_shift   =0
    chc_shift   =0

    asm 
		di 
		nextreg $50,34 
	end asm 
		PeekMemLen(30,69,songinfo$)
	asm 
		nextreg $50,$FF
		ei
    end asm 

' Main loop 
' 

do 			
	asm 
		call	nextsid_vsync                   ' synchronisation is handled by the NS engine 
	end asm 	

 if loadstate = 0 
    ' we are not loading 
	checkkeys()
	updatevumeters()
	barvus()
 	processMouse()
 endif 

 if loadstate=1 
    ' we are loading 
 	updatestars()
	processMouse2()
	barvus()
	checkkeys()
 endif 

loop

'
' Subroutines 
'

sub barvus()
    ' draws note bar vumeters 
    '
	dim x,sprvol,sval   as ubyte
    dim a               as uinteger

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
    '    y = peek (@sindata+cast(uinteger,sinoff))      ' enables vu y sine scroll
        y = 0 
		sprvol=peek(@bardata+cast(uinteger,x))
		UpdateSprite(cast(uinteger,(x<<3))+32,192+32-y,x+1,sprvol,1<<6,%00000000)
        
	next x 
    sinoff = (sinoff + sinspeed) band 63 
	asm 
	 	ld      hl,bardata
	 	ld      b,32 
	 decloop:
	 	ld      a,(hl)
	 	or      a : jr z,nodec 
	 	dec     (hl)
	 nodec:
	 	inc     hl 
	 	djnz    decloop
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

sub mono()
	asm 
		getreg(09)
		xor 224
		nextreg $09,a 
	end asm 
	audiomask = 10 
	border audiomask
end sub 

sub enable_cha()
	if cha_state=0
		asm 
			ld	hl,test_waveforma ; Duty cycle ON
			ld a,(._cha_wave_len)
			call	nextsid_set_waveform_A
		end asm 
	else 
		asm 
			ld	hl,noduty_waveform ; Duty cycle OFF
			ld a,(._cha_wave_len)
			call	nextsid_set_waveform_A
		end asm 
		cha_state = 1
	endif 
	if loadstate=0
		print at 2,2;paper 2-(cha_state<<1);"    "
	endif 
end sub 


sub enable_chb()
	if chb_state=0
		asm 
			ld	hl,test_waveformb; Duty cycle ON
			ld a,(._chb_wave_len)
			call	nextsid_set_waveform_B
		end asm 
	else 
		asm 
			ld	hl,noduty_waveform ; Duty cycle OFF
			ld a,(._chb_wave_len)
			call	nextsid_set_waveform_B
		end asm 
		chb_state = 1
	endif 
	if loadstate=0
		print at 4,2;paper 2-(chb_state<<1);"    "
	endif 
end sub 


sub enable_chc()
	'dim papercol as ubyte 
	if chc_state=0
	'	papercol = 2
		asm 
			ld	hl,test_waveformc ; Duty cycle ON
			ld a,(._chc_wave_len)
			call	nextsid_set_waveform_C
		end asm 

	else 
	'	papercol = 0  
		asm 
			ld	hl,noduty_waveform ; Duty cycle OFF
			ld a,(._chc_wave_len)
			call	nextsid_set_waveform_C
		end asm 
		chc_state=1
	endif 
	if loadstate=0
		print at 6,2;paper 2-(chc_state<<1);"    "
	endif 
end sub 

sub detune_cha_a(adder as ubyte)
	if adder=1
		' increase 
		detune_a=detune_a+1
	elseif adder=2 
			' increase 
			detune_a=detune_a-1
	endif 
	asm 
		ld hl,(._detune_a)
		call nextsid_set_detune_A
	end asm 

end sub 


sub detune_cha_b(adder as ubyte)
	if adder=1
		' increase 
		detune_b=detune_b+1
	elseif adder=2 
			' increase 
			detune_b=detune_b-1
	endif 
	asm 
		ld hl,(._detune_b)
		call nextsid_set_detune_B
	end asm 


end sub 


sub detune_cha_c(adder as ubyte)
	if adder=1
		' increase 
		detune_c=detune_c+1
	elseif adder=2 
			' increase 
			detune_c=detune_c-1
	endif 
	asm 
		ld hl,(._detune_c)
		call nextsid_set_detune_C
	end asm 

end sub 

sub updatevumeters()
	asm 
		ld      hl,22528+64+10			; bar cha a 
		ld      bc,65533
		ld      a,8
		out     (c),a 
		in      a,(c)
		and     15
		or      a 
		call    nz,makevu 

		ld      hl,22528+64+64+10			; bar cha a 
		ld      bc,65533
		ld      a,9
		out     (c),a 
		in      a,(c)
		and     15
		or      a  
		call    nz,makevu 

		ld      hl,22528+64+64+64+10			; bar cha a 
		ld      bc,65533
		ld      a,10
		out     (c),a 
		in      a,(c)
		and     15
		or      a
        jr      z,skipcha

	makevu:
		ld      c,16
		ld      b,a 
		sll     a
		or      $10101
		ld      d,a 
		ld      e,8 
		mul     d,e 
		ld      a,e
	drawloop:
		ld      (hl),a 
		inc     hl 
		dec     c 
		djnz    drawloop 
		ld      a,6
	blankend:
		ld      (hl),a
		inc     hl
		dec     c 
		jr      nz,blankend
	skipcha:
	end asm 
		
end sub 

sub processMouse2()
	
	dim     rx2     as ubyte 
    dim     sprx    as uinteger
    dim     spry    as ubyte

	newmouse() : oldmox=mox : oldmoy=moy : 
	mox=peek(@Mouse+1) :  moy=peek(@Mouse+2) :  mbutt=peek(@Mouse)
	
	if click = 0 
		rx = mox / 8 : ry = moy / 8
		sprx=(32+cast(uinteger,mox)) : spry=(32+moy)
		UpdateSprite(sprx,spry,0,16,0,0)
	endif 

	if mbutt band 15=13 and click = 0 		'				 left mb
		position = (maxoffset+rx/6*23+(ry))-1
		ink 2
		'print at 0,12;position;" ";max
		if clicktimer=0 
			if  position<max
				if size(position) > 0                   ' its a file 
					lastclick=position                  ' save click counter
					'pause 0 
					loadpt3(position) 
				elseif size(position)=0
					UpdateSprite(sprx,spry,0,17,0,0)
					file$=files$(position)
					if tempbyte=0 
						changedir(file$)
						cls 
						lastclick=255
						readdir()
						DrawRequester()
					endif 
				endif 	
				printat64(0,15)
				print64(files$(position)( to 31)+" - "+str(size(position))+"bytes  ")	
				clicktimer = 12
				click = 1	
				DrawColours()
			endif 
		endif 	
	elseif mbutt band 15=14	and click=0                     ' right mb
		mainpage()
	ELSEIF mbutt band 15 = 15                               ' no mouse, used for button debounce
		if clicktimer>0 
			clicktimer=clicktimer-1
		else
		click=0
		endif 
		
	endif 

end sub 

sub mainpage()
    ' shows the main NextSIDPlayer page
	cls 
	ShowLayer2(1)
	asm 
		nextreg SPRITE_CONTROL_NR_15,%000011011
	end asm 
		loadstate=0
		displaywaveform(chan_select)
	ink 6
end sub 

sub fastcall nextsid_stop()
	asm 
		call nextsid_stop 
	end asm 
end sub 


sub fastcall nextsid_play()
	asm 
		call nextsid_play
	end asm 
end sub 

sub fastcall nextsid_pause()
	asm 
		call nextsid_pause
	end asm 
end sub 

sub processMouse()
	' main page mouse 
	dim rx2 as ubyte 
	newmouse() : oldmox=mox : oldmoy=moy : 
	mox=peek(@Mouse+1) :  moy=peek(@Mouse+2) :  mbutt=peek(@Mouse)
	
	if click = 0 
		rx = mox / 8 : ry = moy / 8
		sprx=(32+cast(uinteger,mox)) : spry=(32+moy)
		UpdateSprite(sprx,spry,0,16,0,0)
	endif 

	if mbutt band 15=13 and click = 0 		'				 left mb
		'updatecursor()
		'click = 1
		' enable SID voices 
		if rx>1 and rx<6 
			if ry = 2
				cha_state=1-cha_state
				enable_cha()
				click = 1 
			elseif ry = 4
				chb_state=1-chb_state
				enable_chb()
				click = 1 
			elseif ry = 6
				chc_state=1-chc_state
				enable_chc()
				click = 1 
			endif 

		endif 

		if rx>=0 and rx<=1

			if ry = 2 
				adjustshiftlength(0,1)
				click = 1 
			elseif ry = 4
				adjustshiftlength(1,1)
				click = 1 
			elseif ry = 6
				adjustshiftlength(2,1)
				click = 1 
			endif 

		endif 
		
		' ch wave form 
		if rx >6 and rx < 9

			if ry = 2 
				chan_select=0
				displaywaveform(chan_select)
				click = 1 
			elseif ry = 4 
				chan_select=1
				displaywaveform(chan_select)
				click = 1 
			elseif ry = 6 
				chan_select=2
				displaywaveform(chan_select)
				click = 1 
			endif
			
		endif 


		' detune 
		if ry = 2 
			if rx =26
				detune_cha_a(2)
			elseif rx =27
				detune_cha_a(1)
			endif 

		elseif ry=4
			if rx =26
				detune_cha_b(2)
			elseif rx=27
				detune_cha_b(1)
			endif 

		elseif ry=6 
			if rx =26
				detune_cha_c(2)
			elseif rx =27
				detune_cha_c(1)
			endif 

		elseif ry=9 
			if rx=26 
				' reduce wav mask 
				adjustwavelength(chan_select,0)
			elseif rx=27 
				' increase wav mask 
				adjustwavelength(chan_select,1)
			endif 
			click = 1
		elseif ry=22	'; save nt3 pause abc/acb mono/ste quit 
			rx2 = int((rx-1)/6)
			if rx2=0  'save nt3
				savent3()
			elseif rx2=1   ' pause 
				asm 
					call nextsid_pause 
				end asm 
			elseif rx2=2
				abc()
			elseif rx2=3 
				mono()
			endif 
			click = 1
			'print at 23,0;rx2;" ";22			

		elseif ry = 21 
			' load nt3, stop, - -50 +50 
			rx2 = int((rx-1)/6)
			if rx2=0  'load nt3 
				loadnt3()
				setnt3()
				refreshsettings()
			elseif rx2=1   ' stop 
				nextsid_stop()

			elseif rx2 = 2 
				chiptype()	' swap ay/ym 

			elseif rx2 = 3
				' detune 
				if psgclock>500
					psgclock = psgclock - 50 
					setpsgclock(psgclock)
				endif 

			elseif rx2 = 4
				psgclock = psgclock + 50 
				setpsgclock(psgclock)

			endif 
			click = 1

		elseif ry = 20  
			'; load play blank -- ++

			rx2 = int((rx-1)/6)
			click = 1
			' refreshsettings()
			if rx2=0  'load pt3
				' empty 
				'Browser("Pick a file","PT3")
				ShowLayer2(0)
				asm 
					nextreg SPRITE_CONTROL_NR_15,%000001011
				end asm 
				cls 
				' nextsid_pause()
				UpdateSprite(sprx,spry,0,17,0,0)
				readdir()
				DrawRequester()
				
				loadstate=1					' turn on load mode 
				' nextsid_pause()
			elseif rx2=1   ' play
				playing = 1
				asm 
					call nextsid_play
				end asm 
			elseif rx2=2   ' reset
				defaultsettings()
			elseif rx2 = 3
				' detune 
				if psgclock>500
					psgclock = psgclock - 500 
					setpsgclock(psgclock)
				endif 
				click = 0

			elseif rx2 = 4
				psgclock = psgclock + 500 
				setpsgclock(psgclock)
				click = 0

			endif 

		elseif ry = 3 or ry = 5 or ry = 7 
			if rx >=10 and rx<=26
				if ry = 3 ' cha 		
				elseif ry = 5 ' chb 
				elseif ry =7 'chc 
				endif 
			endif 
		else 
		
			if ry > 10 and ry <20			' size of edit window 
				if editmode = 0 			' ignore of edit mode is on
					drawwavpartial(rx<<1)
				endif 
			endif

		endif 

		if click = 1 and ry >19 and loadstate=0
			print at ry,1+int((rx-1)/6)*6;paper 2;over 1;"      "
			refreshsettings()
		endif 

		if loadstate=0 
			refreshsettings()
		endif 
		'instvolume=40
		'updatecursor()
		
	elseif mbutt band 15=14	and click=0						' right mb
		
		if rx>=0 and rx<=1

			if ry = 2 
				adjustshiftlength(0,0)
				click = 1 
			elseif ry = 4
				adjustshiftlength(1,0)
				click = 1 
			elseif ry = 6
				adjustshiftlength(2,0)
				click = 1 
			endif 

		endif 
		if loadstate=0 
			refreshsettings()
		endif 
	ELSEIF mbutt band 15 = 15						' no mouse, used for button debounce
		if click = 1 and ry >19 and loadstate=0
			print at ry,1+int((rx-1)/6)*6;paper 0;over 1;"      "
		endif 
		click=0
 endif

end sub

sub defaultsettings()
	asm 
		ld hl,defaults
		ld de,header
		ld bc,134
		ldir
	end asm 
	setnt3()
end sub 

sub fastcall setpsgclock(clock as ulong)

	asm  
		ex de,hl
		call nextsid_set_psg_clock
	end asm 

end sub 

sub abc()

	asm 
		getreg(08)
		xor %00100000
		nextreg $08,a 
	end asm 

end sub 

sub chiptype()

	asm 
		getreg(06)
		xor %1
		nextreg $06,a 
	end asm 

end sub 

sub fastcall PeekString2(address as uinteger,byref outstring as string)
    asm  
    ex de, hl 
    pop hl 
    ex (sp), hl
    jp .core.__STORE_STR 
    end asm 
end sub

sub DrawRequester()
	CLS : Border 0

	col = 0 : xx = 0 : yy = 1  
	'if count-maxoffset>114 : max = max : else max = count-maxoffset : endif 
	for x=maxoffset to max -1
		printat64(yy,xx)
		'ext$=right$(files$(x)(to ),3)
		'getextcolour(ext$)
		 
 		if size(x)>0
 			ink 6
			else 
			ink 2

 		endif 
		if x=lastclick
			ink 5
		endif 
		print64(files$(x)(  to 11))
		yy=yy+1
		if yy=24
			col=col+1
			yy =1 : xx=peek(@coloffsets+cast(uinteger,col))
			if xx>=64 : col = 0 : xx = 0 : yy = 1 : endif 
		endif 
	next 
	ink 5
	ppx = peek(@xxoffset+cast(uinteger,selxx))
	ppy = selyy  
	' print at ppy+1,ppx;over 1;"\::\::\::\::\::\::"
	printat64(0,0)
	print64("Found "+str(count)+" items") : yy = 1 
	makestars()
end sub 

sub DrawColours()
    ' draws the colours over the button when clicked 
	col = 0 : xx = 0 : yy = 1  
	'if count-maxoffset>114 : max = max : else max = count-maxoffset : endif 
	for x=maxoffset to max -1
 		if size(x)>0
 			ink 6 
			else 
			ink 2

 		endif 
		if x=lastclick
			ink 5
		endif 
		print at yy,xx;over 1;"       "
		yy=yy+1
		if yy=24
			col=col+1
			yy =1 : xx=xx+6
			if xx>=64 : col = 0 : xx = 0 : yy = 1 : endif 
		endif 
	next 
	' 0,6,12
end sub 

sub readdir()

    ' this is horrible and needs rewriting...
    ' reads the folders for pt3 files 
    count = 0 
	ink 6
	border 0 
	printat42(0,0)
	print42("Reading dir...")
        asm 
            ;; BREAK 
            f_esxdos					 equ $08
            m_getsetdrv 			 equ $89
            f_opendir          equ $a3 ;(163) open directory for reading 
            f_readdir          equ $a4 ;(164) read directory entry 
            f_rewinddir        equ $a7 ; (167) Rewind the dir 
            f_getcwd		       equ $a8 ; (167) get current working directory 
            f_close						 equ $9b
            ;di
                push ix 
        initdrive:

                ld a,'*'
                ld ix,dirbuffer
                rst f_esxdos : DB f_getcwd
                
                ld b,$10
                ld a,'*'
                ld ix,dirbuffer
                rst f_esxdos : db f_opendir
                
                ld (handle),a				; a = dir handle 
                rst f_esxdos : db f_rewinddir
        dirloop:		
                ld a,(handle)
                ld ix,dirbuffer
                rst f_esxdos : db f_readdir				
            
                or a
                jp z,donedir			; no more entries
                jp c,donedir 			; fail, a = error code 
                
                genlenthtloop:
                ld hl,dirbuffer
                ld a,(hl) : or a : jr z,donelength : inc c : ld a,c : or a : jr z,donelength : inc hl : jr genlenthtloop 

        donelength:
                ;ld hl,stringtemp : ld a,c : ld (hl),a : inc hl : ld a,b : ld (hl),a : inc hl 
                ;ld hl,dirbuffer
                ;ex de,hl 
                ;ldir 

                pop ix 
        end asm 

		t$="" : tsize = 0
		PeekMem(@dirbuffera+7,0,t$)
		tsize=len(t$)
		size(count)=peek(ulong,@dirbuffera+7+cast(uinteger,tsize)+5)
		ext$=Lcase(Right(t$,3))
		if ext$="pt3" or t$(1)="." or size(count)=0
			files$(count)=t$
			size(count)=peek(ulong,@dirbuffera+7+cast(uinteger,tsize)+5)
			count = count + 1
			if count = 145
			count = 144
			asm : push ix : jp donedir : end asm 
			endif 
		endif 

    dirbuffera:
        asm 
                push ix 			; 2
                jp dirloop		; 3 
        handle:
                db 0 					; 1
        dirbuffer:
                defs 255,0
        dir: 
                DB "c:/"
        print_fname:
                ld a,(hl):inc hl:cp 0:ret z:rst 16:jr print_fname
        donedir:
                ld a,(handle) : rst f_esxdos : db f_close
                pop ix 
        end asm 

    if count>114 : max = 114 : else max = count : endif 

end sub 

sub fastcall PeekMem(address as uinteger,delimeter as ubyte,byref outstring as string)
    ' assign a string from a memory block until delimeter 
    asm 
        push namespace peekmem 
    main:        
        ex      de, hl 
        pop     hl 
        pop     af          ; delimeter 
        ex      (sp),hl         
        ;' de string ram 
        ;' hl source data 
        ;' now copy to string temp
		push    bc 
        push    hl 
        ex      de, hl 
        ld      de,.LABEL._stringtemp+2
        ld      bc,0 
    copyloop:
        cp      (hl)                 ; compare with a / delimeter 
        jr      z,endcopy            ; we matched 
        push    bc 
        ldi 
        pop     bc 
        inc     c
        jr      nz,copyloop          ; loop while c<>0
        dec     c 
    endcopy:
        ld      (.LABEL._stringtemp),bc 
        pop     hl 
        ld      de,.LABEL._stringtemp
        ; de = string data 
        ; hl = string
		pop     bc  
        pop     namespace
        jp      .core.__STORE_STR
    end asm 

end sub 


stringtemp:
asm 
stringtemp:
		defs 80,0
end asm 

sub changedir(byref dir as string)
    ' changes directory 
 	asm 

		f_changecwd                 equ $a9
		di 
		push    ix 
		ex      de,hl
		ld      c,(hl) : inc hl                     ; copy new dir name to temp location 
		ld      b,(hl) : inc hl 
		ld      de,.LABEL._filename     
		ldir 
		xor a : ld (de),a : ld (._tempbyte),a       ; zero terminated 
		ld      a,'*'
		rst     f_esxdos : db m_getsetdrv	
		 ; ; BREAK				
		jr      nc,chdirsuccess 
	    ld      (._tempbyte),a 
chdirsuccess:
		ld      (handle),a
		ld      ix,.LABEL._filename                 ; change dir 
		rst     f_esxdos : db f_changecwd	
		xor     a 
		ld      (._tempbyte),a 
		pop     ix 
		ei 
 end asm 
		
end sub 

sub getsonginfo()
    ' grab song info from pt3 file 
	PeekMemLen($a000,69,songinfo$)
end sub 

sub fastcall PeekMemLen(address as uinteger,length as uinteger,byref outstring as string)
    ' assign a string from a memory block with a set length 
    asm 

        ex      de, hl 
        pop     hl 
        pop     bc
        ex      (sp),hl         
        ;' de string ram 
        ;' hl source data 
        ;' now copy to string temp
        
        push    hl 
        ex      de, hl 
        ld      (stringtemp),bc 
        ld      de,stringtemp+2
        ldir 

        pop     hl 
        ld      de,stringtemp
        ; de = string data 
        ; hl = string 
        jp      .core.__STORE_STR

    end asm 

end sub 

sub backupsysvar() 

	asm 
		di 
		nextreg MMU7_E000_NR_57,90
		ld      hl,$5C00
		ld      de,$e000 
		ld      bc,256
		ldir 
		
	end asm 
'	SaveSD("sysvar.bin",$e000,256)
	asm
		nextreg MMU7_E000_NR_57,1
	end asm

end sub 

sub restoresys()

	asm 
	di 
		nextreg MMU7_E000_NR_57,90
		ld      de,$5C00
		ld      hl,$e000 
		ld      bc,256
		ldir 
		nextreg MMU7_E000_NR_57,1
	end asm 	

end sub

' these are the bit patterns that get applied to produce the duty cycles 
' 128, 000 etc is the default and produces the cleanest sound 
' 

wavea: 
asm 
wavea: 
test_waveforma:
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
end asm 

waveb: 
asm 
waveb: 
test_waveformb:
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
end asm 

wavec: 
asm 
test_waveformc:
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
end asm 


asm 
noduty_waveform:
 db 128,128,128,128,128,128,128,128
 db 128,128,128,128,128,128,128,128
 db 128,128,128,128,128,128,128,128
 db 128,128,128,128,128,128,128,128
end asm 

asm 
muted_waveform:
 db 0,0,0,0,0,0,0,0
 db 0,0,0,0,0,0,0,0
 db 0,0,0,0,0,0,0,0
 db 0,0,0,0,0,0,0,0
end asm 

notetable:
asm 
end asm 

ENDOFPROG:

coloffsets:
ASM 
	DB 0,13,26,39,52,64
END ASM 	
xxoffset:
ASM 
	DB 0,6,13,19,26
	DB 6,7,6,6,6
END ASM 	


Stardata:
asm 
' stores the star data, 250 stars * 3 for x, y & speed 
startdata:
		defs 250*3,0
		db 0
end asm 


header: 
' this is the version 1 of the nt3 header 
asm 
header: 
	db "NT3-1.0-KevB&em00k"		; header + 4-6 for version 
	dw 0000,0000				; psg clock   +18
	db 0						; bit mask bit 7 AY/YM 6 ABC/ACB 5 Mono/Stereo  +1
	db 0						; chan a size 			+1 
	ds 32,0						; chan a wav 			
	db 0 						; chan b size 
	ds 32,0						; chan b wav 
	db 0 						; chan c size
	ds 32,0						; chan c wav 
	ds 2,0						; chan a enable + shift
	ds 2,0						; chan a detune 
	ds 2,0						; chan b enable + shift
	ds 2,0						; chan b detune 
	ds 2,0						; chan c enable + shift
	ds 2,0						; chan c detune 
end asm 

defaults:
asm 
defaults:
	db "NT3-1.0-KevB&em00k"		; header + 4-6 for version 
	db $F0,$B3,$1A,$00				; psg clock   +18 1750 0000
	db 0						; bit mask bit 7 AY/YM 6 ABC/ACB 5 Mono/Stereo  +1
	db 15						; chan a size 			+1 
	db $80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0
	db $80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0
	db 15 						; chan b size 
	db $80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0
	db $80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0
	db 15 						; chan c size
	db $80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0
	db $80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0,$80,0
	db 0,3						; chan a enable + shift
	dw $0012					; chan a detune 
	db 0,3						; chan b enable + shift
	dw $0006					; chan b detune 
	db 1,3						; chan c enable + shift
	dw $0000					; chan c detune 
end asm 