'!org=32768
'#!asm 
#include <nextlib.bas>

dim tst as ubyte 

tst = 100 

function ltrim(ByVal s$, ByVal rep$) as String
    DIM i as Uinteger = 0
    DIM d, l2 as Uinteger
    DIM l as Uinteger = len(rep$)

    if not l then return s$

    d = l - 1
    l2 = len(s$)

    while i < l2 and rep = s(i to i + d)
        i = i + l
    end while

    return s$(i to)
end function


t$=ltrim("---BIG TEST","---")
print t$ 

asm 
di 
halt 
end asm 


do 
t$="test"
ExecDot("test"+str(n))
n=n+1
loop 


sub fastcall ExecDot(execfilename as string)
    ASM 
		; dont include the period eg "nexload myfile.nex" 
		; string pointer in hl 
        ; BREAK
		PROC 
		LOCAL exedotfailed, execdotdone
        push hl 

		ld a,(hl) 										; size of string of input call now copy string to temp location
		inc hl : inc hl : ld de,.LABEL._filename : ld b,0 : ld c,a : ldir 

		ld a,$0d : ld (de),a							; ensure line finishes with EOL marker 

		ld ix,.LABEL._filename : push ix : pop hl 		;  dot command and regular 
		rst $8 : DB $8f 								;  M_EXECCMD ($8f)   

		jp execdotdone
					
	exedotfailed:	
		; esxdos error in a 
		out($fe),a										; handle the error however you want 

	execdotdone:
        pop hl 
        jp .core.__MEM_FREE        
        ; pop de : pop bc : pop ix
        
        
        di
		ENDP		
    end asm 
end sub 
