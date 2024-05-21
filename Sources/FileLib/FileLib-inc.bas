' fOpen Lib     - em00k part of NextBuild
' library is incomplete

#include <nextlib.bas>




declare function fOpenFile(fname as string) as ubyte
declare function fCreate(fname as string) as ubyte
declare function fReadBytes(infile as ubyte,destadd as uinteger, ldbytes as ulong) as uinteger 
declare function fReadBanks(fname as string, dbank as ubyte) as ubyte 
declare function fWriteBytes(infile as ubyte,srcadd as uinteger, ldbytes as ulong) as uinteger
declare function fSetPos(file as ubyte, fpos as ulong) as ulong 
declare function fGetPos(file as ubyte) as ulong 
declare function fGetFilesize(file as ubyte) as ulong 
declare function fOpenDir(fname as string) as ubyte 
declare function fGetNextDir(fandle as ubyte) as string 


function fastcall fOpenFile(fname as string) as ubyte 
    asm 
        push    namespace   fOpenFile 

    fcachefname:
        push    hl                      ; save string address 
        ld      de,.LABEL._filename
        ld      c, (hl)
        inc     hl 
        ld      b, (hl)
        inc     hl 
        ldir    
        xor     a 
        ld      (de), a 
        pop     hl 
        call    .core.__MEM_FREE
    
    setdrv:
        ld      a,'$'
        rst     $08
        db      $89
        ret

    ffopen:
        ld	    b,$01           ; read 
        jr      faction

    fcreate:
        ld	    b,$0e           ; create 

    faction:
        ld      a,'$'
        rst     $08
        db      $9a
        jr      c, ffailed
        ret

    fwrite:		
        ; ix address, bc bytes 
        or      a
        ret     z
        rst     $08
        db      $9e
        jr      c, ffailed
        ret
    fread:		
        ; ix address, bc bytes 
        or      a
        ret     z
        rst     $08
        db      $9d
        jr      c, ffailed
        ret
    fclose:
        or      a
        ret     z
        rst     $08
        db      $9b
        jr      c, ffailed
        ret
    fpos:
        ; BCDE  position 
        or      a 
        ret     z 
        ld      ixl, 0          ; esx_seek_set
        rst     $08 
        db      $9f 
        jr      c, ffailed
        ret 

    fgetpos:
        ; rets position in BCDE 
        or      a 
        ret     z 
        rst     $08 
        db      $a0 
        jr      c, ffailed
        ret 

    fgetstat:
        or      a 
        ret     z 
        rst     $08 
        db      $a1 
        jr      c, ffailed
        ret 
    
    ; catches failures 
    ffailed:
        ld      b, 25
    1:
        ld      a, 2 
        out     ($fe), a 
        nop     : nop 
        ld      a, 4
        out     ($fe), a 
        djnz    1B 

        xor     a 
        ld      b, a 
        ld      c, a 
        ld      h, a 
        ld      l, a 
        ld      d, a 
        ld      e, a        ; flatten everything going back 
        ret  
    
        POP     namespace 
    end asm 
    fClose(0)
end function

function fastcall fOpenDrive() as ubyte 
    asm 
        call    .fOpenFile.setdrv
    end asm 
end function 

function fastcall fCreate(fname as string) as ubyte 
    asm 
        ; creates a file 
        call    .fOpenFile.fcachefname
        ld      ix, .LABEL._filename 
        jp      .fOpenFile.fcreate
    end asm 
    fOpenFile("")
end function 

sub fastcall fClose(fandle as ubyte)
    asm 
        ; closes a file 
        jp    .fOpenFile.fclose
    end asm 
end sub 

function fastcall fReadBytes(infile as ubyte, destadd as uinteger, ldbytes as ulong) as uinteger 
    asm 
        ; ix address, bc bytes, a handle 
        ex      (sp), hl 
        pop     ix              ; get address 
        pop     ix              ; get address 
        pop     bc              ; get length 
        push    hl              ; save ret 
        call    .fOpenFile.fread
        ld      l, c            ; send back saved size 
        ld      h, b 
    end asm 
end function


function fastcall fWriteBytes(infile as ubyte, srcadd as uinteger, ldbytes as ulong) as uinteger 
    asm 
        ; ix address, bc bytes, a handle 
        ex      (sp), hl 
        pop     ix              ; get address 
        pop     ix              ; get address 
        pop     bc              ; get length 
        push    hl              ; save ret 
        call    .fOpenFile.fwrite
        ld      l, c            ; send back saved size 
        ld      h, b 
    end asm 
end function

function fastcall fSetPos(file as ubyte, fpos as ulong) as ulong 
    asm 
        ; sets file position 
        ex      (sp), hl        ; exchange ret address
        pop     bc              ; need to empty off stack
        pop     de              ; pop LOW bytes
        pop     bc              ; pop HIGH bytes 
        push    hl              ; push ret back on to stack 
        call    .fOpenFile.fpos ; do call 
        ld      l, c            ; size in BCDE, so transfer to DEHL 
        ld      h, b 
        ex      de, hl 
    end asm 
end function 

function fastcall fGetPos(file as ubyte) as ulong 
    asm 
        ; gets file position 
        call    .fOpenFile.fgetpos
        ld      l, c 
        ld      h, b 
        ex      de, hl 
    end asm 
end function 


function fastcall fDelete(fname as string) as ubyte
    asm 
        ; gets file position 
        BREAK 
        call    .fOpenFile.fcachefname
        ld      ix, .LABEL._filename 
        ld      a, '*'
        rst     8 
        db      $ad                 ; unlink 
        ; a = success 
    end asm 
end function 


function fastcall fGetDir() as string 
    asm 
        ; gets file position 
        BREAK 
        push    ix 
        call    .fOpenFile.setdrv
        ld      ix, .LABEL._filename+2 
        ld      a, $ff
        ld      de, spec
        ld      b, 0 
        rst     8 
        db      $a8                 ; getcwd 
        ld      hl, .LABEL._filename+2 
        ld      bc, 0 
    1:
        inc     bc 
        ld      a, (hl)
        or      a 
        jr      nz, 1B
        ld      hl, .LABEL._filename
        ld      c, (hl)
        inc     hl 
        ld      b, (hl)
        dec     hl 
        pop     ix 
        ret 
    spec:
        db "C:/",0
        ; a = success 
    end asm 
end function 

function fastcall fChandeDir(fname as string) as ubyte
    asm 
        ; gets file position 
        BREAK 
        call    .fOpenFile.fcachefname
        ld      ix, .LABEL._filename 
        ld      a, '*'
        rst     8 
        db      $9a                 ; unlink         
        
        ; a = success 
    end asm 
end function 


function fastcall fGetFilesize(file as ubyte) as ulong 
    asm 
        ; gets file size 
        ld      ix, .LABEL._filename
        call    .fOpenFile.fgetstat
        ld      hl, (.LABEL._filename+7)
        ld      de, (.LABEL._filename+9)
    end asm 
end function 

function fastcall fReadBanks(fname as string, dbank as ubyte) as ubyte 
    asm 
        ; ix address, bc bytes, a handle 
         
        
        call    .fOpenFile.fcachefname
        pop     hl 
        pop     af              ; start bank 
        nextreg $52, a          ; $4000 as workspace 
        push    hl              ; save ret 
        ld      d, a 
        push    ix 
        ld      ix,.LABEL._filename 
        call    .fOpenFile.ffopen 
        ; a will be handle 
        ld      e, a            ; save banks in e 

    1:  ; load loop
        push    de              ; save handle and banks
        ld      a, e            ; get back handle 
        ld      ix, $4000       ; destination 
        ld      bc, $2000       ; max load amount 
        call    .fOpenFile.fread
        ;       bc bytes read 
        pop     de 
        inc     d               ; increse banks 
        ld      a, d            ; next bank 
        nextreg $52, a 
        
        ld      a, b 
        or      c 
        jr      nz, 1B          ; did we load zero bytes yet? yes jump forward to 2 
       
        ; ld      a, d            ; return the number of banks loaded 
        nextreg $52, $0a        ; retsore banks
        pop     ix 
        ret 
    end asm 
    fOpenFile("")
end function 

function fastcall fOpenDir(fname as string) as ubyte 
    asm
    push        namespace   fOpenDir
    
    initdrive:
        BREAK 
        push    ix 
		;' get current work dir
        call    .fOpenFile.fcachefname

		ld      a,'*'                       ; default drive
    	ld      ix,.LABEL._filename         ; buffer 
		rst     8 : DB $a8                  ; get the current directory 
		
		ld      b,$80                       ; lfn files only
        ld      c,$78
		ld      a,'*'                       ; default drive         

		ld      ix,.LABEL._filename         ; point to buffer         
        ld      de,.LABEL._filename         ; point to buffer         
		rst     8 : db $a3                  ; open dir 

        jp      z,_dont_close			        ; no more entries
        jp      c,close_dir 		        ; fail, a = error code 
        jr      _dont_close        

    close_dir:
        rst 8 : db $9b
        xor     a 
        jp      _open_dir_end

    _dont_close:
		ld      (fandle+1),a	            ; a = dir handle 
		rst     8 : db $a7                  ; rewind to start of dir
    fandle:
        ld      a, 0 
        ; a will be return <>0 for success 

    _open_dir_end:
        pop     ix 
        ret 
    pop         namespace
    end asm
    fOpenFile("")
end function

function fastcall fGetNextDir(fandle as ubyte) as string 

    asm
        push        namespace   fGetNextDir
        ; a will be handle 
        or      a 
        ret     z 
        push    ix 
        ld      (close_dir2+1), a 
        ld      ix, .LABEL._filename 
        ld      de, .LABEL._filename 
        rst     8 : db $a4           ; read entry 

        or      a
        jp      z,close_dir2		        ; no more entries
        jp      c,close_dir2 		        ; fail, a = error code 
        ;jr      _dont_close2
    close_dir2:
        
        ld      a, 0 : rst 8 : db $9b
        xor     a 
        ld      hl, .LABEL._filename
        ld      (hl), 0 : inc hl  
        ld      (hl), 0 

        ld      hl, .LABEL._filename        ; send string back 
        pop     ix 
        pop         namespace
    end asm

end function 
' dim n as ubyte 
' dim file as ubyte 

' fOpenDrive()

' test = fOpenDir("ATEST")

' print test 
' if test

'     dir = fOpenDir("ATEST")

'     if dir
'         test$=fGetDir(dir)
'         if len test$  
'             print test 
'         endif 
'     endif 

'     endif 

' endif 


' file = fCreate("test.asm")

' if file 
'     Print "File opened "+str(file)
'     bytes=fWriteBytes(file,@dataa,256)
'     if bytes 
'         print "bytes saved "+str(bytes)
'         new_pos = fSetPos(file,$20)
'         if new_pos
'             print "new position "+str(new_pos)
'             bytes=fReadBytes(file,$4000,32)
'             if bytes 
'                 print "bytes loaded "+str(bytes)
'                 print "file pos "+str(fGetPos(file))
'                 print "file size "+str(fGetFilesize(file))
'                 fClose(0)   
'             endif 
'         endif 
'     endif 
' endif 

' banks = fReadBanks("JAGTITLE.MOD",40 )


' ' if file 
' '     Print "File opened "+str(file)
' '     bytes=fReadBytes(file,$4000,32)
' '     if bytes 
' '         print "bytes read "+str(bytes)
' '         new_pos = fSetPos(file,$20)
' '         if new_pos
' '             print "new position "+str(new_pos)
' '             bytes=fReadBytes(file,$4000,32)
' '             if bytes 
' '                 print "bytes loaded "+str(bytes)
' '                 print "file pos "+str(fGetPos(file))
' '                 print "file size "+str(fGetFilesize(file))
' '                 fClose(0)   
' '             endif 
' '         endif 
' '     endif 
' ' endif 

' ' do : loop 
