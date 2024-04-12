#include <nextlib.bas>

dim add as uinteger

do 
    WaitRetrace2(194)
    print at 2,0;"Sample  :                 " 
    border 2
    GetNextSample()
    border 0 
    add = peek(uinteger,@pattern_position)
    print at 0,0;"Pattern : ";peek(add);"   "
    add = peek(uinteger,@pattern_position_index)
    print at 1,0;"Position: ";peek(add);"   " 
    add = peek(uinteger,@sample_to_play)
    print at 2,0;"Sample  : ";peek(add);"   " 
    
loop 

sub fastcall GetNextSample()

    asm 
 
        ld      hl,pattern_timing+1

    pattern_timing:
        ld      a,0 
        inc     a 
        ld      (hl),a 
        cp      5 
        ret     nz 
        xor     a 
        ld      (hl),a 

        ld      de,increase_pattern_pos+1   ; for speed 
        ld      bc,get_pattern_order+1

    get_pattern_order:
        ld      a, 0 
        ld      hl, pattern_order           ; point to pattern_order data 
        add     a,a                         ; *2 for size
        add     hl,a                        ; add to hl 

        ; hl now points pattern address of pattern 

        ld      a,(hl)                      ; swap (hl) to hl 
        inc     hl 
        ld      h,(hl)
        ld      l,a                         ; hl now start of pattern data 
 
        ld      a,h                         ; end of playlist? hl = $ffff 
        or      l 
        cp      $ff 
        jr      nz, dont_reset_pattern_order_index 
        
        xor     a                           ; reset the index 
        ld      (de),a                      ; reset increase_pattern_pos
        ld      (bc),a                      ; and pattern order 
        jr      get_pattern_order           ; read again 

    dont_reset_pattern_order_index:
        ld      a,(de)                      ; get increase_pattern_pos
        add     hl,a                        ; add to pattern offset 
        ld      a,(hl)                      ; get the sample 
        cp      $ff                         ; end of pattern? 
        jr      nz,process_sample 
         
        xor     a 
        ld      (de),a                      ; reset pattern position
        ld      a,(bc)
        inc     a
        ld      (bc),a 
        jr      get_pattern_order
    
    process_sample:
        ;or      a                           ; if a / sample not 0  
        call    nz,play_sample              ; call play_sample

    increase_pattern_pos:
        ld      a,0                         ; smc 
        inc     a                           
        res     6,a                         ; reset bit 6 64 
        ld      (de),a                      ; increase pattern position with smc 
        ret 

    play_sample:
        ld      (sample+1),a 
    sample:
        ld      a,0
        ret 
    end asm 


end sub 

pattern_position:
asm 
        dw get_pattern_order+1
end asm 

pattern_position_index:
asm 
        dw increase_pattern_pos+1 
end asm 

sample_to_play:
asm 
        dw sample+1
end asm 

pattern:
asm 

	pat1: 
        db 1,0,3,3, 1,0,3,3, 1,0,3,3, 1,0,3,3,$ff 

    pat2:
        db 1,0,0,0, 1,0,0,0, 1,0,0,0, 2,0,0,0,$ff 

    pat3:
        db 1,3,3,3, 2,3,3,3, 1,3,3,3, 2,3,2,3,$ff 

    pat4:
        db 1,0,3,3, 2,0,3,3, 1,0,3,1, 2,2,2,3, $ff 

end asm 

pattern_order:
asm 
pattern_order:
	dw pat1         ; 9 0
    ; dw $ffff 
	dw pat3         ; 10 1
	dw pat3         ; 11 2
	dw pat3         ; 12 3
	dw pat3         ; 13 4
	dw pat3         ; 14 5
	dw pat3         ; 15 6
	dw pat2         ; 16 7
	dw pat3         ; 17 8
	dw pat4         ; 0 9 
	dw pat3         ; 1 10 
	dw pat3         ; 2 11
	dw pat3         ; 3 12 
	dw pat4         ; 2 13 
	dw pat3         ; 4 14 
	dw pat3         ; 5 15 
	dw pat3         ; 6 16 
	dw pat3         ; 7 17 
	dw pat4         ; 8 18 

	dw $ffff        ; end of pattern marker

end asm 

asm

        ld      hl,$4000 
    testloop:
        ; BREAK 

        call    checkpos
        call    raster_line

        jp testloop

end asm

testcode:
asm
    raster_line:	
    ;    ei 
        push	af 
        push    de 
        push    hl  
        push    ix   
        push    bc 

        ld      a,(chunkloadflag)               ; get the load flag 
        or      a                               ; was it zero 
        jr      z,skipload2                     ; yes skip 
        ;
         
        ld      a,(chunkloadflag)               ; get the load flag  
        cp      1                               ; is flag set to 1 
        call    z, read_data_b                  ; then load data b ($5000)
        ;
        ld      a,(chunkloadflag) 
        cp      2 
        call    z, read_data_a                  ; load data a 
        ;
        xor     a 
        ld      (chunkloadflag), a 
    skipload2:

        raster_frame equ $+1	
        ld      a,0 
        inc	    a
        ld	    (raster_frame),a

        pop     bc 
        pop     ix 
        pop     hl  
        pop     de 
        pop	    af

        ret

    checkpos:
        ld      de,(sample_offset)
        ld      a,e                             ; put e into a 
        or      a                               ; was it zero 
        jr      nz,skipload                     ; no skip loading 

        ld      a,d                             ; get d 
        cp      $41                             ; compare to $50
        jr      nz, skiploada                   ; <>50 then skip 
        ld      a,1                             ; else set load flag to 1 
        ld      (chunkloadflag),a 
        
skiploada:        

        ld      a,d                             ; get d 
        cp      $40                             ; compare to $40
        jr      nz, skipload                    ; <> $40  skip 
        ld      a,2                             ; else set load flag to 2 
        ld      (chunkloadflag),a 

skipload:

        ld      de,(sample_offset)
        ld      a,(de)                          ; grab sample 
        nextreg DAC_C_MIRROR_NR_2E, a           ; send to left channel 
        inc     de      

        ld      a,(de)                          ; grab sample 
        nextreg DAC_B_MIRROR_NR_2C, a           ; send to right channel 
        inc     de      
        ; BREAK
        ld      a,d                             ; get d into a 
        cp      $42                             ; cp $60 max is $6000
        jr      nz,final                        ; if not $60 then jump to final 
        ld      de,$4000                        ; else reset de to $4000
final: 
        ld      hl,sample_offset
        ld      (hl),e
        inc     hl 
        ld      (hl),d
        ret 

    chunkloadflag:
        db      0 

    sample_offset:
        dw      $4000 

end asm

asm 
    read_data_a:
        
        ld      a, 1
        out     ($fe),a
        ret 

    read_data_b:
            
        ld      a, 2
        out     ($fe),a
        ret 

asm 
        di 
    ctc0:
     ; BREAK 
        push 	af 
        push    bc 
        push    hl 
        push    de 
        ; ld 		a,(raster_frame) 
        ; and 	7
        ; out 	($fe),a 
        ; BREAK 
        ; nextreg $50,32              ; page in sample 
        ld      hl,(sample_length)
        ld      de,(sample_offset)    ; point to sample position 
        ;xor     a 
        ;sbc     hl,de 
        ;jr      c,done_playing
        ld      a,$40 
        or      d 
        ld      d,a 
        ld      a,(de)              ; grab sample 
    done_playing:
        pop     de 
        pop     hl 
        pop     bc 
        pop 	af 
        jp      ctc0

    sample_length:
        dw      0 


end asm 
