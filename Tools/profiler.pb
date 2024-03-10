Structure details
  startaddress.s
  endaddress.s 
  size.i
  name.s
EndStructure

NewList subs.details()

file$ = "memory.txt"

If ReadFile(0,file$)
  
  While Not Eof(0)
    
    line$ = ReadString(0)
    If FindString(LCase(line$),"__leave",0)
      AddElement(subs())
      subs()\name=StringField(line$,2,"_")
      subs()\endaddress="$"+StringField(line$,1,":")
    EndIf
 
  Wend 
  
  If ListSize(subs())    
    ForEach subs()
      ; this bit we want to go through each list item we found and look for the start
      ; buff$ holds a copy of out input file
      FileSeek(0,0)       ; rewind to start of file 
      While Not Eof(0)    
        line$ = ReadString(0)
        If FindString(LCase(line$),LCase(subs()\name),0)
          If Right(LCase(line$),Len(subs()\name))=LCase(subs()\name)
            Debug "2 found "+line$
            subs()\startaddress="$"+StringField(line$,1,":")
            size = Val(subs()\endaddress)-Val(subs()\startaddress)
            Debug size 
            subs()\size=size 
            Break     ; break from the while 
          EndIf 
        EndIf    
      Wend 
    Next
  EndIf
  
  CloseFile(0)
  
Else
  Debug "Error opening file"
EndIf

; now print the output 

SortStructuredList(subs(), #PB_Sort_Descending, OffsetOf(details\size), TypeOf(details\size))


outline$ = LSet("Sub",30," ")+ #TAB$+ #TAB$+LSet("size bytes",10," ") + #CRLF$
outline$ + LSet("=",63,"=") + #CRLF$
ForEach subs()
  outline$ + LSet(subs()\name,30," ")
  outline$ + #TAB$+ #TAB$
  outline$ + LSet(Str(subs()\size),10," ")
  outline$ + #TAB$+ #TAB$
  outline$ + subs()\startaddress+"-"+subs()\endaddress 
  outline$ + #CRLF$
  total + subs()\size
Next 
outline$ + #CRLF$
outline$ + "Total size : " + Str(total)

If CreateFile(0,"profile_memory.txt")
  WriteString(0,outline$)
  CloseFile(0)  
EndIf

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 74
; FirstLine = 26
; Executable = memprofiler.exe