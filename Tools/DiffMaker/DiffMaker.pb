XIncludeFile "DiffGUI.pbf"

; diff maker 

Global *source_buffer  = AllocateMemory(256)     ; buffer for source frame
Global *compare_buffer = AllocateMemory(256)     ; buffer for compare frame 
Global *dif_buffer     = AllocateMemory(256)     ; store the diff Data.a frame

Global frames   = 20

; populate the buffers

CopyMemory(?Sprite1,*source_buffer,256)
CopyMemory(?Sprite2,*compare_buffer,256)

ShowMemoryViewer(*compare_buffer,256)

Procedure CompareBuffers()
  ; compare source + compare buffers 
  
  For offset      = 0 To 255 
    
    source_byte.a   = PeekA(*source_buffer+offset) 
    compare_byte.a  = PeekA(*compare_buffer+offset) 
    
    If source_byte <> compare_byte
      Debug "Address offset : " + Str(offset)
      Debug "Difference     : " + Str(source_byte)  + " > " + Str(compare_byte)+"  > "+ Str((source_byte-compare_byte) & 255 )
      differences + 1
      PokeA(*dif_buffer+offset,150)
    Else
      PokeA(*dif_buffer+offset,0)
    EndIf 
    
    
  Next 
EndProcedure

Debug "Total differences : " + Str(differences)



Procedure DrawBuffers()
  
  Shared r, g, b 
  
  ; draw the source buffer on source canvas
  
  width   = 16 
  height  = 16 
  offset  = 0 
  scale   = 8 
  
  StartDrawing(CanvasOutput(Canvas_0))
  
  For y = 0 To height - 1
    For x = 0 To width - 1 
      
      pixel   = PeekA(*source_buffer+offset) 
      
      r = PeekA(?LUT3BITTO8BIT+(pixel >> 5))
      g = PeekA(?LUT3BITTO8BIT+(pixel >> 2) & 7)
      b = PeekA(?LUT2BITTO8BIT+(pixel & 3))
      
      Box(  x*scale,  y*scale,  scale,  scale, RGB(r,g,b))
      
      offset + 1 
      
    Next x 
  Next y 
  
  StopDrawing()
  
  StartDrawing(CanvasOutput(Canvas_1))
  
  offset = 0 
  
  For y = 0 To height - 1
    For x = 0 To width - 1 
      
      pixel   = PeekA(*compare_buffer+offset) 
      
      r = PeekA(?LUT3BITTO8BIT+(pixel >> 5))
      g = PeekA(?LUT3BITTO8BIT+(pixel >> 2) & 7)
      b = PeekA(?LUT2BITTO8BIT+(pixel & 3))
      
      Box(  x*scale,  y*scale,  scale,  scale, RGB(r,g,b))
      
      offset + 1 
      
    Next x 
  Next y 
  
  StopDrawing()
  
    StartDrawing(CanvasOutput(Canvas_2))
  
  offset = 0 
  
  For y = 0 To height - 1
    For x = 0 To width - 1 
      
      pixel   = PeekA(*dif_buffer+offset) 
      
      r = PeekA(?LUT3BITTO8BIT+(pixel >> 5))
      g = PeekA(?LUT3BITTO8BIT+(pixel >> 2) & 7)
      b = PeekA(?LUT2BITTO8BIT+(pixel & 3))
      
      Box(  x*scale,  y*scale,  scale,  scale, RGB(r,g,b))
      
      offset + 1 
      
    Next x 
  Next y 
  
  StopDrawing()
  
EndProcedure

Procedure Window_1_Events(event)
  Select event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False
      
    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget()
        Case Button_0
          CompareBuffers()
      EndSelect
  EndSelect
  ProcedureReturn #True
EndProcedure

Procedure Setup()
  OpenWindow_1()
  CompareBuffers()
  DrawBuffers()
EndProcedure

; call setup 

Setup()

; Main loop 

Repeat
  
  result = Window_1_Events(WaitWindowEvent())
  
Until result = #False



DataSection:
  Sprite1:
  Data.a  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $FD, $FD, $FF, $FD, $F4, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $FD, $F4, $A8, $A8, $A8, $A8, $F4, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $FD, $F4, $A8, $ED, $FE, $ED, $FE, $A8, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $F4, $EC, $E3, $FE, $F2, $0B, $F2, $0B, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $EC, $E4, $E3, $ED, $F2, $F2, $FB, $F2, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $ED, $FE, $FE, $F2, $FE, $FE, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $A0, $ED, $ED, $ED, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $F4, $A0, $A0, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $F4, $FD, $FD, $FD, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $F4, $FD, $EC, $FD, $FD, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $F2, $F2, $EC, $FD, $FD, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $F2, $EC, $FD, $FD, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $EC, $F4, $F4, $FD, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $E3, $ED, $F2, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $EC, $F9, $F9, $F9, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  
  
  
  Sprite2:
  Data.a  $E3, $F4, $EC, $00, $00, $FD, $FD, $FF, $FD, $F4, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $EC, $E4, $F4, $FD, $F4, $A8, $A8, $A8, $A8, $F4, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $F4, $A8, $ED, $FE, $ED, $FE, $A8, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $FE, $F2, $0B, $F2, $0B, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $ED, $FE, $F2, $FB, $F2, $FE, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $ED, $F2, $FE, $F2, $FE, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $A0, $ED, $ED, $ED, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $F4, $FD, $A0, $A0, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $F4, $FD, $FD, $F4, $FD, $FF, $A0, $F2, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $ED, $F2, $A0, $F4, $FD, $FD, $A0, $ED, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $F2, $F2, $A0, $F4, $FD, $FD, $E3, $E3, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $EC, $EC, $F4, $FD, $FD, $E3, $F9, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $F9, $F2, $F4, $EC, $E3, $F4, $F2, $F2, $F9, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $F9, $ED, $ED, $E3, $E3, $E3, $ED, $F9, $EC, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $EC, $F9, $E3, $E3, $E3, $E3, $E3, $EC, $E3, $E3, $E3, $E3, $E3
  Data.a  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
EndDataSection

DataSection: 
  LUT3BITTO8BIT:
  Data.a 0,$24,$49,$6D,$92,$B6,$DB,$FF
  LUT2BITTO8BIT:
  Data.a 0,$55,$AA,$FF
EndDataSection


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 20
; FirstLine = 17
; Folding = -
; EnableXP