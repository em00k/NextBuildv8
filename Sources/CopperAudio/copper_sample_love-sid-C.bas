'!org=32768
'!copy=h:\ctc_test.nex 
'#!nosysvars
'#!asm
' NextBuild Copper Audio v2 

' original CopperAudio by Lampros Potamianos used with permission
' optimized & adapted for nextbuild by em00k


#define NEX 
#define IM2 


#include <nextlib.bas>
#include <nextlib_ints.bas>
#include <keys.bas>
asm 
	di 
	
end asm 
LoadSDBank("/lies/output.dat",0,0,0,30)					'; Load sample into bank 32-33
LoadSDBank("nextsid.bin",0,0,0,33)
' LoadSDBank("vt24000.bin",0,0,0,34)                  '; load the vt2 replayer 
' LoadSDBank("game.afb",0,0,0,36) 				' load an ayfx afb bank into bank 36
LoadSDBank("chiptune3.pt3",0,0,0,34) 				' load music.pt3 into bank 34
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

InitSFX(36)							' init the SFX engine, sfx are in bank 36
InitMusic(34,38,0000)				' init the music engine 33 has the player, 34 the pt3, 0000 the offset in bank 34
SetUpIM()							' init the IM2 code 
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

' WaitKey()

nasty: 

asm 

        #include "symb.asm"


	    nextreg 	                $57,33					    ; put nextsid in place;;
;	    irq_vector	                equ	65022			        ;     2 BYTES Interrupt vector
;	    sidstack	                equ	24576				    ;   252 BYTES System stack
;	    vector_table	            equ	64512		        ;   257 BYTES Interrupt vector table	
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
	    nextreg     VIDEO_INTERUPT_VALUE_NR_23,192

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
	    ld	    a,15		; 16 BYTE waveform
	    call	nextsid_set_waveform_B

	    ld	    hl,6		; Slight detune
	    call	nextsid_set_detune_B
        ld      a, 3
        ld     (nextsid_shift_B),a 

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

do 
   
	
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

    asm 
        call nextsid_vsync
    end asm
    if timer = 0 
        ' update_pattern()
        ' GetNextSample()                 ' grab next pattern row 
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



' pattern:
' asm 

' 	pat1: 
'         db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3,$ff 

'     pat2:
'         db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3 
'         db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3
'         db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3
'         db 1,0,3,3, 1,0,3,3, 1,0,3,3, 2,0,2,0,$ff 

'     pat3:
'         db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,3,3 
'         db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,2,4 
'         db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,3,3 
'         db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,2,3,$ff 

'     pat4:
'         db 1,0,3,3, 2,0,3,3, 1,0,3,3, 2,0,3,3
'         db 1,0,3,3, 2,0,3,3, 1,0,3,3, 2,0,3,3 
'         db 1,0,3,3, 2,0,3,3, 1,0,3,3, 2,0,3,3 
'         db 1,0,3,3, 2,0,3,3, 1,0,3,1, 2,0,2,3, $ff 

' end asm 

' pattern_order:
' asm 
' pattern_order:
' 	dw pat1         ; 9 0
' 	dw pat3         ; 10 1
' 	dw pat3         ; 11 2
' 	dw pat3         ; 12 3
' 	dw pat3         ; 13 4
' 	dw pat3         ; 14 5
' 	dw pat3         ; 15 6
' 	dw pat2         ; 16 7
' 	dw pat3         ; 17 8
' 	dw pat4         ; 0 9 
' 	dw pat3         ; 1 10 
' 	dw pat3         ; 2 11
' 	dw pat3         ; 3 12 
' 	dw pat4         ; 2 13 
' 	dw pat3         ; 4 14 
' 	dw pat3         ; 5 15 
' 	dw pat3         ; 6 16 
' 	dw pat3         ; 7 17 
' 	dw pat4         ; 8 18 

' 	dw $ffff        ; end of pattern marker

' end asm 


sub update_pattern()

	print at 10,oldpos;ink 2;over 1;" "
	print at 10,pattern_position band 15 ;ink 6;over 1;"_"
	oldpos = pattern_position band 15 

end sub 

' CallbackSFX()


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
