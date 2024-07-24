'!ORGas ubyte = 24576
' FDoTile8 example, same as FDoTile16
' em00k dec20
'
CONST	BITUP	as ubyte = 	4	'	16
CONST	BITDOWN	as ubyte = 	5	'	32
CONST	BITLEFT	as ubyte = 	6	'	64
CONST	BITRIGHT	as ubyte = 	7	'	128
CONST	DIRNONE	as ubyte = 	%00000000
CONST	DIRUP	as ubyte = 	%00010000
CONST	DIRDOWN	as ubyte = 	%00100000
CONST	DIRLEFT	as ubyte = 	%01000000
CONST	DIRRIGHT	as ubyte = 	%10000000
CONST	DIRUPI	as ubyte = 	%11101111
CONST	DIRDOWNI	as ubyte = 	%11011111
CONST	DIRLEFTI	as ubyte = 	%10111111
CONST	DIRRIGHTI	as ubyte = 	%01111111
CONST	ULAPFE	as ubyte = 	$FE	'	BORDER	+	MIC	+	BEEP	+	read	Keyboard
CONST	TIMEXPFF	as ubyte = 	$FF	'	Timex	video	control	port
CONST	ZX128MEMORYP7FFD	as ubyte = 	$7FFD	'	ZX	Spectrum	128	ports
CONST	ZX128MEMORYPDFFD	as ubyte = 	$DFFD
CONST	ZX128P3MEMORYP1FFD	as ubyte = 	$1FFD
CONST	AYREGPFFFD	as ubyte = 	$FFFD
CONST	AYDATAPBFFD	as ubyte = 	$BFFD
CONST	Z80DMAPORTDATAGEAR	as ubyte = 	$6B	'	on	ZXN	the	zxnDMA	handles	this	in	zxnDMA	mode
CONST	Z80DMAPORTMB02	as ubyte = 	$0B	'	on	ZXN	the	zxnDMA	handles	this	in	Zilog	mode
CONST	DIVMMCCONTROLPE3	as ubyte = 	$E3
CONST	SPICSPE7	as ubyte = 	$E7
CONST	SPIDATAPEB	as ubyte = 	$EB
CONST	KEMPSTONMOUSEXPFBDF	as ubyte = 	$FBDF
CONST	KEMPSTONMOUSEYPFFDF	as ubyte = 	$FFDF
CONST	KEMPSTONMOUSEBPFADF	as ubyte = 	$FADF	'	kempston	mouse	wheel+buttons
CONST	KEMPSTONJOY1P1F	as ubyte = 	$1F
CONST	KEMPSTONJOY2P37	as ubyte = 	$37
CONST	TBBLUEREGISTERSELECTP243B	as ubyte = 	$243B
CONST	TBBLUEREGISTERACCESSP253B	as ubyte = 	$253B
CONST	DACGSCOVOXINDEX	as ubyte = 	1
CONST	DACPENTAGONATMINDEX	as ubyte = 	2
CONST	DACSPECDRUMINDEX	as ubyte = 	3
CONST	DACSOUNDRIVE1INDEX	as ubyte = 	4
CONST	DACSOUNDRIVE2INDEX	as ubyte = 	5
CONST	DACCOVOXINDEX	as ubyte = 	6
CONST	DACPROFICOVOXINDEX	as ubyte = 	7
CONST	I2CSCLP103B	as ubyte = 	$103B	'	i2c	bus	port	(clock)	(write	only?)
CONST	I2CSDAP113B	as ubyte = 	$113B	'	i2c	bus	port	(data)	(read+write)
CONST	UARTTXP133B	as ubyte = 	$133B	'	UART	tx	port	(read+write)
CONST	UARTRXP143B	as ubyte = 	$143B	'	UART	rx	port	(read+write)
CONST	UARTCTRLP153B	as ubyte = 	$153B	'	UART	control	port	(read+write)
CONST	ZILOGDMAP0B	as ubyte = 	$0B
CONST	ZXNDMAP6B	as ubyte = 	$6B
CONST	LAYER2ACCESSP123B	as ubyte = 	$123B
CONST	LAYER2ACCESSWRITEOVERROM	as ubyte = 	$01	'	map	Layer2	bank	into	ROM	area	(0000..3FFF)	for	WRITE-only	(reads	as	ROM)
CONST	LAYER2ACCESSL2ENABLED	as ubyte = 	$02	'	enable	Layer2	(make	banks	form	nextreg	$12	visible)
CONST	LAYER2ACCESSREADOVERROM	as ubyte = 	$04	'	map	Layer2	bank	into	ROM	area	(0000..3FFF)	for	READ-only
CONST	LAYER2ACCESSSHADOWOVERROM	as ubyte = 	$08	'	bank	selected	by	bits	6-7	is	from	"shadow	Layer	2"	banks	range	(nextreg	$13)
CONST	LAYER2ACCESSBANKOFFSET	as ubyte = 	$10	'	bit	2-0	is	bank	offset	for	current	active	mapping	+0..+7	(other	bits	are	reserved,	use	0)
CONST	LAYER2ACCESSOVERROMBANKM	as ubyte = 	$C0	'	(mask	of)	value	0..3	selecting	bank	mapped	for	R/W	(Nextreg	$12	or	$13)
CONST	LAYER2ACCESSOVERROMBANK0	as ubyte = 	$00	'	screen	lines	0..63	(256x192)	or	columns	0..63	(320x256)	or	columns	0..127	(640x256)
CONST	LAYER2ACCESSOVERROMBANK1	as ubyte = 	$40	'	screen	lines	64..127	(256x192)	or	columns	64..127	(320x256)	or	columns	128..255	(640x256)
CONST	LAYER2ACCESSOVERROMBANK2	as ubyte = 	$80	'	screen	lines	128..191	(256x192)	or	columns	128..191	(320x256)	or	columns	256..383	(640x256)
CONST	LAYER2ACCESSOVERROM48K	as ubyte = 	$C0	'	maps	all	0..191	lines	into	$0000..$BFFF	region	(256x192)	or	2/3	of	columns	in	320x256/640x256
CONST	SPRITESTATUSSLOTSELECTP303B	as ubyte = 	$303B
CONST	SPRITESTATUSMAXIMUMSPRITES	as ubyte = 	$02
CONST	SPRITESTATUSCOLLISION	as ubyte = 	$01
CONST	SPRITESLOTSELECTPATTERNHALF	as ubyte = 	128	'	add	it	to	0..63	index	to	make	pattern	upload	start	at	second	half	of	pattern
CONST	SPRITEATTRIBUTEP57	as ubyte = 	$57
CONST	SPRITEPATTERNP5B	as ubyte = 	$5B
CONST	TURBOSOUNDCONTROLPFFFD	as ubyte = 	$FFFD	'	write	with	bit	7	as ubyte = 	1	(port	shared	with	AY)
CONST	MACHINEIDNR00	as ubyte = 	$00
CONST	NEXTVERSIONNR01	as ubyte = 	$01
CONST	NEXTRESETNR02	as ubyte = 	$02
CONST	MACHINETYPENR03	as ubyte = 	$03
CONST	ROMMAPPINGNR04	as ubyte = 	$04	'In	config	mode,	allows	RAM	to	be	mapped	to	ROM	area.
CONST	PERIPHERAL1NR05	as ubyte = 	$05	'Sets	joystick	mode,	video	fras ubyte = ency	and	Scandoubler.
CONST	PERIPHERAL2NR06	as ubyte = 	$06	'Enables	turbo/50Hz/60Hz	keys,	DivMMC,	Multiface	and	audio	(beep/AY)
CONST	TURBOCONTROLNR07	as ubyte = 	$07
CONST	PERIPHERAL3NR08	as ubyte = 	$08	'ABC/ACB	Stereo,	Internal	Speaker,	SpecDrum,	Timex	Video	Modes,	Turbo	Sound	Next,	RAM	contention	and	[un]lock	128k	paging.
CONST	PERIPHERAL4NR09	as ubyte = 	$09	'Sets	scanlines,	AY	mono	output,	Sprite-id	lockstep,	disables	Kempston	and	divMMC	ports.
CONST	PERIPHERAL5NR0A	as ubyte = 	$0A	'Mouse	buttons	and	DPI	settings	(core	3.1.5)
CONST	NEXTVERSIONMINORNR0E	as ubyte = 	$0E
CONST	ANTIBRICKNR10	as ubyte = 	$10
CONST	VIDEOTIMINGNR11	as ubyte = 	$11
CONST	LAYER2RAMBANKNR12	as ubyte = 	$12	'bank	number	where	visible	Layer	2	video	memory	begins.
CONST	LAYER2RAMSHADOWBANKNR13	as ubyte = 	$13	'bank	number	for	"shadow"	write-over-rom	mapping
CONST	GLOBALTRANSPARENCYNR14	as ubyte = 	$14	'Sets	the	color	treated	as	transparent	for	ULA/Layer2/LoRes
CONST	SPRITECONTROLNR15	as ubyte = 	$15	'LoRes	mode,	Sprites	configuration,	layers	priority
CONST	LAYER2XOFFSETNR16	as ubyte = 	$16
CONST	LAYER2YOFFSETNR17	as ubyte = 	$17
CONST	CLIPLAYER2NR18	as ubyte = 	$18
CONST	CLIPSPRITENR19	as ubyte = 	$19
CONST	CLIPULALORESNR1A	as ubyte = 	$1A
CONST	CLIPTILEMAPNR1B	as ubyte = 	$1B
CONST	CLIPWINDOWCONTROLNR1C	as ubyte = 	$1C	'set	to	15	to	reset	all	clip-window	indices	to	0
CONST	VIDEOLINEMSBNR1E	as ubyte = 	$1E
CONST	VIDEOLINELSBNR1F	as ubyte = 	$1F
CONST	VIDEOINTERUPTCONTROLNR22	as ubyte = 	$22	'Controls	the	timing	of	raster	interrupts	and	the	ULA	frame	interrupt.
CONST	VIDEOINTERUPTVALUENR23	as ubyte = 	$23
CONST	ULAXOFFSETNR26	as ubyte = 	$26	'since	core	3.0
CONST	ULAYOFFSETNR27	as ubyte = 	$27	'since	core	3.0
CONST	HIGHADRESSKEYMAPNR28	as ubyte = 	$28	'reads	first	8b	part	of	value	written	to	$44	(even	unfinished	16b	write)
CONST	LOWADRESSKEYMAPNR29	as ubyte = 	$29
CONST	HIGHDATATOKEYMAPNR2A	as ubyte = 	$2A
CONST	LOWDATATOKEYMAPNR2B	as ubyte = 	$2B
CONST	DACBMIRRORNR2C	as ubyte = 	$2C	'reads	as	MSB	of	Pi	I2S	left	side	sample,	LSB	waits	at	$2D
CONST	DACADMIRRORNR2D	as ubyte = 	$2D	'another	alias	for	$2D,	reads	LSB	of	value	initiated	by	$2C	or	$2E	read
CONST	SOUNDDRIVEDFMIRRORNR2D	as ubyte = 	$2D	'Nextreg	port-mirror	of	port	0xDF
CONST	DACCMIRRORNR2E	as ubyte = 	$2E	'reads	as	MSB	of	Pi	I2S	right	side	sample,	LSB	waits	at	$2D
CONST	TILEMAPXOFFSETMSBNR2F	as ubyte = 	$2F
CONST	TILEMAPXOFFSETLSBNR30	as ubyte = 	$30
CONST	TILEMAPYOFFSETNR31	as ubyte = 	$31
CONST	LORESXOFFSETNR32	as ubyte = 	$32
CONST	LORESYOFFSETNR33	as ubyte = 	$33
CONST	SPRITEATTRSLOTSELNR34	as ubyte = 	$34	'Sprite-attribute	slot	index	for	$35-$39/$75-$79	port	$57	mirrors
CONST	SPRITEATTR0NR35	as ubyte = 	$35	'port	$57	mirror	in	nextreg	space	(accessible	to	copper)
CONST	SPRITEATTR1NR36	as ubyte = 	$36
CONST	SPRITEATTR2NR37	as ubyte = 	$37
CONST	SPRITEATTR3NR38	as ubyte = 	$38
CONST	SPRITEATTR4NR39	as ubyte = 	$39
CONST	PALETTEINDEXNR40	as ubyte = 	$40	'Chooses	a	ULANext	palette	number	to	configure.
CONST	PALETTEVALUENR41	as ubyte = 	$41	'Used	to	upload	8-bit	colors	to	the	ULANext	palette.
CONST	PALETTEFORMATNR42	as ubyte = 	$42	'ink-mask	for	ULANext	modes
CONST	PALETTECONTROLNR43	as ubyte = 	$43	'Enables	or	disables	ULANext	interpretation	of	attribute	values	and	toggles	active	palette.
CONST	PALETTEVALUE9BITNR44	as ubyte = 	$44	'Holds	the	additional	blue	color	bit	for	RGB333	color	selection.
CONST	TRANSPARENCYFALLBACKCOLNR4A	as ubyte = 	$4A	'8-bit	colour	to	be	drawn	when	all	layers	are	transparent
CONST	SPRITETRANSPARENCYINR4B	as ubyte = 	$4B	'index	of	transparent	colour	in	sprite	palette	(only	bottom	4	bits	for	4-bit	patterns)
CONST	TILEMAPTRANSPARENCYINR4C	as ubyte = 	$4C	'index	of	transparent	colour	in	tilemap	graphics	(only	bottom	4	bits)
CONST	MMU00000NR50	as ubyte = 	$50	'Set	a	Spectrum	RAM	page	at	position	0x0000	to	0x1FFF
CONST	MMU12000NR51	as ubyte = 	$51	'Set	a	Spectrum	RAM	page	at	position	0x2000	to	0x3FFF
CONST	MMU24000NR52	as ubyte = 	$52	'Set	a	Spectrum	RAM	page	at	position	0x4000	to	0x5FFF
CONST	MMU36000NR53	as ubyte = 	$53	'Set	a	Spectrum	RAM	page	at	position	0x6000	to	0x7FFF
CONST	MMU48000NR54	as ubyte = 	$54	'Set	a	Spectrum	RAM	page	at	position	0x8000	to	0x9FFF
CONST	MMU5A000NR55	as ubyte = 	$55	'Set	a	Spectrum	RAM	page	at	position	0xA000	to	0xBFFF
CONST	MMU6C000NR56	as ubyte = 	$56	'Set	a	Spectrum	RAM	page	at	position	0xC000	to	0xDFFF
CONST	MMU7E000NR57	as ubyte = 	$57	'Set	a	Spectrum	RAM	page	at	position	0xE000	to	0xFFFF
CONST	COPPERDATANR60	as ubyte = 	$60
CONST	COPPERCONTROLLONR61	as ubyte = 	$61
CONST	COPPERCONTROLHINR62	as ubyte = 	$62
CONST	COPPERDATA16BNR63	as ubyte = 	$63	'	same	as	$60,	but	waits	for	full	16b	before	write
CONST	VIDEOLINEOFFSETNR64	as ubyte = 	$64	'	(core	3.1.5)
CONST	ULACONTROLNR68	as ubyte = 	$68
CONST	DISPLAYCONTROLNR69	as ubyte = 	$69
CONST	LORESCONTROLNR6A	as ubyte = 	$6A
CONST	TILEMAPCONTROLNR6B	as ubyte = 	$6B
CONST	TILEMAPDEFAULTATTRNR6C	as ubyte = 	$6C
CONST	TILEMAPBASEADRNR6E	as ubyte = 	$6E	'Tilemap	base	address	of	map
CONST	TILEMAPGFXADRNR6F	as ubyte = 	$6F	'Tilemap	definitions	(graphics	of	tiles)
CONST	LAYER2CONTROLNR70	as ubyte = 	$70
CONST	LAYER2XOFFSETMSBNR71	as ubyte = 	$71	'	for	320x256	and	640x256	L2	modes	(core	3.0.6+)
CONST	SPRITEATTR0INCNR75	as ubyte = 	$75	'port	$57	mirror	in	nextreg	space	(accessible	to	copper)	(slot	index++)
CONST	SPRITEATTR1INCNR76	as ubyte = 	$76
CONST	SPRITEATTR2INCNR77	as ubyte = 	$77
CONST	SPRITEATTR3INCNR78	as ubyte = 	$78
CONST	SPRITEATTR4INCNR79	as ubyte = 	$79
CONST	USERSTORAGE0NR7F	as ubyte = 	$7F
CONST	EXPANSIONBUSENABLENR80	as ubyte = 	$80
CONST	EXPANSIONBUSCONTROLNR81	as ubyte = 	$81
CONST	INTERNALPORTDECODING0NR82	as ubyte = 	$82	'bits	0-7
CONST	INTERNALPORTDECODING1NR83	as ubyte = 	$83	'bits	8-15
CONST	INTERNALPORTDECODING2NR84	as ubyte = 	$84	'bits	16-23
CONST	INTERNALPORTDECODING3NR85	as ubyte = 	$85	'bits	24-31
CONST	EXPANSIONBUSDECODING0NR86	as ubyte = 	$86	'bits	0-7	mask
CONST	EXPANSIONBUSDECODING1NR87	as ubyte = 	$87	'bits	8-15	mask
CONST	EXPANSIONBUSDECODING2NR88	as ubyte = 	$88	'bits	16-23	mask
CONST	EXPANSIONBUSDECODING3NR89	as ubyte = 	$89	'bits	24-31	mask
CONST	EXPANSIONBUSPROPAGATENR8A	as ubyte = 	$8A	'Monitoring	internal	I/O	or	adding	external	keyboard
CONST	ALTERNATEROMNR8C	as ubyte = 	$8C	'Enable	alternate	ROM	or	lock	48k	ROM
CONST	ZXMEMMAPPINGNR8E	as ubyte = 	$8E	'shortcut	to	set	classic	zx128+3	memory	model	at	one	place
CONST	PIGPIOOUTENABLE0NR90	as ubyte = 	$90	'pins	0-7
CONST	PIGPIOOUTENABLE1NR91	as ubyte = 	$91	'pins	8-15
CONST	PIGPIOOUTENABLE2NR92	as ubyte = 	$92	'pins	16-23
CONST	PIGPIOOUTENABLE3NR93	as ubyte = 	$93	'pins	24-27
CONST	PIGPIO0NR98	as ubyte = 	$98	'pins	0-7
CONST	PIGPIO1NR99	as ubyte = 	$99	'pins	8-15
CONST	PIGPIO2NR9A	as ubyte = 	$9A	'pins	16-23
CONST	PIGPIO3NR9B	as ubyte = 	$9B	'pins	24-27
CONST	PIPERIPHERALSENABLENRA0	as ubyte = 	$A0
CONST	PII2SAUDIOCONTROLNRA2	as ubyte = 	$A2
CONST	ESPWIFIGPIOOUTPUTNRA8	as ubyte = 	$A8
CONST	ESPWIFIGPIONRA9	as ubyte = 	$A9
CONST	EXTENDEDKEYS0NRB0	as ubyte = 	$B0	'read	Next	compound	keys	as	standalone	keys	(outside	of	zx48	matrix)
CONST	EXTENDEDKEYS1NRB1	as ubyte = 	$B1	'read	Next	compound	keys	as	standalone	keys	(outside	of	zx48	matrix)
CONST	DEBUGLEDCONTROLNRFF	as ubyte = 	$FF	'Turns	debug	LEDs	on	and	off	on	TBBlue	implementations	that	have	them.
CONST	MEMROMCHARS3C00	as ubyte = 	$3C00	'	actual	chars	start	at	$3D00	with	space
CONST	MEMZXSCREEN4000	as ubyte = 	$4000
CONST	MEMZXATTRIB5800	as ubyte = 	$5800
CONST	MEMLORES04000	as ubyte = 	$4000
CONST	MEMLORES16000	as ubyte = 	$6000
CONST	MEMTIMEXSCR04000	as ubyte = 	$4000
CONST	MEMTIMEXSCR16000	as ubyte = 	$6000
CONST	COPPERNOOP	as ubyte = 	%00000000
CONST	COPPERWAITH	as ubyte = 	%10000000
CONST	COPPERHALTB	as ubyte = 	$FF	'	2x	$FF	as ubyte = 	wait	for	(511,63)	as ubyte = 	infinite	wait
CONST	DMARESET	as ubyte = 	$C3
CONST	DMARESETPORTATIMING	as ubyte = 	$C7
CONST	DMARESETPORTBTIMING	as ubyte = 	$CB
CONST	DMALOAD	as ubyte = 	$CF
CONST	DMACONTINUE	as ubyte = 	$D3
CONST	DMADISABLEINTERUPTS	as ubyte = 	$AF
CONST	DMAENABLEINTERUPTS	as ubyte = 	$AB
CONST	DMARESETDISABLEINTERUPTS	as ubyte = 	$A3
CONST	DMAENABLEAFTERRETI	as ubyte = 	$B7
CONST	DMAREADSTATUSBYTE	as ubyte = 	$BF
CONST	DMAREINITSTATUSBYTE	as ubyte = 	$8B
CONST	DMASTARTREADS as ubyte = 	$A7
CONST	DMAFORCEREADY	as ubyte = 	$B3
CONST	DMADISABLE	as ubyte = 	$83
CONST	DMAENABLE	as ubyte = 	$87
CONST	DMAREADMASKFOLLOWS	as ubyte = 	$BB

#define NEX

asm 
	  di 					;' I recommend ALWAYS disabling interrupts 
end asm 
		
#include <nextlib.bas>

border 0 

nextrega(GLOBALTRANSPARENCYNR14,0)					'; black transparency 
nextrega($70,%00010000)			'; enable 320x256 256col L2 
ClipLayer2(0,255,0,255)			'; make all of L2 visible 
nextrega($69,%10000000)			' enables L2 
nextrega($7,3)					' 28mhz 


' LoadSDBank ( filename$ , dest address, size, offset, 8k start bank )
' dest address always is 0 - 16384, this would be an offset into the banks 
' if you do not know the filesize set size to 0. If the file > 8192 the data
' is loaded into the next consecutive bank. Very handy 

LoadSDBank("sonic.spr",0,0,0,34) 	' file is 16kb, so load into banks 34/35

dim tx,ty,sx,sy, tile  as ubyte 

	
	for ty =  0 to 31 
		for tx =  0 to 39
			' note order of arguments tile, x, y, bank 
			FDoTile8(66,tx,ty,34)
		
		next tx 
	next ty 

do 

	for it =  0 to 16 step 4 
	tile  =  0 
	for ty  =  0 to 7
		for tx  =  0 to 31
			' note order of arguments tile, x, y, bank 
			FDoTile8(tile,tx,it+ty,34)
			tile= tile+1 
			WaitRetrace(1)
		next tx 
	next ty 

	WaitRetrace(100)

	next it

loop 
 