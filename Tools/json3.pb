Structure ObjectsStructure
  id.i
  x.i
  y.i
  height.i
  width.i
  visible.i
  name.s
  rotation.i
EndStructure

Structure LayersStructure
  id.i
  name.s
  List Data.i()
  List objects.ObjectsStructure()
EndStructure

Structure ExportStructure
  target.s
EndStructure


Structure EditorsettingsStructure
  export.ExportStructure
EndStructure


Structure TestStructure
  compressionlevel.i
  editorsettings.EditorsettingsStructure
  height.i
  infinite.i
  List layers.LayersStructure()
EndStructure


File = ReadFile(#PB_Any, "Test02.json")
If File
  Debug "File open"
  Format = ReadStringFormat(File)
  JSON$ = ReadString(File, Format|#PB_File_IgnoreEOL)
  Debug JSON$
  JSON = ParseJSON(#PB_Any, JSON$, #PB_JSON_NoCase)
  If JSON
    
    ExtractJSONStructure(JSONValue(JSON), @Test.TestStructure, TestStructure)
    Debug Test\compressionlevel
    Debug Test\editorsettings\export\target
    Debug Test\height
    
    Debug ""
    
    ForEach Test\layers()
      Debug "Layer: " + Str(Test\layers()\id) + " " + Test\layers()\name
      ForEach Test\layers()\Data()
        Debug "Data: " + Str(Test\layers()\Data())
      Next 
      ForEach Test\layers()\objects()
        Debug "Object:" + Str(Test\layers()\objects()\id) + " " + Test\layers()\objects()\name + " " + Str(Test\layers()\objects()\x) + "/" + Str(Test\layers()\objects()\y) + " " + Str(Test\layers()\objects()\width) + "/" + Str(Test\layers()\objects()\height)
      Next
      Debug ""
    Next
    
    FreeJSON(JSON)
  EndIf
  CloseFile(File)
EndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 67
; FirstLine = 18
; EnableXP