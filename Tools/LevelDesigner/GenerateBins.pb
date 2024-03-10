
If CreateFile(0,"8kilo.bin")
  While size <8192
    WriteAsciiCharacter(0,(size & 255))
    size + 1 
  Wend
  CloseFile(0)
EndIf

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 3
; EnableXP