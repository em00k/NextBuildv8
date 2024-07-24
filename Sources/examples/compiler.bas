'!ORG=24576
'#!copy=h:\l2320.nex
'!asm 

#include <nextlib.bas>
dim tesvar as ubyte 

testvar = 10
c=10
b=20
asm 
 BREAK 
 ld e,[._c]
 ld d,[._b]
end asm 

print testvar,c,b

do 

loop 