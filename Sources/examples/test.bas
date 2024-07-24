
#include <nextlib.bas>
dim tesvar as ubyte 

BBREAK 

asm 
    org $e000
end asm 
mytable:
ASM 
  mytable:
    defb 5,6,7,8
END ASM

