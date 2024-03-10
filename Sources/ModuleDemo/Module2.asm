	org 24576
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
	jp .core.__MAIN_PROGRAM__
.core.__CALL_BACK__:
	DEFW 0
.core.ZXBASIC_USER_DATA:
	; Defines HEAP SIZE
.core.ZXBASIC_HEAP_SIZE EQU 1024
.core.ZXBASIC_MEM_HEAP:
	DEFS 1024
	; Defines USER DATA Length in bytes
.core.ZXBASIC_USER_DATA_LEN EQU .core.ZXBASIC_USER_DATA_END - .core.ZXBASIC_USER_DATA
	.core.__LABEL__.ZXBASIC_USER_DATA_LEN EQU .core.ZXBASIC_USER_DATA_LEN
	.core.__LABEL__.ZXBASIC_USER_DATA EQU .core.ZXBASIC_USER_DATA
_mbutt:
	DEFB 00
_mox:
	DEFB 00
_moy:
	DEFB 00
_spry:
	DEFB 00
_sprx:
	DEFB 00, 00
	_VarLoadModule EQU 16384
	_VarLoadModuleParameter1 EQU 16385
	_VarLoadModuleParameter2 EQU 16386
	_VarLifes EQU 16387
	_VarPoints EQU 16388
	_VarPosX EQU 16390
	_VarPosY EQU 16391
	_Mouse EQU 16393
	_VarLevel EQU 16492
_common:
	DEFB 00, 00
.core.ZXBASIC_USER_DATA_END:
.core.__MAIN_PROGRAM__:
	call _Init
	call _Main
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
#line 420 "/NextBuildv8/Scripts/nextlib.bas"

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

#line 434 "/NextBuildv8/Scripts/nextlib.bas"
#line 3246 "/NextBuildv8/Scripts/nextlib.bas"

		ld iy,$5c3a
		jp endfilename

#line 3250 "/NextBuildv8/Scripts/nextlib.bas"
	call _checkints
.LABEL._filename:
#line 3254 "/NextBuildv8/Scripts/nextlib.bas"

filename:
		DEFS 256,0
endfilename:

#line 3259 "/NextBuildv8/Scripts/nextlib.bas"
#line 3267 "/NextBuildv8/Scripts/nextlib.bas"



shadowlayerbit:
		db 0

#line 3273 "/NextBuildv8/Scripts/nextlib.bas"
#line 11 "/NextBuildv8/Scripts/nextlib_ints.bas"


		afxChDesc       EQU     $fd00
		sfxenablednl    EQU     $fd40
		bankbuffersplayernl EQU     $fd60
		di

#line 18 "/NextBuildv8/Scripts/nextlib_ints.bas"
	ld de, .LABEL.__LABEL0
	ld hl, _common
	call .core.__STORE_STR
#line 39 "c://NextBuildv8//Sources//ModuleDemo/Common.bas"

		Mouse		EQU ._Mouse

#line 42 "c://NextBuildv8//Sources//ModuleDemo/Common.bas"
#line 259 "c://NextBuildv8//Sources//ModuleDemo/Common.bas"

		di

#line 262 "c://NextBuildv8//Sources//ModuleDemo/Common.bas"
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
	ei
	ret
_checkints:
#line 536 "/NextBuildv8/Scripts/nextlib.bas"

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

#line 559 "/NextBuildv8/Scripts/nextlib.bas"
_checkints__leave:
	ret
_InitSprites2:
#line 1039 "/NextBuildv8/Scripts/nextlib.bas"

		PROC
		LOCAL spr_nobank, spr_address, sploop, sp_out


		ld      (spr_address+1), hl
		exx
		pop     hl
		exx

		ld      d, a

		xor 	a
		ld 		bc, SPRITE_STATUS_SLOT_SELECT_P_303B
		out 	(c), a


		inc     sp
		inc     sp
		pop     af
		or      a
		jr      z,spr_nobank
		nextreg $50,a
		inc     a
		nextreg $51,a

spr_nobank:

		ld 		b,d

spr_address:
		ld      hl,0

sploop:

		push 	bc
		ld 		bc,$005b
		otir
		pop 	bc
		djnz 	sploop

		nextreg $50, $FF
		nextreg $51, $FF

sp_out:
		exx
		push    hl
		exx

		ENDP


#line 1091 "/NextBuildv8/Scripts/nextlib.bas"
_InitSprites2__leave:
	ret
_UpdateSprite:
	push ix
	ld ix, 0
	add ix, sp
#line 1142 "/NextBuildv8/Scripts/nextlib.bas"






		ld a,(IX+9)
		ld bc, $303b

		out (c), a

		ld bc, $57
		ld a,(IX+4)
		out (c), a

		ld a,(IX+7)
		out (c), a

		ld d,(IX+13)


		ld a,(IX+5)
		and 1
		or d
		out (c), a


		ld a,(IX+11)
		or 192

		out (c), a
		ld a,(IX+15)
		out (c), a


#line 1177 "/NextBuildv8/Scripts/nextlib.bas"
_UpdateSprite__leave:
	exx
	ld hl, 12
__EXIT_FUNCTION:
	ld sp, ix
	pop ix
	pop de
	add hl, sp
	ld sp, hl
	push de
	exx
	ret
_L2Text:
	push ix
	ld ix, 0
	add ix, sp
#line 2506 "/NextBuildv8/Scripts/nextlib.bas"

		PROC

		LOCAL plotTilesLoop2, printloop, inloop, addspace, addspace2



#line 2517 "/NextBuildv8/Scripts/nextlib.bas"
		ld a,$50
		ld bc,$243B
		out(c),a
		inc b
		in a,(c)
		ld (textfontdone+1),a

	ld e,(IX+5) : ld d,(IX+7)
	ld l,(IX+8) : ld h,(IX+9)
	ld a,(hl) : ld b,a
	inc hl : inc hl
	ld a,(IX+11) : nextreg $50,a

printloop:
		push bc
		ld a,(hl)
	cp 32 : jp z,addspace
	cp 33 : jp z,addspace2
		sub 32
inloop:
	push hl : push de
		ex de,hl
		call PlotTextTile
	pop de : pop hl
		inc hl
		inc e
		pop bc
		djnz printloop
		jp textfontdone
addspace:
		ld a,0
		jp inloop
addspace2:
		ld a,0
		jp inloop

PlotTextTile:
	ld d,64 : ld e,a

		DB $ED,$30

#line 2556
	ld a,%00000000 : or d
	ex de,hl	 : ld h,a : ld a,e
	rlca : rlca : rlca
	ld e,a : ld a,d
	rlca : rlca : rlca
	ld d,a : and 192 : or 3
		ld bc,LAYER2_ACCESS_PORT
	out (c),a : ld a,d : and 63
	ld d,a : ld bc,$800
		push de
		ld a,(IX+13)

plotTilesLoop2:

		push bc
		ld bc,8
		push de
		ldirx
		pop de
		inc d
		pop bc
		djnz plotTilesLoop2






		pop de
		ret
textfontdone:
	ld a,$0a : nextreg $50,a
endofl2text:
	ld a,2 : ld bc,LAYER2_ACCESS_PORT
		out (c),a
#line 2594 "/NextBuildv8/Scripts/nextlib.bas"
		ENDP


#line 2595 "/NextBuildv8/Scripts/nextlib.bas"
_L2Text__leave:
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
	pop bc
	ex (sp), hl
	exx
	ret
_CLS256:
	push ix
	ld ix, 0
	add ix, sp
#line 2856 "/NextBuildv8/Scripts/nextlib.bas"



Cls256:
#line 2864 "/NextBuildv8/Scripts/nextlib.bas"
		push	bc
		push	de
		push	hl

		ld bc,$123b
		in a,(c)
		push af
		xor a
		out	(c),a


		ld a,(IX+5)

		ld	d,a
		ld	e,3
		ld	a,1

		ld      bc, $123b
LoadAll:
		out	(c),a
		push	af

		ld	hl,0
ClearLoop:
		ld	(hl),d
		inc	l
		jr	nz,ClearLoop
		inc	h
		ld	a,h
		cp	$40
		jr	nz,ClearLoop

		pop	af
		add	a,$40
		dec	e
		jr	nz,LoadAll

		ld  bc, $123b

		pop af

		out	(c),a

		pop	hl
		pop	de
		pop	bc
#line 2913 "/NextBuildv8/Scripts/nextlib.bas"

#line 2909 "/NextBuildv8/Scripts/nextlib.bas"
_CLS256__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_WaitRetrace2:
#line 3181 "/NextBuildv8/Scripts/nextlib.bas"

		PROC

		LOCAL readline
	pop hl : exx
		ld d,0
		ld e,a
readline:
		ld bc,$243b
		ld a,$1e
		out (c),a
		inc b
		in a,(c)
		ld h,a
		dec b
		ld a,$1f
		out (c),a
		inc b
		in a,(c)
		ld  l,a
		and a
		sbc hl,de
		add hl,de
		jr nz,readline
	exx : push hl
		ENDP

#line 3208 "/NextBuildv8/Scripts/nextlib.bas"
_WaitRetrace2__leave:
	ret
_NStr:
#line 153 "c://NextBuildv8//Sources//ModuleDemo/Common.bas"





		PROC
		LOCAL Na1, Na2, skpinc, nst_finished

		ld 		hl,.LABEL._filename
		ld		d, 0
		push 	hl
		call 	CharToAsc
		ld 		(hl), d
		pop 	hl

		ld		a,  3
		ld 		(hl), a
		inc 	hl
		ld 		(hl), d
		dec 	hl

		ld		de, _common
		ex 		de, hl
		call    .core.__STORE_STR
		jp 		nst_finished

CharToAsc:


		ld 		hl,.LABEL._filename+2
		ld		c, -100
		call	Na1
		ld		c, -10
		call	Na1
		ld		c, -1

Na1:

		ld		b, '0'-1

Na2:

		inc		b
		add		a, c
		jr		c, Na2
		sub		c
		push 	af
		ld		a, b

		ld 		(hl), a
		inc 	hl

skpinc:

		pop 	af

		ret

nst_finished:

		ENDP


#line 216 "c://NextBuildv8//Sources//ModuleDemo/Common.bas"
	ld hl, (_common)
	call .core.__LOADSTR
_NStr__leave:
	ret
_Init:
#line 33 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"

		nextreg SPRITE_CONTROL_NR_15,%00000001
		di


#line 38 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"
_Init__leave:
	ret
_Main:
	xor a
	push af
	call _CLS256
	xor a
	push af
	ld a, 29
	push af
	ld hl, .LABEL.__LABEL1
	call .core.__LOADSTR
	push hl
	xor a
	push af
	push af
	call _L2Text
	xor a
	push af
	ld a, 29
	push af
	ld a, (_mox)
	call _NStr
	ex de, hl
	ld hl, .LABEL.__LABEL2
	push de
	call .core.__ADDSTR
	ex (sp), hl
	call .core.__MEM_FREE
	pop hl
	push hl
	ld a, (_moy)
	call _NStr
	ex de, hl
	pop hl
	push hl
	push de
	call .core.__ADDSTR
	pop de
	ex (sp), hl
	push de
	call .core.__MEM_FREE
	pop hl
	call .core.__MEM_FREE
	pop hl
	push hl
	ld a, 1
	push af
	xor a
	push af
	call _L2Text
	ld a, 26
	push af
	ld hl, 0
	push hl
	ld a, 16
	call _InitSprites2
.LABEL.__LABEL3:
#line 59 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"

		nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,255

#line 62 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"
	call _ProcessMouse
	ld a, ((_Mouse) + (1))
	ld (_mox), a
	ld a, ((_Mouse) + (2))
	ld (_moy), a
	ld a, (_Mouse)
	ld (_mbutt), a
	ld a, (_mox)
	ld l, a
	ld h, 0
	ld de, 32
	add hl, de
	ld (_sprx), hl
	ld a, (_moy)
	add a, 32
	ld (_spry), a
	xor a
	push af
	push af
	ld a, 3
	push af
	xor a
	push af
	ld a, (_spry)
	push af
	push hl
	call _UpdateSprite
	ld a, 1
	push af
	ld a, 29
	push af
	ld a, (_mox)
	srl a
	srl a
	srl a
	call _NStr
	push hl
	ld a, (_moy)
	srl a
	srl a
	srl a
	call _NStr
	ex de, hl
	pop hl
	push hl
	push de
	call .core.__ADDSTR
	pop de
	ex (sp), hl
	push de
	call .core.__MEM_FREE
	pop hl
	call .core.__MEM_FREE
	pop hl
	push hl
	xor a
	push af
	ld a, 6
	push af
	call _L2Text
	ld a, 1
	push af
	ld a, 29
	push af
	ld a, (_mbutt)
	and 3
	call _NStr
	push hl
	ld a, 1
	push af
	ld a, 6
	push af
	call _L2Text
#line 70 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"

		nextreg TRANSPARENCY_FALLBACK_COL_NR_4A,0

#line 73 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"
	ld a, 1
	call _WaitRetrace2
	ld a, (_mbutt)
	and 3
	sub 2
	jp nz, .LABEL.__LABEL3
	ld a, 1
	ld (_VarLoadModule), a
	jp _Main__leave
.LABEL.__LABEL6:
	jp .LABEL.__LABEL3
_Main__leave:
	ret
_ProcessMouse:
#line 109 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"


		ld		de,(nmousex)
		ld 		(omousex),de
		ld		a,(mouseb)
		ld 		(omouseb),a

		call 	getmouse
		ld 		(mouseb),a
		ld 		(nmousex),hl

		ld 		a,l
		sub 	e
		ld 		e,a
		ld 		a,h
		sub 	d
		ld 		d,a
		ld 		(dmousex),de

		ld 		d,0
		bit 	7,e
		jr 		z,bl
		dec 	d
bl:
		ld 		hl,(rmousex)
		add 	hl,de
		ld 		bc,4*256
		call 	rangehl
		ld 		(rmousex),hl
		sra  	h
		rr 		l
		sra 	h
		rr 		l
		ld 		a,l
		ld 		(mousex),a
		ld 		de,(dmousey)
		ld 		d,0
		bit 	7,e
		jr 		z,bd
		dec	 	d
bd:
		ld 		hl,(rmousey)
		add 	hl,de
		ld 		bc,4*192+64
		call 	rangehl
		ld 		(rmousey),hl
		sra  	h
		rr 		l
		sra 	h
		rr 		l
		ld 		a,l
		ld 		(mousey),a

		ld 		a,(mouseb)
		ld 		(Mouse),a
		ld 		a,(mousex)
		ld 		(Mouse+1),a
		ld 		a,(mousey)
		ld 		(Mouse+2),a

		ret

getmouse:
		ld		bc,64479
		in 		a,(c)
		ld 		l,a
		ld		bc,65503
		in 		a,(c)
		cpl
		ld 		h,a
		ld 		(nmousex),hl
		ld		bc,64223
		in 		a,(c)
		ld 		(mouseb),a
		ret

rangehl:

		bit 	7,h
		jr 		nz,mi
		or 		a
		push 	hl
		sbc	 	hl,bc
		pop 	hl
		ret 	c
		ld		h,b
		ld 		l,c
		dec 	hl
		ret

mi:
		ld 		hl,0
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



#line 232 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"
_ProcessMouse__leave:
	ret
.LABEL.__LABEL0:
	DEFW 0001h
	DEFB 20h
.LABEL.__LABEL1:
	DEFW 0008h
	DEFB 4Dh
	DEFB 4Fh
	DEFB 44h
	DEFB 55h
	DEFB 4Ch
	DEFB 45h
	DEFB 20h
	DEFB 32h
.LABEL.__LABEL2:
	DEFW 0006h
	DEFB 4Dh
	DEFB 4Fh
	DEFB 55h
	DEFB 53h
	DEFB 45h
	DEFB 20h
	;; --- end of user code ---
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/free.asm"
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

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/heapinit.asm"
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

#line 69 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/free.asm"

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

#line 258 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/loadstr.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/alloc.asm"
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

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/error.asm"
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
#line 69 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/alloc.asm"



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
#line 113 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/alloc.asm"
	    ret z ; NULL
#line 115 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/alloc.asm"
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

#line 2 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/loadstr.asm"

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
#line 259 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/storestr.asm"
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


#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/strcpy.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/realloc.asm"
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

#line 2 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/strcpy.asm"

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

#line 14 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/storestr.asm"

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

#line 260 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/strcat.asm"

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/strlen.asm"
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


#line 3 "C:/NextBuildv8/zxbasic/src/arch/zx48k/library-asm/strcat.asm"

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

#line 261 "c:\\NextBuildv8\\Sources\\ModuleDemo\\Module2.bas"

	END
