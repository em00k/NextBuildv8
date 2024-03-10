'!org=40960
'!copy=h:\Tracker.nex
' NextBuild GUI Example 
'#!nosp
'!opt=2
'!heap=2048
'#!asm
'

#define NEX 
'#define CUSTOMISR
#include <nextlib.bas>
#include <keys.bas>
#include "hex.bas"




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
    nextreg LAYER2_RAM_BANK_NR_12,45        ; * 2 so 22 = 44 8kb 
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
dim x1              as uinteger
dim y1,x2,y2        as ubyte
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
dim row, play       as ubyte
dim keydown         as ubyte 
dim map_value       as ubyte 
dim mx, my  as uinteger
dim tx, ty  as uinteger
dim wheel_value     as ubyte 
dim wheel_delta     as ubyte 
dim wheel_last      as ubyte 
dim edit_panel      as ubyte 
dim diskop_on       as ubyte 
dim file_position   as ubyte = 0
dim max_positions   as ubyte = 0 


const LeftButton    as ubyte = 13
const RightButton   as ubyte = 14
const BothButton    as ubyte = 12
const NoButton      as ubyte = 15

const TILE_BUFFER   as uinteger = $9600
asm 
    TILE_BUFFER     EQU $9600
end asm 

dim pattern, position as ubyte 
dim k,slen         as ubyte 

pattern = 1
' -------------------------------------------------------------
' -- Set up 
' -------------------------------------------------------------

#include "Decode-inc.bas"
asm 
#include "Z:/zxenv/nxmod_outputbins/main.txt"
end asm 
LoadSDBank("mouse.spr",0,0,0,30)
InitSprites2(32,0,30)
'LoadSDBank("PATT2.DAT",0,0,0,26)   
'LoadSDBank("SAMP2.DAT",0,0,0,34)   

LoadSDBank("finetune.dat",0,0,0,4)
LoadSDBank("ATASCII.spr",0,0,0,20)							' 1 bit font to bank 20
LoadSDBank("mm.pal",1024,0,0,20)								' palette to bank 20 + $0200
LoadSDBank("modload.bin",0,0,0,21)
LoadSDBank("modeng.bin",0,0,0,22)
NextReg($50,20)													' page bank 20 to $8000, slot 7 
PalUpload($0400,64,0)											' upload the palette 
CopyToBanks(20,10,1,1024)										' copy bank 20 > 2 with 1 bank of length 1024 bytes 
NextReg($50,$ff)
ClearTilemap() 
'RollOut()

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
    ld hl,TILE_BUFFER
    ld de,TILE_BUFFER+1
    ld (hl),0
    ld bc,2559
    ldir
end asm 
dim ArrayStr as string = ""

' -------------------------------------------------------------
' -- TEST AREA 
' -------------------------------------------------------------

' DrawRownDown()

' -------------------------------------------------------------
' -- Draw Start Panels 
' -------------------------------------------------------------

' SetPlotInk(128)
Draw_Box(@panel1)
Draw_Box(@trackerwindow)
Draw_Button(@buttonOK)
Show_Row(position,pattern)
'Draw_Button(@button2)
'Draw_Button(@button3)

' for x = 0 to 15 
' TextLine(2,x+1,"TEST",x)
' next 
Get_Position(position)
'colour_pattern()
TextPatternUpdate()
Read_Dir_Entries()
'RollIn()

' -------------------------------------------------------------
' -- Main Loop 
' -------------------------------------------------------------


do
    
    Update_Mouse()
    WaitRetrace2(200)
    ReadKeys()
    PlaySong()

	t = t + 1 
    TextNumber(0,0,t)
    if map_value = 16     ' play
        play = 1 
        PlayMod()
    elseif map_value  =  17   ' stop 

        play = 0 

   
    elseif map_value  =  20   ' clear 
        Clear_Info_Area()
        Draw_Box(@middle_panel)
        diskop_on = 0
    elseif map_value  =  24   ' sampler
        Clear_Info_Area()
        Draw_Box(@middle_panel)
        Draw_Box(@panelsampler)
        DrawSample()
        diskop_on = 0
    elseif map_value  =  22   ' diskop
        Clear_Info_Area()
        Draw_Box(@middle_panel)
        Draw_Box(@paneldiskopback)
        Draw_Button(@paneldiskop)
        Show_Dir_Entries(file_position)
        LoadMod()
        
        diskop_on = 1 
    endif 

    if diskop_on = 1
        tx = mx 
        ty = my 
        if click = 1
            if ty > 4 and ty < 14 
                if tx > 6 and tx < 63
                  
                endif 
            endif 
        endif 
    endif 

loop 

border pen_color

ArrayStr = common$ 

' -------------------------------------------------------------
' -- Sub Routines  
' -------------------------------------------------------------

sub Clear_Info_Area()
    asm 

        ld      hl,09+(6*160)+$4400
        ld      d, h 
        ld      e, l 
        inc     de 
        ld      (hl),0
        ld      bc, 160*8
        ldir 
   
        ld      hl,TILE_BUFFER+(5*80)
        ld      d, h 
        ld      e, l 
        inc     de 
        ld      (hl),0
        ld      bc, 80*7
        ldir 
    end asm 

end sub 

sub Show_Dir_Entries(counter as ubyte)
    dim x   as ubyte 

    for x = 0 to 6 
        GetElement(@Array1,x+counter)
        TextLine(7,7+x,"                                        ",0)
        TextLine(5,7+x,ArrayStr,2)
    next 
    counter = counter + 1 

end sub 

sub PlayMod()

    asm 
        nextreg MMU4_8000_NR_54,BANK8K_FINETUNE

      ; BREAK 
      ;  exx 
      ;  push hl : push de : push bc
      ;  push af 
      ;  exx 
      ;  ex af,af'
      ;  push hl : push de : push bc : push iy : push ix 
      ;  push af 
        
        BREAK
    ;    ld      ix,mod_name
    ;    call    $9600
        ; BREAK 
        nextreg MMU6_C000_NR_56,21
        nextreg MMU7_E000_NR_57,22
        ld      sp, $bffe 
        call    startup               ; mod loader in bank 21

;        ld 		hl, mod_data_cache			; F900 - 1488 bytes for embedded tunes 
;        ld 		de, mod_patterns			; along with sample + pattern data
;        ld 		bc, 1488					; copy tesko.mod's data in place 
;        ldir 	
       
        call 	load_test_mod				; we play an embedded tune 

      ;  call    $9609
        jp      $
     ;   BREAK

        ;  ld      sp, 0000
        nextreg MMU4_8000_NR_54,4
       ; nextreg MMU2_4000_NR_52,10
        nextreg MMU3_6000_NR_53,11
        nextreg MMU7_E000_NR_57,1

        pop af 
        pop ix : pop iy : pop bc : pop de : pop hl 
        exx 
        ex af, af'
        pop af 
        pop bc : pop de : pop hl 
        exx 
    end asm 
end sub 

sub Read_Dir_Entries()

    asm 

        f_opendir       EQU         $a3
        f_readdir       EQU         $a4 
        f_telldir       EQU         $a5
        f_seekdir       EQU         $a6
        f_rewinddir     EQU         $a7

        push    ix 
         
        ld      a, '*'                  ; deafult drive specifier 
        ld      b, $10                  ; lfn only
        ld      ix,__direcotory_name    ; directory to open 
        ESXDOS
        db      f_opendir
        
        ld      (_dir_handle),a         ; write dir handle - 0 if error 
        or      a 
        jr      z,._exit_show_dir       ; error with file handle 
        jp      c,._exit_show_dir       ; unable to open dir 

        ; lets rewind the dir 

        ld      a, (_dir_handle)        ; get back dir handle 
        ESXDOS  : db f_rewinddir        ; rewind to start of directory 

        ; read an entry 
    _read_filename_entry:
        ld      a, (_dir_handle)        ; ensure handle is set 
        ld      ix, _dir_buffer         ; point to buffer        

        ESXDOS  : db f_readdir          ; read from SD card
        jr      c, _exit_show_dir       ; error so just exit 
        or      a 
        jr      z, _exit_show_dir

        jp      _get_full_dir_to_array  ; read the rest of the entries 
        
    _exit_show_dir:

        ld      a, (_dir_handle)        ; ensure handle is set 
        ESXDOS : db F_CLOSE 

        pop     ix                      ; exit clean up 
        jp      ._Read_Dir_Entries__leave        ; jump to end of sub 

    _dir_check_max:

    _get_full_dir_to_array:
        ld      de, _dir_buffer+1       ; point to fname buffer 
        
        call    _get_length             ; get lenth and store in array_str_length
        ld      a, 19                   ; array bank 
        ld      bc, (test_count)        ; get LSB of loop into c 
        call    _put_array              ; put the filename into ram 

        ld      a, (_dir_handle)        ; ensure handle is set 
        ld      ix, _dir_buffer         ; point to buffer 
        ESXDOS  : db f_readdir          ; read from SD card 
        or      a
        jr      z,._no_more_entries 

        ld      hl, test_count
        inc     (hl)

        jr      _get_full_dir_to_array 

    _no_more_entries:
        ld      a, (test_count) 
        ld      (._max_positions),a       

        jp      ._exit_show_dir         ; exit sub routine 

    _get_length:
        push    de                  ; save position in RAM 
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
        db      0                       ; handle for directory 
    _last_position:
        db      0,0,0,0
    CUR_XY:
        dw      0 
        dw      0 
    _dir_buffer:
        ds      256, 0                   ; buffer for dir attributes 


    end asm 

end sub 

sub fastcall PeekMemLen(address as uinteger,length as uinteger,byref outstring as string)
    ' assign a string from a memory block with a set length 
    asm 

        ex      de, hl 
        pop     hl 
        pop     bc
        ex      (sp),hl         
        ;' de string ram 
        ;' hl source data 
        ;' now copy to string temp
        
        push    hl 
        ex      de, hl 
        ld      (stringtemp),bc 
        ld      de,stringtemp+2
        ldir 

        pop     hl 
        ld      de,stringtemp
        ; de = string data 
        ; hl = string 
        jp      .core.__STORE_STR

    end asm 

end sub 

sub GetModSongName()

    NextReg(MMU0_0000_NR_50,21)

    asm 
        ld      b, 20           ; 20chars

        ld      hl, $139B       ; song name from header in modeng.bin
        ld      de, $4cee       ; song name on screen 
    1:
        ldi                     ; copy from song to screen
        inc     de              ; skip attribyte
        djnz    1B

    end asm 

    NextReg(MMU0_0000_NR_50,$FF)

end sub 

sub LoadMod()
    asm 
        di
        
        nextreg MMU4_8000_NR_54,4
        nextreg MMU6_C000_NR_56,21
        nextreg MMU7_E000_NR_57,22
      ;  ld      (mod_load_sp+1), sp 
      ;  ld      sp, $BFFE
       
        exx 
        push hl : push de : push bc
        push af 
        exx : ex af,af'
        push hl : push de : push bc : push iy : push ix 
        push af 
        ld      ix, mod_name 
    BREAK 
        call    startup
    mod_load_sp:
      

      ;  ld      sp, 0000
        nextreg MMU2_4000_NR_52,10
        nextreg MMU6_C000_NR_56,0
        nextreg MMU7_E000_NR_57,1

        pop af 
        pop ix : pop iy : pop bc : pop de : pop hl 
        exx : ex af, af'
        pop af 
        pop bc : pop de : pop hl 
        exx 

         
    end asm 
   
    GetModSongName()
    position = 0 
    Show_Row(0,0)

end sub 

sub DrawSample()
    
    for x = 0 to 255
        FPlotL2(20*4,x+17,28)
    next 

end sub 


sub PlaySong()
    if t >= 4 and play = 1 
    row = row + 1 
    if row = 64
        position = position + 1 
        if position=slen 
            position=0 
        endif 
        Get_Position(position)
        TextPatternUpdate()
        row = 0 
    endif 
    Show_Row(row,position)
    ' TextLine(0,18,"Pattern  : " +str(pattern)+" ",0)
    'TextLine(0,19,"Position : " +str(position)+" "+str(slen)+" ",0)
    t = 0 
    endif 
end sub 

sub ReadKeys()

    k = GetKeyScanCode()

    if keydown = 0 and k = KEYA
		t = 0 
        row = (row + 1) band 63
        Show_Row(row,pattern)
        keydown = 1 

    elseif keydown = 0 and k = KEYQ 

        row = row - 1 band 63 
        Show_Row(row,pattern)
        keydown = 1 

	elseif keydown = 0 and k = KEYSPACE 
		row = 0 
		Show_Row(row,pattern)
		play = 1 - play 
		keydown = 1 
    elseif k = 0 

        keydown = 0 

    endif 

end sub 

sub Update_Mouse()
    
    dim mbutt   as ubyte

    Process_Mouse()

    mx = cast(uinteger,(peek (@Mouse+1)))<<1
    
    if mx > 319
        mx = 319
    endif 

    my = peek(@Mouse+3)
	mbutt=peek(@Mouse) band 15 

    UpdateSprite(cast(uinteger,mx),my,0,16,0,0)

    mx = (mx) >> 2
    my = my >> 3 

    map_value = 0 
    TextNumber(70,22,mx)
    TextNumber(74,22,my)

    TextNumber(70,24,mbutt)
    
    TextNumber(70,25,peek(@Mouse))
    

    if (mbutt = LeftButton or mbutt = BothButton) and click = 0 
        
        map_value = peek(TILE_BUFFER+cast(uinteger,mx)+cast(uinteger,my)*80)
        

        if map_value > 0 
            TextLine(70,26,str(map_value),13)
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
        TextLine(70,27,"---",13)
        click = 0 
        TextLine(70,27,"       ",4)
    elseif (mbutt = NoButton or mbutt = BothButton) and click = 1
        if peek(TILE_BUFFER+cast(uinteger,mx)+cast(uinteger,my)*80) = last_id
            ' the mouse is still over the button we clicked on
            ' now call the relevant command 
            Process_Button(last_id)
            if dclick = 1
                TextLine(70,27,"Doub cl",4)
            else 
                TextLine(70,27,"Clicked",4)
            endif 
         
        endif 
        click = 2 
    endif 
    
end sub 

sub Process_Button(byval in_id as ubyte)

    dim     addvalue    as ubyte 

    if dclick > 0 
        addvalue = 10 
    else 
        addvalue = 1
    endif 

    if in_id = 1 
        ' increase pattern position 
        if position<slen+addvalue
        position=position+addvalue
        TextPatternUpdate()
        end if 
    elseif in_id=2 
        ' decrease pattern position 
        if position>addvalue-1
            position=position-addvalue
            TextPatternUpdate()
        endif
    elseif in_id=29
        ' move up a position 
        if file_position<max_positions-6
            file_position=file_position+1
            Show_Dir_Entries(file_position)   
        endif 
    elseif in_id=28  
        ' move down a position 
        if file_position>0
            file_position=file_position-1
            Show_Dir_Entries(file_position)   
        endif 
    endif 

end sub 

sub TextPatternUpdate()
    Get_Position(position)
    TextLine(17,2,hex16(position),14)
    TextLine(17,3,hex16(pattern),14)
    TextLine(17,4,hex16(slen),14)
    Show_Row(0,position)
end sub 

sub Draw_Box(byval Draw_Box_data as uinteger)

    ' SetPlotInk(128)
    dim     add         as uinteger 
    dim     y3, type    as ubyte 
    dim     top_colour  as ubyte 
    dim     bot_colour  as ubyte 

    add = Draw_Box_data      ' seek address of panel data 

    do
        x1 = peek(ubyte, add+1)       ' x 
        if x1 = $ff : exit do : endif 
        
        if peek(ubyte,add)>0
            x1=x1+256
        endif 
        
        y1 = peek(ubyte, add+2) +1    ' y 
        x2 = peek(ubyte, add+3)     ' width 

        if x2 >160 : exit do : endif    ' if x2*2 > 320 then exit panel routine 

        y2 = peek(ubyte, add+4)-1   ' height 
        co = peek(ubyte, add+6)     ' colour 
        
        type = peek(ubyte, add+5)   ' 0 raised, 1 lowered, 16+ button ID

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
        elseif type = 5
            top_colour = co 
            bot_colour = co 
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
        add = add + 7               ' size of each panel datablock 

    loop 

end sub 


' -------------------------------------------------------------
' -- GUI Panel Data 
' -------------------------------------------------------------


panel1:
asm 
    ;  x    y  w/2  h        black back ground 
    db 0,0, 0, 160, 0, 0, 0 
end asm 

trackerwindow:
asm 
    ;  x    y       w/2     h         t  colour 
 ;   db 4    ,8      ,160-4  ,255-8 , 0, 4            ; main full screen back panel
        ;  x    y       w/2     h         t  colour 
    db 0,4    ,4      ,160-4  ,255-8 , 0, 3            ; main full screen back panel

   db 0,15   ,127    ,16    ,120     , 1, 7            ; tracker window 
   db 0,34   ,127    ,31   ,120     , 1, 7            ; middle button lowered
   db 0,92   ,127    ,31   ,120     , 1, 7            ; middle button lowered
   db 0,148   ,127    ,31   ,120     , 1, 7            ; middle button lowered
   db 0,204   ,127    ,29   ,120     , 1, 7            ; middle button lowered

   ; right hand panel next to tracker window

   db 1,10   ,127    ,(2*8)+7   ,120     , 1, 9

    ;   db $0,$0,$0,$0, 0,0
    db $ff,$ff,$ff,$ff, 146

end asm 

middle_panel:
asm 
    ;  x    y       w/2     h         t  colour 
    db 0,5,(8*6)-1  ,(20*8)-6  ,8*8 , 5, 3            ; main full screen back panel
    
    ;   db $0,$0,$0,$0, 0,0
    db $ff,$ff,$ff,$ff, 146

end asm 
panelsampler:
asm 
    db 0,BASE_X+15    ,(6 *8)-1    , 16*8, 8*8, 1, 7
    db $ff,$ff,$ff,$ff, 146
end asm 


paneldiskopback:
asm 
    db 0,BASE_X+16    ,(6 *8)-1    , 15*8, 8*8, 1, 7
    db $ff,$ff,$ff,$ff, $ff
end asm 

paneldiskop:
asm 
    ;   x   y   t   col id 
    db 4,   6,  4,  2,  0
    db "  DIRECTORY : ____________________," ,0
    ; 
    db BASE_X+1,   9,  0,  0,  28      ; up arrow 
    db 5,"," ,0
    db BASE_X+1,   10,  0,  0,  29
    db 6,"," ,0

    db "       ," ,$FF
   ; db BASE_X+4,   5,  160-10,  10,  0
   db $ff,$ff,$ff,$ff, $ff
   db $ff,$ff, $ff

end asm 

sub Draw_Button(Buttond_data as uinteger)

    ' draws button and text 

    dim width   as ubyte 
    dim bx      as ubyte 
    dim by      as uinteger 
    dim tlen    as uinteger 
    dim col     as ubyte 
    dim type    as ubyte 
    dim id      as ubyte 

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

        ' if  type = 4 
        '     width = 123
        ' else 
        
             width   = cast(ubyte, tlen *2) +1    ' txt len * 8 + 2 

        ' endif 

        poke    add2+1, (bx <<2)-1      ' x + 1 as its a WORD
        poke    add2+2,(by <<3)-1       ' y 
        poke    add2+3, width           ' width 
        poke    add2+4, 8               ' height 
        poke    add2+5, type            ' type 
        poke    add2+6, 4               ' colour 

        Draw_Box(@buttontmp)

        TextLine(bx,by,tempstr,col)

        poke uinteger @objectbuffer+Cast(uinteger,id<<1), add

        if  id > 0 
            y = by * 80 
            for x = bx to bx+tlen 
                poke TILE_BUFFER+cast(uinteger,x)+cast(uinteger,y),id 
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
    dim type    as ubyte 
    dim id      as ubyte
    dim tlena   as ubyte 

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

        poke    add2+1, (bx <<2)-1              ' x pos
        poke    add2+2,(by <<3)-1               ' y pos 
        poke    add2+3, width                   ' width 
        poke    add2+4, 8                       ' height 
        
        if type = 4 
            mode = 4
        endif 
        
        poke    add2+5, mode 
         if mode < 4 
             poke    add2+6, 4
         else 
             poke    add2+6, 3
         endif 

        Draw_Box(@buttontmp)


end sub 



sub GetElement(memory_pointer as uinteger,string_position as ubyte)
    ' expects a pointer to the Array to use and position to get the element
    ' this routine will set ArrayStr$ to the element string on exit 
    ' 
    asm 
         
        ; on entry 
        ; (ix+4/5)= memory pointer 
        ; 6/7 = string position 
        ; BREAK 
        ld      l, (ix+4)                   ; array memory address of array
        ld      h, (ix+5)
        
        ld      c, (hl)                      ; get desired start bank eg 24 

        ld      a, (ix+7)                   ; get element number 
        call    _get_element
        jp      ._GetElement__leave 

_get_element: 
        swapnib                             ; 0000xxxx > xxxx0000
        and     %0001111                    ; xxxx0000
        srl     a 
        srl     a
        add     a, a 
        add     a, c                        ; add to start bank eg 24 + 

        nextreg MMU0_0000_NR_50, a           ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a           ; set next bank 
        
        ld      a,(ix+7)                    ; get element again 
        and     63                          ; ensure it wraps around 
        ld      h, a                        ; our banks 
        ld      l, 0                        ; start 

        
        ld      a, (hl)                     ; is it enable?
        or      a 
        jp      nz,garray_not_null           ; not enable exit - maybe send empty string
        ld      hl, garry_empty_arraystr
        jp      gempty_array_position

garray_not_null:
        inc     hl                          ; skip over enable byte 
        inc     hl                          ; skip over var bytes
        inc     hl                          ; skip over var bytes

        ; hl = source string 

    gempty_array_position: 

        ld      de, ._ArrayStr              ; point to ArrayStr$ pointer
        ex      de, hl                      ; swap 
        call    .core.__STORE_STR           ; store in ArrayStr$
        ; hl should be the exit string pointer 

        nextreg MMU0_0000_NR_50, $ff        ; return rom banks 
        nextreg MMU1_2000_NR_51, $ff 

        jr      _GetElement__leave

    garry_empty_arraystr:
        db      0, 0,"",0

    garray_str_position:
        dw      0000 
    garray_str_pointer:
        dw      0000 

    end asm 

end sub 

sub PutElement(memory_pointer as uinteger,array_string as string,string_position as uinteger) 

    asm 
         
        ; on entry 
        ; ix+4/5)   = memory pointer 
        ; 6/7       = array string 
        ; 8/9       = string position 
        ; h         = element 
     
        ld      l, (ix+6)                   ; get string in memory, 2 bytes = length 
        ld      h, (ix+7)
        push    hl 
        ld      e, (ix+4)                   ; fetch the pointer for the array config 
        ld      d, (ix+5)
        ld      c, (ix+8)                    ; get element offset 
        ld      a,(hl)
        inc     hl 
        ld      h,(hl)
        ld      l, a 
        ld      (array_str_length), hl      ; store string length to array_str_length
 
        ld      a, (de)
       
        call    _put_array
        jp      ._PutElement__leave 

_put_array:
        push    de                          ; push this to stack 
        ld      h, a
        ; now we get the bank from the pointer array 
         
        ld      a, c 
        swapnib                             ; 0000xxxx > xxxx0000
        and     %00001111                   ; xxxx0000
        srl     a 
        srl     a 
        add     a, a                        ; x 2 because we're using 2 banks 
        add     a, h 

        nextreg MMU0_0000_NR_50, a          ; set bank 
        inc     a 
        nextreg MMU1_2000_NR_51, a          ; set next bank 
        
        ld      a,c                         ; get element again 
        and     63                          ; ensure it wraps around 
        ld      h, a                        ; our banks 

        ; add the string at string_position 

        ld      l, 0                        ; start of data

        ld      (hl), 1                     ; element enable 
        inc     hl 
        inc     hl                          ; two var bytes 
        inc     hl 

        ld      bc,(array_str_length)       ; get the length of the string 
        ld      (hl),c 
        inc     hl 
        ld      (hl),b 
        inc     hl 
        inc     bc 
        inc     bc                          ; add 2 to include size when copying 
        ld      b, 0                        ; cap to 256 max
        pop     de 
        ; ld      e, (ix+6)                   ; get array pointer address  [SIZE][STRING.....]
        ; ld      d, (ix+7)
        ex      de, hl                      ; exchange array with string pointers

        ldir                                ; copy string 

        nextreg MMU0_0000_NR_50,$ff
        nextreg MMU1_2000_NR_51,$ff         ; restore bank 
        ret 

    end asm 

    asm 
        ; not all are used 
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

    end asm 

end sub 



sub fastcall ClearArray(array_as as uinteger)

    asm 
         

        ld      b, 4            ; 4 loops 
        ld      a, (hl)
.clear_arry_loop:
        push    bc 
        push    af 
        nextreg MMU0_0000_NR_50, a 
        inc     a 
        nextreg MMU1_2000_NR_51, a 
        ld      hl, 0 
        ld      (hl), 0 
        ld      de, 1 
        ld      bc, $4000 
        ldir 
        pop     af 
        inc     a 
        inc     a 
        pop     bc 
        djnz    .clear_arry_loop

        nextreg MMU0_0000_NR_50, $ff 
        nextreg MMU1_2000_NR_51, $ff 
    end asm 

end sub 

Array1:
    asm 
        ; this is array number 1
        asm_array1:
        ; start bank, map address 
        db      19     ; banks 24 + 8 * 8192kb = 65536kb
        dw      $0000

    end asm 


' // ---------------------------------------------
' // -- GUI button data --------------------------
' // ---------------------------------------------

objectbuffer:
asm     
        ds 128,0        ; room for 64 2 bytes each 
end asm 

buttontmp: 
asm
    ;     x  y  t  c  id 
    db  0,0, 0, 0, 0, 0,0
    db  $ff,$ff, $ff,$ff,$ff
end asm 

buttonOK:
asm 
    BASE_X equ 1
    ;   x          y   t   col id 
    db BASE_X+3,   2,  0,  1,  0
    db "POSITION   ," ,0
    db BASE_X+3,   3,  0,  1,  0
    db "PATTERN    ," ,0
    db BASE_X+3,   4,  0,  1,  0
    db "LENGTH     ," ,0
    db BASE_X+3,   5,  0,  1,  0
    db "SAMPLE     ," ,0
end asm 

text_status:
asm 
    ;   x   y    t   col id 
    db 4,   14,  4,  2,  0
    db "        SONG NAME ," ,0

    db 23,   14,  4,  2,  25
    db "____________________," ,0

    db 4,   15,  4,  2,  0
    db "      SAMPLE NAME ," ,0

    db 23,   15,  4,  2,  26
    db "____________________," ,0

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

PutElement(0,"",0)
GetElement(0,0)

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


' Going to need a pattern buffer? 
asm 
pattern_buffer:
end asm 
' asm 
'     pattern0:
'     incbin "./data/finetune2.dat"
' end asm 
asm 
__direcotory_name:
    db "c:",0
    ds 32,0
asm 
mod_name:
    db "test.mod",0
end asm 

#include "tilemapetext-inc.bas"
#include "mouse-inc.bas"