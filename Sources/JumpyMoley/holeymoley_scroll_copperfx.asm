	org 28000
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
	jp .core.__MAIN_PROGRAM__
.core.__CALL_BACK__:
	DEFW 0
.core.ZXBASIC_USER_DATA:
	; Defines USER DATA Length in bytes
.core.ZXBASIC_USER_DATA_LEN EQU .core.ZXBASIC_USER_DATA_END - .core.ZXBASIC_USER_DATA
	.core.__LABEL__.ZXBASIC_USER_DATA_LEN EQU .core.ZXBASIC_USER_DATA_LEN
	.core.__LABEL__.ZXBASIC_USER_DATA EQU .core.ZXBASIC_USER_DATA
_plx:
	DEFB 00, 00
_startx:
	DEFB 00, 00
_ply:
	DEFB 00
_starty:
	DEFB 00
_pldx:
	DEFB 00
_pldy:
	DEFB 00
_playersprite:
	DEFB 00h
_oldpx:
	DEFB 00, 00
_oldpy:
	DEFB 00
_attr3:
	DEFB 00
_nojump:
	DEFB 00
_diamonds:
	DEFB 00
_globalframe:
	DEFB 00
_globalframetimer:
	DEFB 00
_level:
	DEFB 00h
_maxlevel:
	DEFB 04h
_velocity:
	DEFB 00, 00, 00, 00
_mapoffset:
	DEFB 00, 00
_jumptrigger:
	DEFB 00
_jumpposition:
	DEFB 00
_playerframe:
	DEFB 00
_hudtimer:
	DEFB 00
_mapbuffer:
	DEFB 00, 00
_int_done:
	DEFB 00
_lineno:
	DEFB 00
_scrolly:
	DEFB 00
_scrolltrigger:
	DEFB 00
_hvel:
	DEFB 00, 00, 00, 00
_pleft:
	DEFB 00
_pright:
	DEFB 00
_jumpvalue:
	DEFB 00
_playeranim:
	DEFB 00
_lastframe:
	DEFB 00
_floor:
	DEFB 00
_kemp:
	DEFB 00
_sword:
	DEFB 00h
_ssize:
	DEFB 0Eh
_swordframe:
	DEFB 00h
_swordkeypressed:
	DEFB 00
_ospraddress:
	DEFB 00, 00
_dead:
	DEFB 00
_t:
	DEFB 00
_fx_ow:
	DEFB 00
_wait:
	DEFB 00
_aSprites:
	DEFW .LABEL.__LABEL333
_aSprites.__DATA__.__PTR__:
	DEFW _aSprites.__DATA__
_aSprites.__DATA__:
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
	DEFB 00h
.LABEL.__LABEL333:
	DEFW 0001h
	DEFW 0008h
	DEFB 01h
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
		DEFS 1024,0
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
#line 14 "/NextBuildv8/Scripts/nextlib_ints.bas"





		afxChDesc       	EQU     $fd00
		sfxenablednl    	EQU     $fd40
		currentmusicbanknl	EQU 	$fd44
		currentsfxbank		EQU 	$fd48
		bankbuffersplayernl EQU     $fd50
		sampletoplay		EQU 	$fd58
		ayfxbankinplaycode	EQU 	$fd3e

#line 27 "/NextBuildv8/Scripts/nextlib_ints.bas"
	xor a
	call .core.PAPER
	xor a
	call .core.BORDER
	xor a
	call .core.INK
	call .core.CLS
#line 16 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		nextreg SPRITE_CONTROL_NR_15,%001_010_11

		nextreg TURBO_CONTROL_NR_07,3
		nextreg PERIPHERAL_3_NR_08,254
		nextreg ULA_CONTROL_NR_68,%10101000
		nextreg LAYER2_CONTROL_NR_70,%00010000
		nextreg LAYER2_RAM_BANK_NR_12,12


		di

#line 28 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	ld a, 43
	push af
	ld hl, 0
	push hl
	ld a, 64
	call _InitSprites2
	call _InitCopperAudio
	ld a, 4
	call _PlayCopperSample
	call _SetCopperAudio
	ld a, 38
	call _InitSFX
	ld hl, 0
	push hl
	ld a, 56
	push af
	ld a, 37
	call _InitMusic
	call _SetUpIM
	ld hl, _aSprites.__DATA__
	ld (_ospraddress), hl
	call _ShowIntroScreen__leave
	xor a
	push af
	call _CLS256
	ld a, 1
	call _ShowLayer2
	ld a, 255
	push af
	xor a
	push af
	ld a, 255
	push af
	xor a
	push af
	call _ClipLayer2
	ld a, 9
	push af
	ld a, 25
	push af
	ld a, 24
	call _CopyToBanks
	ld a, 1
	push af
	ld a, 54
	push af
	ld a, 24
	call _CopyToBanks
	ld a, 96
	push af
	ld a, 64
	call _SetupTileHW
#line 142 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"


		nextreg TILEMAP_CONTROL_NR_6B,%10100001


#line 147 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
.LABEL._Restart:
	xor a
	ld (_int_done), a
	ld (_dead), a
	ld hl, (_mapoffset)
	ld a, l
	ld (_level), a
	push af
	call _GetLevel
	ld hl, 32
	ld (_plx), hl
	ld a, 64
	ld (_ply), a
#line 156 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	: ld a,1 : ld (sfxenablednl),a :
#line 157 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
.LABEL.__LABEL0:
	ld a, (_int_done)
	dec a
	jp nz, .LABEL.__LABEL3
#line 162 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



#line 165 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	call _ReadKeys
#line 167 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



#line 170 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	call _CheckCollision
#line 173 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



#line 176 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	ld a, (_dead)
	or a
	jp nz, .LABEL.__LABEL4
	call _UpdatePlayer
	jp .LABEL.__LABEL5
.LABEL.__LABEL4:
	ld a, (_dead)
	dec a
	jp nz, .LABEL.__LABEL6
	xor a
	ld (_playeranim), a
	ld a, 4
	ld (_playersprite), a
	xor a
	ld (_dead), a
	jp .LABEL.__LABEL5
.LABEL.__LABEL6:
	ld a, (_dead)
	sub 2
	jp nz, .LABEL.__LABEL8
	ld hl, _t
	inc (hl)
	ld a, (_t)
	sub 255
	jp nz, .LABEL.__LABEL5
	xor a
	ld (_dead), a
	ld a, (_lastframe)
	ld (_playersprite), a
.LABEL.__LABEL11:
	jp .LABEL.__LABEL5
.LABEL.__LABEL8:
	ld a, (_dead)
	sub 3
	jp nz, .LABEL.__LABEL12
	ld a, 255
	ld (_wait), a
	ld a, 4
	ld (_dead), a
	jp .LABEL.__LABEL5
.LABEL.__LABEL12:
	ld a, (_dead)
	sub 4
	jp nz, .LABEL.__LABEL5
	ld hl, _wait
	dec (hl)
	ld a, (_wait)
	or a
	jp nz, .LABEL.__LABEL5
	xor a
	ld (_dead), a
	jp .LABEL._Restart
.LABEL.__LABEL5:
#line 208 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



#line 211 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	call _UpdateSprites
	call _processthrows
#line 218 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



#line 221 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	xor a
	ld (_int_done), a
.LABEL.__LABEL3:
#line 223 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



#line 226 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	jp .LABEL.__LABEL0
.LABEL._ThrowData:
#line 658 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

ThrowData:


		db 0,0,0,0,0,0
		db 0,0,0,0,0,0
		db 0,0,0,0,0,0
		db 0,0,0,0,0,0

#line 667 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
.LABEL._ThrowPositions:
#line 669 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		db 1,-1
		db 1,-2
		db 1,-3
		db 1,0
		db 1,1
		db 1,2
		db 1,3
		db 1,6
		db 1,6
		db 1,6
		db 1,6
		db 1,6
		db 1,6
		db 1,6
		db 1,6



#line 688 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
.LABEL._jumptable:
#line 872 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



		db -9,-7,-6,-5,-3,-2,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0

#line 877 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 1014 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		palbuffdiamond
		defs 32,0

#line 1018 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
.LABEL._map:
#line 1428 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

map:




		defs 1280,0


#line 1437 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
.LABEL._palbuff:
#line 1445 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

palbuff:



		incbin "./data/level1/leveltest.nxp"

#line 1452 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
.LABEL._copper_sample_table:
#line 2048 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

copper_sample_table:









		dw $3901,0,4417
		dw $3901,4417,7516
		dw $3a01,11933-8192,7086
		dw $3b01,2635,3238
		dw $3b01,5873,11000



#line 2067 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
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
_ShowLayer2:
#line 611 "/NextBuildv8/Scripts/nextlib.bas"

		PROC
		LOCAL disable
		or 		a
		jr 		z,disable
		nextreg $69,%10000000
		ret
disable:
		nextreg $69,0
		ENDP

#line 622 "/NextBuildv8/Scripts/nextlib.bas"
_ShowLayer2__leave:
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
_InitSprites2:
#line 1048 "/NextBuildv8/Scripts/nextlib.bas"

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


#line 1100 "/NextBuildv8/Scripts/nextlib.bas"
_InitSprites2__leave:
	ret
_RemoveSprite:
	push ix
	ld ix, 0
	add ix, sp
#line 1105 "/NextBuildv8/Scripts/nextlib.bas"


		push 	bc
		ld 		a,(IX+5)
		ld 		bc, $303b
		out 	(c), a
		ld 		bc, $57



		xor 	a
		out 	(c), a
		out 	(c), a
		out 	(c), a
		ld 		a,(IX+7)
		out 	(c), a
		pop 	bc


#line 1124 "/NextBuildv8/Scripts/nextlib.bas"
_RemoveSprite__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	ex (sp), hl
	exx
	ret
_UpdateSprite:
	push ix
	ld ix, 0
	add ix, sp
#line 1151 "/NextBuildv8/Scripts/nextlib.bas"






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


#line 1186 "/NextBuildv8/Scripts/nextlib.bas"
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
_CLS256:
	push ix
	ld ix, 0
	add ix, sp
#line 3034 "/NextBuildv8/Scripts/nextlib.bas"



Cls256:
#line 3042 "/NextBuildv8/Scripts/nextlib.bas"
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
		ld	a,2
		out	(c),a
		nextreg $50,$ff
		nextreg $51,$ff

		pop	hl
		pop	de
		pop	bc
#line 3093 "/NextBuildv8/Scripts/nextlib.bas"

#line 3089 "/NextBuildv8/Scripts/nextlib.bas"
_CLS256__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_ClipLayer2:
	push ix
	ld ix, 0
	add ix, sp
#line 3101 "/NextBuildv8/Scripts/nextlib.bas"

		ld a,(IX+5)
	DW $92ED : DB 24
		ld a,(IX+7)
	DW $92ED : DB 24
		ld a,(IX+9)
	DW $92ED : DB 24
		ld a,(IX+11)
	DW $92ED : DB 24

#line 3111 "/NextBuildv8/Scripts/nextlib.bas"
_ClipLayer2__leave:
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
_ClipTile:
	push ix
	ld ix, 0
	add ix, sp
#line 3133 "/NextBuildv8/Scripts/nextlib.bas"

		ld a,(IX+5)
	DW $92ED : DB 27
		ld a,(IX+7)
	DW $92ED : DB 27
		ld a,(IX+9)
	DW $92ED : DB 27
		ld a,(IX+11)
	DW $92ED : DB 27

#line 3143 "/NextBuildv8/Scripts/nextlib.bas"
_ClipTile__leave:
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
_ClipSprite:
	push ix
	ld ix, 0
	add ix, sp
#line 3149 "/NextBuildv8/Scripts/nextlib.bas"

		ld a,(IX+5)
	DW $92ED : DB $19
		ld a,(IX+7)
	DW $92ED : DB $19
		ld a,(IX+9)
	DW $92ED : DB $19
		ld a,(IX+11)
	DW $92ED : DB $19

#line 3159 "/NextBuildv8/Scripts/nextlib.bas"
_ClipSprite__leave:
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
_WaitRetrace:
	push ix
	ld ix, 0
	add ix, sp
#line 3341 "/NextBuildv8/Scripts/nextlib.bas"

		PROC
		LOCAL readline
readline:
		ld 		a,VIDEO_LINE_LSB_NR_1F
		ld 		bc,TBBLUE_REGISTER_SELECT_P_243B
		out 	(c),a
		inc 	b
		in 		a,(c)
		cp 		250
		jr 		nz,readline
		dec 	hl
		ld 		a,h
		or 		l
		jr 		nz,readline
		ENDP

#line 3358 "/NextBuildv8/Scripts/nextlib.bas"
_WaitRetrace__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_PlaySFX:
#line 60 "/NextBuildv8/Scripts/nextlib_ints.bas"

		ld (sampletoplay),a

#line 63 "/NextBuildv8/Scripts/nextlib_ints.bas"
_PlaySFX__leave:
	ret
_InitMusic:
#line 69 "/NextBuildv8/Scripts/nextlib_ints.bas"



		exx
		pop     hl
		exx
		call    _checkints
		di

		ld      (aybank1+1),a
		pop     af
		ld      (ayseta+1),a
		pop     de
		ld      (aysetde+1),de


		db $3e,$52,$01,$3b,$24,$ed,$79,$04,$ed,$78
#line 85
		ld 		(exitplayerinit+3),a
		ld 		(exitplayernl+3),a

		db $3e,$50,$01,$3b,$24,$ed,$79,$04,$ed,$78
#line 88
		ld		(exitplayerinit+7),a
		ld		(exitplayernl+7),a

		db $3e,$51,$01,$3b,$24,$ed,$79,$04,$ed,$78
#line 91
		ld 		(exitplayerinit+11),a
		ld 		(exitplayernl+11),a

aybank1:
		ld      a,0
		nextreg $52,a
		ld      (bankbuffersplayernl),a
ayseta:
		ld      a, 0
		ld      (bankbuffersplayernl+1),a
		nextreg $50,a
		inc     a
		nextreg $51,a
aysetde:
		ld      de,00000
		ld      hl,$0000
		add     hl,de
		push    ix
		call    $4003
		pop     ix

exitplayerinit:
		nextreg $52,$0a
		nextreg $50,$00
		nextreg $51,$01

ayrepairestack:



	exx : push hl : exx



	ld a,(.itbuff) : or a : jr z,$+3 : ei
#line 125
		ret

ayplayerstack:
		ds      128,0

playmusicnl:



		db $3e,$52,$01,$3b,$24,$ed,$79,$04,$ed,$78
#line 134
		ld      (exitplayernl+3),a

		ld      hl,bankbuffersplayernl
		ld      a,(hl)
		nextreg $52,a
		inc     hl
		ld      a,(hl)
		nextreg $50,a
		inc     a
		nextreg $51,a

		ld      a,(sfxenablednl+1)
		cp      2
		jr      z,mustplayernl

		ld      a,(sfxenablednl+1)
		cp      3
		jr      z,re_init_music


		push    ix
		call    $4005
		pop ix


exitplayernl:
		nextreg $52,$0a
		nextreg $50,$00
		nextreg $51,$01

ayrepairestack2:

		ret

re_init_music:
		ld		a, 1
		ld      (sfxenablednl+1),a
		ld		hl,0000
		call	$4003
		jp      exitplayernl

mustplayernl:
		xor     a
		ld      (sfxenablednl+1),a
		call    $4008
		jp      exitplayernl


#line 192 "/NextBuildv8/Scripts/nextlib_ints.bas"
_InitMusic__leave:
	ret
_SetUpIM:
#line 192 "/NextBuildv8/Scripts/nextlib_ints.bas"


	exx : pop hl : exx

		di

		ld      hl,$fe00
		ld      de,$fe01
		ld      bc,257
		ld      a,h
		ld      i,a
		ld      (hl),a
		ldir

		ld      h,a
		ld      l, a
		ld      a,$c3
		ld      (hl),a
		inc     hl
		ld      de,._ISR
		ld      (hl),e
		inc     hl
		ld      (hl),d

		nextreg VIDEO_INTERUPT_CONTROL_NR_22,%00000110
		nextreg VIDEO_INTERUPT_VALUE_NR_23,190

		im      2

		exx
		push    hl
		exx
		ei


#line 227 "/NextBuildv8/Scripts/nextlib_ints.bas"
_SetUpIM__leave:
	ret
_ISR:
#line 245 "/NextBuildv8/Scripts/nextlib_ints.bas"




		ld 		(out_isr_sp+1), sp
		ld 		sp, temp_isr_sp
	push af : push bc : push hl : push de : push ix : push iy
		ex af,af'
		push af
	exx : push bc : push hl : push de :	exx
		ld 		bc,TBBLUE_REGISTER_SELECT_P_243B
		in 		a,(c)
		ld 		(skipmusicplayer+1), a

#line 259 "/NextBuildv8/Scripts/nextlib_ints.bas"
	call _MyCustomISR
#line 270 "/NextBuildv8/Scripts/nextlib_ints.bas"



		ld 		a,(sampletoplay)
		cp		$ff
		jr 		z,no_sfx_to_play

		call 	PlaySFX

no_sfx_to_play:

		ld      a,(sfxenablednl)
	or      a : jr z,skipfxplayernl

		call    _CallbackSFX

skipfxplayernl:
		ld      a,(sfxenablednl+1)
	or      a : jr z,skipmusicplayer
	ld 		bc,65533	: ld a,255:out (c),a
		call    playmusicnl


#line 293 "/NextBuildv8/Scripts/nextlib_ints.bas"
#line 295 "/NextBuildv8/Scripts/nextlib_ints.bas"


skipmusicplayer:
		ld 		a,0
		ld		bc, TBBLUE_REGISTER_SELECT_P_243B
		out 	(c), a



		exx
	pop de : pop hl : pop bc
		exx

	pop af : ex af,af'
	pop iy : pop ix : pop de : pop hl : pop bc : pop af
out_isr_sp:
		ld 		sp, 0000
		ei
		ret

#line 315 "/NextBuildv8/Scripts/nextlib_ints.bas"
#line 315 "/NextBuildv8/Scripts/nextlib_ints.bas"

		ds 64, 0
temp_isr_sp:
		db 0, 0

#line 320 "/NextBuildv8/Scripts/nextlib_ints.bas"
_ISR__leave:
	ret
_PlaySFXSys:
#line 325 "/NextBuildv8/Scripts/nextlib_ints.bas"






PlaySFX:
		PROC
		Local ayfxrestoreslot

		push 	ix

		ld 		a,(sampletoplay)

		ld 		d,a

		ld 		a,$ff
		ld 		(sampletoplay),a


	db $3e,$51,$01,$3b,$24,$ed,$79,$04,$ed,$78 : ld (ayfxrestoreslot+3),a
#line 345

	db $3e,$52,$01,$3b,$24,$ed,$79,$04,$ed,$78 : ld (ayfxrestoreslot+7),a
#line 346

		ld 		a,(ayfxbankinplaycode)
		nextreg $51,a
		inc 	a
		nextreg $52,a

		ld 		a,d

AFXPLAY:

		ld 		de,0
		ld 		h,e
		ld 		l,a
		add 	hl,hl

afxBnkAdr:

		ld 		bc,0
		add 	hl,bc
		ld 		c,(hl)
		inc 	hl
		ld 		b,(hl)
		add 	hl,bc
		push 	hl

		ld 		hl,afxChDesc
		ld 		b,3

afxPlay0:

		inc 	hl
		inc 	hl
		ld 		a,(hl)
		inc 	hl
		cp 		e
		jr 		c,afxPlay1
		ld 		c,a
		ld 		a,(hl)
		cp 		d
		jr 		c,afxPlay1
		ld 		e,c
		ld 		d,a
		push 	hl
		pop 	ix

afxPlay1:

		inc 	hl
		djnz 	afxPlay0

		pop 	de
		ld 		(ix-3),e
		ld 		(ix-2),d
		ld 		(ix-1),b
		ld 		(ix-0),b

ayfxrestoreslot:

		nextreg $51,$ff
		nextreg $52,$ff
		pop 	ix


		ENDP


#line 416 "/NextBuildv8/Scripts/nextlib_ints.bas"
_PlaySFXSys__leave:
	ret
_InitSFX:
#line 418 "/NextBuildv8/Scripts/nextlib_ints.bas"









		PROC
		LOCAL ayfxrestoreslot

		ld 		d,a
		call 	_checkints
		di

		exx
		pop 	hl
		exx


	db $3e,$51,$01,$3b,$24,$ed,$79,$04,$ed,$78 : ld (ayfxrestoreslot+3),a
#line 439

	db $3e,$52,$01,$3b,$24,$ed,$79,$04,$ed,$78 : ld (ayfxrestoreslot+7),a
#line 440

		ld 		a,d
		ld 		(ayfxbankinplaycode),a
		nextreg $51,a
		inc 	a
		nextreg $52,a

		ld 		hl,$2000

AFXINIT:
		inc 	hl
		ld 		(afxBnkAdr+1),hl

		ld 		hl,afxChDesc
		ld 		de,$00ff
		ld 		bc,$03fd

afxInit0:
		ld 		(hl),d
		inc 	hl
		ld 		(hl),d
		inc 	hl
		ld 		(hl),e
		inc 	hl
		ld 		(hl),e
		inc 	hl
		djnz 	afxInit0

		ld 		hl,$ffbf
		ld 		e,$15

afxInit1:
		dec 	e
		ld 		b,h
		out 	(c),e
		ld 		b,l
		out 	(c),d
		jr 		nz,afxInit1
		ld 		(afxNseMix+1),de

ayfxrestoreslot:

		nextreg $51,$0
		nextreg $52,$1

		exx
		push 	hl
		exx

		ret

		ENDP


#line 498 "/NextBuildv8/Scripts/nextlib_ints.bas"
	call _CallbackSFX
	call _PlaySFXSys
_InitSFX__leave:
	ret
_CallbackSFX:
#line 505 "/NextBuildv8/Scripts/nextlib_ints.bas"


		PROC

		LOCAL ayfxrestoreslot

AFXFRAME:





		exx
		push ix

	ld bc,65533	: ld a,254:out (c),a

	db $3e,$51,$01,$3b,$24,$ed,$79,$04,$ed,$78 : ld (ayfxrestoreslot+3),a
#line 522

	db $3e,$52,$01,$3b,$24,$ed,$79,$04,$ed,$78 : ld (ayfxrestoreslot+7),a
#line 523

		ld 		a,(ayfxbankinplaycode)
		nextreg $51,a
		inc 	a
		nextreg $52,a

		ld 		bc,$03fd
		ld 		ix,afxChDesc

afxFrame0:
		push 	bc

		ld 		a,11
		ld 		h,(ix+1)
		cp 		h
		jr 		nc,afxFrame7
		ld 		l,(ix+0)

		ld 		e,(hl)
		inc 	hl

		sub 	b
		ld 		d,b

		ld 		b,$ff
		out 	(c),a
		ld 		b,$bf
		ld 		a,e
		and 	$0f
		out 	(c),a

		bit 	5,e
		jr 		z,afxFrame1

		ld 		a,3
		sub 	d
		add 	a,a

		ld 		b,$ff
		out 	(c),a
		ld 		b,$bf
		ld 		d,(hl)
		inc 	hl
		out 	(c),d
		ld 		b,$ff
		inc 	a
		out 	(c),a
		ld 		b,$bf
		ld 		d,(hl)
		inc 	hl
		out 	(c),d

afxFrame1:

		bit 	6,e
		jr 		z,afxFrame3

		ld 		a,(hl)
		sub 	$20
		jr 		c,afxFrame2
		ld 		h,a
		ld 		b,$ff
		ld 		b,c
		jr 		afxFrame6

afxFrame2:
		inc 	hl
		ld 		(afxNseMix+1),a

afxFrame3:
		pop 	bc
		push 	bc
		inc 	b

		ld 		a,%01101111
afxFrame4:
		rrc 	e
		rrca
		djnz 	afxFrame4
		ld d	,a

		ld 		bc,afxNseMix+2
		ld 		a,(bc)
		xor 	e
		and 	d
		xor 	e
		ld 		(bc),a

afxFrame5:
		ld 		c,(ix+2)
		ld 		b,(ix+3)
		inc 	bc

afxFrame6:
		ld 		(ix+2),c
		ld 		(ix+3),b

		ld 		(ix+0),l
		ld 		(ix+1),h

afxFrame7:
		ld 		bc,4
		add 	ix,bc
		pop 	bc
		djnz 	afxFrame0

		ld 		hl,$ffbf

afxNseMix:
		ld 		de,0
		ld 		a,6
		ld 		b,h
		out 	(c),a
		ld 		b,l
		out 	(c),e
		inc 	a
		ld 		b,h
		out 	(c),a
		ld 		b,l
		out 	(c),d
		pop 	ix
		exx

ayfxrestoreslot:
		nextreg $51,$0
		nextreg $52,$1


		ld 		bc,65533
		ld 		a,255
		out 	(c),a
		ret

		ENDP


#line 663 "/NextBuildv8/Scripts/nextlib_ints.bas"
	call _ISR
_CallbackSFX__leave:
	ret
_MultiKeys:
#line 42 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/keys.bas"

		ld a, h
		in a, (0FEh)
		cpl
		and l

#line 48 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/keys.bas"
_MultiKeys__leave:
	ret
_GetKeyScanCode:
#line 60 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/keys.bas"

		PROC
		LOCAL END_KEY
		LOCAL LOOP

		ld l, 1
		ld a, l
LOOP:
		cpl
		ld h, a
		in a, (0FEh)
		cpl
		and 1Fh
		jr nz, END_KEY

		ld a, l
		rla
		ld l, a
		jr nc, LOOP
		ld h, a
END_KEY:
		ld l, a
		ENDP

#line 84 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/keys.bas"
_GetKeyScanCode__leave:
	ret
_MyCustomISR:
#line 229 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



#line 232 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	call _PlayCopperAudio
	call _SetCopperAudio
	ld a, 1
	ld (_int_done), a
#line 235 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"



#line 238 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_MyCustomISR__leave:
	ret
_ShowIntroScreen:
_ShowIntroScreen__leave:
	ret
_GetLevel:
	push ix
	ld ix, 0
	add ix, sp
	xor a
	push af
	push af
	push af
	push af
	call _ClipTile
	ld a, (ix+5)
	ld l, a
	ld h, 0
	ld de, 1280
	call .core.__MUL16_FAST
	ld (_mapoffset), hl
#line 341 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		nextreg MMU0_0000_NR_50,40
		ld de,(._mapoffset)
		ld hl,$000
		add hl,de
		ld de,$4000
		ld bc,1280
		ldir
		nextreg MMU0_0000_NR_50,$ff





#line 355 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	call _SetUpNPC
	ld hl, (_startx)
	ld (_plx), hl
	ld a, (_starty)
	ld (_ply), a
	ld a, 220
	push af
	ld a, 8
	push af
	ld a, 255
	push af
	xor a
	push af
	call _ClipTile
	ld a, 220
	push af
	ld a, 8
	push af
	ld a, 159
	push af
	xor a
	push af
	call _ClipSprite
_GetLevel__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_ScrollLevel:
	push ix
	ld ix, 0
	add ix, sp
	ld a, (ix+5)
	cp 64
	jp nc, _ScrollLevel__leave
	ld a, (_level)
	ld l, a
	ld h, 0
	ld de, 1280
	call .core.__MUL16_FAST
	push hl
	ld a, (ix+5)
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	ex de, hl
	pop hl
	add hl, de
	ld (_mapoffset), hl
#line 367 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		nextreg MMU0_0000_NR_50,40
		ld de,(._mapoffset)
		ld hl,$000
		add hl,de
		ld de,$4000
		ld bc,1280
		ldir
		ld a,0
		nextreg MMU0_0000_NR_50,$ff


#line 379 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_ScrollLevel__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_CheckCollision:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, -13
	add hl, sp
	ld sp, hl
	ld (hl), 0
	ld bc, 12
	ld d, h
	ld e, l
	inc de
	ldir
	ld a, (_ply)
	sub 140
	ccf
	jp nc, .LABEL.__LABEL21
	ld a, 1
	ld (_scrolltrigger), a
.LABEL.__LABEL21:
	ld a, (_scrolltrigger)
	dec a
	jp nz, .LABEL.__LABEL23
	ld a, (_scrolly)
	cp 8
	jp nc, .LABEL.__LABEL25
	inc a
	ld hl, (_velocity)
	ld de, (_velocity + 2)
	add a, e
	ld (_scrolly), a
.LABEL.__LABEL25:
	ld a, (_scrolly)
	push af
	ld a, 49
	call _NextRegA
	ld a, 7
	ld hl, (_scrolly - 1)
	cp h
	jp nc, .LABEL.__LABEL27
	xor a
	ld (_scrolltrigger), a
	ld hl, _lineno
	inc (hl)
	ld a, (_lineno)
	push af
	call _ScrollLevel
	xor a
	ld (_scrolly), a
	ld a, (_oldpy)
	ld (_ply), a
	xor a
	push af
	ld a, 49
	call _NextRegA
.LABEL.__LABEL27:
	ld a, (_oldpy)
	dec a
	ld de, (_velocity + 2)
	sub e
	ld (_ply), a
.LABEL.__LABEL23:
	ld a, 64
	ld hl, (_ply - 1)
	sub h
	ccf
	sbc a, a
	push af
	xor a
	ld hl, (_lineno - 1)
	cp h
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL298
	ld a, h
.LABEL.__LABEL298:
	or a
	jp z, .LABEL.__LABEL29
	ld a, 2
	ld (_scrolltrigger), a
.LABEL.__LABEL29:
	ld a, (_scrolltrigger)
	sub 2
	jp nz, .LABEL.__LABEL31
	ld a, (_scrolly)
	ld h, a
	ld a, 248
	call .core.__LTI8
	or a
	jp z, .LABEL.__LABEL33
	ld a, (_scrolly)
	dec a
	ld h, a
	ld a, (_jumpvalue)
	add a, h
	ld (_scrolly), a
.LABEL.__LABEL33:
	ld a, (_scrolly)
	push af
	ld a, 49
	call _NextRegA
	ld a, (_scrolly)
	ld h, 249
	call .core.__LTI8
	or a
	jp z, .LABEL.__LABEL35
	xor a
	ld (_scrolltrigger), a
	ld hl, (_lineno - 1)
	cp h
	jp nc, .LABEL.__LABEL37
	ld hl, _lineno
	dec (hl)
.LABEL.__LABEL37:
	ld a, (_lineno)
	push af
	call _ScrollLevel
	xor a
	ld (_scrolly), a
	ld a, (_oldpy)
	ld (_ply), a
	xor a
	push af
	ld a, 49
	call _NextRegA
.LABEL.__LABEL35:
	ld a, (_oldpy)
	inc a
	ld (_ply), a
.LABEL.__LABEL31:
	ld hl, (_plx)
	ld (_oldpx), hl
	ld a, (_ply)
	ld (_oldpy), a
	ld a, (_pldx)
	or a
	jp nz, .LABEL.__LABEL38
	ld de, (_hvel + 2)
	ld a, e
	ld l, a
	ld h, 0
	ex de, hl
	ld hl, (_plx)
	or a
	sbc hl, de
	ld (_plx), hl
	jp .LABEL.__LABEL39
.LABEL.__LABEL38:
	ld a, (_pldx)
	dec a
	jp nz, .LABEL.__LABEL39
	ld de, (_hvel + 2)
	ld a, e
	ld l, a
	ld h, 0
	ex de, hl
	ld hl, (_plx)
	add hl, de
	ld (_plx), hl
.LABEL.__LABEL39:
	ld hl, (_plx)
	ld (ix-11), l
	ld (ix-10), h
	ld a, (_ply)
	ld (ix-1), a
	inc hl
	inc hl
	ld b, 3
.LABEL.__LABEL299:
	srl h
	rr l
	djnz .LABEL.__LABEL299
	ld a, l
	ld (ix-2), a
	ld l, (ix-11)
	ld h, (ix-10)
	ld de, 14
	add hl, de
	ld b, 3
.LABEL.__LABEL301:
	srl h
	rr l
	djnz .LABEL.__LABEL301
	ld a, l
	ld (ix-3), a
	ld a, (ix-1)
	add a, 12
	srl a
	srl a
	srl a
	ld (ix-4), a
	ld a, (ix-1)
	add a, 14
	srl a
	srl a
	srl a
	ld (ix-5), a
	ld a, 40
	cp (ix-2)
	jp nc, .LABEL.__LABEL43
	ld (ix-2), 0
.LABEL.__LABEL43:
	cp (ix-3)
	jp nc, .LABEL.__LABEL45
	ld (ix-3), 40
.LABEL.__LABEL45:
	ld a, 32
	cp (ix-4)
	jp nc, .LABEL.__LABEL47
	ld (ix-4), 0
.LABEL.__LABEL47:
	cp (ix-5)
	jp nc, .LABEL.__LABEL49
	ld (ix-5), 32
.LABEL.__LABEL49:
	ld (ix-6), 0
	ld a, (_pldx)
	or a
	jp nz, .LABEL.__LABEL50
	ld a, (ix-4)
	ld (ix-7), a
	jp .LABEL.__LABEL52
.LABEL.__LABEL55:
	ld a, (ix-7)
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	ld de, 16384
	add hl, de
	push hl
	ld a, (ix-2)
	ld l, a
	ld h, 0
	ex de, hl
	pop hl
	add hl, de
	ld a, (hl)
	ld (ix-6), a
	ld h, a
	ld a, 27
	cp h
	jp nc, .LABEL.__LABEL56
	ld hl, (_oldpx)
	ld (_plx), hl
	ld de, 0
	ld hl, 0
	ld (_hvel), hl
	ld (_hvel + 2), de
	jp .LABEL.__LABEL51
.LABEL.__LABEL56:
	inc (ix-7)
.LABEL.__LABEL52:
	ld a, (ix-5)
	cp (ix-7)
	jp nc, .LABEL.__LABEL55
.LABEL.__LABEL54:
	jp .LABEL.__LABEL51
.LABEL.__LABEL50:
	ld a, (_pldx)
	dec a
	jp nz, .LABEL.__LABEL51
	ld a, (ix-4)
	ld (ix-7), a
	jp .LABEL.__LABEL61
.LABEL.__LABEL64:
	ld a, (ix-7)
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	ld de, 16384
	add hl, de
	push hl
	ld a, (ix-3)
	ld l, a
	ld h, 0
	ex de, hl
	pop hl
	add hl, de
	ld a, (hl)
	ld (ix-6), a
	ld h, a
	ld a, 27
	cp h
	jp nc, .LABEL.__LABEL65
	ld hl, (_oldpx)
	ld (_plx), hl
	ld hl, (_hvel + 2)
	push hl
	ld hl, (_hvel)
	push hl
	ld de, 0
	ld hl, 13107
	call .core.__LEI32
	or a
	jp nz, .LABEL.__LABEL51
	ld hl, (_hvel + 2)
	push hl
	ld hl, (_hvel)
	push hl
	ld de, 0
	ld hl, 13107
	call .core.__SUB32
	ld (_hvel), hl
	ld (_hvel + 2), de
.LABEL.__LABEL69:
	jp .LABEL.__LABEL51
.LABEL.__LABEL65:
	inc (ix-7)
.LABEL.__LABEL61:
	ld a, (ix-5)
	cp (ix-7)
	jp nc, .LABEL.__LABEL64
.LABEL.__LABEL51:
	ld a, (_pldy)
	sub 2
	jp nz, .LABEL.__LABEL70
	ld a, (_ply)
	dec a
	ld de, (_velocity + 2)
	sub e
	ld (_ply), a
	jp .LABEL.__LABEL71
.LABEL.__LABEL70:
	ld a, (_ply)
	inc a
	ld de, (_velocity + 2)
	add a, e
	ld (_ply), a
.LABEL.__LABEL71:
	ld hl, (_plx)
	ld (ix-11), l
	ld (ix-10), h
	ld hl, (_ply - 1)
	ld a, (_scrolly)
	add a, h
	ld (ix-1), a
	ld l, (ix-11)
	ld h, (ix-10)
	inc hl
	inc hl
	ld b, 3
.LABEL.__LABEL303:
	srl h
	rr l
	djnz .LABEL.__LABEL303
	ld a, l
	ld (ix-2), a
	ld l, (ix-11)
	ld h, (ix-10)
	ld de, 14
	add hl, de
	ld b, 3
.LABEL.__LABEL305:
	srl h
	rr l
	djnz .LABEL.__LABEL305
	ld a, l
	ld (ix-3), a
	ld a, (ix-1)
	add a, 2
	srl a
	srl a
	srl a
	ld (ix-4), a
	ld a, (ix-1)
	add a, 14
	srl a
	srl a
	srl a
	ld (ix-5), a
	ld a, 40
	cp (ix-2)
	jp nc, .LABEL.__LABEL73
	ld (ix-2), 0
.LABEL.__LABEL73:
	cp (ix-3)
	jp nc, .LABEL.__LABEL75
	ld (ix-3), 40
.LABEL.__LABEL75:
	ld a, 32
	cp (ix-4)
	jp nc, .LABEL.__LABEL77
	ld (ix-4), 0
.LABEL.__LABEL77:
	cp (ix-5)
	jp nc, .LABEL.__LABEL79
	ld (ix-5), 32
.LABEL.__LABEL79:
	ld (ix-6), 0
	ld a, (_pldy)
	sub 2
	jp nz, .LABEL.__LABEL80
	ld a, (ix-4)
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	ld de, 16384
	add hl, de
	ld (ix-13), l
	ld (ix-12), h
	ld a, (ix-2)
	ld (ix-8), a
	jp .LABEL.__LABEL82
.LABEL.__LABEL85:
	ld l, (ix-13)
	ld h, (ix-12)
	push hl
	ld a, (ix-8)
	ld l, a
	ld h, 0
	ex de, hl
	pop hl
	add hl, de
	ld a, (hl)
	ld (ix-6), a
	ld h, a
	ld a, 27
	cp h
	sbc a, a
	ld d, a
	ld a, (_ply)
	cp 4
	sbc a, a
	or d
	jp z, .LABEL.__LABEL86
	ld a, (ix-6)
	sub 28
	sub 1
	sbc a, a
	ld d, a
	ld a, (ix-6)
	sub 27
	sub 1
	sbc a, a
	or d
	jp z, .LABEL.__LABEL89
	ld a, (_oldpy)
	sub 8
	ld (_ply), a
	jp .LABEL.__LABEL86
.LABEL.__LABEL89:
	ld a, (_oldpy)
	ld (_ply), a
	ld a, 16
	ld (_jumpposition), a
	jp .LABEL.__LABEL81
.LABEL.__LABEL86:
	inc (ix-8)
.LABEL.__LABEL82:
	ld a, (ix-3)
	cp (ix-8)
	jp nc, .LABEL.__LABEL85
.LABEL.__LABEL84:
	jp .LABEL.__LABEL81
.LABEL.__LABEL80:
	ld a, (ix-5)
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	ld de, 16384
	add hl, de
	ld (ix-13), l
	ld (ix-12), h
	ld a, (ix-2)
	ld (ix-8), a
	jp .LABEL.__LABEL91
.LABEL.__LABEL94:
	ld l, (ix-13)
	ld h, (ix-12)
	push hl
	ld a, (ix-8)
	ld l, a
	ld h, 0
	ex de, hl
	pop hl
	add hl, de
	ld a, (hl)
	ld (ix-6), a
	ld h, a
	ld a, 25
	cp h
	jp nc, .LABEL.__LABEL96
	ld a, 1
	ld (_floor), a
	ld a, (_oldpy)
	ld (_ply), a
	xor a
	ld (_jumptrigger), a
	ld de, 0
	ld hl, 0
	ld (_velocity), hl
	ld (_velocity + 2), de
	jp .LABEL.__LABEL93
.LABEL.__LABEL96:
	xor a
	ld (_floor), a
	inc (ix-8)
.LABEL.__LABEL91:
	ld a, (ix-3)
	cp (ix-8)
	jp nc, .LABEL.__LABEL94
.LABEL.__LABEL93:
	ld hl, (_velocity + 2)
	push hl
	ld hl, (_velocity)
	push hl
	ld de, 2
	ld hl, 0
	call .core.__LTI32
	or a
	jp z, .LABEL.__LABEL81
	ld de, 0
	ld hl, 13107
	ld bc, (_velocity)
	add hl, bc
	ex de, hl
	ld bc, (_velocity + 2)
	adc hl, bc
	ex de, hl
	ld (_velocity), hl
	ld (_velocity + 2), de
.LABEL.__LABEL81:
#line 567 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		di

#line 570 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 571 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		DW $91ED
		DB $50
		DB 54

#line 576 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	ld a, (_lineno)
	ld l, a
	ld h, 0
	ld de, 20
	call .core.__MUL16_FAST
	push hl
	ld a, (_oldpy)
	srl a
	srl a
	srl a
	ld l, a
	ld h, 0
	ld de, 20
	call .core.__MUL16_FAST
	push hl
	ld hl, (_oldpx)
	ld de, 8
	add hl, de
	ld b, 4
.LABEL.__LABEL307:
	srl h
	rr l
	djnz .LABEL.__LABEL307
	ex de, hl
	pop hl
	add hl, de
	ex de, hl
	pop hl
	add hl, de
	ld (ix-13), l
	ld (ix-12), h
	ld a, (hl)
	ld (ix-9), a
#line 575 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		DW $91ED
		DB $50
		DB $ff

#line 580 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 575 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		ei

#line 578 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	ld a, (ix-9)
	sub 8
	jp nz, .LABEL.__LABEL101
	ld hl, _diamonds
	dec (hl)
	xor a
	call _PlayCopperSample
#line 583 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		DW $91ED
		DB $50
		DB 54

#line 588 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	ld l, (ix-13)
	ld h, (ix-12)
	xor a
	ld (hl), a
#line 585 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		DW $91ED
		DB $50
		DB 40

#line 590 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	ld a, (_lineno)
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	push hl
	ld a, (_oldpy)
	srl a
	srl a
	srl a
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	push hl
	ld hl, (_oldpx)
	ld de, 8
	add hl, de
	ld b, 4
.LABEL.__LABEL309:
	srl h
	rr l
	djnz .LABEL.__LABEL309
	add hl, hl
	ex de, hl
	pop hl
	add hl, de
	ex de, hl
	pop hl
	add hl, de
	ld (ix-13), l
	ld (ix-12), h
	ld de, 0
	ld (hl), e
	inc hl
	ld (hl), d
	ld l, (ix-13)
	ld h, (ix-12)
	ld de, 40
	add hl, de
	ld de, 0
	ld (hl), e
	inc hl
	ld (hl), d
#line 589 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		DW $91ED
		DB $50
		DB $ff

#line 594 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	ld a, (_lineno)
	push af
	call _ScrollLevel
	ld a, (_diamonds)
	or a
	jp nz, .LABEL.__LABEL101
	ld a, 3
	ld (_dead), a
.LABEL.__LABEL101:
	ld hl, (_plx)
	ld (_oldpx), hl
	ld a, (_ply)
	ld (_oldpy), a
_CheckCollision__leave:
	ld sp, ix
	pop ix
	ret
_AddThrowbaddy:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	push hl
	ld a, (ix-1)
	ld d, 6
	ld e, a
	mul d, e
	ld a, e
	ld l, a
	ld h, 0
	ex de, hl
	ld hl, .LABEL._ThrowData
	add hl, de
	ld (ix-4), l
	ld (ix-3), h
.LABEL.__LABEL104:
	ld l, (ix-4)
	ld h, (ix-3)
	ld a, (hl)
	ld h, a
	xor a
	cp h
	sbc a, a
	push af
	ld a, (ix-1)
	cp 3
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL313
	ld a, h
.LABEL.__LABEL313:
	or a
	jp z, .LABEL.__LABEL105
	inc (ix-1)
	jp .LABEL.__LABEL104
.LABEL.__LABEL105:
	ld a, (ix-1)
	cp 3
	jp nc, _AddThrowbaddy__leave
	ld h, (ix-3)
	ld a, 1
	ld (hl), a
	inc hl
	push hl
	ld l, (ix+4)
	ld h, (ix+5)
	ex de, hl
	pop hl
	ld (hl), e
	inc hl
	ld (hl), d
	ld l, (ix-4)
	ld h, (ix-3)
	inc hl
	inc hl
	inc hl
	ld a, (ix+7)
	ld (hl), a
	ld l, (ix-4)
	ld h, (ix-3)
	ld de, 4
	add hl, de
	ld a, (ix-2)
	ld (hl), a
	ld l, (ix-4)
	ld h, (ix-3)
	inc de
	add hl, de
	ld a, (ix+9)
	add a, 32
	ld (hl), a
_AddThrowbaddy__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	pop bc
	ex (sp), hl
	exx
	ret
_processthrows:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, -10
	add hl, sp
	ld sp, hl
	ld (hl), 0
	ld bc, 9
	ld d, h
	ld e, l
	inc de
	ldir
	ld (ix-4), 0
	jp .LABEL.__LABEL108
.LABEL.__LABEL111:
	ld a, (ix-4)
	ld d, 6
	ld e, a
	mul d, e
	ld a, e
	ld l, a
	ld h, 0
	ex de, hl
	ld hl, .LABEL._ThrowData
	add hl, de
	ld (ix-8), l
	ld (ix-7), h
	ld a, (hl)
	or a
	jp z, .LABEL.__LABEL112
	ld hl, .LABEL._ThrowPositions
	ld (ix-10), l
	ld (ix-9), h
	ld l, (ix-6)
	ld h, (ix-5)
	push hl
	ld l, (ix-10)
	ld h, (ix-9)
	inc hl
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ex de, hl
	pop hl
	add hl, de
	ld (ix-6), l
	ld (ix-5), h
	ld a, (ix-1)
	ld l, (ix-10)
	ld h, (ix-9)
	inc hl
	inc hl
	inc hl
	add a, (hl)
	ld (ix-1), a
	ld l, (ix-10)
	ld h, (ix-9)
	ld de, 4
	add hl, de
	ld a, (hl)
	ld (ix-2), a
	ld l, (ix-10)
	ld h, (ix-9)
	inc de
	add hl, de
	ld a, (hl)
	ld (ix-3), a
	ld a, (ix-2)
	add a, 2
	ld (ix-2), a
	ld h, a
	ld a, 32
	cp h
	jp nc, .LABEL.__LABEL115
	xor a
	push af
	ld a, (ix-3)
	sub 5
	push af
	call _RemoveSprite
	ld l, (ix-8)
	ld h, (ix-7)
	ld de, 4
	add hl, de
	xor a
	ld (hl), a
	ld l, (ix-8)
	ld h, (ix-7)
	ld (hl), a
	jp .LABEL.__LABEL112
.LABEL.__LABEL115:
	ld l, (ix-8)
	ld h, (ix-7)
	inc hl
	push hl
	ld l, (ix-6)
	ld a, l
	pop hl
	ld (hl), a
	ld l, (ix-8)
	ld h, (ix-7)
	inc hl
	inc hl
	inc hl
	ld a, (ix-1)
	ld (hl), a
	ld l, (ix-8)
	ld h, (ix-7)
	dec de
	add hl, de
	ld a, 3
	ld (hl), a
	xor a
	push af
	push af
	ld a, 8
	push af
	ld a, (ix-3)
	push af
	ld a, (ix-1)
	push af
	ld l, (ix-6)
	ld h, (ix-5)
	push hl
	call _UpdateSprite
.LABEL.__LABEL112:
	inc (ix-4)
.LABEL.__LABEL108:
	ld a, 3
	cp (ix-4)
	jp nc, .LABEL.__LABEL111
_processthrows__leave:
	ld sp, ix
	pop ix
	ret
_ReadKeys:
	ld a, 4
	ld (_pldy), a
	ld bc, 31
	in a, (c)
	ld (_kemp), a
	call _GetKeyScanCode
	ld de, 64264
	call .core.__EQ16
	or a
	jp z, .LABEL.__LABEL118
	xor a
	ld (_diamonds), a
.LABEL.__LABEL118:
	ld hl, 64772
	call _MultiKeys
	ld d, a
	ld a, (_kemp)
	and 1
	dec a
	sub 1
	sbc a, a
	or d
	jp z, .LABEL.__LABEL119
	xor a
	ld hl, (_pleft - 1)
	cp h
	jp nc, .LABEL.__LABEL121
	ld hl, _pleft
	dec (hl)
	jp .LABEL.__LABEL122
.LABEL.__LABEL121:
	ld a, (_pright)
	cp 8
	jp nc, .LABEL.__LABEL122
	add a, 2
	ld (_pright), a
.LABEL.__LABEL122:
	ld a, 1
	ld (_pldx), a
	xor a
	ld (_attr3), a
	jp .LABEL.__LABEL120
.LABEL.__LABEL119:
	ld hl, 64769
	call _MultiKeys
	ld d, a
	ld a, (_kemp)
	and 2
	sub 2
	sub 1
	sbc a, a
	or d
	jp z, .LABEL.__LABEL120
	xor a
	ld hl, (_pright - 1)
	cp h
	jp nc, .LABEL.__LABEL127
	ld hl, _pright
	dec (hl)
	jp .LABEL.__LABEL128
.LABEL.__LABEL127:
	ld a, (_pleft)
	cp 8
	jp nc, .LABEL.__LABEL128
	add a, 2
	ld (_pleft), a
.LABEL.__LABEL128:
	xor a
	ld (_pldx), a
	ld a, 8
	ld (_attr3), a
.LABEL.__LABEL120:
	xor a
	ld hl, (_pleft - 1)
	cp h
	jp nc, .LABEL.__LABEL132
	ld hl, (_hvel + 2)
	push hl
	ld hl, (_hvel)
	push hl
	ld de, 2
	ld hl, 0
	call .core.__LTI32
	or a
	jp z, .LABEL.__LABEL134
	ld de, 0
	ld hl, 6553
	ld bc, (_hvel)
	add hl, bc
	ex de, hl
	ld bc, (_hvel + 2)
	adc hl, bc
	ex de, hl
	ld (_hvel), hl
	ld (_hvel + 2), de
.LABEL.__LABEL134:
	ld hl, _pleft
	dec (hl)
	ld a, 1
	ld (_playeranim), a
	xor a
	ld (_pldx), a
.LABEL.__LABEL132:
	ld hl, (_pright - 1)
	cp h
	jp nc, .LABEL.__LABEL136
	ld hl, (_hvel + 2)
	push hl
	ld hl, (_hvel)
	push hl
	ld de, 2
	ld hl, 0
	call .core.__LTI32
	or a
	jp z, .LABEL.__LABEL138
	ld de, 0
	ld hl, 6553
	ld bc, (_hvel)
	add hl, bc
	ex de, hl
	ld bc, (_hvel + 2)
	adc hl, bc
	ex de, hl
	ld (_hvel), hl
	ld (_hvel + 2), de
.LABEL.__LABEL138:
	ld hl, _pright
	dec (hl)
	ld a, 1
	ld (_playeranim), a
	ld (_pldx), a
.LABEL.__LABEL136:
	ld hl, (_pright - 1)
	ld a, (_pleft)
	add a, h
	or a
	jp nz, .LABEL.__LABEL140
	ld hl, (_hvel + 2)
	push hl
	ld hl, (_hvel)
	push hl
	ld de, 0
	ld hl, 26214
	call .core.__LEI32
	or a
	jp nz, .LABEL.__LABEL142
	ld hl, (_hvel + 2)
	push hl
	ld hl, (_hvel)
	push hl
	ld de, 0
	ld hl, 13107
	call .core.__SUB32
	ld (_hvel), hl
	ld (_hvel + 2), de
.LABEL.__LABEL142:
	ld a, 4
	ld (_pldx), a
	xor a
	ld (_playeranim), a
.LABEL.__LABEL140:
	ld hl, 64258
	call _MultiKeys
	ld d, a
	ld a, (_kemp)
	and 16
	sub 16
	sub 1
	sbc a, a
	or d
	jp z, .LABEL.__LABEL143
	ld hl, (_sword - 1)
	ld a, (_swordkeypressed)
	or h
	jp nz, .LABEL.__LABEL144
	xor a
	ld (_swordframe), a
	ld a, 1
	ld (_swordkeypressed), a
	ld a, 2
	ld (_sword), a
	ld a, 10
	call _PlaySFX
.LABEL.__LABEL146:
	jp .LABEL.__LABEL144
.LABEL.__LABEL143:
	ld a, (_sword)
	dec a
	jp nz, .LABEL.__LABEL144
	xor a
	push af
	ld a, 63
	push af
	call _RemoveSprite
.LABEL.__LABEL144:
	ld hl, 64258
	call _MultiKeys
	sub 1
	sbc a, a
	push af
	ld a, (_sword)
	dec a
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL314
	ld a, h
.LABEL.__LABEL314:
	or a
	jp z, .LABEL.__LABEL150
	ld a, (_kemp)
	and 16
	jp nz, .LABEL.__LABEL152
	xor a
	ld (_swordkeypressed), a
	ld (_sword), a
.LABEL.__LABEL152:
	xor a
	push af
	ld a, 63
	push af
	call _RemoveSprite
.LABEL.__LABEL150:
	ld hl, 64770
	call _MultiKeys
	or a
	jp z, .LABEL.__LABEL154
	ld hl, 50
	push hl
	call _WaitRetrace
#line 776 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		di

#line 779 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 780 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		DW $91ED
		DB $50
		DB 54

#line 785 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 788 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		DW $91ED
		DB $50
		DB $ff

#line 793 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 788 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		ei

#line 791 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
.LABEL.__LABEL154:
	ld hl, 32513
	call _MultiKeys
	ld d, a
	ld a, (_kemp)
	and 32
	sub 32
	sub 1
	sbc a, a
	or d
	push af
	ld a, (_jumptrigger)
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL315
	ld a, h
.LABEL.__LABEL315:
	push af
	ld a, (_nojump)
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL316
	ld a, h
.LABEL.__LABEL316:
	or a
	jp z, .LABEL.__LABEL155
	ld a, (_floor)
	or a
	jp z, .LABEL.__LABEL156
	ld a, 2
	ld (_jumptrigger), a
	ld a, 1
	ld (_nojump), a
	ld a, 5
	call _PlaySFX
.LABEL.__LABEL158:
	jp .LABEL.__LABEL156
.LABEL.__LABEL155:
	ld hl, 32513
	call _MultiKeys
	sub 1
	sbc a, a
	push af
	ld a, (_kemp)
	and 32
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL317
	ld a, h
.LABEL.__LABEL317:
	push af
	ld a, (_nojump)
	dec a
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL318
	ld a, h
.LABEL.__LABEL318:
	or a
	jp z, .LABEL.__LABEL156
	xor a
	ld (_nojump), a
	ld (_jumpposition), a
	ld (_playersprite), a
.LABEL.__LABEL156:
	ld a, (_jumptrigger)
	sub 2
	jp nz, .LABEL.__LABEL162
	xor a
	ld (_jumpposition), a
	ld a, 1
	ld (_jumptrigger), a
	ld a, 2
	ld (_playersprite), a
.LABEL.__LABEL162:
	ld a, (_jumptrigger)
	dec a
	jp nz, .LABEL.__LABEL164
	ld hl, (_hvel + 2)
	push hl
	ld hl, (_hvel)
	push hl
	ld de, 2
	ld hl, 13107
	call .core.__LTI32
	or a
	jp z, .LABEL.__LABEL166
	ld de, 0
	ld hl, 13107
	ld bc, (_hvel)
	add hl, bc
	ex de, hl
	ld bc, (_hvel + 2)
	adc hl, bc
	ex de, hl
	ld (_hvel), hl
	ld (_hvel + 2), de
.LABEL.__LABEL166:
	ld a, 2
	ld (_playerframe), a
	xor a
	ld (_playeranim), a
	ld hl, 32513
	call _MultiKeys
	ld d, a
	ld a, (_kemp)
	and 32
	sub 32
	sub 1
	sbc a, a
	or d
	jp z, .LABEL.__LABEL168
	ld a, 1
	ld (_nojump), a
	ld a, (_jumpposition)
	ld l, a
	ld h, 0
	ex de, hl
	ld hl, .LABEL._jumptable
	add hl, de
	ld a, (hl)
	ld (_jumpvalue), a
	ld a, 2
	ld (_pldy), a
.LABEL.__LABEL168:
	ld hl, (_ply - 1)
	ld a, (_jumpvalue)
	add a, h
	ld (_ply), a
	ld hl, _jumpposition
	inc (hl)
	ld a, 15
	ld hl, (_jumpposition - 1)
	cp h
	jp nc, .LABEL.__LABEL164
	ld a, 3
	ld (_jumptrigger), a
.LABEL.__LABEL164:
	ld a, (_playersprite)
	cp 2
	sbc a, a
	ld h, a
	ld a, (_playeranim)
	or a
	jr z, .LABEL.__LABEL319
	ld a, h
.LABEL.__LABEL319:
	or a
	jp z, .LABEL.__LABEL172
	ld a, (_playerframe)
	sub 5
	jp nz, .LABEL.__LABEL173
	xor a
	ld (_playerframe), a
	ld a, 1
	ld hl, (_playersprite - 1)
	sub h
	ld (_playersprite), a
	jp .LABEL.__LABEL172
.LABEL.__LABEL173:
	ld hl, _playerframe
	inc (hl)
.LABEL.__LABEL172:
	ld a, (_globalframetimer)
	sub 8
	jp nz, .LABEL.__LABEL175
	xor a
	ld (_globalframetimer), a
	ld a, 1
	ld hl, (_globalframe - 1)
	sub h
	ld (_globalframe), a
	call _PalCycle
	jp .LABEL.__LABEL176
.LABEL.__LABEL175:
	ld hl, _globalframetimer
	inc (hl)
.LABEL.__LABEL176:
	ld a, (_sword)
	sub 2
	jp nz, _ReadKeys__leave
	ld hl, _swordframe
	inc (hl)
	ld a, 3
	ld hl, (_swordframe - 1)
	cp h
	jp nc, _ReadKeys__leave
	ld a, 1
	ld (_sword), a
_ReadKeys__leave:
	ret
_UpdatePlayer:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	xor a
	push af
	ld a, (_attr3)
	push af
	ld a, (_playersprite)
	push af
	ld a, 62
	push af
	ld a, (_ply)
	push af
	ld hl, (_plx)
	push hl
	call _UpdateSprite
	xor a
	ld hl, (_sword - 1)
	cp h
	jp nc, _UpdatePlayer__leave
	ld a, (_attr3)
	or a
	jp z, .LABEL.__LABEL183
	ld hl, (_plx)
	ld de, -8
	add hl, de
	ld (ix-2), l
	ld (ix-1), h
	jp .LABEL.__LABEL184
.LABEL.__LABEL183:
	ld hl, (_plx)
	ld de, 8
	add hl, de
	ld (ix-2), l
	ld (ix-1), h
.LABEL.__LABEL184:
	xor a
	push af
	ld a, (_attr3)
	push af
	ld a, (_swordframe)
	add a, 16
	push af
	ld a, 63
	push af
	ld a, (_ply)
	push af
	ld l, (ix-2)
	ld h, (ix-1)
	push hl
	call _UpdateSprite
_UpdatePlayer__leave:
	ld sp, ix
	pop ix
	ret
_pokeBank:
#line 896 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"


	exx : pop hl  : exx


		nextreg $50,a
		pop     af
		ld      (hl),a
		nextreg $50,$ff
	exx : push hl : exx

#line 907 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_pokeBank__leave:
	ret
_SetUpNPC:
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
	xor a
	ld (_diamonds), a
	ld (ix-4), 0
	jp .LABEL.__LABEL185
.LABEL.__LABEL188:
	ld hl, 0
	push hl
	ld a, (ix-4)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	ld (hl), 0
	xor a
	push af
	ld a, (ix-4)
	push af
	call _RemoveSprite
	inc (ix-4)
.LABEL.__LABEL185:
	ld a, 63
	cp (ix-4)
	jp nc, .LABEL.__LABEL188
	ld (ix-5), 0
	jp .LABEL.__LABEL190
.LABEL.__LABEL193:
	ld (ix-6), 0
	jp .LABEL.__LABEL195
.LABEL.__LABEL198:
	ld a, 40
	push af
	ld a, 80
	call _NextRegA
	ld l, (ix-8)
	ld h, (ix-7)
	ld a, (hl)
	ld (ix-3), a
	ld (ix-1), 0
	ld (ix-2), 0
	sub 16
	jp nz, .LABEL.__LABEL200
	ld (ix-3), 8
	xor a
	ld (hl), a
	ld (ix-2), 2
	jp .LABEL.__LABEL201
.LABEL.__LABEL200:
	ld a, (ix-3)
	sub 15
	jp nz, .LABEL.__LABEL202
	ld (ix-3), 10
	jp .LABEL.__LABEL201
.LABEL.__LABEL202:
	ld a, (ix-3)
	dec a
	jp nz, .LABEL.__LABEL204
	ld a, (ix-5)
	ld l, a
	ld h, 0
	ld de, 20
	call .core.__MUL16_FAST
	push hl
	ld a, (ix-6)
	ld l, a
	ld h, 0
	srl h
	rr l
	ex de, hl
	pop hl
	add hl, de
	push hl
	ld a, 8
	push af
	ld a, 54
	call _pokeBank
	ld hl, _diamonds
	inc (hl)
	ld (ix-3), 0
	jp .LABEL.__LABEL201
.LABEL.__LABEL204:
	ld a, (ix-3)
	sub 19
	jp nz, .LABEL.__LABEL206
	xor a
	ld (hl), a
	ld (ix-3), 16
	jp .LABEL.__LABEL201
.LABEL.__LABEL206:
	ld a, (ix-3)
	sub 96
	jp nz, .LABEL.__LABEL208
	ld a, (ix-6)
	add a, a
	add a, a
	add a, a
	ld l, a
	ld h, 0
	ld (_startx), hl
	ld a, (ix-5)
	add a, a
	add a, a
	add a, a
	ld (_starty), a
	jp .LABEL.__LABEL201
.LABEL.__LABEL208:
	ld (ix-3), 0
.LABEL.__LABEL201:
	ld a, (ix-3)
	ld h, a
	xor a
	cp h
	jp nc, .LABEL.__LABEL211
	ld l, (ix-8)
	ld h, (ix-7)
	ld (hl), a
	ld a, (ix-3)
	cp 96
	jp nc, .LABEL.__LABEL211
	ld a, (ix-2)
	push af
	ld a, (ix-1)
	push af
	ld a, (ix-3)
	push af
	push af
	ld a, (ix-5)
	push af
	ld a, (ix-6)
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	push hl
	call _AddNewSprite
.LABEL.__LABEL211:
	ld l, (ix-8)
	ld h, (ix-7)
	inc hl
	ld (ix-8), l
	ld (ix-7), h
	inc (ix-6)
.LABEL.__LABEL195:
	ld a, 39
	cp (ix-6)
	jp nc, .LABEL.__LABEL198
	inc (ix-5)
.LABEL.__LABEL190:
	ld a, 63
	cp (ix-5)
	jp nc, .LABEL.__LABEL193
	ld a, 255
	push af
	ld a, 80
	call _NextRegA
	ld hl, _diamonds
	dec (hl)
_SetUpNPC__leave:
	ld sp, ix
	pop ix
	ret
_PalCycle:
#line 974 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"


		CCOUNT EQU 3
		PROC
		local loadpal, palloop
	pop hl : exx
loadpal:
		ld de,palbuffdiamond

		ld a,(de)
		push af
		ld hl,palbuffdiamond+1
		ld de,palbuffdiamond
		ld bc,CCOUNT-1
		ldir
		pop af
		ld (de),a

		ld hl,palbuffdiamond

		ld b,CCOUNT
		ld a,1
palloop:

		nextreg PALETTE_INDEX_NR_40,a
		ld d,a
		ld a,(hl)
		nextreg $41,a

		inc hl

		ld a,d
		inc a
		djnz palloop
	exx : push hl
		ENDP

#line 1011 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_PalCycle__leave:
	ret
_UpdateSprites:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, -29
	add hl, sp
	ld sp, hl
	ld (hl), 0
	ld bc, 28
	ld d, h
	ld e, l
	inc de
	ldir
	ld a, 7
	call .core.BORDER
	ld a, 2
	call .core.BORDER
	ld (ix-9), 0
	ld (ix-2), 0
.LABEL.__LABEL214:
	ld a, (ix-2)
	cp 31
	jp nc, _UpdateSprites__leave
	add a, a
	add a, a
	add a, a
	ld l, a
	ld h, 0
	ex de, hl
	ld hl, (_ospraddress)
	add hl, de
	ld (ix-29), l
	ld (ix-28), h
	ld a, (hl)
	ld (ix-15), a
	and 1
	dec a
	jp nz, .LABEL.__LABEL217
	ld (ix-8), 0
	ld (ix-9), 0
	inc hl
	ld a, (hl)
	ld l, a
	ld h, 0
	ld (ix-17), l
	ld (ix-16), h
	ld a, (ix-15)
	sub 3
	jp nz, .LABEL.__LABEL219
	ld de, 255
	add hl, de
	ld (ix-17), l
	ld (ix-16), h
.LABEL.__LABEL219:
	ld l, (ix-29)
	ld h, (ix-28)
	inc hl
	inc hl
	ld a, (hl)
	ld (ix-1), a
	push af
	ld a, (_lineno)
	add a, 28
	ld h, a
	pop af
	cp h
	sbc a, a
	push af
	ld a, (ix-1)
	push af
	ld a, (_lineno)
	inc a
	ld h, a
	pop af
	sub h
	ccf
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL324
	ld a, h
.LABEL.__LABEL324:
	or a
	jp z, .LABEL.__LABEL220
	ld a, (_lineno)
	sub 32
	add a, a
	add a, a
	add a, a
	neg
	ld hl, (_scrolly - 1)
	sub h
	ld (ix-12), a
	ld a, (ix-1)
	add a, a
	add a, a
	add a, a
	ld (ix-4), a
	ld l, (ix-29)
	ld h, (ix-28)
	ld de, 4
	add hl, de
	ld a, (hl)
	ld (ix-3), a
	ld l, (ix-29)
	ld h, (ix-28)
	inc de
	add hl, de
	ld a, (hl)
	ld (ix-10), a
	ld l, (ix-29)
	ld h, (ix-28)
	ld de, 7
	add hl, de
	ld a, (hl)
	ld (ix-5), a
	ld a, (ix-10)
	sub 10
	jp nz, .LABEL.__LABEL223
	ld a, (ix-5)
	or a
	jp nz, .LABEL.__LABEL224
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, -16
	add hl, de
	ex de, hl
	ld hl, (_plx)
	or a
	sbc hl, de
	ccf
	sbc a, a
	push af
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, 16
	add hl, de
	ld de, (_plx)
	or a
	sbc hl, de
	ccf
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL325
	ld a, h
.LABEL.__LABEL325:
	or a
	jp z, .LABEL.__LABEL223
	ld a, (ix-12)
	add a, (ix-4)
	sub 64
	ld h, a
	ld a, (_ply)
	sub h
	ccf
	sbc a, a
	push af
	ld a, (ix-12)
	add a, (ix-4)
	add a, 6
	ld hl, (_ply - 1)
	sub h
	ccf
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL326
	ld a, h
.LABEL.__LABEL326:
	or a
	jp z, .LABEL.__LABEL223
	ld l, (ix-29)
	ld h, (ix-28)
	ld de, 7
	add hl, de
	ld a, 2
	ld (hl), a
.LABEL.__LABEL227:
	jp .LABEL.__LABEL223
.LABEL.__LABEL224:
	ld a, 1
	cp (ix-5)
	jp nc, .LABEL.__LABEL223
	inc (ix-5)
	ld a, 8
	cp (ix-5)
	jp nc, .LABEL.__LABEL233
	inc (ix-3)
	ld (ix-5), 2
	ld a, 15
	cp (ix-3)
	jp nc, .LABEL.__LABEL234
	ld (ix-3), 10
	ld (ix-5), 0
	jp .LABEL.__LABEL235
.LABEL.__LABEL234:
	ld a, (ix-3)
	sub 11
	jp nz, .LABEL.__LABEL235
	ld a, 9
	call _PlaySFX
.LABEL.__LABEL235:
	ld l, (ix-29)
	ld h, (ix-28)
	ld de, 4
	add hl, de
	ld a, (ix-3)
	ld (hl), a
.LABEL.__LABEL233:
	ld l, (ix-29)
	ld h, (ix-28)
	ld de, 7
	add hl, de
	ld a, (ix-5)
	ld (hl), a
.LABEL.__LABEL223:
	ld a, (ix-10)
	sub 8
	jp nz, .LABEL.__LABEL239
	ld l, (ix-29)
	ld h, (ix-28)
	ld de, 6
	add hl, de
	ld a, (hl)
	ld (ix-6), a
	ld l, (ix-29)
	ld h, (ix-28)
	inc de
	add hl, de
	ld a, (hl)
	ld (ix-7), a
	ld a, (ix-6)
	or a
	jp nz, .LABEL.__LABEL240
	ld l, (ix-17)
	ld h, (ix-16)
	dec hl
	ld (ix-17), l
	ld (ix-16), h
	ld de, 8
	add hl, de
	ld b, 3
.LABEL.__LABEL327:
	srl h
	rr l
	djnz .LABEL.__LABEL327
	ld de, 40
	add hl, de
	ld (ix-21), l
	ld (ix-20), h
	ld a, (ix-12)
	add a, (ix-4)
	srl a
	srl a
	srl a
	inc a
	ld (ix-11), a
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	ld de, 16384
	add hl, de
	push hl
	ld l, (ix-21)
	ld h, (ix-20)
	ex de, hl
	pop hl
	add hl, de
	ld (ix-19), l
	ld (ix-18), h
	ld de, 40
	add hl, de
	ld a, (hl)
	ld (ix-9), a
	cp 25
	sbc a, a
	push af
	ld l, (ix-19)
	ld h, (ix-18)
	ld de, -41
	add hl, de
	pop de
	ld a, 25
	cp (hl)
	sbc a, a
	or d
	jp z, .LABEL.__LABEL243
	ld l, (ix-17)
	ld h, (ix-16)
	inc hl
	ld (ix-17), l
	ld (ix-16), h
	ld (ix-6), 1
.LABEL.__LABEL243:
	ld (ix-8), 0
	jp .LABEL.__LABEL241
.LABEL.__LABEL240:
	ld a, (ix-6)
	dec a
	jp nz, .LABEL.__LABEL244
	ld l, (ix-17)
	ld h, (ix-16)
	inc hl
	ld (ix-17), l
	ld (ix-16), h
	ld de, 16
	add hl, de
	ld b, 3
.LABEL.__LABEL329:
	srl h
	rr l
	djnz .LABEL.__LABEL329
	ld de, 40
	add hl, de
	ld (ix-23), l
	ld (ix-22), h
	ld a, (ix-12)
	add a, (ix-4)
	srl a
	srl a
	srl a
	inc a
	ld (ix-11), a
	ld l, a
	ld h, 0
	ld de, 40
	call .core.__MUL16_FAST
	ld de, 16384
	add hl, de
	push hl
	ld l, (ix-23)
	ld h, (ix-22)
	ex de, hl
	pop hl
	add hl, de
	ld (ix-19), l
	ld (ix-18), h
	ld de, 39
	add hl, de
	ld a, (hl)
	ld (ix-9), a
	ld (ix-8), 8
	cp 25
	sbc a, a
	push af
	ld l, (ix-19)
	ld h, (ix-18)
	ld de, -41
	add hl, de
	pop de
	ld a, 25
	cp (hl)
	sbc a, a
	or d
	jp z, .LABEL.__LABEL241
	ld (ix-6), 0
	ld l, (ix-17)
	ld h, (ix-16)
	dec hl
	ld (ix-17), l
	ld (ix-16), h
.LABEL.__LABEL247:
	jp .LABEL.__LABEL241
.LABEL.__LABEL244:
	ld a, (ix-6)
	sub 2
	jp nz, .LABEL.__LABEL241
	ld (ix-6), 3
	xor a
	push af
	ld a, (ix-2)
	push af
	call _RemoveSprite
	ld a, (ix-2)
	push af
	ld a, (ix-4)
	add a, (ix-12)
	push af
	ld l, (ix-17)
	ld h, (ix-16)
	push hl
	call _AddThrowbaddy
	ld l, (ix-29)
	ld h, (ix-28)
	xor a
	ld (hl), a
.LABEL.__LABEL241:
	ld a, (_globalframe)
	add a, (ix-3)
	ld (ix-3), a
	ld l, (ix-29)
	ld h, (ix-28)
	ld de, 6
	add hl, de
	ld a, (ix-6)
	ld (hl), a
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, 255
	or a
	sbc hl, de
	ccf
	jp nc, .LABEL.__LABEL250
	ld l, (ix-29)
	ld h, (ix-28)
	ld a, 3
	ld (hl), a
	inc hl
	push hl
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, -255
	add hl, de
	ld a, l
	pop hl
	ld (hl), a
	jp .LABEL.__LABEL239
.LABEL.__LABEL250:
	ld l, (ix-29)
	ld h, (ix-28)
	ld a, 1
	ld (hl), a
	inc hl
	push hl
	ld l, (ix-17)
	ld a, l
	pop hl
	ld (hl), a
.LABEL.__LABEL239:
	ld a, (_dead)
	or a
	jp nz, .LABEL.__LABEL253
	ld a, (ix-10)
	sub 8
	sub 1
	sbc a, a
	ld d, a
	ld a, (ix-10)
	sub 10
	sub 1
	sbc a, a
	or d
	jp z, .LABEL.__LABEL253
	ld a, (_sword)
	sub 2
	jp nz, .LABEL.__LABEL256
	ld a, 18
	ld (_ssize), a
	ld hl, (_plx)
	inc hl
	ld (ix-25), l
	ld (ix-24), h
	ld l, (ix-17)
	ld h, (ix-16)
	ld (ix-27), l
	ld (ix-26), h
	ld a, (_ply)
	ld (ix-14), a
	ld a, (ix-12)
	add a, (ix-4)
	inc a
	ld (ix-13), a
	jp .LABEL.__LABEL257
.LABEL.__LABEL256:
	ld a, 14
	ld (_ssize), a
	ld hl, (_plx)
	inc hl
	ld (ix-25), l
	ld (ix-24), h
	ld l, (ix-17)
	ld h, (ix-16)
	ld (ix-27), l
	ld (ix-26), h
	ld a, (_ply)
	ld (ix-14), a
	ld a, (ix-12)
	add a, (ix-4)
	inc a
	ld (ix-13), a
.LABEL.__LABEL257:
	ld l, (ix-25)
	ld h, (ix-24)
	push hl
	ld a, (_ssize)
	ld l, a
	ld h, 0
	ex de, hl
	pop hl
	add hl, de
	push hl
	ld l, (ix-27)
	ld h, (ix-26)
	ex de, hl
	pop hl
	or a
	sbc hl, de
	sbc a, a
	push af
	ld l, (ix-25)
	ld h, (ix-24)
	push hl
	ld l, (ix-27)
	ld h, (ix-26)
	push hl
	ld a, (_ssize)
	ld l, a
	ld h, 0
	ex de, hl
	pop hl
	add hl, de
	ex de, hl
	pop hl
	or a
	sbc hl, de
	pop de
	ccf
	sbc a, a
	or d
	ld d, a
	ld a, (_ssize)
	add a, (ix-14)
	cp (ix-13)
	sbc a, a
	or d
	push af
	ld a, (ix-14)
	push af
	ld a, (_ssize)
	add a, (ix-13)
	ld h, a
	pop af
	pop de
	sub h
	ccf
	sbc a, a
	or d
	jp nz, .LABEL.__LABEL259
	ld a, 2
	call .core.BORDER
	ld a, (ix-10)
	sub 8
	jp nz, .LABEL.__LABEL260
	ld a, (_sword)
	or a
	jp nz, .LABEL.__LABEL262
	ld l, (ix-17)
	ld h, (ix-16)
	ex de, hl
	ld hl, (_plx)
	or a
	sbc hl, de
	ccf
	jp nc, .LABEL.__LABEL264
	ld a, 6
	ld (_pright), a
	xor a
	ld (_pleft), a
	jp .LABEL.__LABEL265
.LABEL.__LABEL264:
	ld hl, (_plx)
	ld de, -8
	add hl, de
	ld d, h
	ld e, l
	ld l, (ix-17)
	ld h, (ix-16)
	or a
	sbc hl, de
	ccf
	jp nc, .LABEL.__LABEL265
	ld a, 6
	ld (_pleft), a
	xor a
	ld (_pright), a
.LABEL.__LABEL265:
	ld a, (_fx_ow)
	or a
	jp nz, .LABEL.__LABEL268
	ld a, 3
	call _PlayCopperSample
	ld a, 5
	ld (_fx_ow), a
	jp .LABEL.__LABEL259
.LABEL.__LABEL268:
	ld hl, _fx_ow
	dec (hl)
.LABEL.__LABEL269:
	jp .LABEL.__LABEL259
.LABEL.__LABEL262:
	xor a
	ld hl, (_sword - 1)
	cp h
	jp nc, .LABEL.__LABEL259
	ld hl, (_plx)
	inc hl
	inc hl
	push hl
	ld l, (ix-17)
	ld h, (ix-16)
	ex de, hl
	pop hl
	or a
	sbc hl, de
	ccf
	jp nc, .LABEL.__LABEL272
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, -12
	add hl, de
	ld (ix-17), l
	ld (ix-16), h
	jp .LABEL.__LABEL273
.LABEL.__LABEL272:
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, (_plx)
	or a
	sbc hl, de
	ccf
	jp nc, .LABEL.__LABEL273
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, 8
	add hl, de
	ld (ix-17), l
	ld (ix-16), h
.LABEL.__LABEL273:
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, 255
	or a
	sbc hl, de
	ccf
	jp nc, .LABEL.__LABEL276
	ld l, (ix-29)
	ld h, (ix-28)
	ld a, 3
	ld (hl), a
	inc hl
	push hl
	ld l, (ix-17)
	ld h, (ix-16)
	ld de, -255
	add hl, de
	ld a, l
	pop hl
	ld (hl), a
	jp .LABEL.__LABEL277
.LABEL.__LABEL276:
	ld l, (ix-29)
	ld h, (ix-28)
	ld a, 1
	ld (hl), a
	inc hl
	push hl
	ld l, (ix-17)
	ld a, l
	pop hl
	ld (hl), a
.LABEL.__LABEL277:
	ld a, (ix-7)
	ld h, a
	xor a
	cp h
	jp nc, .LABEL.__LABEL278
	dec (ix-7)
	ld a, 11
	call _PlaySFX
	ld l, (ix-29)
	ld h, (ix-28)
	ld de, 7
	add hl, de
	ld a, (ix-7)
	ld (hl), a
	jp .LABEL.__LABEL279
.LABEL.__LABEL278:
	ld a, (ix-7)
	or a
	jp nz, .LABEL.__LABEL279
	ld a, 12
	call _PlaySFX
	xor a
	push af
	ld a, (ix-2)
	push af
	call _RemoveSprite
	ld l, (ix-29)
	ld h, (ix-28)
	xor a
	ld (hl), a
	ld de, 7
	add hl, de
	ld (hl), a
.LABEL.__LABEL279:
	ld a, (ix-6)
	sub 2
	jp nz, .LABEL.__LABEL259
	ld a, 12
	call _PlaySFX
	ld (ix-6), 0
	ld a, (ix-2)
	push af
	ld a, (ix-4)
	push af
	ld l, (ix-17)
	ld h, (ix-16)
	push hl
	call _AddThrowbaddy
.LABEL.__LABEL263:
	jp .LABEL.__LABEL259
.LABEL.__LABEL260:
	ld a, (ix-10)
	sub 10
	jp nz, .LABEL.__LABEL259
	ld a, 10
	cp (ix-3)
	sbc a, a
	push af
	ld a, (ix-3)
	cp 13
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL331
	ld a, h
.LABEL.__LABEL331:
	or a
	jp z, .LABEL.__LABEL259
	ld a, 1
	ld (_dead), a
	ld a, 2
	ld (_pldy), a
	ld (_jumptrigger), a
	ld a, (_fx_ow)
	or a
	jp nz, .LABEL.__LABEL288
	ld a, 3
	call _PlayCopperSample
	ld a, 5
	ld (_fx_ow), a
	jp .LABEL.__LABEL259
.LABEL.__LABEL288:
	ld hl, _fx_ow
	dec (hl)
.LABEL.__LABEL259:
	xor a
	call .core.BORDER
.LABEL.__LABEL253:
	ld l, (ix-29)
	ld h, (ix-28)
	ld a, (hl)
	ld h, a
	xor a
	cp h
	jp nc, .LABEL.__LABEL217
	xor a
	push af
	ld a, (ix-8)
	push af
	ld a, (ix-3)
	push af
	ld a, (ix-2)
	push af
	ld a, (ix-12)
	add a, (ix-4)
	push af
	ld l, (ix-17)
	ld h, (ix-16)
	push hl
	call _UpdateSprite
.LABEL.__LABEL291:
	jp .LABEL.__LABEL217
.LABEL.__LABEL220:
	xor a
	push af
	ld a, (ix-2)
	push af
	call _RemoveSprite
.LABEL.__LABEL217:
	inc (ix-2)
	jp .LABEL.__LABEL214
_UpdateSprites__leave:
	ld sp, ix
	pop ix
	ret
_AddNewSprite:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
.LABEL.__LABEL292:
	ld hl, 0
	push hl
	ld a, (ix-1)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	ld a, (hl)
	and 1
	dec a
	sub 1
	sbc a, a
	push af
	ld a, (ix-1)
	cp 32
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL332
	ld a, h
.LABEL.__LABEL332:
	or a
	jp z, .LABEL.__LABEL293
	inc (ix-1)
	jp .LABEL.__LABEL292
.LABEL.__LABEL293:
	ld a, (ix-1)
	cp 32
	jp nc, _AddNewSprite__leave
	ld l, (ix+4)
	ld h, (ix+5)
	ex de, hl
	ld hl, 255
	or a
	sbc hl, de
	jp nc, .LABEL.__LABEL296
	ld (ix-2), 3
	jp .LABEL.__LABEL297
.LABEL.__LABEL296:
	ld (ix-2), 1
.LABEL.__LABEL297:
	ld a, (ix-2)
	push af
	ld hl, 0
	push hl
	ld a, (ix-1)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	pop af
	ld (hl), a
	ld l, (ix+4)
	ld a, l
	push af
	ld hl, 1
	push hl
	ld a, (ix-1)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	pop af
	ld (hl), a
	ld a, (ix+7)
	push af
	ld hl, 2
	push hl
	ld a, (ix-1)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	pop af
	ld (hl), a
	ld a, (ix-1)
	push af
	ld hl, 3
	push hl
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	pop af
	ld (hl), a
	ld a, (ix+9)
	push af
	ld hl, 4
	push hl
	ld a, (ix-1)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	pop af
	ld (hl), a
	ld a, (ix+11)
	push af
	ld hl, 5
	push hl
	ld a, (ix-1)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	pop af
	ld (hl), a
	ld a, (ix+13)
	push af
	ld hl, 6
	push hl
	ld a, (ix-1)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	pop af
	ld (hl), a
	ld a, (ix+15)
	push af
	ld hl, 7
	push hl
	ld a, (ix-1)
	ld l, a
	push hl
	ld hl, _aSprites
	call .core.__ARRAY
	pop af
	ld (hl), a
_AddNewSprite__leave:
	exx
	ld hl, 12
	jp __EXIT_FUNCTION
_SetupTileHW:
#line 1324 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"


	exx : pop hl : exx : push af

		nextreg PALETTE_CONTROL_NR_43,%00110001

		ld hl,palbuff
		ld b,16*2
_tmuploadloop:
	ld a,(hl) : nextreg PALETTE_VALUE_9BIT_NR_44,a
		inc hl
		djnz _tmuploadloop

		ld 		hl,palbuff+2
		ld 		de,palbuffdiamond
		ld		bc,32
		ldir


		nextreg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000

		pop af
		nextreg TILEMAP_BASE_ADR_NR_6E,a
		pop af
		nextreg TILEMAP_GFX_ADR_NR_6F,a

		nextreg ULA_CONTROL_NR_68,%10100000
		nextreg GLOBAL_TRANSPARENCY_NR_14,0
		nextreg TILEMAP_TRANSPARENCY_I_NR_4C,$0
		pop af

		nextreg MMU2_4000_NR_52,41
		ld hl,$4000
		ld de,$6000
		ld bc,3104
		ldir

		nextreg MMU2_4000_NR_52,$0a
		ld hl,map
		ld de,$4000
		ld bc,80*40
		ldir

	exx : push hl : exx

#line 1369 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
	ld a, 255
	push af
	xor a
	push af
	ld a, 255
	push af
	xor a
	push af
	call _ClipTile
_SetupTileHW__leave:
	ret
_CopyToBanks:
#line 1392 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

	exx : pop hl : exx


		call _checkints
		di
		ld c,a
		pop de
		ld e,c
		pop af
		ld b,a

copybankloop:
	push bc : push de
	ld a,e : nextreg $50,a : ld a,d : nextreg $51,a





		ld hl,$0000
		ld de,$2000
		ld bc,$2000
		ldir
	pop de : pop bc
	inc d : inc e
		djnz copybankloop

	nextreg $50,$ff : nextreg $51,$ff

	ld a,(.itbuff) : or a : jr z,$+3 : ei
#line 1422
	exx : push hl : exx


#line 1427 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_CopyToBanks__leave:
	ret
_InitCopperAudio:
#line 1457 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"


		ld		bc,TBBLUE_REGISTER_SELECT_P_243B
		ld		a,VIDEO_TIMING_NR_11
		out		(c),a
		inc		b
		in		a,(c)
		and		7
		ld		(.CopperSample.video_timing),a

		nextreg	COPPER_CONTROL_LO_NR_61,$00
		nextreg	COPPER_CONTROL_HI_NR_62,$00
		nextreg	COPPER_DATA_NR_60,$FF
		nextreg	COPPER_DATA_NR_60,$FF

		ld		a,SOUNDDRIVE_DF_MIRROR_NR_2D
		ld		(.CopperSample.sample_dac),a


#line 1476 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_InitCopperAudio__leave:
	ret
_PlayCopperSample:
#line 1480 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"





		ld 		hl,copper_sample_table
		ld 		e,a
		ld 		d,6
		mul 	d,e
		add 	hl,de
		ld		(.playerstack+1),sp
		ld 		sp,hl

		pop 	hl
		ld		(.CopperSample.sample_loop),hl

		pop 	hl
		ld		(.CopperSample.sample_ptr),hl

		pop 	hl
		ld		(.CopperSample.sample_len),hl

		ld		hl,0
		ld		(.CopperSample.sample_pos),hl

		ld		a,SOUNDDRIVE_DF_MIRROR_NR_2D
		ld		(.CopperSample.sample_dac),a

playerstack:
		ld 		sp,0



#line 1513 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_PlayCopperSample__leave:
	ret
_SetCopperAudio:
#line 1517 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"





		call CopperSample.set_copper_audio



#line 1526 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_SetCopperAudio__leave:
	ret
_PlayCopperAudio:
#line 1531 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"







		call CopperSample.play_copper_audio




#line 1543 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_PlayCopperAudio__leave:
	ret
_CopperSample:
#line 1575 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

		push namespace CopperSample











		PERIPHERAL_1_REGISTER			equ	$05
		TURBO_CONTROL_REGISTER			equ	$07

		RASTER_LINE_MSB_REGISTER		equ	$1E
		RASTER_LINE_LSB_REGISTER		equ	31
		SOUNDDRIVE_MIRROR_REGISTER		equ	$2D
		COPPER_DATA						equ	$60
		COPPER_CONTROL_LO_BYTE_REGISTER	equ	$61
		COPPER_CONTROL_HI_BYTE_REGISTER	equ	$62
		CONFIG1 						equ $05
		COPHI							equ $62
		COPLO							equ $61
		SELECT							equ $243b
		SAMPLEBANK						equ 32


set_copper_audio:


		ld		(.stack+1),sp

		ld		ix,copper_loop

		ld		bc,SELECT
		ld		a,CONFIG1
		out		(c),a
		inc		b
		in		a,(c)

		ld		hl,hdmi_50_config
		ld		de,vga_50_config
		bit		2,a
		jr		z,.refresh
		ld		hl,hdmi_60_config
		ld		de,vga_60_config
	.refresh:
		ld		a,(video_timing)
		cp		7
		jr		z,.hdmi
		ex		de,hl
	.hdmi:
		ld		a,(hl)
		inc		hl
		ld		(.return+1),a

		ld		sp,hl





		ld		hl,(sample_len)
		ld		bc,(sample_pos)
		xor		a
		sbc		hl,bc

		ld		b,h
		ld		c,l

		pop		hl
		ld		(video_lines),hl

		ld		a,h
		cpl
		ld		h,a
		ld		a,l
		cpl
		ld		l,a
		inc		hl

		ld		a,20

		add		hl,bc
		jp		c,.no_loop





		ld		a,c
		and		%11110000
		or		b
		swapnib
	.no_loop:
		ld		b,a

		ld		a,c
		and		%00001111
		ld		c,a



		ld		hl,.zone+1
		pop		de
		ld		(hl),e
		ld		a,d

		pop		hl

		ld		(copper_audio_config+1),sp

		ld		sp,copper_audio_stack

		cp		b
		jr		nz,.skip

		ex		af,af'

		ld		e,c
		ld		d,9
		mul		d,e
		ld		a,144
		sub		e

		add		hl,de
		push	hl
		push	ix
		ld		de,copper_out16
		add		de,a
		push	de

		ex		af,af'

		jr		.next



	.skip:
		push	hl



	.next:
		ld		hl,copper_out16
		dec		a

	.zone:
		cp		7
		jp		nz,.no_split

		ld		de,copper_split
		push	de
	.no_split:
		cp		b
		jp		nz,.no_zone

		ex		af,af'

		ld		e,c
		ld		d,9
		mul		d,e
		ld		a,144
		sub		e

		add		de,copper_out16
		push	de
		push	ix
		ld		de,copper_out16
		add		de,a
		push	de

		ex		af,af'

		jr		.zone_next

	.no_zone:
		push	hl

		.zone_next
		dec		a
		jp		p,.zone

		ld		(copper_audio_control+1),sp

		.return
		ld		a,0

		.stack
		ld		sp,0

		ret












play_copper_audio:


	db $3e,$50,$01,$3b,$24,$ed,$79,$04,$ed,$78 : ld (playbankout+3),a
#line 1784

	db $3e,$51,$01,$3b,$24,$ed,$79,$04,$ed,$78 : ld (playbankout+7),a
#line 1785

		ld 			a,(sample_bank)
		nextreg 	$50,a
		inc 		a
		nextreg 	$51,a

		call 		play_copper_audio2

playbankout:
		nextreg 	$50,$ff
		nextreg 	$51,$ff

		ret

play_copper_audio2:

		ld			(play_copper_stack+1),sp

copper_audio_config:

		ld		sp,0

		pop		hl
		pop		de

		ld		a,l
		nextreg	COPLO,a
		ld		a,h
		nextreg	COPHI,a

		ld		hl,(sample_ptr)
		ld		bc,(sample_pos)
		add		hl,bc

		ld		bc,SELECT
		ld		a,COPPER_DATA
		out		(c),a
		inc		b

		ld		a,(sample_dac)

copper_audio_control:
		ld		sp,0

		ret



copper_out16:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1838
		inc		de
copper_out15:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1844
		inc		de
copper_out14:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1850
		inc		de
copper_out13:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1856
		inc		de
copper_out12:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1862
		inc		de
copper_out11:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1868
		inc	de
copper_out10:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1874
		inc		de
copper_out9:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1880
		inc		de
copper_out8:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1886
		inc		de
copper_out7:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1892
		inc		de
copper_out6:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1898
		inc		de
copper_out5:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1904
		inc		de
copper_out4:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1910
		inc		de
copper_out3:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1916
		inc	de
copper_out2:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1922
		inc		de
copper_out1:
		out		(c),d
		out		(c),e
		out		(c),a

		Dw $90ED
#line 1928
		inc		de
copper_out0:

		ret



copper_split:
		out		(c),d
		out		(c),e
		ld		de,32768+0
		nextreg	COPPER_CONTROL_LO_BYTE_REGISTER,$00
		nextreg	COPPER_CONTROL_HI_BYTE_REGISTER,$C0
		ret


copper_loop:
		ld		hl,sample_dac
		ld		a,(sample_loop)
		and		a
		jr		z,.forever
		dec		a
		jr		nz,.loop
		ld		(hl),0

	.loop:
		ld		(sample_loop),a

	.forever:
		ld		a,(hl)
		ld		hl,(sample_ptr)
		ret



copper_done:
		ld		de,(sample_ptr)
		xor		a
		sbc		hl,de
		ld		(sample_pos),hl

play_copper_stack:
		ld		sp,0

		ret





vga_50_config:
		db		187
		dw		311
		db		6
		db		7+12
		dw		copper_out7
		db		$1C
		db		$C3
		dw		32768+199

vga_60_config:
		db		191
		dw		264
		db		3
		db		4+12
		dw		copper_out8
		db		$20
		db		$C3
		dw		32768+200

hdmi_50_config:
		db		186
		dw		312
		db		6
		db		7+12
		dw		copper_out8
		db		$20
		db		$C3
		dw		32768+200

hdmi_60_config:
		db		189
		dw		262
		db		3
		db		4+12
		dw		copper_out6
		db		$18
		db		$C3
		dw		32768+198








sample_ptr:		dw	0
sample_pos:		dw	0
sample_len:		dw	0
sample_dac:		db	0

sample_loop:    db	0
sample_bank:    db 	0

video_lines:	dw	0
video_timing:	db	0

		dw	0,0,0,0,0,0,0,0
		dw	0,0,0,0,0,0,0,0
		dw	0,0,0,0,0,0,0

copper_audio_stack:
		dw	copper_done
		pop namespace


#line 2081 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
_CopperSample__leave:
	ret
	;; --- end of user code ---
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/array.asm"
; vim: ts=4:et:sw=4:
	; Copyleft (K) by Jose M. Rodriguez de la Rosa
	;  (a.k.a. Boriel)
;  http://www.boriel.com
	; -------------------------------------------------------------------
	; Simple array Index routine
	; Number of total indexes dimensions - 1 at beginning of memory
	; HL = Start of array memory (First two bytes contains N-1 dimensions)
	; Dimension values on the stack, (top of the stack, highest dimension)
	; E.g. A(2, 4) -> PUSH <4>; PUSH <2>

	; For any array of N dimension A(aN-1, ..., a1, a0)
	; and dimensions D[bN-1, ..., b1, b0], the offset is calculated as
	; O = [a0 + b0 * (a1 + b1 * (a2 + ... bN-2(aN-1)))]
; What I will do here is to calculate the following sequence:
	; ((aN-1 * bN-2) + aN-2) * bN-3 + ...


#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/mul16.asm"
	    push namespace core

__MUL16:	; Mutiplies HL with the last value stored into de stack
	    ; Works for both signed and unsigned

	    PROC

	    ex de, hl
	    pop hl		; Return address
	    ex (sp), hl ; CALLEE caller convention

__MUL16_FAST:
	    ld a,d                      ; a = xh
	    ld d,h                      ; d = yh
	    ld h,a                      ; h = xh
	    ld c,e                      ; c = xl
	    ld b,l                      ; b = yl
	    mul d,e                     ; yh * yl
	    ex de,hl
	    mul d,e                     ; xh * yl
	    add hl,de                   ; add cross products
	    ld e,c
	    ld d,b
	    mul d,e                     ; yl * xl
	    ld a,l                      ; cross products lsb
	    add a,d                     ; add to msb final
	    ld h,a
	    ld l,e                      ; hl = final

	    ret	; Result in hl (16 lower bits)

	    ENDP

	    pop namespace
#line 20 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/array.asm"

#line 24 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/array.asm"

	    push namespace core

__ARRAY_PTR:   ;; computes an array offset from a pointer
	    ld c, (hl)
	    inc hl
	    ld h, (hl)
	    ld l, c

__ARRAY:
	    PROC

	    LOCAL LOOP
	    LOCAL ARRAY_END
	    LOCAL RET_ADDRESS ; Stores return address
	    LOCAL TMP_ARR_PTR ; Stores pointer temporarily

	    ld e, (hl)
	    inc hl
	    ld d, (hl)
	    inc hl
	    ld (TMP_ARR_PTR), hl
	    ex de, hl
	    ex (sp), hl	; Return address in HL, array address in the stack
	    ld (RET_ADDRESS + 1), hl ; Stores it for later

	    exx
	    pop hl		; Will use H'L' as the pointer
	    ld c, (hl)	; Loads Number of dimensions from (hl)
	    inc hl
	    ld b, (hl)
	    inc hl		; Ready
	    exx

	    ld hl, 0	; HL = Offset "accumulator"

LOOP:
#line 64 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/array.asm"
	    pop bc		; Get next index (Ai) from the stack

#line 74 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/array.asm"

	    add hl, bc	; Adds current index

	    exx			; Checks if B'C' = 0
	    ld a, b		; Which means we must exit (last element is not multiplied by anything)
	    or c
	    jr z, ARRAY_END		; if B'Ci == 0 we are done

	    ld e, (hl)			; Loads next dimension into D'E'
	    inc hl
	    ld d, (hl)
	    inc hl
	    push de
	    dec bc				; Decrements loop counter
	    exx
	    pop de				; DE = Max bound Number (i-th dimension)

	    call __MUL16_FAST
	    jp LOOP

ARRAY_END:
	    ld a, (hl)
	    exx

#line 103 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/array.asm"
	    LOCAL ARRAY_SIZE_LOOP

	    ex de, hl
	    ld hl, 0
	    ld b, a
ARRAY_SIZE_LOOP:
	    add hl, de
	    djnz ARRAY_SIZE_LOOP

#line 113 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/array.asm"

	    ex de, hl
	    ld hl, (TMP_ARR_PTR)
	    ld a, (hl)
	    inc hl
	    ld h, (hl)
	    ld l, a
	    add hl, de  ; Adds element start

RET_ADDRESS:
	    jp 0

	    ;; Performs a faster multiply for little 16bit numbs

TMP_ARR_PTR:
	    DW 0  ; temporary storage for pointer to tables

	    ENDP

	    pop namespace

#line 2086 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/border.asm"
	; __FASTCALL__ Routine to change de border
	; Parameter (color) specified in A register

	    push namespace core

	BORDER EQU 229Bh

	    pop namespace


	; Nothing to do! (Directly from the ZX Spectrum ROM)
#line 2087 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/cls.asm"
	;; Clears the user screen (24 rows)

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/sposn.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/sysvars.asm"
	;; -----------------------------------------------------------------------
	;; ZX Basic System Vars
	;; Some of them will be mapped over Sinclair ROM ones for compatibility
	;; -----------------------------------------------------------------------

	push namespace core

SCREEN_ADDR:        DW 16384  ; Screen address (can be pointed to other place to use a screen buffer)
SCREEN_ATTR_ADDR:   DW 22528  ; Screen attribute address (ditto.)

	; These are mapped onto ZX Spectrum ROM VARS

	CHARS	            EQU 23606  ; Pointer to ROM/RAM Charset
	TVFLAGS             EQU 23612  ; TV Flags
	UDG	                EQU 23675  ; Pointer to UDG Charset
	COORDS              EQU 23677  ; Last PLOT coordinates
	FLAGS2	            EQU 23681  ;
	ECHO_E              EQU 23682  ;
	DFCC                EQU 23684  ; Next screen addr for PRINT
	DFCCL               EQU 23686  ; Next screen attr for PRINT
	S_POSN              EQU 23688
	ATTR_P              EQU 23693  ; Current Permanent ATTRS set with INK, PAPER, etc commands
	ATTR_T	            EQU 23695  ; temporary ATTRIBUTES
	P_FLAG	            EQU 23697  ;
	MEM0                EQU 23698  ; Temporary memory buffer used by ROM chars

	SCR_COLS            EQU 33     ; Screen with in columns + 1
	SCR_ROWS            EQU 24     ; Screen height in rows
	SCR_SIZE            EQU (SCR_ROWS << 8) + SCR_COLS
	pop namespace
#line 2 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/sposn.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/attr.asm"
	; Attribute routines
; vim:ts=4:et:sw:


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
#line 6 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/attr.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/in_screen.asm"



	    push namespace core

__IN_SCREEN:
	    ; Returns NO carry if current coords (D, E)
	    ; are OUT of the screen limits

	    PROC
	    LOCAL __IN_SCREEN_ERR

	    ld hl, SCR_SIZE
	    ld a, e
	    cp l
	    jr nc, __IN_SCREEN_ERR	; Do nothing and return if out of range

	    ld a, d
	    cp h
	    ret c                       ; Return if carry (OK)

__IN_SCREEN_ERR:
__OUT_OF_SCREEN_ERR:
	    ; Jumps here if out of screen
	    ld a, ERROR_OutOfScreen
	    jp __STOP   ; Saves error code and exits

	    ENDP

	    pop namespace
#line 7 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/attr.asm"


	    push namespace core

__ATTR_ADDR:
	    ; calc start address in DE (as (32 * d) + e)
    ; Contributed by Santiago Romero at http://www.speccy.org
	    ld h, 0                     ;  7 T-States
	    ld a, d                     ;  4 T-States
	    ld d, h
	    add a, a     ; a * 2        ;  4 T-States
	    add a, a     ; a * 4        ;  4 T-States
	    ld l, a      ; HL = A * 4   ;  4 T-States

	    add hl, hl   ; HL = A * 8   ; 15 T-States
	    add hl, hl   ; HL = A * 16  ; 15 T-States
	    add hl, hl   ; HL = A * 32  ; 15 T-States
	    add hl, de

	    ld de, (SCREEN_ATTR_ADDR)    ; Adds the screen address
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

	    call __ATTR_ADDR

__SET_ATTR:
	    ; Internal __FASTCALL__ Entry used by printing routines
	    ; HL contains the address of the ATTR cell to set
	    PROC

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

	    pop namespace
#line 3 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/sposn.asm"

	; Printing positioning library.
	    push namespace core

	; Loads into DE current ROW, COL print position from S_POSN mem var.
__LOAD_S_POSN:
	    PROC

	    ld de, (S_POSN)
	    ld hl, SCR_SIZE
	    or a
	    sbc hl, de
	    ex de, hl
	    ret

	    ENDP


	; Saves ROW, COL from DE into S_POSN mem var.
__SAVE_S_POSN:
	    PROC

	    ld hl, SCR_SIZE
	    or a
	    sbc hl, de
	    ld (S_POSN), hl ; saves it again

__SET_SCR_PTR:  ;; Fast
	    push de
	    call __ATTR_ADDR
	    ld (DFCCL), hl
	    pop de

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

	    ld hl, (SCREEN_ADDR)
	    add hl, de    ; HL = Screen address + DE
	    ld (DFCC), hl
	    ret

	    ENDP

	    pop namespace
#line 4 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/cls.asm"

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
#line 6 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/cls.asm"

	    push namespace core

CLS:
	    PROC
	    call        __zxnbackup_sysvar_bank
	    ld hl, 0
	    ld (COORDS), hl
	    ld hl, SCR_SIZE
	    ld (S_POSN), hl
	    ld hl, (SCREEN_ADDR)
	    ld (DFCC), hl
	    ld (hl), 0
	    ld d, h
	    ld e, l
	    inc de
	    ld bc, 6143
	    ldir

	    ; Now clear attributes

	    ld hl, (SCREEN_ATTR_ADDR)
	    ld (DFCCL), hl
	    ld d, h
	    ld e, l
	    inc de
	    ld a, (ATTR_P)
	    ld (hl), a
	    ld bc, 767
	    ldir
	    jp __zxnbackup_sysvar_bank_restore


	    ENDP

	    pop namespace
#line 2088 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/eq16.asm"
	    push namespace core

__EQ16:	; Test if 16bit values HL == DE
    ; Returns result in A: 0 = False, FF = True
	    xor a	; Reset carry flag
	    sbc hl, de
	    ret nz
	    inc a
	    ret

	    pop namespace

#line 2089 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/ink.asm"
	; Sets ink color in ATTR_P permanently
; Parameter: Paper color in A register




	    push namespace core

INK:
	    PROC
	    LOCAL __SET_INK
	    LOCAL __SET_INK2
	    call   __zxnbackup_sysvar_bank
	    ld de, ATTR_P

__SET_INK:
	    cp 8
	    jr nz, __SET_INK2

	    inc de ; Points DE to MASK_T or MASK_P
	    ld a, (de)
	    or 7 ; Set bits 0,1,2 to enable transparency
	    ld (de), a
	    jp    __zxnbackup_sysvar_bank_restore

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
	    jp    __zxnbackup_sysvar_bank_restore

	; Sets the INK color passed in A register in the ATTR_T variable
INK_TMP:
	    ld de, ATTR_T
	    call __SET_INK
	    jp __zxnbackup_sysvar_bank_restore
	    ENDP

	    pop namespace

#line 2090 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/lei32.asm"

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/sub32.asm"
	; SUB32
	; Perform TOP of the stack - DEHL
	; Pops operand out of the stack (CALLEE)
	; and returns result in DEHL. Carry an Z are set correctly

	    push namespace core

__SUB32:
	    exx
	    pop bc		; saves return address in BC'
	    exx

	    or a        ; clears carry flag
	    ld b, h     ; Operands come reversed => BC <- HL,  HL = HL - BC
	    ld c, l
	    pop hl
	    sbc hl, bc
	    ex de, hl

	    ld b, h	    ; High part (DE) now in HL. Repeat operation
	    ld c, l
	    pop hl
	    sbc hl, bc
	    ex de, hl   ; DEHL now has de 32 bit result

	    exx
	    push bc		; puts return address back
	    exx
	    ret

	    pop namespace
#line 3 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/lei32.asm"

	    push namespace core

__LEI32: ; Test 32 bit values Top of the stack <= HL,DE
	    PROC
	    LOCAL checkParity
	    exx
	    pop de ; Preserves return address
	    exx

	    call __SUB32

	    exx
	    push de ; Puts return address back
	    exx

	    ex af, af'
	    ld a, h
	    or l
	    or e
	    or d
	    ld a, 1
	    ret z

	    ex af, af'
	    jp po, checkParity
	    ld a, d
	    xor 0x80
checkParity:
	    ld a, 0     ; False
	    ret p
	    inc a       ; True
	    ret
	    ENDP

	    pop namespace
#line 2091 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/lti32.asm"



	    push namespace core

__LTI32: ; Test 32 bit values in Top of the stack < HLDE
	    PROC
	    LOCAL checkParity
	    exx
	    pop de ; Preserves return address
	    exx

	    call __SUB32

	    exx
	    push de ; Restores return address
	    exx

	    jp po, checkParity
	    ld a, d
	    xor 0x80
checkParity:
	    ld a, 0     ; False
	    ret p
	    inc a       ; True
	    ret
	    ENDP

	    pop namespace
#line 2092 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/lti8.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/lei8.asm"
	    push namespace core

__LEI8: ; Signed <= comparison for 8bit int
	    ; A <= H (registers)
	    PROC
	    LOCAL checkParity
	    sub h
	    jr nz, __LTI
	    inc a
	    ret

__LTI8:  ; Test 8 bit values A < H
	    sub h

__LTI:   ; Generic signed comparison
	    jp po, checkParity
	    xor 0x80
checkParity:
	    ld a, 0     ; False
	    ret p
	    inc a       ; True
	    ret
	    ENDP

	    pop namespace
#line 2 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/lti8.asm"
#line 2093 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/paper.asm"
	; Sets paper color in ATTR_P permanently
; Parameter: Paper color in A register




	    push namespace core

PAPER:
	    PROC
	    LOCAL __SET_PAPER
	    LOCAL __SET_PAPER2
	    call        __zxnbackup_sysvar_bank
	    ld de, ATTR_P

__SET_PAPER:
	    cp 8
	    jr nz, __SET_PAPER2
	    inc de
	    ld a, (de)
	    or 038h
	    ld (de), a
	    jp        __zxnbackup_sysvar_bank_restore


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
	    jp        __zxnbackup_sysvar_bank_restore


	; Sets the PAPER color passed in A register in the ATTR_T variable
PAPER_TMP:
	    call        __zxnbackup_sysvar_bank
	    ld de, ATTR_T
	    jp __SET_PAPER
	    ENDP

	    pop namespace

#line 2095 "C:\\NextBuildv8\\Sources\\JumpyMoley\\holeymoley_scroll_copperfx.bas"


	END
