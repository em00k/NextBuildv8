#include once <stackf.asm>
#include once <zxnext_utils.asm>
    push namespace core

BEEP:	; The beep command, as in BASIC
    ; Duration in C,ED,LH (float)
    ; Pitch in top of the stack
    call        __zxnbackup_sysvar_bank
    CALL __FPSTACK_PUSH

    pop hl    ; RET address
    pop af
    pop de
    pop bc    ; Recovers PITCH from the stack
    push hl    ; CALLEE, now ret addr in top of the stack

    CALL __FPSTACK_PUSH  ; Pitch onto the FP stack

    push ix   ; BEEP routine modifies IX. We have to preserve it
    call 03F8h
    pop ix
    call        __zxnbackup_sysvar_bank
    ret

    pop namespace






