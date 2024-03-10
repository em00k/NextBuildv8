
' DMA Routines 

SUB DMAUpdate(byval scaler as ubyte)
    ' in scaler 0 - 255 
	asm 
		; quick sets DMA 
		ld e,a : ld bc,$6b : ld a,$68 : out (c),a : ld a,$22 : out (c),a
		ld a,e			; new scaler value 
		out (c),a : ld a,$cf : out (c),a : ld a,$87 : out (c),a
	end asm 
end sub 

SUB DMALoop(byval dmsloopv as ubyte)
    ' in dmsloopv 0 no loop 1 loop 
	asm 
		; quick sets DMA 
		ld e,a
		ld bc,$6b
		ld a,e				; new scaler value 
		cp 1 : jr z,dmalooprepeat
		ld a,$82 : jr dmalooprepeat+2
dmalooprepeat:
		ld a,$b2 
		out (c),a
	end asm 
	
end sub 

' Sub fastcall DMAPlay(byval address as uinteger,dmalen as uinteger, byval scaler as ubyte,byval repeat as ubyte)
'     ' sets up the dma 
' 	asm  
' 	Z80DMAPORT EQU 107
' 	SPECDRUM EQU $FFDF
' 	BUFFER_SIZE	EQU 8192
' PLAY:
' 	ld      (dmaaddress), hl
' 	pop     hl 
' 	exx 
' 	pop     hl : ld (dmadlength), hl 
' 	pop     af : ld (dmascaler),a
' 	pop     af : ; repeat flag 

' 	; deal with setting repeat flag
' 	cp      1 : jr z,setrepeaton
' 	ld      a,$82 : jr setrepeaton+2
' setrepeaton:
' 	ld      a,$b2

' 	ld      (dmarepeat),a
	
' 	; LOAD DMA 

' 	ld      hl,dma
' 	ld      b,dmaend-dma
' 	ld      c,z80dmaport
' 	otir
	
' loopa:
' 	jp dmaend
	
' dma:

' 	defb $c3			; r6-reset dma
' 	defb $c7			; r6-reset port a timing
' 	defb $ca			; r6-set port b timing same as port a

' 	defb $7d 			; r0-transfer mode, a -> b
' dmaaddress:
' 	defw $4400		    ; r0-port a, start address
' dmadlength:
' 	defw 2056			; r0-block length

' 	defb $54 			; r1-port a address incrementing, variable timing
' 	defb $2				; r1-cycle length port b

' 	defb $68			; r2-port b address fixed, variable timing
' 	defb $22			; r2-cycle length port b 2t with pre-escaler
' dmascaler:
' 	defb 100			; r2-port b pre-escaler
' 	;		  defb 255	; r2-port b pre-escaler
' 	;		  defb $ad 	; r4-continuous mode
' 	defb $cd 			; r4-burst mode
' 	defw specdrum		; r4-port b, start address

' 	; defb $b2			;r5-restart on end of block, /ce + /wait, rdy active low
' 	; defb $a2			;r5-restart on end of block, rdy active low
' dmarepeat:			    ; $b2 for short burst $82 for one shot 
' 	defb $82			; r5-stop on end of block, rdy active low
' 	;
' 	defb $bb			; read mask follows
' 	defb $10			; mask - only port a hi byte - where does the mask come from? wr6

' 	defb $cf			; r6-load
' 	defb $b3			; r6-force ready
' 	defb $87			; r6-enable dma
		  
' dmaend:
' 	exx 
' 	push hl
	
' 	end asm 

' end sub 

sub fastcall dmaCopy(source as uinteger, dest as uinteger, length as uinteger)

    asm 

        pop     ix          ; save ret 
        pop     hl 
        pop     de 
        pop     bc 
        ld      (DMASource),hl
        ld      (DMADest),de
        ld      (DMALength),bc
        ld      hl,DMACode
        ld      b,DMACode_Len
        ld      c,ZXN_DMA_PORT
        otir
        push    ix 
        ret 

DMACode:
        db $83                        ; disable DMA 

        db %01111101                  ; R0-Transfer mode, A -> B, write adress 
                                      ; + block length
DMASource: 
        dw 0                          ; R0-Port A, Start address 
                                      ; (source address)
DMALength:
        dw 0                          ; R0-Block length (length in bytes)
        db %01010100                  ; R1-write A time byte, increment, to 
                                      ; memory, bitmask
        db %00000010                  ; 2t
        db %01010000                  ; R2-write B time byte, increment, to 
                                      ; memory, bitmask
        db %00000010                  ; R2-Cycle length port B
        db %10101101                  ; R4-Continuous mode (use this for block 
                                      ; transfer), write dest adress
DMADest:
        dw 0                          ; R4-Dest address (destination address)
        db %10000010                  ; R5-Restart on end of block, RDY active 
                                      ; LOW
        db $cf                        ; R6-Load
        db $87                        ; R6-Enable DMA
        
    DMACode_Len                    equ $-DMACode

    end asm 

end sub 