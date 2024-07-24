'!ORG=24576

' FPlotL2 Example 
' em00k dec20
'#!copy=h:\FPlot2.nex
asm 
	  di 					;' I recommend ALWAYS disabling interrupts 
end asm 
#define NEX 				' This tells nextbuild we are making a final NEX and do not Load from SD 
							' with out you would need eachfile that is used with LoadSDBank
							' and must be before include <nextlib.bas>
#include <nextlib.bas>

border 0 

nextrega($7,3)					'; 28mhz 
nextrega($14,0)					'; black transparency 
nextrega($70,%00010000)			'; enable 320x256 256col L2 
nextrega($69,%10000000)			' enables L2 
nextrega(PALETTE_CONTROL_NR_43,%00010000)
ClipLayer2(0,255,0,255)			'; make all of L2 visible 

LoadSDBank("font1.spr",0,0,0,40) 	' load the first font to bank 40 

' FL2Text(0,0,"THIS EXAMPLE SHOWS THE FL2TEXT COMMAND",40)
' FL2Text(0,1,"THAT DRAWS TEXT WITH A FONT ON 320X256",40)
' FL2Text(0,5,"PRESS SPACE TO SEE A PLOT EXAMPLE",40)


dim px,py as uinteger 
dim pcol, color, cc, nc, b as ubyte 

color = 155 

LineL2(0,0,200,200)
for y=0 to 256
LineL2(00,y,319,0)
LineL2(0,255,319,255-y)
next y 
WaitKey()


t = 0
do 
    'this draws the moire type thing 

    for px = 0 to 319 'step 2
        ' PlotLine(px,0,160,128)
        LineL2(px,0,159,127)
        color = color + 1'
    next px 
    
    for py = 0 to 253 'step 2
        'PlotLine(319,py,160,128)
        LineL2(319,py,160,128)
        color = color + 1'+py
    next py 
    
    for px = 0 to 319 'step 2
    LineL2(319-px,254,160,128)
        'PlotLine(319-px,255,160,128)
        color = color + 1'+px 
    next px 

    for py = 0 to 254 'step 2
        'PlotLine(0,255-py,160,128)
        LineL2(0,255-py,160,128)
        color = color + 1'px band 63 
    next py 

 'for px = 0 to 253 step 2
' '    PlotLine2(px,0,128,100)        ' this can be used to test alternate method 
'     PlotLine(px,0,200,200)
     color = color + 3 
 'next px 

	' for py = 0 to 254 step 1
	' 	for px = 0 to 319 step 1 
    '     FPlot2New(py,px) 
	' 	next px 
	' next py 
    t =t + 1    
loop until t = 1
' poke @rainbow+0,255
' poke @rainbow+1,1
' poke @rainbow+2,255
' poke @rainbow+3,1
' for col = 4 to 511 step 8
' 	'for be=col to col+3
' 		poke @rainbow+col,0
' 		poke @rainbow+col+1,0
' 		poke @rainbow+col+2,0
' 		poke @rainbow+col+3,0
' 		poke @rainbow+col+4,0
' 		poke @rainbow+col+5,0
' 		poke @rainbow+col+6,0
' 		poke @rainbow+col+7,0
' 	'next 
' Next 
do 
    WaitRetrace2(224)
	PalUpload(@rainbow, nc,b)
	'NextReg($40,0) : NextReg($44,0) : NextReg($44,0)
	'if b>2 : 
	b=b-2 ': else : b = 254 : endif 
	cc=cc+1 ': b=b-2 : if b = 0 : b = 254 : endif 
	if cc=255
		if nc = 16
			nc = 32
		elseif nc = 32
	'		nc = 0
		elseif nc = 0
	'		nc = 16
		endif 
	endif 
   
loop 


sub PlotLine2(x0 as integer, y0 as integer, x1 as integer, y1 as integer)
    ' alternate all in one method smaller method but slower
    '

    dx =  abs(x1-x0) 
    if x0<x1
        sx = 1 
    else 
        sx = -1
    endif 
    dy = -abs(y1-y0)  
    if y0<y1
        sy = 1 
    else 
        sy = -1
    endif 
    err = dx+dy
    do 
    FPlot2New(cast(uinteger,y0),cast(uinteger,x0))
        if (x0 = x1 and y0 = y1) : exit do : end if 
        e2 = err<<1
        if (e2 >= dy) 
            err = err + dy
            x0 = x0 + sx
            color = x0 
        end if
        if (e2 <= dx)
            err = err + dx
            y0 = y0 + sy
            color = y0
        end if
    loop 
end sub 

sub fastcall FPlot2New(y as uinteger,x as uinteger)

asm 
                ; BREAK 
                exx : pop hl : exx 
                di 
    Get_Pixel_Address_M2:	
                pop de 
                ; ex de,hl 
                LD	A, E			; Get the X coordinate
                AND	0x3F			; Offset in bank
                LD	H, A			; Store in high byte
                LD	B, 6 
                BSRA 	DE, B 			
                LD	A, E			; Get the X coordinate
                OR	%00010000
                LD	E, A
                ld bc,$123b 
                out (c),a
;                Z80PRTA	0x123B
                ld a,%00000111
                out (c),a 
;                Z80PORT	0x123B, %00000111	; Enable memory read/write 
                LD	A, (._color)
                LD	E, A 
                LD	D, 0
                LD	A, (HL)
                AND	D
                OR	E
                LD	(HL), A
;                Z80PORT	0x123B, %00000010	; Disable memory writes
                ld a,%00000010
                out (c),a 
                exx : push hl : exx 
                
    end asm 

end sub 


sub PlotLine(plinex as integer,plineya as integer,plinew as integer,pliney as integer )
    ' PlotLine x1,y1,x2,y2 
    ' 
    if abs(pliney - plineya) < abs(plinew - plinex)
        if plinex > plinew
            PlotLinelow(plinew, pliney, plinex, plineya)
        else
            PlotLinelow(plinex, plineya, plinew, pliney)
        end if
    else
        if plineya > pliney
            PlotLinehigh(plinew, pliney, plinex, plineya)
        else
            PlotLinehigh(plinex, plineya, plinew, pliney)
        end if
    end if
end sub 


sub PlotLinelow(plinex as integer,plineya as integer,plinew as integer,pliney as integer )
    ' used byte PlotLine

	plinedx=plinew-plinex
	plinedy=pliney-plineya

	if plinedy<0
		plinefi=-1
		plinedy=-plinedy
    else  
        plinefi=1
	endif 

	plineD=(plinedy<<1)-plinedx
	plineyb=plineya

	for x = plinex to plinew

		' FPlotL2(cast(ubyte,plineyb),cast(uinteger,x),color)
        FPlot2New(cast(uinteger,plineyb),cast(uinteger,x))
		if plineD > 0
            plineyb = plineyb + plinefi
            plineD = plineD - (plinedx<<1)
		endif

		plineD=plineD+(plinedy<<1)

	next 

end sub

sub PlotLinehigh(plinex as integer,plineya as integer,plinew as integer,pliney as integer )
    ' used byte PlotLine

	plinedx=plinew-plinex
	plinedy=pliney-plineya

	if plinedx<0
		plinexi=-1
		plinedx=-plinedx
    else 
        plinexi=1
	endif 

	plineD=(plinedx<<1)-plinedy
	plinexb=plinex

	for plineyb = plineya to pliney

		' FPlotL2(cast(ubyte,plineyb),cast(uinteger,plinexb),color)
        FPlot2New(cast(uinteger,plineyb),cast(uinteger,plinexb))
		if plineD > 0
            plinexb = plinexb + plinexi
            plineD = plineD - (plinedy<<1)
        endif
		plineD=plineD+(plinedx<<1)
	next 

end sub

sub fastcall LineL2(X1 as uinteger, Y1 as uinteger, X2 as uinteger, Y2 as uinteger)

    asm 
    ; ----------------------------------------------------------------------------
    ; Graphics Primitives
    ; ----------------------------------------------------------------------------
; Draw a line using Bresenham's Incremental Line algorithm
    ; Author:	Dean Belfield 12/07/2021
    ; Mangled for Boriel ZX Basic em00k 2021
    ; 
    ; PLOTPOS_X: X pixel position 1
    ; PLOTPOS_Y: Y pixel position 1
    ; DE : X pixel position 2
    ; HL : Y pixel position 2
    ; 
    ; BC : Loop counter
    ; HL': Error value for Bresenhams
    ; DE': Line height
    ; BC': Line width
    ; R00: X step
    ; R02: Y step
    ;

    ; setup for zxb 
    
    ex (sp),hl                  ; swap hl + stack
    ld (stackreturn+1),hl         ; save ret address 
    pop de  
    ld (PLOTPOS_X),de 
    pop hl 
    ld (PLOTPOS_Y),hl 
    ; call Pixel_Bounds_Check
    pop de                      ; get x2 
    pop hl                      ; get y2 
    call Primitive_Line 
    

stackreturn:
    ld hl,0
    push hl 
    
    ret  

    Primitive_Line:		 
            ; ex (sp),hl 

            PUSH	HL			; Stack Y2
            PUSH	DE			; Stack X2
            EXX				; Switch to alternative registers
    ;       
            POP	HL			; Get X2
            LD	BC, (PLOTPOS_X)		; Get X1
            ; SUB	HL, BC 			; Get width in HL
            or a : sbc hl,bc 

            LD	BC, 1
            JP	P, skipneg

            ; NEG16	HL

            xor a 
            sub l 
            ld l,a 
            sbc a,a 
            sub h 
            ld h,a 

            LD	BC, -1 
    skipneg:			
             
            LD	(R00), BC 		; Horizontal line direction
            EX	DE, HL			; DE': Width
    ;
            POP	HL			; Get Y2
            LD	BC, (PLOTPOS_Y)		; Get Y1
            ; SUB	HL, BC 			; HL': Height
            or a 
            sbc hl,bc 

            LD	BC, 1 
            JP	P, skipneg2

            ; NEG16	HL 
            
            xor a 
            sub l 
            ld l,a 
            sbc a,a 
            sub h 
            ld h,a 

            LD	BC, -1

    skipneg2:			
            LD	(R02), BC		; Vertical line direction
    ;
            LD	A,H			; Check for zero length line
            OR	L 
            OR	E
            OR	D 
            RET	Z
    ;
            ; CP16	HL, DE			; Work out which diagonal we are on
            or a 
            sbc hl,de 
            add hl,de 

            JR	NC, Primitive_Line_Q2	; Height > Width, so jump to Q2
            EX 	DE, HL			; Swap width and height and use Q1
    ;
    ; This bit of code draws the line where BC>DE (more horizontal than vertical)
    ;		
    Primitive_Line_Q1:	
            CALL	Primitive_Line_Init

    PrimlineStart:
    		PUSH	BC
            CALL	Primitive_Line_Plot
            EXX				            ; Switch to main registers
            JR	NC, SkipADDBC
            LD	BC, (R02)		                ; Increment Y
            ADD	HL, BC
    SkipADDBC:
            EX	DE, HL
            LD	BC, (R00)
            ADD	HL, BC 
            EX	DE, HL
            POP	BC
            DJNZ	PrimlineStart 			; Loop
            DEC	C 
            JR	NZ, PrimlineStart
            JP	Plot_Point
    ;
    ; This bit of code draws the line where BC<=DE (more vertical than horizontal)
    ;
    Primitive_Line_Q2:	
            CALL	Primitive_Line_Init
            PUSH	BC
            CALL	Primitive_Line_Plot
            EXX				                ; Switch to main registers
            JR	NC, PrimlineYInc
            EX	DE, HL 			            ; Increment X
            LD	BC, (R00)
            ADD	HL, BC 
            EX 	DE, HL
    PrimlineYInc:
            LD	BC, (R02)		            ; Increment Y
            ADD	HL, BC
            POP	BC
            DJNZ	Primitive_Line_Q2 			; Loop
            DEC	C 
            JR	NZ, Primitive_Line_Q2
            JP	Plot_Point
    ;
    ; Initialise the line routine
    ;
    Primitive_Line_Init:	
            PUSH	HL			; Push line dimension	
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
    Primitive_Line_Plot:	

            PUSH	DE 
            PUSH	HL
            
            CALL	Plot_Point
            POP	HL
            POP	DE
            EXX 				; Switch to alternative registers
            ; SUB	HL, DE			; Subtract the line height from the error (HL = HL - DE)
            or a 
            sbc hl,de

            RET	NC
            ADD	HL, BC			; Add the line width to the error (HL = HL + BC)
            RET 				; C set at this point
Plot_Point:
            
            LD	A, E			; Get the X coordinate
            AND	0x3F			; Offset in bank
            LD	H, A			; Store in high byte
            LD	B, 6 
            BSRA 	DE, B 			
            LD	A, E			; Get the X coordinate
            OR	%00010000
            LD	E, A
            ld bc,$123b 
            out (c),a
        ;                Z80PRTA	0x123B
            ld a,%00000111
            out (c),a 
        ;                Z80PORT	0x123B, %00000111	; Enable memory read/write 
            LD	A, (._color)
            LD	E, A 
            LD	D, 0
            LD	A, (HL)
            AND	D
            OR	E
            LD	(HL), A
        ;                Z80PORT	0x123B, %00000010	; Disable memory writes
            ld a,%00000010
            out (c),a 
            ret 
Pixel_Bounds_Check:	
            LD	A, D			; If either of the high bytes
			OR	H 			; are negative, then
			ADD	A, A			; the pixel is out of bounds
			CCF
			RET	NC
			LD	BC, (PIXEL_HEIGHT)	; Now do a screen bounds
			; CP16	HL, BC 			; comparison on the Y
            or a 
            sbc hl, bc 
            add hl,bc 

			RET	NC 
			EX	DE, HL			; And now the X
			LD	BC, (PIXEL_WIDTH)
			; CP16	HL, BC 
            or a 
            sbc hl, bc 
            add hl,bc 
			EX	DE, HL
			RET

PLOTPOS_X:      dw 00
PLOTPOS_Y:      dw 00
R00:            db 0 
R01:            db 0 
R02:            db 0 
R03:            db 0 
PIXEL_HEIGHT:   dw 256
PIXEL_WIDTH:    dw 320

    end asm 
end sub 

rainbow: 
asm 
	incbin "rainbow.pal" 
	incbin "rainbow.pal" 
end asm    