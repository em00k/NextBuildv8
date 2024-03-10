; level designer for my crap games
; em00k march / 2021

Global version$="v0.1"

XIncludeFile "Gui.pbf"              ; include the forms 

UsePNGImageDecoder()
Global Dim Tiles(256)
Global tilecount = 0 
Global selectedtile = 0 

;-- Tile routines 

Procedure ImportTiles(file$="moley.png")
  
  tempim=CreateImage(#PB_Any,320,256)       ; create a temp image 
  importim=LoadImage(#PB_Any,file$)         ; load the image
  
  For x = 0 To ImageWidth(importim) Step 8  ; each tile is 8x8px 
    
    Tiles(tilecount) = GrabImage(importim,#PB_Any,x,0,8,8)
    
    
    tilecount + 1     
    
  Next x
  
  
  
EndProcedure


;-- Canvas Routines

Procedure DrawGridMap()
  
  StartDrawing(CanvasOutput(CanvasMap))
  
  For x = 0 To 960 Step 48          ; each 16x16 tile is scaled x 3 
    Line(x,0,1,768,#White)  
  Next x 
  
  For y = 0 To 768 Step 48
    Line(0,y,960,1,#White)
  Next y 
    
  StopDrawing()
  
EndProcedure

Procedure DrawGridTile()
  
  StartDrawing(CanvasOutput(CanvasTiles))
  
  For x = 0 To 48*3 Step 48          ; each 16x16 tile is scaled x 3 
    Line(x,0,1,768,#Blue)  
  Next x 
  
  For y = 0 To 768 Step 48
    Line(0,y,960,1,#Blue)
  Next y 
    
  StopDrawing()
  
EndProcedure

Procedure ClearCanvasMap()
  
  StartDrawing(CanvasOutput(CanvasMap))
  Box(0,0,960,768,#Black)
  StopDrawing()
  
EndProcedure

Procedure ClearCanvasTiles()
  
  StartDrawing(CanvasOutput(CanvasTiles))
  Box(0,0,960,768,#Black)
  StopDrawing()
  
EndProcedure

Procedure PrintDebug(msge$)
  
  StartDrawing(CanvasOutput(CanvasTiles))
  
  DrawText(3,750,msge$)
  
  StopDrawing()
  
EndProcedure

Procedure UpdateTiles()
  
  StartDrawing(CanvasOutput(CanvasTiles))
  While tcount < tilecount
    
    DrawImage(ImageID(Tiles(tcount)),48*x,48*y,48,48)
    
    x = x + 1 : If x > 2 : y = y + 1 : x = 0 : EndIf 
    
    tcount + 1 
    
  Wend
  StopDrawing()
  
EndProcedure

Procedure PlaceTile(tile, x, y)
  StartDrawing(CanvasOutput(CanvasMap))
  
    DrawImage(ImageID(tiles(tile)),x,y,48,48)
  
  StopDrawing()
EndProcedure

Procedure ProcessCanvasMap(Type)
  
  ;-- FOR MAP 
  
  offya = GetGadgetAttribute(CanvasMap, #PB_Canvas_MouseY) /48
  offxa = GetGadgetAttribute(CanvasMap, #PB_Canvas_MouseX)/48
  
  msge$="X="+Str(offxa)+" Y="+Str(offya)
  
  PrintDebug(msge$)
  
  If Type=#PB_EventType_LeftButtonDown Or (GetGadgetAttribute(CanvasMap, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)   
    PlaceTile(selectedtile,offxa*48,offya*48)
  ElseIf Type=#PB_EventType_RightButtonDown Or (GetGadgetAttribute(CanvasMap, #PB_Canvas_Buttons) & #PB_Canvas_RightButton)   
    PlaceTile(selectedtile,offxa*48,offya*48)
  EndIf           
  
EndProcedure


Procedure ProcessCanvasTiles(Type)
  
  ;-- FOR TILES 
  
  offya = GetGadgetAttribute(CanvasTiles, #PB_Canvas_MouseY) /48
  offxa = GetGadgetAttribute(CanvasTiles, #PB_Canvas_MouseX)/48
  
  tile = offxa+offya*3
  
  msge$="Tile ="+Str(tile)+"         "
  
  PrintDebug(msge$)
  
  If Type=#PB_EventType_LeftClick ; Or (GetGadgetAttribute(CanvasTiles, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)   
    Debug " Tile = "+Str(tile)
    selectedtile = tile 
  EndIf           
  
EndProcedure

;-- Main processing

Procedure Window_0_Events(event)
  Select event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False

    Case #PB_Event_Menu
      Select EventMenu()
        Case #MenuLoad
        Case #MenuLoadAll
        Case #MenuSaveMap
        Case #MenuSaveAll
        Case #MenuAbout
        Case #MenuQuit
      EndSelect

    Case #PB_Event_Gadget
      
      Type = EventType()
      Select EventGadget()
        Case CanvasMap
          ProcessCanvasMap(Type)
          
        Case CanvasTiles
          ProcessCanvasTiles(Type)
          
      EndSelect
      
  EndSelect
  ProcedureReturn #True
EndProcedure

;-- Setup 

Procedure Setup()
  
  OpenWindow_0()                    ; open main window 
  ClearCanvasMap()                  ; Clear the canvas map 
  ClearCanvasTiles()                 ; Clear the canvas tile 
  DrawGridMap()
  ImportTiles()
  UpdateTiles()
  DrawGridTile()
  
EndProcedure

Setup()                             ; call the setup (openwindow/set up canvas)

Repeat 
  
  event = WaitWindowEvent()
  result = Window_0_Events(event)
  
Until result=#False 


; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 131
; FirstLine = 42
; Folding = B+-
; EnableXP