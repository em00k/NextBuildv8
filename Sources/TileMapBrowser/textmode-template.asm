	org 25088
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
	call .core.__MEM_INIT
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
_x:
	DEFB 00, 00
_v:
	DEFB 00
.core.ZXBASIC_USER_DATA_END:
.core.__MAIN_PROGRAM__:
#line 16 "/NextBuildv8/Scripts/nextlib.bas"

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

#line 318 "/NextBuildv8/Scripts/nextlib.bas"
#line 425 "/NextBuildv8/Scripts/nextlib.bas"

		M_GETSETDRV			equ $89
		F_OPEN     			equ $9a
		F_CLOSE    			equ $9b
		F_READ     			equ $9d
		F_WRITE    			equ $9e
		F_SEEK     			equ $9f
		F_STAT				equ $a1
		F_SIZE				equ $ac
		FA_READ     		equ $01
		FA_APPEND   		equ $06
		FA_OVERWRITE		equ $0C
		LAYER2_ACCESS_PORT 	EQU $123B

#line 439 "/NextBuildv8/Scripts/nextlib.bas"
#line 3451 "/NextBuildv8/Scripts/nextlib.bas"

		ld iy,$5c3a
		jp endfilename

#line 3455 "/NextBuildv8/Scripts/nextlib.bas"
	call _checkints
.LABEL._filename:
#line 3459 "/NextBuildv8/Scripts/nextlib.bas"

filename:
		DEFS 256,0
endfilename:

#line 3464 "/NextBuildv8/Scripts/nextlib.bas"
#line 3466 "/NextBuildv8/Scripts/nextlib.bas"

nbtempstackstart:
		ld sp,endfilename-2

#line 3470 "/NextBuildv8/Scripts/nextlib.bas"
#line 3472 "/NextBuildv8/Scripts/nextlib.bas"



shadowlayerbit:
		db 0

#line 3478 "/NextBuildv8/Scripts/nextlib.bas"
#line 10 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"



		nextreg TURBO_CONTROL_NR_07,%11
		nextreg GLOBAL_TRANSPARENCY_NR_14,$0
		nextreg CLIP_TILEMAP_NR_1B,0
		nextreg CLIP_TILEMAP_NR_1B,159
		nextreg CLIP_TILEMAP_NR_1B,0
		nextreg CLIP_TILEMAP_NR_1B,255
		NextReg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000
		NextReg TILEMAP_CONTROL_NR_6B,%11001001
		NextReg TILEMAP_BASE_ADR_NR_6E,$44
		NextReg TILEMAP_GFX_ADR_NR_6F,$40
		NextReg PALETTE_CONTROL_NR_43,%00110000

#line 25 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"
	ld hl, 16384
	push hl
	ld hl, .LABEL._palettezx7
	push hl
	call _zx7Unpack
	ld hl, 0
	ld (_x), hl
	jp .LABEL.__LABEL0
.LABEL.__LABEL3:
	ld hl, (_x)
	srl h
	rr l
	ld a, l
	push af
	ld a, 64
	call _NextRegA
	ld hl, (_x)
	ld de, 16384
	add hl, de
	ld a, (hl)
	ld (_v), a
	push af
	ld a, 68
	call _NextRegA
	ld hl, (_x)
	ld de, 16385
	add hl, de
	ld a, (hl)
	ld (_v), a
	push af
	ld a, 68
	call _NextRegA
	ld hl, (_x)
	inc hl
	inc hl
	ld (_x), hl
.LABEL.__LABEL0:
	ld hl, 511
	ld de, (_x)
	or a
	sbc hl, de
	jp nc, .LABEL.__LABEL3
	ld hl, 16384
	push hl
	ld hl, .LABEL._fontzx7
	push hl
	call _zx7Unpack
	call _ClearTilemap
	ld a, 4
	push af
	ld hl, .LABEL.__LABEL5
	call .core.__LOADSTR
	push hl
	xor a
	push af
	push af
	call _TextBlock
.LABEL.__LABEL6:
	ld hl, 0
	call .core.__PAUSE
	jp .LABEL.__LABEL6
.LABEL._fontzx7:
#line 94 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"

		incbin ".\data\topan.fnt.zx7"
		defs 6,0

#line 98 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"
.LABEL._palettezx7:
#line 100 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"

		incbin ".\data\mm.pal.zx7"
		defs 6,0

#line 104 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"
	ld bc, 0
.core.__END_PROGRAM:
	di
	ld hl, (.core.__CALL_BACK__)
	ld sp, hl
	exx
	pop hl
	pop iy
	pop ix
	exx
	ret
_checkints:
#line 541 "/NextBuildv8/Scripts/nextlib.bas"

		PROC
		LOCAL start, intsdisable
start:


		ex 		af,af'
		ld 		a,i
		ld 		a,r
		jp 		po,intsdisable
		ld 		a,1
		ld 		(itbuff),a
		ex 		af,af'
		ret
intsdisable:
		xor 	a
		ld 		(itbuff),a
		ex 		af,af'
		ret
		ENDP
itbuff:
		db 0

#line 564 "/NextBuildv8/Scripts/nextlib.bas"
_checkints__leave:
	ret
_NextRegA:
#line 903 "/NextBuildv8/Scripts/nextlib.bas"

		PROC
		LOCAL 	reg
		ld 		(reg),a
		pop 	hl
		pop 	af
		DW $92ED
reg:
		db 		0
		push 	hl
		ENDP

#line 915 "/NextBuildv8/Scripts/nextlib.bas"
_NextRegA__leave:
	ret
_zx7Unpack:
	push ix
	ld ix, 0
	add ix, sp
#line 935 "/NextBuildv8/Scripts/nextlib.bas"





		LD E, (IX+6)
		LD D, (IX+7)
		call dzx7_turbo

		jp zx7end

dzx7_turbo:
		ld      a, $80
dzx7s_copy_byte_loop:
		ldi
dzx7s_main_loop:
		call    dzx7s_next_bit
		jr      nc, dzx7s_copy_byte_loop


		push    de
		ld      bc, 0
		ld      d, b
dzx7s_len_size_loop:
		inc     d
		call    dzx7s_next_bit
		jr      nc, dzx7s_len_size_loop


dzx7s_len_value_loop:
		call    nc, dzx7s_next_bit
		rl      c
		rl      b
		jr      c, dzx7s_exit
		dec     d
		jr      nz, dzx7s_len_value_loop
		inc     bc


		ld      e, (hl)
		inc     hl
		defb    $cb, $33
		jr      nc, dzx7s_offset_end
		ld      d, $10
dzx7s_rld_next_bit:
		call    dzx7s_next_bit
		rl      d
		jr      nc, dzx7s_rld_next_bit
		inc     d
		srl	d
dzx7s_offset_end:
		rr      e


		ex      (sp), hl
		push    hl
		sbc     hl, de
		pop     de
		ldir
dzx7s_exit:
		pop     hl
		jr      nc, dzx7s_main_loop
dzx7s_next_bit:
		add     a, a
		ret     nz
		ld      a, (hl)
		inc     hl
		rla
		ret
zx7end:



#line 1008 "/NextBuildv8/Scripts/nextlib.bas"
_zx7Unpack__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	ex (sp), hl
	exx
	ret
_TextBlock:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	push hl
	inc sp
	ld a, (ix+5)
	ld (ix-1), a
	ld a, (ix+7)
	ld (ix-2), a
	ld l, (ix+8)
	ld h, (ix+9)
	call .core.__STRLEN
	ex de, hl
	ld hl, 0
	or a
	sbc hl, de
	jp nc, _TextBlock__leave
	ld hl, 0
	ld (_x), hl
	jp .LABEL.__LABEL10
.LABEL.__LABEL13:
	ld l, (ix+8)
	ld h, (ix+9)
	push hl
	ld hl, (_x)
	push hl
	push hl
	xor a
	call .core.__STRSLICE
	ld a, 1
	call .core.__ASC
	ld (ix-3), a
	ld a, (ix+11)
	push af
	ld a, (ix-3)
	push af
	ld a, (ix-2)
	push af
	ld a, (ix-1)
	call _UpdateMap
	inc (ix-1)
	ld a, (ix-1)
	sub 80
	jp nz, .LABEL.__LABEL14
	inc (ix-2)
	ld (ix-1), 0
.LABEL.__LABEL14:
	ld hl, (_x)
	inc hl
	ld (_x), hl
.LABEL.__LABEL10:
	ld l, (ix+8)
	ld h, (ix+9)
	call .core.__STRLEN
	dec hl
	ld de, (_x)
	or a
	sbc hl, de
	jp nc, .LABEL.__LABEL13
_TextBlock__leave:
	ex af, af'
	exx
	ld l, (ix+8)
	ld h, (ix+9)
	call .core.__MEM_FREE
	ex af, af'
	exx
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	pop bc
	pop bc
	ex (sp), hl
	exx
	ret
_ClearTilemap:
#line 67 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"

		ld hl,$4400
		ld de,$4401
		ld bc,2560*2
		ld (hl),0
		ldir

#line 74 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"
_ClearTilemap__leave:
	ret
_UpdateMap:
#line 77 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"


	exx : pop hl : exx
	ld hl,$4400 : add a,a :
		DB $ED,$31

#line 81

	pop de : ld a,e : ld e,160 :
		DB $ED,$30

#line 83
	add hl,de : pop af
	ld (hl),a : inc hl : 	pop af
		and %01111111
		rlca
		ld (hl),a
outme:
	exx : push hl : exx

#line 97 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"
_UpdateMap__leave:
	ret
.LABEL.__LABEL5:
	DEFW 0004h
	DEFB 54h
	DEFB 45h
	DEFB 53h
	DEFB 54h
	;; --- end of user code ---
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/asc.asm"
	; Returns the ascii code for the given str
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/free.asm"
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

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/heapinit.asm"
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

#line 69 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/free.asm"

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

#line 3 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/asc.asm"

	    push namespace core

__ASC:
	    PROC
	    LOCAL __ASC_END

	    ex af, af'	; Saves free_mem flag

	    ld a, h
	    or l
	    ret z		; NULL? return

	    ld c, (hl)
	    inc hl
	    ld b, (hl)

	    ld a, b
	    or c
	    jr z, __ASC_END		; No length? return

	    inc hl
	    ld a, (hl)
	    dec hl

__ASC_END:
	    dec hl
	    ex af, af'
	    or a
	    call nz, __MEM_FREE	; Free memory if needed

	    ex af, af'	; Recover result

	    ret
	    ENDP

	    pop namespace
#line 108 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/loadstr.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/alloc.asm"
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

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/error.asm"
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
#line 69 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/alloc.asm"



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
#line 113 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/alloc.asm"
	    ret z ; NULL
#line 115 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/alloc.asm"
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

#line 2 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/loadstr.asm"

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
#line 110 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/pause.asm"
	; The PAUSE statement (Calling the ROM)
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/zxnext_utils.asm"

	        push namespace core

	        PROC
__zxnbackup_sysvar_bank:
	        push    af
	        push    bc
	        ld	bc,$243B                        					; 10
	        ld	a, $52 												; 7
	        out 	(c), a 												; 12 register select
	        inc 	b 													; 4 bc = TBBLUE_REGISTER_ACCESS_P_253B
	        in	a, (c)												; 12 get bank value
	        ld 	(__zxnbackup_sysvar_bank_restore+3),a 									; 13
	        pop     bc
	        pop     af
	        nextreg     $52, $0a
	        nextreg     $50, $ff
	        nextreg     $51, $ff
		ret

__zxnbackup_sysvar_bank_restore:
	        nextreg $52, $0a
	        ret
	        ENDP

	        pop namespace
#line 3 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/pause.asm"

	    push namespace core

__PAUSE:
	    ; call        __zxnbackup_sysvar_bank
	    ; ld b, h
	    ; ld c, l
	    ; call 1F3Dh  ; PAUSE_1
	    ; jp __zxnbackup_sysvar_bank_restore

	    PROC
	    LOCAL __pause_loop
	            ld      h, l
    __pause_loop:
				ld 		a,$1f       ; VIDEO_LINE_LSB_NR_1F
				ld 		bc,$243b    ; TBBLUE_REGISTER_SELECT_P_243B
				out 	(c),a
				inc 	b
				in 		a,(c)
				or      a				; line to wait for
				jr 		nz,__pause_loop
				dec 	h

				jr 		nz,__pause_loop
	            ret
	    ENDP

	    pop namespace
#line 111 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/strlen.asm"
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


#line 112 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/strslice.asm"
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

#line 113 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\textmode-template.bas"

	END
