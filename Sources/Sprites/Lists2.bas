'!ORG=32768
'!HEAP=1024
' Event Sprite Engine 
' Part of NextBuild 
'#
' This code will manage a list of sprites and move according to defined simple movement scripts
'

#include <nextlib.bas>                                          ' inlcude the nextlib 
#INCLUDE <keys.bas>

declare function getNextElement(listaddress as uinteger) as UINTEGER
declare function addElement(listaddress as UBYTE,x as ubyte ,y as ubyte) as UBYTE 
declare function addSprite(listaddress as UBYTE,spritedata as UINTEGER) as UBYTE
declare function deleteElement(elementid as UBYTE) as UBYTE 
declare function getElement(elementid as UBYTE) as UINTEGER
declare function resetList(elementid as UINTEGER) as UBYTE 
declare function addScript(script as UINTEGER, scriptid as UBYTE) as UINTEGER
declare function countList(listaddress as UINTEGER) as UBYTE

asm
    nextreg SPRITE_CONTROL_NR_15,%00001011                     	; ' Enable sprite visibility & Sprite ULA L2 order 
    nextreg TURBO_CONTROL_NR_07,3                               ; 28 mhz 
end asm

dim a,b,c,base as UINTEGER
dim lista as UINTEGER at $c000
dim item as UBYTE 
for x = 0 to 512 : poke $c000+x,0 : next x 

InitSprites(1,@Sprites) 

addScript(@scripts,0)                ' ; send script to slot generated for above 
addScript(@scripts+5,1)                ' ; send script to slot generated for above 
addScript(@scripts,2)                ' ; send script to slot generated for above 

a=addSprite(@lista,@spritedata)             ' needs changing upload sprite data 
b=addSprite(@lista,@spritedata+16)             ' needs changing upload sprite data 
c=addSprite(@lista,@spritedata+32)             ' needs changing upload sprite data 

print countList(@lista)

do  
    WaitRetrace(1)  
    UpdateSprites()

loop 

sub UpdateSprites()
    ' update the sprites in the list 
    dim spriteon,yy,type,spid,simage,pma,pmb,pmc,pmd,pme,sprstep,sploop,sprpc,command as UBYTE
    dim xx,sprdata,eventadd as UINTEGER


    ' -- sprite loop

    for sploop = 0 to countList(@lista)
        base=getNextElement(@lista)            ' will return bass address of element 
        xx = peek(UINTEGER,base+1) : yy = peek(UBYTE,base+3)
        simage = peek(UBYTE,base+6) : spid = peek(UBYTE,base+5)
        pmd = peek(UBYTE,base+10)
        eventadd = peek(UINTEGER,base+13) : sprpc=peek(UBYTE,base+15)
        
        ' get script address 
        ' control 
        const RT as ubyte = 1 
        const UP as ubyte = 2
        const LT as ubyte = 4 
        const DN as ubyte = 8 
        
        if sprpc = 0 
           
            command = peek(eventadd)
            else 
            print command
            command = peek(base+9)
        endif 
        pause 0
        if pmd > 0                              ' if amount = 0 
            pmd = pmd - 1
            poke(base+10,pmd)
            if command = 1 
                xx=xx+1 : poke UINTEGER base+1,xx 
            elseif command = 4
                xx=xx-1 : poke UINTEGER base+1,xx 
            endif 
        else    
            command = peek(eventadd+cast(uinteger,sprpc))
            pmd = peek(eventadd+cast(uinteger,sprpc)+1)

            sprpc=sprpc+2        
        endif

        poke(base+10,pmd)
        poke(base+15,sprpc)             ' ; store the pc 
        poke(base+9,command)                 ' ; pmc = direction


        ' SPRON    EQU 0       ; sprite on / off 
        ' SPRX     EQU 1       ; two bytes as x is int 
        ' SPRY     EQU 3       ; y byte 
        ' SPRTYPE  EQU 4       ; sprite type, defined by game 
        ' SPRID    EQU 5       ; sprite id 
        ' SPRIMG   EQU 6       ; sprite image
        ' SPRPMA   EQU 7       ; sprite params 
        ' SPRPMB   EQU 8       ; sprite params
        ' SPRPMC   EQU 9
        ' SPRPMD   EQU 10
        ' SPRPME   EQU 11
        ' SPRPMF   EQU 12
        ' SPRDAT1  EQU 13     ; sprite script address 2 bytes 
        ' SPRDAT2  EQU 14
        ' SPRDAT3  EQU 15     ; stage in script 
        UpdateSprite(xx,yy,spid,simage,0,0)
    next sploop 


end sub 


' PRINT countList(@lista)
a=addElement(@lista,5,6)
' PRINT countList(@lista)
deleteElement(a)
' PRINT countList(@lista)

' PRINT addElement(@lista,2,3)
' PRINT addElement(@lista,7,9)
' PRINT addElement(@lista,10,12)   ' 4
for x = 0 to 15 
    ' PRINT addElement(@lista,x,x)
next x 

do 
    if GetKeyScanCode()=KEYSPACE 
        item = cast(UBYTE,rnd*10)
        base = getElement(item)
        ' PRINT at 20,5;item;"   ";peek(base+1);"   ";peek(base+2);"   " 
        pause 0 
    endif 
    if GetKeyScanCode()=KEY1
        item = 10
        base = deleteElement(item)
        addElement(@lista,64,64)
        resetList(@lista) : cls 
        for x = 0 to 31 
            base = getNextElement(@lista) 
            ' PRINT peek(base+1);"   ";peek(base+2);"   " 
        next 
        pause 10
    endif 
loop 

do 
    border 2
    base = getNextElement(@lista) 
    ' PRINT at 0,0;peek(base+1);"   ";peek(base+2);"   " 
    border 0 
    pause 0
loop 

function fastcall deleteElement(elementid as UBYTE)
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
        ld b,31
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
        ld hl,0
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

function fastcall getElement(elementid as UBYTE) as UINTEGER

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

function fastcall countList(listaddress as UINTEGER) as UBYTE
    ' counts how many itmes in the list are define / enabled 
    asm 
        ; hl = list address 
        ld b,0
    counterloop:                ; skip header 
        add hl,16 : ld a,h : and 1 : cp 1 : jr z,countcomplete ; count complete          
        ld a,(hl) : or a : jr z,donotcount 
        inc b 
    donotcount:
        jr counterloop
    countcomplete:
        ld a,b 
        ret 
    end asm 
end function 

function fastcall addScript(script as UINTEGER, scriptid as UBYTE) as UINTEGER

    asm 
        ; this will upload a script to the specified slot 0 - 255
        ; table starts at $c200, scripts at $c500 
        ;BREAK 
        exx : pop hl : exx              ; store ret address 
        push hl                         ; save script address 
        ;BREAK                          
        ; a = script id                
        and 15                          ; top out at 16 for now 
        ld e,a 
        sla a 
        ex af,af' 
        ld d,128                        ; each script can be 128 bytes long 
        mul d,e                         ; now have the offset into table
        ld hl,$c500                     ; start at data
        add hl,de                       ; now at new script address 
        pop de                          ; pop script address 
        push hl 
        ex de,hl                        ; swap hl/de 
        
    scriptloop:
        ld a,(hl) : test $ff : jr z,finishedscriptloop
        ldi 
        jr scriptloop

    finishedscriptloop:
    ;    BREAK 
        ex af,af'
        ld de,$c200 
        add de,a 
        pop hl 
        ld a,l : ld (de),a : ld a,h : inc de : ld (de),a
        exx : push hl : exx 
        ret 


    end asm 
end function 

function fastcall addElement(listaddress as UBYTE,x as UBYTE ,y as UBYTE) as UBYTE 

    asm 
        exx : pop hl : exx
        ; hl now at last list entry 
        ld hl,$c000 : ld b,0
    addloop:
        
        add hl,16 : push hl : ld de,512: sbc hl,de : pop hl : jr c,nonavailable
        ld a,(hl) : or a : jr z,available  ; item available 
        inc b                           ; return value 
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


function fastcall addSprite(listaddress as UBYTE,spritedata as UINTEGER) as UBYTE 

    asm 
        PROC 
        LOCAL addloop, available, nonavailable
        exx : pop hl : exx
        ; hl now at last list entry 
        ld hl,$c000 : ld b,0
    addloop:
        ;BREAK 
        add hl,16 : push hl : ld de,512: sbc hl,de : pop hl : jr c,nonavailable
        ld a,(hl) : or a : jr z,available  ; item available 
        inc b                           ; return value 
        jr addloop
    available:
        pop de 
        ex de, hl
        push bc
        ld bc,15
        ldir 
        pop bc 
        exx : push hl : exx 
        ld a,b 
        ret 
    nonavailable:
        exx : push hl : exx 
        xor a           ; send back 0 
        ret 
        ENDP 
    end asm 
end function 

spritedata:
asm 
   ; sprite on , sprx, sprx, spry, sprtype, sprid, sprimg, pma, pmb, pmc, pmd, pme, pmf, spdat1, spdat2, spdat3
                ; ' id i a b c d e f       s 
    db 1,64,0,64,  0,0,0,0,0,0,0,0,0,0,$c2,0
    db 1,164,0,164,0,1,0,0,0,0,0,0,0,2,$c2,0
    db 1,104,0,104,0,2,0,0,0,0,0,0,0,2,$c2,0
end asm 

scripttable:
asm 
scripttable:                ; stores the address of scripts , space for 32 scripts 
    ds 64,00
end asm 
scripts:
asm 
script1:
    ; 0 still 1 right 2 up 3 left 4 down 
    ; 
    ; X = 0 Y = 0 
    ; IF = 16
    ; ELSE = 17
    ; ENDIF = 18
    ; 
    ; if opcode = if (16) scan forward for else or endif save difference in scrpt temp 1
    ; get 
    ; IF X<100 
    ;  X = + 1 
    ; END IF 
    ; 
    db RT,AM*100,DL*55,WA*13			;' right for 10 loops delay 3, at end wait 20 
    db $ff       ; ff = end mark of script 
script2:
    db AM*100,DL*55,WA*13
    db $ff     

;   notes on list data 
;   16 bytes, first 16 control bytes (maybe could be smaller but for later )
;   eventarray:
;   first four bytes are a temp area 
;   B 1,0,0,0 							;' nuimber of event , event active , blank , blank 
;   Command Amount Delay Wait  
;   B RT,AM*100,DL*55,WA*13			;' right for 10 loops delay 3, at end wait 20 
;   B SI,AM*200,DL*50,WA*30
;   B DN+LT,AM*5,DL*20,WA*1
;   B RT,AM*5,DL*20,WA*1
;   B UP+LT,AM*5,DL*20,WA*1
;   B RT,AM*100,DL*25,WA*25
;   B LT,AM*100,DL*25,WA*25

end asm 
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


asm 
    RT	EQU 1
    UP	EQU 2
    LT	EQU 4 
    DN	EQU 8
    SI	EQU 16
    AM  EQU 1 
    WA  EQU 1 
    DL  EQU 1 
    SPRON    EQU 0       ; sprite on / off 
    SPRX     EQU 1       ; two bytes as x is int 
    SPRY     EQU 3       ; y byte 
    SPRTYPE  EQU 4       ; sprite type, defined by game 
    SPRID    EQU 5       ; sprite id 
    SPRIMG   EQU 6       ; sprite image
    SPRPMA   EQU 7       ; sprite params 
    SPRPMB   EQU 8       ; sprite params
    SPRPMC   EQU 9
    SPRPMD   EQU 10
    SPRPME   EQU 11
    SPRPMF   EQU 12
    SPRDAT1  EQU 13     ; sprite script address 2 bytes 
    SPRDAT2  EQU 14
    SPRDAT3  EQU 15     ; stage in script 



end asm 