UsePNGImageDecoder()
UsePNGImageEncoder()
InitSprite()


;OpenWindow(0,10,10,800,400,"")
IncludeFile "convertformsv2.pbf"
OpenWindow_ftiles()

Structure palmap
  r.a
  g.a
  b.a
  i.a
  hb.a
  lb.a
EndStructure
Global infilename$=""   ; 24 bit!
Global NAME$=GetFilePart(infilename$,#PB_FileSystem_NoExtension)
Global PATH$=GetPathPart(infilename$)
Global filepalette$=""
Global NewList palette.palmap() 
Global NewList bmppalette.palmap() 
Global *tilebuffer= AllocateMemory(16384)      ; memory to load the til into
Global *palbuff = AllocateMemory(16*4)         ; palette buffer 
Global *outputbuffer = AllocateMemory(16384)
Global sourceimage = CreateImage(#PB_Any,256,192)
Global tilemode=0, zoomlevel=1, BMPImageIn, CurrentEditTile
Global permtileimage = CreateImage(#PB_Any,8,256*8)
Global tileorder = CreateImage(#PB_Any,512,384)
Global Dim imagetiles(256)
Global imginheight = 192, imginwidth = 256, mapx, mapy, r, g, b  
Global *mapbuffer = AllocateMemory(1024*1024)      ; size of map 
Global *spritebuffer = AllocateMemory(16384)
Global worldpos=0, viewwidth=520/8, worldwidth=80, mapsize=8, EditFrontColour
Global Dim mapedge(4) : mapedge(0)=17 : mapedge(1)=55 : mapedge(2)=61 : mapedge(3)=146
Global Dim spritetiles(128)
Global *sl2buffer = AllocateMemory(49152+513)


Procedure Alert(title$,msg$,type=0)
  If type = 0 
    type = #PB_MessageRequester_Ok
  ElseIf type = 1 
    type = #PB_MessageRequester_Warning
  ElseIf type = 2
    type = #PB_MessageRequester_Error
  Else 
    type = 0 
  EndIf 
  MessageRequester(title$,msg$,type)
EndProcedure

Procedure ReadPaletteA()
  If ReadFile(1,filepalette$)
    l=Lof(1)
    Dim ii$(3)
    
    Dim rr(256)
    Dim gg(256)
    Dim bb(256)
    
    ClearList(palette())
    
    While Not Eof(1)
      
      ;line$=ReadString(1)
      
      AddElement(palette()) 
      
      With palette()
        bytein.a=ReadByte(1)  
        \r = bytein
        bytein=ReadByte(1)
        \g = bytein
        bytein=ReadByte(1)
        \b = bytein
        \i = ListIndex(palette())
        res2 = ((\r>>5) << 6) | ((\g >> 5) << 3) | (\b>>5)
        \hb = res2>>1
        \lb = res2 & 1
        ;res2 = ((r>>5) << 6) | ((g >> 5) << 3) | (b>>5)
        ;'res3=res2 >>1 : sb=res2 band 1
        ;Debug res2>>1
        ;Debug res2 & 1
      EndWith
      
      ;colmap(c)=col1
      c=c+1
      ;Debug v 
      i=0
    Wend
    
    CloseFile(1)  
  Else
    MessageRequester("ERROR!","Cannot load palette!")
    
  EndIf
  
EndProcedure

Procedure ReadPaletteNXP()
  If ReadFile(1,filepalette$,#PB_File_SharedRead)
    l=Lof(1)
    Dim ii$(3)
    
    Dim rr(256)
    Dim gg(256)
    Dim bb(256)
    
    ClearList(palette())
    
    While Not Eof(1)
      
      ;line$=ReadString(1)
      
      AddElement(palette()) 
      
      With palette()
        byteinH.i=ReadByte(1)  
        byteinL.i=ReadByte(1)
        
        d=byteinH<<1 ! byteinL 
        
        \r = PeekA(?LUT3BITTO8BIT+(d >> 6 & 7))
        \g = PeekA(?LUT3BITTO8BIT+(d >> 3 & 7))
        \b = PeekA(?LUT3BITTO8BIT+(d & 7))
        
        \i = ListIndex(palette())
        
        ;res2 = ((r>>5) << 6) | ((g >> 5) << 3) | (b>>5)
        ;'res3=res2 >>1 : sb=res2 band 1
        ;Debug res2>>1
        ;Debug res2 & 1
      EndWith
      
      ;colmap(c)=col1
      c=c+1
      ;Debug v 
      i=0
    Wend
    
    CloseFile(1)  
  Else
    MessageRequester("ERROR!","Cannot load r3g3b2.txt palette!")
    End 
  EndIf
  
  DataSection
    LUT2BITTO8BIT:
    Data.a 0,$55,$AA,$FF
    LUT3BITTO8BIT:
    Data.a 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT4BITTO8BIT:
    Data.a 0,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
  EndDataSection
  
  
EndProcedure

Procedure ReadPalette()
  If OpenFile(1,"r3g3b2.txt")
    l=Lof(1)
    Dim ii$(3)
    
    Global NewList palette.palmap() 
    
    Dim rr(256)
    Dim gg(256)
    Dim bb(256)
    While Not Eof(1)
      
      line$=ReadString(1)
      
      
      While i<3
        ii$(i)=StringField(LTrim(line$),i+1," ")
        i+1
      Wend 
      
      AddElement(palette()) 
      
      With palette()
        
        \r = Val(ii$(0))
        \g = Val(ii$(1))
        \b = Val(ii$(2))
        \i = ListIndex(palette())
        
      EndWith
      
      ;colmap(c)=col1
      c=c+1
      ;Debug v 
      i=0
    Wend
    
    CloseFile(1)  
  Else
    MessageRequester("ERROR!","Cannot load r3g3b2.txt palette!")
    End 
  EndIf
  
EndProcedure

Procedure rgb92rgb24(rgb9)
  
  r = PeekA(?LUT3BITTO8BIT+(rgb9 >> 6 & 7))
  g = PeekA(?LUT3BITTO8BIT+(rgb9 >> 3 & 7))
  b = PeekA(?LUT3BITTO8BIT+(rgb9 & 7))
  ;Dim LUT3BITTO8BIT(7) As ubyte => 
  
  
  DataSection: 
    LUT3BITTO8BIT:
    Data.a 0,$24,$49,$6D,$92,$B6,$DB,$FF
  EndDataSection
  
EndProcedure

Procedure rgb24torgb3(r,g,b)
  
  ;b9=peek(@palette+cast(uinteger,c))
  ;g9=peek(@palette+cast(uinteger,c+1))
  ;r9=peek(@palette+cast(uinteger,c+2))
  res2 = ((r>>5) << 6) | ((g >> 5) << 3) | (b>>5)
  ;'res3=res2 >>1 : sb=res2 band 1
  Debug res2>>1
  Debug res2 & 1
  
EndProcedure

Procedure rgb82rgb24(rgb8)
  
  ;rgb8 = ((r>>5) << 6) | ((g >> 5) << 2) | ((b>>5))
  
  r = PeekA(?LUT3BITTO8BIT+(rgb8 >> 5))
  g = PeekA(?LUT3BITTO8BIT+(rgb8 >> 2) & 7)
  b = PeekA(?LUT2BITTO8BIT+(rgb8 & 3))
  
  DataSection: 
    LUT3BITTO8BIT:
    Data.a 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT2BITTO8BIT:
    Data.a 0,$55,$AA,$FF
  EndDataSection
  
EndProcedure

Procedure RedrawCanvasDef()
  
  ClearList(palette())
  SelectElement(palette(),0)
  While ListSize(palette())<256
    AddElement(palette())
  Wend 
  ShowMemoryViewer(*spritebuffer,512)
  ; StartDrawing(CanvasOutput(Canvas_0))
  With palette()
    For y = 0 To 63
      For x = 0 To 255
        
        sl2byte = PeekA(*spritebuffer+position)
        ;rgb92rgb24(sl2byte)
        SelectElement(palette(),sl2byte)
        
        rgb82rgb24(sl2byte)
        
        
        ;         rf.f=r/100*redslider 
        ;         gf.f=g/100*greenslider 
        ;         bf.f=b/100*blueslider     
        rf.f=r
        gf.f=g 
        bf.f=b
        
        r9.i=Int(rf) : g9.i= Int(gf) : b9.i = Int(bf) 
        
        res2.i  = (((r9>>5) << 6) | ((g9 >> 5) << 3) | (b9>>5))>>1
        res3.i = res2 & 1 
        rgb9.i = (res2<<1) ! res3
        rgb92rgb24(rgb9)
        
        
        \r=r : \g = g : \b = b
        ;Box(x*2,y*2,2,2,(RGB(r,g,b)))
        position+1 
        
      Next x
    Next y 
    ;  StopDrawing()
  EndWith
  ;DisplayPaletteDef()
  
EndProcedure

Procedure DrawTiles()
  
  If ListSize(palette())>0 
    ; populates the temp lookup palette palbuff 
    
    With palette()
      FirstElement(palette())
      For colour = 0 To 15*3 Step 3 
        ; st$=Str(\r)+","+Str(\g)+","+Str(\b)+","
        ; Debug st$
        PokeA(*palbuff+colour,\r)
        PokeA(*palbuff+colour+1,\g)
        PokeA(*palbuff+colour+2,\b)
        NextElement(palette())
      Next colour
    EndWith
  Else
    Alert("No Palette","You do not have a palette loaded yet",2)
  EndIf 
  
  tmpimg=CreateImage(#PB_Any,256,192)
  
  StartDrawing(ImageOutput(tmpimg))
  
  offset = 0 
  
  zoomlevel=GetGadgetState(TrackBar_Zoom)*2
  
  For til=0 To 255
    If by < 192
      For y = 0 To 7
        For x = 0 To 7 Step 2
          
          pixel.a = PeekA(*tilebuffer+offset)
          pixelleft.a = ((pixel & %11110000) >> 4 )*3
          pixelright.a = (pixel & %00001111)*3
          r = PeekA(*palbuff+pixelleft)
          g = PeekA(*palbuff+pixelleft+1)
          b = PeekA(*palbuff+pixelleft+2)
          Plot(bx+x,by+y,RGB(r,g,b))
          
          r = PeekA(*palbuff+pixelright)
          g = PeekA(*palbuff+pixelright+1)
          b = PeekA(*palbuff+pixelright+2)
          
          Plot(bx+x+1,by+y,RGB(r,g,b))
          ;Plot(x+1,y,#White)
          
          offset+1
        Next x 
      Next y 
      ;Debug zoomlevel
      
      bx = bx + 8: If bx>=256 : bx = 0 : by=by+8 : EndIf 
    EndIf 
  Next til
  StopDrawing()
  xc = 0 
  
  For y = 0 To 63 Step 8
    For x = 0 To 255 Step 8  
      If IsImage(imagetiles(xc)) : FreeImage(imagetiles(xc)) : EndIf 
      imagetiles(xc) = GrabImage(tmpimg,#PB_Any,x,y,8,8)
      xc+1
    Next x 
  Next y 
  
  StartDrawing(ImageOutput(sourceimage))
  DrawImage(ImageID(tmpimg),0,0)
  StopDrawing()
  
  StartDrawing(CanvasOutput(Canvas_Preview))
  ;DrawImage(ImageID(tmpimg),0,0,347,260)
  ;zoomlevel=GetGadgetState(TrackBar_Zoom)*2
  DrawImage(ImageID(tmpimg),0,0,256*zoomlevel,192*zoomlevel)
  StopDrawing()
  FreeImage(tmpimg)
  
EndProcedure

Procedure SaveTiles()
  
  ; ShowMemoryViewer(*outputbuffer,16384)
  ; If OpenFile(5,PATH$+"mm.til")
  savedtil=0 : savednxp = 0 
  If OpenFile(5,PATH$+NAME$+".til")
    WriteData(5,*outputbuffer,256*8*8)
    CloseFile(5)
    savedtil=1
  Else
    MessageRequester("Error","Cannot save "+NAME$+".til")
    ;  DeleteFile("h:\"+NAME$+".spr",#PB_FileSystem_Force)
    ;  CopyFile(NAME$+".spr","h:\"+NAME$+".spr")
  EndIf 
  
  ;  If OpenFile(2,PATH$+"mm.pal")
  If OpenFile(2,PATH$+NAME$+".nxp")
    With palette()
      ForEach palette()
        WriteAsciiCharacter(2,\hb)
        WriteAsciiCharacter(2,\lb)
      Next 
    EndWith
    CloseFile(2)
    savednxp = 1 
    ;MessageRequester("DEBUG",PATH$+NAME$+".nxp")
  Else
    MessageRequester("Error","Cannot save "+NAME$+".nxp")
    ;  DeleteFile("h:\"+NAME$+".pal",#PB_FileSystem_Force)
    ;  CopyFile(NAME$+".pal","h:\"+NAME$+".pal")
  EndIf 
  
  If savednxp=0
    MessageRequester("ERROR","Unable to save : "+PATH$+NAME$+".nxp",#PB_MessageRequester_Error)
  EndIf 
  
  If savedtil=0
    MessageRequester("ERROR","Unable to save : "+PATH$+NAME$+".til",#PB_MessageRequester_Error)
  EndIf 
  
  ; Saved OK 
  If savednxp=1 And savedtil=1 
    MessageRequester("Saved","Files saved to :"+#LF$+PATH$+NAME$+".til"+#LF$+PATH$+NAME$+".nxp")
  EndIf 
  
EndProcedure

Procedure Convert()
  
  If ListSize(palette()) = 0 
    ; there is no palette so lets try and get it from the image 
    ; palette starts at 54
    CopyList(bmppalette(),palette())
    MessageRequester("No PAL loaded","Using the BMP fist 16 colours....")
  EndIf 
  
  ; clear the bitmap preview windows to black 
  StartDrawing(CanvasOutput(Canvas_Preview))
  Box(0,0,512,384,#Black)
  StopDrawing()
  
  ;For loop=3 To 3
  
  sourcewidth = imginwidth 
  sourceheight = imginheight
  tempimg=CreateImage(#PB_Any,8,8)
  output=CreateImage(#PB_Any,8,256*8)     ; long image
  
  backbuffer=CreateImage(#PB_Any,512,384)
  
  off=0
  
  x = 0 : y = 0 : dx = 0 : dy = 0 
  
  ; this bit makes a copy of the input image and scales it to ImageID(tmp)
  
  bias = 0 : pyc=0
  
  For c = 0 To 255
    
    
    ; this is where we change the order of reading the tiles. 
    ; so far it does left to right 0 - 255 0 - 192
    ; we would like blocks of 4 ; 1 2
    ;                             3 4 
    ; from                        1 2 3 4 5 6 7 8 9 
    
    StartDrawing(ImageOutput(sourceimage))  
    tempimg=GrabDrawingImage(#PB_Any,(x)+mx*8,(y)+my*8,8,8)
    
    StopDrawing()
    
    ;     StartDrawing(ImageOutput(backbuffer))
    ;     ;  Box(0,0,50,50,#Black)
    ;     ;DrawImage(ImageID(tmp),0,0)
    ;     ;DrawImage(ImageID(tmp),0,c*8*2,16,16)
    ;     DrawImage(ImageID(tempimg),(dx*2),(dy*2),16,16)
    ;     
    ;     StopDrawing()
    ; Draws the image on the image output 
    StartDrawing(ImageOutput(output))
    DrawImage(ImageID(tempimg),0,pyc) : pyc=pyc+8
    StopDrawing()
    
    x=x+8
    If x>=sourcewidth                   ; width 
      y = y+8
      x = 0
    EndIf  
    dx=dx+8
    If dx>=256                  ; width 
      dy = dy+8
      dx = 0
    EndIf  
    FreeImage(tempimg)
  Next  
  
  
  
  ; this reads the bytes in the image 
  
  StartDrawing(ImageOutput(output))
  
  For y=0 To 2047
    For x=0 To 7
      ;x = 0 : y = 0 
      ;For c = 0 To 255
      ; looks at the pixel at x /y 
      col=Point(x,y)
      r = Red(col)
      g = Green(col)
      b = Blue (col)
      ps=0
      ;Debug Str(r)+" "+Str(g)+" "+Str(b)
      ;FirstElement(palette())
      ForEach palette()
        With palette()
          If r = \r And g = \g And b = \b
            curcol = ListIndex(palette())
            If \i > 16 
              exceed16colourscheck=1
            EndIf 
            ;PokeA(*outputbufferfer,curcol)
            ;CharMap(x,y)=curcol
            ;Debug curcol 
            PokeA(*outputbuffer+off,curcol)
            
            Break 
          EndIf
        EndWith
      Next
      off+1
      
      ; Debug val
    Next
  Next 
  
  StopDrawing()
  If exceed16colourscheck=1
    MessageRequester("WARNING","I detected a colour above the first 16",#PB_MessageRequester_Warning)
  EndIf
  
  ; Debug SaveImage(output,"output2.bmp")
  
  ;If OpenFile(5,"4bit.spr")
  ;  WriteData(5,*outputbuffer,64*8*8)
  ;  CloseFile(5)
  ;EndIf 
  off=0
  
  For bytepos=0 To 256*8*8          ; converts the byte image to 4 bit nibbles. 
    
    lbyte=PeekA(*outputbuffer+bytepos)<<4   ; gets first nibble shifts left 4 times 
    bytepos+1
    rbyte=PeekA(*outputbuffer+bytepos)       ; gets next nibble 
    
    ;old stupid way 
    ;lft$=Right(Hex(lbyte),1) : rght$=Right(Hex(rbyte),1)
    ;in$="$"+lft$+rght$
    ;bit=Val(in$)
    ;  Debug bit
    
    bit = lbyte + rbyte           ; adds the nibbles together
    PokeA(*outputbuffer+off,bit)  ; pops it in memory 
    off+1
    
  Next 
  
  ;Next 
  
  ;   StartDrawing(CanvasOutput(Canvas_Preview))
  ;     DrawImage(ImageID(backbuffer),0,0,256*zoomlevel,192*zoomlevel)
  ;   StopDrawing()
  
  CopyMemory(*outputbuffer,*tilebuffer,16384)
  
  DrawTiles()
  
  ; copy to perminagetile
  
  For x = 0 To 255
    
    imagetiles(x) = GrabImage(output,#PB_Any,0,gy,8,8)
    
    gy+8
    
  Next x 
  
  FreeImage(backbuffer)
  FreeImage(output)
  
  tilemode = 1
  
EndProcedure

Procedure DisplayPaletteNXP()
  
  ; palette() 
  StartDrawing(CanvasOutput(Canvas_Palette))
  
  Box(0,0,420,416,#Black)         ; clear the palette area 
  
  ; iterate through the loaded palette and display on Canvas_Palette
  canvaswidth = 145 : boxsize = canvaswidth / 7
  With palette()
    
    SelectElement(palette(),0)    ; first element in palette 
    For y = 0 To 31
      For x = 0 To 7
        
        Box(x*boxsize,y*boxsize,boxsize,boxsize,RGB(\r,\g,\b))
        NextElement(palette())
        
      Next x
    Next y 
    
  EndWith
  StopDrawing()
  StartDrawing(CanvasOutput(Canvas_Palette_Edit))
  
  ;Box(0,0,420,416,#Black)         ; clear the palette area 
  
  ; iterate through the loaded palette and display on Canvas_Palette
  canvaswidth = 145 : boxsize = canvaswidth / 7
  With palette()
    
    SelectElement(palette(),0)    ; first element in palette 
    For y = 0 To 31
      For x = 0 To 7
        
        Box(x*boxsize,y*boxsize,boxsize,boxsize,RGB(\r,\g,\b))
        NextElement(palette())
        
      Next x
    Next y 
    
  EndWith
  StopDrawing()
  If tilemode=1
    DrawTiles() 
  EndIf 
  
EndProcedure

Procedure DisplayPaletteBMP()
  
  ; palette() 
  StartDrawing(CanvasOutput(Canvas_Palette))
  
  Box(0,0,420,416,#Black)         ; clear the palette area 
  
  ; iterate through the loaded palette and display on Canvas_Palette
  canvaswidth = 145 : boxsize = canvaswidth / 7
  With bmppalette()
    
    SelectElement(bmppalette(),0)    ; first element in palette 
    For p = 0 To ListSize(bmppalette())-1
      
      Box(x*boxsize,y*boxsize,boxsize,boxsize,RGB(\r,\g,\b))
      NextElement(bmppalette())
      x=x+1 : If x = 8 : y = y+ 1 : x = 0 : EndIf 
    Next p 
    
  EndWith
  
  StopDrawing()
  StartDrawing(CanvasOutput(Canvas_Palette_Edit))
  
  Box(0,0,420,416,#Black)         ; clear the palette area 
  
  ; iterate through the loaded palette and display on Canvas_Palette
  canvaswidth = 145 : boxsize = canvaswidth / 7
  With bmppalette()
    
    SelectElement(bmppalette(),0)    ; first element in palette 
    For p = 0 To ListSize(bmppalette())-1
      
      Box(x*boxsize,y*boxsize,boxsize,boxsize,RGB(\r,\g,\b))
      NextElement(bmppalette())
      x=x+1 : If x = 8 : y = y+ 1 : x = 0 : EndIf 
    Next p 
    
  EndWith
  
  StopDrawing()
EndProcedure

Procedure LoadBMPPalette(filename$)
  
  ; gets the palette from the loaded BMP
  startoffset = 54      ; start of palette 
  With bmppalette()
    If ReadFile(0,filename$)
      ; get the size of the bmp
      
      FileSeek(0,2)         ; bmp size 
      bmpsize=ReadInteger(0)
      Debug "bmpsize : " + Str(bmpsize)
      ; start of pixel data 
      FileSeek(0,$0a)         ; offset of pixel
      pixeloffset = ReadInteger(0)
      Debug "pixel offset : " + Str(pixeloffset)
      
      FileSeek(0,$0e)         ; header size 
      headersize = ReadInteger(0)
      Debug "headersize : " + Str(headersize)
      
      ; check if its 4 / 8 bits per pixel
      FileSeek(0,$1c)         ; number of bits per pixel 4 / 8 / 24
      bitsperpixel=ReadWord(0)
      Debug "bits per pixel : " + Str(bitsperpixel)
      If bitsperpixel>=24
        MessageRequester("24bit image detected","Palettes can only be extracted from 4 or 8bit BMPs.",#PB_MessageRequester_Warning)
      EndIf               
      ; number of colours in bmp 
      FileSeek(0,$2e)         
      bmpcolour=ReadInteger(0)
      Debug "number of colours : " + Str(bmpcolour)
      
      ; width / height 
      FileSeek(0,$12)         ; width
      bitmapwidth=ReadInteger(0)
      Debug "width : " + Str(bitmapwidth)
      
      FileSeek(0,$16)         ; width
      bitmapheight=ReadInteger(0)
      Debug "height : " + Str(bitmapheight)
      If bitmapheight>192 Or bitmapwidth>256
        MessageRequester("Image Size","Image is bigger than 256*192. Is this intentional?",#PB_MessageRequester_Warning)
      EndIf
      FileSeek(0,1078)    ; start of palette 
      ClearList(bmppalette())
      For p=0 To bmpcolour-1
        AddElement(bmppalette())
        \b=ReadAsciiCharacter(0)
        \g=ReadAsciiCharacter(0)
        \r=ReadAsciiCharacter(0)
        \i=p 
        res2 = ((\r>>5) << 6) | ((\g >> 5) << 3) | (\b>>5)
        \hb = res2>>1
        \lb = res2 & 1
        ReadAsciiCharacter(0)   ; alpha not used 
        
      Next 
      
      CloseFile(0)
      
    EndIf 
  EndWith
  
  DisplayPaletteBMP()
  
EndProcedure

Procedure LoadBMPImage(infilename$)
  tilemode=0
  NAME$=GetFilePart(infilename$,#PB_FileSystem_NoExtension)
  SetGadgetText(String_Tiles,infilename$)
  StartDrawing(CanvasOutput(Canvas_Preview))
  Box(0,0,640,480,#Black)         ; clear the bitmap area 
  temp=LoadImage(#PB_Any,infilename$)
  imginheight = ImageHeight(temp): imginwidth = ImageWidth(temp)
  BMPImageIn=CopyImage(temp,#PB_Any)
  DrawImage(ImageID(BMPImageIn),0,0,ImageWidth(BMPImageIn)*zoomlevel,ImageHeight(BMPImageIn)*zoomlevel)
  ;DrawImage(ImageID(BMPImageIn),0,0,256*zoomlevel,192*zoomlevel)
  StopDrawing()
  If Right(infilename$,3)="bmp"
    ClearList(bmppalette())
    LoadBMPPalette(infilename$)
  EndIf 
  StartDrawing(ImageOutput(sourceimage))
  DrawImage(ImageID(temp),0,0)
  StopDrawing() 
  FreeImage(temp)
  PATH$=GetPathPart(infilename$)
EndProcedure

Procedure SaveBMP()
  
  ; Button_SaveBMP
  
    ImgId = GetGadgetAttribute(Canvas_Sprites, #PB_Canvas_Image)  ;Returns ImageID()
    CreateImage(20, 512, 512)
    StartDrawing(ImageOutput(20))
    DrawImage(ImgId,0,0)
    StopDrawing()
    ; SaveImage(20, "C:\GeyTest.bmp")
    SaveImage(20,"test.bmp", #PB_ImagePlugin_BMP)
    Debug "saved"
  
EndProcedure

Procedure RedrawBitmap()
  If BMPImageIn>0
    StartDrawing(CanvasOutput(Canvas_Preview))
    DrawImage(ImageID(BMPImageIn),0,0,ImageWidth(BMPImageIn)*zoomlevel,ImageHeight(BMPImageIn)*zoomlevel)
    StopDrawing()
  EndIf 
EndProcedure

Procedure ImportTiles(infilename$)
  
  size = FileSize(infilename$)
  If size > 16384
    Alert("Large TIL files","The dropped TIL/NXT is bigger thank 16kb",1) ; 1 = warning
  EndIf 
  
  If ReadFile(0,infilename$,#PB_File_SharedRead)
    
    If ReadData(0,*tilebuffer,16384)   
      
      If ListSize(palette())=0
        
        filepalette$=Left(infilename$,Len(infilename$)-3)+"nxp"
        
        If FileSize(filepalette$)
          ReadPaletteNXP()
          DisplayPaletteNXP()
        EndIf 
      EndIf
      
      DrawTiles()    
      
      SetGadgetText(String_Tiles,infilename$)
      tilemode=1 
    Else 
      Alert("Error","Could not open "+infilename$,2) ; 2 = error
    EndIf 
    CloseFile(0)
  Else
    Alert("Error","Could not open "+infilename$,2) ; 2 = error
  EndIf 
  
  
  
EndProcedure

Procedure ShowEditTiles(tilenumber)
  
  If imagetiles(tilenumber)>0
    StartDrawing(CanvasOutput(Canvas_EditTiles))
    DrawImage(ImageID(imagetiles(tilenumber)),0,0,256,256)
    StopDrawing()
    StartDrawing(CanvasOutput(Canvas_TileDisplay))
    x = 0 : y = 0 : tile = 0 
    For tiles = 0 To 255
      If IsImage(imagetiles(tiles))
        DrawImage(ImageID(imagetiles(tiles)),x,y,16,16)
      EndIf 
      x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
    Next tiles 
    StopDrawing()
    StartDrawing(CanvasOutput(Canvas_TileDisplay))
    DrawingMode(#PB_2DDrawing_Outlined)
    ;DrawText(10,10,Str(offxa)+" "+Str(offya))
    offxa = tilenumber & 31 : offya = tilenumber / 32
    ; y*32+x = num 
    ; 
    Box(offxa*16,offya*16,16,16,#Red)
    StopDrawing()
  EndIf 
  
EndProcedure

Procedure SetRGBSliders()
  
  ; this sets the RGB sliders to the currently selected fron colour 
  
  Debug EditFrontColour
  
  SelectElement(palette(),EditFrontColour)
  With palette()
    
    ;get values off list 
    r=\r : g=\g : b=\b : c=0 
    Repeat 
      a=PeekA(?LUT3BITTO8BIT+c)
      If a=r : r = c : EndIf 
      If a=g : g = c : EndIf 
      If a=b : b = c : EndIf 
      c+1 
    Until c= 8     
    SetGadgetState(TrackBar_Red,r)
    SetGadgetState(TrackBar_Green,g)
    SetGadgetState(TrackBar_Blue,b)
    SetGadgetText(String_Red,Str(\r))
    SetGadgetText(String_Green,Str(\g))
    SetGadgetText(String_Blue,Str(\b))
    res2 = ((\r>>5) << 6) | ((\g >> 5) << 3) | (\b>>5)
    res3 = res2 >>1 : res4=res2 & 1
    
    \hb=res3
    \lb=res4
    SetGadgetText(String_NextCol,Str(\hb)+"/"+Str(\lb))
    
  EndWith
  DataSection
    LUT2BITTO8BIT:
    Data.a 0,$55,$AA,$FF
    LUT3BITTO8BIT:
    Data.a 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT4BITTO8BIT:
    Data.a 0,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
  EndDataSection
EndProcedure

Procedure ReadRGBSliders()
  
  ; this sets the RGB sliders to the currently selected fron colour 
  
  Debug EditFrontColour
  
  SelectElement(palette(),EditFrontColour)
  With palette()
    
    r=GetGadgetState(TrackBar_Red)
    g=GetGadgetState(TrackBar_Green)
    b=GetGadgetState(TrackBar_Blue)
    
    ;get values off list 
    \r=PeekA(?LUT3BITTO8BIT+r) : \g=PeekA(?LUT3BITTO8BIT+g): \b=PeekA(?LUT3BITTO8BIT+b) : c=0 
    
    res2 = ((\r>>5) << 6) | ((\g >> 5) << 3) | (\b>>5)
    res3 = res2 >>1 : res4=res2 & 1
    
    \hb=res3
    \lb=res4
    SetGadgetText(String_Red,Str(\r))
    SetGadgetText(String_Green,Str(\g))
    SetGadgetText(String_Blue,Str(\b))
    
    SetGadgetText(String_NextCol,Str(\hb)+","+Str(\lb))
    
  EndWith
  DataSection
    LUT2BITTO8BIT:
    Data.a 0,$55,$AA,$FF
    LUT3BITTO8BIT:
    Data.a 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT4BITTO8BIT:
    Data.a 0,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
  EndDataSection
EndProcedure

Procedure CheckTileDisplayEvents(Type)
  
  Static startx, starty, firsttile, moveddone, movex, movey, stayx, stayy
  
  offya = GetGadgetAttribute(Canvas_TileDisplay, #PB_Canvas_MouseY) /16
  offxa = GetGadgetAttribute(Canvas_TileDisplay, #PB_Canvas_MouseX)/16
  
  StartDrawing(CanvasOutput(Canvas_TileDisplay))
  DrawText(520,30,RSet(Str(offxa),3,"0")+" / "+RSet(Str(offya),3,"0")+"  ")
  DrawText(520,50,RSet(Str(startx),3,"0")+" / "+RSet(Str(starty),3,"0")+"  ")
  DrawText(520,70,RSet(Str(offxa+offya*32),3,"0"))
  
  ;DrawText(520,70,RSet(Str(offxa),3,"0")+" / "+RSet(Str(offya),3,"0")+"  ")
  StopDrawing()
  ShowEditTiles(CurrentEditTile)
  If offxa <32 And offxa >=0 And offya >= 0 And offya < 8
    
    If Type=#PB_EventType_LeftButtonDown
      CurrentEditTile=offya*32+offxa
      ;ShowEditTiles(CurrentEditTile)
      startx = offxa : starty = offya
      StartDrawing(CanvasOutput(Canvas_TileDisplay))
      DrawText(520,10,"Tile : "+RSet(Str(CurrentEditTile),3,"0")+" / $"+RSet(Hex((CurrentEditTile),#PB_Byte),2,"0")+"  ")
      StopDrawing()
      firsttile = (starty*32+startx)
    EndIf 
    
    ; If Type = #PB_EventType_LeftButtonUp; And (GetGadgetAttribute(Canvas_TileDisplay, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)   
    If (Type = #PB_EventType_MouseMove And GetGadgetAttribute(Canvas_TileDisplay, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)  
      If (startx<>offxa)
        
        Debug "Swap" 
        Debug Str(startx)+" "+Str(starty)
        Debug Str(offxa)+" "+Str(offya)
        
        firsttile = (starty*32+startx)
        secondtile = (offya*32+offxa)
        tmp = imagetiles(firsttile)                    ; get the first tile id
        imagetiles(firsttile)=imagetiles(secondtile)   ; set the first id to secondtile 
        imagetiles(secondtile)=tmp                     ; put first tile into second
        
        StartDrawing(ImageOutput(tileorder))
        x = 0 : y = 0 : tile = 0 
        For tiles = 0 To 255
          DrawImage(ImageID(imagetiles(tiles)),x/2,y/2,8,8)
          x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        Next tiles 
        StopDrawing()
        startx = offxa
        ;         StartDrawing(CanvasOutput(Canvas_TileDisplay))
        ;         DrawImage(ImageID(tileorder),0,0,512,384)
        ;         StopDrawing() 
      ElseIf (starty > offya)
        firsttile = (starty*32+startx)
        secondtile = (offya*32+offxa)
        
        StartDrawing(ImageOutput(tileorder))
        x = 0 : y = 0 : tile = 0 
        For tiles = 0 To secondtile-1
          DrawImage(ImageID(imagetiles(tiles)),x/2,y/2,8,8)
          x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        Next tiles 
        
        DrawImage(ImageID(imagetiles(firsttile)),x/2,y/2,8,8)
        x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        For tiles = secondtile To firsttile-1
          DrawImage(ImageID(imagetiles(tiles)),x/2,y/2,8,8)
          x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        Next tiles 
        
        For tiles = firsttile+1 To 255
          DrawImage(ImageID(imagetiles(tiles)),x/2,y/2,8,8)
          x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        Next tiles 
        
        StopDrawing()
        x = 0 : y = 0 : tile = 0
        For tiles = 0 To 255
          FreeImage(imagetiles(tiles))
          imagetiles(tiles)=GrabImage(tileorder,#PB_Any,x/2,y/2,8,8)
          x=x+16 : If x=512 : x = 0 : y+16 : EndIf
        Next tiles
        ;startx = offxa : 
        starty = offya    
        ;         StartDrawing(CanvasOutput(Canvas_TileDisplay))
        ;         DrawImage(ImageID(tileorder),0,0,512,384)
        ;         StopDrawing() 
      ElseIf (starty < offya)
        
        
        Debug "down"
        Debug Str(startx)+" "+Str(starty)
        Debug Str(offxa)+" "+Str(offya)
        
        firsttile = (starty*32+startx)
        secondtile = (offya*32+offxa)
        ;tmp = imagetiles(firsttile)                    ; get the first tile id
        ;imagetiles(firsttile)=imagetiles(secondtile)   ; set the first id to secondtile
        ;imagetiles(secondtile)=tmp                     ; put first tile into second
        
        StartDrawing(ImageOutput(tileorder))
        x = startx*16 : y = starty*16 : tile = 0 
        For tiles = firsttile+1 To secondtile
          DrawImage(ImageID(imagetiles(tiles)),x/2,y/2,8,8)
          x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        Next tiles 
        
        DrawImage(ImageID(imagetiles(firsttile)),x/2,y/2,8,8)
        x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        
        
        For tiles = secondtile+1 To 255
          DrawImage(ImageID(imagetiles(tiles)),x/2,y/2,8,8)
          x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        Next tiles 
        
        ;         For tiles = secondtile To 255
        ;           DrawImage(ImageID(imagetiles(tiles)),x,y,16,16)
        ;           x=x+16 : If x=512 : x = 0 : y+16 : EndIf 
        ;         Next tiles 
        StopDrawing()
        
        x = 0 : y = 0 : tile = 0
        For tiles = 0 To 255
          FreeImage(imagetiles(tiles))
          imagetiles(tiles)=GrabImage(tileorder,#PB_Any,x/2,y/2,8,8)
          x=x+16 : If x=512 : x = 0 : y+16 : EndIf
        Next tiles
        ;startx = offxa : 
        starty = offya    
        ;         StartDrawing(CanvasOutput(Canvas_TileDisplay))
        ;         DrawImage(ImageID(tileorder),0,0,512,384)
        ;         StopDrawing()       
        
      EndIf 
    EndIf
  EndIf 
EndProcedure

Procedure CommitTileChanges()
  
  
  x = 0 : y = 0 : tile = 0
  StartDrawing(ImageOutput(tileorder))
  For tiles = 0 To 255
    If IsImage((imagetiles(tiles)))
      DrawImage(ImageID(imagetiles(tiles)),x,y)
    EndIf 
    
    x=x+8 : If x=256 : x = 0 : y+8 : EndIf
    
  Next tiles
  
  
  StopDrawing()
  
  x = 0 : y = 0 : tile = 0
  StartDrawing(ImageOutput(sourceimage))
  
  ;For tiles = 0 To 255
  DrawImage(ImageID(tileorder),x,y)
  ;  x=x+8 : If x=256 : x = 0 : y+8 : EndIf 
  ;Next tiles 
  
  StopDrawing()
  
  Convert()
  DrawTiles() 
  
EndProcedure

Procedure LoadMap(infilename$)
  
  size = FileSize(infilename$)
  offset = 0 
  If ReadFile(1,infilename$,#PB_File_SharedRead)
    
    ;While Not Eof(1)
    byte=ReadData(1,*mapbuffer,size)
    
    ;PokeA(*mapbuffer+offset,byte)
    ;offset+1
    ;Wend 
    
    ShowMemoryViewer(*mapbuffer,80*60)
    
    CloseFile(1)
    
  Else
    Debug "cannot open loadmap"
  EndIf
  
  
EndProcedure

Procedure DrawGrid()
  
  StopDrawing()
  If GetGadgetState(Checkbox_Grid)=#PB_Checkbox_Checked
    y=0
    StartDrawing(CanvasOutput(Canvas_Map))
    While y < 590 
      LineXY(0,y,520,y,#Black)
      y + mapsize
    Wend 
    x=0 
    While x < 520 
      LineXY(x,0,x,590,#Black)
      x + mapsize
    Wend  
    
    StopDrawing()
  EndIf 
  
EndProcedure


Procedure UpdateMap()
  If GetGadgetState(Checkbox_MapWord)=#PB_Checkbox_Checked
    offadd=2
  Else
    offadd=1
  EndIf 
  
  
  StartDrawing(CanvasOutput(Canvas_Map))
  off.i=(mapx*offadd)+mapy*worldwidth
  For y = 0 To viewwidth -1
    For x = 0 To viewwidth-1
      ;If mx<worldwidth
      tile=PeekA(*mapbuffer+off)
      DrawImage(ImageID(imagetiles(tile)),mx*mapsize,my*mapsize,mapsize,mapsize)
      ;EndIf 
      off+offadd 
      mx=mx+1
    Next x 
    off+worldwidth-viewwidth*offadd
    mx=0 : my + 1
  Next y 
  
  DrawGrid()
  
  Debug GetGadgetState(TrackBar_MapZoom)
  ;SetGadgetAttribute(Scrollbar_X,#PB_ScrollBar_Maximum,mapedge(GetGadgetState(TrackBar_MapZoom)-1))
  SetGadgetAttribute(Scrollbar_X,#PB_ScrollBar_Maximum,worldwidth-viewwidth)
  
  SetGadgetAttribute(Scrollbar_X,#PB_ScrollBar_PageLength,1)
  
  SetGadgetAttribute(Scrollbar_Y,#PB_ScrollBar_Maximum,16)
  SetGadgetAttribute(Scrollbar_Y,#PB_ScrollBar_PageLength,2)
  Debug zoomlevel
  ;   StartDrawing(Canv
  
EndProcedure

Procedure ProcessEditPaletteEvents(Type)
  
  Global EditFrontColour
  
  offya = GetGadgetAttribute(Canvas_Palette_Edit, #PB_Canvas_MouseY) /20
  offxa = GetGadgetAttribute(Canvas_Palette_Edit, #PB_Canvas_MouseX) /20
  
  
  If Type=#PB_EventType_LeftClick
    ; get palette 
    Debug Str(offya)+","+Str(offxa)
    EditFrontColour=offya*8+offxa 
    Debug EditFrontColour    
    SetRGBSliders() 
  EndIf 
  
EndProcedure

Procedure EditTiles(Type)
  
  offya = GetGadgetAttribute(Canvas_EditTiles, #PB_Canvas_MouseY) /32
  offxa = GetGadgetAttribute(Canvas_EditTiles, #PB_Canvas_MouseX) /32
  
  If offxa=>0 And offxa<8 And offya>=0 And offya<8
    ; If Type = #PB_EventType_LeftButtonUp; And (GetGadgetAttribute(Canvas_TileDisplay, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)   
    If Type=#PB_EventType_LeftButtonDown Or (Type = #PB_EventType_MouseMove And GetGadgetAttribute(Canvas_EditTiles, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)  
      ;If Type=#PB_EventType_LeftClick
      ; get palette 
      ;PushListPosition(palette())
      SelectElement(palette(),EditFrontColour)
      With palette()
        ; StartDrawing(CanvasOutput(Canvas_EditTiles))
        r=\r : g=\g : b=\b 
        ; Box(offxa*32,offya*32,32,32,RGB(r,g,b))
        ; StopDrawing()
        StartDrawing(ImageOutput(imagetiles(CurrentEditTile)))
        Plot(offxa,offya,RGB(r,g,b))
        StopDrawing()
        ;PopListPosition(palette())
      EndWith
    ElseIf Type=#PB_EventType_LeftButtonUp
      
    EndIf 
  EndIf 
  ShowEditTiles(CurrentEditTile)
  
EndProcedure

Procedure DrawSpriteInfo(x,y,tilenr)
  StartDrawing(CanvasOutput(Canvas_Sprites))

  If GetGadgetState(Checkbox_8px)=#PB_Checkbox_Checked
    tx$="8x8px    " 
  Else 
    tx$="16x16px  "
  EndIf 
  If GetGadgetState(Checkbox_4bitSprites)=#PB_Checkbox_Checked
    bt$="4bit 16c  "
  Else 
    bt$="8bit 256c "
  EndIf 
  DrawText(0,17*16,RSet(Str(x),3,"0")+" / "+RSet(Str(y),3,"0")+"  ")
  DrawText(0,18*16,"Sprite : "+RSet(Str(tilenr),3,"0")+" ")
  DrawText(0,19*16,tx$+bt$)
  StopDrawing()  
EndProcedure

Procedure DrawSpriteGrid()
  If GetGadgetState(Checkbox_SpriteGrid)=#PB_Checkbox_Checked
    ; do grid 

    If GetGadgetState(Checkbox_8px)=#PB_Checkbox_Checked
      stepsize = 16
    Else 
      stepsize = 32
    EndIf 
    y=0
    StartDrawing(CanvasOutput(Canvas_Sprites))
    While y < 512 
      LineXY(0,y,520,y,#Red)
      y + stepsize
    Wend 
    x=0 
    While x < 512 
      LineXY(x,0,x,590,#Red)
      x + stepsize
    Wend  
    StopDrawing()  
  EndIf 
  
EndProcedure


Procedure DrawSprites()
  
  RedrawCanvasDef()
  
  tmpsprites = CreateImage(#PB_Any,256,192)
  
  StartDrawing(ImageOutput(tmpsprites))
  DrawingMode(#PB_2DDrawing_Default)

  If GetGadgetState(Checkbox_8px)=#PB_Checkbox_Checked
  With palette()
    For yo=0 To 63 Step 8
      For xo=0 To 255 Step 8
        For y = 0 To 7
          For x = 0 To 7
            
            byte=PeekA(*spritebuffer+off)
            SelectElement(palette(),byte)
            Plot(xo+x,yo+y,RGB(\r,\g,\b))
            off+1
            
          Next x 
        Next y 
      Next xo 
    Next yo
  EndWith
Else
   With palette()
    For yo=0 To 63 Step 16
      For xo=0 To 255 Step 16
        For y = 0 To 15
          For x = 0 To 15
            
            byte=PeekA(*spritebuffer+off)
            SelectElement(palette(),byte)
            Plot(xo+x,yo+y,RGB(\r,\g,\b))
            off+1
            
          Next x 
        Next y 
      Next xo 
    Next yo
  EndWith
  EndIf 
  
  StopDrawing()
  
  ; now pick up in sprite tiles 
  xx=0 : yy = 0 
  For spr = 0 To 127
    ; free image if it already exists 
    If IsImage(spritetiles(spr))
      FreeImage(spritetiles(spr))
    EndIf 
    spritetiles(spr) = GrabImage(tmpsprites,#PB_Any,xx,yy,16,16)
   ; Debug "collected sprite "+Str(spr)
    xx+16 : If xx = 256 : yy+16 : xx = 0 : EndIf   
  Next spr 
  
  spr = 0 : tilesize = 16*2
  FreeImage(tmpsprites)
  StartDrawing(CanvasOutput(Canvas_Sprites))
  Box(0,0,512,512,#Black)
  DrawingMode(#PB_2DDrawing_Transparent)
  For y = 0 To 7
    For x = 0 To 15
      DrawImage(ImageID(spritetiles(spr)),x*tilesize,y*tilesize,tilesize,tilesize)
      spr +1  
    Next 
  Next 
  StopDrawing()
  DrawSpriteGrid()
  DrawSpriteInfo(offxa,offya,0)
  
EndProcedure


Procedure OpenSprites(infilename$)
  
  ;*spritebuffer
  size = FileSize(infilename$)
  Debug size 
  FillMemory(*spritebuffer,16384)
  If ReadFile(0,infilename$,#PB_File_SharedRead)
    
    If ReadData(0,*spritebuffer,16384)
      
      ; data now in *spritebuffer, now need to preview 
      
      DrawSprites()
      
    Else
      Debug "Cannot read data "+infilename$
      ShowMemoryViewer(*spritebuffer,512)
    EndIf
    
    CloseFile(0)
  Else
    Debug "Error cannot open "+infilename$
  EndIf
  
  
EndProcedure

Procedure ReadPalFromMem(*ptr.INTEGER, length.i)
  
  *mem = AllocateMemory(512)
  CopyMemory(*ptr\i,*mem,512)
  ;mem = ReAllocateMemory(*ptr\i,length*SizeOf(CHARACTER))
  
  If *mem 
    
    
    Global NewList importedpalette.palmap() 
    
    Dim rr(512)
    Dim gg(512)
    Dim bb(512)
    
    For x = 0 To 511 Step 2 
      AddElement(importedpalette()) 
      
      byteinH=PeekA(*mem+x)
      byteinL=PeekA(*mem+x+1)
      
      With importedpalette()
        
        d=byteinH<<1 ! byteinL 
        
        \r = PeekA(?LUT3BITTO8BIT+(d >> 6 & 7))
        \g = PeekA(?LUT3BITTO8BIT+(d >> 3 & 7))
        \b = PeekA(?LUT3BITTO8BIT+(d & 7))
        
        \i = ListIndex(importedpalette())
        \hb=byteinH
        \lb=byteinL
        
      EndWith
    Next x 
    
  EndIf 
  
  FreeMemory(*mem)
  DataSection: 
    LUT3BITTO8BIT:
    Data.a 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT2BITTO8BIT:
    Data.a 0,$55,$AA,$FF
  EndDataSection
EndProcedure

Procedure DisplayPaletteNXPL2()
  
  ; palette() 
  StartDrawing(CanvasOutput(Canvas_NXI))
  
  Box(0,0,420,416,#Black)         ; clear the palette area 
  
  ; iterate through the loaded palette and display on Canvas_Palette
  canvaswidth = 512 : boxsize = 16
  With importedpalette()
    
    SelectElement(importedpalette(),0)    ; first element in palette 
    For y = 0 To 7
      For x = 0 To 31
        
        Box(x*boxsize,y*boxsize,boxsize,boxsize,RGB(\r,\g,\b))
        NextElement(importedpalette())
        
      Next x
    Next y 
    
  EndWith
  StopDrawing()
  
EndProcedure


Procedure DisplayPaletteDefL2()
  
  ; palette() 
  StartDrawing(CanvasOutput(Canvas_NXI))
  
  Box(0,0,512,384,#Black)         ; clear the palette area 
  
  ; iterate through the loaded palette and display on Canvas_Palette
  canvaswidth = 512 : boxsize = 16
  With palette()
    
    SelectElement(palette(),0)    ; first element in palette 
    For y = 0 To 7
      For x = 0 To 31
        
        Box(x*boxsize,y*boxsize,boxsize,boxsize,RGB(\r,\g,\b))
        NextElement(palette())
        
      Next x
    Next y 
    
  EndWith
  StopDrawing()
  
EndProcedure

Procedure RedrawCanvasDefL2()
  
  ClearList(palette())
  SelectElement(palette(),0)
  While ListSize(palette())<256
    AddElement(palette())
  Wend 
  StartDrawing(CanvasOutput(Canvas_NXI))
  With palette()
    For y = 0 To 191
      For x = 0 To 255
        
        sl2byte = PeekA(*sl2buffer+position)
        ;rgb92rgb24(sl2byte)
        SelectElement(palette(),sl2byte)
        
        rgb82rgb24(sl2byte)
        
        
        rf.f=r/100*redslider 
        gf.f=g/100*greenslider 
        bf.f=b/100*blueslider 
        
        r9.i=Int(rf) : g9.i= Int(gf) : b9.i = Int(bf) 
        
        res2.i  = (((r9>>5) << 6) | ((g9 >> 5) << 3) | (b9>>5))>>1
        res3.i = res2 & 1 
        rgb9.i = (res2<<1) ! res3
        rgb92rgb24(rgb9)

        
        \r=r : \g = g : \b = b
        Box(x*2,y*2,2,2,(RGB(r,g,b)))
        position+1 
        
      Next x
    Next y 
    StopDrawing()
  EndWith
 ; DisplayPaletteDefL2()
  
EndProcedure


Procedure ReadSL2(infile$)
  
  If ReadFile(0,infile$)
    f = FileSize(infile$)
    newimage = CreateImage(#PB_Any,512,384)
    
    
    If ReadData(0,*sl2buffer,f)
      Debug "Data now in buffer"
      
      If f>49152
        ReadPalFromMem(@*sl2buffer,512)
        
        position = 512
        
        StartDrawing(ImageOutput(newimage))
        With importedpalette()
          For y = 0 To 191
            For x = 0 To 255
              
              sl2byte = PeekA(*sl2buffer+position)
              ;rgb92rgb24(sl2byte)
              
              SelectElement(importedpalette(),sl2byte)
              Box(x*2,y*2,2,2,(RGB(\r,\g,\b)))
              position+1 
              
            Next x
          Next y 
        EndWith
        StopDrawing()
       ; DisplayPaletteNXPL2()
        Debug "File has palette"
      Else 
        position = 0 
        
        ; StartDrawing(ImageOutput(newimage))
     ;   RedrawCanvasDefL2()
      EndIf
    Else 
      Debug "Failed to load sl2 file"
    EndIf 
  ;  FreeMemory(*sl2buffer)
    CloseFile(0)
  Else
    Debug "failed to load sl2 file"
  EndIf 
  ResizeImage(newimage,640,480,#PB_Image_Raw)
  StartDrawing(CanvasOutput(Canvas_NXI))
    DrawImage(ImageID(newimage),0,0)
  StopDrawing()
  FreeImage(newimage)
  
EndProcedure




Procedure PrcoessSpriteEvents(Type)
  
  If GetGadgetState(Checkbox_8px)=#PB_Checkbox_Checked
    stepsize = 32
    stepsize2= 16
  Else 
    stepsize = 16
    stepsize2 = 32
  EndIf 
  
  offya = GetGadgetAttribute(Canvas_Sprites, #PB_Canvas_MouseY) /stepsize2
  offxa = GetGadgetAttribute(Canvas_Sprites, #PB_Canvas_MouseX) /stepsize2
  
  If offxa>=0 And offxa=<512 And offya>=0 And offya=<512
    
  DrawSpriteInfo(offxa,offya,offya*stepsize+offxa)
  
  If Type=#PB_EventType_LeftClick
    ; get palette 
    Debug Str(offya)+","+Str(offxa)   
    Debug offya*stepsize2+offxa 
  
  EndIf 
  
  EndIf 
  
EndProcedure


Procedure NXILoad(infilename$)
  
  ReadSL2(infilename$)
  
EndProcedure

Procedure ImportCSV(infilename$)
  
  size = FileSize(infilename$)
  
  If size > 0 
    
    If ReadFile(0,infile$,#PB_File_SharedRead)
      
      position = 0 
      While Not Eof(0)
        
        inbyte$=ReadString(0)
        
        
        
        PokeA(*mapbuffer+position,inbyte)
        PokeA(*mapbuffer+position+1,inbyte+1)
        
        position+2 
        
      Wend 
              
    Else
      Debug "failed to open : "+infilename$
    EndIf 
  EndIf 
  
  
EndProcedure



Procedure Setup()
  tilemode=0 : BMPImageIn=0
  StartDrawing(CanvasOutput(Canvas_Preview))
  Box(0,0,512,384,#Black)
  DrawText(10,10,"Drop BMP/PNG here",#Yellow)
  DrawText(10,30,"Drop PAL/NXP Palettes here",#Yellow)
  DrawText(10,50,"Drop TIL to view a .til file",#Yellow)
  StopDrawing()
  StartDrawing(CanvasOutput(Canvas_EditTiles))
  Box(0,0,256,256,#Black)
  StopDrawing() 
  StartDrawing(CanvasOutput(Canvas_TileDisplay))
  Box(0,0,650,256,#Black)
  StopDrawing()
  StartDrawing(CanvasOutput(Canvas_Palette))
  Box(0,0,450,570,#Black)
  StopDrawing()
  SetGadgetText(String_fpal,"")
  SetGadgetText(String_Tiles,"")
  ClearList(palette()): ClearList(bmppalette())
  StartDrawing(CanvasOutput(Canvas_Map))
  Box(0,0,720,590,#Black)
  For y = 0 To 590 Step 22
    LineXY(0,y,720,y,#White)
  Next 
  For x = 0 To 720 Step 22
    LineXY(x,0,x,590,#White)
  Next 
  
  StopDrawing()
  
  ;   StartDrawing(CanvasOutput(Canvas_Back))
  ;   Box(0,0,720,590,#Black)
  ;   StopDrawing() 
EndProcedure
SetGadgetState(TrackBar_Zoom,zoomlevel)
SetGadgetAttribute(Scrollbar_X,#PB_ScrollBar_Maximum,80)
;SetGadgetAttribute(Scrollbar_X,#PB_ScrollBar_PageLength,80/4)
SetGadgetAttribute(Scrollbar_Y,#PB_ScrollBar_Maximum,60/2)
SetGadgetAttribute(Scrollbar_Y,#PB_ScrollBar_PageLength,60/4)
EnableGadgetDrop(Canvas_Preview,    #PB_Drop_Files,   #PB_Drag_Copy)
EnableGadgetDrop(Canvas_Palette,    #PB_Drop_Files,   #PB_Drag_Copy)
EnableGadgetDrop(Canvas_Map,    #PB_Drop_Files,   #PB_Drag_Copy)
EnableGadgetDrop(Canvas_Sprites,    #PB_Drop_Files,   #PB_Drag_Copy)
EnableGadgetDrop(Canvas_NXI,    #PB_Drop_Files,   #PB_Drag_Copy)

Setup()

Repeat
  event=WaitWindowEvent()
  
  Select event
    Case #PB_Event_CloseWindow
      quit=1
      
    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget()
          
        Case Button_Convert
          If GetGadgetText(String_Tiles)<>""
            
            Convert()
            ShowEditTiles(0)
          Else
            MessageRequester("Error","You need to drop an image before you can convert")
          EndIf 
        Case Button_SavesTiles
          SaveTiles()
        Case Button_SaveNXP
          
        Case Button_Next 
          If CurrentEditTile< 255 : CurrentEditTile+1 : EndIf 
          ShowEditTiles(CurrentEditTile)
          Debug CurrentEditTile
          
        Case Button_Back 
          If CurrentEditTile> 0 : CurrentEditTile-1 : EndIf 
          ShowEditTiles(CurrentEditTile)
          Debug CurrentEditTile
          
        Case Button_Clear
          
          Setup()
          ClearList(bmppalette())
          ClearList(palette())
          
        Case TrackBar_Zoom
          zoomlevel = GetGadgetState(TrackBar_Zoom)*2
          If tilemode=1
            DrawTiles()
          Else 
            RedrawBitmap()          
          EndIf
          
        Case Canvas_TileDisplay
          Type=EventType()
          CheckTileDisplayEvents(Type)
          
        Case Canvas_Palette_Edit 
          Type=EventType()
          ProcessEditPaletteEvents(Type)
          
        Case Canvas_EditTiles 
          Type=EventType()
          EditTiles(Type)
        Case Canvas_Sprites
          Type=EventType()
          PrcoessSpriteEvents(Type)
          
          
          
        Case TrackBar_Red,TrackBar_Green,TrackBar_Blue 
          ReadRGBSliders()
          DisplayPaletteNXP()
          ShowEditTiles(CurrentEditTile)
          
        Case Button_Commit
          CommitTileChanges()
          
        Case Checkbox_Grid
          UpdateMap()
          
        Case Scrollbar_Y
          mapy=GetGadgetState(Scrollbar_y)
          UpdateMap()
          
        Case Scrollbar_X
          mapx=GetGadgetState(Scrollbar_x)
          Debug mapx
          UpdateMap()
        Case String_MapHeight
          mapy=GetGadgetState(Scrollbar_y)
          UpdateMap()
          
        Case Spin_mapx
          worldwidth=GetGadgetState(Spin_mapx)
          Debug worldwidth
          UpdateMap()
          
        Case Spin_test
          mapedge=GetGadgetState(Spin_test)
          Debug worldwidth
          UpdateMap()
          
        Case TrackBar_MapZoom
          mapsize=8*GetGadgetState(TrackBar_MapZoom)
          
          viewwidth=520/mapsize 
          Debug TrackBar_MapZoom
          UpdateMap()
          
        Case Checkbox_8px 
          DrawSprites()
          
        Case Checkbox_SpriteGrid
          DrawSprites()
          
          ; save a bmp of the sprites
          
        Case Button_SaveBMP
          Debug "save bmp" 
          SaveBMP()
          
      EndSelect
      
    Case #PB_Event_GadgetDrop
      Select EventGadget()
        Case Canvas_Preview, Canvas_Palette, Canvas_Map,Canvas_Sprites, Canvas_NXI
          
          Files$ = EventDropFiles()
          Count  = CountString(Files$, Chr(10)) + 1
          For i = 1 To Count
            File$=LCase(StringField(Files$, i, Chr(10)))
            Select Right(File$,3)
              Case "bmp","png"
                infilename$=File$
                
                
                LoadBMPImage(infilename$)
                
              Case "pal"
                filepalette$=File$
                size = FileSize(filepalette$)
                If size>0 And size<=768
                  SetGadgetText(String_fpal,File$)
                  If size=512
                    ReadPaletteNXP()
                  Else
                    
                    ReadPaletteA()
                  EndIf 
                  
                  DisplayPaletteNXP()
                Else
                  MessageRequester("Error","PAL does not meet expected size!"+#LF$+"A plain PAL file should be 768 bytes in size",#PB_MessageRequester_Error)
                EndIf 
              Case "nxp"
                filepalette$=File$
                size = FileSize(filepalette$)
                If size>0
                  SetGadgetText(String_fpal,File$)
                  ReadPaletteNXP()
                  DisplayPaletteNXP()     
                Else
                  MessageRequester("Error","NXP does not meet expected size!"+#LF$+"An NXP should not be 0 bytes!",#PB_MessageRequester_Error)
                EndIf 
              Case "til","nxt"
                filepalette$=File$
                ImportTiles(filepalette$)
                ShowEditTiles(0)
              Case "map"
                Debug "map loaded"
                LoadMap(File$)
                UpdateMap()
              Case "spr"
                Debug "Sprite found"
                filepalette$=File$
                OpenSprites(filepalette$)
                SetGadgetState(Panel_0,3)
              Case "nxi"
                Debug "nxi found"
                filepalette$=File$ 
                NXILoad(filepalette$)
              Case "csv"
                Debug "csv found"
                filepalette$=File$ 
                SetGadgetState(Panel_0,2)
                ImportCSV(filepalette$)
                UpdateMap()
            EndSelect
            
          Next i
      EndSelect
      
      Debug "drop"
  EndSelect
  
  
  If x=#PB_Event_CloseWindow
    quit=1
  EndIf
  
Until quit=1

; IDE Options = PureBasic 6.00 Beta 10 (Windows - x64)
; CursorPosition = 726
; FirstLine = 88
; Folding = AAKAADg
; EnableXP