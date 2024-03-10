Global file$ = "amomundo.scr"


If ReadFile(0,file$)
  
  *buffer = AllocateMemory(Lof(0))
  lenth = Lof(0)

  Debug "File Size : "+ Hex(lenth)
  
  If ReadData(0,*buffer,lenth)
    
    a = 255
    
    For c = 0 To 6912
      
      d = PeekA(*buffer+c)
      a = a ! d
      
    Next c
    ShowMemoryViewer(*buffer,6912)
    Debug "checksum : " + Str(a)
  Else 
    Debug "Failed to read data to buffer"
    
    CloseFile(0)
  EndIf 
Else
  Debug "Error opening "+file$
  End 
EndIf

FreeMemory(*buffer)

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 14
; EnableXP
; EnablePurifier