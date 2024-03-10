'!ORG=26000
'!HEAP=2048
'!copy=h:\holeymoleyfx.nex
'#! "assets\gfx2next.exe -tile-repeat -tile-size=8x8 -colors-4bit -block-size=4x4 assets\basicshapes.bmp data\basicsh"

#define IM2
#define NEX
#define CUSTOMISR
#include <nextlib.bas>
#include <keys.bas>

PAPER 0 : BORDER 0 : ink 0 : CLS 

asm 
    nextreg SPRITE_CONTROL_NR_15,%000_001_11          ; ULA/TM / Sprites / L2
    nextreg GLOBAL_TRANSPARENCY_NR_14,0             ; Set global transparency to BLACK
    nextreg TURBO_CONTROL_NR_07,3                   ; 28mhz 
    nextreg PERIPHERAL_3_NR_08,254                  ; contention off
    nextreg ULA_CONTROL_NR_68,%10101000				; Tilemap Control on & on top of ULA,  80x32 
    nextreg LAYER2_CONTROL_NR_70,%00010000			; L2 320x256
	nextreg LAYER2_RAM_BANK_NR_12,12


	di                                              ; disable ints as we dont want IM1 running as we're using the area that sysvars would live in
end asm 

' -- Load Block 

LoadSDBank("SPARK1-9.pt3",0,0,0,56) 				' load music.pt3 into bank 
LoadSDBank("vt24000.bin",0,0,0,37) 				' load the music replayer into bank 
LoadSDBank("game.afb",0,0,0,38) 				' load music.pt3 into bank 

LoadSDBank("levels.bin",0,0,0,40)				' Where we load our levels to 
LoadSDBank("akid2.nxt",0,0,0,41)                        ' load the tiles to bank 20
LoadSDBank("font5.spr",0,0,0,42)                        ' load font 
LoadSDBank("monty2.spr",0,0,0,43)						' sprites bank 32 
LoadSDBank("loading.raw",0,0,0,45)

LoadSDBank("output.dat",0,0,0,57)               ' load the sample into bank 57 


asm : nextreg $50,43 : nextreg $51,44 : end asm 
InitSprites(64,$0000)									' init all sprites 
asm : nextreg $50,$ff : nextreg $51,$ff : end asm   	' pop back default banks 
' -- 
InitCopperAudio()
PlayCopperSample(4)		
SetCopperAudio()
' -- 

InitSFX(38)							            ' init the SFX engine, sfx are in bank 36
InitMusic(37,56,0000)				            ' init the music engine 33 has the player, 34 the pt3, 0000 the offset in bank 34
SetUpIM()							            ' init the IM2 code 

EnableSFX							            ' Enables the AYFX, use DisableSFX to top
EnableMusic 						            ' Enables Music, use DisableMusic to stop 
PlaySFX(0)                                    ' Plays SFX 



' -- vars and consts
const spleft as ubyte = %1000					' thare constants required for sprite mirror + flipping 
const spright as ubyte = %0000
const spup  as ubyte = %0000
const spdown   as ubyte = %0100
dim plx,startx as uinteger 
dim ply,starty as ubyte 
dim pldx as ubyte 
dim pldy as ubyte 
dim plld as ubyte 
dim plch as ubyte 
Dim potx,poty as ubyte
dim playersprite as ubyte = 0
dim oldpx as uinteger 
dim oldpy as ubyte
dim attr3 as ubyte
dim nojump as ubyte
dim honeypots as ubyte
dim globalframe,globalframetimer as ubyte
dim level as ubyte = 0
dim maxlevel as ubyte = 4
dim cc as ubyte 
dim plvel as fixed = 1
dim velocity as fixed 
dim mapoffset as uinteger 
dim jumptrigger,jumpposition as ubyte
dim playerframe as ubyte 
dim hudtimer as ubyte
dim mapbuffer as uinteger
const MLEFT  as ubyte = 0 
const MRIGHT as ubyte = 1 
const MUP	as ubyte = 2 
const MDOWN	as ubyte = 3 
const MSTILL	as ubyte = 4
plx = 4<<3 : ply = 4<<3


' set up some sprites 					ID  X   Y  Img Dir spe
dim aSprites(32,8) AS uByte 			' 32 sprites with 5 attributes 

' -- 
ShowIntroScreen()

' --- TEST AREA 

SetupTileHW($40,$60)                 ' map address $xx00, tile addresss $xx00
'UpdateTilemap(xx as ubyte, yy as ubyte, vv as ubyte)

asm 
    ; Turns on the tilemap 
    nextreg TILEMAP_CONTROL_NR_6B,%10100001				;' Tilemap Control on & on top of ULA,  80x32 
	; set interrupt line
end asm 
level = cast(ubyte,mapoffset)
GetLevel(level)							' use mapoffset when its set to 0 to prevent 
												' it being discard by optimisation 

do 

	

	ReadKeys()
	WaitRetrace2(250)
	UpdatePlayer()
	UpdateSprites()

	CheckCollision()
	ShowHud()
	CheckPots()	

loop 

Sub MyCustomISR()
	
	' CopperWaitLine()
	PlayCopperAudio()
	SetCopperAudio()		
end sub 

CopperSample()

sub CheckPots()

	dim t as ubyte 

	if honeypots=0
		
		do
			FL2Text(13,9,"               ",42)	
			WaitRetrace(100)
			FL2Text(13,9,"LEVEL COMPLETE!",42)
			t=t+1 
			WaitRetrace(50)
		loop until t = 15
		FL2Text(13,10,"PRESS ANY KEY !!",42)
		WaitKey()
		CopyToBanks(24,25,9)
		level = level + 1 : if level = maxlevel : level = 0 : endif 
		GetLevel(level) 		
		
	endif 
		
end sub

sub ShowIntroScreen() 
	dim p,y,a as ubyte 
	dim message$ as string
	do 
		ClipLayer2(0,0,0,0) 
		CopyToBanks(45,24,10)
		FL2Text(0,30,"PRESS ANY KEY TO PLAY-PART OF NEXTBUILD EXAMPLES!!",42)
		ShowLayer2(1)
		ClipLayer2(0,159,0,255) 
		while p<200 and GetKeyScanCode()=0
			WaitRetrace2(50)
			p=p+1 
		wend 
		'ShowMessages()
		ClipLayer2(0,0,0,0) 	
		ClearBank()
		CopyToBanks(24,25,9)
		restore Messages

		read y,message$
		while message$<>"*"
			a=20-(len(message$)>>1)
			FL2Text(a,y,message$,42)
			read y,message$
		wend 
		ClipLayer2(0,159,0,255) 
		p=0 
		while p<200 and GetKeyScanCode()=0
			WaitRetrace2(25)
			p=p+1 
		wend 
		p=0
		ClipLayer2(0,0,0,0) 
	loop until GetKeyScanCode()<>0
	ClearBank()
	CopyToBanks(24,25,9)
	
	ClipLayer2(0,159,0,255) 

	
	Messages:
	Data 5,"HOLEY MOLEY DEMO"
	Data 6,"WRITTEN BY DAVID SAPHIER"
	Data 8,"GRAPHICS SOURCED FROM THE INTERNET"
	Data 9,"AND OR MODIFIED BY ME"
	Data 11,"WRITTEN USING NEXTBUILD AND BORIELS"
	Data 12,"ZX BASIC COMPILER"
	Data 14,"CONTROL HOLEY TO GRAB THE HONEYBUTTIES"
	Data 15,"TO GET TO THE NEXT LEVEL"
	Data 16,"WATCH OUT FOR THE BADDIES!!"
	Data 18,"USE WASD TO MOVE, SPACE TO JUMP"
	Data 22,"PRESS FIRE TO PLAY"

	Data 0,"*"
end sub

sub ClearBank()
	asm
	;	di 
		nextreg MMU2_4000_NR_52,24
		ld hl,$4000 
		ld de,$4001 
		ld (hl),0
		ld bc,$2000
		ldir 
		nextreg MMU2_4000_NR_52,$0a 
	;	ei 
	end asm
end sub 

sub GetLevel(level as ubyte)
	' get next level from bank and copy to $4000
	ClipTile(0,0,0,0)	
	mapoffset = level * 1280 
	asm 
		nextreg MMU7_E000_NR_57,40			; where we have our levels
		ld de,(._mapoffset)
		ld hl,$e000 
		add hl,de 
		ld de,map 
		ld bc,1280
		ldir 
		nextreg MMU7_E000_NR_57,1			; put back 
		ld hl,map 
		ld de,$4000
		ld bc,1280
		ldir 
	end asm 
	SetUpNPC()
	plx = startx: ply = starty
	ClipTile(0,255,0,255)	
end sub

Sub CheckCollision()
	
	' a robust collision routine for our player against the tilemap

    const blocksize as ubyte = 3            ' how many shifts 
    const scalesize as ubyte = 30           ' x1 and x2 x1 = 14 x2 = 30

	dim plxc,sp,add as uinteger
	dim plyc,tilehit,lefttile,righttile, toptile,bottile,tile as ubyte 
	
	mapbuffer = $4000            			' point to the map 	

	oldpx = plx                             ' store current player x and y 
	oldpy = ply

	if pldx = MLEFT                         ' is player x direction LEFT?
		plx = plx -  1-cast(ubyte,plvel)                        ' then plx - 1
	elseif pldx = MRIGHT                    ' is player x direction RIGHT?
		plx = plx +  1+cast(ubyte,plvel)                        ' then plx + 1 
	endif 

    plxc = (plx)                            ' take a copy of plx ply 
    plyc = (ply)
    	
	lefttile = (plxc+2) >> blocksize                ' / 16 to get current map co-ords
	righttile = (plxc+scalesize) >> blocksize              ' +2 & +14 for soft edges 
	
	toptile = (plyc+2) >> blocksize
	bottile = (plyc+scalesize) >> blocksize
	
	if lefttile>40 : lefttile = 0 : endif 
	if righttile>40 : righttile = 40 : endif 
	if toptile>32 : toptile = 0 : endif 
	if bottile>32 : bottile = 32 : endif 
	
	tile = 0                                ' tile flag 

	if pldx = MLEFT                         ' were we moving left? 
		for yy= toptile to bottile
				tile = peek(mapbuffer+(cast(uinteger,yy)*40)+cast(uinteger,lefttile))
				if tile > 0                ' we hit a tile that wasnt 0 
					plx = oldpx             ' put plx back 
					pldx = MSTILL           ' change plx direction to STILL 
					plvel = 0 
                    exit for 
				endif 
		next	
	elseif pldx = MRIGHT                    ' repeat for right 
			for yy= toptile to bottile
				tile = peek(mapbuffer+(cast(uinteger,yy)*40)+cast(uinteger,righttile))
				if tile > 0
					plx = oldpx
					pldx = MSTILL
					plvel = 0 
                    exit for 
				endif 
		next	
	endif 

    ' same as above but for up and down 

	if pldy = MUP
		ply = ply - 1 
	else   'if pldy = MDOWN
		ply = ply + cast(ubyte,velocity) + 1
	endif 

	plxc = (plx) : plyc = (ply)
	
	lefttile = (plxc+2) >> blocksize                   ' 2 & 14 for soft edge blocks 
	righttile = (plxc+scalesize) >> blocksize 
	
	toptile = (plyc+2) >> blocksize
	bottile = (plyc+scalesize) >> blocksize
	
	if lefttile>40 : lefttile = 0 : endif 
	if righttile>40 : righttile = 40 : endif 
	if toptile>32 : toptile = 0 : endif 
	if bottile>32 : bottile = 32 : endif 
	
	tile = 0 

	if pldy = MUP 
		add = (mapbuffer+(cast(uinteger,toptile)*40))
        
		for xx= lefttile to righttile
				tile = peek(add +cast(uinteger,xx))
				if tile > 0 or ply < 4 
						ply=oldpy
						pldy = MDOWN
						jumptrigger=3
						PlaySFX(5)
                        exit for 
				endif 
		next	
	else  ' if pldy = MDOWN
		add = (mapbuffer+(cast(uinteger,bottile)*40))
		for xx= lefttile to righttile
				tile = peek(add+cast(uinteger,xx))
				if tile > 0
						ply=oldpy
					';''	plyd=MUP
                        jumptrigger=0 
						velocity=0
						plvel=0
						exit for 
				endif 
				velocity=velocity+0.04
		next	
	endif 
    
    

    ' detects if we hit left right top of bottom edges to draw a new map
    ' 
    ' if plx = 255-14
    '     worldpoint=worldpoint+1 : plx = 2 : drawmap()
    ' elseif plx = 0 
    '     worldpoint=worldpoint-1 : plx = 254-14 : drawmap()
    ' elseif ply>192
    '     worldpoint=worldpoint+8 : ply = 2 : drawmap()
    ' elseif ply=0
    '     worldpoint=worldpoint-8 : ply = 191 : drawmap()
    ' endif 

	oldpx = plx : oldpy = ply	

end sub 


sub ReadKeys()

	dim keypressed, jumpvalue as ubyte 

	pldx = MSTILL 
	pldy = MSTILL 

	kemp = in 31 

	if GetKeyScanCode()=KEYR 
		honeypots=0
	endif
	if MultiKeys(KEYD) or kemp BAND 1 = 1
		pldx = MRIGHT : keypressed = 1 
        attr3 = spright
		plld = pldx

	elseif MultiKeys(KEYA) or kemp BAND 2 = 2
		pldx = MLEFT : keypressed = 1 
        attr3 = spleft
		plld = pldx

	endif 
	if MultiKeys(KEYW)
		'pldy = MUP : keypressed = 1 
        
	elseif MultiKeys(KEYS)
		'pldy = MDOWN
	endif 
	if (MultiKeys(KEYSPACE) or kemp BAND 16 = 16) and jumptrigger=0 and nojump=0
		jumptrigger = 2
        nojump = 1 
		' PlaySFX(22)
        PlayCopperSample(0)	
		plvel=0
    elseif MultiKeys(KEYSPACE)=0 and kemp BAND 16 = 0 
        nojump=0
	endif  

    if jumptrigger = 2 
        jumpposition=0 
        jumptrigger=1
    endif 

    if jumptrigger = 1 
        jumpvalue=peek(@jumptable+cast(uinteger,jumpposition))
		pldy = MUP 
		if jumpposition <3
				plvel = plvel + 0.5
			else 
				plvel = 1
			endif 
        ply=ply+jumpvalue
        jumpposition=jumpposition+1 : if jumpposition>15 : PlaySFX(48) : jumptrigger=3
    endif 

    if keypressed
        if  playerframe =  3
            ' timer triggered 
            playerframe = 0
            playersprite = 1 - playersprite 
        else 
            playerframe =  playerframe + 1 
        endif 
    endif 

	if  globalframetimer =  5
		' timer triggered 
		 globalframetimer = 0
		 globalframe= 1 - globalframe
	else 
		globalframetimer =  globalframetimer + 1
	endif 
	

end sub 

jumptable:
asm 
    ; the data for when the player jumps 
    db 250,250,251,251,251,251,251,251,252,252,253,253,254,254,255,0
end asm 
sub UpdatePlayer()

	' %00001010  x 2 
	UpdateSprite(cast(uinteger,plx),ply,63,playersprite,attr3,%00001010)
	
end sub 


sub SetUpNPC()
	
	honeypots=0 ' reset pot counter 
	
	dim ccount as uinteger
	dim parama, paramb,a as ubyte 
	
	for sp = 0 to 31 
		aSprites(sp,0)=0						' reset all sprites
		RemoveSprite(sp,0)						' remove all sprites
	next sp

	for yy = 0 to 31 
		for xx=0 to 39
			a=peek($4000+cast(uinteger,ccount))
			parama = 0 
			if a > $3f				
				if a = $40 			
					a = 3			' boxing glove 
				elseif a = $41		
					a = 2			' honey pot 
					honeypots=honeypots+1
				elseif a = $42

					a = 5			' HAWK
					parama=peek($4000+cast(uinteger,ccount+1))
					poke ($4000+cast(uinteger,ccount+1)),0
					
				elseif a = $60 		' player start 
					startx=xx<<3 : starty = yy<<3
				endif 
				' (x as byte,y as byte,spriteimage as ubyte,spritetype as ubyte, parama as ubyte, paramb as ubyte)
				poke ($4000+cast(uinteger,ccount)),0

				if a <$60
					AddNewSprite(cast(uinteger,xx)<<3,cast(ubyte,yy)<<3,a,a,parama,0)
				endif 
			endif 
			ccount=ccount+1
		next xx
	next yy 
end sub

sub UpdateSprites()
	border 7
	Border 2 
	dim p,d,img,y,s,pma,pmb,spattr3,tile,type,ty,y1,size,y2 as ubyte 
	dim x,add,lt,rt as uinteger
	
	while p<32
	
		if aSprites(p,0) band 1 = 1			' is sprite set on 
			spattr3=0 : tile=0
			x = aSprites(p,1)
			if (aSprites(p,0) band 2) = 2
				x = x + 255
			endif 
			y = aSprites(p,2)
			img = aSprites(p,4)
			type = aSprites(p,5)
			d = aSprites(p,6)				' direction 
			s = aSprites(p,7)				' speed 

			if type = 3 					' boxing glove 
				' s = stage of movement 
				if s = 0 
					if plx>=x-16 AND plx<=x+16  
						s = 1  
						aSprites(p,6)=y 
						'PlaySFX(37)
                        PlayCopperSample(2)	
					endif 
				elseif s=1
					y=y+2 : if y>180 : s = 2 :  PlaySFX(39) : endif 
					aSprites(p,2)=y
				elseif s=2 
					if y>aSprites(p,6)
						y=y-1
					else 
						y = aSprites(p,6)
						s = 0 
					endif 
					aSprites(p,2)=y
				endif 
				aSprites(p,7)=s
			endif 

			if type = 5								' hawk 
				pma = aSprites(p,6)
				pmb = aSprites(p,7)
				
				if pma = 0
					x=x-1
					lt = (cast(Ubyte,x) + 2) >> 3 : ty = (y+12) >> 3
					add = $4000+(cast(uinteger,ty)*40)+lt					
					tile = peek(add)					
					if tile >  0 
						x=x+1 
						pma = 1
					endif 
					spattr3 = spright
				elseif pma = 1
					x=x+1
					rt = (cast(Ubyte,x + 2) >> 3)  : ty = (y+12) >> 3
					add = $4000+(cast(uinteger,ty)*40)+rt
					tile = peek(add)
					spattr3 = spleft
					if tile > 0  
						pma = 0
						x=x-1 
					endif 
				endif 
				img = img + globalframe
				aSprites(p,6)=pma
				aSprites(p,1)=cast(ubyte,x)
				if x>255 
					aSprites(p,0)=3 
				else
					aSprites(p,0)=1
				endif 
			endif 

			if type = 2	or type=3 or type = 5					' honey pot 
	        ' px/py player position, tx/ty position of current sprite 
				dim x1,x2 as uinteger
				x1=plx : x2 = x : y1 = ply : y2 = y 
				size = 24   ' size of area to check from point x\y 
				if (x1+size<x2+2) BOR (x1+2>=x2+size) BOR (y1+size<y2+2) BOR (y1+2>=y2+size+2)=00
					border 2
					if type = 2
						' PlaySFX(0)
                        
                        PlayCopperSample(4)	                ' honey pot sound fx 
						aSprites(p,0)=0
						RemoveSprite(p,0)
						honeypots=honeypots-1 
					elseif type = 3  or type= 5
                        PlayCopperSample(3)	
						'PlaySFX(34) 
						PlayerHit()
						plx =startx : ply = starty
						
					endif 
				else    
					border 0 
					UpdateSprite(cast(uinteger,x),y,p,img,spattr3,%00001010)
				endif  
			endif
		endif 
		p=p+1
	wend
end sub
' 
sub ShowHud()
	if  hudtimer =  0
		' timer triggered 
		 hudtimer = 50
		 FL2Text(4,30,"LEVEL : "+str(level),42)
		 FL2Text(20,30,"POTS : "+str(honeypots),42)
	else 
		 hudtimer =  hudtimer - 1 
	endif 
	
end sub

sub PlayerHit()
	dim t as ubyte
	do
		RemoveSprite(63,0)
		WaitRetrace(50)
		UpdateSprite(cast(uinteger,plx),ply,63,4,attr3,%00101010)
		WaitRetrace(50)
		t=t+1
	loop until t = 25 
	
end sub

Sub AddNewSprite(x as uinteger,y as byte,spriteimage as ubyte,spritetype as ubyte, parama as ubyte, paramb as ubyte)
	
	dim p,a as ubyte 

	while aSprites(p,0) band 1 = 1 and p<32
		p=p+1
	WEND 
	
	if p<32
		if x>255 
			a = 3 
			else 
			a = 1
		endif 
		aSprites(p,0)=a 					'  sprite on 
		aSprites(p,1)=cast(ubyte,x)			'  x 
		aSprites(p,2)=y						'  y 
		aSprites(p,3)=p						'  id 
		aSprites(p,4)=spriteimage			'  spriteimage 
		aSprites(p,5)=spritetype			'  type 
		aSprites(p,6)=parama				'  param A 
		aSprites(p,7)=paramb				'  param B 
	endif 
end sub

sub DrawMap()

    ' draws with 16x16 on L2
	dim sp as uinteger
	dim p as ubyte 
	
	mapbuffer = @map

	for y = 0 to 11 
		for x = 0 to 15
			p = peek(mapbuffer+sp)
			FDoTile16(p,y,x,32)
			sp = sp + 1 
		next x 
	next y
	
end sub 


sub fastcall SetupTileHW(tileaddr as ubyte, tiledata as ubyte)
	    
    asm     
    
        exx : pop hl : exx : push af 
         
        nextreg PALETTE_CONTROL_NR_43,%00110000             ; NextReg($43,%00110000)	' Tilemap first palette
                                                            ; writing to NR$43 resets NR$40
        ld hl,palbuff                                       ; upload palette for tilemap
        ld b,16*2
	_tmuploadloop:
        ld a,(hl) : nextreg PALETTE_VALUE_9BIT_NR_44,a
        inc hl 
        djnz _tmuploadloop

        ; ' tilemap 40x32 no attribute 256 mode 
        nextreg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000		; Default Tilemap Attribute on & on top of ULA,  80x32 
        
        pop af 
        nextreg TILEMAP_BASE_ADR_NR_6E,a				    ; tilemap data
        pop af 
        nextreg TILEMAP_GFX_ADR_NR_6F,a				        ; tilemap images 4 bit 
        
        nextreg ULA_CONTROL_NR_68,%10100000				    ; ULA CONTROL REGISTER
        nextreg GLOBAL_TRANSPARENCY_NR_14,0  				; Global transparency bits 7-0 = Transparency color value (0xE3 after a reset)
        nextreg TILEMAP_TRANSPARENCY_I_NR_4C,$0				; Transparency index for the tilemap
        pop af 
            
		nextreg MMU2_4000_NR_52,41
		ld hl,$4000                                     ; copy the tile image data from bank 30 into place
		ld de,$6000
		ld bc,1120										; size of tiles
		ldir 
        
        nextreg MMU2_4000_NR_52,$0a                     ; pop bank orginal bank $0a 
		ld hl,map                                       ; copy map to tilemap data
		ld de,$4000                                     
		ld bc,80*40
        ldir 
        
        exx : push hl : exx 
    end asm 
    ClipTile(0,255,0,255)				
end sub 


sub fastcall UpdateTilemap(xx as ubyte, yy as ubyte, vv as ubyte)
    ' this routine will place tile vv at xx,yy
    asm 
		pop hl : exx                ; save ret address 
		ld hl,$4000                 ; start of tilemap data
		add hl,a	                ; add x 
		pop de                      ; get y
		ld e,40                     ; mul y * 40 = or tilewidth 
		mul d,e                           
		add hl,de                   ; now add to hl
		pop af                      ; get the value vv 
		ld (hl),a                   ; place tile 
		exx 
		push hl                     ; return aaddress on stack 
	end asm 
end sub


Sub fastcall CopyToBanks(startb as ubyte, destb as ubyte, nrbanks as ubyte)
 	asm 
		exx : pop hl : exx 
		; a = start bank 			

		; call _checkints
		; di 
		ld c,a 						; store start bank in c 
		pop de 						; dest bank in e 
		ld e,c 						; d = source e = dest 
		pop af 
		ld b,a 						; number of loops 

		copybankloop:	
		push bc : push de 
		ld a,e : nextreg $50,a : ld a,d : nextreg $51,a 
		; ld hl,$0000
		; ld de,$0001 
		; ld hl,0
		; ld bc,$2000 
		; ldir 
		ld hl,$0000
		ld de,$2000
		ld bc,$2000
		ldir 
		pop de : pop bc
		inc d : inc e
		djnz copybankloop
		
		nextreg $50,$ff : nextreg $51,$ff
		; ReenableInts
		exx : push hl : exx

 	end asm  
end sub  

map:
asm
map:
	; 40 x 32 map 
	; >=63 empty space 
	; 
	; 2 pl start 
    defs 1280,0
	
end asm 

' palbuff:
' asm 
' palbuff:
'     incbin "./data/tiles.nxp"
' end asm 

palbuff:
asm 
palbuff:
	;defs 512,0
	; palette for tilemap 
	db $ff, $01, $ff, $01, $fe, $01, $fc, $00, $b4, $00, $14, $00, $1c, $00, $f4, $00
	db $a8, $00, $a0, $00, $40, $00, $00, $00, $e0, $00, $48, $00, $00, $00, $03, $01
end asm   



sub fastcall InitCopperAudio()

	asm
		
		ld		bc,TBBLUE_REGISTER_SELECT_P_243B
		ld		a,VIDEO_TIMING_NR_11
		out		(c),a
		inc		b
		in		a,(c)				; Display timing
		and		7					; 0..6 VGA / 7 HDMI
		ld		(.CopperSample.video_timing),a	; Store timing mode
		
		nextreg	COPPER_CONTROL_LO_NR_61,$00
		nextreg	COPPER_CONTROL_HI_NR_62,$00
		nextreg	COPPER_DATA_NR_60,$FF
		nextreg	COPPER_DATA_NR_60,$FF

		ld		a,SOUNDDRIVE_DF_MIRROR_NR_2D
		ld		(.CopperSample.sample_dac),a	; Sound on

	end asm

end sub 

sub fastcall PlayCopperSample(sample as ubyte)
	asm
		; BREAK  
		; get sample data 
        ; call    ._checkints
        ; di
		ld 		hl,copper_sample_table								; point to start of sample table 
		ld 		e,a 
		ld 		d,6 
		mul 	d,e 
		add 	hl,de 												; hl now points to start of sample data 
		ld		(.playerstack+1),sp 
		ld 		sp,hl 											

		pop 	hl 
		ld		(.CopperSample.sample_loop),hl 						; saves bank + loop 
		
		pop 	hl  
		ld		(.CopperSample.sample_ptr),hl

		pop 	hl 
		ld		(.CopperSample.sample_len),hl
		
		ld		hl,0
		ld		(.CopperSample.sample_pos),hl

		ld		a,SOUNDDRIVE_DF_MIRROR_NR_2D
		ld		(.CopperSample.sample_dac),a	; Sound on		

	playerstack:
		ld 		sp,0
        ; ReenableInts

	end asm
end sub 

sub fastcall SetCopperAudio()

	asm 
        ; BREAK 
    ;    call    ._checkints
    ;    di 
	;	push ix 
		call CopperSample.set_copper_audio
    ;    pop ix 
    ;    ReenableInts
	end asm 

end sub 

sub fastcall PlayCopperAudio()

	asm

        ; BREAK 
		; exx : pop hl : exx 
	;	call    ._checkints
     ;   di 
	;	push ix 
		call CopperSample.play_copper_audio
	;	pop ix 
     ;   ReenableInts
		; exx : push hl : exx
	end asm

end sub 

sub fastcall CopperWaitLine()
	asm
	wait_line:	 
		ld		bc,TBBLUE_REGISTER_SELECT_P_243B
		ld		de,($1E*256)+$1F

		out		(c),d						; MSB
		inc		b

	.msb:
		in		d,(c)
		bit		0,d							; 256..312/311/262/261 ?
		jp		nz,.msb

		dec		b
		out		(c),e						; LSB
		inc		b

	.lsb:
		in		e,(c)
		cp		e							; 0..255 ?
		jp		nz,.lsb

	end asm

end sub 


sub fastcall CopperSample()
    asm 
	push namespace CopperSample 
	;    ?Updated:     em00k, adding banking                               ?
	;    ?Programmer:  kevbrady@ymail.com                                  ?
	;    ?Modified:    14th July 2018                                      ?
	;    ?Description: Copper sample player (BIS version)                  ?
	;    ?                                                                 ?


	; Hardware registers.
		
	; TBBLUE_REGISTER_SELECT			equ	$243B	; TBBlue register select

	PERIPHERAL_1_REGISTER			equ	$05	; Peripheral 1 setting
	TURBO_CONTROL_REGISTER			equ	$07	; Turbo control
	; DISPLAY_TIMING_REGISTER			equ	$11	; Video timing mode (0..7)
	RASTER_LINE_MSB_REGISTER		equ	$1E	; Current line drawn MSB
	RASTER_LINE_LSB_REGISTER		equ	31	; Current line drawn LSB
	SOUNDDRIVE_MIRROR_REGISTER		equ	$2D	; SpecDrum 8 bit DAC (mirror)
	COPPER_DATA						equ	$60	; Copper list
	COPPER_CONTROL_LO_BYTE_REGISTER	equ	$61
	COPPER_CONTROL_HI_BYTE_REGISTER	equ	$62
	CONFIG1 						equ $05
	COPHI							equ $62
	COPLO							equ $61
	SELECT							equ $243b
	SAMPLEBANK						equ 32 				; sample bank to use 


	set_copper_audio:
		; di 
	
		ld		(.stack+1),sp

		ld		ix,copper_loop				; Auto detect timing

		ld		bc,SELECT
		ld		a,CONFIG1
		out		(c),a
		inc		b
		in		a,(c)						; Peripheral 1 register

		ld		hl,hdmi_50_config
		ld		de,vga_50_config
		bit		2,a
		jr		z,.refresh					; Refresh 50/60hz ?
		ld		hl,hdmi_60_config
		ld		de,vga_60_config
	.refresh:
		ld		a,(video_timing)
		cp		7							; HDMI ?
		jr		z,.hdmi
		ex		de,hl						; Swap to VGA
	.hdmi:
		ld		a,(hl)						; Copper line
		inc		hl
		ld		(.return+1),a				; Store ruturn value

		ld		sp,hl

	;	------------
	;	------------
	;	------------

		ld		hl,(sample_len)				; Calc buffer loop offset
		ld		bc,(sample_pos)
		xor		a							; Clear CF
		sbc		hl,bc

		ld		b,h
		ld		c,l							; BC = loop offset (0..311)

		pop		hl							;  Samples per frame (312)
		ld		(video_lines),hl

		ld		a,h							; 16 bit negate
		cpl
		ld		h,a
		ld		a,l
		cpl
		ld		l,a
		inc		hl							; Samples per frame (-312)

		ld		a,20						; No loop (Out of range)

		add		hl,bc
		jp		c,.no_loop

	;	----D---- ----E----
	;	0000 0008 7654 3210
	;	0000 0000 0008 7654	

		ld		a,c							; Loop offset / 16
		and		%11110000
		or		b
		swapnib
	.no_loop:
		ld		b,a							; B = 0..19 (20 no loop)

		ld		a,c
		and		%00001111
		ld		c,a

	;	------------

		ld		hl,.zone+1					; Build control table
		pop		de
		ld		(hl),e						; Split
		ld		a,d							; Count

		pop		hl							; 0..15 samples routine

		ld		(copper_audio_config+1),sp 	; **PATCH**

		ld		sp,copper_audio_stack
		
		cp		b
		jr		nz,.skip					; Loop 0..15 samples ?

		ex		af,af'

		ld		e,c							; 0..7
		ld		d,9
		mul		d,e							; 0..144
		ld		a,144						; 144..0
		sub		e

		add		hl,de
		push	hl
		push	ix							; Output loop
		ld		de,copper_out16
		add		de,a
		push	de

		ex		af,af'

		jr		.next

	;	------------

	.skip:	
		push	hl							; Output normal

	;	------------

	.next:	
		ld		hl,copper_out16				; 16 samples routine
		dec		a

	.zone:	
		cp		7
		jp		nz,.no_split

		ld		de,copper_split
		push	de							; Output Split
	.no_split:
		cp		b
		jp		nz,.no_zone					; Loop 16 samples ?

		ex		af,af'

		ld		e,c							; 0..15
		ld		d,9
		mul		d,e							; 0..144
		ld		a,144						; 144..0
		sub		e

		add		de,copper_out16
		push	de
		push	ix							; Output loop
		ld		de,copper_out16
		add		de,a
		push	de

		ex		af,af'

		jr		.zone_next

	.no_zone:
		push	hl							; Output normal

	.zone_next	
		dec		a
		jp		p,.zone

		ld		(copper_audio_control+1),sp ; **PATCH**

	.return	
		ld		a,0							; Copper line to wait for

	.stack	
		ld		sp,0

		ret


	; --------------------------------------------------------------------------
	; --------------------------------------------------------------------------
	; --------------------------------------------------------------------------


	; **MUST CALL EACH FRAME AFTER WAITING FOR LINE A FROM SET_COPPER_AUDIO**


	; Build copper list to output one frame of sample data to DAC.

	play_copper_audio: 
		
		getreg($50) : ld (playbankout+3),a 
		getreg($51) : ld (playbankout+7),a 

		ld 			a,(sample_bank)			; set sample banks 
		nextreg 	$50,a 
		inc 		a
		nextreg 	$51,a 
		
		call 		play_copper_audio2		; set copper 
		
	playbankout:		
		nextreg 	$50,$ff					; return roms 
		nextreg 	$51,$ff 
		
		ret 

	play_copper_audio2:
		
		ld			(play_copper_stack+1),sp

	copper_audio_config:
		
		ld		sp,0			; **PATCH**

		pop		hl							; Index + VBLANK
		pop		de							; Line 180 + command WAIT

		ld		a,l
		nextreg	COPLO,a
		ld		a,h
		nextreg	COPHI,a

		ld		hl,(sample_ptr)				; Calc playback position
		ld		bc,(sample_pos)	
		add		hl,bc

		ld		bc,SELECT					; Port
		ld		a,COPPER_DATA
		out		(c),a
		inc		b

		ld		a,(sample_dac)				; Register to set (DAC)

	copper_audio_control:
		ld		sp,0						; **PATCH**
		
		ret									; GO!!!

	;	------------

	copper_out16:	
		out		(c),d		;   0 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out15:	
		out		(c),d		;   9 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out14:	
		out		(c),d		;  18 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out13:	
		out		(c),d		;  27 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out12:	
		out		(c),d		;  36 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out11:	
		out		(c),d		;  45 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc	de
	copper_out10:	
		out		(c),d		;  54 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out9:
		out		(c),d		;  63 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out8:	
		out		(c),d		;  72 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out7:	
		out		(c),d		;  81 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out6:	
		out		(c),d		;  90 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out5:	
		out		(c),d		;  99 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out4:	
		out		(c),d		; 108 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out3:	
		out		(c),d		; 117 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc	de
	copper_out2:	
		out		(c),d		; 126 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out1:	
		out		(c),d		; 135 BYTES
		out		(c),e
		out		(c),a
		OUTINB
		inc		de
	copper_out0:	

		ret			; 144 BYTES

	;	------------

	copper_split:
		out		(c),d						; Terminate
		out		(c),e
		ld		de,32768+0					; Line 0 + command WAIT
		nextreg	COPPER_CONTROL_LO_BYTE_REGISTER,$00 ; Index
		nextreg	COPPER_CONTROL_HI_BYTE_REGISTER,$C0 ; Vblank
		ret			; GO!!!


	copper_loop:	
		ld		hl,sample_dac
		ld		a,(sample_loop)
		and		a
		jr		z,.forever
		dec		a
		jr		nz,.loop	
		ld		(hl),0						; Copper NOP (mute sound)

	.loop:		
		ld		(sample_loop),a

	.forever:
		ld		a,(hl)						; Read DAC mute state
		ld		hl,(sample_ptr)
		ret									; GO!!!

	;	------------

	copper_done:
		ld		de,(sample_ptr)
		xor		a
		sbc		hl,de
		ld		(sample_pos),hl				; Update playback position

	play_copper_stack:
		ld		sp,0
    ;    ei 
		ret


	; --------------------------------------------------------------------------


	vga_50_config:
		db		187						; Copper line 187 (50hz)
		dw		311						; Samples per frame
		db		6						; Split
		db		7+12					; Count
		dw		copper_out7				; Routine (311-304)
		db		$1C						; Index + VBLANK
		db		$C3
		dw		32768+199				; Line 199 + command WAIT

	vga_60_config:	
		db		191						; Copper line 191 (60hz)
		dw		264						; Samples per frame
		db		3						; Split
		db		4+12					; Count
		dw		copper_out8				; Routine (261-256)
		db		$20						; Index + VBLANK
		db		$C3
		dw		32768+200				; Line 197 + command WAIT

	hdmi_50_config:	
		db		186						; Copper line 186 (50hz)
		dw		312						; Samples per frame
		db		6						; Split
		db		7+12					; Count
		dw		copper_out8				; Routine (312-304)
		db		$20						; Index + VBLANK
		db		$C3
		dw		32768+200				; Line 200 + command WAIT

	hdmi_60_config:
		db		189						; Copper line 189 (60hz)
		dw		262						; Samples per frame
		db		3						; Split
		db		4+12					; Count
		dw		copper_out6				; Routine (262-256)
		db		$18						; Index + VBLANK
		db		$C3
		dw		32768+198				; Line 198 + command WAIT


	; --------------------------------------------------------------------------


	; Variables.


	sample_ptr:		dw	0			; 32768
	sample_pos:		dw	0
	sample_len:		dw	0			; 10181
	sample_dac:		db	0			; DAC register

	sample_loop:    db	0		; 0..255
	sample_bank:    db 	0 		; 0..255 

	video_lines:	dw	0		; 312/311/262/261
	video_timing:	db	0		; 0..7

		dw	0,0,0,0,0,0,0,0		;
		dw	0,0,0,0,0,0,0,0		; Define 23 WORDS
		dw	0,0,0,0,0,0,0		;

	copper_audio_stack:
		dw	copper_done
	pop namespace

    end asm 
end sub 

copper_sample_table:
asm 
	copper_sample_table: 
	; bank+loop , sample start, sample len
	; eg bank 56,loop 0 = $3800 
	; sample table sample * 6 
    ; 8,611 dead.pcm
    ; 4,417 jump.pcm
    ; 7,516 pickup.pcm
    ; 7,086 punch.pcm
	; dw $3801,0000,7516						; 7,516 pickup.pcm		1
	; dw $3801,0,0
    dw $3901,0,4417 ; 0jump.pcm
    dw $3901,4417,7516 ; 1pickup.pcm
    dw $3a01,11933-8192,7086 ; 3punch.pcm
    dw $3b01,2635,8611 ; 4dead.pcm
	dw $3c01,11246-8192,11502 ; complete.pcm
	
end asm 


sub ExecDot(execfilename as string)
    ASM 
        ; dont include the period eg "nexload myfile.nex" 
        ; string pointer in hl 
        PROC 
        LOCAL exedotfailed, execdotdone

        push ix : push bc : push de                     ; for zxb saftey 

        ld a,(hl)                                         ; size of string of input call now copy string to temp location
        inc hl : inc hl : ld de,.LABEL._filename : ld b,0 : ld c,a : ldir 

        ld a,$0d : ld (de),a                            ; ensure line finishes with EOL marker 

        ld ix,.LABEL._filename : push ix : pop hl         ;  dot command and regular 
        rst $8 : DB $8f                                 ;  M_EXECCMD ($8f)

        jr nc,execdotdone

    exedotfailed:
        ; esxdos error in a 
        out($fe),a                                        ; handle the error however you want 

    execdotdone:
        pop de : pop bc : pop ix

        ENDP
    end asm 
end sub