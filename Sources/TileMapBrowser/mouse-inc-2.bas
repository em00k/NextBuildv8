
sub Process_Mouse()
	asm 
	; Jim bagley mouse routines, clamps mouse and dampens x & y 
	ld	de,(nmousex)            ; get new mouse x 
	ld (omousex),de             ; store in old mouse 
	ld	a,(mouseb)              ; get mousebuttons into a 
	ld (omouseb),a              ; store in mousebuttold 
	
	call getmouse               ; get mouse 

	ld (mouseb),a               ; save buttons into mouseb
	ld (nmousex),hl             ; save x

	ld a,l                      ; take x into a 
	sub e                       ; subtract old x  
	ld e,a                      ; save new value in e 
	ld a,h                      ; get y 
	sub d                       ; sub old y 
	ld d,a                      ; save new y in d
	ld (dmousex),de	            ; delta mouse
	
	; Unpack X and Y values from HL register pair
	ld a, l
	and %00011111              ; Mask X value (0-31)
	ld l, a
	ld a, h
	and %11100000              ; Mask Y value (0-7)
	ld h, a
	
	; Modify the X value to allow a range of 0-319
	ld d,0                      ; put 0 into d 
	bit 7,e                     ; test bit 7 of e
	jr z,bl                     ; jump if set to bl 
	dec d                       ; else dec d 
bl: 
	ld hl,(rmousex)             ; get hl
	add hl,de
	ld bc,1024                  ; Keep the original value here
	call rangehl
	ld (rmousex),hl
	call clampx                 ; Call the new subroutine to clamp X value
	
	; Pack the modified X and Y values back into the HL register pair
	ld a, h
	or l
	ld l, a
	ld h, 0
	
	; Continue with the rest of the code
	ld a,l
	ld (mousex),a
	ld de,(dmousey)
	ld d,0
	bit 7,e
	jr z,bd
	dec d
bd: 
	ld hl,(rmousey)
	add hl,de
	ld bc,1024
	call rangehl
	ld (rmousey),hl
	sra  h
	rr l
	sra h
	rr l
	ld a,l
	ld (mousey),a

	jp mouseend
	
getmouse:
	ld	bc,64479                ; kemp m X 
	in a,(c)
	ld l,a                      ; store in l
	ld	bc,65503                ; kemp mouse y 
	in a,(c)
	cpl                         ; invert a 
	ld h,a                      ; store in h
	ld (nmousex),hl             ; now store mouse x/y 
	ld	bc,64223                ; get buttons 
	in a,(c)
	ld (mouseb),a               ; store in mouseb 
	ret
    
rangehl:
	bit 7,h                     ; check bit 7 
	jr nz,mi                    ; not 0 jump to mi 
	or a                        ; clear flags 
	push hl                     ; save hl 
	sbc hl,bc                   ; sub bc from hl 
	pop hl                      ; get hl back 
	ret c                       ; ret if carry set (bc>hl)
	ld	h,b                     ; else put bc into hl 
	ld l,c
	dec hl                      ; then decrease hl 
	ret
mi:
	ld hl,0                     ; reset hl 
	ret

clampx:
    ld a, h
    cp 1
    jr c, reset_x
    ld a, l
    cp 64 ; Compare with 320 / 5 = 64
    jr c, within_x
reset_x:
    ld hl, 0
    ret
within_x:
    ld a, l
    ld b, 5
    ld l, 0
    call multiply_x
    ret

multiply_x:
    add a, l
    jr nc, no_carry_x
    inc h
no_carry_x:
    djnz multiply_x
    ret

mousex:
	dw	0
mousey:
	dw	0
omousex:
	dw	0
omousey:
	dw	0
nmousex:
	dw	0
nmousey:
	dw	0
mouseb:
	dw	0
omouseb:
	dw	0
rmousex:
	dw	0
rmousey:
	dw	0
dmousex:
	db	0
dmousey:
	db	0

mouseend:
	ld a,(mouseb)
	ld (Mouse),a
	ld de,(mousex)
	ld (Mouse+1),de
	ld de,(mousey)
	ld (Mouse+3),de
	
	end asm 
end sub 

Mouse:
ASM
Mouse:
			db	0   ; buttons 
			dw	0   ; x 
			dw	0   ; y 
end asm 

