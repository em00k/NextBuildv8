If CreateRegularExpression(0, "\t?") ; 
EndIf
If CreateRegularExpression(1, "(>=|<=|<>|<|>|=)")
EndIf
blockout$=""
; If ReadFile(0,"C:\NextBuildv7\Tools\regdefines.txt")
;   
;   While Not Eof(0)
;     line$=ReadString(0)
;     ; Debug line$
;     name$=StringField(line$,1,#TAB$) 
;   ;  Debug "Name : "+name$
;     middle$=StringField(line$,2,#TAB$)
;   ;  Debug "Equ  : "+middle$
;     value$=StringField(line$,3,#TAB$)
;   ;  Debug "Value: "+value$
;     
;     If LCase(middle$)="equ"
;       blockout$+#TAB$+#TAB$+","+#CRLF$
;       blockout$+#TAB$+#TAB$+"{"+#CRLF$
;       blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"description"+#DQUOTE$+": "+#DQUOTE$+name$+" = "+value$
;       blockout$+"\n\nMore info : https://wiki.specnext.dev/Board_feature_control"
;       blockout$+"\n\nRequires: \n\n\t#INCLUDE <nextlib.bas>\n\n"+#DQUOTE$+","+#CRLF$
;       blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"token"+#DQUOTE$+": "+#DQUOTE$+name$+#DQUOTE$+","+#CRLF$
;       blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"syntax"+#DQUOTE$+": "+#DQUOTE$+name$+" = "+value$+#DQUOTE$+#CRLF$
;       blockout$+#TAB$+#TAB$+"}"+#CRLF$
; 
;       
;      ; Debug blockout$
;       Debug "Processed : "+name$+" as "+value$
;       ;SetClipboardText(blockout$)
;     Else 
;       Debug "debug ignored " + line$
;     EndIf 
;     ;   
;     ;   blockout$=#TAB$+","+#CRLF$
;     ;   blockout$+#TAB$+#TAB$+#DQUOTE$+"LAYER2_RAM_SHADOW_BANK_NR_13"+#DQUOTE$+": {"+#CRLF$
;     ;   blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"prefix"+#DQUOTE$+": "+#DQUOTE$+"LAYER2_RAM_SHADOW_BANK_NR_13"+#DQUOTE$+","+#CRLF$
;     ;   blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"body"+#DQUOTE$+": ["+#CRLF$
;     ;   blockout$+#TAB$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"LAYER2_RAM_SHADOW_BANK_NR_13"+#DQUOTE$+#CRLF$
;     ;   blockout$+#TAB$+#TAB$+#TAB$+"],"+#CRLF$
;     ;   blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"description"+#DQUOTE$+": "+#DQUOTE$+"CONST LAYER2_RAM_SHADOW_BANK_NR_13    equ $13"+#DQUOTE$+#CRLF$
;     ;   blockout$+#TAB$+#TAB$+"}"+#CRLF$
;     ;   
;   Wend 
;   CloseFile(0)
;   If CreateFile(0,"C:\NextBuildv7\Tools\output2.txt")
;     WriteString(0,blockout$)
;     CloseFile(0)
;   Else
;     Debug "failed to save"
;   EndIf
;   
; EndIf
If ReadFile(0,"C:\NextBuildv7\Tools\2output.txt")
  
  While Not Eof(0)
    line$=ReadString(0)
    ; Debug line$
;     name$=StringField(line$,1,#TAB$) 
;    Debug "Name : "+name$
;     middle$=StringField(line$,2,#TAB$)
;    Debug "Equ  : "+middle$
;     value$=StringField(line$,3,#TAB$)
;     comment$ = 
  ;  Debug "Value: "+value$
    
    If Left(Trim(line$," "),1)<>"'"
      ;blockout$+"#deinf "+name$+" as ubyte ="+value$+#CRLF$
      If Len(line$)
        blockout$+"#define "+line$+" "+#CRLF$
        EndIf 
      ;Debug blockout$
      Debug "Processed : "+name$
      ;SetClipboardText(blockout$)
    Else 
      blockout$+line$+" "+#CRLF$
   EndIf 
    ;   
    ;   blockout$=#TAB$+","+#CRLF$
    ;   blockout$+#TAB$+#TAB$+#DQUOTE$+"LAYER2_RAM_SHADOW_BANK_NR_13"+#DQUOTE$+": {"+#CRLF$
    ;   blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"prefix"+#DQUOTE$+": "+#DQUOTE$+"LAYER2_RAM_SHADOW_BANK_NR_13"+#DQUOTE$+","+#CRLF$
    ;   blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"body"+#DQUOTE$+": ["+#CRLF$
    ;   blockout$+#TAB$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"LAYER2_RAM_SHADOW_BANK_NR_13"+#DQUOTE$+#CRLF$
    ;   blockout$+#TAB$+#TAB$+#TAB$+"],"+#CRLF$
    ;   blockout$+#TAB$+#TAB$+#TAB$+#DQUOTE$+"description"+#DQUOTE$+": "+#DQUOTE$+"CONST LAYER2_RAM_SHADOW_BANK_NR_13    equ $13"+#DQUOTE$+#CRLF$
    ;   blockout$+#TAB$+#TAB$+"}"+#CRLF$
    ;   
  Wend 
  CloseFile(0)
  If CreateFile(0,"C:\NextBuildv7\Tools\3output.txt")
    WriteString(0,blockout$)
    CloseFile(0)
  Else
    Debug "failed to save"
  EndIf
  
EndIf


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 67
; FirstLine = 43
; EnableXP