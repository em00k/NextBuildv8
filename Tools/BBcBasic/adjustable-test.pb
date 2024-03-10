; 
; Window Open Template 
; 
; https://bbcmic.ro/#

XIncludeFile "adjustable-test.pbf"

Global Dim colour(256)
Global *buffer = AllocateMemory(320*256)
Global dthread
Global Mutex = CreateMutex() 
Global Semaphore = CreateSemaphore()

Global.f r,t,u,v,f,d,z,t1, t2, d1, d2, z1, s1,s2,s3
Global.i c1,c2
Global.b set2d = 1 

ExamineDesktops():InitSprite():InitKeyboard():InitMouse()
OpenWindow_0()

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

Procedure ImportPalette()
  
  count = 0 
  
  If ReadFile(0,"rainbow.pal")
    While Not Eof(0)  
      byte = ReadAsciiCharacter(0)
      
      r = PeekA(?LUT3BITTO8BIT+(byte >> 5))
      g = PeekA(?LUT3BITTO8BIT+(byte >> 2) & 7)
      b = PeekA(?LUT2BITTO8BIT+(byte & 3))
      colour(count)=RGB(r,g,b)
      count + 1 : ReadAsciiCharacter(0)
      Debug byte 
    Wend 
    
    CloseFile(0)
  Else
    Debug "Error opening palette"
    
  EndIf 
  
  DataSection: 
    LUT3BITTO8BIT:
    Data.a 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT2BITTO8BIT:
    Data.a 0,$55,$AA,$FF
  EndDataSection 
  
EndProcedure


Procedure SetUp()
  
  ;'StartDrawing(CanvasOutput(canvas))
  StartDrawing(CanvasOutput(Canvas_0))
  Box(0,0,800,600,#Black)
  StopDrawing()
  ImportPalette()
  
EndProcedure

Procedure DrawEffect(param)
  
  Static.a g 
  
  Repeat  
    ; StartDrawing(CanvasOutput(Canvas_0))
    LockMutex(Mutex)
    For x=0 To 319 ; Step 2 
      
      If set2d = 1 
        u=(x*8/8) -160 
      Else 
        u=x*(2/(-106))+3   ; 3d into screen 
      EndIf 
      
      For y=0 To 255 
        
        v=y-128

        t=t1 : If v<>0 : t=t2+ATan(u/v)/#PI: EndIf   ; t1 t2 
        d=u*u+v*v

        If d>d1 : d=Sqr(d) : EndIf  ; d1
        If d>d2 : z=z1/d : EndIf    ; d2 z1 
        ; If d>0 And D<10 : z=0 : EndIf 
        ;If d>0 And D<10 : z=v*Sqr(u)  : EndIf 
        z=z+(t*16)
        
        r=Sin(Int(t*s1)*s2)*s3 ; s1 s2 s3
        z=z*(1+(r/8))
        
        col = Int(Abs(Mod((100+z)+g,c1)))

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
    UnlockMutex(Mutex)
    SignalSemaphore(Semaphore)
    ;Delay(1)
    StartDrawing(CanvasOutput(Canvas_0))
    Define.i xx,yy 
    For xx = 0 To 319
      For yy = 0 To 255
        a = PeekA(*buffer+(yy)+xx*256)
        ;Plot(x,y,RGB(8*a,16*a,32*a))
        scale=2
        c= colour(a)
        Box(xx*scale,yy*scale,scale,scale,c)
        ;Box(xx*scale+2,yy*scale,scale,scale,c)
        
      Next
    Next
    StopDrawing()
    
    
  Until param = 1 
  
  ;Box(10,10,10,10,#Black)
  ;  StopDrawing()
  ;  FlipBuffers()
  ;  ClearScreen(0)
EndProcedure

Procedure DrawBuffer()
  StartDrawing(CanvasOutput(Canvas_0))
  For x = 0 To 319 
    For y = 0 To 255 
      a = PeekA(*buffer+(y)+x*256)
      ;Plot(x,y,RGB(8*a,16*a,32*a))
      scale=2
      Box(x*scale,y*scale,scale,scale,colour(a))
      
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
  
  If OpenFile(0,file$)
    If WriteData(0,*buffer,320*256)
      Debug "Saved "+file$ 
    EndIf 
    
    CloseFile(0)
    
  Else 
    Debug "Error saving"
  EndIf
EndProcedure

Procedure ProcessEditor()
  
  
  LockMutex(Mutex)
  For l =0 To  CountGadgetItems(#Editor_0)
    text$=GetGadgetItemText(#Editor_0,l)
    Debug text$ 
    ;t1, t2, d1, d2, z1, s1,s2,s3
    WaitSemaphore(Semaphore)
    If FindString(text$,"t1")
      t1=ValF(StringField(text$,2,"="))
      Debug t1 
    EndIf   
    If FindString(text$,"t2")
      t2=ValF(StringField(text$,2,"="))
      Debug t2
    EndIf   
    If FindString(text$,"d1")
      d1=ValF(StringField(text$,2,"="))
      Debug d1
    EndIf 
    If FindString(text$,"d2")
      d2=ValF(StringField(text$,2,"="))
      Debug d2
    EndIf
    If FindString(text$,"z1")
      z1=ValF(StringField(text$,2,"="))
      Debug z1
    EndIf
    If FindString(text$,"s1")
      s1=ValF(StringField(text$,2,"="))
      Debug s1
    EndIf
    If FindString(text$,"s2")
      s2=ValF(StringField(text$,2,"="))
      Debug s2
    EndIf
    If FindString(text$,"s3")
      s3=ValF(StringField(text$,2,"="))
      Debug s3
    EndIf 
    If FindString(text$,"c1")
      c1=ValF(StringField(text$,2,"="))
      Debug c1
    EndIf 
  Next 
  UnlockMutex(Mutex)
EndProcedure


Procedure Window_0_Events(event)
  Select event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False
      
    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #Button_Stop
          If IsThread(dthread)
            PauseThread(dthread)
          EndIf 
        Case #Button_Play 
          ResumeThread(dthread)
       Case #Button_Save 
         SaveEffect(GetGadgetText(#String_Filename))
        
        Case #Button_Send 
          ; If IsThread(dthread)
          ;   PauseThread(dthread)
          ; EndIf 
          ProcessEditor()
          ; ResumeThread(dthread)
        Case #Checkbox_3D
          If GetGadgetState(#Checkbox_3D) = 1
            set2d = 0 
          Else 
            set2d = 1 
          EndIf 
        Case #Editor_0
          Select EventType()
            Case #PB_EventType_Change
              ;  If IsThread(dthread)
              ;   PauseThread(dthread)
              ;  EndIf 
              ProcessEditor()
              ;  ResumeThread(dthread)
          EndSelect
      EndSelect
  EndSelect
  ProcedureReturn #True
EndProcedure

Define WEvent, Quit, event 

SetUp()
;DrawEffect(0)
;SaveEffect("output320.bin")

Def$="t1=-0.50"+#CRLF$+"t2=8"+#CRLF$
Def$+"d1 = 0"+#CRLF$+"d2 = 0"+#CRLF$+"z1 = 2000"+#CRLF$
Def$+"s1 = 200"+#CRLF$+"s2 = 321"+#CRLF$+"s3 = 0.5 + 0.5"+#CRLF$
Def$+"c1 = 255"
SetGadgetText(#String_Filename,"C:\NextBuildv7\Sources\Spectrum\data\swimage.bin")
SetGadgetText(#Editor_0,Def$)
dthread = CreateThread(@DrawEffect(),0)


Repeat 
  
  event=WaitWindowEvent()
  result=Window_0_Events(event)
  ;  ClearScreen(0)
  
  
  ;  FlipBuffers()
  ;  ExamineKeyboard()
  ; FlipBuffers()
  ; ExamineMouse()
  ; ShowMouseXY()
  
  
Until result=#False



; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 213
; FirstLine = 119
; Folding = +-
; EnableThread
; EnableXP
; EnablePurifier