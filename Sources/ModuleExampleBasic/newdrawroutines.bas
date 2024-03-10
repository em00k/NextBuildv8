asm 
			push namspace	NEXT_GRAPHICS_L2

; Set the video modes up
;
Set_Video_Mode_M1:	LD	A, %00000000		; 256 x 192 x 8
			LD	E, %00100011		; Sprites & clipping, SLU priority
			LD	C, 32 
			LD	B, 24 
			LD	D, 191 + 32
			JR	Set_Video_Mode
;
Set_Video_Mode_M2:	LD	A, %00010000		; 320 x 256 x 8
			LD	E, %00100011		; Sprites & clipping, SLU priority
			LD	C, 40
			LD	B, 32
			LD	D, 255
			JR	Set_Video_Mode
;
Set_Video_Mode_M3:	LD	A, %00100000		; 640 x 256 x 4
			LD	E, %00100011		; Sprites, no clipping, SLU priority
			LD	C, 80
			LD	B, 32
			LD	D, 255
;
Set_Video_Mode:		PUSH	AF, BC, DE
			XOR	A
			LD	(TEXT_BACKGROUND), A
			DEC	A
			LD	(TEXT_FOREGROUND), A 
			LD	(PLOT_COLOUR), A
			LD	(CHAR_COLS), BC
			LD	H, 0
			LD	L, C 
			ADD	HL, HL 
			ADD	HL, HL 
			ADD	HL, HL
			LD	(PIXEL_WIDTH), HL 
			LD	H, 0
			LD	L, B
			ADD	HL, HL 
			ADD	HL, HL 
			ADD	HL, HL
			LD	(PIXEL_HEIGHT), HL
			CALL	NEXT_GRAPHICS.CLS
			POP	DE, BC, AF
			NEXTREG NREG.L2_CONTROL, A
			LD	A, E
			NEXTREG NREG.LAYER_CONTROL, A		
			LD	A, D			
			NEXTREG	NREG.CLIP_WINDOW_L2, 0		; Clip Window
			NEXTREG	NREG.CLIP_WINDOW_L2, 255
			NEXTREG	NREG.CLIP_WINDOW_L2, 0
			NEXTREG	NREG.CLIP_WINDOW_L2, A	
			NEXTREG	NREG.CLIP_WINDOW_SPRITES, 0	; Clip Window Sprites
			NEXTREG	NREG.CLIP_WINDOW_SPRITES, 255
			NEXTREG	NREG.CLIP_WINDOW_SPRITES, 0
			NEXTREG	NREG.CLIP_WINDOW_SPRITES, A
			NEXTREG	NREG.PALETTE_CONTROL, %10010000 ; Change L2 first palette
			RET


; Clear the screen
; Used by CLS and CLG
; C: Colour to clear screen with
;
Clear_Screen_M1:	LD	B, 3 
			LD	A, C 
			JR	Clear_Screen
;
Clear_Screen_M2:	LD	A, C 
			JR	1F

Clear_Screen_M3:	LD	A, C
			AND 	0x0F
			LD	B, A 
			SWAPNIB
			OR	B 
1:			LD	B, 5
;
Clear_Screen:		LD	(R00), A 		; Store the colour
			LD	A, (BORDER_COLOUR)	; Set the border colour
			OUT 	(254), A
			NEXTREG	NREG.L2_SCROLL_Y, 0	; Scroll register
			PUSH	BC			; Stack BC, Z80PORT corrupts it!
			Z80PORT	0x123B, %00000011	; Enable for memory writes
			POP	BC
1:			PUSH	BC
			LD	A, B 
			DEC	A 
			OR	%00010000		; Set to page relative to current page
			Z80PRTA	0x123B
			LD	A, (R00)		; The fill byte value
			LD	DE,0x0000		; Screen RAM is paged into ROM area
			LD	BC,0x4000		; 16K in size
			CALL	NEXT_DMA.FillDMA	; Clear it
			POP	BC
			DJNZ	1B
			Z80PORT	0x123B, %00000010	; Disable memory writes
			RET

; Scroll
;  H: Line to clear after scroll
;
Set_Scroll_Reg:		LD	A, (SCRLPOS_Y)
			ADD	A, A
			ADD	A, A
			ADD	A, A 
			NEXTREG	NREG.L2_SCROLL_Y, A
			RET 

; Adjust HL for scroll position
; HL: Y
; Returns:
; HL: Y adjusted for Y 
;
Adjust_SCRLPOS_P:	LD	A, (SCRLPOS_Y)		; Get Y scroll position
			ADD	A, A
			ADD	A, A 
			ADD	A, A 			; Multiply by 8
			ADD	A, L 			; Add to pixel Y position
			LD	L, A			; Wraps 
			RET

; Print a single character out to an X/Y position
;  E: Character to print
;  L: X Coordinate
;  H: Y Coordinate
;
Print_Char_M3:		CALL	Get_Char_Address_M3		
			CALL	Get_Character_Data	
			LD	BC, (TEXT_FOREGROUND)	; C: Foreground, B: Background
			CALL	Get_Colour_Nibbles
			LD	IXH, 8			; Outer loop counter
			LD	B, high R00		; Index into nibble table
1:			LD	A, (DE)			; First pair of pixels
			AND	%11000000
			RLCA 
			RLCA 
			LD	C, A 
			LD	A, (BC)
			LD	(HL), A 
			INC	H
			LD	A, (DE)			; Second pair of pixels
			AND	%00110000
			SWAPNIB 
			LD	C, A 
			LD	A, (BC)
			LD	(HL), A 
			INC	H 
			LD	A, (DE)			; Third pair of pixels
			AND	%00001100
			RRCA 
			RRCA 
			LD	C, A
			LD	A, (BC)
			LD	(HL), A
			INC	H
			LD	A, (DE)			; Final pair of pixels
			AND	%00000011
			LD	C, A 
			LD	A, (BC)
			LD	(HL), A 
			DEC	H 			; Decrement screen position
			DEC	H
			DEC	H
			INC	DE
			INC	L
			DEC	IXH 
			JR	NZ, 1B
			Z80PORT	0x123B, %00000010
			RET
;
Print_Char_M2:		CALL	Get_Char_Address_M2
			CALL	Get_Character_Data
			LD	BC, (TEXT_FOREGROUND)	; C: Foreground, B: Background
			LD	IXH, 8			; Outer Loop counter
1:			PUSH	HL
			LD	A, (DE)			; Get the byte from the ROM into A
			LD	IXL, 8			; Inner loop counter
2:			ADD	A, A
			JR	C, 3F
			LD	(HL), B			; Set background colour
			JR	4F
3:			LD	(HL), C			; Set foreground colour
4:			INC	H
			DEC	IXL
			JR	NZ, 2B
			INC 	DE			; Goto next byte of character
			POP	HL
			INC	L			; Goto next line on screen
			DEC	IXH
			JR 	NZ, 1B			; Loop around whilst it is Not Zero (NZ)
			Z80PORT	0x123B, %00000010	; Disable memory writes
			RET
;
Print_Char_M1:		CALL 	Get_Char_Address_M1
			CALL	Get_Character_Data
			LD	BC, (TEXT_FOREGROUND)	; C: Foreground, B: Background
			LD	IXH,8			; Outer Loop counter
1:			PUSH	HL
			LD	A,(DE)			; Get the byte from the ROM into A
			LD	IXL, 8			; Inner loop counter
2:			ADD	A, A
			JR	C, 3F
			LD	(HL),B			; Set background colour
			JR	4F
3:			LD	(HL),C			; Set foreground colour
4:			INC	L
			DEC	IXL
			JR	NZ, 2B
			INC 	DE			; Goto next byte of character
			POP	HL
			INC	H			; Goto next line on screen
			DEC	IXH
			JR 	NZ,1B			; Loop around whilst it is Not Zero (NZ)
			Z80PORT	0x123B, %00000010	; Disable memory writes
			RET

; Get all possible colour nibble pairs for Layer 2 (640x256)
;  C: Foreground colour
;  B: Background colour
; Returns:
; R0-R3: Colour nibble pairs
;
Get_Colour_Nibbles:	LD	A, B
			AND	0x0F 
			LD	B, A 
			SWAPNIB
			OR	B 
			LD	(R00), A 		; R0: BB
			LD	A, C
			AND 	0x0F 
			LD	C, A 
			SWAPNIB
			OR	C 
			LD	(R03), A 		; R3: FF
			LD	A, B 			
			SWAPNIB
			OR	C
			LD	(R01), A 		; R1: BF
			SWAPNIB 
			LD	(R02), A 		; R2: FB
			RET 

; Scrape character off screen
;  L: X coordinate
;  H: Y coordinate
; Returns:
; R00 to R07: Character data in monochrome bitmap format
;
Get_Char_M1:		CALL	Get_Char_Address_M1	; Screen address in HL
			Z80PORT	0x123B, %00000110	; Enable memory read only (to read screen data)
			LD 	DE, R00
			LD	B, 8
1:			PUSH	BC
			PUSH	HL
			LD	B, 8
			LD	C, 0
2: 			LD	A, (TEXT_FOREGROUND)
			CP	(HL)
			JR	NZ, 3F
			SET	7, C 
3:			RLC	C
			INC 	L
			DJNZ	2B
			LD	A, C 
			POP	HL
			POP	BC
			LD	(DE), A
			INC	E
			INC	H
			DJNZ	1B
			Z80PORT	0x123B, %00000010	; Disable memory read/write (ready to read ROM charset)
			RET 
;
Get_Char_M2:		CALL	Get_Char_Address_M2	; Screen address in HL
			Z80PORT	0x123B, %00000110	; Enable memory read only (to read screen data)
			LD 	DE, R00
			LD	B, 8
1:			PUSH	BC
			PUSH	HL
			LD	B, 8
			LD	C, 0
2: 			LD	A, (TEXT_FOREGROUND)
			CP	(HL)
			JR	NZ, 3F
			SET	7, C 
3:			RLC	C
			INC 	H
			DJNZ	2B
			LD	A, C 
			POP	HL
			POP	BC
			LD	(DE), A
			INC	E
			INC	L
			DJNZ	1B
			Z80PORT	0x123B, %00000010	; Disable memory read/write (ready to read ROM charset)
			RET 
;
Get_Char_M3:		CALL	Get_Char_Address_M3
			Z80PORT	0x123B, %00000110	; Enable memory read only (to read screen data)
			LD 	DE, R00
			LD	B, 8
1:			PUSH	BC
			PUSH	DE
			PUSH	HL
			LD	B, 4
			LD	C, 0
			LD	A, (TEXT_FOREGROUND)
			AND	0x0F
			LD	E, A
			SWAPNIB
			LD	D, A 
2:			LD	A, (HL)
			AND	0xF0
			CP	D 
			JR	NZ, 3F
			SET	7, C 
3:			RLC	C
			LD	A, (HL)
			AND	0x0F
			CP	E 
			JR	NZ, 4F 
			SET	7, C 
4:			RLC	C
			INC 	H
			DJNZ	2B
			LD	A, C 
			POP	HL
			POP	DE
			POP	BC
			LD	(DE), A
			INC	E
			INC	L
			DJNZ	1B
			Z80PORT	0x123B, %00000010	; Disable memory read/write (ready to read ROM charset)
			RET 		

; Get screen address
;  H = Y character position
;  L = X character position
;  Returns address in HL
;
Get_Char_Address_M1:	SLA	L 			; Multiply X by 8
			SLA	L 
			SLA	L
			LD	A, H 			; Multiply Y by 8		
			RLCA 
			RLCA 
			RLCA 
			LD	H, A			; Get the Y coordinate
			AND	0xC0			; Get the bank number
			RLCA 
			RLCA 
			OR	%00010000
			Z80PRTA	0x123B
			Z80PORT	0x123B, %00000011	; Enable memory writes
			LD	A, H
			AND	0x3F 
			LD	H, A
			RET
;
Get_Char_Address_M2:	LD	A, L 			; X	
			AND	%00111000		; Get the bank number
			RRCA 
			RRCA 
			RRCA 
			OR	%00010000
			Z80PRTA	0x123B
			Z80PORT	0x123B, %00000011	; Enable memory writes
			LD	A, L 			; Swap X and Y
			LD	L, H
			SLA	L			; Multiply Y by 8
			SLA	L
			SLA	L
			ADD	A, A 			; Multiply X by 8
			ADD	A, A
			ADD	A, A 
			AND	0x3F
			LD	H, A
			RET
;
Get_Char_Address_M3:	LD	A, L 			; X	
			AND	%01110000		; Get the bank number
			SWAPNIB
			OR	%00010000
			Z80PRTA	0x123B
			Z80PORT	0x123B, %00000011	; Enable memory writes
			LD	A, L 			; Swap X and Y
			LD	L, H
			SLA	L			; Multiply Y by 8
			SLA	L
			SLA	L
			ADD	A, A 			; Multiply X by 4
			ADD	A, A
			AND	0x3F
			LD	H, A
			RET

; Get pixel position
; Pages in the correct 16K Layer 2 screen bank into 0x0000
; DE: X
; HL: Y
; Returns:
; HL: Address in memory (between 0x0000 and 0x3FFF)
;
Get_Pixel_Address_M1:	LD	D, L 			; Store the Y coordinate in D
			LD 	L, E			; The low byte is the X coordinate
			LD	A, D			; Get the Y coordinate
			AND	0x3F			; Offset in bank
			LD	H, A			; Store in high byte
			LD	A, D			; Get the Y coordinate
			AND	0xC0			; Get the bank number
			RLCA 
			RLCA 
			OR	%00010000
			Z80PRTA	0x123B
			Z80PORT	0x123B, %00000111	; Enable memory read/write
			RET
;
Get_Pixel_Address_M2:	LD	A, E			; Get the X coordinate
			AND	0x3F			; Offset in bank
			LD	H, A			; Store in high byte
			LD	B, 6 
			BSRA 	DE, B 			
			LD	A, E			; Get the X coordinate
			OR	%00010000
			LD	E, A
			Z80PRTA	0x123B
			Z80PORT	0x123B, %00000111	; Enable memory read/write 
			RET
;
Get_Pixel_Address_M3:	SRL	D 			; But two pixels per byte
			RR	E 			; So divide X by 2
			PUSH	AF
			CALL	Get_Pixel_Address_M2
			POP	AF
			RET

; Read a point
; HL: X
; DE: Y	
;	
Point_M1:		CALL	Get_Pixel_Address_M1
			LD 	A, (HL)
			EX	AF, AF
			Z80PORT	0x123B, %00000010	; Disable memory writes
			EX	AF, AF
			RET
;
Point_M2:		CALL	Get_Pixel_Address_M2
			LD 	A, (HL)
			EX	AF, AF
			Z80PORT	0x123B, %00000010	; Disable memory writes
			EX	AF, AF
			RET
;
Point_M3:		CALL	Get_Pixel_Address_M3
			LD	A, (HL)			; Fetch the byte
			JR	C, 1F 			; If right pixel then skip
			SWAPNIB				; Swap left pixel so its in right pixels nibble
1:			AND	0x0F 			; Mask out the pixel value
			EX	AF, AF 
			Z80PORT	0x123B, %00000010	; Disable memory writes
			EX	AF, AF
			RET
			
			RET

; Plot a point
; HL: Y
; DE: X
;
Plot_M3:		CALL	Adjust_SCRLPOS_P
			CALL	Get_Pixel_Address_M3
			LD	A, (PLOT_COLOUR)
			JR	C, 1F
			AND	0x0F			; Left hand pixel
			SWAPNIB		
			LD	E, A 
			LD	D, 0x0F			; Pixel mask
			JR	2F 
1:			AND	0x0F			; Right hand pixel
			LD	E, A 
			LD	D, 0xF0			; Pixel mask
			JR	2F 
;
Plot_M2:		CALL	Adjust_SCRLPOS_P
			CALL	Get_Pixel_Address_M2
			JR	1F
;
Plot_M1:		CALL	NEXT_GRAPHICS.NEXT_GRAPHICS_ULA.Adjust_SCRLPOS_P
			CALL	Get_Pixel_Address_M1
1:			LD	A, (PLOT_COLOUR)
			LD	E, A 
			LD	D, 0
2:			CALL	Plot
			Z80PORT	0x123B, %00000010	; Disable memory writes
			RET

; Write out the pixel data
; D: Mask
; E: Pixel data to write
;
Plot:			LD	A, (PLOT_MODE)		; Check plot mode is valid
			CP	7
			RET	NC			; Do nothing if plot mode >=7
			CALL	SWITCH_A
Plot_Table:		DEFW	Plot_SET
			DEFW	Plot_OR
			DEFW	Plot_AND
			DEFW	Plot_XOR
			DEFW	Plot_NOT
			DEFW	Plot_NOP
			DEFW	Plot_CLR

Plot_CLR:		LD	A, (HL)
			AND	D
			LD	(HL), A 
Plot_NOP:		RET
;
Plot_SET:		LD	A, (HL)
			AND	D
			OR	E
			LD	(HL), A
			RET
;
Plot_AND:		LD	A, (HL)
			AND	E
			LD	(HL), A
			RET 
;
Plot_OR:		LD	A, (HL)
			OR	E
			LD	(HL), A 
			RET
;
Plot_XOR:		LD	A, (HL)
			XOR	E
			LD	(HL), A 
			RET 
;
Plot_NOT:		LD	A, D 
			CPL
			XOR 	(HL)
			LD	(HL), A
			RET

; Draw Horizontal Line routine
; HL: Y coordinate
; BC: X pixel position 1
; DE: X pixel position 2
;
Draw_Horz_Line_M1:	CALL	NEXT_GRAPHICS.NEXT_GRAPHICS_ULA.Adjust_SCRLPOS_P
;
			LD	B, C 			; B: Low X1, E: Low X2
			LD	D, L 			; D: Low Y
;
			LD	A, B			; Check if E (X1) > B (X2)
			CP	E 
			JR	NC,0F
			LD 	B, E			; Swap B and D
			LD 	E, A		
0:			PUSH	BC 			; Stack colour and X2
			CALL	Get_Pixel_Address_M1	; Get pixel address
			POP	BC 
			LD	A, B 			; Calculate line length in bytes	
			SUB 	E 
			LD	B, A			; Length in B
			INC	B
			LD	A, (PLOT_COLOUR)
1:			LD	(HL), A			; Draw the line
			INC	L
			DJNZ	1B
			Z80PORT	0x123B, %00000010	; Disable memory writes
			RET
;
Draw_Horz_Line_M2:	CALL	Adjust_SCRLPOS_P
			PUSH	HL 			; Stack Y coordinate
			LD	H, B 			; HL: X1
			LD	L, C
			CP16	HL, DE 			; DE: X2
			JR	NC, 1F			; X1 - X2 is > 0
			EX	DE, HL			; Swap them
1:			SUB	HL, DE 			; HL: Line length
			EX	(SP), HL 		; Swap with Y coordinate on stack
			CALL	Get_Pixel_Address_M2
			LD	A, (PLOT_COLOUR)
			LD	D, A
			POP	BC			; Restore loop counter
			INC	BC
2:			LD	(HL), D
			INC	H 
			BIT	6, H 
			CALL	NZ, Next_Bank_M2M3
			DEC	BC 
			LD	A, B 
			OR	C 
			JR	NZ, 2B
			Z80PORT	0x123B, %00000010	; Disable memory writes
			RET 
;
Draw_Horz_Line_M3:	CALL	Adjust_SCRLPOS_P
			PUSH	HL 			; Stack Y coordinate
			LD	H, B 			; HL: X1
			LD	L, C
			CP16	HL, DE 			; DE: X2
			JR	NC, 1F			; X1 - X2 is > 0
			EX	DE, HL			; Swap them
1:			SUB	HL, DE 			; HL: Line length
			EX	(SP), HL 		; Swap with Y coordinate on stack
			CALL	Get_Pixel_Address_M3
			POP	BC			; Restore the loop counter
			INC	BC
			JR	NC, 2F			; If we're on even boundary then fine
;
			LD	A, (PLOT_COLOUR)	; Get the plot colour
			AND	0x0F
			LD	D, A 
			LD	A, (HL) 		; Write out the odd LSH nibble
			AND	0xF0	
			OR	D 
			LD	(HL), A					
			INC	H
			BIT	6, H
			CALL	NZ, Next_Bank_M2M3
			DEC	BC
;
2:			LD	A, (PLOT_COLOUR)	; Get the plot colour
			AND	0x0F
			LD	D, A 
			SWAPNIB
			OR	D 
			LD	D, A 			; D: Plot colour
;
;			POP	BC			; Restore the loop counter
			SRL	B			; Divide by 2		
			RR	C
			PUSH	AF			; Stack the carry bit
			LD	A, B 			; Check for 0
			OR	C 
			JR	Z, 4F
;
3:			LD	(HL), D 
			INC	H 
			BIT	6, H 
			CALL	NZ, Next_Bank_M2M3
			DEC	BC 			; TODO: Needs to do half this
			LD	A, B 
			OR	C
			JR	NZ, 3B
;
4:			POP	AF 			; Restore the carry bit
			JR	NC, 5F			; Is there a final pixel to plot?
			LD	A, D 			; Yes, we already have the plot colours in D
			AND	0xF0			; Just want it in top nibble
			LD	D, A 
			LD	A, (HL)
			AND	0x0F
			OR	D 
			LD	(HL), A
5:			Z80PORT	0x123B, %00000010	; Disable memory writes
			RET 

; Switch to the next bank
; HL: Screen addreses
;  E: Curent bank
;
Next_Bank_M2M3:		LD	H, 0			; Reset pixel pointer
			INC	E 			; Increment to next page
			PUSH	BC
			Z80PORT	0x123B, E
			Z80PORT	0x123B, %00000111
			POP	BC
			RET

; Set the graphics colour
;  C: Colour to set
;  B: Mode
;
Set_Plot_Colour:	
			LD	A, B
			CP	3
			JP	Z, NEXT_GRAPHICS.Set_Border
			LD	A, C
			LD	(PLOT_COLOUR), A 
			RET

; Set the text colour
;  C: Colour to set
;  B: Mode (ignored)
;
Set_Text_Colour:	LD 	A, B
			CP	4
			RET	NC
			CALL	SWITCH_A
			DEFW	Set_Text_Colour_All
			DEFW	Set_Text_Foreground
			DEFW	Set_Text_Background
			DEFW	NEXT_GRAPHICS.Set_Border

            ; Switch on A - lookup table immediately after call
;  A: Index into lookup table
;
SWITCH_A:		
            EX	(SP), HL		; Swap HL with the contents of the top of the stack
			ADD	A, A			; Multiply A by two
			ADD	HL, A 			; Index into the lookup table; this should immediately
			LD	A, (HL)			; follow the call. Fetch an address from the
			INC	HL 				; table.
			LD	H, (HL)
			LD	L, A
			EX	(SP), HL		; Swap this new address back, restores HL
			RET					; Return program control to this new address

Set_Text_Colour_All:	BIT	7, C
			JR	Z, Set_Text_Foreground
			RES	7, C
Set_Text_Background:	LD	A, C 
			LD	(TEXT_BACKGROUND), A 
			RET
Set_Text_Foreground:	LD	A, C 
			LD	(TEXT_FOREGROUND), A 
			RET 
        pop namspace
end asm 