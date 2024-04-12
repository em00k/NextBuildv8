'!org=32768
'!opt=2

' DOTJAM intro by em00k
' Uses NextSID engine 
' 

#define NEX 
#define IM2 

#include <nextlib.bas>
#include <keys.bas>

LoadSDBank("nextsid.bin",0,0,0,33)
LoadSDBank("testsprites.spr",0,0,0,26)	' This is the sprite in bank 26/27
LoadSDBank("chiptune2.pt3",0,0,0,34)
LoadSDBank("tiles.nxt",0,0,0,41)

asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg TRANSPARENCY_FALLBACK_COL_NR_4A, 0
    nextreg VIDEO_LINE_OFFSET_NR_64,32
    nextreg PERIPHERAL_4_NR_09,%00100000
 ;   Bits 6-4
;
 ;   %000    ULA first palette
 ;   %100    ULA second palette
 ;   %001    Layer2 first palette
 ;   %101    Layer2 second palette
 ;   %010    Sprites first palette
 ;   %110    Sprites second palette
 ;   %011    Tilemap first palette
 ;   %111    Tilemap second palette

    nextreg ULA_CONTROL_NR_68,%10101000				; Tilemap Control on & on top of ULA,  80x32 
    nextreg SPRITE_CONTROL_NR_15,%00010011  ; %000    S L U, %11 sprites on over border
    ; ei
end asm 

CONST   relative        as ubyte = %01000000
dim     y               as ubyte 
dim     frame           as ubyte 
dim     lastframe       as ubyte 
dim		key, tune		as ubyte 

dim     pcounter        as ubyte 
dim     pcounter2       as ubyte 
dim     position        as ubyte 
dim     sx              as ubyte 
dim     sy              as ubyte 
dim     dg              as ubyte  = 128
dim     dh              as ubyte  = 58
dim     delay           as ubyte 
dim     delay2           as ubyte 
dim     dhdelay         as ubyte  = 16
dim     timer           as ubyte 
dim     timer3          as ubyte 
dim     col             as ubyte 
dim     palloff         as ubyte 
dim     sadd            as ubyte 
dim     a               as uinteger 

InitSprites2(63,0,26)	
ShowLayer2(0)
ClipLayer2(0,0,0,0)
CLS256(0)

for y = 0 to 192 step 8 
for x = 0 to 512 / 2 step 2 
    col = col + 1
    PlotL2(x,y,col  band %0111)
next x 
next y 


for y = 0 to 192  step 2
for x = 0 to 512 /2 step 8
    col = col +1
    PlotL2(x,y,col band %0111)
next x 

next y 

ClipLayer2(0,255,32,192-33)

' paper 0: ink 0 : border 0 : cls 
' for y = 0 to 15 
'      print ink 1+y;at y,0;"                                "
' next

asm 

    ld  b, 5
    ld  a, 7 
    ld  hl, 22528
    ld  de, 22529
doloopme:
    push bc 
    ld  (hl),a
    ld  bc, 32
    ldir 
    dec a 
    pop bc 
    djnz doloopme 

	nextsid_init EQU 0x0000E098

	nextsid_set_waveform_A EQU 0x0000E07A
	nextsid_set_waveform_B EQU 0x0000E081
	nextsid_set_waveform_C EQU 0x0000E088
	nextsid_set_detune_A EQU 0x0000E056
	nextsid_set_detune_B EQU 0x0000E05A
	nextsid_set_detune_C EQU 0x0000E05E
	nextsid_wavelen_A EQU 0x0000E341
	nextsid_wavelen_B EQU 0x0000E36C
	nextsid_wavelen_C EQU 0x0000E397
	nextsid_shift_C EQU 0x0000E24D
	nextsid_set_shift_C EQU 0x0000E076
	nextsid_shift_B EQU 0x0000E226
	nextsid_set_shift_B EQU 0x0000E072
	nextsid_shift_A EQU 0x0000E1FF
	nextsid_set_shift_A EQU 0x0000E06E

	nextsid_play EQU 0x0000E007
	nextsid_stop EQU 0x0000E011
	nextsid_mode EQU 0x0000E2D7
	nextsid_pause EQU 0x0000E000
	nextsid_reset EQU 0x0000E38C
	nextsid_set_pt3 EQU 0x0000E025

	init EQU 0x0000E3F9
	nextsid_set_psg_clock EQU 0x0000E04E
	nextsid_vsync EQU 0x0000E08F

	nextreg 	$57,33					; put nextsid in place
	irq_vector	equ	65022			;     2 BYTES Interrupt vector
	stack		equ	65021				;   252 BYTES System stack
	vector_table	equ	64512		;   257 BYTES Interrupt vector table	
	startup:	di					; Set stack and interrupts
	ld	sp,stack					; System STACK

	nextreg	TURBO_CONTROL_NR_07,%00000011	; 28Mhz / 27Mhz

	ld	hl,vector_table	; 252 (FCh)
	ld	a,h
	ld	i,a
	im	2

	inc	a							; 253 (FDh)

	ld	b,l							; Build 257 BYTE INT table
	.irq:	ld	(hl),a
	inc	hl
	djnz	.irq					; B = 0
	ld	(hl),a

	ld	a,$FB						; EI
	ld	hl,$4DED					; RETI
	ld	(irq_vector-1),a
	ld	(irq_vector),hl

	ld	bc,0xFFFD					; Turbosound PSG #1
	ld	a,%11111111
	out	(c),a


	nextreg VIDEO_INTERUPT_CONTROL_NR_22,%00000100
	nextreg VIDEO_INTERUPT_VALUE_NR_23,255

	ld	sp,stack					; System STACK
	ei

	; Init the NextSID sound engine, setup the variables and the timers.

	ld	de,0						; LINE (0 = use NextSID)
	ld	bc,192						; Vsync line
	call	nextsid_init			; Init sound engine

	; Setup a duty cycle and set a PT3.

	call	nextsid_stop	; Stop playback
	
	; channel b 
	ld	hl,test_waveformb
	ld	a,16-1		; 16 BYTE waveform
	;call	nextsid_set_waveform_C

	ld	hl,16		; Slight detune
	;call	nextsid_set_detune_C

	; channel a 
	ld	hl,test_waveforma
	ld	a,16-1		; 16 BYTE waveform
	call	nextsid_set_waveform_A

	ld	hl,16		; Slight detune
	call	nextsid_set_detune_A

	ld	hl,$a000 	; Init the PT3 player.
	ld	a,34		; Bank8k a 1st 8K
	ld	b,35		; Bank8k b 2nd 8K
	
	call	nextsid_set_pt3

	nextreg $55,34
	nextreg $56,35
	
	call	init		; VT1-MFX init as normal

	nextreg $55,5 
	nextreg $56,0
	nextreg $57,33

    call	nextsid_play	; Start playback

end asm 

ab=GetReg($1) band %11110000



if ab = %01000000
    setpsgclock(1750000)
endif 

'poke uinteger 23606,@font - 256
poke uinteger 23606,@font - 256
SetupTileHW($5b,$60)                 ' map address $xx00, tile addresss $xx00

asm 
    ; Tuurns on the tilemap 
    nextreg TILEMAP_CONTROL_NR_6B,%10100000				;' Tilemap Control on & on top of ULA,  40x32
end asm

DrawMetaTable(@msg1,2,0)
DrawMetaTable(@msg2,1,3)

ScrollerInit()
a=0 : key = 0
do 

    a = GetKeyScanCode()

    if a=KEY1 and key = 0 
        rand()
        dg  = ((peek @rand_num1) )
        rand()
        dh  =  ((peek @rand_num1) )
        key 	= 1 
    elseif a = KEYP and key = 0 
        dh      = dh + 1 
        key 	= 1 
    elseif a = KEYO and key = 0 
        dh      = dh - 1 
        key 	= 1 
    elseif a = KEYQ and key = 0 
        dg      = dg - 1 
        key 	= 1 
    elseif a = KEYW and key = 0 
        dg      = dg + 1 
        key 	= 1 
    elseif a = 0 and key = 1 
        key 	= 0 
    endif 

    Scroller()
    
	asm 
		call	nextsid_vsync
	end asm 

    NextRegA(LAYER2_XOFFSET_NR_16,timer)
    timer = timer -1 
    NextRegA(LAYER2_YOFFSET_NR_17,Peek(@sintable+cast(uinteger,timer)))
    draw_sprites()
    copper_wobble()
    
    if timer3 = 0 
        pal_cycle()
        timer3 = 3
    else 
        timer3 = timer3 - 1
    endif 
loop 

sub fastcall setpsgclock(clock as ulong)

	asm  
		ex de,hl
		call nextsid_set_psg_clock
	end asm 

end sub 

dim s       as ubyte = 0 

sub draw_sprites()              ' //MARK: - Draw Sprites

    dim x       as ubyte 
    dim dx      as ubyte 
    dim dy      as ubyte 
    dim max     as ubyte 


    pcounter    = 0 
    pcounter2   = 0
    max         = 64

    for x = 0 to max-1

        sx=peek(@sintable+(position + pcounter) )                     ' adds rotation around middle base 
        sy=peek(@sintable+(position + 64 + pcounter) ) 

        dx=peek(@sintable2+((x  +  pcounter2)))   >>2                            ' adds rotation around middle base 
        dy=peek(@sintable2+((x  + 64 + pcounter2) )) >>2

        pcounter = 2+pcounter + dg ' + x/16
        pcounter2 = dh + pcounter2+6  ' + x/16

        if delay = 0 
            
            position = (position + 1) 
            delay = 64
            delay2 = delay2 - 1 
            
        else 
            delay = delay -1 
            
        endif         
        if delay2 = 0 
            sadd = sadd + 8 : if sadd >16 : sadd = 0 : endif 
            delay2 = 0
            
        endif 
        s = (sy>>2 band 7)
        
        UpdateSprite(cast(uinteger,120+sx-dx),88+sy-dy,x,s+sadd,0,0 )

        
    next 
        
end sub 

sub pal_cycle()
    asm 
    
        ld      hl,cycle_palette
        ld      a, (hl)
        ld      de,cycle_palette
        inc     hl 
        ldi : ldi : ldi : ldi : ldi : ldi : ldi : ldi 
        ldi : ldi : ldi : ldi : ldi : ldi : ldi : ldi 
        dec     hl 
        ld      (hl), a

   ;     nextreg PALETTE_CONTROL_NR_43, %00010000        ; set L2 pal
   ;     nextreg PALETTE_INDEX_NR_40,0 

   ;     ld      hl,cycle_palette
   ;     ld      b,7

   ; upload_loop: 
   ;     ld      a,(hl)
   ;     nextreg PALETTE_VALUE_NR_41,a 
   ;     djnz    upload_loop

    end asm 
end sub 



rand_num1:
asm 
rand_num:
    dw 00
end asm 

sub rand() 

    asm 
rnd:
    ld  hl,0xA280   ; yw -> zt
    ld  de,0xC0DE   ; xz -> yw
    ld  (rnd+4),hl  ; x = y, z = w
    ld  a,l         ; w = w ^ ( w << 3 )
    add a,a
    add a,a
    add a,a
    xor l
    ld  l,a
    ld  a,d         ; t = x ^ (x << 1)
    add a,a
    xor d
    ld  h,a
    rra             ; t = t ^ (t >> 1) ^ w
    xor h
    xor l
    ld  h,e         ; y = z
    ld  l,a         ; w = t
    ld  (rnd+1),hl
    ld  (rand_num), a
    end asm 

end sub 
sub ScrollerInit()
    asm 

    call Scroller.inituscroll

    end asm 
end sub 

sub fastcall SetupTileHW(tileaddr as ubyte, tiledata as ubyte)
	    
    asm     
         
        exx : pop hl : exx : push af 
         
        nextreg PALETTE_CONTROL_NR_43,%00110000             ; NextReg($43,%00110000)	' Tilemap first palette
                                                            ; writing to NR$43 resets NR$40
        ld hl,palbuff                                       ; upload palette for tilemap
        ld b,31
	_tmuploadloop:
        ld a,(hl) : nextreg PALETTE_VALUE_9BIT_NR_44,a
        inc hl 
        ld a,(hl) :
        inc hl 
        nextreg PALETTE_VALUE_9BIT_NR_44,a
        djnz _tmuploadloop

        ; ' tilemap 40x32 no attribute 256 mode 
        nextreg TILEMAP_DEFAULT_ATTR_NR_6C,%00000001		; Default Tilemap Attribute on & on top of ULA,  80x32 
        
        pop af 
        nextreg TILEMAP_BASE_ADR_NR_6E,$5b				    ; tilemap data
        pop af 
        nextreg TILEMAP_GFX_ADR_NR_6F,$60				        ; tilemap images 4 bit 
        
        nextreg ULA_CONTROL_NR_68,%00010000				    ; ULA CONTROL REGISTER
        ; nextreg GLOBAL_TRANSPARENCY_NR_14,0  				; Global transparency bits 7-0 = Transparency color value (0xE3 after a reset)
        nextreg TILEMAP_TRANSPARENCY_I_NR_4C,$0				; Transparency index for the tilemap
        pop af    
		nextreg MMU2_4000_NR_52,41
		ld hl,$4000                                     ; copy the tile image data from bank 30 into place
		ld de,$6000
		ld bc,1248 										; size of tiles
		ldir 
        
        nextreg MMU2_4000_NR_52,$0a                     ; pop bank orginal bank $0a 
		ld hl,$5B00                                       ; copy map to tilemap data
		ld de,$5B01                                     
		ld bc,1279
        ld (hl),46

        ldir 
        
        exx : push hl : exx 
    end asm 
    ClipTile(0,255,0,255)				
end sub 


sub fastcall UpdateTilemap(xx as ubyte, yy as ubyte, vv as ubyte)
    ' this routine will place tile vv at xx,yy
    asm 
		pop hl : exx                ; save ret address 
		ld hl,$5b00                 ; start of tilemap data
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

sub fastcall MetaTile(MetaTile as ubyte, xx as ubyte, yy as ubyte )
	asm 
		;BREAK
		exx : pop hl : exx 	; store return address 
	
		; a = MetaTile 
		; stack = xx 
		; stack -2 = yy

		ld hl,tiletable
		
		ld d,a
		ld e,16
		mul d,e 
 
		add hl,de 
		;add hl,a 			; hl now has address of tile data 
		
		ld (bringback+1),hl 
 
		; hl = $4000+x
		ld hl,$5b00 
		pop af 
		add hl,a 
		pop de 
		ld e,40
		mul d,e 
		add hl,de			; hl address to place tile 
		
		; hl now has address of start x,y 

bringback:		
		ld de,0000
		ex de,hl
		ld c,0 
		ld b,5
tilemaploop:
		ldi : ldi : ldi : ldi 
		add de,40-4
		djnz tilemaploop

		exx 
		push hl 

	end asm 
end sub


sub DrawMetaTable(byval address as uinteger, byval xpos as ubyte, byval ypos as ubyte)

    dim num as ubyte 
    dim tile as ubyte 

    num = peek(address)
	ypos = 2+ypos*2 * 4	
    for x = 1 to num
        tile=peek(address+cast(uinteger,x))
        MetaTile(tile,(xpos+x)*4,ypos)
        
    next x 

end sub 

Sub Scroller()
asm 
        ; //MARK: - Scroller()

        push namespace Scroller
        call updateuscroll
        call replicate

        ret



        inituscroll:
        ld hl,message-1                               	; set to refresh char on first call
        ld (scrollupos),hl
        ld hl,pixucount     							; variable to check if new character needed
        ld (hl),1
        ret

    updateuscroll:
        ld hl,pixucount     							; update pixel count
        dec (hl)
        jr nz,scroll

    newuchar:
        ld (hl),8         							; reset pixel count

        ld hl,(scrollupos)              ; update current character
        inc hl
        ld (scrollupos),hl
        ld a,(hl)           ; check for loop token
        or a
        jr nz,getuglyph

    loopumsg:
        ld hl,message                       ; loop if necessary
        ld (scrollupos),hl

    getuglyph:
        ld l,(hl)                                             ; collect letter to print in ascii
        ld h,0                                                                ; convert to offset within font data
        add hl,hl
        add hl,hl
        add hl,hl
        ld de,.font.font-256                       ; base address for font within ROM
        add hl,de                           ; hl=> this letter's font data

        ld de,tempchar                      ; move font data to tempchar space
        ld bc,8
        ldir

    scroll:
        ld hl,20735-32                         ; top-right of print area
        ld de,tempchar

        ld c,8                                                                ; loop to scroll 8 rows

    nextrow:
        ex de,hl                                              ; scroll tempchar area left one pix, keep leftmost bit in carry
        rl (hl)
        ex de,hl
        push hl

        ld b,32

    scrollrow:
        rl (hl)                                                                         ; scroll each pixel left from right to left of screen.
        dec l                                                                           ; NB rightmost byte scrolls tempchar carry data onto screen first time through
        djnz scrollrow                  

        pop hl                                                                ; next raster line down
        inc h
        inc de                                                                ; find next tempchar data position
        dec c
        jr nz,nextrow

        ret


    replicate:

        ld      b, 32
        ld      e, 0 

        ld      hl,sintable             ; point to sin table 
        ld      a, (sintimer)           ; get current timer pos
        add     hl, a                   ; offset into table 

    left:    
        push    hl                  ; store offset into table on stack 
        push    bc                  ; save loops as we will need to use BC again 

        ld      a, (hl)             ; Y scroll position 
        ld      (copy_line+1), a    ; save in copy line  

        ld      b, 184-12           ; Y position to start copy - char line 22
        ld      c,16                ; how many blocks to copy 

    rep_loop: 
        
        ld      d,b                 ; Y = 184   ; make d = Y 

        PIXELAD                     ; ED XY = HL s is already 0 
        ld      a,(hl)              ; get  first 8 pixels 
SPRITE_CONTROL_NR_15
    copy_line:
        ld      d,0                 ; first Y position of sine scroller, smc from above 
        
        PIXELAD                     ; get screen address of ED in hl 
       ; BREAK
        ld      (hl),a              ; store the 8 pixels 
        inc     b                   ; inc Y 
        ld      hl, copy_line+1     ; point to copy line + 1 
        inc     (hl)                ; increase copy Y + 1 
        dec     c                   ; 1 less loop 
        ld      a, c                ; check if it 0 yet 
        or      a 
        jr      nz, rep_loop        ; repeat until chr block drawn 

        ld      a, 8                ; now move our copy position + 8 pixels 
        add     a, e 
        ld      e, a 
        

        ld      a,(counter)         ; check the counter 
        dec     a                   ; - 1 
        jr      nz, overadd         ; its not zero so jump to overadd 
        ld      a, 18               ; else a = 16 
        ld      hl,sintimer         ; point to sintimer 
        inc     (hl)                ; add + 1 
        
    overadd:
        ld      (counter),a         ; save the counter 
        pop     bc 
        dec     b 
        xor     a 
        or      b 
        pop     hl                  ; get back sintable 
        inc     hl 
        inc     hl 

        jr      nz, left 
        ret 

        startline:
        db 16 
        counter:
        db 16

        tempchar:
        db 0,0,0,0,0,0,0,0

        scrollupos: dw 0
        pixucount:  db 0

        ; //MARK: - ScrollerText 
        message:

        db "                                     "
        db " Hello and welcome to my entry to the DOTJAM!!   -------- "
        db "  I have probably broken all the rules but I got carried away and just ejoyed myself, there's still room left but I have to stop tweaking     ------"
        db "  You are listening to the excellent NextSID engine by 9bitcolor and chiptune by z00m            "
        db "                There were'nt any rules about all being my yourelf right??           ------               "
        db "  demo coding & gfx by em00k, nextsid engine by 9bitcolor, music by z00m           "
        db "            you can now use keys QW - OP to adjust the sprite patterns press 1 for a random mix       "
        db "     big fat greets to all the usual lot and you             -------   emk 12/06/22  ------                              "
        db 0

    sintimer:
        db 0 

    sintable:
        db 16,14,13,12,11,10,9,8,7,6,5,4,3,2,2,1
        db 1,0,0,0,0,0,0,0,0,0,0,1,1,2,3,3
        db 4,5,6,7,8,9,10,11,13,14,15,16,17,18,20,21
        db 22,23,24,25,26,27,28,28,29,30,30,31,31,31,31,31
        db 31,31,31,31,31,30,30,29,29,28,27,26,25,24,23,22
        db 21,20,19,18,17,16,14,13,12,11,10,9,8,7,6,5
        db 4,3,2,2,1,1,0,0,0,0,0,0,0,0,0,0
        db 1,1,2,3,3,4,5,6,7,8,9,10,11,13,14,15
        db 16,17,18,20,21,22,23,24,25,26,27,28,28,29,30,30
        db 31,31,31,31,31,31,31,31,31,31,30,30,29,29,28,27
        db 26,25,24,23,22,21,20,19,18,17,16,14,13,12,11,10
        db 9,8,7,6,5,4,3,2,2,1,1,0,0,0,0,0
        db 0,0,0,0,0,1,1,2,3,3,4,5,6,7,8,9
        db 10,11,13,14,15,16,17,18,20,21,22,23,24,25,26,27
        db 28,28,29,30,30,31,31,31,31,31,31,31,31,31,31,30
        db 30,29,29,28,27,26,25,24,23,22,21,20,19,18,17,16

        db 16,14,13,12,11,10,9,8,7,6,5,4,3,2,2,1
        db 1,0,0,0,0,0,0,0,0,0,0,1,1,2,3,3
        db 4,5,6,7,8,9,10,11,13,14,15,16,17,18,20,21
        db 22,23,24,25,26,27,28,28,29,30,30,31,31,31,31,31
        db 31,31,31,31,31,30,30,29,29,28,27,26,25,24,23,22
        db 21,20,19,18,17,16,14,13,12,11,10,9,8,7,6,5
        db 4,3,2,2,1,1,0,0,0,0,0,0,0,0,0,0
        db 1,1,2,3,3,4,5,6,7,8,9,10,11,13,14,15
        db 16,17,18,20,21,22,23,24,25,26,27,28,28,29,30,30
        db 31,31,31,31,31,31,31,31,31,31,30,30,29,29,28,27
        db 26,25,24,23,22,21,20,19,18,17,16,14,13,12,11,10
        db 9,8,7,6,5,4,3,2,2,1,1,0,0,0,0,0
        db 0,0,0,0,0,1,1,2,3,3,4,5,6,7,8,9
        db 10,11,13,14,15,16,17,18,20,21,22,23,24,25,26,27
        db 28,28,29,30,30,31,31,31,31,31,31,31,31,31,31,30
        db 30,29,29,28,27,26,25,24,23,22,21,20,19,18,17,16
        pop namespace
    end asm 
end sub 


sintable:
asm 
    db 64,62,60,59,57,56,54,53,51,49,48,46,45,43,42,40
    db 39,37,36,35,33,32,30,29,28,27,25,24,23,22,20,19
    db 18,17,16,15,14,13,12,11,10,9,8,8,7,6,6,5
    db 4,4,3,3,2,2,1,1,1,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,1,1,1,2,2,2,3,3,4
    db 5,5,6,7,7,8,9,10,11,11,12,13,14,15,16,18
    db 19,20,21,22,23,25,26,27,28,30,31,33,34,35,37,38
    db 40,41,43,44,46,47,49,50,52,53,55,56,58,60,61,63
    db 64,66,67,69,71,72,74,75,77,78,80,81,83,84,86,87
    db 89,90,92,93,94,96,97,99,100,101,102,104,105,106,107,108
    db 109,111,112,113,114,115,116,116,117,118,119,120,120,121,122,122
    db 123,124,124,125,125,125,126,126,126,127,127,127,127,127,127,127
    db 127,127,127,127,127,127,127,126,126,126,125,125,124,124,123,123
    db 122,121,121,120,119,119,118,117,116,115,114,113,112,111,110,109
    db 108,107,105,104,103,102,100,99,98,97,95,94,92,91,90,88
    db 87,85,84,82,81,79,78,76,74,73,71,70,68,67,65,64
    db 64,62,60,59,57,56,54,53,51,49,48,46,45,43,42,40
    db 39,37,36,35,33,32,30,29,28,27,25,24,23,22,20,19
    db 18,17,16,15,14,13,12,11,10,9,8,8,7,6,6,5
    db 4,4,3,3,2,2,1,1,1,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,1,1,1,2,2,2,3,3,4
    db 5,5,6,7,7,8,9,10,11,11,12,13,14,15,16,18
    db 19,20,21,22,23,25,26,27,28,30,31,33,34,35,37,38
    db 40,41,43,44,46,47,49,50,52,53,55,56,58,60,61,63
    db 64,66,67,69,71,72,74,75,77,78,80,81,83,84,86,87
    db 89,90,92,93,94,96,97,99,100,101,102,104,105,106,107,108
    db 109,111,112,113,114,115,116,116,117,118,119,120,120,121,122,122
    db 123,124,124,125,125,125,126,126,126,127,127,127,127,127,127,127
    db 127,127,127,127,127,127,127,126,126,126,125,125,124,124,123,123
    db 122,121,121,120,119,119,118,117,116,115,114,113,112,111,110,109
    db 108,107,105,104,103,102,100,99,98,97,95,94,92,91,90,88
    db 87,85,84,82,81,79,78,76,74,73,71,70,68,67,65,64

    db 0,-1,-3,-4,-6,-7,-9,-10,-11,-12,-13,-14,-14,-15,-15,-15
    db -15,-15,-15,-15,-14,-13,-12,-11,-10,-9,-8,-6,-5,-3,-2,0
    db 0,2,3,5,6,8,9,10,11,12,13,14,15,15,15,15
    db 15,15,15,14,14,13,12,11,10,9,7,6,4,3,1,0
    db 0,-1,-3,-4,-6,-7,-9,-10,-11,-12,-13,-14,-14,-15,-15,-15
    db -15,-15,-15,-15,-14,-13,-12,-11,-10,-9,-8,-6,-5,-3,-2,0
    db 0,2,3,5,6,8,9,10,11,12,13,14,15,15,15,15
    db 15,15,15,14,14,13,12,11,10,9,7,6,4,3,1,0
end asm 

sintable2:
asm 
    db 127,118,108,99,90,81,72,64,56,48,41,34,28,22,17,13
    db 9,6,3,1,0,0,0,1,2,4,7,11,15,20,25,31
    db 38,45,52,60,68,77,85,94,104,113,122,132,141,150,160,169
    db 177,186,194,202,209,216,223,229,234,239,243,247,250,252,253,254
    db 254,254,253,251,248,245,241,237,232,226,220,213,206,198,190,182
    db 173,164,155,146,136,127,118,108,99,90,81,72,64,56,48,41
    db 34,28,22,17,13,9,6,3,1,0,0,0,1,2,4,7
    db 11,15,20,25,31,38,45,52,60,68,77,85,94,104,113,122
    db 132,141,150,160,169,177,186,194,202,209,216,223,229,234,239,243
    db 247,250,252,253,254,254,254,253,251,248,245,241,237,232,226,220
    db 213,206,198,190,182,173,164,155,146,136,127,118,108,99,90,81
    db 72,64,56,48,41,34,28,22,17,13,9,6,3,1,0,0
    db 0,1,2,4,7,11,15,20,25,31,38,45,52,60,68,77
    db 85,94,104,113,122,132,141,150,160,169,177,186,194,202,209,216
    db 223,229,234,239,243,247,250,252,253,254,254,254,253,251,248,245
    db 241,237,232,226,220,213,206,198,190,182,173,164,155,146,136,127
    db 127,118,108,99,90,81,72,64,56,48,41,34,28,22,17,13
    db 9,6,3,1,0,0,0,1,2,4,7,11,15,20,25,31
    db 38,45,52,60,68,77,85,94,104,113,122,132,141,150,160,169
    db 177,186,194,202,209,216,223,229,234,239,243,247,250,252,253,254
    db 254,254,253,251,248,245,241,237,232,226,220,213,206,198,190,182
    db 173,164,155,146,136,127,118,108,99,90,81,72,64,56,48,41
    db 34,28,22,17,13,9,6,3,1,0,0,0,1,2,4,7
    db 11,15,20,25,31,38,45,52,60,68,77,85,94,104,113,122
    db 132,141,150,160,169,177,186,194,202,209,216,223,229,234,239,243
    db 247,250,252,253,254,254,254,253,251,248,245,241,237,232,226,220
    db 213,206,198,190,182,173,164,155,146,136,127,118,108,99,90,81
    db 72,64,56,48,41,34,28,22,17,13,9,6,3,1,0,0
    db 0,1,2,4,7,11,15,20,25,31,38,45,52,60,68,77
    db 85,94,104,113,122,132,141,150,160,169,177,186,194,202,209,216
    db 223,229,234,239,243,247,250,252,253,254,254,254,253,251,248,245
    db 241,237,232,226,220,213,206,198,190,182,173,164,155,146,136,127
end asm 

wavea: 
asm 
wavea: 
test_waveforma:
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
end asm 

waveb: 
asm 
waveb: 
test_waveformb:
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
end asm 

wavec: 
asm 
test_waveformc:
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
 db 128,000,128,000,128,000,128,000
end asm 

font: 
asm 
    push namespace font
    font: 
    incbin "./data/Block_bold.SpecCHR"
    pop namespace
end asm 

tiles:
asm 
    ; 4 x 4 tiles for each letter 
    tiletable:
    incbin "./data/tiles.nxb"

end asm 

asm 
    palbuff:
    incbin "./data/tiles.nxp"
end asm 

msg1:
asm:
    db 5, 00, 01, 02, 02, 03
end asm: 


msg2:
asm:
    db 7, 05, 06, 04, 07, 00, 06, 08
end asm: 

#include "inc-copper.bas"

