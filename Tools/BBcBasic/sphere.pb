; 
; Window Open Template 
; 
; https://bbcmic.ro/#

Global Dim colour(31)
Global *buffer = AllocateMemory(256*192)
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

    Define.f x,y,z,i,j,k,w,t,p,c,d,t,s,v,u
    Static.f g 
    
    For vv=0 To 255
      For uu=0 To 159
        v = vv 
        u = uu 
        x= u/64-1: y=v/128-1.4
        z=1/Sqr(x*x+y*y+1): x=x*z: y=y*z
        x=0: y=0.4: z=-2
        p=-y*y-z*z : i=x*p : j=y+y*p : k=z+z*p : c=i*i+j*j+k*k
        If c<1 
          w=p-Sqr(1-c): 
                  x=w*x: y=y+w*y: z=z+w*z: d=2*(x*x+y*y+z*z): x=x-d*x: y=y-d*y: z=z-d*z

        EndIf 
        t=-(y-2*Sign(y))/y: 
        u=x+x*t:  v=z+z*t
        s=-u*0.5+v*0.8:t=u*0.8+v*0.5
        ;gcol0,15 and (int(t*8)+8*ints)
        ;plot69,u*8,v*4
        ;GCOL0,15 And (Int(T*8)+8*INTS)
        ;PLOT69,U*8,V*4
        
        col = 15 & (Int(t*8)+8*Int(s)) 
        ;       If Mod(x,2) 
        ;         col = 0
        ;       EndIf 
        PokeB(*buffer+((u)*256)+v,col) 
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
For x = 0 To 255
  For y = 0 To 191 
    a = PeekA(*buffer+(y*256)+x)
    ;Plot(x,y,RGB(8*a,16*a,32*a))
    Box(x*3,y*3,3,3,RGB(8*a,16*a,32*a))
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
    WriteData(0,*buffer,49152)
    
    CloseFile(0)
  Else 
    Debug "Error saving"
  EndIf
EndProcedure


Define WEvent, Quit, event 

SetUp()
DrawEffect()
SaveEffect("output6.bin")

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
; CursorPosition = 186
; FirstLine = 83
; Folding = +-
; EnableXP
; EnablePurifier