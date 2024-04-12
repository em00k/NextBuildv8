'!copy=h:\ctc_test.nex

#define NEX
#define IM2
#include <nextlib.bas>

asm 
    nextreg TURBO_CONTROL_NR_07,3
    nextreg GLOBAL_TRANSPARENCY_NR_14,0

end asm 

LoadSDBank("/lies/output.dat",0,0,0,32)	
LoadSDBank("nextsid.bin",0,0,0,33)

dim add as uinteger


asm 
; /*  Equates for NextSID - probably dont need them but not removing just yet


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

	
	INTCTL					equ	0C0h	; Interrupt control
	NMILSB					equ	0C2h	; NMI Return Address LSB
	NMIMSB					equ	0C3h	; NMI Return Address MSB
	INTEN0					equ	0C4h	; INT EN 0
	INTEN1					equ	0C5h	; INT EN 1
	INTEN2					equ	0C6h	; INT EN 2
	INTST0					equ	0C8h	; INT status 0
	INTST1					equ	0C9h	; INT status 1
	INTST2					equ	0CAh	; INT status 2
	INTDM0					equ	0CCh	; INT DMA EN 0
	INTDM1					equ	0CDh	; INT DMA EN 1
	INTDM2					equ	0CEh	; INT DMA EN 2

	CTC0					equ	183Bh	; CTC channel 0 port
	CTC1					equ	193Bh	; CTC channel 1 port
	CTC2					equ	1A3Bh	; CTC channel 2 port
	CTC3					equ	1B3Bh	; CTC channel 3 port
	CTC4					equ	1C3Bh	; CTC channel 4 port
	CTC5					equ	1D3Bh	; CTC channel 5 port
	CTC6					equ	1E3Bh	; CTC channel 6 port
	CTC7					equ	1F3Bh	; CTC channel 7 port

; */
	
	; nextreg 	    $57,33				            ; put nextsid in place
	irq_vector	    equ	65022			            ; 2 BYTES Interrupt vector
	stack		    equ	65021			            ; 252 BYTES System stack
	vector_table	equ	64512		                ; 257 BYTES Interrupt vector table	
	
	startup:	

	di					                            ; Set stack and interrupts
	ld	    sp,stack					            ; System STACK

	nextreg	TURBO_CONTROL_NR_07,%00000011	        ; 28Mhz / 27Mhz

	ld	    hl,vector_table	                        ; 252 (FCh)
	ld	    a,h
	ld	    i,a
	im	    2

	inc	    a							            ; 253 (FDh)

	ld	    b,l							            ; Build 257 BYTE INT table
	.irq:	
	ld	    (hl),a
	inc	    hl
	djnz	.irq					                ; B = 0
	ld	    (hl),a

	ld	    a,$FB						            ; EI
	ld	    hl,$4DED					            ; RETI
	ld	    (irq_vector-1),a
	ld	    (irq_vector),hl

	ld	    bc,0xFFFD					            ; Turbosound PSG #1
	ld	    a,%11111111
	out	    (c),a


	nextreg VIDEO_INTERUPT_CONTROL_NR_22,%00000100
	nextreg VIDEO_INTERUPT_VALUE_NR_23,200

	ld	    sp,stack					            ; System STACK

	call	patch_interrupt

	ei

end asm 

do 
    
    ' print at 2,0;"Sample  :                 " 
    border 2
     GetNextSample()
    border 0 
    add = peek(uinteger,@pattern_position)
    print at 0,0;"Pattern : ";peek(add);"   "
    add = peek(uinteger,@pattern_position_index)
    print at 1,0;"Position: ";peek(add);"   " 
	add = peek(ubyte,peek(uinteger,@sample_to_play))
    print at 2,0;"Sample  : ";str(add)
	WaitRetrace(1)
loop 

GetNextSample()

sub fastcall GetNextSample()

    asm 
        ; playes tracker like pattern data
        ; point to playlist of pattern addresses 
		; doesnt touch the stack 


    get_next_sample:
		
        ld      hl,pattern_timing+1

    pattern_timing:
        ld      a,0 
        inc     a 
        ld      (hl),a 
	pattern_speed:		
        cp      6				; pattern speed 
        ret     nz 
        xor     a 
        ld      (hl),a 

        ld      de,increase_pattern_pos+1   ; for speed 
        ld      bc,get_pattern_order+1

    get_pattern_order:
        ld      a, 0 
        ld      hl, pattern_order           ; point to pattern_order data 
        add     a,a                         ; *2 for size
        add     hl,a                        ; add to hl 

        ; hl now points pattern address of pattern 

        ld      a,(hl)                      ; swap (hl) to hl 
        inc     hl 
        ld      h,(hl)
        ld      l,a                         ; hl now start of pattern data 
 
        ld      a,h                         ; end of playlist? hl = $ffff 
        or      l 
        cp      $ff 
        jr      nz, dont_reset_pattern_order_index 
        
        xor     a                           ; reset the index 
        ld      (de),a                      ; reset increase_pattern_pos
        ld      (bc),a                      ; and pattern order 
        jr      get_pattern_order           ; read again 

    dont_reset_pattern_order_index:
        ld      a,(de)                      ; get increase_pattern_pos
        add     hl,a                        ; add to pattern offset 
        ld      a,(hl)                      ; get the sample 
        cp      $ff                         ; end of pattern? 
        jr      nz,process_sample 
         
        xor     a 
        ld      (de),a                      ; reset pattern position
        ld      a,(bc)
        inc     a
        ld      (bc),a 
        jr      get_pattern_order
    
    process_sample:
		ld 		h,a 						; save sample in h 
        ; or      a                           ; if a / sample not 0  
        ; jr	    nz,play_sample              ; call play_sample

    increase_pattern_pos:
        ld      a,0                         ; smc 
        inc     a                           
        ;res     6,a                         ; reset bit 6 64 
        ld      (de),a                      ; increase pattern position with smc 
		
        ; ret 
		 
    play_sample:
		ld		a,h
        ld		(sample),a											; save the sample to play 
		or		a 
		ret 	z
        ld		b,d 												; save de 
		ld 		c,e 
        dec     a 													; dec sample index 
        ld 		hl,copper_sample_table								; point to start of sample table 
		ld 		e,a 												; table is 6 bytes per item 
		ld 		d,6 												; so 6*index 
		mul 	d,e 												
		add 	hl,de                                               ; add to sample start to get new sample start add 

        ; next two bytes are start bank then loop 
        ld      a,(hl)												; hl is LSBMSB, so get the loop setting 
        ld      (sample_loop),a 									; save it 
        inc     hl 													; move hl pointer 
        ld      a,(hl)												; get bank 
        ld      (sample_bank),a 									; save it 
        inc     hl              ; now sample start 					; move to sample start address 
        
        ld      (sampread+2),hl 									; save this 
    sampread:
        ld      de,(00)           									; patched from above       
        ex      de,hl 
        ld      (sample_start),hl 
		ld 		(sample_offset),hl
        inc     de 
        inc     de
        ex      de,hl 
        ld      (sampread2+2),hl 
    sampread2:
        ld      de,(00)
        ex      de,hl 
        ld      (sample_length),hl 
		ld		d, b
		ld 		e, c

		
		; xor 	a 
		; ld 		(sample),a 
		ret 
        ; t 

    sample:
        db 			0 

    sample_bank:
        db      0 
        
    sample_loop:
        db      0

    sample_start:
        dw      0000

    sample_length:
        dw      0

    sample_offset:
        dw      0

    end asm 


end sub 

pattern_position:
asm 
        dw get_pattern_order+1
end asm 

pattern_position_index:
asm 
        dw increase_pattern_pos+1 
end asm 

sample_to_play:
asm 
        dw sample
end asm 

pattern:
asm 
pat1: 
        db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3
        db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3,$ff 

pat2:
        db 1,0,0,0, 1,0,0,0, 1,0,0,0, 2,0,0,0,$ff 

pat3:
        db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,2,3,$ff 

pat4:
        db 1,0,3,3, 2,0,3,3, 1,0,3,1, 2,2,2,3
        db 1,0,3,3, 2,0,3,3, 1,0,3,1, 2,2,4,2
        db 1,0,3,3, 2,0,3,3, 1,0,3,1, 2,2,2,3
        db 1,0,3,3, 2,0,3,3, 1,0,3,1, 2,3,4,2, $ff

pat5:   
		db 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,$ff 

pat6:	
		db 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,2,2,$ff 
	
		align 256
end asm 

pattern_order:
asm 

pattern_order:
	; patter 0 
	
	dw pat5         ; 0 0
	dw pat5         ; 0 0
	dw pat5         ; 0 0
	dw pat5         ; 0 0

	dw pat5         ; 0 0
	dw pat5         ; 0 0
	dw pat5         ; 0 0
	dw pat6         ; 0 0  break down to beat 


	dw pat4         ; 2  02  
	dw pat4         ; 3  03
	dw pat4         ; 4  04 
	dw pat4         ; 5  05 
	dw pat4         ; 6  01 
	dw pat4         ; 7  08 
	dw pat4         ; 8  0A  
	dw pat5         ; 9  09 
	dw pat5 
	dw pat5 
	dw pat5 

	dw pat5 		; A  0B 
	dw pat5 
	dw pat5 
	dw pat6

	dw pat4         ; B  01 
	dw pat4         ; C  03 
	dw pat4         ; D  04 
	dw pat4         ; E  0A 
	dw pat5         ; F  02  
	dw pat5 
	dw pat5 
	dw pat6 

	dw pat4         ; 10 02 
	dw pat4         ; 11 01 
	dw pat4         ; 12 03 
	dw pat4         ; 13 04 
	dw pat4         ; 14 05
	dw pat5         ; 15 09 
	dw pat5 
	dw pat5 
	dw pat5 

	dw pat5         ; 16 0B 
	dw pat5         ; 16 0B 
	dw pat5         ; 16 0B 
	dw pat5         ; 16 0B 

	dw $ffff        ; end of pattern marker

end asm 

sub ResetSample()
    asm
         
        ld      hl,0     
        ld      (sample_offset),hl 
    end asm
end sub 

asm 
	patch_interrupt:

		di 
		xor     a 
		ld		bc,192
		ld      de,raster_line
		ld      (raster_frame),a
		
		ld 		a,i 
		ld		h,a
		ld		l,0
		ld		(hl),e					                    ; Set LINE interrupt
		inc		l
		ld		(hl),d
		ld		l,6
		ld		de,ctc0					                    ; Set CTC0 interrupt
		ld		(hl),e
		inc		l
		ld		(hl),d
		inc		l
		ld		de,ctc1					                    ; Set CTC1 interrupt
		ld		(hl),e
		inc		l
		ld		(hl),d

		ld		a,b
		and		%00000001
		or		%00000110				                    ; ULA off / LINE interrupt ON

		nextreg	VIDEO_INTERUPT_CONTROL_NR_22,a
		ld		a,c
		nextreg	VIDEO_INTERUPT_VALUE_NR_23,a				; IM2 on line BC	

		nextreg INTCTL,%00001001                            ; Vector 0x00, stackless, IM2

		nextreg INTEN0,%00000010                            ; Interrupt enable LINE
		nextreg INTEN1,%00000001                            ; CTC channel 0 zc/to
		nextreg INTEN2,%00000000                            ; Interrupters
		nextreg INTST0,%11111111                            ; 
		nextreg INTST1,%11111111                            ; Set status bits to clear
		nextreg INTST2,%11111111                            ; 
		nextreg INTDM0,%00000000                            ; 
		nextreg INTDM1,%00000000                            ; No DMA
		nextreg INTDM2,%00000000                            ; 

		call	set_ctc


end asm 

asm 
	; interrupt routines 

	raster_line:	
		push	af 
	raster_frame equ $+1	
		ld      a,0 
		inc	    a
		ld	    (raster_frame),a
		pop	    af
		ei
		reti

	ctc0:
		
		; ex	af,af'		; **VT1-MFX REGISTERS**
		push 	af 
        push    bc 
        push    hl 
        push    de 

		ld		bc,TBBLUE_REGISTER_SELECT_P_243B
		in		a,(c)
		ld 		(ctc0_port+1),a 

		; ld 		a,(sample_loop)
		; or		a 
		; jp 		nz,done_playing

        nextreg $50,32              ; page in sample 
        nextreg $51,33              ; page in sample 

        ld      hl,(sample_start)	
        ld      de,(sample_length)    ; point to sample position 
		add 	hl,de 				; add both to get memory location of end of sample 
		
		; ld		(forward+1),hl 	 

		ld 		de,(sample_offset)
        xor     a 
        sbc     hl,de 				; sample end - offset 
		
        jr      nc,playing			; is sample_offset < sample_end? Then jr to playing  
		jr		c,skiplaying
		ld 		hl,(sample_start)	; reset offset 
		ld		(sample_offset), hl 
		dec		hl 	
		ex		de,hl 
		
	playing:
			
	;'	ld 		a,0
	;'	inc 	a 
	;'	ld 		(playing+1),a 
	;'	and 	1 
	;'	jr		z,playleft 

		ld      a,(de)              ; grab sample 
		inc     de 					; move offset 	

    ;    nextreg DAC_C_MIRROR_NR_2E, a
		
		nextreg DAC_AD_MIRROR_NR_2D,a 

    ;    jr 		skipleft 
	; playleft:
    ;    ld      a,(de)              ; grab sample 
	; 	inc     de 					; move offset 	
    ;    nextreg DAC_B_MIRROR_NR_2C,a

	skipleft:
        ; out     (c),a 
        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,67
        
        ; ;nc     de 
         ld      hl,sample_offset 	; 10 
         ld      (hl),e   			; 7 
         inc     hl 		 			; 4 
         ld      (hl),d 	 			; 7 		; 28 t
		; or 
		; ld		(sample_offset),de 	; 20 
    skiplaying:    
        nextreg $50,$ff              ; page in sample 
        nextreg $51,$ff              ; page in sample 

        nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0

    done_playing:

	ctc0_port:
		ld		a,0 
		ld		bc,TBBLUE_REGISTER_SELECT_P_243B
		out		(c),a 

        pop     de 
        pop     hl 
        pop     bc 
		pop 	af 
		; ex	af,af'		; **VT1-MFX REGISTERS**
		ei 
		reti

	ctc1: 
        ; nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,200
		ei 
		reti 

	set_ctc:

		di 
		ld		d,112  ; vga 50 scanline timing 
		ld		a,0    ; manually set timing 
		ld		hl,.timing_tab
		add		a,a
		add		hl,a

		; CTC Channel 0 

		ld		bc,CTC0					; Channel 0 port
										; IMPETCRV	; Bits 7-0
		ld		a,%10000101				; / 16
		out		(c),a					; Control word
		out		(c),d					; Time constant

		; CTC Channel 1

		ld		bc,CTC1					; Channel 1 port
		;                                    IMPETCRV	; Bits 7-0
		ld		a,%10100101				; / 256
		out		(c),a					; Control word
		ld		a,(hl)
		outinb							; Time constant		

		ei 
		ret 

	.timing_tab:
		db		250, %10001100 			; 0 28000000 50Hz =  8.75
		db		186, %11000000 			; 1 28571429 50Hz = 12.0  ?
		db		192, %11000000 			; 2 29464286 50Hz = 12.0  ?
		db		250, %10010110 			; 3 30000000 50Hz =  9.375
		db		250, %10011011 			; 4 31000000 50Hz =  9.6875
		db		250, %10100000 			; 5 32000000 50Hz = 10.0
		db		250, %10100101 			; 6 33000000 50Hz = 10.03125
		db		250, %10000111 			; 7 27000000 50Hz =  8.4375
		

end asm 

copper_sample_table:
asm 
	copper_sample_table: 
	; bank+loop , sample start, sample len
	; eg bank 32,loop 0 = $2000 
	; sample table sample * 6 

    dw $2000,0,940 ; 1kick.raw
    dw $2000,940,3092 ; 2snare.raw
    dw $2000,4032,1376 ; 3hhat.raw
    dw $2000,5408,3092 ; 4snarehalf.raw
    dw $2000,0,0

end asm 
