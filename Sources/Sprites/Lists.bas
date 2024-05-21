'!ORG=32768
' Event Sprite Engine 
' Part of NextBuild 
'#
' This code will manage a list of sprites and move according to defined simple movement scripts
'

#include <nextlib.bas>                                          ' inlcude the nextlib 
#INCLUDE <keys.bas>

declare function getNextElement(listaddress as uinteger) as UINTEGER
declare function addElement(listaddress as ubyte,x as ubyte ,y as ubyte) as ubyte 
declare function deleteElement(elementid as ubyte) as ubyte 
declare function getElement(elementid as ubyte) as UINTEGER
declare function resetList(elementid as UINTEGER) as UBYTE 

asm
    nextreg SPRITE_CONTROL_NR_15,%00001011                     	; ' Enable sprite visibility & Sprite ULA L2 order 
    nextreg TURBO_CONTROL_NR_07,3                               ; 28 mhz 
end asm

dim a,base as UINTEGER
dim lista as uinteger at $c000
dim item as ubyte 
for x = 0 to 512 : poke $c000+x,0 : next x 

Poke(@lista,0 )
InitSprites(1,@Sprites) 
print addElement(@lista,5,6)
print addElement(@lista,2,3)
print addElement(@lista,7,9)
print addElement(@lista,10,12)   ' 4
for x = 0 to 15 
print addElement(@lista,x,x)
next x 

do 
    if GetKeyScanCode()=KEYSPACE 
        item = cast(ubyte,rnd*10)
        base = getElement(item)
        print at 20,5;item;"   ";peek(base+1);"   ";peek(base+2);"   " 
        pause 0 
    endif 
    if GetKeyScanCode()=KEY1
        item = 10
        base = deleteElement(item)
        addElement(@lista,64,64)
        resetList(@lista) : cls 
        for x = 0 to 31 
            base = getNextElement(@lista) 
            print peek(base+1);"   ";peek(base+2);"   " 
        next 
        pause 10
    endif 
loop 

do 
    border 2
    base = getNextElement(@lista) 
    print at 0,0;peek(base+1);"   ";peek(base+2);"   " 
    border 0 
    pause 0
loop 

function fastcall deleteElement(elementid as ubyte)
    asm 
        BREAK 
        ; a = id 
        ld e,a 
        ld d,16
        mul d,e 
        ld hl,$c010                 ; start at data
        add hl,de
        xor a
        ld (hl),a 
    end asm 
end function 

function fastcall getNextElement(listaddress as UINTEGER) as UINTEGER

    asm 
        ;BREAK 
        ; hl = list address 
        ; 'ld hl,lista              ; ' point to lista
        ;BREAK 
        ;push hl                     ; ' save list start
        inc hl 
        ld e,(hl)                   ; ' get next control byte, how long is list 
        inc hl 
        ld a,(hl)                   ; de has current position at start 
        and $1 
        ld d,a 
        ld b,32
        ld hl,$c000
        add hl,de 
    noreset:         
        add hl,16
        ; hl = current position, de start of list data 
        ; xxxxxxxStart>>>>>>END 
    getloop:
        ld a,(hl) : or a : jr nz,enabled                   ; is the item enable?
        add hl,16 : ld a,h : cp 1 : jr c,endoflista            ; have we reach 512?
        dec b
        jr z,done
        

        ; We reach end now >>>>>>>ENDxxxxxx
    endoflista:
        ld hl,$c000 : add hl,16
        jr getloop 
        
    done:
        ;BREAK 
        ret 

    enabled: 
        ;BREAK 
        ld a,h : and %1 : ld d,a : ld e,l 
        ld ($c001),hl
        ret 
        
    end asm 
end function 

function fastcall resetList(elementid as UINTEGER)

    asm 
        ;BREAK 
        ; hl = address of list 
        ld de,00 
        ld ($c000),de 
        ret 
    end asm 
end function 

function fastcall getElement(elementid as ubyte) as UINTEGER

    asm 
        ;BREAK 
        ; a = id 
        ;dec a : jr nz,setfirstelement
        ld e,a 
        ld d,16
        mul d,e 
        ld hl,$c010                 ; start at data
        add hl,de
        ret 
    setfirstelement:
        ld a,1 
        ret 
    end asm 
end function 

function fastcall addElement(listaddress as ubyte,x as ubyte ,y as ubyte) as ubyte 

    asm 
        exx : pop hl : exx
        ; hl now at last list entry 
        ld hl,$c000 : ld b,0
    addloop:
        inc b                           ; return value 
        add hl,16 : push hl : ld de,512: sbc hl,de : pop hl : jr c,nonavailable
        ld a,(hl) : or a : jr z,available  ; item available 
        
        jr addloop
    available:
        ld (hl),1 : inc hl      ; enable list item 
        pop af : ld (hl),a : inc hl  ; save x 
        pop af : ld (hl),a : inc hl  ; save y 
        exx : push hl : exx 
        ld a,b 
        ret 
    nonavailable:
        exx : push hl : exx 
        xor a           ; send back 0 
        ret 
    end asm 
end function 

Sprites:
ASM 
Sprite1:
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $0F, $13, $13, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $0F, $0F, $0F, $0F, $13, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $A0, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $C0, $C0, $A0, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $C0, $C0, $C0, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $C0, $C0, $C0, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $60, $A0, $C0, $C0, $C0, $C0, $C0, $A0, $60, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $60, $60, $A0, $C0, $C0, $A0, $60, $60, $60, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $92, $EC, $CC, $EC, $EC, $A8, $A8, $A8, $92, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $88, $88, $EC, $EC, $EC, $EC, $EC, $EC, $A8, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $92, $88, $88, $EC, $EC, $EC, $EC, $A8, $6D, $92, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $92, $88, $88, $88, $EC, $A8, $A8, $A8, $6D, $92, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $92, $88, $88, $88, $88, $88, $A8, $A8, $6D, $92, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $6D, $E3, $88, $88, $88, $A8, $A8, $E3, $6D, $6D, $E3, $E3;

end asm  