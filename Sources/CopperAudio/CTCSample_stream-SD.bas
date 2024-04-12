
'!org=32768
'!copy=h:\ctc_test.nex

' Released under GPLv3 David Saphier / em00k 
' Part of Nextbuild 
' Setup CTC code from NextSID by 9bitcolor 
' see 1750 for the song table 



#define NEX
#include <nextlib.bas>
#include <keys.bas>

asm 
	nextreg TURBO_CONTROL_NR_07,3
	nextreg GLOBAL_TRANSPARENCY_NR_14,0
	nextreg NEXT_RESET_NR_02,128 
	nextreg PALETTE_CONTROL_NR_43,%0_000_000_0
	di 
	ld	    sp,stack
end asm 

    CONST   relative        as ubyte = %01000000
    dim     y               as ubyte 
    dim     frame           as ubyte 
    dim     lastframe       as ubyte 
	dim		key, tune		as ubyte 

    paper 0 : ink 7 : cls 

	ChangeTune(1)

    OpenFile()              ' open the pcm for streaming 
    ReadChunk()             ' fill buffers 
    SetUPCTC()              ' Set up CTCs
    InitSprites(2,@Sprites)

    UpdateSprite(32,64,0,0,0,0) 

	' set up a test loop for smoothness 
    spri = 1 
    for x = 0 to 10*16 step 16
        UpdateSprite(16,0,spri,0,0,relative) 
        spri = spri + 1 
    next x 
    NextReg(SPRITE_CONTROL_NR_15,1)



do 

	print at 0,0;tune

	a 	= GetKeyScanCode()

	if key = 1 and a = 0 
		StartTune(tune)				' change tune from tune table 
	endif 

	if a=KEY1 and key = 0 
		tune 	= 0
		key 	= 1 
	elseif a = KEY2 and key = 0 
		tune 	= 1 
		key 	= 1 
	elseif a = KEY3 and key = 0 
		tune 	= 2
		key 	= 1 
	elseif a = KEY4 and key = 0 
		tune 	= 3
		key 	= 1 
	elseif a = 0 and key = 1 
		key 	= 0 
	endif 


	CTCWaitVlbank()                 ' in place of regular Vblank 

	border 2
    
	dostuff()
	
	border 0 
	

loop 

Sub StartTune(tune as ubyte)
	ChangeTune(tune)
	OpenFile()
end sub 

sub fastcall ChangeTune(tune as ubyte)

	asm 
		; BREAK 
		ld 		d,a 						; get tune id 
		ld		hl,tunedatabase
		ld		e,5 						; each entry is 5 bytes 
		mul		d,e 						
		add		hl,de 						; poit hl to entry 
		ld		a,(hl) 						; get sample timing 
		ld 		(sampletiming),a 			; store 
		inc		hl 							; 0 mono - 1 stereo 
		ld 		a,(hl)
		ld 		(sample_stereo),a 
		inc 	hl 							
		ld 		e,(hl)
		inc		hl
		ld 		d,(hl)
		ex		de,hl 
		ld		(tunemamebuffer),hl			; store address of tune 

		call 	set_ctc
		ret 

	tunedatabase:		
		db 		56,0						; sample timing, mono = 1  
		dw 		tune1						; filename 
		db 		0 

		db 		56,0						; sample timing, 1750000 / 31250Hz = 56 
		dw 		tune2						; filename 
		db 		0 

		db 		56,0						; sample timing,  
		dw 		tune3						; filename 
		db 		0

		db 		56,0						; sample timing,  
		dw 		tune4						; filename 
		db 		0

	tunefilename:
		tune1: 	db 		"dream.pcm",0				; 15625 8bit mono 
		tune2: 	db 		"name.pcm",0		        ; 32kz	8	stereo 
		tune3: 	db 		"Alone.pcm",0					; 32khz 8   stereo 
		tune4: 	db 		"seeing32khz.pcm",0                    ; 32khz 8   stereo 

	end asm 

end sub 

sub dostuff()
    ' simple more sprite down screeen 
    y = y + 1 
    UpdateSprite(32,y,0,0,0,0) 

end sub 

sub ResetSample()
	' reset sample position 
	asm
		ld      hl,CTCBASE*256   
		ld      (sample_offset),hl 
	end asm
end sub 

sub OpenFile()
	' opens file for streaming 
	asm
		di 		
		call    open_file 
		ei 
	end asm
end sub 

sub ReadChunk()
	' fills both buffers 
	asm
		call    read_data_a
		call    read_data_b
	end asm

end sub 

sub CTCWaitVlbank()
	asm 
	Vblank:
		ld		hl,raster_frame
		ld		a,(hl)
	.vsync:	
		cp		(hl)	; Wait for LINE to change variable
		jr		z,.vsync
	end asm 
end sub 

Sub SetUPCTC()
	' sets up the CTC, interrupt vectors 
	asm 
	; /*  Equates 
	; This was originally written by KevB for NextSID, minor changes  
	
	INTCTL				equ	0C0h	; Interrupt control
	NMILSB				equ	0C2h	; NMI Return Address LSB
	NMIMSB				equ	0C3h	; NMI Return Address MSB
	INTEN0				equ	0C4h	; INT EN 0
	INTEN1				equ	0C5h	; INT EN 1
	INTEN2				equ	0C6h	; INT EN 2
	INTST0				equ	0C8h	; INT status 0
	INTST1				equ	0C9h	; INT status 1
	INTST2				equ	0CAh	; INT status 2
	INTDM0				equ	0CCh	; INT DMA EN 0
	INTDM1				equ	0CDh	; INT DMA EN 1
	INTDM2				equ	0CEh	; INT DMA EN 2
	CTC0				equ	183Bh	; CTC channel 0 port
	CTC1				equ	193Bh	; CTC channel 1 port
	CTC2				equ	1A3Bh	; CTC channel 2 port
	CTC3				equ	1B3Bh	; CTC channel 3 port
	CTC4				equ	1C3Bh	; CTC channel 4 port
	CTC5				equ	1D3Bh	; CTC channel 5 port
	CTC6				equ	1E3Bh	; CTC channel 6 port
	CTC7				equ	1F3Bh	; CTC channel 7 port
	CTCBASE             equ $c0		; MSB Base address of buffer 
	CTCSIZE             equ $02 	; MSB buffer length 
	CTCEND              equ CTCBASE+(CTCSIZE*2)	

	; */
		
		irq_vector	    equ	65022			            ; 2 BYTES Interrupt vector
		stack		    equ	65021			            ; 252 BYTES System stack
		vector_table	equ	64512		                ; 257 BYTES Interrupt vector table	
		
		startup:	

		di					                            ; Set stack and interrupts
		; ld	    sp,stack					            ; System STACK

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

		nextreg VIDEO_INTERUPT_CONTROL_NR_22,%00000100
		nextreg VIDEO_INTERUPT_VALUE_NR_23,255

		; ld	    sp,stack					            ; System STACK

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

		ei


	; ' Set up the CTCs 

	set_ctc:

		di 
		; // ld		d,114 										; 
		ld		a,(sampletiming)
		ld 		d,a 
		ld		a,0    										; manually set timing 
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
		ld		a,%10101101				; / 256
		out		(c),a					; Control word
        ld      a,255
        out     (c),a 
		;ld		a,(hl)
		;outinb							; Time constant		

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
	
	; end if KevBs routeins 
	; 

	sampletiming:
		db 		56						; 1750000 / 15625 = 112 

	tunemamebuffer:
		dw 		0000 				

	end asm 

end sub 

frame_raster:           '; + 55
asm 
	; interrupt routines 

	; Raster interrupt, not used here but reserved. 

	raster_line:	

		push	af  ;11
        push    hl  ;11
        push    de  ;11
        push    bc  ;11
        push    ix  ;15 
        
    ;    call ._dostuff		attempt to call zxb routine still needs work 

		ld      a,(raster_frame)
		inc	    a
		ld	    (raster_frame),a

		pop     ix 
        pop     bc
        pop     de
        pop     hl
        pop     af
		ei 
		reti

	;' CTC 0 handles streaming the data to the left+right DACs

	ctc0:

		
		push 	af 
		push    hl 
		push    de 

		ld      de,(sample_offset)
		ld      a,e                             ; put e into a 
		or      a                               ; was it zero 
		jr      nz,skipload                     ; no skip loading 

		ld      a,d                             ; get d 
		cp      CTCBASE+CTCSIZE                 ; compare to $50
		jr      nz, skiploada                   ; <>50 then skip 
		ld      a,1                             ; else set load flag to 1 
		ld      (chunkloadflag),a 
		
skiploada:        

		ld      a,d                             ; get d 
		cp      CTCBASE                         ; compare to $40
		jr      nz, skipload                    ; <> $40  skip 
		ld      a,2                             ; else set load flag to 2 
		ld      (chunkloadflag),a 

skipload:

		ld      de,(sample_offset)
		ld		a,(sample_stereo)
		ld 		h,a 
		
		bit 	0,h 
		jr		nz,mono_player

		ld      a,(de)                          ; grab sample 
		
		nextreg DAC_C_MIRROR_NR_2E, a           ; send to left channel 
		inc     de      

		ld      a,(de)                          ; grab sample 
		
		nextreg DAC_B_MIRROR_NR_2C, a           ; send to right channel 
		inc     de  

		jr		end_player

	mono_player:
		ld      a,(de)                          ; grab sample 
		and		%11111110
		nextreg DAC_AD_MIRROR_NR_2D, a           ; send to left channel 
		inc 	de 

	end_player:

		;ld      h,a 							; for displaying time taken on screen 
		;add     a,80
		;and     $fe 
		;nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,a 
		
		;inc     de      

		ld      a,d                             ; get d into a 
		cp      CTCEND                          ; 
		jr      nz,final                        ; if not $60 then jump to final 
		ld      de,CTCBASE*256                  ; else reset de to CTCBASE
final: 
		ld		(sample_offset),de 

		; nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0  ; for displaying time taken on screen 
 
		pop     de 
		pop     hl 
		pop 	af 
		ei 
		reti

	; ' CTC 1 for checking if we need to load another block 

	ctc1: 
		
		ei 
		push    af 
	
		ld      a,(raster_frame)
		; nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,a  ; for displaying time taken on screen 

		ld      a,(chunkloadflag)               ; get the load flag 
		or      a                               ; was it zero 
		jr      z,skipload2                     ; yes skip 

		push    de 
		push    hl  
		push    ix   
		push    bc 

		ld      a,(chunkloadflag)               ; get the load flag  
		cp      1                               ; is flag set to 1 
		call    z, read_data_a                  ; then load data b ($5000)

		ld      a,(chunkloadflag) 
		cp      2 
		call    z, read_data_b                  ; load data a 
		
		pop     bc 
		pop     ix 
		pop     hl  
		pop     de 

	skipload2:
 
		; nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0 ; for displaying time taken on screen 
		pop     af 
		ei 
		reti 

	read_data_a:

		ld      ix,CTCBASE*256
		ld      bc,CTCSIZE*256
		ld      a,(filehandle2)
		ESXDOS
		db      F_READ
		xor     a 
		ld      (chunkloadflag), a 
		ret 

	read_data_b:

		ld      ix,(CTCBASE+CTCSIZE)*256
		ld      bc,CTCSIZE*256
		ld      a,(filehandle2)
		ESXDOS
		db      F_READ
		xor     a 
		ld      (chunkloadflag), a 
		ret 

	; open a file and set file handle 
	; 
	open_file:

		push 	ix 
		; ld      ix,stream_file_name
		ld      a,(filehandle2)
		ESXDOS
		db 		F_CLOSE
		ld      ix,(tunemamebuffer)
		ld      a,'*'
		ld      b,FA_READ
		ESXDOS 
		db      F_OPEN
		ld      (filehandle2),a 
		pop 	ix 
		ret     nc 
		ld      a,2

	openerror:
		out     ($fe),a
		inc     a 
		and     7
		jp 		openerror 

	filehandle2: 
		db      0 

	chunkloadflag:
		db      0 

	sample_stereo:
		db 		0 

end asm 

sample_offset:
asm 
sample_offset: 
	dw      CTCBASE*256

sample_start:
	dw      CTCBASE*256
end asm 

Sprites:
asm 
	Sprite1:
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $92, $92, $92, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $92, $E3, $92, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $92, $92, $92, $92, $92, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $92, $E3, $E3, $92, $92, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $92, $E3, $E3, $E3, $92, $92, $92, $E3, $E3, $E3, $E3, $E3, $92, $92;
		db  $E3, $E3, $92, $92, $E3, $E3, $E3, $92, $E3, $E3, $E3, $E3, $E3, $92, $92, $E3;
		db  $E3, $E3, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $92, $E3, $92, $92, $92, $92, $92, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $92, $E3, $92, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $92, $92, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $92, $92, $92, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $E3, $E3, $92, $92, $E3, $E3, $E3, $E3;



	Sprite2:
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $92, $92, $92, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $92, $E3, $92, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $92, $92, $92, $92, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $92, $E3, $E3, $92, $E3, $E3, $E3, $E3, $E3;
		db  $92, $92, $E3, $E3, $E3, $E3, $E3, $92, $92, $92, $E3, $E3, $E3, $92, $E3, $E3;
		db  $E3, $92, $92, $E3, $E3, $E3, $E3, $E3, $92, $E3, $E3, $E3, $92, $92, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $92, $92, $92, $92, $92, $E3, $92, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $92, $E3, $92, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $92, $92, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $92, $92, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $92, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $92, $92, $E3, $E3, $E3, $92, $E3, $E3, $E3, $E3, $E3, $E3;

    end asm 

raster_frame:
asm 
    raster_frame:
    	db  0
end asm 