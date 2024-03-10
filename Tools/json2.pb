EnableExplicit

Define raw_json.s = ~"{\"layers\":[{\"data\":[2,20,200],\"id\":1, \"height\":100},{\"id\":2,\"height\":500,\"objects\":[{\"x\":2,\"y\":4,\"name\":\"a\"},{\"x\":6,\"y\":8,\"name\":\"b\"},{\"x\":10,\"y\":12,\"name\":\"c\"},{\"x\":14,\"y\":16,\"name\":\"d\"}]}]}"
Define json_obj=ParseJSON(#PB_Any,raw_json.s)
If json_obj
  ;SetClipboardText(ComposeJSON(json_obj))
  Define layer_obj=GetJSONMember(JSONValue(json_obj),"layers")
  If layer_obj
    ;read first "layers" array element
    Define layer_first_entry=GetJSONElement(layer_obj,0)
    If layer_first_entry
      Debug "id: "+GetJSONInteger(GetJSONMember(layer_first_entry,"id"))
      Debug "height: "+GetJSONInteger(GetJSONMember(layer_first_entry,"height"))
      Define layer_first_entry_data=GetJSONMember(layer_first_entry,"data")
      
      Dim ddata(JSONArraySize(layer_first_entry_data)-1)
      ExtractJSONArray(layer_first_entry_data, ddata())
      Define i
      For i = 0 To ArraySize(ddata())
        Debug "data["+i+"]: "+ddata(i)
      Next i
    EndIf
    
    Debug "----"
    
    ;read second "layers" array element
    Define layer_second_entry=GetJSONElement(layer_obj,1)
    If layer_second_entry
      Debug "id: "+GetJSONInteger(GetJSONMember(layer_second_entry,"id"))
      Debug "height: "+GetJSONInteger(GetJSONMember(layer_second_entry,"height"))
      Define layer_second_entry_objects=GetJSONMember(layer_second_entry,"objects")
      
      Structure my_object
        x.i
        y.i
        name.s
      EndStructure
      
      NewList Objects.my_object()
      ExtractJSONList(layer_second_entry_objects, Objects())
      
      ForEach Objects()
        Debug "objects["+ListIndex(Objects())+"]: x="+Str(Objects()\x) + ", y=" + Str(Objects()\y)+", name="+Objects()\name
      Next
      
    EndIf
    
    
    ;Define layer_third_entry=GetJSONElement(layer_obj,2)
    ; ...
  EndIf
EndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 51
; FirstLine = 1
; EnableXP