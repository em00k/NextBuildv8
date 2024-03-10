; 
; Window Open Template 
; 
; https://bbcmic.ro/#

Global Dim colour(31)
For n = 0 To 31 Step 2
  colour(   0 + n ) = RGB(  n, 2*n*16, 2*n*32 )
  ;Color(  4 + n ) = RGB(  64, 255, 4 * n )
  ;Color( 8 + n ) = RGB(  64, 255 - 4 * n , 255 )
  ;Color( 12 + n ) = RGB(  64, 0, 255 - 4 * n )
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
  Define.f r,t,u,v,f,d,z
  Static.f g 
  
;   colour(0)=#Black
;   colour(1)=#Red
;   colour(2)=#Green
;   colour(3)=#Yellow
;   colour(4)=#Blue
;   colour(5)=#Magenta
;   colour(6)=#Cyan
;   colour(7)=#White
;   colour(8)=#Black
;   colour(9)=#Black
;   colour(10)=#Black
;   colour(11)=#Black
;   colour(12)=#Black
;   colour(13)=#Black
;   colour(14)=#Black
;   colour(15)=#Black

  StartDrawing(CanvasOutput(canvase))
  For x=0 To 160
    For y=0 To 256
      ; u=x*(4/(3-106))   ; 3d into screen 
      u=x*4/3-106       ; original 
      v=y-128
      t=0.5 : If v<>0 : t=ATan((u/v))/#PI : EndIf 
      d=u*u+v*v
      If d>0 : d=Sqr(d) : EndIf 
      If d>0 : z=500/d : EndIf 
      z=z+(t*16)
      r=(Sin(Int(t*200)*321)*0.2) ; +0.
      z=z*(1+(r/9))+g
      ; sets pixel colour 
      ; GCOL 0,15-(100+z) MOD 16
      col = colour(Int(Abs(Mod(15-(100+z),16))))
      ; 

      ; Plot(x*8,y*4) ; ,69
      ; Plot(x,y,col) ; ,69
      Box(x*4,y*2,4,2,col)
      
    Next
  Next   
  g+0.3
  ;Box(10,10,10,10,#Black)
  StopDrawing()
;  FlipBuffers()
;  ClearScreen(0)
EndProcedure


Procedure ShowMouseXY()
  
  StartDrawing(ScreenOutput())
  DrawText(0,0,Str(MouseX()))
  DrawText(0,8,Str(MouseY()))
  StopDrawing()
  FlipBuffers()
  ClearScreen(0)
EndProcedure

Define WEvent, Quit, event 

SetUp()
DrawEffect()

Repeat 
  
  event=WindowEvent()
  ProcessEvent(event)
;  ClearScreen(0)
  DrawEffect()
;  FlipBuffers()
;  ExamineKeyboard()
 ; FlipBuffers()
 ; ExamineMouse()
 ; ShowMouseXY()
  
  
Until t=1



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 161
; FirstLine = 72
; Folding = +
; EnableXP
; EnablePurifier