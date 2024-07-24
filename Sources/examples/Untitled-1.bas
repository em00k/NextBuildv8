; ----------------------------------------------------------------------------
; Graphics Primitives
; ----------------------------------------------------------------------------

; Draw a line using Bresenham's Incremental Line algorithm
;
; PLOTPOS_X: X pixel position 1
; PLOTPOS_Y: Y pixel position 1
;
; DE : X pixel position 2
; HL : Y pixel position 2
; BC : Loop counter
; HL': Error value for Bresenhams
; DE': Line height
; BC': Line width
; R00: X step
; R02: Y step
;
Primitive_Line:		PUSH	HL			; Stack Y2
			PUSH	DE			; Stack X2
			EXX				; Switch to alternative registers
;
			POP	HL			; Get X2
			LD	BC, (PLOTPOS_X)		; Get X1
			SUB	HL, BC 			; Get width in HL
			LD	BC, 1
			JP	P, 1F
            
			NEG16	HL
			LD	BC, -1 
1:			LD	(R00), BC 		; Horizontal line direction
			EX	DE, HL			; DE': Width
;
			POP	HL			; Get Y2
			LD	BC, (PLOTPOS_Y)		; Get Y1
			SUB	HL, BC 			; HL': Height
			LD	BC, 1 
			JP	P, 2F
			NEG16	HL 
			LD	BC, -1
2:			LD	(R02), BC		; Vertical line direction
;
			LD	A,H			; Check for zero length line
			OR	L 
			OR	E
			OR	D 
			RET	Z
;
			CP16	HL, DE			; Work out which diagonal we are on
			JR	NC, Primitive_Line_Q2	; Height > Width, so jump to Q2
			EX 	DE, HL			; Swap width and height and use Q1
;
; This bit of code draws the line where BC>DE (more horizontal than vertical)
;		
Primitive_Line_Q1:	CALL	Primitive_Line_Init
1:			PUSH	BC
			CALL	Primitive_Line_Plot
			EXX				; Switch to main registers
			JR	NC, 2F
			LD	BC, (R02)		; Increment Y
			ADD	HL, BC
2:			EX	DE, HL
			LD	BC, (R00)
			ADD	HL, BC 
			EX	DE, HL
			POP	BC
			DJNZ	1B 			; Loop
			DEC	C 
			JR	NZ, 1B
			JP	Plot_Point
;
; This bit of code draws the line where BC<=DE (more vertical than horizontal)
;
Primitive_Line_Q2:	CALL	Primitive_Line_Init
1:			PUSH	BC
			CALL	Primitive_Line_Plot
			EXX				; Switch to main registers
			JR	NC, 2F
			EX	DE, HL 			; Increment X
			LD	BC, (R00)
			ADD	HL, BC 
			EX 	DE, HL
2:			LD	BC, (R02)		; Increment Y
			ADD	HL, BC
			POP	BC
			DJNZ	1B 			; Loop
			DEC	C 
			JR	NZ, 1B
			JP	Plot_Point
;
; Initialise the line routine
;
Primitive_Line_Init:	PUSH	HL			; Push line dimension	
			LD	B, H			; BC': Width
			LD	C, L
			SRL	H 			; HL': Error value for Bresenhams
			RR 	L
			EXX 				; Switch to main registers
			LD	DE, (PLOTPOS_X)		; Starting point
			LD	HL, (PLOTPOS_Y)
			POP	BC			; BC: Loop counter
			LD	A, C 			; Adjust so that it will
			DEC	BC 			; work with a DJNZ/DEC loop
			INC	B
			LD	C, B 
			LD	B, A
			RET
;
; Plot the point and run the Bresenham's algorithm
;
Primitive_Line_Plot:	PUSH	DE 
			PUSH	HL
			CALL	Plot_Point
			POP	HL
			POP	DE
			EXX 				; Switch to alternative registers
			SUB	HL, DE			; Subtract the line height from the error (HL = HL - DE)
			RET	NC
			ADD	HL, BC			; Add the line width to the error (HL = HL + BC)
			RET 				; C set at this point
