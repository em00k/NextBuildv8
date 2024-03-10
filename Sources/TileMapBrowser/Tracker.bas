'!org=40960
'!copy=h:\modules\plottest.nex
' NextBuild GUI Example 
'!opt=2
'!heap=512
'
'

#define NEX 
'#define CUSTOMISR

#include <nextlib.bas>
#include <keys.bas>
#include "hex.bas"
#include "tilemapetext-inc.bas"
#include "mouse-inc.bas"



' -------------------------------------------------------------
' -- Set Registers 
' -------------------------------------------------------------

asm 
    TILE_GFXBASE 		equ 	$40 
    TILE_MAPBASE 		equ 	$44

    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg NEXT_RESET_NR_02,128
   ; nextreg PERIPHERAL_3_NR_08,%01000000

    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg SPRITE_CONTROL_NR_15,%00001011  ; %000    S L U, %11 sprites on over border
    nextreg LAYER2_CONTROL_NR_70,%00010000  ; 5-4 %01 = 320x256x8bpp

    nextreg CLIP_TILEMAP_NR_1B,0                        ; Tilemap clipping 
    nextreg CLIP_TILEMAP_NR_1B,159
    nextreg CLIP_TILEMAP_NR_1B,0
    nextreg CLIP_TILEMAP_NR_1B,255

    NextReg TILEMAP_DEFAULT_ATTR_NR_6C,%00000000        ; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_CONTROL_NR_6B,%11001001				; tilemap on & on top of ULA,  80x32 
    NextReg TILEMAP_BASE_ADR_NR_6E,TILE_MAPBASE		    ; tilemap data $6000
    NextReg TILEMAP_GFX_ADR_NR_6F,TILE_GFXBASE		    ; tilemap blocks 4 bit tiles $4000
    NextReg PALETTE_CONTROL_NR_43,%00110000				; pick the tilemap palette 

    di  
end asm 

dim x               as UINTEGER
dim y               as UINTEGER
dim x1,y1,x2,y2     as ubyte
dim time            as uinteger
dim sx              as uinteger
dim pen_color       as ubyte 
dim pen_color2      as ubyte 
dim sy              as ubyte 
dim sy2             as ubyte 
dim sc              as ubyte 
dim bsy2            as ubyte 
dim t               as uinteger
dim Draw_Box_x      as ubyte
dim Draw_Box_y      as ubyte
dim Draw_Box_w      as ubyte
dim Draw_Box_h      as ubyte

dim vert            as ubyte 
dim co              as ubyte 
dim xt              as uinteger
dim xu              as uinteger
dim tmp_address     as uinteger
dim last_id         as ubyte 
dim dclick          as ubyte 
dim add             as uinteger 
dim add2            as uinteger 
dim pattern_v       as ubyte = 0000
dim click           as ubyte 
dim tempstr         as string = ""


const LeftButton    as ubyte = 13
const RightButton   as ubyte = 14
const BothButton    as ubyte = 12
const NoButton      as ubyte = 15


' -------------------------------------------------------------
' -- Set up 
' -------------------------------------------------------------


LoadSDBank("mouse.spr",0,0,0,31)
InitSprites2(32,0,31)

LoadSDBank("ATASCII.spr",0,0,0,20)							' 1 bit font to bank 20
LoadSDBank("mm.pal",1024,0,0,20)								' palette to bank 20 + $0200
NextReg($50,20)													' page bank 20 to $e000, slot 7 
PalUpload($0400,64,0)											' upload the palette 
CopyToBanks(20,10,1,1024)										' copy bank 20 > 2 with 1 bank of length 1024 bytes 
NextReg($50,$ff)
ClearTilemap() 

'SetUpIM()
'

asm : di : end asm 

NextReg(PALETTE_CONTROL_NR_43,%00010000)
ClipLayer2(0,255,0,255)
SetRGB(0,0,0,0)  ' very drak grey 
SetRGB(1,2,2,2)  ' very dark grey 
SetRGB(2,3,3,3)  ' dark grey 
SetRGB(3,4,4,4)  ' grey 
SetRGB(4,5,5,5)  ' middle grey 
SetRGB(5,6,6,6)  ' light grey 
SetRGB(6,7,7,7)  ' white 
SetRGB(7,1,1,1)  ' very very drak grey 

' Cls256(0)
border 0
dim xx1,xx2,xx3,yy1,yy2,yy3 as integer
dim c as ubyte 
asm 
    ld hl,$e000
    ld de,$e001
    ld (hl),0
    ld bc,2560
    ldir
end asm 


' -------------------------------------------------------------
' -- TEST AREA 
' -------------------------------------------------------------

' DrawRownDown()

' -------------------------------------------------------------
' -- Draw Start Panels 
' -------------------------------------------------------------


SetPlotInk(128)
Draw_Box(@panel1)
Draw_Box(@panel2)
Draw_Button(@buttonOK)
'Draw_Button(@button2)
'Draw_Button(@button3)

' for x = 0 to 15 
' TextLine(2,x+1,"TEST",x)
' next 


' -------------------------------------------------------------
' -- Main Loop 
' -------------------------------------------------------------

ReSetPatterBuffer()
DrawRownDown()


do

    Update_Mouse()
    WaitRetrace2(0)
loop 

border pen_color


' -------------------------------------------------------------
' -- Sub Routines  
' -------------------------------------------------------------


sub Update_Mouse()
    
    dim mx, my  as uinteger
    dim mbutt   as ubyte

    Process_Mouse()

    mx = peek(@Mouse+1)
    my = peek(@Mouse+3)
	mbutt=peek(@Mouse) band 15 

    UpdateSprite(mx,my,0,16,0,0)

    mx = (mx) >> 2 
    my = my >> 3 
    
    TextLine(1,29,str(mx),13)
    TextLine(1,30,str(my),13)

    TextLine(5,31,str(mbutt),6)

    if (mbutt = LeftButton or mbutt = BothButton) and click = 0 
        
        map_value = peek($e000+cast(uinteger,mx)+cast(uinteger,my)*80)
 
        if map_value > 0 
            TextLine(10,31,str(map_value),13)
            tmp_address = @objectbuffer + cast(uinteger,map_value<<1)
            '   tmp_address now is points to the address of the object 
            tmp_address = peek(uinteger,tmp_address)
            PeekMem(tmp_address+6,code ",",tempstr)
            'TextLine(10,25,tempstr,4)
            Draw_Press(tmp_address,4)
            click = 1
            
            if mbutt = BothButton
                dclick = 1 
            else 
                dclick = 0 
            endif 

            last_id=map_value

        endif 
    elseif (mbutt = NoButton or mbutt = RightButton)  and click = 2 
        Draw_Press(tmp_address,0)
        TextLine(10,31,"---",13)
        click = 0 
        TextLine(20,31,"       ",4)
    elseif (mbutt = NoButton or mbutt = BothButton) and click = 1
        if peek($e000+cast(uinteger,mx)+cast(uinteger,my)*80) = last_id
            ' the mouse is still over the button we clicked on
            ' now call the relevant command 
            Process_Button(last_id)
            if dclick = 1
                TextLine(20,31,"Doub cl",4)
            else 
                TextLine(20,31,"Clicked "+str(last_id),4)
            endif 
         
        endif 
        click = 2 
    endif 
    
end sub 

sub Process_Button(byval in_id as ubyte)

    dim textready   as ubyte = 0 
    dim tx, ty      as ubyte 
    dim outputtext  as uinteger

    if dclick > 0 
        addvalue = 10 
    else 
        addvalue = 1
    endif 

    if in_id = 1 
        pattern_v=pattern_v+addvalue band 127 
        textready = 1 
        tx = 17 
        ty = 2 
        outputtext = pattern_v
    elseif in_id=2 
        if pattern_v>addvalue-1
            pattern_v=pattern_v-addvalue
            tx = 17 
            ty = 2 
            outputtext = pattern_v        
            textready = 1         
        endif 
    endif 

    if textready = 1 
        TextLine(tx,ty,hex16(outputtext),14)
    endif 

end sub 

sub Draw_Box(byval Draw_Box_data as uinteger)

    ' SetPlotInk(128)
    dim     add         as uinteger 
    dim     y3, type    as ubyte 
    dim     top_colour  as ubyte 
    dim     bot_colour  as ubyte 

    add = Draw_Box_data      ' seek address of panel data 

    do
        x1 = peek(ubyte, add)       ' x 
        y1 = peek(ubyte, add+1) +1    ' y 
        x2 = peek(ubyte, add+2)     ' width 

        if x2 >160 : exit do : endif    ' if x2*2 > 320 then exit panel routine 

        y2 = peek(ubyte, add+3)-1   ' height 
        co = peek(ubyte, add+5)     ' colour 
        
        type = peek(ubyte, add+4)   ' 0 raised, 1 lowered, 16+ button ID

        if  type = 0            ' not pressed 
            ' raised 
            top_colour = 5    ' light grey 
            bot_colour = 2      ' dark grey 
        elseif type = 1         ' lowered  
            ' lowered 
            top_colour = 2    
            bot_colour = 5
        elseif type = 2
            ' lowered 
            top_colour = 7    
            bot_colour = 7
        elseif type = 4         ' pressed 
            ' pressed  
            top_colour = 2   
            bot_colour = 2
            co = 1 
        endif

        y3 = y1 + y2            ' end y pixel =  y pos +height  0-255

        xu    =   cast (uinteger, ( x2 ) ) << 1     ' w needs to be doubled 
        xu    =   xu + cast (uinteger, x1) +1         ' and now make xu = x + w 0-320

        for xt = x1 to xu 
           '           y    x  colour 
           FPlotLineV(y1,xt,y2, co)                 ' plot vertical line, as we're in 320*256
        next 

        if co = 0                                   ' if the colour = 0 we can exit 
            return 
        endif 

        ' horizontal shading 
        for xt = x1 to xu 
            FPlotL2(y1,xt,top_colour)
            FPlotL2(y3,xt,bot_colour)
        next 


        ' vertical shading 
        FPlotLineV(y1,x1,y2, top_colour)
        FPlotLineV(y1,xu,y2, bot_colour)

        ' corners 
        if type < 4
            FPlotL2(y1,xu,4)
            FPlotL2(y3,x1,4)
        endif 
        add = add + 6               ' size of each panel datablock 

    loop 

end sub 


' -------------------------------------------------------------
' -- GUI Panel Data 
' -------------------------------------------------------------


panel1:
asm 
    ;  x y w/2 h        black bach ground 
    db 0,0,160,255, 0, 0 
end asm 

panel2:
asm 
    ;  x    y       w/2     h         t  colour 
    db 4    ,4      ,160-4  ,255-8 , 0, 3            ; back raid panel 
   ; db 100  ,100    ,50     ,20     , 2, 7            ; middle button 

    db 15   ,128    ,16    ,120     , 1, 7            ; middle button lowered
    db 34   ,128    ,31   ,120     , 1, 7            ; middle button lowered
    db 92   ,128    ,31   ,120     , 1, 7            ; middle button lowered
    db 148   ,128    ,31   ,120     , 1, 7            ; middle button lowered
    db 204   ,128    ,29   ,120     , 1, 7            ; middle button lowered

    db $ff,$ff,$ff,$ff, 146

end asm 

sub Draw_Button(Buttond_data as uinteger)

    ' draws button and text 

    dim width   as ubyte 
    dim bx      as ubyte 
    dim by      as uinteger 
    dim tlen    as uinteger 
    dim col     as ubyte 

    add     = Buttond_data
    add2    = @buttontmp

    do 

        tempstr = "" 

        PeekMem(add+5,code "," ,tempstr)      ' get the button name 

        tlen    = len (tempstr)     ' find out how long it is 

        ' add     = add + tlen  +2      ' start of button data 
        bx      = peek (add)      ' x * 8 
        by      = peek (add+1)    ' y * 8 

        type    = peek (add+2)      ' type 
        col     = peek (add+3)      ' col 
        id      = peek (add+4)      ' id 

        if  type = 4 
            width = 123
        else 
        
            width   = cast(ubyte, tlen *2) +1    ' txt len * 8 + 2 

        endif 

        poke    add2, (bx <<2)-1
        poke    add2+1,(by <<3)-1
        poke    add2+2, width 
        poke    add2+3, 8  ' height 
        poke    add2+4, type
        poke    add2+5, 4 

        Draw_Box(@buttontmp)

        TextLine(bx,by,tempstr,col)

        if  id > 0 
            y = by * 80 
            for x = bx to bx+tlen 
                poke $e000+cast(uinteger,x)+cast(uinteger,y),id 
                poke uinteger @objectbuffer+Cast(uinteger,id<<1), add
            next 
        endif 
         
        if  peek(add+tlen+6) = $ff then exit do 
        add = add + tlen + 7

    loop 
end sub 

sub Draw_Press(Buttond_data as uinteger, mode as ubyte)

    ' draws button and text 

    dim width   as ubyte 
    dim bx      as ubyte 
    dim by      as uinteger 
    dim col     as ubyte 

    add     = Buttond_data
    add2    = @buttontmp

        tempstr = "" 

        PeekMem(add+5,code "," ,tempstr)      ' get the button name 

        tlena    = len (tempstr)     ' find out how long it is 

        ' add     = add + tlen  +2      ' start of button data 
        bx      = peek (add)      ' x * 8 
        by      = peek (add+1)    ' y * 8 

        width   = cast(ubyte, tlena *2) +1    ' txt len * 8 + 2 

        type    = peek (add+2)      ' type 
        col     = peek (add+3)      ' col 
        'id      = peek (add+4)      ' id 

        poke    add2, (bx <<2)-1
        poke    add2+1,(by <<3)-1
        poke    add2+2, width 
        poke    add2+3, 8  ' height 
        
        if type = 4 
            mode = 4
        endif 
        
        poke    add2+4, mode 
         if mode < 4 
             poke    add2+5, 4
         else 
             poke    add2+5, 3
         endif 

        Draw_Box(@buttontmp)


end sub 

' // ---------------------------------------------
' // -- GUI button data --------------------------
' // ---------------------------------------------

objectbuffer:
asm     
        ds 128,0        ; room for 64 2 bytes each 
end asm 

buttontmp: 
asm
    db  0, 0, 0, 0, 0, 0 
    db  $ff,$ff, $ff,$ff,$ff
end asm 

buttonOK:
asm 
    BASE_X equ 1
    ;   x   y   t   col id 
    db BASE_X+3,   2,  4,  1,  0
    db "POSITION   ," ,0
    db BASE_X+3,   3,  0,  1,  0
    db "PATTERN    ," ,0
    db BASE_X+3,   4,  0,  1,  0
    db "LENGTH     ," ,0
    db BASE_X+3,   5,  0,  1,  0
    db "PATTERN    ," ,0
end asm 

text_status:
asm 
    ;   x   y   t   col id 
    db 4,   14,  4,  2,  25
    db "  SONG NAME : ____________________," ,0

    db 4,   15,  4,  2,  26
    db "SAMPLE NAME : ____________________," ,0

end asm 

button2:
asm 
    ;   x   y   t   col id 
    db BASE_X+22,   2,  0,  0,  1      ; up arrow 
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

end asm 

button3:
asm 
    ;   x   y   t   col id 
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
    

end asm 



sub fastcall PeekMem(address as uinteger,delimeter as ubyte,byref outstring as string)
    ' assign a string from a memory block until delimeter 
    asm 
        push namespace peekmem 
main:        
        ex de, hl 
        pop hl 
        pop af          ; delimeter 
        ex (sp),hl         
        ;' de string ram 
        ;' hl source data 
        ;' now copy to string temp
		push bc 
        push hl 
        ex de, hl 
        ld de,.LABEL._string_temp+2
        ld bc,0 
    copyloop:
        cp (hl)                 ; compare with a / delimeter 
        jr z,endcopy            ; we matched 
        push bc 
        ldi 
        pop bc 
        inc c
        jr nz,copyloop          ; loop while c<>0
        dec c 
    endcopy:
        ld (.LABEL._string_temp),bc 
        pop hl 
        ld de,.LABEL._string_temp
        ; de = string data 
        ; hl = string
		pop bc  
        pop namespace
        jp .core.__STORE_STR
    end asm 

end sub 


sub fastcall NewPlotL2(byval x as integer, byval y as integer, byval c as ubyte)

    asm 
    ; Get pixel position
    ; Pages in the correct 16K Layer 2 screen bank into 0x0000
    ; DE: X
    ; HL: Y
    ; Returns:
    ; HL: Address in memory (between 0x0000 and 0x3FFF)
    ;
    ; BREAK  
        exx 
        pop     hl              ; return stack 
        exx 
        pop     de 
    Get_Pixel_Address_M1a:	
        ex      de, hl 
        LD	    D, L 			; Store the Y coordinate in D
        LD 	    L, E			; The low byte is the X coordinate
        LD	    A, D			; Get the Y coordinate
        AND	    0x3F			; Offset in bank
        LD	    H, A			; Store in high byte
        LD	    A, D			; Get the Y coordinate
        AND	    0xC0			; Get the bank number
        RLCA 
        RLCA 
        
        ld      bc,LAYER2_ACCESS_P_123B
        OR	    %000_1_0_000    ; 7-5 = 0, 4 = 1,3=0, 2-0 16kb bank relative to L2 memory mapping
        out     (c), a 

        ; Z80PRTA	0x123B
        ; Z80PORT	0x123B, %00000111	; Enable memory read/write

        ld      a, %00_00_0_1_1_1 ; 7-6 video ram select 5-4 = 0, 3 = reg 12 normal/shadow, 2 = enable reads, 1 = L2 visible, 0 = enable writes
        out     (c), a 

        pop     af 
       ;  LD	    A, (PLOT_COLOUR)
        LD	    E, A 
        LD	    D, 0
    Plot_SETa:		
       ; LD	    A, (HL)
       ; AND	    D
       ; OR	    E
        LD	    (HL), A
        ld      a, %00000010
        out     (c), a    
        exx 
        push    hl 
        exx 
    end asm 


end sub 


'// MARK: - ISR



sub MyCustomISR()

    time = time + 1

end sub 

Sub fastcall ISR()
	' fast call as we will habdle the stack / regs etc 
	asm 

		; save all registers on stack 
		; 
		ld 		(out_isr_sp+1), sp 										; save the stack 
		ld 		sp, temp_isr_sp 										; use temp stack 
		push af : push bc : push hl : push de : push ix : push iy 		
		ex af,af'
		push af
        exx : push bc : push hl : push de :	exx
		ld 		bc,TBBLUE_REGISTER_SELECT_P_243B
		in 		a,(c)

	end asm 
	
	' you *CAN* call a su from here, but you will need to be careful that it doesnt use ROM calls that 
	' can cause a crash, 

	#ifdef CUSTOMISR 
		
		MyCustomISR()
		
	#endif 
	
    ' #ifndef NOAYFX 
	asm 
		; check if a sample has been placed into sampletoplay 
		

    skipmusicplayer:		
		ld 		a,0									; smc from above 
		ld		bc, TBBLUE_REGISTER_SELECT_P_243B
		out 	(c), a								; restore port 243b
			
		; pop registers fromt the stack 

		exx 
        pop de : pop hl : pop bc
		exx 

        pop af : ex af,af'
		pop iy : pop ix : pop de : pop hl : pop bc : pop af 
	out_isr_sp:
		ld 		sp, 0000 
		ei
		ret 									;' standard reg pops ei and reti
	end asm 
	asm 
	ds 64, 0 
    temp_isr_sp:
        db 0, 0 
	end asm 
end sub 

Sub fastcall SetUpIM()
	' this routine will set up the IM vector and set up the relevan jp 
	' note I store the jp in the middle of the vector as in reality 
	' xxFF is all that is needed, you can change this to something else
	' if you wish 
	'#ifdef IM2 
	asm 

		exx : pop hl : exx 

		di 

		ld      hl,$fe00                    ; start of interrupt vector 
		ld      de,$fe01
		ld      bc,257
		ld      a,h                         ; fill with $fe 
		ld      i,a 
		ld      (hl),a 
		ldir 

		ld      h,a
        ld      l, a
        ld      a,$c3                       ; jp 
        ld      (hl),a
        inc     hl
		ld      de,._ISR                    ; this is the address of the routine call on interrtup 
        ld      (hl),e
        inc     hl
        ld      (hl),d 	

		nextreg VIDEO_INTERUPT_CONTROL_NR_22,%00000110          ; set rasterline on for line 192 
		nextreg VIDEO_INTERUPT_VALUE_NR_23,190
		
        im      2                           ; enabled the interrupts 

		exx                                 ; restore the ret address 
        push    hl
        exx 
		ei  
	
	end asm 
    ISR()
end sub 

sub fastcall SetPlotInk(byval plot_ink as ubyte)
    asm 

        ld  (PLOT_COLOUR), a 

    end asm 
end sub 



sub SetRGB(byval index_c as ubyte, byval red_c as ubyte, byval green_c as ubyte,byval blue_c as ubyte)

    asm 
            ;  A: Colour to change (0 - 255)
            ;  B: R colour (3 bits)
            ;  C: G colour (3 bits)
            ;  D: B colour (3 bits)
            ;  Original code by Dean Bellfield - https://github.com/breakintoprogram/next-bbc-basic/blob/348302430032b08e65c1014d7eb17bad6361c6b8/next_graphics.z80#L375
            
        Set_Palette_RGB:	
            ld  a, (ix + 5)
            ld  b, (ix + 7)
            ld  c, (ix + 9)
            ld  d, (ix + 11)

            nextreg PALETTE_INDEX_NR_40, A 		; Select the colour to change


			LD	A, B			                ; Get RED component
			AND	%00000111		                ; %00000RRR
			SWAPNIB				                ; %0RRR0000
			ADD	A, A			                ; %RRR00000
			LD	B, A			                ; Store in B
			LD	A, C			                ; Get GREEN component
			AND	%00000111		                ; %00000GGG
			ADD	A, A 			                ; %0000GGG0
			ADD	A, A			                ; %000GGG00
			OR	B 			                    ; %RRRGGG00
			LD	B, A 			                ; Store in B
			LD	A, D 			                ; Get BLUE component
			AND	%00000110		                ; %00000BB0
			RRA 				                ; %000000BB
			OR	B 			                    ; %RRRGGGBB
			LD	B, A
			nextreg PALETTE_VALUE_9BIT_NR_44,a	; Write out first 8 bits
			LD	A, D 			                ; Get BLUE component
			AND	%00000001 		                ; Get 9th bit
			LD	C, A
			nextreg PALETTE_VALUE_9BIT_NR_44,a 	; Write out final bit 
		end asm  

end sub 



PLOT_COLOUR:
asm: 
PLOT_COLOUR: 
        db 0 
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

rand_num1:
asm 
rand_num:
    dw 00
end asm 

string_temp:
asm 
	string_temp:
			defs 80,0
end asm 
