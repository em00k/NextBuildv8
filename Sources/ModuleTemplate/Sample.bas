'!org=57344	
'!opt=4
'!heap=1024
' ------------------------------------------------------------------------------
' - BankManager Sample v.2.0 ---------------------------------------------------
' ------------------------------------------------------------------------------
' - Main module ----------------------------------------------------------------
' ------------------------------------------------------------------------------

' ORG 57344 - $E000
' Fixed bank located at $E000 to $ffff
' Usable memory from $e000 to $ffff minus heap size


' 1024 bytes reserved for variables @ $4000 bank 24
' VarAddress located at $4000

' ULA is paged out and banks 24/25 live in slots 2&3
' For tilemap functions the relevants pages are put back 

' - Includes -------------------------------------------------------------------
#define NOSP 
#define DEBUG  
#define NEX 
#include <nextlib.bas>
#include "Common.bas"

' - Populate RAM banks for generating a NEX ------------------------------------
LoadSDBank("font8.spr",0,0,0,40)
LoadSDBank("font10.spr",0,0,0,41)
LoadSDBank("font4.spr",0,0,0,42)
LoadSDBank("bonky.spr",0,0,0,43)

asm 
	di 
end asm 

Main()

' Main entry

Sub Main()
	' Initialization here...
	asm 
		; nextreg DISPLAY_CONTROL_NR_69,%01000000
		di 
		nextreg TURBO_CONTROL_NR_07,%00000011		; 28Mhz 
		nextreg SPRITE_CONTROL_NR_15,%000_001_00
		nextreg MMU2_4000_NR_52,24					; fresh banks		
		nextreg MMU3_6000_NR_53,25					; fresh banks 
		; wipe ram 
		ld 		hl,$4000 
		ld 		de,$4001 
		ld 		hl,(0)
		ld 		bc,$7d00 
		ldir 	
	end asm 

	' Start with module 1 
	SetLoadModule(ModuleSample2,0,0)
	
	' proceeding modules will chain 
MainBucle:

	ExecModule(VarLoadModule)
	GOTO MainBucle

END sub

' Execute module id
Sub ExecModule(id as ubyte)

	dim file as string 

	common$=NStr(VarLoadModule)					' get the module to load

	file="module"+common$(2 to )+".bin"			' combine in string 

	LoadSD(file,24576,$7d00,0)					' load from SD to $6000

	asm 
		; call the routine
		ld 		(execmodule_end+1),sp 			; ensure stack is always balanced 
		call 	24576
	execmodule_end:
		ld		sp,00000
	end asm 

end sub
