' ----------------------------------------------------------------
' This file is released under the MIT License
' 
' Copyleft (k) 2008
' by Jose Rodriguez-Rosa (a.k.a. Boriel) <http://www.boriel.com>
'
' Simple INPUT routine (not as powerful as Sinclair BASIC's), but
' this one uses PRINT42 routine
' Usage: A$ = INPUT42(MaxChars)
' ----------------------------------------------------------------
#ifndef __LIBRARY_INPUT42__

REM Avoid recursive / multiple inclusion

#define __LIBRARY_INPUT42__

REM The input subroutine
REM DOES NOT act like ZX Spectrum INPUT command
REM Uses ZX SPECTRUM ROM

#include once <pos.bas>
#include once <csrlin.bas>
#include once <print42.bas>

#pragma push(case_insensitive)
#pragma case_insensitive = True

FUNCTION input42(MaxLen AS UINTEGER, INPUTSTR as STRING="") AS STRING
    CONST FlagsAddress AS uInteger = 23611
    CONST LastKAddress AS uInteger = 23560
	DIM LastK AS UBYTE AT LastKAddress: REM LAST_K System VAR
	DIM result$,fsplt$,bsplt$ AS STRING
	DIM i as UINTEGER
    dim xpos,p as ubyte 
    DIM input_time,input_on as ubyte 
    DIM tmp as UByte
    LET tmp = PEEK FlagsAddress
    POKE FlagsAddress, PEEK FlagsAddress bOR 8 : REM sets FLAGS var to L mode

	result$ = ""

    IF INPUTSTR$<>"" 
        result$ = INPUTSTR$
        'printat42(0,0)
        PRINT42 result$
        xpos = len(result$)
    ENDIF 

    ' POKE 23611, PEEK 23611 bOR 8
	
	DO
		PRIVATEInputShowCursor42()

		REM Wait for a Key Press
		LastK = 0

		DO  
          
            if input_time > 0                       ' process the cursor flash 
                input_time = input_time - 1 
                
            elseif input_time=0 
                input_on = 1 - input_on 
                input_time = 10 
            endif 

            if input_on = 0 
                PRIVATEInputShowCursor42()                
            else 
                PRIVATEInputHideCursor42()
            endif 
            
            WaitRetrace(1)                          ' wait at least a frame
        LOOP UNTIL (PEEK (LastKAddress)) <> 0

		PRIVATEInputHideCursor42()

		IF LastK = 12 THEN                              ' backspace 
			IF LEN(result$) THEN                        ' "Del" key code is 12
				IF LEN(result$) = 1 THEN                ' if string only has 1 char, then del will 
					LET result$ = ""                    ' make the string = ""
                    xpos = 0                            ' reset the xpos to position 0
				ELSE
                    if xpos = LEN(result$)              ' is xpos is the same length as the string 
                        LET result$ = result$( TO LEN(result$) - 2)	    ' do a delete from the end of the string
                        xpos = xpos - 1                             ' decrease xpos
                    elseif xpos > 1                    ' if xpos is larger that 1   xpos > [-X------]
                        
                        xpos = xpos - 1                 ' decrease xpos 
                        result$ = result$( TO (xpos-1)) + result$(xpos+1 TO ) 	
                        fsplt$=result$( TO (xpos+1)) 	
                        bsplt$=result$(xpos+1 TO )+CHR$(8) 	
                        p = 1
                    elseif xpos = 1  
                        xpos = xpos - 1
                        result$ = result$(xpos+1 TO )
                        p = 1
                    endif
				END IF

                printat42(21,0)  
                PRINT42 result$  

			END IF
            beep .01,2
		ELSEIF LastK >= CODE(" ") AND LEN(result$) < MaxLen THEN
            if LastK = 203
                LastK = 127
            endif 
            if xpos = LEN(result$)
                result$ = result$ + CHR$(LastK)
                PRINT42 CHR$(LastK)
                xpos = xpos + 1 
            elseif xpos>0
                result$ = result$( TO (xpos-1)) + CHR$(LastK) + result$(xpos TO ) 	
                fsplt$=result$( TO (xpos)) 	
                bsplt$=result$(xpos+1 TO ) 	
                'printat42x(0)            
                printat42(21,0)  
                PRINT42 fsplt$ + "_" + bsplt$
                xpos = xpos + 1 
            else 
               ' border 6         
                result$ = CHR$(LastK) +result$
                'printat42x(0)            
                printat42(21,0)  
                PRINT42 "_" + result$
                'xpos = xpos + 1 
                p = 1
            endif 

            beep .01,2
            
        ELSEIF LastK = 8               ' cursor left 

            if xpos > 0 : xpos = xpos - 1 : endif 
            p = 1 

        ELSEIF LastK = 9 AND xpos < LEN(result$)               ' cursor right

            if xpos < len(result$) : xpos = xpos + 1 : endif 
            p =  1
        ELSEIF LastK = 9 AND xpos = LEN(result$)               ' cursor right
            
            p = 1 
		END IF

        if p = 1 
            if xpos > 0 
                fsplt$=result$( TO (xpos - 1 )) 	
                bsplt$=result$(xpos TO ) 	
                result$ = fsplt$ + bsplt$	    
            endif 

            ' print at 2,0;fsplt$;"   "
            ' print at 3,0;bsplt$;"    "
            printat42(21,0)  
            'printat42x(0)

            if xpos = LEN(result$) 
                PRINT42 result$
            elseif xpos >0 
                PRINT42 fsplt$ + "_" + bsplt$ 
            else
                PRINT42 "_"+result$
            endif 
            p = 0
        endif 

        ' print at 2,0;fsplt$;"   "
        ' print at 3,0;bsplt$;"    "
        ' print xpos 
        ' print LEN(result$)
        ' print LastK;" "

	LOOP UNTIL LastK = 13 : REM "Enter" key code is 13
    beep .01,8
    POKE FlagsAddress, tmp : REM resets FLAGS var

	FOR i = 1 TO LEN(result$):
		PRINT42 CHR$(8) + " " + CHR$(8)
	NEXT
	
	RETURN result$

END FUNCTION

#pragma pop(case_insensitive)

' ------------------------------------------------------------------
' Function 'PRIVATE' to this module.
' Shows a flashing cursor
' ------------------------------------------------------------------
SUB FASTCALL PRIVATEInputShowCursor42
	REM Print a Flashing cursor at current print position
	OVER 1:ink 2: PRINT42 ">" + CHR$(8): ink 0:OVER 0 :
END SUB


' ------------------------------------------------------------------
' Function 'PRIVATE' to this module.
' Hides the flashing cursor
' ------------------------------------------------------------------
SUB FASTCALL PRIVATEInputHideCursor42
	REM Print a Flashing cursor at current print position
	OVER 0: ink 0 : PRINT42 " " + CHR$(8)
END SUB

#endif

