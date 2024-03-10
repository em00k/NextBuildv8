startup:	di			; Set stack and interrupts
	ld 	(exit_stack+1),sp
	ld	sp,stack	; System STACK

	nextreg	TURBO,00000011b	; 28Mhz / 27Mhz

	ld	hl,vector_table	; 252 (FCh)
	ld	a,h
	ld	i,a
	im	2

	inc	a		; 253 (FDh)
	ld	b,l		; Build 257 BYTE INT table

.irq:	ld	(hl),a
	inc	hl
	djnz	.irq		; B = 0
	ld	(hl),a

	ld	a,0FBh		; EI
	ld	hl,04DEDh	; RETI
	ld	[irq_vector-1],a
	ld	[irq_vector],hl


	nextreg	INTMSB,00000100b; ULA off / LINE interrupt off
	nextreg	INTLSB,255	; IRQ on line 192 (not used)

	ld	a,128		; Can cause initial click
	out	(DAC_AD),a
	out	(DAC_BC),a

 	xor	a


     ;nextreg	MM4,BANK8K_FINETUNE
     ;nextreg	MM5,5		; See MAIN.ASM (FINETUNE.INC)
     ;ld	hl,40960
     ;ld	de,32768	; MMU scratch
     ;ld	bc,4096+1536+512
     ;ldir			; Copy to bank8k
 
     call	create_volume_tables

     ld	de,-1		; LINE (-1 = use Paula)
     ld	bc,192		; Vsync line
     call	ctc_init	; CTC set to dummy EI:RETI
 
     ;ld	ix,ntsc_filename; Load NTSC period tab
     ;add	a,"0"		; Patch video timing file
     ;ld	(ix+11),a
 
     ;ld	a,BANK8K_PERIOD
     ;ld 	ix, path_filename
     ;call	load_period_tab
 
 