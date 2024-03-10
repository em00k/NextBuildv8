
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
	
	ld d,0                      ; put 0 into d 
	bit 7,e                     ; test bit 7 of e
	jr z,bl                     ; jump if set to bl 
	dec d                       ; else dec d 
bl: 
	ld hl,(rmousex)             ; get hl
	add hl,de
	ld bc,4*256
	call rangehl
	ld (rmousex),hl
	sra  h
	rr l
	sra h
	rr l
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

mousex:
	db	0
mousey:
	db	0
omousex:
	db	0
omousey:
	db	0
nmousex:
	db	0
nmousey:
	db	0
mouseb:
	db	0
omouseb:
	db	0
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

