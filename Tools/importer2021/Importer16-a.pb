; sebestian weikum - out back (antoher ambition remix (nuevadeep)
; darius and crayon alicia <3 <3 <3 <3 <3 <3 <3 <3 <3
UsePNGImageDecoder()
UseJPEGImageDecoder()
UsePNGImageEncoder()
UseCRC32Fingerprint()
Structure palmap
  r.i
  g.i
  b.i
  i.i
EndStructure
Structure block
  crc.s
  buff.s
EndStructure
Structure tile
  id.i
  t.i
  pa.i
  x.i
  y.i
  w.i
  h.i
  s.i
  pb.i
  kb.i
EndStructure

XIncludeFile("Importer2.pbf")
XIncludeFile("adaptpalette.pbi")

Global file$="sheet1.bmp"
Global NewList palette.palmap() 



Global canvasimage, found, blkoff, blksize=16, bank=0, numtiles=0, bkimage, col8bit, custompalette=2
Global Dim pals(10)
Global NewList blocks.block() 
Global NewList tiles.tile() 
Global Dim colbyte(maxblock*9)

#WIDTH = 768
#HEIGHT = 576

Global canvasimage=CreateImage(#PB_Any,768,576) 

; ALlocate some memory for the blocks. 
; 16kb should be enough
Global *blocks = AllocateMemory(16384*4)
Global *blocks_bank2 = AllocateMemory(16384*4)
Global *blocks_bank3 = AllocateMemory(16384*4)
Global *scrbuff 

; And some temp memory
Global *temp = AllocateMemory(256)
; map memory 
Global *map = AllocateMemory(32*24*256)  ; 256 screens of 32x24 8x8px blocks

; procs 


Procedure ReadPalette()
  If ReadFile(1,"r3g3b2.txt")
    l=Lof(1)
    Dim ii$(3)
    
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

Procedure ReadCustomPalette(file$)
  
  If ReadFile(1,file$,#PB_File_SharedRead)
    l=Lof(1)
    Dim ii$(3)
    
    ClearList(palette())
    
    Dim rr(256)
    Dim gg(256)
    Dim bb(256)
    
    If custompalette = 2          ; pal file 
                                  ; standard 3 byte palette file 
      
      While Not Eof(1)
        
        If i = 175 
            Debug "break"
          EndIf 
        
        RR=ReadAsciiCharacter(1)
        GG=ReadAsciiCharacter(1)
        BB=ReadAsciiCharacter(1)
        
        AddElement(palette()) 
        
        With palette()
          \r = RR
          \g = GG
          \b = BB
          \i = ListIndex(palette())
        EndWith
        i+1
      Wend
      
      CloseFile(1)  
    Else
      MessageRequester("ERROR!","Cannot load "+file$+" palette!")
      End 
    EndIf
    
  EndIf

  
EndProcedure

Procedure LoadBMP(w.i,h.i)
  
  Global image$=OpenFileRequester("Open bitmap",GetCurrentDirectory()," images |*.bmp;*.png;*.jpg;*.gif",0)
  
  ;result = ReadFile(1,image$, #PB_File_SharedRead )
  
  Debug image$
  
  If image$<>""
    
    ;image = CreateImage(#PB_Any,256*2,192*2)
    
    ;FreeImage(hImage)
    
    hImage = LoadImage(#PB_Any, image$ )
    
    If hImage
      
      i = ImageTo8bit(ImageID(hImage), 1) 
      
      *image = Save8bitImage(i, "", 1) 
      ;Save8bitImage(i, "testme.bmp", 00)
      ;ResizeImage(1,512,64*2,#PB_Image_Raw )
      
      j = CatchImage(#PB_Any, *image) 
      
      ;Save8bitImage(i, "Z:\GoogleDrive\speccy\udjeednext\temp.bmp") 
      
      StartDrawing(CanvasOutput(Canvas_Import))
      
      
      Box(0,0,512,384,RGB(40,40,40))
    ;  DrawImage(ImageID(j),0,0,ImageWidth((j))+w,ImageHeight((j))+h)
      DrawImage(ImageID(hImage),0,0,ImageWidth((hImage))+w,ImageHeight((hImage))+h)
      
      StopDrawing()
      
      ;SetGadgetState (Spin_RX, ImageWidth(j)) : SetGadgetText(Spin_RX, Str(ImageWidth(j)))
      ;SetGadgetState (Spin_RY, ImageHeight(j)) : SetGadgetText(Spin_RY, Str(ImageHeight(j)))
      
    EndIf 
    
  EndIf
  
EndProcedure

Procedure LoadBKImage()
  
  Global bkimage = LoadImage(#PB_Any, file$ )      ; load image 
  
  Global fname$ = file$
  
  ; make a copy that we can resize and draw 
  
  If bkimage
    
    ;ResizeImage(bkimage,256,192,#PB_Image_Raw)
    If custompalette = 0 
      i = ImageTo8bit(ImageID(bkimage), 1) 
      *image = Save8bitImage(i, "", 1)  
      bkimage = CatchImage(#PB_Any, *image) 
      
      CopyImage(bkimage,bigbkimage)
      
      FreeMemory(*image)
    Else 
      
      CopyImage(bkimage,bigbkimage)
      
      
      If ImageHeight(bkimage)<192 Or ImageWidth(bkimage)<256
        temp=CreateImage(#PB_Any,256,192)
        StartDrawing(ImageOutput(temp))
        DrawImage(ImageID(bkimage),0,0)
        StopDrawing()
        FreeImage(bigbkimage)
        bigbkimage=CopyImage(temp,#PB_Any)
        FreeImage(bkimage)
        bkimage=CopyImage(bigbkimage,#PB_Any)
      EndIf 
    EndIf 
    
    ResizeImage(bigbkimage,#WIDTH,#HEIGHT,#PB_Image_Raw)
    ; show on canvas 
    
    ;StartDrawing(CanvasOutput(Canvas_Import))
    
    
    
  EndIf
  
  StartDrawing(ImageOutput(canvasimage))
  DrawImage(ImageID(bigbkimage),0,0,#WIDTH,#HEIGHT)
  ;DrawImage(ImageID(bigbkimage),0,0)
  StopDrawing()
  
EndProcedure

Procedure ColorLookup(x,y)
  Static curcol.a;, res2.b, 
  Static r.a, g.a, b.a ; , retcol.b
  retcol = 0 
  ;StartDrawing(ImageOutput(bkimage))
  col = Point (x,y)
  r = Red(col)
  g = Green(col)
  b = Blue (col)
  ;   ForEach palette()
  ;     With palette()
  ;       If r = \r And g = \g And b = \b
  ;         curcol = ListIndex(palette())
  ;         retcol = curcol
  ;         Break 
  ;       EndIf
  ;     EndWith
  ;   Next
  
  If custompalette > 0 
    ForEach palette()
      With palette()
        If r = \r And g = \g And b = \b
          curcol = ListIndex(palette())
          retcol = curcol
          Break 
        EndIf
      EndWith
    Next
    ProcedureReturn retcol 
    
  Else 
    
    res2 = ((r>>5) << 6) | ((g >> 5) << 3) | (b>>5)
    ; res2 = ((r>>5) << GetGadgetState(TrackBar_Red)) | ((g >> 5) << 3) | (b>>5)
    ; res2 = ((r>>5) << 6) | ((g >> 5) << GetGadgetState(TrackBar_Red)) | (b>>5)
    ;	'res3=res2 >>1 : sb=res2 band 1
    ;	NextRegA($44,cast(ubyte,res2>>1))
    ;	NextRegA($44,cast(ubyte,res2 band 1))
    curcol = (res2 >> 1) ;& (res2 & 1 ) 
    retcol = curcol
    
    
    
    ProcedureReturn retcol 
  EndIf 
  ;StopDrawing()
  
EndProcedure

Procedure UpdateCanvas()
  
  StartDrawing(CanvasOutput(Canvas_Import))
  DrawImage(ImageID(canvasimage),0,0,#WIDTH,#HEIGHT)
  StopDrawing()
  
EndProcedure

Procedure DrawGrid()
  
  StartDrawing(ImageOutput(canvasimage))
  For y = 0 To 23 Step 2
    For x = 0 To 31 Step 2 
      Line(x*24,0,1,#HEIGHT,#Blue)
      Line(0,y*24,#WIDTH,1,#Blue)
    Next
  Next
  StopDrawing()
  
  
EndProcedure

Procedure CheckBlock(size=256)
  
  
  Static c
  found = #False
  finger$ = Fingerprint(*temp,size,#PB_Cipher_CRC32)
  ;finger$ = PeekS(*temp,size,#PB_Ascii)
  ;;Debug finger$
  ; byte.b=255
  
  ; For x= 0 To 63
  ;   byte = byte ! PeekA(*temp+x)
  ; Next 
  ; finger$=Str(byte)
  With blocks()
    ForEach blocks()
      ;Debug    blocks()\crc
      
      ;  If CompareMemory(*temp,blocks()\bff
      If finger$ =    blocks()\crc
        ;Debug "Found block already "+finger$
        found = 0
        ProcedureReturn ListIndex(blocks())
        Break 1
      EndIf 
    Next 
  EndWith
  
  ;If found = #False
  AddElement(blocks())
  blocks()\crc=finger$
  Debug "added "+finger$
  c=ListIndex(blocks())
  found = 1 
  Debug c
  numtiles = c - 1 
  ;EndIf 
  ProcedureReturn c
EndProcedure

Procedure SaveData(mode=0)
  Debug Left(in$,Len(in$)-3)+"bin"
  
  in$ = file$
  
  If mode=0
    If OpenFile(0,Left(in$,Len(in$)-3)+"bin")
      WriteData(0,*Map,768)
      CloseFile(0)
    EndIf
  EndIf 

  If OpenFile(1,Left(in$,Len(in$)-3)+"spr")
    WriteData(1,*blocks,16384)
    CloseFile(1)
  Else
    Debug "error saving blocks.spr"
  EndIf
  
  If bank>0
    If OpenFile(1,Left(in$,Len(in$)-4)+"2.spr")
      WriteData(1,*blocks_bank2,16384)
      CloseFile(1)
    EndIf
  EndIf
  
  
EndProcedure

Procedure RemapTo9bit()
  
  ; 	Dim res2,sb,res3 As uinteger
  ; 	For c=0 To 255*4 Step 4	
  ; 		b9=peek(@palette+cast(uinteger,c))
  ; 		g9=peek(@palette+cast(uinteger,c+1))
  ; 		r9=peek(@palette+cast(uinteger,c+2))
  ; 		res2 = ((r9>>5) << 6) BOR ((g9 >> 5) << 3) BOR (b9>>5)
  ; 		'res3=res2 >>1 : sb=res2 band 1
  ; 		NextRegA($44,cast(ubyte,res2>>1))
  ; 		NextRegA($44,cast(ubyte,res2 band 1))
  ; 		sb = 0
  ; 	Next c 
  
EndProcedure

Procedure GetBlocks16()
  
  ; grab block 
  blkoff = 0 
  ; outer loop to move across screen 
  
  gs = GetGadgetState(Checkbox_values)    ; store the state of Show Values
  
  For yy = 0 To 192-8 Step 16 
    For xx = 0 To 256-8 Step 16
      
      found = 0 
      offset = 0 
      ; inner loop to read block ay xx,yy
      StartDrawing(ImageOutput(bkimage))    
      For y = 0 To 15                     ; read 16 pix across and down 
        For x = 0 To 15
          ;val = Point(x+xx,y+yy)
          val2 = ColorLookup(x+xx,y+yy)
          PokeA(*temp+offset,val2)        ; poke value to temp buffer 
          offset = offset + 1             ; increse offset for px
        Next  
      Next 
      StopDrawing()
      
      blk = CheckBlock()                  ; set blk to checkblock result
      
      offset=0
      ; test 
      If found > 0                        ; new block was found not in list 
        StartDrawing(CanvasOutput(Canvas_Import))
        DrawingMode(#PB_2DDrawing_Outlined )
        
        ;{          
        ;}        ;DrawingMode(#PB_2DDrawing_AlphaBlend  )
        
        Box(xx*3,yy*3,48,48,#Red)         ; highlight new block with red 
        DrawingMode(#PB_2DDrawing_Default )
        StopDrawing()
        
        If blk=64 And bank=0             ; have we exceeded the 16kb bank?
          bank+1                         ; yes next bank
          blkoff=0
          
          
        EndIf 
        If bank=0
          CopyMemory(*temp,*blocks+blkoff,256)
        Else 
          CopyMemory(*temp,*blocks_bank2+blkoff,256)
        EndIf 
        
        blkoff+256                        ; increase the blkoff amount by 256
        
      EndIf 
      
      ; stop in the map 
      
      PokeA(*map+((xx/16)+(yy/16)*16),blk)  ; poke the tile number to memory 
      
      ; show tile value
      If blk>0  And gs= 1
        StartDrawing(CanvasOutput(Canvas_Import))
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
        DrawText(xx*3,yy*3,Str(blk),#White)
        DrawingMode(#PB_2DDrawing_Default )
        StopDrawing()
      EndIf 
    Next 
  Next 
  ;ShowMemoryViewer(*map,768)
  
  
EndProcedure

Procedure GetBlocksSpectrum()
  
  ; grab block 
  
  gs = GetGadgetState(Checkbox_values)    ; store the state of Show Values
  
  ; outer loop to move across screen 
  
  For yy = 0 To 192-8 Step 8 
    For xx = 0 To 256-8 Step 8
      
      found = 0 
      offset = 0 
      ; inner loop to read block ay xx,yy
      StartDrawing(ImageOutput(bkimage))    
      For y = 0 To 7
        For x = 0 To 7
          ; val = Point(x+xx,y+yy)
          val2 = ColorLookup(x+xx,y+yy)
          PokeA(*temp+offset,val2)       ; poke value to temp buffer 
          offset = offset + 1
        Next 
      Next 
      StopDrawing()
      
      blk = CheckBlock(64)
      
      offset=0
      ; test 
      If found > 0
        StartDrawing(CanvasOutput(Canvas_Import))
        DrawingMode(#PB_2DDrawing_Outlined )
        
        ;         For y = 0 To 8
        ;           For x = 0 To 7
        ;             
        ;             val = PeekA(*temp+offset)       ; poke value to temp buffer 
        ;             SelectElement(palette(),val)
        ;             col = RGB(palette()\r,palette()\g,palette()\b)
        ;             ;Plot(x,y,val)
        ;            ; Box(xx*3+x*3,yy*3+y*3,3,3,col)
        ;             
        ;             offset = offset + 1
        ;           Next 
        ;         Next 
        
        ;DrawingMode(#PB_2DDrawing_AlphaBlend  )
        Box(xx*3,yy*3,24,24,#Red)
        DrawingMode(#PB_2DDrawing_Default )
        StopDrawing()
        CopyMemory(*temp,*blocks+blkoff,64)
        blkoff+64
        
      EndIf 
      
      ; stop in the map 
      
      PokeA(*map+((xx/8)+(yy/8)*32),blk)
      If blk>0  And gs= 1
        StartDrawing(CanvasOutput(Canvas_Import))
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
        DrawText(xx*3,yy*3,Hex(blk),#White)
        DrawingMode(#PB_2DDrawing_Default )
        StopDrawing()
      EndIf
      
    Next 
  Next 
  ShowMemoryViewer(*map,768)
  
  
EndProcedure


Procedure GetBlocks(mode=0)
  
  ; grab block 
  
  gs = GetGadgetState(Checkbox_values)    ; store the state of Show Values
  
  ; outer loop to move across screen 
  
  
  If mode = 1 And GetGadgetState(LI_Tiles)>-1 ; get blocks just for selection
    blkoff=0 
    Selected=GetGadgetState(LI_Tiles)
    push=ListIndex(tiles())

    SelectElement(tiles(),Selected)
    With tiles()
      stx=\x*8
      sty=\y*8
      enx=(\x*8)+((1+\w)*8)-8
      eny=(\y*8)+((1+\h)*8)-8
    EndWith
    SelectElement(tiles(),push)
    numtiles=0 : ClearList(blocks())
  Else
    blkoff=0 
    stx=0
    sty=0
    eny=192-8
    enx=256-8
  EndIf 
  
  
  For yy = sty To eny Step 8 
    For xx = stx To enx Step 8
      
      found = 0 
      offset = 0 
      ; inner loop to read block ay xx,yy
      StartDrawing(ImageOutput(bkimage))    
      For y = 0 To 7
        For x = 0 To 7
          ; val = Point(x+xx,y+yy)
          val2.a = ColorLookup(x+xx,y+yy)
          PokeA(*temp+offset,val2)       ; poke value to temp buffer 
          offset = offset + 1
        Next 
      Next 
      StopDrawing()
      
      blk = CheckBlock(64)
      
      offset=0
      ; test 
      If found > 0
        ; found unique tile so do red box and store it 
        StartDrawing(CanvasOutput(Canvas_Import))
        DrawingMode(#PB_2DDrawing_Outlined )
        Box(xx*3,yy*3,24,24,#Red)
        DrawingMode(#PB_2DDrawing_Default )
        StopDrawing()
        ; this is the block data in ram
        ; blkoff is the offset from start 
        ; we need to flatten this on each call
        ; for mode = 1 selection
        CopyMemory(*temp,*blocks+blkoff,64)
        blkoff+64
        
      EndIf 
      
      ; store in the map 
      
      PokeA(*map+((xx>>3)+(yy>>3)<<5),blk)
      
      ; show tile values 
      
      If blk>0  And gs= 1
        StartDrawing(CanvasOutput(Canvas_Import))
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
        DrawText(xx*3,yy*3,Hex(blk),#White)
        DrawingMode(#PB_2DDrawing_Default )
        StopDrawing()
      EndIf
      
    Next 
  Next 
  ShowMemoryViewer(*map,768)
  
  
EndProcedure

Procedure RemapImageTo9bit()
  
  For yy = 0 To 192-8 Step 8 
    For xx = 0 To 256-8 Step 8
      
      StartDrawing(ImageOutput(bkimage))    
      For y = 0 To 7
        For x = 0 To 7
          ; val = Point(x+xx,y+yy)
          ;';val2 = ColorLookup(x+xx,y+yy)
          col=Point(x+xx,y+yy)

          r.a = PeekA(?LUT3BITTO8BIT+(col >> 6 & 7 ))
          g.a = PeekA(?LUT3BITTO8BIT+((col >> 3) & 7))
          b.a = PeekA(?LUT3BITTO8BIT+(col & 7))         

          Plot(x+xx,y+yy,RGB(r,g,b))       ; poke value to temp buffer 

        Next 
      Next 
      StopDrawing()
      
    Next 
  Next 

    DataSection:
    LUT2BITTO8BIT:
    Data.b 0,$55,$AA,$FF
    LUT3BITTO8BIT:
    Data.b 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT4BITTO8BIT:
    Data.b 0,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
  EndDataSection
  

  
EndProcedure



Procedure UpdateTiles16()
  
  offset = 0                                      
  StartDrawing(CanvasOutput(Canvas_Blocks))      ; select Canvas_Blocks to draw on
  Box(0,0,380,1280,#Black)                        ; Draw a black back ground 
  
  For c = 0 To numtiles                          ; loop for number of tiles in list
    
    For y = 0 To 15                              ; loop acroos and down 
      For x = 0 To 15          
        val = PeekA(*blocks+offset+offadd)       ; get value from *blocks+offset+offadd
        
        If custompalette > 0 
          SelectElement(palette(),val)             ; select correct colour 
          col = RGB(palette()\r,palette()\g,palette()\b)
          r.a = Red(col)
          g.a = Green(col)
          b.a = Blue(col)
        Else 
          
          ; 8 bit to 24
          If col8bit=1
            r.a = PeekA(?LUT3BITTO8BIT+(val >> 5))
            g.a = PeekA(?LUT3BITTO8BIT+((val >> 2) & 7))
            b.a = PeekA(?LUT2BITTO8BIT+(val & 3))
          Else 
            ; 9 bit to 24 
            
            r.a = PeekA(?LUT3BITTO8BIT+(val >> 6 & 7 ))
            g.a = PeekA(?LUT3BITTO8BIT+((val >> 3) & 7))
            b.a = PeekA(?LUT3BITTO8BIT+(val & 7))
          EndIf 
        EndIf 
        ;Plot(x,y,val)
        ; Box(xxbl*32+(x*2),yybl*32+(y*2),2,2,col)     ; draw box to canvas_blocks
        Box(xxbl*32+(x*2),yybl*32+(y*2),2,2,RGB(r,g,b))     ; draw box to canvas_blocks
        offadd+1                                            ; increase offadd by 1 
      Next 
    Next
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(xxbl*32,yybl*32,Str(c))
    DrawingMode(#PB_2DDrawing_Default)
    xxbl+1                                       ; increase xxbl 
    If xxbl>=8                                   ; if 12 or more reset xxlb and increse
      xxbl=0
      yybl+1                                     ; yybl by 1 
    EndIf
    offset+256 : offadd = 0                      ; next tile to show 
  Next 
  
  For y = 0 To 100
    For x = 0 To 11 
      Line(x*32,0,1,#HEIGHT,#Blue)
      Line(0,y*32,#WIDTH,1,#Blue)
    Next
  Next
  
  StopDrawing()
  
  DataSection:
    LUT2BITTO8BIT:
    Data.b 0,$55,$AA,$FF
    LUT3BITTO8BIT:
    Data.b 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT4BITTO8BIT:
    Data.b 0,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
  EndDataSection
  
  
  
EndProcedure

Procedure UpdateTiles()
  
  offset = 0 : offadd=0                                     
  StartDrawing(CanvasOutput(Canvas_Blocks))      ; select Canvas_Blocks to draw on
  Box(0,0,380,830,#Black)                        ; Draw a black back ground 
  
  For c = 0 To numtiles+1                          ; loop for number of tiles in list
    
    For y = 0 To 7                              ; loop acroos and down 
      For x = 0 To 7          
        val = PeekA(*blocks+offset+offadd)       ; get value from *blocks+offset+offadd
                                                 ;SelectElement(palette(),val)             ; select correct colour 
                                                 ;col = RGB(palette()\r,palette()\g,palette()\b)
                                                 ;Plot(x,y,val)
        
        
        
        
        r.a = PeekA(?LUT3BITTO8BIT+(val >> 5))
        g.a = PeekA(?LUT3BITTO8BIT+((val >> 2) & 7))
        b.a = PeekA(?LUT2BITTO8BIT+(val & 3))
        
        
        Box(xxbl*32+(x*4),yybl*32+(y*4),4,4,RGB(r,g,b))     ; draw box to canvas_blocks
        offadd+1                                            ; increase offadd by 1 
      Next 
    Next
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(xxbl*32,yybl*32,Hex(c))
    DrawingMode(#PB_2DDrawing_Default)
    xxbl+1                                       ; increase xxbl 
    If xxbl>=8                                   ; if 12 or more reset xxlb and increse
      xxbl=0
      yybl+1                                     ; yybl by 1 
    EndIf
    offset +64: offadd = 0                      ; next tile to show 
  Next 
  
  ;StartDrawing(ImageOutput(Canvas_Blocks))
  For y = 0 To 25 
    For x = 0 To 11  
      Line(x*32,0,1,#HEIGHT,#Blue)
      Line(0,y*32,#WIDTH,1,#Blue)
    Next
  Next
  StopDrawing()
  
  StopDrawing()
  
  DataSection:
    LUT2BITTO8BIT:
    Data.b 0,$55,$AA,$FF
    LUT3BITTO8BIT:
    Data.b 0,$24,$49,$6D,$92,$B6,$DB,$FF
    LUT4BITTO8BIT:
    Data.b 0,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
  EndDataSection
EndProcedure


Procedure DrawBlocks(scalefactor,maxwidth=9)
  ; array of colours
  
  Dim c.i(16)
  
  c(0)=RGB(0,0,0)   ; black
  c(1)=RGB(0,0,202) ; blue
  c(2)=RGB(202,0,0) ; red
  c(3)=RGB(202,0,202)   ; megenta
  c(4)=RGB(0,202,0)     ; green
  c(5)=RGB(0,202,202)   ; cyan 
  c(6)=RGB(202,202,0)   ; yellow
  c(7)=RGB(202,202,202) ; white 
  
  ; brights
  
  c(8)=RGB(0,0,0)   ; black
  c(9)=RGB(0,0,255) ; blue
  c(10)=RGB(255,0,0); red
  c(11)=RGB(255,0,255)   ; megenta
  c(12)=RGB(0,255,0)     ; green
  c(13)=RGB(0,255,255)   ; cyan 
  c(14)=RGB(255,255,0)   ; yellow
  c(15)=RGB(255,255,255) ; white 
  
  
  StartDrawing(ImageOutput(Canvas_Blocks))
  
  Box(0,0,800,1280,#Blue)
  
  scale = scalefactor
  
  Repeat 
    For y = 0 To 7
      For x = 0 To 7
        pixel = PeekA(*scrbuff+(x+y*8)+count)
        
        x1 = (x*scale)+xadd
        y1 = (y*scale)+yadd 
        
        col.c = PeekA(*scrbuff+6143+cc)
        ;         
        ;         f.b = Int (col/128)
        ;         b.b = Int ((col-(f*128))/64)
        ;         col = Int (col-(64*b)-(128*f))
        ;         p.b = Int (col/8)
        ;         i.b = Int (col-(p*8))
        ;         
        
        ; get paper ink flash and bright from block attribute 
        
        i.b = col.c & %00000111    ; 00000111
        p.b = col.c >> 3 & %0111   ; 00111000
        f.b = col.c & %10000000    ; 10000000
        b.b = col.c >> 6 & %1      ; 01000000
        
        fg = c(i+8*b)
        bg = c(p+8*b)
        
        ;Debug bg
        
        If pixel = 1
          Box(x1,y1,scale,scale,fg)
        Else
          
          Box(x1,y1,scale,scale,bg) 
        EndIf 
        
        
        
      Next 
      cc+1
    Next 
    
    xadd + 0+ scale * 8 
    count + 1
    
    If x1> maxwidth*8; 64*8-(scale*8)
      yadd+0+scale*8
      xadd = 0 
    EndIf
    ;Debug count / 64
    ;block+1
    
  Until count=80
  
  tiles=GrabDrawingImage(#PB_Any,0,0,80,80)
  
  StopDrawing()
  
  UpdateCanvas()
  
  
EndProcedure


Procedure ImLoad()
  ;file$=OpenFileRequester("","","",0)
  If file$<>""
    blkoff=0 : offset=0 : found=0 : numtiles = 0 
    ClearList(blocks())
    LoadBKImage() : DrawGrid() : UpdateCanvas() : 
    If GetGadgetState(Option_8)=0
      GetBlocks16()
      UpdateTiles16()
    Else
      GetBlocks()
      UpdateTiles()
    EndIf
    
    
  EndIf
EndProcedure     

Procedure ImOnlyLoad()
  
;   If file$=""
     
;   EndIf
  
  If file$<>""
    ;blkoff=0 : offset=0 : found=0 : numtiles = 0 
    ;ClearList(blocks())
    LoadBKImage() : DrawGrid() : UpdateCanvas() : 
    If GetGadgetState(Option_8)=0
      GetBlocks16()
      UpdateTiles16()
    Else
      GetBlocks()
      UpdateTiles()
    EndIf
    
    
  EndIf
EndProcedure     

Procedure ImSpectrum()
  
  file$=OpenFileRequester("","","",0)
  If file$<>""
    ClearList(blocks())
    ;Global scrnam$ = LoadImage(#PB_Any, file$ )      ; load image 
    
    bkimage = CreateImage(#PB_Any,256,192)
    
    scrin = ReadFile(#PB_Any,file$)
    
    If scrin 
      
      SetWindowTitle(Window_Importer,file$)
      
      Debug "opening "+file$
      
      *scrbuff = AllocateMemory(Lof(scrin))     ; allocate memory for screen 
      
      Dim c.i(16)
      
      c(0)=RGB(0,0,0)   ; black
      c(1)=RGB(0,0,202) ; blue
      c(2)=RGB(202,0,0) ; red
      c(3)=RGB(202,0,202)   ; megenta
      c(4)=RGB(0,202,0)     ; green
      c(5)=RGB(0,202,202)   ; cyan 
      c(6)=RGB(202,202,0)   ; yellow
      c(7)=RGB(202,202,202) ; white 
      
      ; brights
      
      c(8)=RGB(0,0,0)   ; black
      c(9)=RGB(0,0,255) ; blue
      c(10)=RGB(255,0,0); red
      c(11)=RGB(255,0,255)   ; megenta
      c(12)=RGB(0,255,0)     ; green
      c(13)=RGB(0,255,255)   ; cyan 
      c(14)=RGB(255,255,0)   ; yellow
      c(15)=RGB(255,255,255) ; white 
      
      If ReadData(scrin,*scrbuff,6912)
        
        Debug "Read data"
        
        
        
        StartDrawing(ImageOutput(bkimage))
        py=0        
        For outer = 0 To 2                                    ; outer loop which third           
          For off = 0 To 255 Step 32                          ; Next 8*line            
            For sy = 0 To 2047 Step 256                       ; next char                           
              For x = 0 To 31                                 ; left to righ                 
                colb.b = PeekA(*scrbuff+6144+papery+pp)
                i.b = colb & %00000111    ; 00000111
                p.b = colb >> 3 & %0111   ; 00111000
                f.b = colb & %10000000    ; 10000000
                b.b = colb >> 6 & %1      ; 01000000               
                fg = c(i+8*b) : bg = c(p+8*b)                
                sh = 1                                         ; byte to test for                 
                offset = outer*2048                            ; offset third*2048                 
                byte = PeekA(*scrbuff+offset+x+sy+off)         ; get the next linear byte 
                For bb=7 To 0 Step -1                          ; set up shift to read bits 0 - 7                       
                  If byte & sh                                 ; get value and test against sh
                    Plot((x*8)+bb,py,fg)                       ; it was true so pixel 
                  Else 
                    Plot((x*8)+bb,py,gg)                       ; it was a zero                    
                  EndIf                  
                  sh << 1                                     ; shift our test bit left 1                  
                Next    
                sh = 0                                        ; all done reset 
                pp+1   
              Next    
              pp = 0   
              py + 1                                          ; inc leanear plot line           
              If py = 192                                     ; we hit 192 most we can go exit 
                Break 1
              EndIf         
            Next 
            papery+32 :   
            col + 1   
          Next 
        Next   
        StopDrawing()
        CloseFile(scrin)
      Else 
        Debug "Error opening "+fname$
      EndIf
      
    Else
      Debug "Error opening "+fname$
      
      
    EndIf 
    
    new=CopyImage(bkimage,#PB_Any )
    ;'ResizeImage(new,#WIDTH,#HEIGHT,#PB_Image_Raw)
    SaveImage(new,"temp.bmp",#PB_ImagePlugin_BMP)
    file$="temp.bmp"
    LoadBKImage()
    DrawGrid() : UpdateCanvas() : 
    
    ;  
    ;     StartDrawing(ImageOutput(canvasimage))
    ;     DrawImage(ImageID(j),0,0,#WIDTH,#HEIGHT)
    ;     StopDrawing()
    
    
    ; 
    ;     StartDrawing(CanvasOutput(Canvas_Import))
    ;     DrawImage(ImageID(canvasimage),0,0,#WIDTH,#HEIGHT)
    ;     StopDrawing()     
    ; DrawBlocks(2,9)
    
    
  EndIf
  
  GetBlocks()
  UpdateTiles()
EndProcedure

Procedure UpdateGUIText()
  
  
  
EndProcedure

Procedure SaveTile(tile)
  
  push=ListIndex(tiles())     ; store current tile element 
  SelectElement(tiles(),tile) ; get the one we selected from the list icon 
  
  With tiles()
    ;file$=SaveFileRequester("Save tileblock","","",0)
    in$=SaveFileRequester("Save tileblock NXT",StringField(file$,1,".")+".nxt","",0)
    
    If in$
    If ReadFile(0,in$)
      CloseFile(0)
      DeleteFile(in$,#PB_FileSystem_Force)
    EndIf
    
    If CreateFile(0,in$,#PB_File_SharedWrite)
      ; saves map at offset of x/y*w/h
      WriteAsciiCharacter(0,\t)  
      WriteAsciiCharacter(0,\s)  
      WriteAsciiCharacter(0,\x)  
      WriteAsciiCharacter(0,\y)  
      WriteAsciiCharacter(0,\w)  
      WriteAsciiCharacter(0,\h)  
      WriteAsciiCharacter(0,\s)  
      WriteAsciiCharacter(0,\s)  
      
      For y = \y To \y+\h
        For x = \x To \x+\w 
          WriteData(0,*map+x+y*32,1)
        Next 
      Next 
      WriteData(0,*blocks,numtiles*64)
      
      
      CloseFile(0)
      Debug "save test file"
    Else
      Debug "Faile to save test"
    EndIf 
  EndIf 
  
  EndWith
  
  SelectElement(tiles(),push)
  
EndProcedure

Procedure SaveTileSelection(tile)
  
  push=ListIndex(tiles())     ; store current tile element 
  SelectElement(tiles(),tile) ; get the one we selected from the list icon 
  
  With tiles()
    ;file$=SaveFileRequester("Save tile selction","","",0)
    in$=SaveFileRequester("Save tile selction",StringField(file$,1,".")+Str(tile)+".map","",0)
    If in$
    If ReadFile(0,in$)
      CloseFile(0)
      DeleteFile(in$,#PB_FileSystem_Force)
    EndIf
    
    If CreateFile(0,in$,#PB_File_SharedWrite)

      For y = \y To \y+\h
        For x = \x To \x+\w 
          WriteData(0,*map+x+y*32,1)
        Next 
      Next 
      
      CloseFile(0)
      Debug "save the selection"
    Else
      Debug "Failed to save test"
    EndIf 
    EndIf 
  EndWith
  
  SelectElement(tiles(),push)
  
EndProcedure

Procedure ClearTiles()
  
  ClearList(tiles())
  ClearGadgetItems(LI_tiles)
  UpdateCanvas()
  
EndProcedure


Procedure Window_Importer_Events(event)
  
  Static txstart, tystart, startset
  
  
  
  Select event
    Case #PB_Event_GadgetDrop
      Select EventGadget()
        Case Canvas_Import
          Debug "DROPPED" 
          file$ = EventDropFiles()
          If LCase(GetExtensionPart(file$))="nxp"
            custompalette = 1 
            ReadCustomPalette(file$)
          ElseIf LCase(GetExtensionPart(file$))="pal"
            custompalette = 2 
            ReadCustomPalette(file$)
          Else 
            ImOnlyLoad()      
          EndIf
               
        Case Btn_ImLoad
          Debug "DROPPED" 
          file$ = EventDropFiles()
          
          If LCase(GetExtensionPart(file$))="nxp"
            custompalette = 1 
            ReadCustomPalette(file$)
          ElseIf LCase(GetExtensionPart(file$))="pal"
            custompalette = 2 
            ReadCustomPalette(file$)
          Else 
            ImLoad()          
          EndIf
          
      EndSelect
    Case #PB_Event_CloseWindow
      ProcedureReturn #False
      
    Case #PB_Event_Menu
      Select EventMenu()
;         Case #MenuItem_LoadBaseImage
;           Debug "LoadBaseImage"
;           file$=OpenFileRequester("","","",0)
;           ImLoad()
;           
;         Case #MenuItem_LoadImage
;           Debug "LoadImage"
;           file$=OpenFileRequester("","","",0)
;           ImOnlyLoad()
;           
;         Case #MenuItem_SaveTileBitmap
;           Debug "SaveTileBitmap"
;           
;         Case #MenuItem_SaveSelection
;           Debug "SaveSelection"
;           Selected=GetGadgetState(LI_Tiles)
;           SaveTileSelection(Selected)
;           
;         Case #MenuItem_SaveNXT
;           Debug "SaveNXT"
;           Selected=GetGadgetState(LI_Tiles)
;           SaveTile(Selected)
; 
;         Case #MenuItem_SaveSPR
;           Debug "SaveSPR"
;           in$=SaveFileRequester("Save SPR file",StringField(file$,1,".")+".spr","",0)
; 
;           SaveData(1)
;           
      EndSelect
      
    Case #PB_Event_Gadget
      
      Type=EventType()
      
      Select EventGadget()
          
        Case Btn_ImLoad
          ; Load in a new image and process blocks 
          file$=OpenFileRequester("","","",0)
          ImLoad()
        Case Btn_SaveAll
          ; save all the data, tiles and map
          SaveData()
          
        Case Spin_MWidth
          Width=GetGadgetState(Spin_MWidth)*16*48
          ResizeGadget(Canvas_Import,0, 0, Width, 590)
          SetGadgetAttribute(Scroll_Area_1,#PB_ScrollArea_InnerWidth,Width)
          UpdateCanvas()
          StartDrawing(CanvasOutput(Canvas_Import))
          For y = 0 To 23 Step 2
            For x = 0 To Width*16 Step 2 
              Line(x*24,0,1,#HEIGHT,#Blue)
              Line(0,y*24,Width,1,#Blue)
            Next
          Next
          StopDrawing()
        Case Scroll_Area_1
          Select EventType()
            Case  #PB_EventType_Resize
              SetGadgetAttribute(Scroll_Area_1,#PB_ScrollArea_ScrollStep,32)
              Debug GetGadgetAttribute(Scroll_Area_1,#PB_ScrollArea_ScrollStep)
          EndSelect
        Case Btn_ImOnly
          file$=OpenFileRequester("","","",0)
          ImOnlyLoad()
        Case Btn_ImSpectrum
          ImSpectrum() 
        Case Canvas_Import
          
          offya = GetGadgetAttribute(Canvas_Import, #PB_Canvas_MouseY) /24
          offxa = GetGadgetAttribute(Canvas_Import, #PB_Canvas_MouseX)/24
          SetGadgetText(String_XY,"X="+Str(offxa)+" Y="+Str(offya))
          If Type=#PB_EventType_LeftButtonDown Or (GetGadgetAttribute(CanvasMapLayout, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)   
            txstart= offxa 
            tystart= offya 
            If startset=1
              UpdateCanvas()
            EndIf 
            StartDrawing(CanvasOutput(Canvas_Import))
            Line(offxa*24,offya*24,24,1,#White) 
            Line(offxa*24,offya*24,1,24,#White) 
            StopDrawing()
            startset=1
          EndIf
          If Type=#PB_EventType_RightButtonDown Or (GetGadgetAttribute(CanvasMapLayout, #PB_Canvas_Buttons) & #PB_Canvas_RightButton)   
            Debug offxa
            Debug offya
            ;               StartDrawing(CanvasOutput(Canvas_Import))
            ;               
            ;               Line(offxa*24,24+offya*24,24,1,#White) 
            ;               Line(24+offxa*24,offya*24,1,24,#White) 
            With tiles()  
              ;               StopDrawing()
              If startset=1
                AddElement(tiles())
                curr=ListIndex(tiles())
                
                \id=curr
                \x=txstart
                \y=tystart
                \w=offxa-txstart
                \h=offya-tystart
                \s=(1+\w)*(1+\h)
                \kb=\s*64
                
                text$=Str(curr)+Chr(10)+Str(txstart)+Chr(10)+Str(tystart)+Chr(10)+Str(offxa-txstart)+Chr(10)+Str(offya-tystart)+Chr(10)+Str(tiles()\s)+Chr(10)+Str(tiles()\kb)
                startset=0
                AddGadgetItem(LI_Tiles,-1,text$)
                SetGadgetState(LI_Tiles,curr)
                StartDrawing(CanvasOutput(Canvas_Import))
                DrawingMode(#PB_2DDrawing_AlphaBlend| #PB_2DDrawing_XOr)
                FrontColor(#Red)
                RGBA(150, 150, 150, 105)
                Box(\x*24,\y*24,(1+\w)*24,(1+\h)*24)
                DrawingMode(#PB_2DDrawing_Default)   
                StopDrawing()
                
              EndIf 
            EndIf
          EndWith
        Case LI_Tiles
          If Type=#PB_EventType_LeftClick 
            Selected=GetGadgetState(LI_Tiles)
            If Selected >= 0 
            push=ListIndex(tiles())
            SelectElement(tiles(),Selected)
            With tiles()
              Debug \id
              Debug \x
              Debug \y
              Debug \w
              Debug \h
              Debug (1+\w)*(1+\h)
              UpdateCanvas()             
              StartDrawing(CanvasOutput(Canvas_Import))
              DrawingMode(#PB_2DDrawing_AlphaBlend| #PB_2DDrawing_XOr)
              FrontColor(#Red)
              RGBA(150, 150, 150, 105)
              Box(\x*24,\y*24,(1+\w)*24,(1+\h)*24)
              DrawingMode(#PB_2DDrawing_Default)   
              StopDrawing()
              
              ;GetBlocks()
            EndWith
            SelectElement(tiles(),push)
            EndIf
          EndIf 
        Case Btn_SaveTile
           Selected=GetGadgetState(LI_Tiles)
           
           SaveTile(Selected)
        Case Btn_SaveSelection
          ; this saves just the highlighted selection 
          ; as a map from the selection, ie no bitmap data / header 
          Selected=GetGadgetState(LI_Tiles)
          SaveTileSelection(Selected)
          
          
        Case Btn_SelectTileData
          ; clear and reselect blocks from selection 
          Selected=GetGadgetState(LI_Tiles)
          numtiles=0
          GetBlocks(1)
          UpdateTiles()
          ; 12= header and 4x$00 end marker 
          ; + number of blocks * 64 
          ;With tiles()
          ;  *header=AllocateMemory(12+\s+\kb)
        Case Btn_SaveTileData
          ; this should save the tilemap and data
          Selected=GetGadgetState(LI_Tiles)
          SaveTile(Selected)
          
          ; EndWith
        Case Btn_Clear
          ClearTiles()
        Case Btn_9bit
          RemapImageTo9bit()
           UpdateCanvas()
          
      EndSelect
  EndSelect
  ProcedureReturn #True
EndProcedure

Procedure SetUp()
  StartDrawing(CanvasOutput(Canvas_Import))
  Box(0,0,800,1280,#Black)
  StopDrawing()
  ReadCustomPalette("256cols-emk.pal")
  SetGadgetState(Spin_MWidth,1)
  ;SetGadgetState(#PB_ScrollArea_ScrollStep  ,16)
  EnableGadgetDrop(Canvas_Import, #PB_Drop_Files, #PB_Drag_Copy)
  EnableGadgetDrop(Btn_ImLoad, #PB_Drop_Files, #PB_Drag_Copy)
EndProcedure

OpenWindow_Importer()
SetUp() 
LoadBKImage()
DrawGrid()
SetGadgetAttribute(Canvas_Import, #PB_Canvas_Cursor, #PB_Cursor_Cross)
UpdateCanvas()
GetBlocks16()
UpdateTiles16()

Repeat 
  
  event = WaitWindowEvent()
  result=Window_Importer_Events(event)
  
Until result = #False


; IDE Options = PureBasic 5.71 LTS (Windows - x86)
; CursorPosition = 247
; FirstLine = 126
; Folding = KAAA9
; Markers = 112,1212,1371
; EnableXP
; Executable = ..\..\..\BorielsZXBasic4Next0.3b\Sources\chicken\importer.exe
; CurrentDirectory = C:\NextBuildv7\Tools\importer2021
; EnablePurifier