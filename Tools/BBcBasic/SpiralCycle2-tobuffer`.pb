; 
; Window Open Template 
; 
; https://bbcmic.ro/#

Global Dim colour(31)
Global *buffer = AllocateMemory(320*256)
For n = 0 To 31 Step 4
  colour(   0 + c ) = RGB(  c*16, 2*c*16, 3*c*16 )
  ;Color(  4 + n ) = RGB(  64, 255, 4 * n )
  ;Color( 8 + n ) = RGB(  64, 255 - 4 * n , 255 )
  ;Color( 12 + n ) = RGB(  64, 0, 255 - 4 * n )
  c+2
Next
; For n = 16 To 31
;   colour(n) = 0 
; Next 

ExamineDesktops():InitSprite():InitKeyboard():InitMouse()
Global window=OpenWindow(#PB_Any ,DesktopWidth(0)/2-400,DesktopHeight(0)/2-300,800,600,"Demo")
; Global screenwin=OpenWindowedScreen(WindowID(window),#PB_Any,0,800,600)
Global canvase=CanvasGadget(#PB_Any, 0, 0, 800, 600)
;Global canvas=CanvasGadget(#PB_Any,0,0,800,600)

; EnableExplicit

#FP = 6

Procedure filltriangle(x1,y1,x2,y2,x3,y3)
  
  Define.l x, y, x0,y0, dx1, dx2, dx3, scanleftx, scanrightx, leftadd, rightadd, beginx, endx
  Define.b bucle
  
  ; magenta outline for debugging purposes
  ; theoretically the magenta should be overwritten by the white triangle
  LineXY(x1, y1 , x2, y2, RGB(128,0,255))
  LineXY(x2, y2 , x3, y3, RGB(128,0,255))
  LineXY(x3, y3 , x1, y1, RGB(128,0,255))
  
  ; Sort algorithm using swap method, two iterations is enough to sort an array with 3 items
  For bucle = 0 To 1
    If y1>y2 : x0=x2 : x2=x1 : x1=x0 : y0=y2 : y2=y1 : y1=y0 :  EndIf 
    If y2>y3 : x0=x3 : x3=x2:  x2=x0 : y0=y3 : y3=y2 : y2=y0 :  EndIf
  Next bucle
  
  If y2 <> y1
    dx1=(((x2-x1)<<#FP)/(y2-y1))
  Else
    dx1=((x2-x1)<<#FP)
  EndIf
  
  If y3 <> y1
    dx2=(((x3-x1)<<#FP)/(y3-y1))
  Else
    dx2=((x3-x1)<<#FP)
  EndIf
  
  If y3 <> y2
    dx3=(((x3-x2)<<#FP)/(y3-y2))
  Else
    dx3=((x3-x2)<<#FP)
  EndIf
  
  scanleftx = x1 << #FP
  scanrightx = x1 << #FP
  
  If dx1 < dx2
    leftadd=dx1
    rightadd=dx2
  Else
    leftadd=dx2
    rightadd=dx1
  EndIf
  
  If y1 <> y2
    For y = y1 To y2-1
      beginx = scanleftx >> #FP
      endx = scanrightx >> #FP
      If endx-beginx > 0
        LineXY(beginx, y , endx, y, RGB(255,255,255))
      EndIf
      scanleftx + leftadd
      scanrightx + rightadd
    Next y
  Else
    scanleftx + leftadd
    scanrightx + rightadd
  EndIf
  
  If dx2 > dx3
    leftadd = dx2
    rightadd = dx3
  Else
    leftadd = dx3
    rightadd = dx2
  EndIf
  
  If y2 <> y3
    For y = y2 To y3
      beginx = scanleftx >> #FP
      endx = scanrightx >> #FP
      If beginx <> endx
        LineXY(beginx, y , endx, y, RGB(255,255,255))
      EndIf
      scanleftx + leftadd
      scanrightx + rightadd
    Next y
  EndIf
  
EndProcedure

Procedure ProcessEvent(event)
  
  Define devent
  devent = event 
  Debug EventGadget()
  Select devent
      
    Case #PB_Event_Gadget
      
      
    Case #PB_Event_CloseWindow
      End
  EndSelect
  
EndProcedure

Procedure SetUp()
  
  ;'StartDrawing(CanvasOutput(canvas))
  StartDrawing(CanvasOutput(canvase))
  Box(0,0,800,600,#Black)
  StopDrawing()
  
EndProcedure

Procedure DrawEffect()
  Define.f  r,t,u,v,f,d,z
  Static.a g 
  
  colour(0)=#Black
  colour(1)=#Red
  colour(2)=#Green
  colour(3)=#Yellow
  colour(4)=#Blue
  colour(5)=#Magenta
  colour(6)=#Cyan
  colour(7)=#White
  colour(8)=#Black
  colour(9)=#Black
  colour(10)=#Black
  colour(11)=#Black
  colour(12)=#Black
  colour(13)=#Black
  colour(14)=#Black
  colour(15)=#Black

  ; StartDrawing(CanvasOutput(canvase))
  
  For x=0 To 319
    For y=0 To 255 
      u=x*(2/(-106))+3   ; 3d into screen 
      ;u=(x*8/8) -160      
      v=y-128
      t=-0.50 : If v<>0 : t=8+ATan(u/v)/#PI: EndIf 
      d=u*u+v*v
      If d>0 : d=Sqr(d) : EndIf  
      If d>0 : z=2000/d : EndIf 
      ; If d>0 And D<10 : z=0 : EndIf 
      ;If d>0 And D<10 : z=v*Sqr(u)  : EndIf 
      z=z+(t*16)
      r=Sin(Int(t*200)*321)*0.5+0.05
      z=z*(1+(r/8))
      
      col = Int(Abs(Mod((100+z)+g,255)))


;       If Mod(x,2) 
;         col = 0
;       EndIf 
      
      If y>120 And y<150 
          If Mod(x,2)=1 And Mod(y,1)=0
            col = 255
          Else
            col = col 
          EndIf 
        ElseIf y>110 And y<140
          If Mod(x,3)=1 And Mod(y,3)=1
            col = 255
          Else
            col = col 
          EndIf 
        ;ElseIf y>100 And y<130
        ;    col = 255

        EndIf 
    
      PokeB(*buffer+(y)+x*256,col) 
    Next

  Next   
  g+1
  ;Box(10,10,10,10,#Black)
;  StopDrawing()
;  FlipBuffers()
;  ClearScreen(0)
EndProcedure

Procedure DrawBuffer()
StartDrawing(CanvasOutput(canvase))
For x = 0 To 319
  For y = 0 To 255 
    a = PeekA(*buffer+(y)+x*256)
    ;Plot(x,y,RGB(8*a,16*a,32*a))
    scale=3
    Box(x*scale,y*scale,scale,scale,RGB(8*a,16*a,32*a))

  Next
Next
StopDrawing()
EndProcedure

Procedure ShowMouseXY()
  
  StartDrawing(ScreenOutput())
  DrawText(0,0,Str(MouseX()))
  DrawText(0,8,Str(MouseY()))
  StopDrawing()
  FlipBuffers()
  ClearScreen(0)
EndProcedure

Procedure SaveEffect(fname$)
  
  file$ = fname$ 
  
  If OpenFile(0,"C:\NextBuildv7\Sources\Spectrum\data\"+file$)
    WriteData(0,*buffer,320*256)
    
    CloseFile(0)
  Else 
    Debug "Error saving"
  EndIf
EndProcedure


Define WEvent, Quit, event 

SetUp()
DrawEffect()
SaveEffect("output320.bin")

Repeat 
  
  event=WindowEvent()
  ProcessEvent(event)
;  ClearScreen(0)
  DrawEffect()
  DrawBuffer()
;  FlipBuffers()
;  ExamineKeyboard()
 ; FlipBuffers()
 ; ExamineMouse()
 ; ShowMouseXY()
  
  
Until t=1



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 194
; FirstLine = 89
; Folding = +-
; EnableXP
; EnablePurifier