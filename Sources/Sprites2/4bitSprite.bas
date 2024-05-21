'!ORG=24576
'!heap=2048
'!copy=h:4bit.nex
'!opt=2

asm : di : end asm 
									' These must be set before including the nextlib
#define NEX 						' If we want to produce a file NEX, LoadSDBank commands will be disabled and all data included

#include <nextlib.bas>				' now include the nextlib library
#include <keys.bas>					' we are using GetKeyScanCode, inkey$ is not recommened when using our own IM routine
									' (infact any ROM routine that may requires sysvars etc should be avoided)
#include <hex.bas>

LoadSDBank("256x128-r.spr",0,0,0,34)

asm 
    nextreg $56,34
    nextreg $57,35
    nextreg PALETTE_CONTROL_NR_43,%00100000
    nextreg SPRITE_CONTROL_NR_15,%00000011
end asm 

PalUpload(@spritepal,64,0)
InitSprites2(64,$c000,24)

asm 
    nextreg $56,00
    nextreg $57,01
    nextreg PERIPHERAL_4_NR_09,%1<<4
end asm 

dim sp,y,spriteflag,im,flags as ubyte
dim x as uinteger
dim p as ubyte 

ink 7 : paper 0 : cls 

' %10 = 4-bit colour pattern (128 bytes) using bytes 0..127 of pattern slot, this sprite is "anchor"
' %11 = 4-bit colour pattern (128 bytes) using bytes 128..255 of pattern slot, this sprite is "anchor"

spriteflag = 128

for y = 0 to 7
    for x = 0 to 15
        
        ' to draw 4 bit sprites, attribute 4 must have bit 7 and 6 set depending on the 
        ' sprite you want to address. 
        ' bit 7 set will address the first 0-127 bytes of an image 
        ' bit 7 & 6 will address the second 128-255 bytes of an image 
        ' 
        spriteflag = 128 bor ( ((im band 1)<<6) )
        ' lets step through the palettes, we need bites 7-4
        ' so shift it by 4 
        
        UpdateSprite(cast(uinteger,x<<4)+32,y<<4,sp,im>>1,p<<4,spriteflag)
        sp = sp + 1 
        im = im + 1 
        p = (p + 1 ) band 7

        Print at 12,0;"Moving Sprite ";sp;"  "
        Print at 13,0;"      Pattern ";im;"  "
        Print at 14,0;"ActualPattern ";im>>1;"  "
        Print at 15,0;"  Attribute 2 ";BinToString(p<<4);"  "
        Print at 16,0;"  Attribute 5 ";BinToString(spriteflag);"  "

        'WaitKey(): while inkey$<>"" : wend 
        
    next x 
    
next y 

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


