'!org=32768
'!copy=h:\ctc_test_love.nex 
'#!nosysvars
'#!asm
' NextBuild Copper Audio v2 

' original CopperAudio by Lampros Potamianos used with permission
' optimized & adapted for nextbuild by em00k


#define NEX 
#define IM2 


#include <nextlib.bas>
#include <keys.bas>
asm 
	di 
	
end asm 
LoadSDBank("/lies/output.dat",0,0,0,31)					'; Load sample into bank 32-33
LoadSDBank("nextsid.bin",0,0,0,33)
' LoadSDBank("vt24000.bin",0,0,0,34)                  '; load the vt2 replayer 
' LoadSDBank("game.afb",0,0,0,36) 				' load an ayfx afb bank into bank 36
LoadSDBank("love.pt3",0,0,0,34) 				' load music.pt3 into bank 34
'LoadSDBank("lemotree.pt3",0,0,0,38) 				' load music.pt3 into bank 34

' backupsysvar() 

' register block
'
asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,256x192
    nextreg PERIPHERAL_3_NR_08,%0_1_011010      ; contention off 
    nextreg TURBO_CONTROL_NR_07,%11             ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,0         ; black 
    nextreg SPRITE_CONTROL_NR_15,%000_000_11    ; %000    S L U, %11 sprites on over border
    nextreg LAYER2_CONTROL_NR_70,%00_00_0000    ; 5-4 %01 = 320x256x8bpp 00 = 256x192 
    ; nextreg $22,00000010			; enable line interrupt 
end asm 

paper 0 : ink  6 : border 0 : cls 

' InitSFX(36)							' init the SFX engine, sfx are in bank 36
' InitMusic(34,38,0000)				' init the music engine 33 has the player, 34 the pt3, 0000 the offset in bank 34
' SetUpIM()							' init the IM2 code 
' EnableSFX
' EnableMusic


' Init_Music()
dim key as ubyte 
dim timer, oldpos as ubyte 
dim sample,pattern_position, pattern_position_index,play,sam,start,t as ubyte 
dim pattern_order_index, pattern_index as uinteger
dim sampleplay_position, last_sample_y as ubyte 
dim samples(8) as string 
samples(0)="0 Space "
samples(1)="1 Kick"
samples(2)="2 Snare"
samples(3)="3 HHat "
samples(4)="5 Snare"
samples(5)="            "
' pause 0 

' BBREAK 

play = 1 

draw_sample(0)
draw_sample(1)
draw_sample(2)
draw_sample(3)
' WaitKey()

nasty: 

asm 

        #include "symb.asm"


	    nextreg 	                $57,33					    ; put nextsid in place
	    irq_vector	                equ	65022			        ;     2 BYTES Interrupt vector
	    sidstack	                equ	24576				    ;   252 BYTES System stack
	    vector_table	            equ	64512		        ;   257 BYTES Interrupt vector table	
	    startup:	
        di					                ; Set stack and interrupts
	    ; ld	    sp,sidstack					; System STACK

	nextreg	TURBO_CONTROL_NR_07,%00000011	; 28Mhz / 27Mhz

	    ld	    hl,vector_table	            ; 252 (FCh)
	    ld	    a,h
	    ld	    i,a
	    im	    2

	    inc	    a							        ; 253 (FDh)

	    ld	    b,l							        ; Build 257 BYTE INT table
	.irq:	
        ld	    (hl),a
	    inc	    hl
	    djnz	.irq					        ; B = 0
	    ld	    (hl),a

	    ld	    a,$FB						        ; EI
	    ld	    hl,$4DED					        ; RETI
	    ld	    (irq_vector-1),a
	    ld	    (irq_vector),hl

	    ld	    bc,0xFFFD					; Turbosound PSG #1
	    ld	    a,%11111111
	    out	    (c),a


	    nextreg     VIDEO_INTERUPT_CONTROL_NR_22,%00000100
	    nextreg     VIDEO_INTERUPT_VALUE_NR_23,255

	    ; ld	    sp,sidstack					; System STACK
	    ; ei

	; Init the NextSID sound engine, setup the variables and the timers.

	    ld	    de,0						; LINE (0 = use NextSID)
	    ld	    bc,180						; Vsync line
	    call	nextsid_init			; Init sound engine

	; Setup a duty cycle and set a PT3.

	    call	nextsid_stop	; Stop playback
	
	; channel b 
	;    ld	    hl,noduty_waveform
	;    ld	    a,16-1		; 16 BYTE waveform
	;    call	nextsid_set_waveform_B

	;    ld	    hl,16		; Slight detune
	;    call	nextsid_set_detune_B

	; channel a 
	    ld	    hl,test_waveformc
	    ld	    a,16-1		; 16 BYTE waveform
	    call	nextsid_set_waveform_C

	    ld	    hl,1		; Slight detune
	    call	nextsid_set_detune_C
        ld      a, 3
        ld     (nextsid_shift_C),a 

	    ld	    hl,$a000 	; Init the PT3 player.
	    ld	    a,34		; Bank8k a 1st 8K
	    ld	    b,35		; Bank8k b 2nd 8K
	
	    call	nextsid_set_pt3

	    nextreg $55,34
	    nextreg $56,35
	
	    call	init		; VT1-MFX init as normal

	    nextreg $55,5 
	    nextreg $56,0
	    nextreg $57,33
        
	    
        ei 

end asm 

' do 
' border 0
' loop 
InitCopperAudio()

PlayCopperSample(5)

' draw_pattern()
SetCopperAudio()
do 
   
	
	CopperWaitLine()

    SetCopperAudio()
    
	' border 2

	' border 0  
    if t=0 and play = 1
          Play_Music()
     'y=0
    else 
         t=t+1 
    endif 


    if key=0 and play = 0
    '    print at sam,0;ink 2;samples(sam+1)
    endif 

	' timer = 6 / 125bmp MOD speed 6
	' timer = 5 / 125bmp MOD speed 5

    'if  peek (E2C7) = 0
    
    'endif 
    PlayCopperAudio()
    asm 
        call nextsid_vsync
    end asm
    
    if timer = 0 
        ' update_pattern()
        GetNextSample()                 ' grab next pattern row 
        timer = 5 
    else 
        timer = timer - 1
    endif 
    
	' UpdateSampleCursor()

loop 


sub fastcall Play_Music()

    asm 
        call       	nextsid_play	
    end asm 

end sub 


sub fastcall Init_Music()

    asm 
        call        Music.setupmusic 
    end asm 

end sub 

sub fastcall Mute_Music()

    asm 
        call        Music.mutemusic
    end asm 

end sub 

sub fastcall music()
    asm 
    push namespace Music 

    setupmusic:

        call        setbanks
        ld          hl,$0000 
        call        $4003                       ; call setup
        jr          .finished 
    
    playframe:
        call        setbanks 
        call        $4005 
        jr          .finished

    mutemusic:
        call        setbanks
        call        $4008 
        jr          setupmusic

    .finished:
        nextreg     $52,10 
        nextreg     $50,$ff 
        ei 
        ret  
    
    setbanks:
        di      
        nextreg     $52,34
        nextreg     $50,38 
        ret 

    pop namespace
    end asm 
end sub 

sub UpdateSampleCursor()

	if sample > 0 
		y 				= sample<<1 
		last_sample_y 	= y 
	else 
		y 				= last_sample_y
	endif 
	
	x 		= sampleplay_position << 1 
	print at last_sample_y,0;ink 6;over 1;"                               ";"                               "
	

	print at y,x;paper 4;over 1;"  "
	print at y+1,x;paper 4;over 1;"  "

	

	sampleplay_position = sampleplay_position + 1 
end sub 


sub GetNextSample()

	'print at sample<<1,0;ink 2;over 1;"                               ";"                               "
	

	' oldpos = pattern_position

    pattern_index =  peek(uinteger, @pattern_order+(cast(uinteger,pattern_order_index)<<1))

    if pattern_index=$ffff 
        pattern_index = peek(uinteger, @pattern_order) : pattern_order_index=1      ' loop pos
         draw_pattern()
    endif 
	    
    ' if peek(@pattern_index)=$ff : pattern_index = pattern_order : pattern_order_index=0 : endif 
    
    sample = peek(peek(uinteger, @pattern_index)+cast(uinteger,pattern_position))

    if sample = $ff
        pattern_position=0  
        sample = peek(peek(uinteger, @pattern_index)+cast(uinteger,pattern_position))
         draw_pattern()
    endif 

    ' print at 15,15;peek(peek(uinteger, @pattern_index)+cast(uinteger,pattern_position));" ";sample;"    "
    ' print at 16,15;pattern_position;" ";pattern_order_index;"    ";"  ";pattern_position_index

	' ' print at 16,0;pattern_position;" - ";samples(sample+1);"  "

    ' print at sample<<1,0;ink 6;over 1;"                               ";"                               "
	
	pattern_position = pattern_position +1
	pattern_position_index = pattern_position_index +1

	if pattern_position_index>63 or pattern_position>63
        pattern_position_index=0 
        pattern_position=0  
        pattern_order_index = pattern_order_index + 1
         draw_pattern()
	endif 

	if sample >0
		PlayCopperSample(sample-1)
		sampleplay_position=0
		asm 
			ld 	hl, 22528
			ld	(hl),2
			ld	de,22529
			ld	bc,256+64
			ldir 
		end asm 
	' else 
	' sample = 0 
	endif 
	

end sub 

pattern:
asm 

	pat1: 
        db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3,$ff 

    pat2:
        db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3 
        db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3
        db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3
        db 1,0,3,3, 1,0,3,3, 1,0,3,3, 2,0,2,0,$ff 

    pat3:
        db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,3,3 
        db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,2,4 
        db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,3,3 
        db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,2,3,$ff 

    pat4:
        db 1,0,3,3, 2,0,3,3, 1,0,3,3, 2,0,3,3
        db 1,0,3,3, 2,0,3,3, 1,0,3,3, 2,0,3,3 
        db 1,0,3,3, 2,0,3,3, 1,0,3,3, 2,0,3,3 
        db 1,0,3,3, 2,0,3,3, 1,0,3,1, 2,0,2,3, $ff 

end asm 

pattern_order:
asm 
pattern_order:
	dw pat1         ; 9 0
	dw pat3         ; 10 1
	dw pat3         ; 11 2
	dw pat3         ; 12 3
	dw pat3         ; 13 4
	dw pat3         ; 14 5
	dw pat3         ; 15 6
	dw pat2         ; 16 7
	dw pat3         ; 17 8
	dw pat4         ; 0 9 
	dw pat3         ; 1 10 
	dw pat3         ; 2 11
	dw pat3         ; 3 12 
	dw pat4         ; 2 13 
	dw pat3         ; 4 14 
	dw pat3         ; 5 15 
	dw pat3         ; 6 16 
	dw pat3         ; 7 17 
	dw pat4         ; 8 18 

	dw $ffff        ; end of pattern marker

end asm 

sub draw_pattern()

	dim a, inbyte as ubyte 

	'pattern_start = @pattern + (pat << 4) 		' pat * 16 
    pattern_index =  peek(uinteger, @pattern_order+(cast(uinteger,pattern_order_index)<<1))

	for x = 0 to 15 
		a = peek(peek(uinteger, @pattern_index)+cast(uinteger,pattern_position)+x)
		if a < 5 
			print at 10,x;ink 2;a 
		endif 
	next 

end sub 

sub update_pattern()

	print at 10,oldpos;ink 2;over 1;" "
	print at 10,pattern_position band 15 ;ink 6;over 1;"_"
	oldpos = pattern_position band 15 

end sub 
CopperSample()
music()
' CallbackSFX()

sub draw_sample(sample as ubyte)

	dim 	samples_start,samples_length,o,sample_start,m as uinteger
	dim 	a,sample_bank, inbyte as ubyte 
	' asm 
	' 	di 
	' end asm 
	samples_start 	= @copper_sample_table+(cast(uinteger,sample)*6)			' point to start of data

	samples_length 	= peek(uinteger,samples_start+4)			' point to length 
	
	sample_start 	= peek(uinteger,samples_start+2)

	sample_bank 	= peek(samples_start+1)
	a = int (samples_length/ 255 ) 			' step size 
	o = 0 
	
	' print at 12,15;ink 6;"samples : ";samples_start
	' print "start   : ";sample_start
	' print "length  : ";samples_length
	' print "bank    : ";sample_bank
	
	for x = 0 to 254
		for m = o to o+a
			NextRegA($50,sample_bank)
			NextRegA($51,sample_bank+1)
			inbyte 		= peek(sample_start+m) >> 4
			NextReg($50,$ff)	
			NextReg($51,$ff)		
			plot x,cast (ubyte,inbyte)+176-((sample+1)<<4)
		next m  
		o=o+a
	'	print at 0,0;o 
	'	print at 1,0;sample_start+o	
	next 


end sub 

sub fastcall InitCopperAudio()

	asm
		
		ld		bc,TBBLUE_REGISTER_SELECT_P_243B
		ld		a,VIDEO_TIMING_NR_11
		out		(c),a
		inc		b
		in		a,(c)				; Display timing
		and		7					; 0..6 VGA / 7 HDMI
		ld		(.CopperSample.video_timing),a	; Store timing mode
		
		nextreg	COPPER_CONTROL_LO_NR_61,$00
		nextreg	COPPER_CONTROL_HI_NR_62,$00
		nextreg	COPPER_DATA_NR_60,$FF
		nextreg	COPPER_DATA_NR_60,$FF

		ld		a,SOUNDDRIVE_DF_MIRROR_NR_2D
		ld		(.CopperSample.sample_dac),a	; Sound on
                 
		ld 		a,31			; set sample banks 
		nextreg $50,a 
		inc 	a
		nextreg $51,a 
		ret
	end asm

end sub 

sub fastcall PlayCopperSample(sample as ubyte)
	asm
		; BREAK  
		; get sample data 
        di 
		ld 		hl,copper_sample_table								; point to start of sample table 
		ld 		e,a 
		ld 		d,6 
		mul 	d,e 
		add 	hl,de 												; hl now points to start of sample data 
		ld		(.playerstack+1),sp 
		ld 		sp,hl 											

		pop 	hl 
		ld		(.CopperSample.sample_loop),hl 						; saves bank + loop 
		
		pop 	hl  
		ld		(.CopperSample.sample_ptr),hl

		pop 	hl 
		ld		(.CopperSample.sample_len),hl
		
		ld		hl,0
		ld		(.CopperSample.sample_pos),hl

		ld		a,SOUNDDRIVE_DF_MIRROR_NR_2D
		ld		(.CopperSample.sample_dac),a	; Sound on		

	playerstack:
		ld 		sp,0
        ei 
	end asm
end sub 

sub fastcall SetCopperAudio()

	asm 
        di  
		call CopperSample.set_copper_audio
        ei 
	end asm 

end sub 

sub fastcall PlayCopperAudio()

	asm
        di  
		call CopperSample.play_copper_audio
        ei 
	end asm

end sub 

sub fastcall CopperWaitLine()
	asm
	wait_line:	
		ld		bc,TBBLUE_REGISTER_SELECT_P_243B
		ld		de,($1E*256)+$1F

		out		(c),d						; MSB
		inc		b

	.msb:
		in		d,(c)
		bit		0,d							; 256..312/311/262/261 ?
		jp		nz,.msb

		dec		b
		out		(c),e						; LSB
		inc		b

	.lsb:
		in		e,(c)
		cp		e							; 0..255 ?
		jp		nz,.lsb
		
		ret

	end asm

end sub 


sub fastcall CopperSample()
    asm 
	push namespace CopperSample 
	;    ?Updated:     em00k, adding banking                               ?
	;    ?Programmer:  kevbrady@ymail.com                                  ?
	;    ?Modified:    14th July 2018                                      ?
	;    ?Description: Copper sample player (BIS version)                  ?
	;    ?                                                                 ?


	; Hardware registers.
		
	; TBBLUE_REGISTER_SELECT			equ	$243B	; TBBlue register select

	PERIPHERAL_1_REGISTER			equ	$05	; Peripheral 1 setting
	TURBO_CONTROL_REGISTER			equ	$07	; Turbo control
	; DISPLAY_TIMING_REGISTER			equ	$11	; Video timing mode (0..7)
	RASTER_LINE_MSB_REGISTER		equ	$1E	; Current line drawn MSB
	RASTER_LINE_LSB_REGISTER		equ	31	; Current line drawn LSB
	SOUNDDRIVE_MIRROR_REGISTER		equ	$2D	; SpecDrum 8 bit DAC (mirror)
	COPPER_DATA						equ	$60	; Copper list
	COPPER_CONTROL_LO_BYTE_REGISTER	equ	$61
	COPPER_CONTROL_HI_BYTE_REGISTER	equ	$62
	CONFIG1 						equ $05
	COPHI							equ $62
	COPLO							equ $61
	SELECT							equ $243b
	SAMPLEBANK						equ 32 				; sample bank to use 


	set_copper_audio:
		
		
		ld		(.copstack+1),sp

		ld		ix,copper_loop				; Auto detect timing

		ld		bc,SELECT
		ld		a,CONFIG1
		out		(c),a
		inc		b
		in		a,(c)						; Peripheral 1 register

		ld		hl,hdmi_50_config
		ld		de,vga_50_config
		bit		2,a
		jr		z,.refresh					; Refresh 50/60hz ?
		ld		hl,hdmi_60_config
		ld		de,vga_60_config
	.refresh:
		ld		a,(video_timing)
		cp		7							; HDMI ?
		jr		z,.hdmi
		ex		de,hl						; Swap to VGA
	.hdmi:
		ld		a,(hl)						; Copper line
		inc		hl
		ld		(.return+1),a				; Store ruturn value
        
		ld		sp,hl
         
	;	------------
	;	------------
	;	------------

		ld		hl,(sample_len)				; Calc buffer loop offset
		ld		bc,(sample_pos)
		xor		a							; Clear CF
		sbc		hl,bc

		ld		b,h
		ld		c,l							; BC = loop offset (0..311)

		pop		hl							;  Samples per frame (312)
		ld		(video_lines),hl

		ld		a,h							; 16 bit negate
		cpl
		ld		h,a
		ld		a,l
		cpl
		ld		l,a
		inc		hl							; Samples per frame (-312)

		ld		a,20						; No loop (Out of range)

		add		hl,bc
		jp		c,.no_loop

	;	----D---- ----E----
	;	0000 0008 7654 3210
	;	0000 0000 0008 7654	

		ld		a,c							; Loop offset / 16
		and		%11110000
		or		b
		swapnib
	.no_loop:
		ld		b,a							; B = 0..19 (20 no loop)

		ld		a,c
		and		%00001111
		ld		c,a

	;	------------

		ld		hl,.zone+1					; Build control table
		pop		de
		ld		(hl),e						; Split
		ld		a,d							; Count

		pop		hl							; 0..15 samples routine

		ld		(copper_audio_config+1),sp 	; **PATCH**

		ld		sp,copper_audio_stack
		
		cp		b
		jr		nz,.skip					; Loop 0..15 samples ?

		ex		af,af'

		ld		e,c							; 0..7
		ld		d,9
		mul		d,e							; 0..144
		ld		a,144						; 144..0
		sub		e

		add		hl,de
		push	hl
		push	ix							; Output loop
		ld		de,copper_out16
		add		de,a
		push	de

		ex		af,af'

		jr		.next

	;	------------

	.skip:	
		push	hl							; Output normal

	;	------------

	.next:	
		ld		hl,copper_out16				; 16 samples routine
		dec		a

	.zone:	
		cp		7
		jp		nz,.no_split

		ld		de,copper_split
		push	de							; Output Split
	.no_split:
		cp		b
		jp		nz,.no_zone					; Loop 16 samples ?

		ex		af,af'

		ld		e,c							; 0..15
		ld		d,9
		mul		d,e							; 0..144
		ld		a,144						; 144..0
		sub		e

		add		de,copper_out16
		push	de
		push	ix							; Output loop
		ld		de,copper_out16
		add		de,a
		push	de

		ex		af,af'

		jr		.zone_next

	.no_zone:
		push	hl							; Output normal

	.zone_next	
		dec		a
		jp		p,.zone

		ld		(copper_audio_control+1),sp ; **PATCH**

	.return	
		ld		a,0							; Copper line to wait for

	.copstack	
		ld		sp,0
        
		ret


	; --------------------------------------------------------------------------
	; --------------------------------------------------------------------------
	; --------------------------------------------------------------------------


	; **MUST CALL EACH FRAME AFTER WAITING FOR LINE A FROM SET_COPPER_AUDIO**


	; Build copper list to output one frame of sample data to DAC.

	play_copper_audio: 
		
         
		; ld 			a,(sample_bank)			; set sample banks 
		; nextreg 	$50,a 
		; inc 		a
		; nextreg 	$51,a 
		
		;call 		play_copper_audio2		; set copper 
		
		; nextreg 	$50,$ff					; return roms 
		; nextreg 	$51,$ff 
		 
		;ret 

	play_copper_audio2:
		
		ld			(play_copper_stack+1),sp

	copper_audio_config:
		
		ld		sp,0			; **PATCH**

		pop		hl							; Index + VBLANK
		pop		de							; Line 180 + command WAIT

		ld		a,l
		nextreg	COPLO,a
		ld		a,h
		nextreg	COPHI,a

		ld		hl,(sample_ptr)				; Calc playback position
		ld		bc,(sample_pos)	
		add		hl,bc

		ld		bc,SELECT					; Port
		ld		a,COPPER_DATA
		out		(c),a
		inc		b

		ld		a,(sample_dac)				; Register to set (DAC)

	copper_audio_control:
		ld		sp,0						; **PATCH**
		
		ret									; GO!!!

	;	------------

	copper_out16:	
		out		(c),d		;   0 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out15:	
		out		(c),d		;   9 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out14:	
		out		(c),d		;  18 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out13:	
		out		(c),d		;  27 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out12:	
		out		(c),d		;  36 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out11:	
		out		(c),d		;  45 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc	de
	copper_out10:	
		out		(c),d		;  54 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out9:
		out		(c),d		;  63 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out8:	
		out		(c),d		;  72 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out7:	
		out		(c),d		;  81 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out6:	
		out		(c),d		;  90 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out5:	
		out		(c),d		;  99 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out4:	
		out		(c),d		; 108 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out3:	
		out		(c),d		; 117 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc	de
	copper_out2:	
		out		(c),d		; 126 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out1:	
		out		(c),d		; 135 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out0:	

		ret			; 144 BYTES

	;	------------

	copper_split:
		out		(c),d						; Terminate
		out		(c),e
		ld		de,32768+0					; Line 0 + command WAIT
		nextreg	COPPER_CONTROL_LO_BYTE_REGISTER,$00 ; Index
		nextreg	COPPER_CONTROL_HI_BYTE_REGISTER,$C0 ; Vblank
		ret			; GO!!!


	copper_loop:	
		ld		hl,sample_dac
		ld		a,(sample_loop)
		and		a
		jr		z,.forever
		dec		a
		jr		nz,.loop	
		ld		(hl),0						; Copper NOP (mute sound)

	.loop:		
		ld		(sample_loop),a

	.forever:
		ld		a,(hl)						; Read DAC mute state
		ld		hl,(sample_ptr)
		ret									; GO!!!

	;	------------

	copper_done:
		ld		de,(sample_ptr)
		xor		a
		sbc		hl,de
		ld		(sample_pos),hl				; Update playback position

	play_copper_stack:
		ld		sp,0
      
		ret


	; --------------------------------------------------------------------------


	vga_50_config:
		db		187						; Copper line 187 (50hz)
		dw		311						; Samples per frame
		db		6						; Split
		db		7+12					; Count
		dw		copper_out7				; Routine (311-304)
		db		$1C						; Index + VBLANK
		db		$C3
		dw		32768+199				; Line 199 + command WAIT

	vga_60_config:	
		db		191						; Copper line 191 (60hz)
		dw		264						; Samples per frame
		db		3						; Split
		db		4+12					; Count
		dw		copper_out8				; Routine (261-256)
		db		$20						; Index + VBLANK
		db		$C3
		dw		32768+200				; Line 197 + command WAIT

	hdmi_50_config:	
		db		186						; Copper line 186 (50hz)
		dw		312						; Samples per frame
		db		6						; Split
		db		7+12					; Count
		dw		copper_out8				; Routine (312-304)
		db		$20						; Index + VBLANK
		db		$C3
		dw		32768+200				; Line 200 + command WAIT

	hdmi_60_config:
		db		189						; Copper line 189 (60hz)
		dw		262						; Samples per frame
		db		3						; Split
		db		4+12					; Count
		dw		copper_out6				; Routine (262-256)
		db		$18						; Index + VBLANK
		db		$C3
		dw		32768+198				; Line 198 + command WAIT


	; --------------------------------------------------------------------------


	; Variables.


	sample_ptr:		dw	0			; 32768
	sample_pos:		dw	0
	sample_len:		dw	0			; 10181
	sample_dac:		db	0			; DAC register

	sample_loop:    db	0		; 0..255
	sample_bank:    db 	0 		; 0..255 

	video_lines:	dw	0		; 312/311/262/261
	video_timing:	db	0		; 0..7

		dw	0,0,0,0,0,0,0,0		;
		dw	0,0,0,0,0,0,0,0		; Define 23 WORDS
		dw	0,0,0,0,0,0,0		;

	copper_audio_stack:
		dw	copper_done
	pop namespace

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
		ld      bc,0
		ldir 
		nextreg MMU7_E000_NR_57,1
	end asm 	

end sub


copper_sample_table:
asm 
	copper_sample_table: 
	; bank+loop , sample start, sample len
	; eg bank 32,loop 0 = $2000 
	; sample table sample * 6 


    dw $1f01,0,940 ; 1kick.raw
    dw $1f01,940,3092 ; 2snare.raw
    dw $1f01,4032,1376 ; 3hhat.raw
    dw $1f01,5408,3092 ; 4snarehalf.raw
    dw $1f01,0,0


end asm 

wavea: 
asm 
wavea: 
    test_waveforma:
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
end asm 

waveb: 
asm 
waveb: 
    test_waveformb:
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
end asm 

wavec: 
asm 
    test_waveformc:
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
        db  128,000,128,000,128,000,128,000
end asm 


asm 
    noduty_waveform:
        db  128,128,128,128,128,128,128,128
        db  128,128,128,128,128,128,128,128
        db  128,128,128,128,128,128,128,128
        db  128,128,128,128,128,128,128,128
end asm 

asm 
    muted_waveform:
        db  0,0,0,0,0,0,0,0
        db  0,0,0,0,0,0,0,0
        db  0,0,0,0,0,0,0,0
        db  0,0,0,0,0,0,0,0
end asm 
