

asm  
    ld iy,$5c3a	
end asm 

#include <input.bas>

print at 10, 5; "Type something: ";
a$ = input(20)
print
print "You typed: "; a$

