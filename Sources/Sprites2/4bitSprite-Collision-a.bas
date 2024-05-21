'!ORG=24576
'!heap=2048
'!copy=h:4bit.nex
'!opt=5

asm : di : end asm 
									' These must be set before including the nextlib
#define NEX 						' If we want to produce a file NEX, LoadSDBank commands will be disabled and all data included

#include <nextlib.bas>				' now include the nextlib library
#include <keys.bas>					' we are using GetKeyScanCode, inkey$ is not recommened when using our own IM routine
									' (infact any ROM routine that may requires sysvars etc should be avoided)
#include <hex.bas>

LoadSDBank("256x128-r.spr",0,0,0,34)
'LoadSDBank("test.spr",0,0,0,34)

asm 
    nextreg $56,34
    nextreg $57,35
    nextreg TURBO_CONTROL_NR_07,3
    nextreg PALETTE_CONTROL_NR_43,%00100000
    nextreg SPRITE_CONTROL_NR_15,%00000011
end asm 

PalUpload(@spritepal,64,0)
InitSprites2(64,$c000,24)
dim sprites(128,8)      as ubyte                        ' define an array 128 sprites with 8 elements

asm 
    nextreg $56,00
    nextreg $57,01
    nextreg PERIPHERAL_4_NR_09,%1<<4
end asm 


dim y,spriteflag,im,flags as ubyte
dim tmpspradd   as uinteger = 0 
dim x           as uinteger
dim p           as ubyte 
dim tx          as uinteger
dim ty          as ubyte 
dim sp          as ubyte 
dim id          as ubyte 
dim di          as ubyte 
dim dd          as ubyte 
dim ve          as ubyte 
dim spr          as ubyte 

' rough idead of content for the elements 
' 0                1       2  3       4   5     6 
' enable & x MSB,  x LSB,  y, sprite, id, dir, speed  

' set up random sprites 

for x = 0 to 127 
    
    sprites(x,0)     = 1<<7        ' bit 7 to enable sprite 
    sprites(x,1)     = int(rnd*230)
    sprites(x,2)     = int(rnd*191)
    sprites(x,3)     = x 
    sprites(x,4)     = x 
    sprites(x,5)     = 1+int(rnd*1)   ' 0 right 1 up 2 left 3 down 
    sprites(x,6)     = 1+int(rnd*4)   ' 
    sprites(x,7)     = 1+int(rnd*1)   ' 
next 




ink 7 : paper 0 : cls 

' %10 = 4-bit colour pattern (128 bytes) using bytes 0..127 of pattern slot, this sprite is "anchor"
' %11 = 4-bit colour pattern (128 bytes) using bytes 128..255 of pattern slot, this sprite is "anchor"

spriteflag = 128


do 
    border 2 
    update_all_sprites()
    border 0 
    WaitRetrace2(200)

loop 

sub update_all_sprites()

    dim add         as uinteger
    
    add = @sprites                   ' point address to start of array 

    for spr = 0 to 127
        
        tx = peek(add) 
    ' asm 
        
    '         ld 		hl,._sprites.__DATA__						; ' Start of sprite date 
    '         ld 		a,(._spr)
    '         ld 		d,a 
    '         ld 		e,9
    '         mul 	d,e 
    '         add 	hl,de 	
            
    '         ld      a, (hl) : ld (._tx), a : inc hl 
    '         ld      a, (hl) : ld (._tx+1), a : inc hl 
    '         ld      a, (hl) : ld (._ty), a : inc hl 
    '         ld      a, (hl) : ld (._sp), a : inc hl 
    '         ld      a, (hl) : ld (._id), a : inc hl 
    '         ld      a, (hl) : ld (._di), a : inc hl 
    '         ld      a, (hl) : ld (._ve), a : inc hl 
    '         ld      a, (hl) : ld (._dd), a : inc hl 
    ' end asm 
        ' print str(add)
        ' print @sprites   
        
        if  cast(ubyte,tx) band 192 > 0                                 ' is the sprite enable?

            tx = peek (add+1)                               ' get the LSB for x 
            ty = peek(add+2)                                ' get y 
            sp = peek(add+3)                                ' get sprite 
            id = peek(add+4)                                ' get the image id
            di = peek(add+5)                                ' direction 
            ve = peek(add+6)                                ' speed 
            dd = peek(add+7)                                ' speed 

            if di = 0                                           ' going right
                tx = tx + ve
                if tx > 250 
                    di = 1
                    tx = tx - ve
                endif  
            elseif di = 1                                       ' goint left
                tx = tx - ve
                if tx >250                                      ' wrap below 0 so we can check if its rolled
                    di = 0
                    tx = tx + ve
                endif    
            endif            

            if dd = 0                                           ' going up 
                ty = ty - ve 
                if ty > 250 
                    dd = 1
                    ty = ty + ve 
                endif 
            elseif dd = 1                                       ' going down 
                ty = ty + ve
                if ty > 190
                    ty = ty - ve 
                    dd = 0
                endif 
            endif 
            ' asm 
                
            '     ld      a, (._id)
            '     ld      h, %10000000
            '     and     1 
            '     jr      z, 1F               ; its zero so skip
            '     ; else
            '     ld      h, %11000000
            ' 1:  or      h 
            '     ld      (._spriteflag), a 
            ' end asm 

            spriteflag = 128 bor ( ((id band 1)<<6))        


            UpdateSprite(cast(uinteger,tx)+32,cast(uinteger,(ty+32)),spr,0,0,spriteflag)
            
             
            ' asm 
            '     ld      l, (ix-2)
            '     ld      h, (ix-1)
            '     inc     hl 
            '     ld      a, (hl)
            '     inc     hl 
            '     ld      (._tx), a 
            '     inc     hl 
            '     ld      a, (hl)
            '     ld      (._ty), a 
            '     inc     hl 
            '     inc     hl 
            '     inc     hl 
            '     ld      a, (hl)
            '     ld      (._di), a 
            '     inc     hl 
            '     inc     hl 
            '     ld      a, (hl)
            '     ld      (._dd), a 

            ' end asm 
            poke add+1, tx                                  ' store new x
            poke add+2, ty                                  ' store new y
            poke add+5, di                                  ' store new direction  
            poke add+7, dd                                  ' store new direction  

        endif 
        
        add = add + 9
        ' tx = tx band 1 + peek (add+1)                   ' get the MSB and LSD for x 

        
    next spr

    while inkey$<>"" : wend 
end sub 

print at 18,0;"128 SPRITES"

WaitKey() : while inkey$<>"" : wend 

sp = 0 : im = 0 : p = 0 

do 
    
    Print at 12,0;"Moving Sprite ";sp;"  "
    Print at 13,0;"      Pattern ";im;"  "
    Print at 14,0;"ActualPattern ";im>>1;"  "
    Print at 15,0;"  Attribute 2 ";BinToString(p<<4);"  "
    Print at 16,0;"  Attribute 5 ";BinToString(spriteflag);"  "

    y = (rnd*16)*16

    for x = 0 to 255 step 10
        spriteflag = 128 bor ( ((im band 1)<<6) bor %01010)               ' im = %1000000 BOR %00000000 or %01000000
        UpdateSprite(cast(uinteger,x)+32,y,sp,im>>1,p << 4,spriteflag)
        WaitRetrace(1)
    next 

    p = (p + 1 ) band 7

    sp = (sp + 1) band 127 
    im = (im + 1) band 127

   WaitKey(): while inkey$<>"" : wend 

loop 

spritepal:
asm 
   db $00, $00, $50, $01, $A4, $01, $D1, $00, $2E, $00, $BD, $01, $64, $01, $DB, $00 
   db $8C, $01, $7A, $00, $B6, $01, $69, $00, $72, $01, $F9, $01 ,$E9, $00, $FF ,$00 

  db $00, $00, $19, $01, $49, $00, $61, $01, $0E, $01, $65, $00, $81, $00, $9A, $00
  db $95, $00, $D0, $00, $09, $01, $9D, $01, $32, $00, $F8, $00, $E0, $00, $FF, $ff 
end asm 


