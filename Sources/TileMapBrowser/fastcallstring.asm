	org 32768
.core.__START_PROGRAM:
	di
	push ix
	push iy
	exx
	push hl
	exx
	ld hl, 0
	add hl, sp
	ld (.core.__CALL_BACK__), hl
	ei
	call .core.__MEM_INIT
	call .core.__PRINT_INIT
	jp .core.__MAIN_PROGRAM__
.core.__CALL_BACK__:
	DEFW 0
.core.ZXBASIC_USER_DATA:
	; Defines HEAP SIZE
.core.ZXBASIC_HEAP_SIZE EQU 2048
.core.ZXBASIC_MEM_HEAP:
	DEFS 2048
	; Defines USER DATA Length in bytes
.core.ZXBASIC_USER_DATA_LEN EQU .core.ZXBASIC_USER_DATA_END - .core.ZXBASIC_USER_DATA
	.core.__LABEL__.ZXBASIC_USER_DATA_LEN EQU .core.ZXBASIC_USER_DATA_LEN
	.core.__LABEL__.ZXBASIC_USER_DATA EQU .core.ZXBASIC_USER_DATA
_t:
	DEFB 00, 00
_n:
	DEFB 00, 00, 00, 00, 00
.core.ZXBASIC_USER_DATA_END:
.core.__MAIN_PROGRAM__:
#line 17 "/NextBuildv7/Scripts/nextlib.bas"
		BIT_UP			equ 4
		BIT_DOWN		equ 5
		BIT_LEFT		equ 6
		BIT_RIGHT		equ 7
		DIR_NONE		equ %00000000
		DIR_UP			equ %00010000
		DIR_DOWN		equ %00100000
		DIR_LEFT		equ %01000000
		DIR_RIGHT		equ %10000000
		DIR_UP_I		equ %11101111
		DIR_DOWN_I		equ %11011111
		DIR_LEFT_I		equ %10111111
		DIR_RIGHT_I		equ %01111111
		ULA_P_FE                        equ $FE
		TIMEX_P_FF                      equ $FF
		ZX128_MEMORY_P_7FFD             equ $7FFD
		ZX128_MEMORY_P_DFFD             equ $DFFD
		ZX128P3_MEMORY_P_1FFD           equ $1FFD
		AY_REG_P_FFFD                   equ $FFFD
		AY_DATA_P_BFFD                  equ $BFFD
		Z80_DMA_PORT_DATAGEAR           equ $6B
		Z80_DMA_PORT_MB02               equ $0B
		DIVMMC_CONTROL_P_E3             equ $E3
		SPI_CS_P_E7                     equ $E7
		SPI_DATA_P_EB                   equ $EB
		KEMPSTON_MOUSE_X_P_FBDF         equ $FBDF
		KEMPSTON_MOUSE_Y_P_FFDF         equ $FFDF
		KEMPSTON_MOUSE_B_P_FADF         equ $FADF
		KEMPSTON_JOY1_P_1F              equ $1F
		KEMPSTON_JOY2_P_37              equ $37
		TBBLUE_REGISTER_SELECT_P_243B   equ $243B
		TBBLUE_REGISTER_ACCESS_P_253B   equ $253B
		DAC_GS_COVOX_INDEX              equ     1
		DAC_PENTAGON_ATM_INDEX          equ     2
		DAC_SPECDRUM_INDEX              equ     3
		DAC_SOUNDRIVE1_INDEX            equ     4
		DAC_SOUNDRIVE2_INDEX            equ     5
		DAC_COVOX_INDEX                 equ     6
		DAC_PROFI_COVOX_INDEX           equ     7
		I2C_SCL_P_103B                  equ $103B
		I2C_SDA_P_113B                  equ $113B
		UART_TX_P_133B                  equ $133B
		UART_RX_P_143B                  equ $143B
		UART_CTRL_P_153B                equ $153B
		ZILOG_DMA_P_0B                  equ $0B
		ZXN_DMA_P_6B                    equ $6B
		LAYER2_ACCESS_P_123B            equ $123B
		LAYER2_ACCESS_WRITE_OVER_ROM    equ $01
		LAYER2_ACCESS_L2_ENABLED        equ $02
		LAYER2_ACCESS_READ_OVER_ROM     equ $04
		LAYER2_ACCESS_SHADOW_OVER_ROM   equ $08
		LAYER2_ACCESS_BANK_OFFSET       equ $10
		LAYER2_ACCESS_OVER_ROM_BANK_M   equ $C0
		LAYER2_ACCESS_OVER_ROM_BANK_0   equ $00
		LAYER2_ACCESS_OVER_ROM_BANK_1   equ $40
		LAYER2_ACCESS_OVER_ROM_BANK_2   equ $80
		LAYER2_ACCESS_OVER_ROM_48K      equ $C0
		SPRITE_STATUS_SLOT_SELECT_P_303B    equ $303B
		SPRITE_STATUS_MAXIMUM_SPRITES   equ $02
		SPRITE_STATUS_COLLISION         equ $01
		SPRITE_SLOT_SELECT_PATTERN_HALF equ 128
		SPRITE_ATTRIBUTE_P_57           equ $57
		SPRITE_PATTERN_P_5B             equ $5B
		TURBO_SOUND_CONTROL_P_FFFD      equ $FFFD
		MACHINE_ID_NR_00                equ $00
		NEXT_VERSION_NR_01              equ $01
		NEXT_RESET_NR_02                equ $02
		MACHINE_TYPE_NR_03              equ $03
		ROM_MAPPING_NR_04               equ $04
		PERIPHERAL_1_NR_05              equ $05
		PERIPHERAL_2_NR_06              equ $06
		TURBO_CONTROL_NR_07             equ $07
		PERIPHERAL_3_NR_08              equ $08
		PERIPHERAL_4_NR_09              equ $09
		PERIPHERAL_5_NR_0A              equ $0A
		NEXT_VERSION_MINOR_NR_0E        equ $0E
		ANTI_BRICK_NR_10                equ $10
		VIDEO_TIMING_NR_11              equ $11
		LAYER2_RAM_BANK_NR_12           equ $12
		LAYER2_RAM_SHADOW_BANK_NR_13    equ $13
		GLOBAL_TRANSPARENCY_NR_14       equ $14
		SPRITE_CONTROL_NR_15            equ $15
		LAYER2_XOFFSET_NR_16            equ $16
		LAYER2_YOFFSET_NR_17            equ $17
		CLIP_LAYER2_NR_18               equ $18
		CLIP_SPRITE_NR_19               equ $19
		CLIP_ULA_LORES_NR_1A            equ $1A
		CLIP_TILEMAP_NR_1B              equ $1B
		CLIP_WINDOW_CONTROL_NR_1C       equ $1C
		VIDEO_LINE_MSB_NR_1E            equ $1E
		VIDEO_LINE_LSB_NR_1F            equ $1F
		VIDEO_INTERUPT_CONTROL_NR_22    equ $22
		VIDEO_INTERUPT_VALUE_NR_23      equ $23
		ULA_XOFFSET_NR_26               equ $26
		ULA_YOFFSET_NR_27               equ $27
		HIGH_ADRESS_KEYMAP_NR_28        equ $28
		LOW_ADRESS_KEYMAP_NR_29         equ $29
		HIGH_DATA_TO_KEYMAP_NR_2A       equ $2A
		LOW_DATA_TO_KEYMAP_NR_2B        equ $2B
		DAC_B_MIRROR_NR_2C              equ $2C
		DAC_AD_MIRROR_NR_2D             equ $2D
		SOUNDDRIVE_DF_MIRROR_NR_2D      equ $2D
		DAC_C_MIRROR_NR_2E              equ $2E
		TILEMAP_XOFFSET_MSB_NR_2F       equ $2F
		TILEMAP_XOFFSET_LSB_NR_30       equ $30
		TILEMAP_YOFFSET_NR_31           equ $31
		LORES_XOFFSET_NR_32             equ $32
		LORES_YOFFSET_NR_33             equ $33
		SPRITE_ATTR_SLOT_SEL_NR_34      equ $34
		SPRITE_ATTR0_NR_35              equ $35
		SPRITE_ATTR1_NR_36              equ $36
		SPRITE_ATTR2_NR_37              equ $37
		SPRITE_ATTR3_NR_38              equ $38
		SPRITE_ATTR4_NR_39              equ $39
		PALETTE_INDEX_NR_40             equ $40
		PALETTE_VALUE_NR_41             equ $41
		PALETTE_FORMAT_NR_42            equ $42
		PALETTE_CONTROL_NR_43           equ $43
		PALETTE_VALUE_9BIT_NR_44        equ $44
		TRANSPARENCY_FALLBACK_COL_NR_4A equ $4A
		SPRITE_TRANSPARENCY_I_NR_4B     equ $4B
		TILEMAP_TRANSPARENCY_I_NR_4C    equ $4C
		MMU0_0000_NR_50                 equ $50
		MMU1_2000_NR_51                 equ $51
		MMU2_4000_NR_52                 equ $52
		MMU3_6000_NR_53                 equ $53
		MMU4_8000_NR_54                 equ $54
		MMU5_A000_NR_55                 equ $55
		MMU6_C000_NR_56                 equ $56
		MMU7_E000_NR_57                 equ $57
		COPPER_DATA_NR_60               equ $60
		COPPER_CONTROL_LO_NR_61         equ $61
		COPPER_CONTROL_HI_NR_62         equ $62
		COPPER_DATA_16B_NR_63           equ $63
		VIDEO_LINE_OFFSET_NR_64         equ $64
		ULA_CONTROL_NR_68               equ $68
		DISPLAY_CONTROL_NR_69           equ $69
		LORES_CONTROL_NR_6A             equ $6A
		TILEMAP_CONTROL_NR_6B           equ $6B
		TILEMAP_DEFAULT_ATTR_NR_6C      equ $6C
		TILEMAP_BASE_ADR_NR_6E          equ $6E
		TILEMAP_GFX_ADR_NR_6F           equ $6F
		LAYER2_CONTROL_NR_70            equ $70
		LAYER2_XOFFSET_MSB_NR_71        equ $71
		SPRITE_ATTR0_INC_NR_75          equ $75
		SPRITE_ATTR1_INC_NR_76          equ $76
		SPRITE_ATTR2_INC_NR_77          equ $77
		SPRITE_ATTR3_INC_NR_78          equ $78
		SPRITE_ATTR4_INC_NR_79          equ $79
		USER_STORAGE_0_NR_7F            equ $7F
		EXPANSION_BUS_ENABLE_NR_80      equ $80
		EXPANSION_BUS_CONTROL_NR_81     equ $81
		INTERNAL_PORT_DECODING_0_NR_82  equ $82
		INTERNAL_PORT_DECODING_1_NR_83  equ $83
		INTERNAL_PORT_DECODING_2_NR_84  equ $84
		INTERNAL_PORT_DECODING_3_NR_85  equ $85
		EXPANSION_BUS_DECODING_0_NR_86  equ $86
		EXPANSION_BUS_DECODING_1_NR_87  equ $87
		EXPANSION_BUS_DECODING_2_NR_88  equ $88
		EXPANSION_BUS_DECODING_3_NR_89  equ $89
		EXPANSION_BUS_PROPAGATE_NR_8A   equ $8A
		ALTERNATE_ROM_NR_8C             equ $8C
		ZX_MEM_MAPPING_NR_8E            equ $8E
		PI_GPIO_OUT_ENABLE_0_NR_90      equ $90
		PI_GPIO_OUT_ENABLE_1_NR_91      equ $91
		PI_GPIO_OUT_ENABLE_2_NR_92      equ $92
		PI_GPIO_OUT_ENABLE_3_NR_93      equ $93
		PI_GPIO_0_NR_98                 equ $98
		PI_GPIO_1_NR_99                 equ $99
		PI_GPIO_2_NR_9A                 equ $9A
		PI_GPIO_3_NR_9B                 equ $9B
		PI_PERIPHERALS_ENABLE_NR_A0     equ $A0
		PI_I2S_AUDIO_CONTROL_NR_A2      equ $A2
		ESP_WIFI_GPIO_OUTPUT_NR_A8      equ $A8
		ESP_WIFI_GPIO_NR_A9             equ $A9
		EXTENDED_KEYS_0_NR_B0           equ $B0
		EXTENDED_KEYS_1_NR_B1           equ $B1
		DEBUG_LED_CONTROL_NR_FF         equ $FF
		MEM_ROM_CHARS_3C00              equ $3C00
		MEM_ZX_SCREEN_4000              equ $4000
		MEM_ZX_ATTRIB_5800              equ $5800
		MEM_LORES0_4000                 equ $4000
		MEM_LORES1_6000                 equ $6000
		MEM_TIMEX_SCR0_4000             equ $4000
		MEM_TIMEX_SCR1_6000             equ $6000
		COPPER_NOOP                     equ %00000000
		COPPER_WAIT_H                   equ %10000000
		COPPER_HALT_B                   equ $FF
		DMA_RESET					equ $C3
		DMA_RESET_PORT_A_TIMING		equ $C7
		DMA_RESET_PORT_B_TIMING		equ $CB
		DMA_LOAD					equ $CF
		DMA_CONTINUE				equ $D3
		DMA_DISABLE_INTERUPTS		equ $AF
		DMA_ENABLE_INTERUPTS		equ $AB
		DMA_RESET_DISABLE_INTERUPTS	equ $A3
		DMA_ENABLE_AFTER_RETI		equ $B7
		DMA_READ_STATUS_BYTE		equ $BF
		DMA_REINIT_STATUS_BYTE		equ $8B
		DMA_START_READ_SEQUENCE		equ $A7
		DMA_FORCE_READY				equ $B3
		DMA_DISABLE					equ $83
		DMA_ENABLE					equ $87
		DMA_READ_MASK_FOLLOWS		equ $BB
#line 318 "/NextBuildv7/Scripts/nextlib.bas"
#line 421 "/NextBuildv7/Scripts/nextlib.bas"
		M_GETSETDRV	equ $89
		F_OPEN     	equ $9a
		F_CLOSE    	equ $9b
		F_READ     	equ $9d
		F_WRITE    	equ $9e
		F_SEEK     	equ $9f
		F_STAT		equ $a1
		F_SIZE		equ $ac
		FA_READ     	equ $01
		FA_APPEND   	equ $06
		FA_OVERWRITE	equ $0C
		LAYER2_ACCESS_PORT EQU $123B
#line 434 "/NextBuildv7/Scripts/nextlib.bas"
	call _checkints
#line 3492 "/NextBuildv7/Scripts/nextlib.bas"
		ld iy,$5c3a
		jp nbtempstackstart
#line 3495 "/NextBuildv7/Scripts/nextlib.bas"
.LABEL._filename:
#line 3516 "/NextBuildv7/Scripts/nextlib.bas"
filename:
		DEFS 256,0
endfilename:
#line 3520 "/NextBuildv7/Scripts/nextlib.bas"
#line 3522 "/NextBuildv7/Scripts/nextlib.bas"
nbtempstackstart:
		ld sp,nbtempstackstart
#line 3525 "/NextBuildv7/Scripts/nextlib.bas"
#line 3527 "/NextBuildv7/Scripts/nextlib.bas"
sfxenablednl:
		db 0,0
shadowlayerbit:
		db 0
#line 3532 "/NextBuildv7/Scripts/nextlib.bas"
	ld hl, .LABEL.__LABEL0
	call .core.__LOADSTR
	push hl
	ld hl, .LABEL.__LABEL1
	call .core.__LOADSTR
	push hl
	call _ltrim
	ex de, hl
	ld hl, _t
	call .core.__STORE_STR2
	ld hl, (_t)
	xor a
	call .core.__PRINTSTR
	call .core.PRINT_EOL_ATTR
#line 31 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
		di
		halt
#line 34 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
.LABEL.__LABEL2:
	ld de, .LABEL.__LABEL4
	ld hl, _t
	call .core.__STORE_STR
	ld a, (_n)
	ld de, (_n + 1)
	ld bc, (_n + 3)
	call .core.__STR_FAST
	ex de, hl
	ld hl, .LABEL.__LABEL4
	push de
	call .core.__ADDSTR
	ex (sp), hl
	call .core.__MEM_FREE
	pop hl
	ld a, 1
	call _ExecDot
	ld hl, _n + 4
	call .core.__FP_PUSH_REV
	ld a, 081h
	ld de, 00000h
	ld bc, 00000h
	call .core.__ADDF
	ld hl, _n
	call .core.__STOREF
	jp .LABEL.__LABEL2
.core.__END_PROGRAM:
	di
	ld hl, (.core.__CALL_BACK__)
	ld sp, hl
	exx
	pop hl
	pop iy
	pop ix
	exx
	ei
	ret
_checkints:
#line 537 "/NextBuildv7/Scripts/nextlib.bas"
start:
		ex af,af'
		ld a,i
		ld a,r
		jp po,intsdisable
		ld a,1
		ld (itbuff),a
		ex af,af'
		ret
intsdisable:
		xor a
		ld (itbuff),a
		ex af,af'
		ret
itbuff:
		db 0
#line 556 "/NextBuildv7/Scripts/nextlib.bas"
_checkints__leave:
	ret
_ltrim:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, -8
	add hl, sp
	ld sp, hl
	ld (hl), 0
	ld bc, 7
	ld d, h
	ld e, l
	inc de
	ldir
	ld l, (ix+6)
	ld h, (ix+7)
	call .core.__STRLEN
	ld (ix-8), l
	ld (ix-7), h
	ld a, h
	or l
	jp nz, .LABEL.__LABEL6
	ld l, (ix+4)
	ld h, (ix+5)
	call .core.__LOADSTR
	jp _ltrim__leave
.LABEL.__LABEL6:
	ld l, (ix-8)
	ld h, (ix-7)
	dec hl
	ld (ix-4), l
	ld (ix-3), h
	ld l, (ix+4)
	ld h, (ix+5)
	call .core.__STRLEN
	ld (ix-6), l
	ld (ix-5), h
.LABEL.__LABEL7:
	ld l, (ix-2)
	ld h, (ix-1)
	push hl
	ld l, (ix-6)
	ld h, (ix-5)
	ex de, hl
	pop hl
	or a
	sbc hl, de
	sbc a, a
	push af
	ld l, (ix+6)
	ld h, (ix+7)
	push hl
	ld l, (ix+4)
	ld h, (ix+5)
	push hl
	ld l, (ix-2)
	ld h, (ix-1)
	push hl
	push hl
	ld l, (ix-4)
	ld h, (ix-3)
	ex de, hl
	pop hl
	add hl, de
	push hl
	xor a
	call .core.__STRSLICE
	ex de, hl
	pop hl
	ld a, 2
	call .core.__STREQ
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL9
	ld a, h
.LABEL.__LABEL9:
	or a
	jp z, .LABEL.__LABEL8
	ld l, (ix-2)
	ld h, (ix-1)
	push hl
	ld l, (ix-8)
	ld h, (ix-7)
	ex de, hl
	pop hl
	add hl, de
	ld (ix-2), l
	ld (ix-1), h
	jp .LABEL.__LABEL7
.LABEL.__LABEL8:
	ld l, (ix+4)
	ld h, (ix+5)
	push hl
	ld l, (ix-2)
	ld h, (ix-1)
	push hl
	ld hl, 65534
	push hl
	xor a
	call .core.__STRSLICE
_ltrim__leave:
	ex af, af'
	exx
	ld l, (ix+4)
	ld h, (ix+5)
	call .core.__MEM_FREE
	ld l, (ix+6)
	ld h, (ix+7)
	call .core.__MEM_FREE
	ex af, af'
	exx
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	ex (sp), hl
	exx
	ret
_ExecDot:
#line 45 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
		PROC
		LOCAL exedotfailed, execdotdone
		push hl
		ld a,(hl)
	inc hl : inc hl : ld de,.LABEL._filename : ld b,0 : ld c,a : ldir
	ld a,$0d : ld (de),a
	ld ix,.LABEL._filename : push ix : pop hl
	rst $8 : DB $8f
		jp execdotdone
exedotfailed:
		out($fe),a
execdotdone:
		pop hl
		jp .core.__MEM_FREE
		di
		ENDP
#line 75 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
_ExecDot__leave:
	ret
.LABEL.__LABEL0:
	DEFW 0003h
	DEFB 2Dh
	DEFB 2Dh
	DEFB 2Dh
.LABEL.__LABEL1:
	DEFW 000Bh
	DEFB 2Dh
	DEFB 2Dh
	DEFB 2Dh
	DEFB 42h
	DEFB 49h
	DEFB 47h
	DEFB 20h
	DEFB 54h
	DEFB 45h
	DEFB 53h
	DEFB 54h
.LABEL.__LABEL4:
	DEFW 0004h
	DEFB 74h
	DEFB 65h
	DEFB 73h
	DEFB 74h
	;; --- end of user code ---
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/addf.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/stackf.asm"
	; -------------------------------------------------------------
	; Functions to manage FP-Stack of the ZX Spectrum ROM CALC
	; -------------------------------------------------------------


	    push namespace core

	__FPSTACK_PUSH EQU 2AB6h	; Stores an FP number into the ROM FP stack (A, ED CB)
	__FPSTACK_POP  EQU 2BF1h	; Pops an FP number out of the ROM FP stack (A, ED CB)

__FPSTACK_PUSH2: ; Pushes Current A ED CB registers and top of the stack on (SP + 4)
	    ; Second argument to push into the stack calculator is popped out of the stack
	    ; Since the caller routine also receives the parameters into the top of the stack
	    ; four bytes must be removed from SP before pop them out

	    call __FPSTACK_PUSH ; Pushes A ED CB into the FP-STACK
	    exx
	    pop hl       ; Caller-Caller return addr
	    exx
	    pop hl       ; Caller return addr

	    pop af
	    pop de
	    pop bc

	    push hl      ; Caller return addr
	    exx
	    push hl      ; Caller-Caller return addr
	    exx

	    jp __FPSTACK_PUSH


__FPSTACK_I16:	; Pushes 16 bits integer in HL into the FP ROM STACK
	    ; This format is specified in the ZX 48K Manual
	    ; You can push a 16 bit signed integer as
	    ; 0 SS LL HH 0, being SS the sign and LL HH the low
	    ; and High byte respectively
	    ld a, h
	    rla			; sign to Carry
	    sbc	a, a	; 0 if positive, FF if negative
	    ld e, a
	    ld d, l
	    ld c, h
	    xor a
	    ld b, a
	    jp __FPSTACK_PUSH

	    pop namespace
#line 2 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/addf.asm"

	; -------------------------------------------------------------
	; Floating point library using the FP ROM Calculator (ZX 48K)
	; All of them uses A EDCB registers as 1st paramter.
	; For binary operators, the 2n operator must be pushed into the
	; stack, in the order AF DE BC (F not used).
	;
	; Uses CALLEE convention
	; -------------------------------------------------------------

	    push namespace core

__ADDF:	; Addition
	    call __FPSTACK_PUSH2

	    ; ------------- ROM ADD
	    rst 28h
	    defb 0fh	; ADD
	    defb 38h;   ; END CALC

	    jp __FPSTACK_POP

	    pop namespace

#line 104 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/free.asm"
; vim: ts=4:et:sw=4:
	; Copyleft (K) by Jose M. Rodriguez de la Rosa
	;  (a.k.a. Boriel)
;  http://www.boriel.com
	;
	; This ASM library is licensed under the BSD license
	; you can use it for any purpose (even for commercial
	; closed source programs).
	;
	; Please read the BSD license on the internet

	; ----- IMPLEMENTATION NOTES ------
	; The heap is implemented as a linked list of free blocks.

; Each free block contains this info:
	;
	; +----------------+ <-- HEAP START
	; | Size (2 bytes) |
	; |        0       | <-- Size = 0 => DUMMY HEADER BLOCK
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   | <-- If Size > 4, then this contains (size - 4) bytes
	; | (0 if Size = 4)|   |
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   |
	; | (0 if Size = 4)|   |
	; +----------------+   |
	;   <Allocated>        | <-- This zone is in use (Already allocated)
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   |
	; | (0 if Size = 4)|   |
	; +----------------+ <-+
	; | Next (2 bytes) |--> NULL => END OF LIST
	; |    0 = NULL    |
	; +----------------+
	; | <free bytes...>|
	; | (0 if Size = 4)|
	; +----------------+


	; When a block is FREED, the previous and next pointers are examined to see
	; if we can defragment the heap. If the block to be breed is just next to the
	; previous, or to the next (or both) they will be converted into a single
	; block (so defragmented).


	;   MEMORY MANAGER
	;
	; This library must be initialized calling __MEM_INIT with
	; HL = BLOCK Start & DE = Length.

	; An init directive is useful for initialization routines.
	; They will be added automatically if needed.

#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/heapinit.asm"
; vim: ts=4:et:sw=4:
	; Copyleft (K) by Jose M. Rodriguez de la Rosa
	;  (a.k.a. Boriel)
;  http://www.boriel.com
	;
	; This ASM library is licensed under the BSD license
	; you can use it for any purpose (even for commercial
	; closed source programs).
	;
	; Please read the BSD license on the internet

	; ----- IMPLEMENTATION NOTES ------
	; The heap is implemented as a linked list of free blocks.

; Each free block contains this info:
	;
	; +----------------+ <-- HEAP START
	; | Size (2 bytes) |
	; |        0       | <-- Size = 0 => DUMMY HEADER BLOCK
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   | <-- If Size > 4, then this contains (size - 4) bytes
	; | (0 if Size = 4)|   |
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   |
	; | (0 if Size = 4)|   |
	; +----------------+   |
	;   <Allocated>        | <-- This zone is in use (Already allocated)
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   |
	; | (0 if Size = 4)|   |
	; +----------------+ <-+
	; | Next (2 bytes) |--> NULL => END OF LIST
	; |    0 = NULL    |
	; +----------------+
	; | <free bytes...>|
	; | (0 if Size = 4)|
	; +----------------+


	; When a block is FREED, the previous and next pointers are examined to see
	; if we can defragment the heap. If the block to be breed is just next to the
	; previous, or to the next (or both) they will be converted into a single
	; block (so defragmented).


	;   MEMORY MANAGER
	;
	; This library must be initialized calling __MEM_INIT with
	; HL = BLOCK Start & DE = Length.

	; An init directive is useful for initialization routines.
	; They will be added automatically if needed.




	; ---------------------------------------------------------------------
	;  __MEM_INIT must be called to initalize this library with the
	; standard parameters
	; ---------------------------------------------------------------------
	    push namespace core

__MEM_INIT: ; Initializes the library using (RAMTOP) as start, and
	    ld hl, ZXBASIC_MEM_HEAP  ; Change this with other address of heap start
	    ld de, ZXBASIC_HEAP_SIZE ; Change this with your size

	; ---------------------------------------------------------------------
	;  __MEM_INIT2 initalizes this library
; Parameters:
;   HL : Memory address of 1st byte of the memory heap
;   DE : Length in bytes of the Memory Heap
	; ---------------------------------------------------------------------
__MEM_INIT2:
	    ; HL as TOP
	    PROC

	    dec de
	    dec de
	    dec de
	    dec de        ; DE = length - 4; HL = start
	    ; This is done, because we require 4 bytes for the empty dummy-header block

	    xor a
	    ld (hl), a
	    inc hl
    ld (hl), a ; First "free" block is a header: size=0, Pointer=&(Block) + 4
	    inc hl

	    ld b, h
	    ld c, l
	    inc bc
	    inc bc      ; BC = starts of next block

	    ld (hl), c
	    inc hl
	    ld (hl), b
	    inc hl      ; Pointer to next block

	    ld (hl), e
	    inc hl
	    ld (hl), d
	    inc hl      ; Block size (should be length - 4 at start); This block contains all the available memory

	    ld (hl), a ; NULL (0000h) ; No more blocks (a list with a single block)
	    inc hl
	    ld (hl), a

	    ld a, 201
	    ld (__MEM_INIT), a; "Pokes" with a RET so ensure this routine is not called again
	    ret

	    ENDP

	    pop namespace

#line 69 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/free.asm"

	; ---------------------------------------------------------------------
	; MEM_FREE
	;  Frees a block of memory
	;
; Parameters:
	;  HL = Pointer to the block to be freed. If HL is NULL (0) nothing
	;  is done
	; ---------------------------------------------------------------------

	    push namespace core

MEM_FREE:
__MEM_FREE: ; Frees the block pointed by HL
	    ; HL DE BC & AF modified
	    PROC

	    LOCAL __MEM_LOOP2
	    LOCAL __MEM_LINK_PREV
	    LOCAL __MEM_JOIN_TEST
	    LOCAL __MEM_BLOCK_JOIN

	    ld a, h
	    or l
	    ret z       ; Return if NULL pointer

	    dec hl
	    dec hl
	    ld b, h
	    ld c, l    ; BC = Block pointer

	    ld hl, ZXBASIC_MEM_HEAP  ; This label point to the heap start

__MEM_LOOP2:
	    inc hl
	    inc hl     ; Next block ptr

	    ld e, (hl)
	    inc hl
	    ld d, (hl) ; Block next ptr
	    ex de, hl  ; DE = &(block->next); HL = block->next

	    ld a, h    ; HL == NULL?
	    or l
	    jp z, __MEM_LINK_PREV; if so, link with previous

	    or a       ; Clear carry flag
	    sbc hl, bc ; Carry if BC > HL => This block if before
	    add hl, bc ; Restores HL, preserving Carry flag
	    jp c, __MEM_LOOP2 ; This block is before. Keep searching PASS the block

	;------ At this point current HL is PAST BC, so we must link (DE) with BC, and HL in BC->next

__MEM_LINK_PREV:    ; Link (DE) with BC, and BC->next with HL
	    ex de, hl
	    push hl
	    dec hl

	    ld (hl), c
	    inc hl
	    ld (hl), b ; (DE) <- BC

	    ld h, b    ; HL <- BC (Free block ptr)
	    ld l, c
	    inc hl     ; Skip block length (2 bytes)
	    inc hl
	    ld (hl), e ; Block->next = DE
	    inc hl
	    ld (hl), d
	    ; --- LINKED ; HL = &(BC->next) + 2

	    call __MEM_JOIN_TEST
	    pop hl

__MEM_JOIN_TEST:   ; Checks for fragmented contiguous blocks and joins them
	    ; hl = Ptr to current block + 2
	    ld d, (hl)
	    dec hl
	    ld e, (hl)
	    dec hl
	    ld b, (hl) ; Loads block length into BC
	    dec hl
	    ld c, (hl) ;

	    push hl    ; Saves it for later
	    add hl, bc ; Adds its length. If HL == DE now, it must be joined
	    or a
	    sbc hl, de ; If Z, then HL == DE => We must join
	    pop hl
	    ret nz

__MEM_BLOCK_JOIN:  ; Joins current block (pointed by HL) with next one (pointed by DE). HL->length already in BC
	    push hl    ; Saves it for later
	    ex de, hl

	    ld e, (hl) ; DE -> block->next->length
	    inc hl
	    ld d, (hl)
	    inc hl

	    ex de, hl  ; DE = &(block->next)
	    add hl, bc ; HL = Total Length

	    ld b, h
	    ld c, l    ; BC = Total Length

	    ex de, hl
	    ld e, (hl)
	    inc hl
	    ld d, (hl) ; DE = block->next

	    pop hl     ; Recovers Pointer to block
	    ld (hl), c
	    inc hl
	    ld (hl), b ; Length Saved
	    inc hl
	    ld (hl), e
	    inc hl
	    ld (hl), d ; Next saved
	    ret

	    ENDP

	    pop namespace

#line 105 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/loadstr.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/alloc.asm"
; vim: ts=4:et:sw=4:
	; Copyleft (K) by Jose M. Rodriguez de la Rosa
	;  (a.k.a. Boriel)
;  http://www.boriel.com
	;
	; This ASM library is licensed under the MIT license
	; you can use it for any purpose (even for commercial
	; closed source programs).
	;
	; Please read the MIT license on the internet

	; ----- IMPLEMENTATION NOTES ------
	; The heap is implemented as a linked list of free blocks.

; Each free block contains this info:
	;
	; +----------------+ <-- HEAP START
	; | Size (2 bytes) |
	; |        0       | <-- Size = 0 => DUMMY HEADER BLOCK
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   | <-- If Size > 4, then this contains (size - 4) bytes
	; | (0 if Size = 4)|   |
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   |
	; | (0 if Size = 4)|   |
	; +----------------+   |
	;   <Allocated>        | <-- This zone is in use (Already allocated)
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   |
	; | (0 if Size = 4)|   |
	; +----------------+ <-+
	; | Next (2 bytes) |--> NULL => END OF LIST
	; |    0 = NULL    |
	; +----------------+
	; | <free bytes...>|
	; | (0 if Size = 4)|
	; +----------------+


	; When a block is FREED, the previous and next pointers are examined to see
	; if we can defragment the heap. If the block to be freed is just next to the
	; previous, or to the next (or both) they will be converted into a single
	; block (so defragmented).


	;   MEMORY MANAGER
	;
	; This library must be initialized calling __MEM_INIT with
	; HL = BLOCK Start & DE = Length.

	; An init directive is useful for initialization routines.
	; They will be added automatically if needed.

#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/error.asm"
	; Simple error control routines
; vim:ts=4:et:

	    push namespace core

	ERR_NR    EQU    23610    ; Error code system variable


	; Error code definitions (as in ZX spectrum manual)

; Set error code with:
	;    ld a, ERROR_CODE
	;    ld (ERR_NR), a


	ERROR_Ok                EQU    -1
	ERROR_SubscriptWrong    EQU     2
	ERROR_OutOfMemory       EQU     3
	ERROR_OutOfScreen       EQU     4
	ERROR_NumberTooBig      EQU     5
	ERROR_InvalidArg        EQU     9
	ERROR_IntOutOfRange     EQU    10
	ERROR_NonsenseInBasic   EQU    11
	ERROR_InvalidFileName   EQU    14
	ERROR_InvalidColour     EQU    19
	ERROR_BreakIntoProgram  EQU    20
	ERROR_TapeLoadingErr    EQU    26


	; Raises error using RST #8
__ERROR:
	    ld (__ERROR_CODE), a
	    rst 8
__ERROR_CODE:
	    nop
	    ret

	; Sets the error system variable, but keeps running.
	; Usually this instruction if followed by the END intermediate instruction.
__STOP:
	    ld (ERR_NR), a
	    ret

	    pop namespace
#line 69 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/alloc.asm"



	; ---------------------------------------------------------------------
	; MEM_ALLOC
	;  Allocates a block of memory in the heap.
	;
	; Parameters
	;  BC = Length of requested memory block
	;
; Returns:
	;  HL = Pointer to the allocated block in memory. Returns 0 (NULL)
	;       if the block could not be allocated (out of memory)
	; ---------------------------------------------------------------------

	    push namespace core

MEM_ALLOC:
__MEM_ALLOC: ; Returns the 1st free block found of the given length (in BC)
	    PROC

	    LOCAL __MEM_LOOP
	    LOCAL __MEM_DONE
	    LOCAL __MEM_SUBTRACT
	    LOCAL __MEM_START
	    LOCAL TEMP, TEMP0

	TEMP EQU TEMP0 + 1

	    ld hl, 0
	    ld (TEMP), hl

__MEM_START:
	    ld hl, ZXBASIC_MEM_HEAP  ; This label point to the heap start
	    inc bc
	    inc bc  ; BC = BC + 2 ; block size needs 2 extra bytes for hidden pointer

__MEM_LOOP:  ; Loads lengh at (HL, HL+). If Lenght >= BC, jump to __MEM_DONE
	    ld a, h ;  HL = NULL (No memory available?)
	    or l
#line 113 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/alloc.asm"
	    ret z ; NULL
#line 115 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/alloc.asm"
	    ; HL = Pointer to Free block
	    ld e, (hl)
	    inc hl
	    ld d, (hl)
	    inc hl          ; DE = Block Length

	    push hl         ; HL = *pointer to -> next block
	    ex de, hl
	    or a            ; CF = 0
	    sbc hl, bc      ; FREE >= BC (Length)  (HL = BlockLength - Length)
	    jp nc, __MEM_DONE
	    pop hl
	    ld (TEMP), hl

	    ex de, hl
	    ld e, (hl)
	    inc hl
	    ld d, (hl)
	    ex de, hl
	    jp __MEM_LOOP

__MEM_DONE:  ; A free block has been found.
	    ; Check if at least 4 bytes remains free (HL >= 4)
	    push hl
	    exx  ; exx to preserve bc
	    pop hl
	    ld bc, 4
	    or a
	    sbc hl, bc
	    exx
	    jp nc, __MEM_SUBTRACT
	    ; At this point...
	    ; less than 4 bytes remains free. So we return this block entirely
	    ; We must link the previous block with the next to this one
	    ; (DE) => Pointer to next block
	    ; (TEMP) => &(previous->next)
	    pop hl     ; Discard current block pointer
	    push de
	    ex de, hl  ; DE = Previous block pointer; (HL) = Next block pointer
	    ld a, (hl)
	    inc hl
	    ld h, (hl)
	    ld l, a    ; HL = (HL)
	    ex de, hl  ; HL = Previous block pointer; DE = Next block pointer
TEMP0:
	    ld hl, 0   ; Pre-previous block pointer

	    ld (hl), e
	    inc hl
	    ld (hl), d ; LINKED
	    pop hl ; Returning block.

	    ret

__MEM_SUBTRACT:
	    ; At this point we have to store HL value (Length - BC) into (DE - 2)
	    ex de, hl
	    dec hl
	    ld (hl), d
	    dec hl
	    ld (hl), e ; Store new block length

	    add hl, de ; New length + DE => free-block start
	    pop de     ; Remove previous HL off the stack

	    ld (hl), c ; Store length on its 1st word
	    inc hl
	    ld (hl), b
	    inc hl     ; Return hl
	    ret

	    ENDP

	    pop namespace

#line 2 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/loadstr.asm"

	; Loads a string (ptr) from HL
	; and duplicates it on dynamic memory again
	; Finally, it returns result pointer in HL

	    push namespace core

__ILOADSTR:		; This is the indirect pointer entry HL = (HL)
	    ld a, h
	    or l
	    ret z
	    ld a, (hl)
	    inc hl
	    ld h, (hl)
	    ld l, a

__LOADSTR:		; __FASTCALL__ entry
	    ld a, h
	    or l
	    ret z	; Return if NULL

	    ld c, (hl)
	    inc hl
	    ld b, (hl)
	    dec hl  ; BC = LEN(a$)

	    inc bc
	    inc bc	; BC = LEN(a$) + 2 (two bytes for length)

	    push hl
	    push bc
	    call __MEM_ALLOC
	    pop bc  ; Recover length
	    pop de  ; Recover origin

	    ld a, h
	    or l
	    ret z	; Return if NULL (No memory)

	    ex de, hl ; ldir takes HL as source, DE as destiny, so SWAP HL,DE
	    push de	; Saves destiny start
	    ldir	; Copies string (length number included)
	    pop hl	; Recovers destiny in hl as result
	    ret

	    pop namespace
#line 106 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print_eol_attr.asm"
	; Calls PRINT_EOL and then COPY_ATTR, so saves
	; 3 bytes

#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
; vim:ts=4:sw=4:et:
; vim:ts=4:sw=4:et:
	; PRINT command routine
	; Does not print attribute. Use PRINT_STR or PRINT_NUM for that

#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/sposn.asm"
	; Printing positioning library.
	    push namespace core

	    PROC
	    LOCAL ECHO_E

__LOAD_S_POSN:		; Loads into DE current ROW, COL print position from S_POSN mem var.
	    ld de, (S_POSN)
	    ld hl, (MAXX)
	    or a
	    sbc hl, de
	    ex de, hl
	    ret


__SAVE_S_POSN:		; Saves ROW, COL from DE into S_POSN mem var.
	    ld hl, (MAXX)
	    or a
	    sbc hl, de
	    ld (S_POSN), hl ; saves it again
	    ret


	ECHO_E	EQU 23682
	MAXX	EQU ECHO_E   ; Max X position + 1
	MAXY	EQU MAXX + 1 ; Max Y position + 1

	S_POSN	EQU 23688
	POSX	EQU S_POSN		; Current POS X
	POSY	EQU S_POSN + 1	; Current POS Y

	    ENDP

	    pop namespace

#line 7 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/cls.asm"
	; JUMPS directly to spectrum CLS
	; This routine does not clear lower screen

	;CLS	EQU	0DAFh

	; Our faster implementation



	    push namespace core

CLS:
	    PROC

	    LOCAL COORDS
	    LOCAL __CLS_SCR
	    LOCAL ATTR_P
	    LOCAL SCREEN

	    ld hl, 0
	    ld (COORDS), hl
	    ld hl, 1821h
	    ld (S_POSN), hl
__CLS_SCR:
	    ld hl, SCREEN
	    ld (hl), 0
	    ld d, h
	    ld e, l
	    inc de
	    ld bc, 6144
	    ldir

	    ; Now clear attributes

	    ld a, (ATTR_P)
	    ld (hl), a
	    ld bc, 767
	    ldir
	    ret

	COORDS	EQU	23677
	SCREEN	EQU 16384 ; Default start of the screen (can be changed)
	ATTR_P	EQU 23693
	;you can poke (SCREEN_SCRADDR) to change CLS, DRAW & PRINTing address

	SCREEN_ADDR EQU (__CLS_SCR + 1) ; Address used by print and other screen routines
	    ; to get the start of the screen
	    ENDP

	    pop namespace

#line 8 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/in_screen.asm"



	    push namespace core

__IN_SCREEN:
	    ; Returns NO carry if current coords (D, E)
	    ; are OUT of the screen limits (MAXX, MAXY)

	    PROC
	    LOCAL __IN_SCREEN_ERR

	    ld hl, MAXX
	    ld a, e
	    cp (hl)
	    jr nc, __IN_SCREEN_ERR	; Do nothing and return if out of range

	    ld a, d
	    inc hl
	    cp (hl)
	    ;; jr nc, __IN_SCREEN_ERR	; Do nothing and return if out of range
	    ;; ret
	    ret c                       ; Return if carry (OK)

__IN_SCREEN_ERR:
__OUT_OF_SCREEN_ERR:
	    ; Jumps here if out of screen
	    ld a, ERROR_OutOfScreen
	    jp __STOP   ; Saves error code and exits

	    ENDP

	    pop namespace
#line 9 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/table_jump.asm"

	    push namespace core

JUMP_HL_PLUS_2A: ; Does JP (HL + A*2) Modifies DE. Modifies A
	    add a, a

JUMP_HL_PLUS_A:	 ; Does JP (HL + A) Modifies DE
	    ld e, a
	    ld d, 0

JUMP_HL_PLUS_DE: ; Does JP (HL + DE)
	    add hl, de
	    ld e, (hl)
	    inc hl
	    ld d, (hl)
	    ex de, hl
CALL_HL:
	    jp (hl)

	    pop namespace

#line 10 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/ink.asm"
	; Sets ink color in ATTR_P permanently
; Parameter: Paper color in A register

#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/const.asm"
	; Global constants

	    push namespace core

	P_FLAG	EQU 23697
	FLAGS2	EQU 23681
	ATTR_P	EQU 23693	; permanet ATTRIBUTES
	ATTR_T	EQU 23695	; temporary ATTRIBUTES
	CHARS	EQU 23606 ; Pointer to ROM/RAM Charset
	UDG	EQU 23675 ; Pointer to UDG Charset
	MEM0	EQU 5C92h ; Temporary memory buffer used by ROM chars

	    pop namespace

#line 5 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/ink.asm"

	    push namespace core

INK:
	    PROC
	    LOCAL __SET_INK
	    LOCAL __SET_INK2

	    ld de, ATTR_P

__SET_INK:
	    cp 8
	    jr nz, __SET_INK2

	    inc de ; Points DE to MASK_T or MASK_P
	    ld a, (de)
	    or 7 ; Set bits 0,1,2 to enable transparency
	    ld (de), a
	    ret

__SET_INK2:
	    ; Another entry. This will set the ink color at location pointer by DE
	    and 7	; # Gets color mod 8
	    ld b, a	; Saves the color
	    ld a, (de)
	    and 0F8h ; Clears previous value
	    or b
	    ld (de), a
	    inc de ; Points DE to MASK_T or MASK_P
	    ld a, (de)
	    and 0F8h ; Reset bits 0,1,2 sign to disable transparency
	    ld (de), a ; Store new attr
	    ret

	; Sets the INK color passed in A register in the ATTR_T variable
INK_TMP:
	    ld de, ATTR_T
	    jp __SET_INK

	    ENDP

	    pop namespace

#line 11 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/paper.asm"
	; Sets paper color in ATTR_P permanently
; Parameter: Paper color in A register



	    push namespace core

PAPER:
	    PROC
	    LOCAL __SET_PAPER
	    LOCAL __SET_PAPER2

	    ld de, ATTR_P

__SET_PAPER:
	    cp 8
	    jr nz, __SET_PAPER2
	    inc de
	    ld a, (de)
	    or 038h
	    ld (de), a
	    ret

	    ; Another entry. This will set the paper color at location pointer by DE
__SET_PAPER2:
	    and 7	; # Remove
	    rlca
	    rlca
	    rlca		; a *= 8

	    ld b, a	; Saves the color
	    ld a, (de)
	    and 0C7h ; Clears previous value
	    or b
	    ld (de), a
	    inc de ; Points to MASK_T or MASK_P accordingly
	    ld a, (de)
	    and 0C7h  ; Resets bits 3,4,5
	    ld (de), a
	    ret


	; Sets the PAPER color passed in A register in the ATTR_T variable
PAPER_TMP:
	    ld de, ATTR_T
	    jp __SET_PAPER
	    ENDP

	    pop namespace

#line 12 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/flash.asm"
	; Sets flash flag in ATTR_P permanently
; Parameter: Paper color in A register



	    push namespace core

FLASH:
	    ld hl, ATTR_P

	    PROC
	    LOCAL IS_TR
	    LOCAL IS_ZERO

__SET_FLASH:
	    ; Another entry. This will set the flash flag at location pointer by DE
	    cp 8
	    jr z, IS_TR

	    ; # Convert to 0/1
	    or a
	    jr z, IS_ZERO
	    ld a, 0x80

IS_ZERO:
	    ld b, a	; Saves the color
	    ld a, (hl)
	    and 07Fh ; Clears previous value
	    or b
	    ld (hl), a
	    inc hl
	    res 7, (hl)  ;Reset bit 7 to disable transparency
	    ret

IS_TR:  ; transparent
	    inc hl ; Points DE to MASK_T or MASK_P
	    set 7, (hl)  ;Set bit 7 to enable transparency
	    ret

	; Sets the FLASH flag passed in A register in the ATTR_T variable
FLASH_TMP:
	    ld hl, ATTR_T
	    jr __SET_FLASH
	    ENDP

	    pop namespace

#line 13 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/bright.asm"
	; Sets bright flag in ATTR_P permanently
; Parameter: Paper color in A register



	    push namespace core

BRIGHT:
	    ld hl, ATTR_P

	    PROC
	    LOCAL IS_TR
	    LOCAL IS_ZERO

__SET_BRIGHT:
	    ; Another entry. This will set the bright flag at location pointer by DE
	    cp 8
	    jr z, IS_TR

	    ; # Convert to 0/1
	    or a
	    jr z, IS_ZERO
	    ld a, 0x40

IS_ZERO:
	    ld b, a	; Saves the color
	    ld a, (hl)
	    and 0BFh ; Clears previous value
	    or b
	    ld (hl), a
	    inc hl
	    res 6, (hl)  ;Reset bit 6 to disable transparency
	    ret

IS_TR:  ; transparent
	    inc hl ; Points DE to MASK_T or MASK_P
	    set 6, (hl)  ;Set bit 6 to enable transparency
	    ret

	; Sets the BRIGHT flag passed in A register in the ATTR_T variable
BRIGHT_TMP:
	    ld hl, ATTR_T
	    jr __SET_BRIGHT
	    ENDP

	    pop namespace
#line 14 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/over.asm"
	; Sets OVER flag in P_FLAG permanently
; Parameter: OVER flag in bit 0 of A register
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/copy_attr.asm"


#line 4 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/copy_attr.asm"



	    push namespace core

COPY_ATTR:
	    ; Just copies current permanent attribs into temporal attribs
	    ; and sets print mode
	    PROC

	    LOCAL INVERSE1
	    LOCAL __REFRESH_TMP

	INVERSE1 EQU 02Fh

	    ld hl, (ATTR_P)
	    ld (ATTR_T), hl

	    ld hl, FLAGS2
	    call __REFRESH_TMP

	    ld hl, P_FLAG
	    call __REFRESH_TMP


__SET_ATTR_MODE:		; Another entry to set print modes. A contains (P_FLAG)


	    LOCAL TABLE
	    LOCAL CONT2

	    rra					; Over bit to carry
	    ld a, (FLAGS2)
	    rla					; Over bit in bit 1, Over2 bit in bit 2
	    and 3				; Only bit 0 and 1 (OVER flag)

	    ld c, a
	    ld b, 0

	    ld hl, TABLE
	    add hl, bc
	    ld a, (hl)
	    ld (PRINT_MODE), a

	    ld hl, (P_FLAG)
	    xor a			; NOP -> INVERSE0
	    bit 2, l
	    jr z, CONT2
	    ld a, INVERSE1 	; CPL -> INVERSE1

CONT2:
	    ld (INVERSE_MODE), a
	    ret

TABLE:
	    nop				; NORMAL MODE
	    xor (hl)		; OVER 1 MODE
	    and (hl)		; OVER 2 MODE
	    or  (hl)		; OVER 3 MODE

#line 67 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/copy_attr.asm"

__REFRESH_TMP:
	    ld a, (hl)
	    and 10101010b
	    ld c, a
	    rra
	    or c
	    ld (hl), a
	    ret

	    ENDP

	    pop namespace

#line 4 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/over.asm"


	    push namespace core

OVER:
	    PROC

	    ld c, a ; saves it for later
	    and 2
	    ld hl, FLAGS2
	    res 1, (HL)
	    or (hl)
	    ld (hl), a

	    ld a, c	; Recovers previous value
	    and 1	; # Convert to 0/1
	    add a, a; # Shift left 1 bit for permanent

	    ld hl, P_FLAG
	    res 1, (hl)
	    or (hl)
	    ld (hl), a
	    ret

	; Sets OVER flag in P_FLAG temporarily
OVER_TMP:
	    ld c, a ; saves it for later
	    and 2	; gets bit 1; clears carry
	    rra
	    ld hl, FLAGS2
	    res 0, (hl)
	    or (hl)
	    ld (hl), a

	    ld a, c	; Recovers previous value
	    and 1
	    ld hl, P_FLAG
	    res 0, (hl)
	    or (hl)
	    ld (hl), a
	    jp __SET_ATTR_MODE

	    ENDP

	    pop namespace

#line 15 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/inverse.asm"
	; Sets INVERSE flag in P_FLAG permanently
; Parameter: INVERSE flag in bit 0 of A register



	    push namespace core

INVERSE:
	    PROC

	    and 1	; # Convert to 0/1
	    add a, a; # Shift left 3 bits for permanent
	    add a, a
	    add a, a
	    ld hl, P_FLAG
	    res 3, (hl)
	    or (hl)
	    ld (hl), a
	    ret

	; Sets INVERSE flag in P_FLAG temporarily
INVERSE_TMP:
	    and 1
	    add a, a
	    add a, a; # Shift left 2 bits for temporary
	    ld hl, P_FLAG
	    res 2, (hl)
	    or (hl)
	    ld (hl), a
	    jp __SET_ATTR_MODE

	    ENDP

	    pop namespace

#line 16 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/bold.asm"
	; Sets BOLD flag in P_FLAG permanently
; Parameter: BOLD flag in bit 0 of A register


	    push namespace core

BOLD:
	    PROC

	    and 1
	    rlca
	    rlca
	    rlca
	    ld hl, FLAGS2
	    res 3, (HL)
	    or (hl)
	    ld (hl), a
	    ret

	; Sets BOLD flag in P_FLAG temporarily
BOLD_TMP:
	    and 1
	    rlca
	    rlca
	    ld hl, FLAGS2
	    res 2, (hl)
	    or (hl)
	    ld (hl), a
	    ret

	    ENDP

	    pop namespace

#line 17 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/italic.asm"
	; Sets ITALIC flag in P_FLAG permanently
; Parameter: ITALIC flag in bit 0 of A register


	    push namespace core

ITALIC:
	    PROC

	    and 1
	    rrca
	    rrca
	    rrca
	    ld hl, FLAGS2
	    res 5, (HL)
	    or (hl)
	    ld (hl), a
	    ret

	; Sets ITALIC flag in P_FLAG temporarily
ITALIC_TMP:
	    and 1
	    rrca
	    rrca
	    rrca
	    rrca
	    ld hl, FLAGS2
	    res 4, (hl)
	    or (hl)
	    ld (hl), a
	    ret

	    ENDP

	    pop namespace

#line 18 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"

#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/attr.asm"
	; Attribute routines
; vim:ts=4:et:sw:







	    push namespace core

__ATTR_ADDR:
	    ; calc start address in DE (as (32 * d) + e)
    ; Contributed by Santiago Romero at http://www.speccy.org
	    ld h, 0                     ;  7 T-States
	    ld a, d                     ;  4 T-States
	    add a, a     ; a * 2        ;  4 T-States
	    add a, a     ; a * 4        ;  4 T-States
	    ld l, a      ; HL = A * 4   ;  4 T-States

	    add hl, hl   ; HL = A * 8   ; 15 T-States
	    add hl, hl   ; HL = A * 16  ; 15 T-States
	    add hl, hl   ; HL = A * 32  ; 15 T-States

    ld d, 18h ; DE = 6144 + E. Note: 6144 is the screen size (before attr zone)
	    add hl, de

	    ld de, (SCREEN_ADDR)    ; Adds the screen address
	    add hl, de

	    ; Return current screen address in HL
	    ret


	; Sets the attribute at a given screen coordinate (D, E).
	; The attribute is taken from the ATTR_T memory variable
	; Used by PRINT routines
SET_ATTR:

	    ; Checks for valid coords
	    call __IN_SCREEN
	    ret nc

__SET_ATTR:
	    ; Internal __FASTCALL__ Entry used by printing routines
	    PROC

	    call __ATTR_ADDR

__SET_ATTR2:  ; Sets attr from ATTR_T to (HL) which points to the scr address
	    ld de, (ATTR_T)    ; E = ATTR_T, D = MASK_T

	    ld a, d
	    and (hl)
	    ld c, a    ; C = current screen color, masked

	    ld a, d
	    cpl        ; Negate mask
	    and e    ; Mask current attributes
	    or c    ; Mix them
	    ld (hl), a ; Store result in screen

	    ret

	    ENDP


	; Sets the attribute at a given screen pixel address in hl
	; HL contains the address in RAM for a given pixel (not a coordinate)
SET_PIXEL_ADDR_ATTR:
	    ;; gets ATTR position with offset given in SCREEN_ADDR
	    ld a, h
	    rrca
	    rrca
	    rrca
	    and 3
	    or 18h
	    ld h, a
	    ld de, (SCREEN_ADDR)
	    add hl, de  ;; Final screen addr
	    jp __SET_ATTR2

	    pop namespace
#line 20 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"

	; Putting a comment starting with @INIT <address>
	; will make the compiler to add a CALL to <address>
	; It is useful for initialization routines.


	    push namespace core

__PRINT_INIT: ; To be called before program starts (initializes library)
	    PROC

	    ld hl, __PRINT_START
	    ld (PRINT_JUMP_STATE), hl

	    ld hl, 1821h
	    ld (MAXX), hl  ; Sets current maxX and maxY

	    xor a
	    ld (FLAGS2), a

	    ret


__PRINTCHAR: ; Print character store in accumulator (A register)
	    ; Modifies H'L', B'C', A'F', D'E', A

	    LOCAL PO_GR_1

	    LOCAL __PRCHAR
	    LOCAL __PRINT_CONT
	    LOCAL __PRINT_CONT2
	    LOCAL __PRINT_JUMP
	    LOCAL __SRCADDR
	    LOCAL __PRINT_UDG
	    LOCAL __PRGRAPH
	    LOCAL __PRINT_START
	    LOCAL __ROM_SCROLL_SCR
	    LOCAL __TVFLAGS

	    __ROM_SCROLL_SCR EQU 0DFEh
	    __TVFLAGS EQU 5C3Ch

	PRINT_JUMP_STATE EQU __PRINT_JUMP + 1

__PRINT_JUMP:
	    jp __PRINT_START    ; Where to jump. If we print 22 (AT), next two calls jumps to AT1 and AT2 respectively


	    LOCAL __SCROLL
__SCROLL:  ; Scroll?
	    ld hl, __TVFLAGS
	    bit 1, (hl)
	    ret z
	    call __ROM_SCROLL_SCR
	    ld hl, __TVFLAGS
	    res 1, (hl)
	    ret
#line 78 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"

__PRINT_START:
	    cp ' '
	    jp c, __PRINT_SPECIAL    ; Characters below ' ' are special ones

	    exx               ; Switch to alternative registers
	    ex af, af'        ; Saves a value (char to print) for later


	    call __SCROLL
#line 89 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
	    call __LOAD_S_POSN

	; At this point we have the new coord
	    ld hl, (SCREEN_ADDR)

	    ld a, d
	    ld c, a     ; Saves it for later

	    and 0F8h    ; Masks 3 lower bit ; zy
	    ld d, a

	    ld a, c     ; Recovers it
	    and 07h     ; MOD 7 ; y1
	    rrca
	    rrca
	    rrca

	    or e
	    ld e, a
	    add hl, de    ; HL = Screen address + DE
	    ex de, hl     ; DE = Screen address

	    ex af, af'

	    cp 80h    ; Is it an UDG or a ?
	    jp c, __SRCADDR

	    cp 90h
	    jp nc, __PRINT_UDG

	    ; Print a 8 bit pattern (80h to 8Fh)

	    ld b, a
	    call PO_GR_1 ; This ROM routine will generate the bit pattern at MEM0
	    ld hl, MEM0
	    jp __PRGRAPH

	PO_GR_1 EQU 0B38h

__PRINT_UDG:
	    sub 90h ; Sub ASC code
	    ld bc, (UDG)
	    jp __PRGRAPH0

	__SOURCEADDR EQU (__SRCADDR + 1)    ; Address of the pointer to chars source
__SRCADDR:
	    ld bc, (CHARS)

__PRGRAPH0:
    add a, a   ; A = a * 2 (since a < 80h) ; Thanks to Metalbrain at http://foro.speccy.org
	    ld l, a
	    ld h, 0    ; HL = a * 2 (accumulator)
	    add hl, hl
	    add hl, hl ; HL = a * 8
	    add hl, bc ; HL = CHARS address

__PRGRAPH:
	    ex de, hl  ; HL = Write Address, DE = CHARS address
	    bit 2, (iy + $47)
	    call nz, __BOLD
	    bit 4, (iy + $47)
	    call nz, __ITALIC
	    ld b, 8 ; 8 bytes per char
__PRCHAR:
	    ld a, (de) ; DE *must* be ALWAYS source, and HL destiny

PRINT_MODE:     ; Which operation is used to write on the screen
    ; Set it with:
	    ; LD A, <OPERATION>
	    ; LD (PRINT_MODE), A
	    ;
    ; Available opertions:
    ; NORMAL : 0h  --> NOP         ; OVER 0
    ; XOR    : AEh --> XOR (HL)    ; OVER 1
    ; OR     : B6h --> OR (HL)     ; PUTSPRITE
    ; AND    : A6h --> AND (HL)    ; PUTMASK
	    nop     ;

INVERSE_MODE:   ; 00 -> NOP -> INVERSE 0
	    nop     ; 2F -> CPL -> INVERSE 1

	    ld (hl), a

	    inc de
	    inc h     ; Next line
	    djnz __PRCHAR

	    call __LOAD_S_POSN
	    push de
	    call __SET_ATTR
	    pop de
	    inc e            ; COL = COL + 1
	    ld hl, (MAXX)
	    ld a, e
	    dec l            ; l = MAXX
	    cp l             ; Lower than max?
	    jp nc, __PRINT_EOL1

__PRINT_CONT:
	    call __SAVE_S_POSN

__PRINT_CONT2:
	    exx
	    ret

	; ------------- SPECIAL CHARS (< 32) -----------------

__PRINT_SPECIAL:    ; Jumps here if it is a special char
	    exx
	    ld hl, __PRINT_TABLE
	    jp JUMP_HL_PLUS_2A


PRINT_EOL:        ; Called WHENEVER there is no ";" at end of PRINT sentence
	    exx

__PRINT_0Dh:        ; Called WHEN printing CHR$(13)

	    call __SCROLL
#line 209 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
	    call __LOAD_S_POSN

__PRINT_EOL1:        ; Another entry called from PRINT when next line required
	    ld e, 0

__PRINT_EOL2:
	    ld a, d
	    inc a

__PRINT_AT1_END:
	    ld hl, (MAXY)
	    cp l
	    jr c, __PRINT_EOL_END    ; Carry if (MAXY) < d

	    ld hl, __TVFLAGS
	    set 1, (hl)
	    dec a
#line 229 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"

__PRINT_EOL_END:
	    ld d, a

__PRINT_AT2_END:
	    call __SAVE_S_POSN
	    exx
	    ret

__PRINT_COM:
	    exx
	    push hl
	    push de
	    push bc
	    call PRINT_COMMA
	    pop bc
	    pop de
	    pop hl
	    ret

__PRINT_TAB:
	    ld hl, __PRINT_TAB1
	    jr __PRINT_SET_STATE

__PRINT_TAB1:
	    ld (MEM0), a
	    exx
	    ld hl, __PRINT_TAB2
	    jr __PRINT_SET_STATE

__PRINT_TAB2:
	    ld a, (MEM0)        ; Load tab code (ignore the current one)
	    push hl
	    push de
	    push bc
	    ld hl, __PRINT_START
	    ld (PRINT_JUMP_STATE), hl
	    call PRINT_TAB
	    pop bc
	    pop de
	    pop hl
	    ret

__PRINT_NOP:
__PRINT_RESTART:
	    ld hl, __PRINT_START
	    jr __PRINT_SET_STATE

__PRINT_AT:
	    ld hl, __PRINT_AT1

__PRINT_SET_STATE:
	    ld (PRINT_JUMP_STATE), hl    ; Saves next entry call
	    exx
	    ret

__PRINT_AT1:    ; Jumps here if waiting for 1st parameter
	    exx
	    ld hl, __PRINT_AT2
	    ld (PRINT_JUMP_STATE), hl    ; Saves next entry call
	    call __LOAD_S_POSN
	    jr __PRINT_AT1_END

__PRINT_AT2:
	    exx
	    ld hl, __PRINT_START
	    ld (PRINT_JUMP_STATE), hl    ; Saves next entry call
	    call __LOAD_S_POSN
	    ld e, a
	    ld hl, (MAXX)
	    cp l
	    jr c, __PRINT_AT2_END
	    jr __PRINT_EOL1

__PRINT_DEL:
	    call __LOAD_S_POSN        ; Gets current screen position
	    dec e
	    ld a, -1
	    cp e
	    jp nz, __PRINT_AT2_END
	    ld hl, (MAXX)
	    ld e, l
	    dec e
	    dec e
	    dec d
	    cp d
	    jp nz, __PRINT_AT2_END
	    ld d, h
	    dec d
	    jp __PRINT_AT2_END

__PRINT_INK:
	    ld hl, __PRINT_INK2
	    jp __PRINT_SET_STATE

__PRINT_INK2:
	    exx
	    call INK_TMP
	    jp __PRINT_RESTART

__PRINT_PAP:
	    ld hl, __PRINT_PAP2
	    jp __PRINT_SET_STATE

__PRINT_PAP2:
	    exx
	    call PAPER_TMP
	    jp __PRINT_RESTART

__PRINT_FLA:
	    ld hl, __PRINT_FLA2
	    jp __PRINT_SET_STATE

__PRINT_FLA2:
	    exx
	    call FLASH_TMP
	    jp __PRINT_RESTART

__PRINT_BRI:
	    ld hl, __PRINT_BRI2
	    jp __PRINT_SET_STATE

__PRINT_BRI2:
	    exx
	    call BRIGHT_TMP
	    jp __PRINT_RESTART

__PRINT_INV:
	    ld hl, __PRINT_INV2
	    jp __PRINT_SET_STATE

__PRINT_INV2:
	    exx
	    call INVERSE_TMP
	    jp __PRINT_RESTART

__PRINT_OVR:
	    ld hl, __PRINT_OVR2
	    jp __PRINT_SET_STATE

__PRINT_OVR2:
	    exx
	    call OVER_TMP
	    jp __PRINT_RESTART

__PRINT_BOLD:
	    ld hl, __PRINT_BOLD2
	    jp __PRINT_SET_STATE

__PRINT_BOLD2:
	    exx
	    call BOLD_TMP
	    jp __PRINT_RESTART

__PRINT_ITA:
	    ld hl, __PRINT_ITA2
	    jp __PRINT_SET_STATE

__PRINT_ITA2:
	    exx
	    call ITALIC_TMP
	    jp __PRINT_RESTART


__BOLD:
	    push hl
	    ld hl, MEM0
	    ld b, 8
__BOLD_LOOP:
	    ld a, (de)
	    ld c, a
	    rlca
	    or c
	    ld (hl), a
	    inc hl
	    inc de
	    djnz __BOLD_LOOP
	    pop hl
	    ld de, MEM0
	    ret


__ITALIC:
	    push hl
	    ld hl, MEM0
	    ex de, hl
	    ld bc, 8
	    ldir
	    ld hl, MEM0
	    srl (hl)
	    inc hl
	    srl (hl)
	    inc hl
	    srl (hl)
	    inc hl
	    inc hl
	    inc hl
	    sla (hl)
	    inc hl
	    sla (hl)
	    inc hl
	    sla (hl)
	    pop hl
	    ld de, MEM0
	    ret

PRINT_COMMA:
	    call __LOAD_S_POSN
	    ld a, e
	    and 16
	    add a, 16

PRINT_TAB:
	    PROC
	    LOCAL LOOP, CONTINUE

	    inc a
	    call __LOAD_S_POSN ; e = current row
	    ld d, a
	    ld a, e
	    cp 21h
	    jr nz, CONTINUE
	    ld e, -1
CONTINUE:
	    ld a, d
	    inc e
	    sub e  ; A = A - E
	    and 31 ;
	    ret z  ; Already at position E
	    ld b, a
LOOP:
	    ld a, ' '
	    push bc
	    exx
	    call __PRINTCHAR
	    exx
	    pop bc
	    djnz LOOP
	    ret
	    ENDP

PRINT_AT: ; Changes cursor to ROW, COL
	    ; COL in A register
	    ; ROW in stack

	    pop hl    ; Ret address
	    ex (sp), hl ; callee H = ROW
	    ld l, a
	    ex de, hl

	    call __IN_SCREEN
	    ret nc    ; Return if out of screen

	    ld hl, __TVFLAGS
	    res 1, (hl)
#line 485 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print.asm"
	    jp __SAVE_S_POSN

	    LOCAL __PRINT_COM
	    LOCAL __BOLD
	    LOCAL __BOLD_LOOP
	    LOCAL __ITALIC
	    LOCAL __PRINT_EOL1
	    LOCAL __PRINT_EOL2
	    LOCAL __PRINT_AT1
	    LOCAL __PRINT_AT2
	    LOCAL __PRINT_AT2_END
	    LOCAL __PRINT_BOLD
	    LOCAL __PRINT_BOLD2
	    LOCAL __PRINT_ITA
	    LOCAL __PRINT_ITA2
	    LOCAL __PRINT_INK
	    LOCAL __PRINT_PAP
	    LOCAL __PRINT_SET_STATE
	    LOCAL __PRINT_TABLE
	    LOCAL __PRINT_TAB, __PRINT_TAB1, __PRINT_TAB2

__PRINT_TABLE:    ; Jump table for 0 .. 22 codes

	    DW __PRINT_NOP    ;  0
	    DW __PRINT_NOP    ;  1
	    DW __PRINT_NOP    ;  2
	    DW __PRINT_NOP    ;  3
	    DW __PRINT_NOP    ;  4
	    DW __PRINT_NOP    ;  5
	    DW __PRINT_COM    ;  6 COMMA
	    DW __PRINT_NOP    ;  7
	    DW __PRINT_DEL    ;  8 DEL
	    DW __PRINT_NOP    ;  9
	    DW __PRINT_NOP    ; 10
	    DW __PRINT_NOP    ; 11
	    DW __PRINT_NOP    ; 12
	    DW __PRINT_0Dh    ; 13
	    DW __PRINT_BOLD   ; 14
	    DW __PRINT_ITA    ; 15
	    DW __PRINT_INK    ; 16
	    DW __PRINT_PAP    ; 17
	    DW __PRINT_FLA    ; 18
	    DW __PRINT_BRI    ; 19
	    DW __PRINT_INV    ; 20
	    DW __PRINT_OVR    ; 21
	    DW __PRINT_AT     ; 22 AT
	    DW __PRINT_TAB    ; 23 TAB

	    ENDP

	    pop namespace


#line 5 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/print_eol_attr.asm"


	    push namespace core

PRINT_EOL_ATTR:
	    call PRINT_EOL
	    jp COPY_ATTR

	    pop namespace
#line 107 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/printstr.asm"





	; PRINT command routine
	; Prints string pointed by HL

	    push namespace core

PRINT_STR:
__PRINTSTR:		; __FASTCALL__ Entry to print_string
	    PROC
	    LOCAL __PRINT_STR_LOOP
	    LOCAL __PRINT_STR_END

	    ld d, a ; Saves A reg (Flag) for later

	    ld a, h
	    or l
	    ret z	; Return if the pointer is NULL

	    push hl

	    ld c, (hl)
	    inc hl
	    ld b, (hl)
	    inc hl	; BC = LEN(a$); HL = &a$

__PRINT_STR_LOOP:
	    ld a, b
	    or c
	    jr z, __PRINT_STR_END 	; END if BC (counter = 0)

	    ld a, (hl)
	    call __PRINTCHAR
	    inc hl
	    dec bc
	    jp __PRINT_STR_LOOP

__PRINT_STR_END:
	    pop hl
	    ld a, d ; Recovers A flag
	    or a   ; If not 0 this is a temporary string. Free it
	    ret z
	    jp __MEM_FREE ; Frees str from heap and return from there

__PRINT_STR:
	    ; Fastcall Entry
	    ; It ONLY prints strings
	    ; HL = String start
	    ; BC = String length (Number of chars)
	    push hl ; Push str address for later
	    ld d, a ; Saves a FLAG
	    jp __PRINT_STR_LOOP

	    ENDP

	    pop namespace

#line 108 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/pushf.asm"

	; Routine to push Float pointed by HL
	; Into the stack. Notice that the hl points to the last
	; byte of the FP number.
	; Uses H'L' B'C' and D'E' to preserve ABCDEHL registers

	    push namespace core

__FP_PUSH_REV:
	    push hl
	    exx
	    pop hl
	    pop bc ; Return Address
	    ld d, (hl)
	    dec hl
	    ld e, (hl)
	    dec hl
	    push de
	    ld d, (hl)
	    dec hl
	    ld e, (hl)
	    dec hl
	    push de
	    ld d, (hl)
	    push de
	    push bc ; Return Address
	    exx
	    ret

	    pop namespace


#line 109 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/storef.asm"
	    push namespace core

__PISTOREF:	; Indect Stores a float (A, E, D, C, B) at location stored in memory, pointed by (IX + HL)
	    push de
	    ex de, hl	; DE <- HL
	    push ix
	    pop hl		; HL <- IX
	    add hl, de  ; HL <- IX + HL
	    pop de

__ISTOREF:  ; Load address at hl, and stores A,E,D,C,B registers at that address. Modifies A' register
	    ex af, af'
	    ld a, (hl)
	    inc hl
	    ld h, (hl)
	    ld l, a     ; HL = (HL)
	    ex af, af'

__STOREF:	; Stores the given FP number in A EDCB at address HL
	    ld (hl), a
	    inc hl
	    ld (hl), e
	    inc hl
	    ld (hl), d
	    inc hl
	    ld (hl), c
	    inc hl
	    ld (hl), b
	    ret

	    pop namespace

#line 110 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/storestr.asm"
; vim:ts=4:et:sw=4
	; Stores value of current string pointed by DE register into address pointed by HL
	; Returns DE = Address pointer  (&a$)
	; Returns HL = HL               (b$ => might be needed later to free it from the heap)
	;
	; e.g. => HL = _variableName    (DIM _variableName$)
	;         DE = Address into the HEAP
	;
	; This function will resize (REALLOC) the space pointed by HL
	; before copying the content of b$ into a$


#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/strcpy.asm"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/realloc.asm"
; vim: ts=4:et:sw=4:
	; Copyleft (K) by Jose M. Rodriguez de la Rosa
	;  (a.k.a. Boriel)
;  http://www.boriel.com
	;
	; This ASM library is licensed under the BSD license
	; you can use it for any purpose (even for commercial
	; closed source programs).
	;
	; Please read the BSD license on the internet

	; ----- IMPLEMENTATION NOTES ------
	; The heap is implemented as a linked list of free blocks.

; Each free block contains this info:
	;
	; +----------------+ <-- HEAP START
	; | Size (2 bytes) |
	; |        0       | <-- Size = 0 => DUMMY HEADER BLOCK
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   | <-- If Size > 4, then this contains (size - 4) bytes
	; | (0 if Size = 4)|   |
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   |
	; | (0 if Size = 4)|   |
	; +----------------+   |
	;   <Allocated>        | <-- This zone is in use (Already allocated)
	; +----------------+ <-+
	; | Size (2 bytes) |
	; +----------------+
	; | Next (2 bytes) |---+
	; +----------------+   |
	; | <free bytes...>|   |
	; | (0 if Size = 4)|   |
	; +----------------+ <-+
	; | Next (2 bytes) |--> NULL => END OF LIST
	; |    0 = NULL    |
	; +----------------+
	; | <free bytes...>|
	; | (0 if Size = 4)|
	; +----------------+


	; When a block is FREED, the previous and next pointers are examined to see
	; if we can defragment the heap. If the block to be breed is just next to the
	; previous, or to the next (or both) they will be converted into a single
	; block (so defragmented).


	;   MEMORY MANAGER
	;
	; This library must be initialized calling __MEM_INIT with
	; HL = BLOCK Start & DE = Length.

	; An init directive is useful for initialization routines.
	; They will be added automatically if needed.







	; ---------------------------------------------------------------------
	; MEM_REALLOC
	;  Reallocates a block of memory in the heap.
	;
	; Parameters
	;  HL = Pointer to the original block
	;  BC = New Length of requested memory block
	;
; Returns:
	;  HL = Pointer to the allocated block in memory. Returns 0 (NULL)
	;       if the block could not be allocated (out of memory)
	;
; Notes:
	;  If BC = 0, the block is freed, otherwise
	;  the content of the original block is copied to the new one, and
	;  the new size is adjusted. If BC < original length, the content
	;  will be truncated. Otherwise, extra block content might contain
	;  memory garbage.
	;
	; ---------------------------------------------------------------------
	    push namespace core

__REALLOC:    ; Reallocates block pointed by HL, with new length BC
	    PROC

	    LOCAL __REALLOC_END

	    ld a, h
	    or l
	    jp z, __MEM_ALLOC    ; If HL == NULL, just do a malloc

	    ld e, (hl)
	    inc hl
	    ld d, (hl)    ; DE = First 2 bytes of HL block

	    push hl
	    exx
	    pop de
	    inc de        ; DE' <- HL + 2
	    exx            ; DE' <- HL (Saves current pointer into DE')

	    dec hl        ; HL = Block start

	    push de
	    push bc
	    call __MEM_FREE        ; Frees current block
	    pop bc
	    push bc
	    call __MEM_ALLOC    ; Gets a new block of length BC
	    pop bc
	    pop de

	    ld a, h
	    or l
	    ret z        ; Return if HL == NULL (No memory)

	    ld (hl), e
	    inc hl
	    ld (hl), d
	    inc hl        ; Recovers first 2 bytes in HL

	    dec bc
	    dec bc        ; BC = BC - 2 (Two bytes copied)

	    ld a, b
	    or c
	    jp z, __REALLOC_END        ; Ret if nothing to copy (BC == 0)

	    exx
	    push de
	    exx
	    pop de        ; DE <- DE' ; Start of remaining block

	    push hl        ; Saves current Block + 2 start
    ex de, hl    ; Exchanges them: DE is destiny block
	    ldir        ; Copies BC Bytes
	    pop hl        ; Recovers Block + 2 start

__REALLOC_END:

	    dec hl        ; Set HL
	    dec hl        ; To begin of block
	    ret

	    ENDP

	    pop namespace

#line 2 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/strcpy.asm"

	; String library


	    push namespace core

__STRASSIGN: ; Performs a$ = b$ (HL = address of a$; DE = Address of b$)
	    PROC

	    LOCAL __STRREALLOC
	    LOCAL __STRCONTINUE
	    LOCAL __B_IS_NULL
	    LOCAL __NOTHING_TO_COPY

	    ld b, d
	    ld c, e
	    ld a, b
	    or c
	    jr z, __B_IS_NULL

	    ex de, hl
	    ld c, (hl)
	    inc hl
	    ld b, (hl)
	    dec hl		; BC = LEN(b$)
	    ex de, hl	; DE = &b$

__B_IS_NULL:		; Jumps here if B$ pointer is NULL
	    inc bc
	    inc bc		; BC = BC + 2  ; (LEN(b$) + 2 bytes for storing length)

	    push de
	    push hl

	    ld a, h
	    or l
	    jr z, __STRREALLOC

	    dec hl
	    ld d, (hl)
	    dec hl
	    ld e, (hl)	; DE = MEMBLOCKSIZE(a$)
	    dec de
	    dec de		; DE = DE - 2  ; (Membloksize takes 2 bytes for memblock length)

	    ld h, b
	    ld l, c		; HL = LEN(b$) + 2  => Minimum block size required
	    ex de, hl	; Now HL = BLOCKSIZE(a$), DE = LEN(b$) + 2

	    or a		; Prepare to subtract BLOCKSIZE(a$) - LEN(b$)
	    sbc hl, de  ; Carry if len(b$) > Blocklen(a$)
	    jr c, __STRREALLOC ; No need to realloc
	    ; Need to reallocate at least to len(b$) + 2
	    ex de, hl	; DE = Remaining bytes in a$ mem block.
	    ld hl, 4
	    sbc hl, de  ; if remaining bytes < 4 we can continue
	    jr nc,__STRCONTINUE ; Otherwise, we realloc, to free some bytes

__STRREALLOC:
	    pop hl
	    call __REALLOC	; Returns in HL a new pointer with BC bytes allocated
	    push hl

__STRCONTINUE:	;   Pops hl and de SWAPPED
	    pop de	;	DE = &a$
	    pop hl	; 	HL = &b$

	    ld a, d		; Return if not enough memory for new length
	    or e
	    ret z		; Return if DE == NULL (0)

__STRCPY:	; Copies string pointed by HL into string pointed by DE
	    ; Returns DE as HL (new pointer)
	    ld a, h
	    or l
	    jr z, __NOTHING_TO_COPY
	    ld c, (hl)
	    inc hl
	    ld b, (hl)
	    dec hl
	    inc bc
	    inc bc
	    push de
	    ldir
	    pop hl
	    ret

__NOTHING_TO_COPY:
	    ex de, hl
	    ld (hl), e
	    inc hl
	    ld (hl), d
	    dec hl
	    ret

	    ENDP

	    pop namespace

#line 14 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/storestr.asm"

	    push namespace core

__PISTORE_STR:          ; Indirect assignement at (IX + BC)
	    push ix
	    pop hl
	    add hl, bc

__ISTORE_STR:           ; Indirect assignement, hl point to a pointer to a pointer to the heap!
	    ld c, (hl)
	    inc hl
	    ld h, (hl)
	    ld l, c             ; HL = (HL)

__STORE_STR:
	    push de             ; Pointer to b$
	    push hl             ; Array pointer to variable memory address

	    ld c, (hl)
	    inc hl
	    ld h, (hl)
	    ld l, c             ; HL = (HL)

	    call __STRASSIGN    ; HL (a$) = DE (b$); HL changed to a new dynamic memory allocation
	    ex de, hl           ; DE = new address of a$
	    pop hl              ; Recover variable memory address pointer

	    ld (hl), e
	    inc hl
	    ld (hl), d          ; Stores a$ ptr into elemem ptr

	    pop hl              ; Returns ptr to b$ in HL (Caller might needed to free it from memory)
	    ret

	    pop namespace

#line 111 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/storestr2.asm"
	; Similar to __STORE_STR, but this one is called when
	; the value of B$ if already duplicated onto the stack.
	; So we needn't call STRASSING to create a duplication
	; HL = address of string memory variable
	; DE = address of 2n string. It just copies DE into (HL)
	; 	freeing (HL) previously.



	    push namespace core

__PISTORE_STR2: ; Indirect store temporary string at (IX + BC)
	    push ix
	    pop hl
	    add hl, bc

__ISTORE_STR2:
	    ld c, (hl)  ; Dereferences HL
	    inc hl
	    ld h, (hl)
	    ld l, c		; HL = *HL (real string variable address)

__STORE_STR2:
	    push hl
	    ld c, (hl)
	    inc hl
	    ld h, (hl)
	    ld l, c		; HL = *HL (real string address)

	    push de
	    call __MEM_FREE
	    pop de

	    pop hl
	    ld (hl), e
	    inc hl
	    ld (hl), d
	    dec hl		; HL points to mem address variable. This might be useful in the future.

	    ret

	    pop namespace

#line 112 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/str.asm"
	; The STR$( ) BASIC function implementation

	; Given a FP number in C ED LH
	; Returns a pointer (in HL) to the memory heap
	; containing the FP number string representation





	    push namespace core

__STR:

__STR_FAST:

	    PROC
	    LOCAL __STR_END
	    LOCAL RECLAIM2
	    LOCAL STK_END

	    ld hl, (STK_END)
	    push hl; Stores STK_END
	    ld hl, (ATTR_T)	; Saves ATTR_T since it's changed by STR$ due to a ROM BUG
	    push hl

	    call __FPSTACK_PUSH ; Push number into stack
	    rst 28h		; # Rom Calculator
	    defb 2Eh	; # STR$(x)
	    defb 38h	; # END CALC
	    call __FPSTACK_POP ; Recovers string parameters to A ED CB (Only ED LH are important)

	    pop hl
	    ld (ATTR_T), hl	; Restores ATTR_T
	    pop hl
	    ld (STK_END), hl	; Balance STK_END to avoid STR$ bug

	    push bc
	    push de

	    inc bc
	    inc bc
	    call __MEM_ALLOC ; HL Points to new block

	    pop de
	    pop bc

	    push hl
	    ld a, h
	    or l
	    jr z, __STR_END  ; Return if NO MEMORY (NULL)

	    push bc
	    push de
	    ld (hl), c
	    inc hl
	    ld (hl), b
	    inc hl		; Copies length

	    ex de, hl	; HL = start of original string
	    ldir		; Copies string content

	    pop de		; Original (ROM-CALC) string
	    pop bc		; Original Length

__STR_END:
	    ex de, hl
	    inc bc

	    call RECLAIM2 ; Frees TMP Memory
	    pop hl		  ; String result

	    ret

	RECLAIM2 EQU 19E8h
	STK_END EQU 5C65h

	    ENDP

	    pop namespace

#line 113 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/strcat.asm"

#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/strlen.asm"
	; Returns len if a string
	; If a string is NULL, its len is also 0
	; Result returned in HL

	    push namespace core

__STRLEN:	; Direct FASTCALL entry
	    ld a, h
	    or l
	    ret z

	    ld a, (hl)
	    inc hl
	    ld h, (hl)  ; LEN(str) in HL
	    ld l, a
	    ret

	    pop namespace


#line 3 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/strcat.asm"

	    push namespace core

__ADDSTR:	; Implements c$ = a$ + b$
	    ; hl = &a$, de = &b$ (pointers)


__STRCAT2:	; This routine creates a new string in dynamic space
	    ; making room for it. Then copies a$ + b$ into it.
	    ; HL = a$, DE = b$

	    PROC

	    LOCAL __STR_CONT
	    LOCAL __STRCATEND

	    push hl
	    call __STRLEN
	    ld c, l
	    ld b, h		; BC = LEN(a$)
	    ex (sp), hl ; (SP) = LEN (a$), HL = a$
	    push hl		; Saves pointer to a$

	    inc bc
	    inc bc		; +2 bytes to store length

	    ex de, hl
	    push hl
	    call __STRLEN
	    ; HL = len(b$)

	    add hl, bc	; Total str length => 2 + len(a$) + len(b$)

	    ld c, l
	    ld b, h		; BC = Total str length + 2
	    call __MEM_ALLOC
	    pop de		; HL = c$, DE = b$

	    ex de, hl	; HL = b$, DE = c$
	    ex (sp), hl ; HL = a$, (SP) = b$

	    exx
	    pop de		; D'E' = b$
	    exx

	    pop bc		; LEN(a$)

	    ld a, d
	    or e
    ret z		; If no memory: RETURN

__STR_CONT:
	    push de		; Address of c$

	    ld a, h
	    or l
	    jr nz, __STR_CONT1 ; If len(a$) != 0 do copy

	    ; a$ is NULL => uses HL = DE for transfer
	    ld h, d
	    ld l, e
	    ld (hl), a	; This will copy 00 00 at (DE) location
	    inc de      ;
	    dec bc      ; Ensure BC will be set to 1 in the next step

__STR_CONT1:        ; Copies a$ (HL) into c$ (DE)
	    inc bc
	    inc bc		; BC = BC + 2
    ldir		; MEMCOPY: c$ = a$
	    pop hl		; HL = c$

	    exx
	    push de		; Recovers b$; A ex hl,hl' would be very handy
	    exx

	    pop de		; DE = b$

__STRCAT: ; ConCATenate two strings a$ = a$ + b$. HL = ptr to a$, DE = ptr to b$
    ; NOTE: Both DE, BC and AF are modified and lost
	    ; Returns HL (pointer to a$)
	    ; a$ Must be NOT NULL
	    ld a, d
	    or e
	    ret z		; Returns if de is NULL (nothing to copy)

	    push hl		; Saves HL to return it later

	    ld c, (hl)
	    inc hl
	    ld b, (hl)
	    inc hl
	    add hl, bc	; HL = end of (a$) string ; bc = len(a$)
	    push bc		; Saves LEN(a$) for later

	    ex de, hl	; DE = end of string (Begin of copy addr)
	    ld c, (hl)
	    inc hl
	    ld b, (hl)	; BC = len(b$)

	    ld a, b
	    or c
	    jr z, __STRCATEND; Return if len(b$) == 0

	    push bc			 ; Save LEN(b$)
	    inc hl			 ; Skip 2nd byte of len(b$)
	    ldir			 ; Concatenate b$

	    pop bc			 ; Recovers length (b$)
	    pop hl			 ; Recovers length (a$)
	    add hl, bc		 ; HL = LEN(a$) + LEN(b$) = LEN(a$+b$)
	    ex de, hl		 ; DE = LEN(a$+b$)
	    pop hl

	    ld (hl), e		 ; Updates new LEN and return
	    inc hl
	    ld (hl), d
	    dec hl
	    ret

__STRCATEND:
	    pop hl		; Removes Len(a$)
	    pop hl		; Restores original HL, so HL = a$
	    ret

	    ENDP

	    pop namespace

#line 114 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"
#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/string.asm"
	; String library



	    push namespace core

__STR_ISNULL:	; Returns A = FF if HL is 0, 0 otherwise
	    ld a, h
	    or l
	    sub 1		; Only CARRY if HL is NULL
	    sbc a, a	; Only FF if HL is NULL (0 otherwise)
	    ret


__STRCMP:	; Compares strings at HL, DE: Returns 0 if EQual, -1 if HL < DE, +1 if HL > DE
	    ; A register is preserved and returned in A'
	    PROC ; __FASTCALL__

	    LOCAL __STRCMPZERO
	    LOCAL __STRCMPEXIT
	    LOCAL __STRCMPLOOP
	    LOCAL __NOPRESERVEBC
	    LOCAL __EQULEN
	    LOCAL __EQULEN1
	    LOCAL __HLZERO

	    ex af, af'	; Saves current A register in A' (it's used by STRXX comparison functions)

	    ld a, h
	    or l
	    jr z, __HLZERO

	    ld a, d
	    or e
	    ld a, 1
	    ret z		; Returns +1 if HL is not NULL and DE is NULL

	    ld c, (hl)
	    inc hl
	    ld b, (hl)
	    inc hl		; BC = LEN(a$)
	    push hl		; HL = &a$, saves it

	    ex de, hl
	    ld e, (hl)
	    inc hl
	    ld d, (hl)
	    inc hl
	    ex de, hl	; HL = LEN(b$), de = &b$

	    ; At this point Carry is cleared, and A reg. = 1
	    sbc hl, bc	; Carry if len(b$) > len(a$)
	    jr z, __EQULEN	; Jump if they have the same length so A reg. = 0
	    jr c, __EQULEN1 ; Jump if len(b$) > len(a$) so A reg. = 1
__NOPRESERVEBC:
	    add hl, bc	; Restore HL (original length)
	    ld b, h		; len(b$) <= len(a$)
	    ld c, l		; so BC = hl
	    dec a		; At this point A register = 0, it must be -1 since len(a$) > len(b$)
__EQULEN:
	    dec a		; A = 0 if len(a$) = len(b$), -1 otherwise
__EQULEN1:
	    pop hl		; Recovers A$ pointer
	    push af		; Saves A for later (Value to return if strings reach the end)
	    ld a, b
	    or c
	    jr z, __STRCMPZERO ; empty string being compared

    ; At this point: BC = lesser length, DE and HL points to b$ and a$ chars respectively
__STRCMPLOOP:
	    ld a, (de)
	    cpi
	    jr nz, __STRCMPEXIT ; (HL) != (DE). Examine carry
	    jp po, __STRCMPZERO ; END of string (both are equal)
	    inc de
	    jp __STRCMPLOOP

__STRCMPZERO:
	    pop af		; This is -1 if len(a$) < len(b$), +1 if len(b$) > len(a$), 0 otherwise
	    ret

__STRCMPEXIT:		; Sets A with the following value
	    dec hl		; Get back to the last char
	    cp (hl)
	    sbc a, a	; A = -1 if carry => (DE) < (HL); 0 otherwise (DE) > (HL)
	    cpl			; A = -1 if (HL) < (DE), 0 otherwise
	    add a, a    ; A = A * 2 (thus -2 or 0)
	    inc a		; A = A + 1 (thus -1 or 1)

	    pop bc		; Discard top of the stack
	    ret

__HLZERO:
	    or d
	    or e
	    ret z		; Returns 0 (EQ) if HL == DE == NULL
	    ld a, -1
	    ret			; Returns -1 if HL is NULL and DE is not NULL

	    ENDP

	    ; The following routines perform string comparison operations (<, >, ==, etc...)
	    ; On return, A will contain 0 for False, other value for True
	    ; Register A' will determine whether the incoming strings (HL, DE) will be freed
    ; from dynamic memory on exit:
	    ;		Bit 0 => 1 means HL will be freed.
	    ;		Bit 1 => 1 means DE will be freed.

__STREQ:	; Compares a$ == b$ (HL = ptr a$, DE = ptr b$). Returns FF (True) or 0 (False)
	    push hl
	    push de
	    call __STRCMP
	    pop de
	    pop hl

	    ;inc a		; If A == -1, return 0
	    ;jp z, __FREE_STR

	    ;dec a		;
	    ;dec a		; Return -1 if a = 0 (True), returns 0 if A == 1 (False)
	    sub 1
	    sbc a, a
	    jp __FREE_STR


__STRNE:	; Compares a$ != b$ (HL = ptr a$, DE = ptr b$). Returns FF (True) or 0 (False)
	    push hl
	    push de
	    call __STRCMP
	    pop de
	    pop hl

	    ;jp z, __FREE_STR

	    ;ld a, 0FFh	; Returns 0xFFh (True)
	    jp __FREE_STR


__STRLT:	; Compares a$ < b$ (HL = ptr a$, DE = ptr b$). Returns FF (True) or 0 (False)
	    push hl
	    push de
	    call __STRCMP
	    pop de
	    pop hl

	    jp z, __FREE_STR ; Returns 0 if A == B

	    dec a		; Returns 0 if A == 1 => a$ > b$
	    ;jp z, __FREE_STR

	    ;inc a		; A = FE now (-2). Set it to FF and return
	    jp __FREE_STR


__STRLE:	; Compares a$ <= b$ (HL = ptr a$, DE = ptr b$). Returns FF (True) or 0 (False)
	    push hl
	    push de
	    call __STRCMP
	    pop de
	    pop hl

	    dec a		; Returns 0 if A == 1 => a$ < b$
	    ;jp z, __FREE_STR

	    ;ld a, 0FFh	; A = FE now (-2). Set it to FF and return
	    jp __FREE_STR


__STRGT:	; Compares a$ > b$ (HL = ptr a$, DE = ptr b$). Returns FF (True) or 0 (False)
	    push hl
	    push de
	    call __STRCMP
	    pop de
	    pop hl

	    jp z, __FREE_STR		; Returns 0 if A == B

	    inc a		; Returns 0 if A == -1 => a$ < b$
	    ;jp z, __FREE_STR		; Returns 0 if A == B

	    ;ld a, 0FFh	; A = FE now (-2). Set it to FF and return
	    jp __FREE_STR


__STRGE:	; Compares a$ >= b$ (HL = ptr a$, DE = ptr b$). Returns FF (True) or 0 (False)
	    push hl
	    push de
	    call __STRCMP
	    pop de
	    pop hl

	    inc a		; Returns 0 if A == -1 => a$ < b$
	    ;jr z, __FREE_STR

	    ;ld a, 0FFh	; A = FE now (-2). Set it to FF and return

__FREE_STR: ; This exit point will test A' for bits 0 and 1
	    ; If bit 0 is 1 => Free memory from HL pointer
	    ; If bit 1 is 1 => Free memory from DE pointer
	    ; Finally recovers A, to return the result
	    PROC

	    LOCAL __FREE_STR2
	    LOCAL __FREE_END

	    ex af, af'
	    bit 0, a
	    jr z, __FREE_STR2

	    push af
	    push de
	    call __MEM_FREE
	    pop de
	    pop af

__FREE_STR2:
	    bit 1, a
	    jr z, __FREE_END

	    ex de, hl
	    call __MEM_FREE

__FREE_END:
	    ex af, af'
	    ret

	    ENDP

	    pop namespace

#line 115 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"

#line 1 "C:/NextBuildv7/zxbasic/src/arch/zx48k/library-asm/strslice.asm"
	; String slicing library
	; HL = Str pointer
	; DE = String start
	; BC = String character end
	; A register => 0 => the HL pointer wont' be freed from the HEAP
	; e.g. a$(5 TO 10) => HL = a$; DE = 5; BC = 10

	; This implements a$(X to Y) being X and Y first and
	; last characters respectively. If X > Y, NULL is returned

	; Otherwise returns a pointer to a$ FROM X to Y (starting from 0)
	; if Y > len(a$), then a$ will be padded with spaces (reallocating
	; it in dynamic memory if needed). Returns pointer (HL) to resulting
	; string. NULL (0) if no memory for padding.
	;





	    push namespace core

__STRSLICE:			; Callee entry
	    pop hl			; Return ADDRESS
	    pop bc			; Last char pos
	    pop de			; 1st char pos
	    ex (sp), hl		; CALLEE. -> String start

__STRSLICE_FAST:	; __FASTCALL__ Entry
	    PROC

	    LOCAL __CONT
	    LOCAL __EMPTY
	    LOCAL __FREE_ON_EXIT

	    push hl			; Stores original HL pointer to be recovered on exit
	    ex af, af'		; Saves A register for later

	    push hl
	    call __STRLEN
	    inc bc			; Last character position + 1 (string starts from 0)
	    or a
	    sbc hl, bc		; Compares length with last char position
	    jr nc, __CONT	; If Carry => We must copy to end of string
	    add hl, bc		; Restore back original LEN(a$) in HL
	    ld b, h
	    ld c, l			; Copy to the end of str
	    ccf				; Clears Carry flag for next subtraction

__CONT:
	    ld h, b
	    ld l, c			; HL = Last char position to copy (1 for char 0, 2 for char 1, etc)
	    sbc hl, de		; HL = LEN(a$) - DE => Number of chars to copy
	    jr z, __EMPTY	; 0 Chars to copy => Return HL = 0 (NULL STR)
	    jr c, __EMPTY	; If Carry => Nothing to return (NULL STR)

	    ld b, h
	    ld c, l			; BC = Number of chars to copy
	    inc bc
	    inc bc			; +2 bytes for string length number

	    push bc
	    push de
	    call __MEM_ALLOC
	    pop de
	    pop bc
	    ld a, h
	    or l
	    jr z, __EMPTY	; Return if NULL (no memory)

	    dec bc
	    dec bc			; Number of chars to copy (Len of slice)

	    ld (hl), c
	    inc hl
	    ld (hl), b
	    inc hl			; Stores new string length

	    ex (sp), hl		; Pointer to A$ now in HL; Pointer to new string chars in Stack
	    inc hl
	    inc hl			; Skip string length
	    add hl, de		; Were to start from A$
	    pop de			; Start of new string chars
	    push de			; Stores it again
	    ldir			; Copies BC chars
	    pop de
	    dec de
	    dec de			; Points to String LEN start
	    ex de, hl		; Returns it in HL
	    jr __FREE_ON_EXIT

__EMPTY:			; Return NULL (empty) string
	    pop hl
	    ld hl, 0		; Return NULL


__FREE_ON_EXIT:
	    ex af, af'		; Recover original A register
	    ex (sp), hl		; Original HL pointer

	    or a
	    call nz, __MEM_FREE

	    pop hl			; Recover result
	    ret

	    ENDP

	    pop namespace

#line 117 "c:\NextBuildv7\Sources\Textmode\fastcallstring.bas"

	END
