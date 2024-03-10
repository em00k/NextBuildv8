	org 40960
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
_y:
	DEFB 00, 00
_x1:
	DEFB 00, 00
_y1:
	DEFB 00
_x2:
	DEFB 00
_y2:
	DEFB 00
_time:
	DEFB 00, 00
_pen_color:
	DEFB 00
_t:
	DEFB 00, 00
_co:
	DEFB 00
_xt:
	DEFB 00, 00
_xu:
	DEFB 00, 00
_tmp_address:
	DEFB 00, 00
_last_id:
	DEFB 00
_dclick:
	DEFB 00
_add:
	DEFB 00, 00
_add2:
	DEFB 00, 00
_click:
	DEFB 00
_tempstr:
	DEFB 00, 00
_row:
	DEFB 00
_play:
	DEFB 00
_keydown:
	DEFB 00
_map_value:
	DEFB 00
_mx:
	DEFB 00, 00
_my:
	DEFB 00, 00
_tx:
	DEFB 00, 00
_ty:
	DEFB 00, 00
_diskop_on:
	DEFB 00
_file_position:
	DEFB 00h
_max_positions:
	DEFB 00h
_pattern:
	DEFB 00
_position:
	DEFB 00
_k:
	DEFB 00
_slen:
	DEFB 00
_ArrayStr:
	DEFB 00, 00
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
#line 3452 "/NextBuildv8/Scripts/nextlib.bas"

		ld iy,$5c3a
		jp endfilename

#line 3456 "/NextBuildv8/Scripts/nextlib.bas"
	call _checkints
.LABEL._filename:
#line 3460 "/NextBuildv8/Scripts/nextlib.bas"

filename:
		DEFS 1024,0
endfilename:

#line 3465 "/NextBuildv8/Scripts/nextlib.bas"
#line 3467 "/NextBuildv8/Scripts/nextlib.bas"

nbtempstackstart:
		ld sp,endfilename-2

#line 3471 "/NextBuildv8/Scripts/nextlib.bas"
#line 3473 "/NextBuildv8/Scripts/nextlib.bas"



shadowlayerbit:
		db 0

#line 3479 "/NextBuildv8/Scripts/nextlib.bas"
#line 329 "C://NextBuildv8//Sources//TileMapBrowser/tilemapetext-inc.bas"

pattern_buffer_add:
		dw 		pattern_buffer

#line 333 "C://NextBuildv8//Sources//TileMapBrowser/tilemapetext-inc.bas"
.LABEL._Mouse:
#line 126 "C://NextBuildv8//Sources//TileMapBrowser/mouse-inc.bas"

Mouse:
		db	0
		dw	0
		dw	0

#line 132 "C://NextBuildv8//Sources//TileMapBrowser/mouse-inc.bas"
#line 24 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		TILE_GFXBASE 		equ 	$40
		TILE_MAPBASE 		equ 	$44



		nextreg NEXT_RESET_NR_02,128

		nextreg LAYER2_RAM_BANK_NR_12,40
		nextreg TURBO_CONTROL_NR_07,%11
		nextreg GLOBAL_TRANSPARENCY_NR_14,$0
		nextreg SPRITE_CONTROL_NR_15,%00001011
		nextreg LAYER2_CONTROL_NR_70,%00010000

		nextreg CLIP_TILEMAP_NR_1B,0
		nextreg CLIP_TILEMAP_NR_1B,159
		nextreg CLIP_TILEMAP_NR_1B,0
		nextreg CLIP_TILEMAP_NR_1B,255

		NextReg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000
		NextReg TILEMAP_CONTROL_NR_6B,%11001001
		NextReg TILEMAP_BASE_ADR_NR_6E,TILE_MAPBASE
		NextReg TILEMAP_GFX_ADR_NR_6F,TILE_GFXBASE
		NextReg PALETTE_CONTROL_NR_43,%00110000

		di

#line 51 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	ld de, .LABEL.__LABEL0
	ld hl, _tempstr
	call .core.__STORE_STR
#line 102 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		TILE_BUFFER     EQU $9600

#line 105 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	ld a, 1
	ld (_pattern), a
	ld a, 30
	push af
	ld hl, 0
	push hl
	ld a, 32
	call _InitSprites2
#line 126 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		DW $91ED
		DB $50
		DB 20

#line 131 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	xor a
	push af
	ld a, 64
	push af
	ld hl, 1024
	push hl
	call _PalUpload
	ld hl, 1024
	push hl
	ld a, 1
	push af
	ld a, 10
	push af
	ld a, 20
	call _CopyToBanks
#line 129 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		DW $91ED
		DB $50
		DB $ff

#line 134 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	call _ClearTilemap
#line 135 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	: di :
#line 136 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 138 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		DW $91ED
		DB PALETTE_CONTROL_NR_43
		DB %00010000

#line 143 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	ld a, 255
	push af
	xor a
	push af
	ld a, 255
	push af
	xor a
	push af
	call _ClipLayer2
	xor a
	push af
	xor a
	push af
	xor a
	push af
	xor a
	push af
	call _SetRGB
	ld a, 2
	push af
	ld a, 2
	push af
	ld a, 2
	push af
	ld a, 1
	push af
	call _SetRGB
	ld a, 3
	push af
	ld a, 3
	push af
	ld a, 3
	push af
	ld a, 2
	push af
	call _SetRGB
	ld a, 4
	push af
	ld a, 4
	push af
	ld a, 4
	push af
	ld a, 3
	push af
	call _SetRGB
	ld a, 5
	push af
	ld a, 5
	push af
	ld a, 5
	push af
	ld a, 4
	push af
	call _SetRGB
	ld a, 6
	push af
	ld a, 6
	push af
	ld a, 6
	push af
	ld a, 5
	push af
	call _SetRGB
	ld a, 7
	push af
	ld a, 7
	push af
	ld a, 7
	push af
	ld a, 6
	push af
	call _SetRGB
	ld a, 1
	push af
	ld a, 1
	push af
	ld a, 1
	push af
	ld a, 7
	push af
	call _SetRGB
	xor a
	call .core.BORDER
#line 152 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		ld hl,TILE_BUFFER
		ld de,TILE_BUFFER+1
		ld (hl),0
		ld bc,2560
		ldir

#line 159 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	ld de, .LABEL.__LABEL0
	ld hl, _ArrayStr
	call .core.__STORE_STR
	ld hl, .LABEL._panel1
	push hl
	call _Draw_Box
	ld hl, .LABEL._trackerwindow
	push hl
	call _Draw_Box
	ld hl, .LABEL._buttonOK
	push hl
	call _Draw_Button
	ld a, (_pattern)
	push af
	ld a, (_position)
	push af
	call _Show_Row
	ld a, (_position)
	call _Get_Position
	call _TextPatternUpdate
	call _Read_Dir_Entries
.LABEL.__LABEL1:
	call _Update_Mouse
	ld a, 200
	call _WaitRetrace2
	call _ReadKeys
	call _PlaySong
	ld hl, (_t)
	inc hl
	ld (_t), hl
	ld a, (_map_value)
	sub 16
	jp nz, .LABEL.__LABEL3
	ld a, 1
	ld (_play), a
	call _PlayMod
	jp .LABEL.__LABEL4
.LABEL.__LABEL3:
	ld a, (_map_value)
	sub 17
	jp nz, .LABEL.__LABEL5
	xor a
	ld (_play), a
	jp .LABEL.__LABEL4
.LABEL.__LABEL5:
	ld a, (_map_value)
	sub 20
	jp nz, .LABEL.__LABEL7
	ld hl, .LABEL._middle_panel
	push hl
	call _Draw_Box
	xor a
	ld (_diskop_on), a
	jp .LABEL.__LABEL4
.LABEL.__LABEL7:
	ld a, (_map_value)
	sub 24
	jp nz, .LABEL.__LABEL9
	call _Clear_Info_Area
	ld hl, .LABEL._middle_panel
	push hl
	call _Draw_Box
	ld hl, .LABEL._panelsampler
	push hl
	call _Draw_Box
	call _DrawSample
	xor a
	ld (_diskop_on), a
	jp .LABEL.__LABEL4
.LABEL.__LABEL9:
	ld a, (_map_value)
	sub 22
	jp nz, .LABEL.__LABEL4
	call _Clear_Info_Area
	ld hl, .LABEL._middle_panel
	push hl
	call _Draw_Box
	ld hl, .LABEL._paneldiskopback
	push hl
	call _Draw_Box
	ld hl, .LABEL._paneldiskop
	push hl
	call _Draw_Button
	ld a, (_file_position)
	push af
	call _Show_Dir_Entries
	call _GetModSongName
	ld a, 1
	ld (_diskop_on), a
.LABEL.__LABEL4:
	ld a, (_diskop_on)
	dec a
	jp nz, .LABEL.__LABEL14
	ld a, (_map_value)
	sub 29
	jp nz, .LABEL.__LABEL15
	ld a, (_max_positions)
	sub 6
	ld h, a
	ld a, (_file_position)
	cp h
	jp nc, .LABEL.__LABEL18
	ld hl, _file_position
	inc (hl)
	ld a, (_file_position)
	push af
	call _Show_Dir_Entries
.LABEL.__LABEL18:
	jp .LABEL.__LABEL14
.LABEL.__LABEL15:
	ld a, (_map_value)
	sub 28
	jp nz, .LABEL.__LABEL14
	xor a
	ld hl, (_file_position - 1)
	cp h
	jp nc, .LABEL.__LABEL14
	ld hl, _file_position
	dec (hl)
	ld a, (_file_position)
	push af
	call _Show_Dir_Entries
.LABEL.__LABEL14:
	ld a, (_diskop_on)
	dec a
	jp nz, .LABEL.__LABEL24
	ld hl, (_mx)
	ld (_tx), hl
	ld hl, (_my)
	ld (_ty), hl
	ld hl, 4
	ld de, (_ty)
	or a
	sbc hl, de
	sbc a, a
	push af
	ld de, 14
	ld hl, (_ty)
	or a
	sbc hl, de
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL133
	ld a, h
.LABEL.__LABEL133:
	or a
	jp z, .LABEL.__LABEL24
	ld hl, 6
	ld de, (_tx)
	or a
	sbc hl, de
	sbc a, a
	push af
	ld de, 63
	ld hl, (_tx)
	or a
	sbc hl, de
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL134
	ld a, h
.LABEL.__LABEL134:
	or a
	jp z, .LABEL.__LABEL24
	xor a
	push af
	ld hl, (_ty)
	ld de, 0
	call .core.__U32TOFREG
	call .core.__STR_FAST
	ld de, .LABEL.__LABEL29
	push hl
	call .core.__ADDSTR
	ex (sp), hl
	call .core.__MEM_FREE
	pop hl
	push hl
	ld hl, (_tx)
	ld de, 0
	call .core.__U32TOFREG
	call .core.__STR_FAST
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
	ld de, .LABEL.__LABEL30
	push hl
	call .core.__ADDSTR
	ex (sp), hl
	call .core.__MEM_FREE
	pop hl
	push hl
	ld a, 10
	push af
	ld a, 10
	push af
	call _TextLine
.LABEL.__LABEL24:
	jp .LABEL.__LABEL1
.LABEL._panel1:
#line 769 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		db 0,0, 0, 160, 0, 0, 0

#line 773 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._trackerwindow:
#line 775 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"




		db 0,4    ,4      ,160-4  ,255-8 , 0, 3

		db 0,15   ,127    ,16    ,120     , 1, 7
		db 0,34   ,127    ,31   ,120     , 1, 7
		db 0,92   ,127    ,31   ,120     , 1, 7
		db 0,148   ,127    ,31   ,120     , 1, 7
		db 0,204   ,127    ,29   ,120     , 1, 7



		db 1,10   ,127    ,(2*8)+7   ,120     , 1, 9


		db $ff,$ff,$ff,$ff, 146


#line 795 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._middle_panel:
#line 797 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		db 0,5,(8*6)-1  ,(20*8)-6  ,8*8 , 5, 3


		db $ff,$ff,$ff,$ff, 146


#line 805 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._panelsampler:
#line 806 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		db 0,BASE_X+15    ,(6 *8)-1    , 16*8, 8*8, 1, 7
		db $ff,$ff,$ff,$ff, 146

#line 810 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._paneldiskopback:
#line 813 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		db 0,BASE_X+16    ,(6 *8)-1    , 15*8, 8*8, 1, 7
		db $ff,$ff,$ff,$ff, $ff

#line 817 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._paneldiskop:
#line 819 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		db 4,   6,  4,  2,  0
	db "  DIRECTORY : ____________________," ,0

		db BASE_X+1,   9,  0,  0,  28
		db 5,"," ,0
		db BASE_X+1,   10,  0,  0,  29
		db 6,"," ,0

		db "       ," ,$FF

		db $ff,$ff,$ff,$ff, $ff
		db $ff,$ff, $ff


#line 835 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._Array1:
#line 1157 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


asm_array1:

		db      24
		dw      $0000


#line 1165 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._objectbuffer:
#line 1172 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		ds 128,0

#line 1175 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._buttontmp:
#line 1177 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		db  0,0, 0, 0, 0, 0,0
		db  $ff,$ff, $ff,$ff,$ff

#line 1182 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._buttonOK:
#line 1184 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		BASE_X equ 1

		db BASE_X+3,   2,  0,  1,  0
		db "POSITION   ," ,0
		db BASE_X+3,   3,  0,  1,  0
		db "PATTERN    ," ,0
		db BASE_X+3,   4,  0,  1,  0
		db "LENGTH     ," ,0
		db BASE_X+3,   5,  0,  1,  0
		db "SAMPLE     ," ,0

#line 1196 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._text_status:
#line 1198 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		db 4,   14,  4,  2,  0
		db "        SONG NAME ," ,0

		db 23,   14,  4,  2,  25
		db "____________________," ,0

		db 4,   15,  4,  2,  0
		db "      SAMPLE NAME ," ,0

		db 23,   15,  4,  2,  26
		db "____________________," ,0


#line 1213 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._button2:
#line 1215 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		db BASE_X+22,   2,  0,  0,  1
		db 5,"," ,0
		db BASE_X+24,   2,  0,  0,  2
		db 6,"," ,0

		db BASE_X+22,   3,  0,  0,  3
		db 5,"," ,0
		db BASE_X+24,   3,  0,  0,  4
		db 6,"," ,0

		db BASE_X+22,   4,  0,  0,  5
		db 5,"," ,0
		db BASE_X+24,   4,  0,  0,  6
		db 6,"," ,0

		db BASE_X+22,   5,  0,  0,  7
		db 5,"," ,0
		db BASE_X+24,   5,  0,  0,  8
		db 6,"," ,0


		db BASE_X+15,   2,  1,  13,  0
		db " 0000 ," ,0
		db BASE_X+15,   3,  1,  13,  0
		db " 0000 ," ,0
		db BASE_X+15,   4,  1,  13,  0
		db " 0000 ," ,0
		db BASE_X+15,   5,  1,  13,  0
		db " 0000 ," ,0


#line 1248 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._button3:
#line 1250 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		db BASE_X+26,   2,  0,  10,  16
		db "   PLAY   ," ,0
		db BASE_X+37,   2,  0,  10,  17
		db "   STOP   ," ,0
		db BASE_X+48,   2,  0,  10,  18
		db "   EDIT   ," ,0
		db BASE_X+26,   3,  0,  10,  19
		db " PATTERN  ," ,0
		db BASE_X+37,   3,  0,  10,  20
		db "  CLEAR   ," ,0
		db BASE_X+48,   3,  0,  10,  0
		db "          ," ,0

		db BASE_X+26,   4,  0,  10,  22
		db " DISK OP. ," ,0
		db BASE_X+37,   4,  0,  10,  23
		db " EDIT OP. ," ,0
		db BASE_X+48,   4,  0,  10,  24
		db "  SAMPLER ," , 0

		db BASE_X+26,   5,  0,  10,  0
		db "          ," ,0
		db BASE_X+37,   5,  0,  10,  0
		db "          ," ,0
		db BASE_X+48,   5,  0,  10,  0
		db "          ," ,$FF



#line 1281 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._PLOT_COLOUR:
#line 1547 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	:
PLOT_COLOUR:
		db 0

#line 1551 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	ld hl, 0
	push hl
	ld hl, .LABEL.__LABEL0
	call .core.__LOADSTR
	push hl
	ld hl, 0
	push hl
	call _PutElement
	xor a
	push af
	ld hl, 0
	push hl
	call _GetElement
.LABEL._rand_num1:
#line 1586 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

rand_num:
		dw 00

#line 1590 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
.LABEL._string_temp:
#line 1592 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

string_temp:
		defs 80,0

#line 1596 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1599 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

pattern_buffer:

#line 1602 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1606 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

__direcotory_name:
	db "c:",0
		ds 32,0
		asm
mod_name:
		db "test.mod",0

#line 1614 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
	ld hl, 0
	ld b, h
	ld c, l
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
_FPlotL2:
#line 2767 "/NextBuildv8/Scripts/nextlib.bas"





		call _checkints
		di
#line 2775 "/NextBuildv8/Scripts/nextlib.bas"
		exx
		pop hl
		exx

		ld bc,LAYER2_ACCESS_PORT

		push af
		ex de,hl

		bit 0, d
		jr z,nobanks6and7
		ld d,%100

nobanks6and7:
		ld a,e
		swapnib
		srl a
		srl a
		and 3
		or d
		ld e,a

		ld a,%00000011
		out (c),a

		ld a,e

		add a,%00010000
		out (c),a

		pop af
		pop hl
		ld h,l
		ld l,a
		ld a,h
		and 63
		ld h,a

		pop af
		ld (hl),a


		exx
		push hl
		exx
		ld a,%00000010
		out (c),a


	ld a,(.itbuff) : or a : jr z,$+3 : ei
#line 2824
#line 2825 "/NextBuildv8/Scripts/nextlib.bas"

#line 2828 "/NextBuildv8/Scripts/nextlib.bas"
_FPlotL2__leave:
	ret
_FPlotLineV:
#line 2831 "/NextBuildv8/Scripts/nextlib.bas"




		PROC
		LOCAL nobanks6and7, lineloop


		call _checkints
		di
#line 2842 "/NextBuildv8/Scripts/nextlib.bas"
		exx
		pop hl
		exx

		ld bc,LAYER2_ACCESS_PORT

		push af
		ex de,hl

		bit 0, d
		jr z,nobanks6and7
		ld d,%100

nobanks6and7:
		ld a,e
		swapnib
		srl a
		srl a
		and 3
		or d
		ld e,a

		ld a,%00000011
		out (c),a

		ld a,e

		add a,%00010000
		out (c),a

		pop af
		pop hl
		ld h,l
		ld l,a
		ld a,h
		and 63
		ld h,a


		pop		bc

		pop 	af

lineloop:

		ld 		(hl),a
		inc 	l
		djnz 	lineloop

		exx
		push 	hl
		exx
		ld 		bc, LAYER2_ACCESS_PORT
		ld 		a,%00000010
		out 	(c),a


	ld a,(.itbuff) : or a : jr z,$+3 : ei
#line 2899
#line 2900 "/NextBuildv8/Scripts/nextlib.bas"
		ENDP

#line 2904 "/NextBuildv8/Scripts/nextlib.bas"
_FPlotLineV__leave:
	ret
_PalUpload:
	push ix
	ld ix, 0
	add ix, sp
#line 2986 "/NextBuildv8/Scripts/nextlib.bas"


		ld l,(IX+4)
		ld h,(IX+5)
		ld b,(IX+7)
		ld e,(IX+9)
		ld a,e

loadpal:



		ld d,0
		DW $92ED
		DB $40


		ld c,0
palloop:
		ld a,(hl)

		DW $92ED
		DB $44
		inc hl
		ld a,(hl)

		DW $92ED
		DB $44
		inc hl

		djnz palloop
		ld a,128
		DW $92ED
		DB $40
		xor a
		DW $92ED
		DB $44
		DW $92ED
		DB $44



#line 3028 "/NextBuildv8/Scripts/nextlib.bas"
_PalUpload__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	pop bc
	ex (sp), hl
	exx
	ret
_ClipLayer2:
	push ix
	ld ix, 0
	add ix, sp
#line 3102 "/NextBuildv8/Scripts/nextlib.bas"

		ld a,(IX+5)
	DW $92ED : DB 24
		ld a,(IX+7)
	DW $92ED : DB 24
		ld a,(IX+9)
	DW $92ED : DB 24
		ld a,(IX+11)
	DW $92ED : DB 24

#line 3112 "/NextBuildv8/Scripts/nextlib.bas"
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
_WaitRetrace2:
#line 3362 "/NextBuildv8/Scripts/nextlib.bas"

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

#line 3389 "/NextBuildv8/Scripts/nextlib.bas"
_WaitRetrace2__leave:
	ret
_GetKeyScanCode:
#line 72 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/keys.bas"

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

#line 96 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/keys.bas"
_GetKeyScanCode__leave:
	ret
_hex:
#line 30 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/hex.bas"

		push namespace core
		PROC
		LOCAL SUB_CHAR
		LOCAL SUB_CHAR2
		LOCAL END_CHAR
		LOCAL DIGIT

		push hl
		push de
		ld bc,10
		call __MEM_ALLOC
		ld a, h
		or l
		pop de
		pop bc
		ret z

		push hl
		ld (hl), 8
		inc hl
		ld (hl), 0
		inc hl

		call DIGIT
		ld d, e
		call DIGIT
		ld d, b
		call DIGIT
		ld d, c
		call DIGIT
		pop hl
		ret

DIGIT:
		ld a, d
		call SUB_CHAR
		ld a, d
		jr SUB_CHAR2

SUB_CHAR:
		rrca
		rrca
		rrca
		rrca

SUB_CHAR2:
		and 0Fh
		add a, '0'
		cp '9' + 1
		jr c, END_CHAR
		add a, 7

END_CHAR:
		ld (hl), a
		inc hl
		ret

		ENDP
		pop namespace

#line 91 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/hex.bas"
#line 30 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/hex.bas"

		ld hl, 0

#line 33 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library/hex.bas"
_hex__leave:
	ret
_hex16:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	ld l, (ix+4)
	ld h, (ix+5)
	ld de, 0
	call _hex
	ld d, h
	ld e, l
	ld bc, -2
	call .core.__PSTORE_STR2
	ld l, (ix-2)
	ld h, (ix-1)
	push hl
	ld hl, 4
	push hl
	ld hl, 7
	push hl
	xor a
	call .core.__STRSLICE
_hex16__leave:
	ex af, af'
	exx
	ld l, (ix-2)
	ld h, (ix-1)
	call .core.__MEM_FREE
	ex af, af'
	exx
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_ClearTilemap:
#line 37 "C://NextBuildv8//Sources//TileMapBrowser/tilemapetext-inc.bas"

		ld 		hl,TILE_MAPBASE*256
		ld 		de,1+TILE_MAPBASE*256
		ld 		bc,2560*2
		ld 		(hl),0
		ldir

#line 44 "C://NextBuildv8//Sources//TileMapBrowser/tilemapetext-inc.bas"
_ClearTilemap__leave:
	ret
_CopyToBanks:
#line 75 "C://NextBuildv8//Sources//TileMapBrowser/tilemapetext-inc.bas"

	exx : pop hl : exx


		call 	_checkints

		ld 		c,a
		pop 	de
		ld 		e,c
		pop 	af
		ld 		b,a
		pop 	hl
		ld 		(copysize+1),hl

copybankloop:
		push 	bc
		push 	de
		ld 		a,e
		nextreg $50,a
		ld 		a,d
		nextreg $51,a

		ld 		hl,$0000
		ld 		de,$2000
copysize:
		ld 		bc,$2000
		ldir
		pop 	de
		pop	 	bc
		inc 	d
		inc 	e
		djnz 	copybankloop

	nextreg $50,$ff : nextreg $51,$ff

	exx : push hl : exx : ret


#line 113 "C://NextBuildv8//Sources//TileMapBrowser/tilemapetext-inc.bas"
_CopyToBanks__leave:
	ret
_TextLine:
	push ix
	ld ix, 0
	add ix, sp
#line 118 "C://NextBuildv8//Sources//TileMapBrowser/tilemapetext-inc.bas"


		push 	namespace TextLine

		add 	a,a
		ld 		(xpos+1),a
		ld 		a,(ix+7)
		and 	31
		ld 		e,a
		ld 		hl,.TILE_MAPBASE*256
		ld 		d,160
		mul 	d,e
		add 	hl,de

xpos:
		ld 		a,0
		add 	hl,a
		ex 		de,hl
		ld		h,(ix+9)
		ld 		l,(ix+8)
		ld 		b,(hl)
		add 	hl,2
		ld 		a,(ix+11)
		ld 		(col+1),a
lineloop:
		push 	bc


		ldi





col:
		ld 		a,0
		and 	%01111111
		rlca
		ld 		(de),a
		inc 	de
		pop 	bc
		djnz 	lineloop
done:
		pop 	namespace


#line 164 "C://NextBuildv8//Sources//TileMapBrowser/tilemapetext-inc.bas"
_TextLine__leave:
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
_Process_Mouse:
#line 3 "C://NextBuildv8//Sources//TileMapBrowser/mouse-inc.bas"


		ld	de,(nmousex)
		ld (omousex),de
		ld	a,(mouseb)
		ld (omouseb),a

		call getmouse

		ld (mouseb),a
		ld (nmousex),hl

		ld a,l
		sub e
		ld e,a
		ld a,h
		sub d
		ld d,a
		ld (dmousex),de

		ld d,0
		bit 7,e
		jr z,bl
		dec d
bl:
		ld hl,(rmousex)
		add hl,de
		ld bc,4*256
		call rangehl
		ld (rmousex),hl
		sra  h
		rr l
		sra h
		rr l
		ld a,l
		ld (mousex),a
		ld de,(dmousey)
		ld d,0
		bit 7,e
		jr z,bd
		dec d
bd:
		ld hl,(rmousey)
		add hl,de
		ld bc,1024
		call rangehl
		ld (rmousey),hl
		sra  h
		rr l
		sra h
		rr l
		ld a,l
		ld (mousey),a

		jp mouseend

getmouse:
		ld	bc,64479
		in a,(c)
		ld l,a
		ld	bc,65503
		in a,(c)
		cpl
		ld h,a
		ld (nmousex),hl
		ld	bc,64223
		in a,(c)
		ld (mouseb),a
		ret

rangehl:
		bit 7,h
		jr nz,mi
		or a
		push hl
		sbc hl,bc
		pop hl
		ret c
		ld	h,b
		ld l,c
		dec hl
		ret
mi:
		ld hl,0
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
		ld a,(mouseb)
		ld (Mouse),a
		ld de,(mousex)
		ld (Mouse+1),de
		ld de,(mousey)
		ld (Mouse+3),de


#line 123 "C://NextBuildv8//Sources//TileMapBrowser/mouse-inc.bas"
_Process_Mouse__leave:
	ret
_Show_Row:
	push ix
	ld ix, 0
	add ix, sp
#line 11 "C://NextBuildv8//Sources//TileMapBrowser/Decode-inc.bas"


		ROWLENGTH	equ 	80
		STARTXY     EQU     12+(16*160)+$4400
		ADDSTEP     EQU     8
		push    ix
		ld		hl, STARTXY
		ld 		(cursor_position), hl
		call    draw_row
		pop     ix
		jp      _Show_Row__leave


draw_row:

		ld 		a, (._pattern)
		and		7
		add		a, a
		add		a, a
		ld 		h, a

		ld 		a, (IX+5)
		sub 	7

		ld      ixl, a

		cp 		64
		jr		c, skipand192
		xor 	a
skipand192:
		ld      d, a

		call 	getPatternRow




PatternLoop:


		ld c, 15


RowLoop:

		push    bc

		ld      a,ixl

		cp      64
		jp      nc, printblank

		push 	hl
		call    printnumber

		ld      hl,(cursor_position)
		add 	hl, 4
		ld 		(cursor_position), hl

		pop 	hl



		push    hl

		call    DecodePatternData

		call    printhl

		inc     hl
		inc     hl
		ld      a, e
		call    printhex_XX

		inc     hl
		inc     hl

		ld      a, c
		call    printhex_X

		ld      a, d
		call    printhex_XX

		add 	hl, 8
		ld 		(cursor_position), hl




		pop     hl



		add hl, 4



		push    hl
		call    DecodePatternData

		call    printhl

		inc     hl
		inc     hl
		ld      a, e
		call    printhex_XX

		inc     hl
		inc     hl
		ld      a, c
		call    printhex_X

		ld      a, d
		call    printhex_XX

		add 	hl, 8
		ld 		(cursor_position), hl






		pop     hl



		add     hl,4



		push    hl
		call    DecodePatternData

		call    printhl

		inc     hl
		inc     hl

		ld      a, e
		call    printhex_XX

		inc     hl
		inc     hl

		ld      a, c
		call    printhex_X

		ld      a, d
		call    printhex_XX

		add 	hl, 8
		ld 		(cursor_position), hl





		pop     hl



		add hl, 4



		push    hl
		call    DecodePatternData

		call    printhl

		inc     hl
		inc     hl

		ld      a, e
		call    printhex_XX

		inc     hl
		inc     hl

		ld      a, c
		call    printhex_X

		ld      a, d
		call    printhex_XX


		ld 		(cursor_position), hl




		ld 		a, ROWLENGTH
		cp 		80
		jr 		z, charsperline_80
		add 	hl, 4
		jr		charperline_skip
charsperline_80:

		add 	hl, 84-36
charperline_skip:
		ld 		(cursor_position), hl

		pop     hl



		add hl, 4

back:
		inc     ix

		pop     bc


		dec c
		jp nz, RowLoop







		ret

getPatternRow:


		ld      e, 16
		mul     d, e
		add 	hl,$4000
		add		hl,de
		ret

printblank:


		ld 		de, (cursor_position)
		ld 		a, ' '
		ld 		b, 80
wipeloop:
		ld 		(de), a
		inc 	de
		inc 	de
		djnz    wipeloop
		ld 		(cursor_position), de
		jp      back

DecodePatternData:

		ld 		a, (._pattern)
		and	%00111000
		rrca
		rrca
		rrca
		add 	a, 32
		nextreg $52,a




		ld 		e, (hl)
		inc 	hl
		ld 		b, (hl)
		inc 	hl
		ld 		c, (hl)
		inc 	hl
		ld 		d, (hl)


		ld 		a, e
		add 	a, c
		swapnib
		and     $1f
		push    af



		ld  	a, e
		and 	$f
		ld 		h, a
		ld 		l, b


		ld 		a, c
		and 	$f
		ld 		c,a

		pop     af
		ld      e, a








		nextreg $52,10

		jp    period_to_string

printhex_X:




		or 		$f0
		daa
		add 	a, $a0
		adc 	a, $40

		ld		(hl), a
		inc 	hl
		inc 	hl

		ret


printhex_XX:




		ld 		e, a
		swapnib
		or 		$f0
		daa
		add 	a, $a0
		adc 	a, $40

		ld		(hl), a
		inc 	hl
		inc 	hl
char2:
		ld 		a, e
		or 		$f0
		daa
		add 	a, $a0
		adc 	a, $40
		ld		(hl), a
		inc 	hl
		inc 	hl

		ret

printnumber:

		ld 		hl, (cursor_position)
		ld 		e, -10
		call 	Na1
		ld 		e, -1
Na1:
		ld 		b, '0'-1
Na2:
		inc 	b
		add 	a, e
		jr 		c, Na2
		sub 	e
		ld		(hl), b
		inc 	hl
		inc 	hl
		ld 		(cursor_position), hl
		ret

skipglyph:
		ld 		hl, (cursor_position)
		ld 		(hl),32
	inc 	hl 	: inc 	hl
		jr		char2

printhl:

		push 	de
		ld      de, (cursor_position)
		ex      de, hl


	.pr_lp:
		ld      a, (de)
		or      a
		jr      z,.pr_done
		ld      (hl), a
		inc     hl
		ld      (hl), b
		inc     hl
		inc     de
		jr      .pr_lp
pr_done:
		pop 	de

		ret


cursor_position:
		dw 	STARTXY

cur_x:      db 0
cur_y:      db 0

		BANK8K_FINETUNE   equ     24

period_to_string:





		nextreg	$50,BANK8K_FINETUNE


		ld		a,(hl)
		ld		hl,note_tab
		add		a,a
		add		hl,a
		rrca
		cp      72
		jr      nz, normalcolour
		ld      b, 1
		jr      darkcolour
normalcolour:
		ld      b, 8
darkcolour:
		nextreg	$50,$ff
		ret

color_pattern_table:
		ld 		de, STARTXY+1
		ld 		c, 15
colour_start:
		ld 		b, ROWLENGTH
		ld 		hl, colourtable
colourloop:
		ld 		a, (hl)
		and 	%01111111
		rlca
		ld 		(de),a
		inc 	hl
		inc 	de
		inc 	de
		djnz 	colourloop
		ld 		a, ROWLENGTH
		cp 		40
		jr 		z, charsperline_40



charsperline_40:

		ld 		a, c
		cp 		9
		jr		nz,notmiddle
		ld		b, 58
		ld 		hl, middle
		dec 	c
		jr 		colourloop

notmiddle:
		dec 	c
		jr 		nz, colour_start
		ret



colourtable:

		db 		0,0

		db 		0,0,0,0,$a,$a,6,6,6,0,0,0,0,$a,$a,6,6,6
		db 		0,0,0,0,$a,$a,6,6,6,0,0,0,0,$a,$a,6,6,6,0,0
		db 		0,0,0,0,$a,$a,6,6,6,0,0,0,0,$a,$a,6,6,6,0,0
		db 		0,0,0,0,$a,$a,6,6,6,0,0,0,0,$a,$a,6,6,6,0,0

middle:
		defs 	ROWLENGTH,18

















note_tab:
		db	"C-1"
		db 0
		db	"C#1"
		db 0
		db	"D-1"
		db 0
		db	"D#1"
		db 0
		db	"E-1"
		db 0
		db	"F-1"
		db 0
		db	"F#1"
		db 0
		db	"G-1"
		db 0
		db	"G#1"
		db 0
		db	"A-1"
		db 0
		db	"A#1"
		db 0
		db	"B-1"
		db 0
		db	"C-2"
		db 0
		db	"C#2"
		db 0
		db	"D-2"
		db 0
		db	"D#2"
		db 0
		db	"E-2"
		db 0
		db	"F-2"
		db 0
		db	"F#2"
		db 0
		db	"G-2"
		db 0
		db	"G#2"
		db 0
		db	"A-2"
		db 0
		db	"A#2"
		db 0
		db	"B-2"
		db 0
		db	"C-3"
		db 0
		db	"C#3"
		db 0
		db	"D-3"
		db 0
		db	"D#3"
		db 0
		db	"E-3"
		db 0
		db	"F-3"
		db 0
		db	"F#3"
		db 0
		db	"G-3"
		db 0
		db	"G#3"
		db 0
		db	"A-3"
		db 0
		db	"A#3"
		db 0
		db	"B-3"
		db 0
		db	" - "
		db 0

inkred:


		ret


#line 586 "C://NextBuildv8//Sources//TileMapBrowser/Decode-inc.bas"
_Show_Row__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	ex (sp), hl
	exx
	ret
_Get_Position:
#line 590 "C://NextBuildv8//Sources//TileMapBrowser/Decode-inc.bas"



		nextreg	$52, 32
		ld 		hl, $4000+950
		ld 		b, (hl)





continuesong:
		ld 		hl, $4000+952
		add		hl,a
		ld 		a, (hl)
		ld 		(._pattern), a
		ld 		a, b
		ld 		(._slen), a
		nextreg $52,10

#line 610 "C://NextBuildv8//Sources//TileMapBrowser/Decode-inc.bas"
_Get_Position__leave:
	ret
_Clear_Info_Area:
#line 263 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		ld      hl,09+(7*160)+$4400
		ld      d, h
		ld      e, l
		inc     de
		ld      (hl),0
		ld      bc, 160*9
		ldir
		ld      hl,(0)
		ld      hl,TILE_BUFFER
		ld      de,TILE_BUFFER+1
		ld      bc, 160*9
		ldir

#line 278 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
_Clear_Info_Area__leave:
	ret
_Show_Dir_Entries:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	inc sp
	ld (ix-1), 0
	jp .LABEL.__LABEL31
.LABEL.__LABEL34:
	ld a, (ix-1)
	add a, (ix+5)
	push af
	ld hl, .LABEL._Array1
	push hl
	call _GetElement
	xor a
	push af
	ld hl, .LABEL.__LABEL36
	call .core.__LOADSTR
	push hl
	ld a, (ix-1)
	add a, 7
	push af
	ld a, 7
	push af
	call _TextLine
	ld a, 2
	push af
	ld hl, (_ArrayStr)
	call .core.__LOADSTR
	push hl
	ld a, (ix-1)
	add a, 7
	push af
	ld a, 5
	push af
	call _TextLine
	inc (ix-1)
.LABEL.__LABEL31:
	ld a, 6
	cp (ix-1)
	jp nc, .LABEL.__LABEL34
	inc (ix+5)
_Show_Dir_Entries__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_PlayMod:
#line 295 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		nextreg MMU4_8000_NR_54,22


		DB $c5,$DD,$01,$0,$0,$c1

#line 299
		exx
	push hl : push de : push bc
		push af
		exx
		ex af,af'
	push hl : push de : push bc : push iy : push ix
		push af

		call    $9603


		DB $c5,$DD,$01,$0,$0,$c1

#line 310


		nextreg MMU4_8000_NR_54,4
		nextreg MMU2_4000_NR_52,10
		nextreg MMU3_6000_NR_53,11


		pop af
	pop ix : pop iy : pop bc : pop de : pop hl
		exx
		ex af, af'
		pop af
	pop bc : pop de : pop hl
		exx

#line 331 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
_PlayMod__leave:
	ret
_Read_Dir_Entries:
#line 329 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


		f_opendir       EQU         $a3
		f_readdir       EQU         $a4
		f_telldir       EQU         $a5
		f_seekdir       EQU         $a6
		f_rewinddir     EQU         $a7

		push    ix

		ld      a, '*'
		ld      b, $10
		ld      ix,__direcotory_name

		rst 8
#line 343
		db      f_opendir

		ld      (_dir_handle),a
		or      a
		jr      z,._exit_show_dir
		jp      c,._exit_show_dir



		ld      a, (_dir_handle)

	rst 8  : db f_rewinddir
#line 354


_read_filename_entry:
		ld      a, (_dir_handle)
		ld      ix, _dir_buffer


	rst 8  : db f_readdir
#line 361
		jr      c, _exit_show_dir
		or      a
		jr      z, _exit_show_dir

		jp      _get_full_dir_to_array

_exit_show_dir:

		ld      a, (_dir_handle)

	rst 8 : db F_CLOSE
#line 371

		pop     ix
		jp      ._Read_Dir_Entries__leave

_dir_check_max:

_get_full_dir_to_array:
		ld      de, _dir_buffer+1

		call    _get_length
		ld      a, 24
		ld      bc, (test_count)
		call    _put_array

		ld      a, (_dir_handle)
		ld      ix, _dir_buffer

	rst 8  : db f_readdir
#line 388
		or      a
		jr      z,._no_more_entries

		ld      hl, test_count
		inc     (hl)

		jr      _get_full_dir_to_array

_no_more_entries:
		ld      a, (test_count)
		ld      (._max_positions),a

		jp      ._exit_show_dir

_get_length:
		push    de
		ld      bc, 0
	1:      ld      a,(de)
		or      a
		jr      z,_string_len_end
		inc     bc
		inc     de
		jr      1B
_string_len_end:
		ld      (array_str_length),bc
		pop     de
		ret

test_count:
		db 0,0

_dir_handle:
		db      0
_last_position:
		db      0,0,0,0
CUR_XY:
		dw      0
		dw      0
_dir_buffer:
		ds      256, 0



#line 441 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
_Read_Dir_Entries__leave:
	ret
_GetModSongName:
#line 463 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		ld      b, 20

		ld      de, 36+14*160+$4400
		ld      hl, $F39B
	1:
		ldi
		inc     de
		djnz    1B


#line 474 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
_GetModSongName__leave:
	ret
_DrawSample:
	ld hl, 0
	ld (_x), hl
	jp .LABEL.__LABEL37
.LABEL.__LABEL40:
	ld a, 28
	push af
	ld hl, (_x)
	ld de, 17
	add hl, de
	push hl
	ld a, 80
	call _FPlotL2
	ld hl, (_x)
	inc hl
	ld (_x), hl
.LABEL.__LABEL37:
	ld hl, 255
	ld de, (_x)
	or a
	sbc hl, de
	jp nc, .LABEL.__LABEL40
_DrawSample__leave:
	ret
_PlaySong:
	ld de, 4
	ld hl, (_t)
	or a
	sbc hl, de
	ccf
	sbc a, a
	push af
	ld a, (_play)
	dec a
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL135
	ld a, h
.LABEL.__LABEL135:
	or a
	jp z, _PlaySong__leave
	ld hl, _row
	inc (hl)
	ld a, (_row)
	sub 64
	jp nz, .LABEL.__LABEL45
	ld hl, _position
	inc (hl)
	ld hl, (_slen - 1)
	ld a, (_position)
	sub h
	jp nz, .LABEL.__LABEL47
	xor a
	ld (_position), a
.LABEL.__LABEL47:
	ld a, (_position)
	call _Get_Position
	call _TextPatternUpdate
	xor a
	ld (_row), a
.LABEL.__LABEL45:
	ld a, (_position)
	push af
	ld a, (_row)
	push af
	call _Show_Row
	ld hl, 0
	ld (_t), hl
_PlaySong__leave:
	ret
_ReadKeys:
	call _GetKeyScanCode
	ld a, l
	ld (_k), a
	ld a, (_keydown)
	sub 1
	sbc a, a
	push af
	ld a, (_k)
	ld l, a
	ld h, 0
	ld de, 64769
	call .core.__EQ16
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL136
	ld a, h
.LABEL.__LABEL136:
	or a
	jp z, .LABEL.__LABEL48
	ld hl, 0
	ld (_t), hl
	ld a, (_row)
	inc a
	and 63
	ld (_row), a
	ld a, (_pattern)
	push af
	ld a, (_row)
	push af
	call _Show_Row
	ld a, 1
	ld (_keydown), a
	jp _ReadKeys__leave
.LABEL.__LABEL48:
	ld a, (_keydown)
	sub 1
	sbc a, a
	push af
	ld a, (_k)
	ld l, a
	ld h, 0
	ld de, 64257
	call .core.__EQ16
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL137
	ld a, h
.LABEL.__LABEL137:
	or a
	jp z, .LABEL.__LABEL50
	ld a, (_row)
	dec a
	and 63
	ld (_row), a
	ld a, (_pattern)
	push af
	ld a, (_row)
	push af
	call _Show_Row
	ld a, 1
	ld (_keydown), a
	jp _ReadKeys__leave
.LABEL.__LABEL50:
	ld a, (_keydown)
	sub 1
	sbc a, a
	push af
	ld a, (_k)
	ld l, a
	ld h, 0
	ld de, 32513
	call .core.__EQ16
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL138
	ld a, h
.LABEL.__LABEL138:
	or a
	jp z, .LABEL.__LABEL52
	xor a
	ld (_row), a
	ld a, (_pattern)
	push af
	ld a, (_row)
	push af
	call _Show_Row
	ld a, 1
	ld hl, (_play - 1)
	sub h
	ld (_play), a
	ld a, 1
	ld (_keydown), a
	jp _ReadKeys__leave
.LABEL.__LABEL52:
	ld a, (_k)
	or a
	jp nz, _ReadKeys__leave
	xor a
	ld (_keydown), a
_ReadKeys__leave:
	ret
_Update_Mouse:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	inc sp
	call _Process_Mouse
	ld a, ((.LABEL._Mouse) + (1))
	ld l, a
	ld h, 0
	add hl, hl
	ld (_mx), hl
	ld hl, 319
	ld de, (_mx)
	or a
	sbc hl, de
	jp nc, .LABEL.__LABEL57
	ld hl, 319
	ld (_mx), hl
.LABEL.__LABEL57:
	ld a, ((.LABEL._Mouse) + (3))
	ld l, a
	ld h, 0
	ld (_my), hl
	ld a, (.LABEL._Mouse)
	and 15
	ld (ix-1), a
	xor a
	push af
	xor a
	push af
	ld a, 16
	push af
	xor a
	push af
	ld hl, (_my)
	ld a, l
	push af
	ld hl, (_mx)
	push hl
	call _UpdateSprite
	ld hl, (_mx)
	ld b, 2
.LABEL.__LABEL141:
	srl h
	rr l
	djnz .LABEL.__LABEL141
	ld (_mx), hl
	ld hl, (_my)
	ld b, 3
.LABEL.__LABEL143:
	srl h
	rr l
	djnz .LABEL.__LABEL143
	ld (_my), hl
	xor a
	ld (_map_value), a
	ld a, 13
	push af
	ld hl, (_mx)
	ld de, 0
	call .core.__U32TOFREG
	call .core.__STR_FAST
	push hl
	ld a, 22
	push af
	ld a, 70
	push af
	call _TextLine
	ld a, 13
	push af
	ld hl, (_my)
	ld de, 0
	call .core.__U32TOFREG
	call .core.__STR_FAST
	push hl
	ld a, 23
	push af
	ld a, 70
	push af
	call _TextLine
	ld a, 6
	push af
	ld a, (ix-1)
	call .core.__U8TOFREG
	call .core.__STR_FAST
	push hl
	ld a, 24
	push af
	ld a, 70
	push af
	call _TextLine
	ld a, 6
	push af
	ld a, (.LABEL._Mouse)
	call .core.__U8TOFREG
	call .core.__STR_FAST
	push hl
	ld a, 25
	push af
	ld a, 70
	push af
	call _TextLine
	ld a, (ix-1)
	sub 13
	sub 1
	sbc a, a
	ld d, a
	ld a, (ix-1)
	sub 12
	sub 1
	sbc a, a
	or d
	push af
	ld a, (_click)
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL145
	ld a, h
.LABEL.__LABEL145:
	or a
	jp z, .LABEL.__LABEL58
	ld hl, (_mx)
	ld de, 38400
	add hl, de
	push hl
	ld hl, (_my)
	ld de, 80
	call .core.__MUL16_FAST
	ex de, hl
	pop hl
	add hl, de
	ld a, (hl)
	ld (_map_value), a
	xor a
	ld hl, (_map_value - 1)
	cp h
	jp nc, .LABEL.__LABEL61
	ld a, 13
	push af
	ld a, (_map_value)
	call .core.__U8TOFREG
	call .core.__STR_FAST
	push hl
	ld a, 26
	push af
	ld a, 70
	push af
	call _TextLine
	ld a, (_map_value)
	add a, a
	ld l, a
	ld h, 0
	ex de, hl
	ld hl, .LABEL._objectbuffer
	add hl, de
	ld (_tmp_address), hl
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld (_tmp_address), hl
	ld hl, _tempstr
	push hl
	ld a, 44
	push af
	ld hl, (_tmp_address)
	ld de, 6
	add hl, de
	call _PeekMem
	ld a, 4
	push af
	ld hl, (_tmp_address)
	push hl
	call _Draw_Press
	ld a, 1
	ld (_click), a
	ld a, (ix-1)
	sub 12
	jp nz, .LABEL.__LABEL62
	ld a, 1
	ld (_dclick), a
	jp .LABEL.__LABEL63
.LABEL.__LABEL62:
	xor a
	ld (_dclick), a
.LABEL.__LABEL63:
	ld a, (_map_value)
	ld (_last_id), a
.LABEL.__LABEL61:
	jp _Update_Mouse__leave
.LABEL.__LABEL58:
	ld a, (ix-1)
	sub 15
	sub 1
	sbc a, a
	ld d, a
	ld a, (ix-1)
	sub 14
	sub 1
	sbc a, a
	or d
	push af
	ld a, (_click)
	sub 2
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL146
	ld a, h
.LABEL.__LABEL146:
	or a
	jp z, .LABEL.__LABEL64
	xor a
	push af
	ld hl, (_tmp_address)
	push hl
	call _Draw_Press
	ld a, 13
	push af
	ld hl, .LABEL.__LABEL66
	call .core.__LOADSTR
	push hl
	ld a, 27
	push af
	ld a, 70
	push af
	call _TextLine
	xor a
	ld (_click), a
	ld a, 4
	push af
	ld hl, .LABEL.__LABEL67
	call .core.__LOADSTR
	push hl
	ld a, 27
	push af
	ld a, 70
	push af
	call _TextLine
	jp _Update_Mouse__leave
.LABEL.__LABEL64:
	ld a, (ix-1)
	sub 15
	sub 1
	sbc a, a
	ld d, a
	ld a, (ix-1)
	sub 12
	sub 1
	sbc a, a
	or d
	push af
	ld a, (_click)
	dec a
	sub 1
	sbc a, a
	ld h, a
	pop af
	or a
	jr z, .LABEL.__LABEL147
	ld a, h
.LABEL.__LABEL147:
	or a
	jp z, _Update_Mouse__leave
	ld hl, (_mx)
	ld de, 38400
	add hl, de
	push hl
	ld hl, (_my)
	ld de, 80
	call .core.__MUL16_FAST
	ex de, hl
	pop hl
	add hl, de
	ld a, (hl)
	ld hl, (_last_id - 1)
	sub h
	jp nz, .LABEL.__LABEL71
	ld a, (_last_id)
	push af
	call _Process_Button
	ld a, (_dclick)
	dec a
	jp nz, .LABEL.__LABEL72
	ld a, 4
	push af
	ld hl, .LABEL.__LABEL74
	call .core.__LOADSTR
	push hl
	ld a, 27
	push af
	ld a, 70
	push af
	call _TextLine
	jp .LABEL.__LABEL71
.LABEL.__LABEL72:
	ld a, 4
	push af
	ld hl, .LABEL.__LABEL75
	call .core.__LOADSTR
	push hl
	ld a, 27
	push af
	ld a, 70
	push af
	call _TextLine
.LABEL.__LABEL71:
	ld a, 2
	ld (_click), a
_Update_Mouse__leave:
	ld sp, ix
	pop ix
	ret
_Process_Button:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	inc sp
	xor a
	ld hl, (_dclick - 1)
	cp h
	jp nc, .LABEL.__LABEL76
	ld (ix-1), 10
	jp .LABEL.__LABEL77
.LABEL.__LABEL76:
	ld (ix-1), 1
.LABEL.__LABEL77:
	ld a, (ix+5)
	dec a
	jp nz, .LABEL.__LABEL78
	ld a, (_slen)
	add a, (ix-1)
	ld h, a
	ld a, (_position)
	cp h
	jp nc, .LABEL.__LABEL81
	ld a, (_position)
	add a, (ix-1)
	ld (_position), a
	call _TextPatternUpdate
.LABEL.__LABEL81:
	jp _Process_Button__leave
.LABEL.__LABEL78:
	ld a, (ix+5)
	sub 2
	jp nz, _Process_Button__leave
	ld a, (ix-1)
	dec a
	ld hl, (_position - 1)
	cp h
	jp nc, _Process_Button__leave
	ld a, (_position)
	sub (ix-1)
	ld (_position), a
	call _TextPatternUpdate
_Process_Button__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_TextPatternUpdate:
	ld a, (_position)
	call _Get_Position
	ld a, 14
	push af
	ld a, (_position)
	ld l, a
	ld h, 0
	push hl
	call _hex16
	push hl
	ld a, 2
	push af
	ld a, 17
	push af
	call _TextLine
	ld a, 14
	push af
	ld a, (_pattern)
	ld l, a
	ld h, 0
	push hl
	call _hex16
	push hl
	ld a, 3
	push af
	ld a, 17
	push af
	call _TextLine
	ld a, 14
	push af
	ld a, (_slen)
	ld l, a
	ld h, 0
	push hl
	call _hex16
	push hl
	ld a, 4
	push af
	ld a, 17
	push af
	call _TextLine
	ld a, (_position)
	push af
	xor a
	push af
	call _Show_Row
_TextPatternUpdate__leave:
	ret
_Draw_Box:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	push hl
	push hl
	ld l, (ix+4)
	ld h, (ix+5)
	ld (ix-6), l
	ld (ix-5), h
.LABEL.__LABEL86:
	ld l, (ix-6)
	ld h, (ix-5)
	inc hl
	ld a, (hl)
	ld l, a
	ld h, 0
	ld (_x1), hl
	ld de, 255
	ld hl, (_x1)
	call .core.__EQ16
	or a
	jp nz, _Draw_Box__leave
	ld l, (ix-6)
	ld h, (ix-5)
	ld a, (hl)
	ld h, a
	xor a
	cp h
	jp nc, .LABEL.__LABEL91
	ld hl, (_x1)
	ld de, 256
	add hl, de
	ld (_x1), hl
.LABEL.__LABEL91:
	ld l, (ix-6)
	ld h, (ix-5)
	inc hl
	inc hl
	ld a, (hl)
	inc a
	ld (_y1), a
	ld l, (ix-6)
	ld h, (ix-5)
	inc hl
	inc hl
	inc hl
	ld a, (hl)
	ld (_x2), a
	ld a, 160
	ld hl, (_x2 - 1)
	cp h
	jp c, _Draw_Box__leave
	ld l, (ix-6)
	ld h, (ix-5)
	ld de, 4
	add hl, de
	ld a, (hl)
	dec a
	ld (_y2), a
	ld l, (ix-6)
	ld h, (ix-5)
	ld de, 6
	add hl, de
	ld a, (hl)
	ld (_co), a
	ld l, (ix-6)
	ld h, (ix-5)
	ld de, 5
	add hl, de
	ld a, (hl)
	ld (ix-2), a
	or a
	jp nz, .LABEL.__LABEL94
	ld (ix-3), 5
	ld (ix-4), 2
	jp .LABEL.__LABEL95
.LABEL.__LABEL94:
	ld a, (ix-2)
	dec a
	jp nz, .LABEL.__LABEL96
	ld (ix-3), 2
	ld (ix-4), 5
	jp .LABEL.__LABEL95
.LABEL.__LABEL96:
	ld a, (ix-2)
	sub 2
	jp nz, .LABEL.__LABEL98
	ld (ix-3), 7
	ld (ix-4), 7
	jp .LABEL.__LABEL95
.LABEL.__LABEL98:
	ld a, (ix-2)
	sub 4
	jp nz, .LABEL.__LABEL100
	ld (ix-3), 2
	ld (ix-4), 2
	ld a, 1
	ld (_co), a
	jp .LABEL.__LABEL95
.LABEL.__LABEL100:
	ld a, (ix-2)
	sub 5
	jp nz, .LABEL.__LABEL95
	ld a, (_co)
	ld (ix-3), a
	ld a, (_co)
	ld (ix-4), a
.LABEL.__LABEL95:
	ld hl, (_y1 - 1)
	ld a, (_y2)
	add a, h
	ld (ix-1), a
	ld a, (_x2)
	ld l, a
	ld h, 0
	add hl, hl
	ld (_xu), hl
	ld de, (_xu)
	ld hl, (_x1)
	add hl, de
	inc hl
	ld (_xu), hl
	ld hl, (_x1)
	ld (_xt), hl
	jp .LABEL.__LABEL104
.LABEL.__LABEL107:
	ld a, (_co)
	push af
	ld a, (_y2)
	push af
	ld hl, (_xt)
	push hl
	ld a, (_y1)
	call _FPlotLineV
	ld hl, (_xt)
	inc hl
	ld (_xt), hl
.LABEL.__LABEL104:
	ld hl, (_xu)
	ld de, (_xt)
	or a
	sbc hl, de
	jp nc, .LABEL.__LABEL107
	ld a, (_co)
	or a
	jp z, _Draw_Box__leave
	ld hl, (_x1)
	ld (_xt), hl
	jp .LABEL.__LABEL111
.LABEL.__LABEL114:
	ld a, (ix-3)
	push af
	ld hl, (_xt)
	push hl
	ld a, (_y1)
	call _FPlotL2
	ld a, (ix-4)
	push af
	ld hl, (_xt)
	push hl
	ld a, (ix-1)
	call _FPlotL2
	ld hl, (_xt)
	inc hl
	ld (_xt), hl
.LABEL.__LABEL111:
	ld hl, (_xu)
	ld de, (_xt)
	or a
	sbc hl, de
	jp nc, .LABEL.__LABEL114
	ld a, (ix-3)
	push af
	ld a, (_y2)
	push af
	ld hl, (_x1)
	push hl
	ld a, (_y1)
	call _FPlotLineV
	ld a, (ix-4)
	push af
	ld a, (_y2)
	push af
	ld hl, (_xu)
	push hl
	ld a, (_y1)
	call _FPlotLineV
	ld a, (ix-2)
	cp 4
	jp nc, .LABEL.__LABEL117
	ld a, 4
	push af
	ld hl, (_xu)
	push hl
	ld a, (_y1)
	call _FPlotL2
	ld a, 4
	push af
	ld hl, (_x1)
	push hl
	ld a, (ix-1)
	call _FPlotL2
.LABEL.__LABEL117:
	ld l, (ix-6)
	ld h, (ix-5)
	ld de, 7
	add hl, de
	ld (ix-6), l
	ld (ix-5), h
	jp .LABEL.__LABEL86
_Draw_Box__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_Draw_Button:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, -9
	add hl, sp
	ld sp, hl
	ld (hl), 0
	ld bc, 8
	ld d, h
	ld e, l
	inc de
	ldir
	ld l, (ix+4)
	ld h, (ix+5)
	ld (_add), hl
	ld hl, .LABEL._buttontmp
	ld (_add2), hl
.LABEL.__LABEL118:
	ld de, .LABEL.__LABEL0
	ld hl, _tempstr
	call .core.__STORE_STR
	ld hl, _tempstr
	push hl
	ld a, 44
	push af
	ld hl, (_add)
	ld de, 5
	add hl, de
	call _PeekMem
	ld hl, (_tempstr)
	call .core.__STRLEN
	ld (ix-9), l
	ld (ix-8), h
	ld hl, (_add)
	ld a, (hl)
	ld (ix-2), a
	ld hl, (_add)
	inc hl
	ld a, (hl)
	ld l, a
	ld h, 0
	ld (ix-7), l
	ld (ix-6), h
	ld hl, (_add)
	inc hl
	inc hl
	ld a, (hl)
	ld (ix-4), a
	ld hl, (_add)
	inc hl
	inc hl
	inc hl
	ld a, (hl)
	ld (ix-3), a
	ld hl, (_add)
	ld de, 4
	add hl, de
	ld a, (hl)
	ld (ix-5), a
	ld l, (ix-9)
	ld h, (ix-8)
	add hl, hl
	ld a, l
	inc a
	ld (ix-1), a
	ld hl, (_add2)
	inc hl
	ld a, (ix-2)
	add a, a
	add a, a
	dec a
	ld (hl), a
	ld hl, (_add2)
	inc hl
	inc hl
	push hl
	ld l, (ix-7)
	ld h, (ix-6)
	add hl, hl
	add hl, hl
	add hl, hl
	dec hl
	ld a, l
	pop hl
	ld (hl), a
	ld hl, (_add2)
	inc hl
	inc hl
	inc hl
	ld a, (ix-1)
	ld (hl), a
	ld hl, (_add2)
	ld de, 4
	add hl, de
	ld a, 8
	ld (hl), a
	ld hl, (_add2)
	ld de, 5
	add hl, de
	ld a, (ix-4)
	ld (hl), a
	ld hl, (_add2)
	ld de, 6
	add hl, de
	ld a, 4
	ld (hl), a
	ld hl, .LABEL._buttontmp
	push hl
	call _Draw_Box
	ld a, (ix-3)
	push af
	ld hl, (_tempstr)
	call .core.__LOADSTR
	push hl
	ld l, (ix-7)
	ld h, (ix-6)
	ld a, l
	push af
	ld a, (ix-2)
	push af
	call _TextLine
	ld a, (ix-5)
	add a, a
	ld l, a
	ld h, 0
	ex de, hl
	ld hl, .LABEL._objectbuffer
	add hl, de
	push hl
	ld hl, (_add)
	ex de, hl
	pop hl
	ld (hl), e
	inc hl
	ld (hl), d
	ld a, (ix-5)
	ld h, a
	xor a
	cp h
	jp nc, .LABEL.__LABEL121
	ld l, (ix-7)
	ld h, (ix-6)
	ld de, 80
	call .core.__MUL16_FAST
	ld (_y), hl
	ld a, (ix-2)
	ld l, a
	ld h, 0
	ld (_x), hl
	jp .LABEL.__LABEL122
.LABEL.__LABEL125:
	ld hl, (_x)
	ld de, 38400
	add hl, de
	ex de, hl
	ld hl, (_y)
	add hl, de
	ld a, (ix-5)
	ld (hl), a
	ld hl, (_x)
	inc hl
	ld (_x), hl
.LABEL.__LABEL122:
	ld a, (ix-2)
	ld l, a
	ld h, 0
	push hl
	ld l, (ix-9)
	ld h, (ix-8)
	ex de, hl
	pop hl
	add hl, de
	ld de, (_x)
	or a
	sbc hl, de
	jp nc, .LABEL.__LABEL125
.LABEL.__LABEL121:
	ld l, (ix-9)
	ld h, (ix-8)
	ex de, hl
	ld hl, (_add)
	add hl, de
	ld de, 6
	add hl, de
	ld a, (hl)
	sub 255
	jp z, _Draw_Button__leave
	ld l, (ix-9)
	ld h, (ix-8)
	ex de, hl
	ld hl, (_add)
	add hl, de
	ld de, 7
	add hl, de
	ld (_add), hl
	jp .LABEL.__LABEL118
_Draw_Button__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	ex (sp), hl
	exx
	ret
_Draw_Press:
	push ix
	ld ix, 0
	add ix, sp
	ld hl, 0
	push hl
	push hl
	push hl
	ld l, (ix+4)
	ld h, (ix+5)
	ld (_add), hl
	ld hl, .LABEL._buttontmp
	ld (_add2), hl
	ld de, .LABEL.__LABEL0
	ld hl, _tempstr
	call .core.__STORE_STR
	ld hl, _tempstr
	push hl
	ld a, 44
	push af
	ld hl, (_add)
	ld de, 5
	add hl, de
	call _PeekMem
	ld hl, (_tempstr)
	call .core.__STRLEN
	ld a, l
	ld (ix-4), a
	ld hl, (_add)
	ld a, (hl)
	ld (ix-2), a
	ld hl, (_add)
	inc hl
	ld a, (hl)
	ld l, a
	ld h, 0
	ld (ix-6), l
	ld (ix-5), h
	ld a, (ix-4)
	add a, a
	inc a
	ld (ix-1), a
	ld hl, (_add)
	inc hl
	inc hl
	ld a, (hl)
	ld (ix-3), a
	ld hl, (_add2)
	inc hl
	ld a, (ix-2)
	add a, a
	add a, a
	dec a
	ld (hl), a
	ld hl, (_add2)
	inc hl
	inc hl
	push hl
	ld l, (ix-6)
	ld h, (ix-5)
	add hl, hl
	add hl, hl
	add hl, hl
	dec hl
	ld a, l
	pop hl
	ld (hl), a
	ld hl, (_add2)
	inc hl
	inc hl
	inc hl
	ld a, (ix-1)
	ld (hl), a
	ld hl, (_add2)
	ld de, 4
	add hl, de
	ld a, 8
	ld (hl), a
	ld a, (ix-3)
	sub 4
	jp nz, .LABEL.__LABEL130
	ld (ix+7), 4
.LABEL.__LABEL130:
	ld hl, (_add2)
	ld de, 5
	add hl, de
	ld a, (ix+7)
	ld (hl), a
	ld a, (ix+7)
	cp 4
	jp nc, .LABEL.__LABEL131
	ld hl, (_add2)
	ld de, 6
	add hl, de
	ld a, 4
	ld (hl), a
	jp .LABEL.__LABEL132
.LABEL.__LABEL131:
	ld hl, (_add2)
	ld de, 6
	add hl, de
	ld a, 3
	ld (hl), a
.LABEL.__LABEL132:
	ld hl, .LABEL._buttontmp
	push hl
	call _Draw_Box
_Draw_Press__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	ex (sp), hl
	exx
	ret
_GetElement:
	push ix
	ld ix, 0
	add ix, sp
#line 959 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"






		ld      l, (ix+4)
		ld      h, (ix+5)

		ld      c, (hl)

		ld      a, (ix+7)
		call    _get_element
		jp      ._GetElement__leave

_get_element:
		swapnib
		and     %0001111
		srl     a
		srl     a
		add     a, a
		add     a, c

		nextreg MMU0_0000_NR_50, a
		inc     a
		nextreg MMU1_2000_NR_51, a

		ld      a,(ix+7)
		and     63
		ld      h, a
		ld      l, 0


		ld      a, (hl)
		or      a
		jp      nz,garray_not_null
		ld      hl, garry_empty_arraystr
		jp      gempty_array_position

garray_not_null:
		inc     hl
		inc     hl
		inc     hl



gempty_array_position:

		ld      de, ._ArrayStr
		ex      de, hl
		call    .core.__STORE_STR


		nextreg MMU0_0000_NR_50, $ff
		nextreg MMU1_2000_NR_51, $ff

		jr      _GetElement__leave

garry_empty_arraystr:
		db      0, 0,"",0

garray_str_position:
		dw      0000
garray_str_pointer:
		dw      0000


#line 1026 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
_GetElement__leave:
	ld sp, ix
	pop ix
	exx
	pop hl
	pop bc
	ex (sp), hl
	exx
	ret
_PutElement:
	push ix
	ld ix, 0
	add ix, sp
#line 1031 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"








		ld      l, (ix+6)
		ld      h, (ix+7)
		push    hl
		ld      e, (ix+4)
		ld      d, (ix+5)
		ld      c, (ix+8)
		ld      a,(hl)
		inc     hl
		ld      h,(hl)
		ld      l, a
		ld      (array_str_length), hl

		ld      a, (de)

		call    _put_array
		jp      ._PutElement__leave

_put_array:
		push    de
		ld      h, a


		ld      a, c
		swapnib
		and     %00001111
		srl     a
		srl     a
		add     a, a
		add     a, h

		nextreg MMU0_0000_NR_50, a
		inc     a
		nextreg MMU1_2000_NR_51, a

		ld      a,c
		and     63
		ld      h, a



		ld      l, 0

		ld      (hl), 1
		inc     hl
		inc     hl
		inc     hl

		ld      bc,(array_str_length)
		ld      (hl),c
		inc     hl
		ld      (hl),b
		inc     hl
		inc     bc
		inc     bc
		ld      b, 0
		pop     de


		ex      de, hl

		ldir

		nextreg MMU0_0000_NR_50,$ff
		nextreg MMU1_2000_NR_51,$ff
		ret


#line 1106 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1107 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"


array_str_length:
		dw      0000
array_str_last_position:
		dw      0000
array_str_position:
		dw      0000
arra_str_size:
		dw      0000
array_str_pointer:
		dw      0000


#line 1121 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
_PutElement__leave:
	ex af, af'
	exx
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
	pop bc
	ex (sp), hl
	exx
	ret
_PeekMem:
#line 1286 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

		push namespace peekmem
main:
		ex de, hl
		pop hl
		pop af
		ex (sp),hl



		push bc
		push hl
		ex de, hl
		ld de,.LABEL._string_temp+2
		ld bc,0
copyloop:
		cp (hl)
		jr z,endcopy
		push bc
		ldi
		pop bc
		inc c
		jr nz,copyloop
		dec c
endcopy:
		ld (.LABEL._string_temp),bc
		pop hl
		ld de,.LABEL._string_temp


		pop bc
		pop namespace
		jp .core.__STORE_STR

#line 1320 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
_PeekMem__leave:
	ret
_SetRGB:
	push ix
	ld ix, 0
	add ix, sp
#line 1503 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"







Set_Palette_RGB:
		ld  a, (ix + 5)
		ld  b, (ix + 7)
		ld  c, (ix + 9)
		ld  d, (ix + 11)

		nextreg PALETTE_INDEX_NR_40, A


		LD	A, B
		AND	%00000111

		DB $ED,$23
#line 1522
		ADD	A, A
		LD	B, A
		LD	A, C
		AND	%00000111
		ADD	A, A
		ADD	A, A
		OR	B
		LD	B, A
		LD	A, D
		AND	%00000110
		RRA
		OR	B
		LD	B, A
		nextreg PALETTE_VALUE_9BIT_NR_44,a
		LD	A, D
		AND	%00000001
		LD	C, A
		nextreg PALETTE_VALUE_9BIT_NR_44,a

#line 1543 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
_SetRGB__leave:
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
.LABEL.__LABEL0:
	DEFW 0000h
.LABEL.__LABEL29:
	DEFW 0003h
	DEFB 20h
	DEFB 2Dh
	DEFB 20h
.LABEL.__LABEL30:
	DEFW 0001h
	DEFB 20h
.LABEL.__LABEL36:
	DEFW 0028h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
.LABEL.__LABEL66:
	DEFW 0003h
	DEFB 2Dh
	DEFB 2Dh
	DEFB 2Dh
.LABEL.__LABEL67:
	DEFW 0007h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
	DEFB 20h
.LABEL.__LABEL74:
	DEFW 0007h
	DEFB 44h
	DEFB 6Fh
	DEFB 75h
	DEFB 62h
	DEFB 20h
	DEFB 63h
	DEFB 6Ch
.LABEL.__LABEL75:
	DEFW 0007h
	DEFB 43h
	DEFB 6Ch
	DEFB 69h
	DEFB 63h
	DEFB 6Bh
	DEFB 65h
	DEFB 64h
	;; --- end of user code ---
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

#line 70 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/alloc.asm"


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

#line 1641 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/border.asm"
	; __FASTCALL__ Routine to change de border
	; Parameter (color) specified in A register

	    push namespace core

	BORDER EQU 229Bh

	    pop namespace


	; Nothing to do! (Directly from the ZX Spectrum ROM)
#line 1642 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
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

#line 1643 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
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

#line 1644 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/loadstr.asm"


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
#line 1645 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
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
#line 1646 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/pstorestr2.asm"
; vim:ts=4:et:sw=4
	;
	; Stores an string (pointer to the HEAP by DE) into the address pointed
	; by (IX + BC). No new copy of the string is created into the HEAP, since
	; it's supposed it's already created (temporary string)
	;

#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/storestr2.asm"
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

#line 9 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/pstorestr2.asm"

	    push namespace core

__PSTORE_STR2:
	    push ix
	    pop hl
	    add hl, bc
	    jp __STORE_STR2

	    pop namespace

#line 1647 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/storestr.asm"
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


#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/strcpy.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/realloc.asm"
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

#line 2 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/strcpy.asm"

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

#line 14 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/storestr.asm"

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

#line 1648 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/str.asm"
	; The STR$( ) BASIC function implementation

	; Given a FP number in C ED LH
	; Returns a pointer (in HL) to the memory heap
	; containing the FP number string representation


#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/stackf.asm"
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
#line 9 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/str.asm"
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
#line 10 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/str.asm"

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

#line 1649 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/strcat.asm"

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


#line 3 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/strcat.asm"

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

#line 1650 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

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

#line 1652 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/u32tofreg.asm"
#line 1 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/neg32.asm"
	    push namespace core

__ABS32:
	    bit 7, d
	    ret z

__NEG32: ; Negates DEHL (Two's complement)
	    ld a, l
	    cpl
	    ld l, a

	    ld a, h
	    cpl
	    ld h, a

	    ld a, e
	    cpl
	    ld e, a

	    ld a, d
	    cpl
	    ld d, a

	    inc l
	    ret nz

	    inc h
	    ret nz

	    inc de
	    ret

	    pop namespace

#line 2 "C:/NextBuildv8/zxbasic/src/arch/zxnext/library-asm/u32tofreg.asm"
	    push namespace core

__I8TOFREG:
	    ld l, a
	    rlca
	    sbc a, a	; A = SGN(A)
	    ld h, a
	    ld e, a
	    ld d, a

__I32TOFREG:	; Converts a 32bit signed integer (stored in DEHL)
	    ; to a Floating Point Number returned in (A ED CB)

	    ld a, d
	    or a		; Test sign

	    jp p, __U32TOFREG	; It was positive, proceed as 32bit unsigned

	    call __NEG32		; Convert it to positive
	    call __U32TOFREG	; Convert it to Floating point

	    set 7, e			; Put the sign bit (negative) in the 31bit of mantissa
	    ret

__U8TOFREG:
	    ; Converts an unsigned 8 bit (A) to Floating point
	    ld l, a
	    ld h, 0
	    ld e, h
	    ld d, h

__U32TOFREG:	; Converts an unsigned 32 bit integer (DEHL)
	    ; to a Floating point number returned in A ED CB

	    PROC

	    LOCAL __U32TOFREG_END

	    ld a, d
	    or e
	    or h
	    or l
	    ld b, d
	    ld c, e		; Returns 00 0000 0000 if ZERO
	    ret z

	    push de
	    push hl

	    exx
	    pop de  ; Loads integer into B'C' D'E'
	    pop bc
	    exx

	    ld l, 128	; Exponent
	    ld bc, 0	; DEBC = 0
	    ld d, b
	    ld e, c

__U32TOFREG_LOOP: ; Also an entry point for __F16TOFREG
	    exx
	    ld a, d 	; B'C'D'E' == 0 ?
	    or e
	    or b
	    or c
	    jp z, __U32TOFREG_END	; We are done

	    srl b ; Shift B'C' D'E' >> 1, output bit stays in Carry
	    rr c
	    rr d
	    rr e
	    exx

	    rr e ; Shift EDCB >> 1, inserting the carry on the left
	    rr d
	    rr c
	    rr b

	    inc l	; Increment exponent
	    jp __U32TOFREG_LOOP


__U32TOFREG_END:
	    exx
	    ld a, l     ; Puts the exponent in a
	    res 7, e	; Sets the sign bit to 0 (positive)

	    ret
	    ENDP

	    pop namespace

#line 1653 "C:\\NextBuildv8\\Sources\\TileMapBrowser\\Tracker-NXMOD-2-with-decode.bas"

	END
