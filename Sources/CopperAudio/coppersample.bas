'!org=24576
' NextBuild Layer2 Template 

#define NEX 
#define IM2 

#include <nextlib.bas>

asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency,sprites on over border,320x256
    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg SPRITE_CONTROL_NR_15,%00000011  ; %000    S L U, %11 sprites on over border
    nextreg LAYER2_CONTROL_NR_70,%00000000  ; 5-4 %01 = 320x256x8bpp
end asm 


asm 

TBBLUE_REGISTER_SELECT		equ	$243B	; TBBlue register select

PERIPHERAL_1_REGISTER		equ	$05	; Peripheral 1 setting
TURBO_CONTROL_REGISTER		equ	$07	; Turbo control
DISPLAY_TIMING_REGISTER		equ	$11	; Video timing mode (0..7)
RASTER_LINE_MSB_REGISTER		equ	$1E	; Current line drawn MSB
RASTER_LINE_LSB_REGISTER		equ	$1F	; Current line drawn LSB
SOUNDDRIVE_MIRROR_REGISTER		equ	$2D	; SpecDrum 8 bit DAC (mirror)
COPPER_DATA		equ	$60	; Copper list
COPPER_CONTROL_LO_BYTE_REGISTER	equ	$61
COPPER_CONTROL_HI_BYTE_REGISTER	equ	$62


; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------


; Example use:


    call	init_copper_audio

    ld	hl,32768			; Address of sample/buffer
    ld	de,1024				; 1K buffer
    ld	a,0					; Loop forever
    call	play_sample		; Trigger


.GameLoop	call	set_copper_audio

    call	wait_line	; Wait for line A

    ld	a,1		; BLUE border
    out	(254),a	

    call	play_copper_audio

    xor	a,a		; BLACK border
    out	(254),a

    NEXTREG	,00000010b	; 14mhz **FORCED**

    jr	GameLoop


; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------


; **CALL ONCE DURING STARTUP**


; Initialize copper audio by reading display mode.


init_copper_audio:	ld	bc,TBBLUE_REGISTER_SELECT
    ld	a,DISPLAY_TIMING_REGISTER
    out	(c),a
    inc	b
    in	a,(c)			; Display timing
    and	a,7			; 0..6 VGA / 7 HDMI
    ld	(video_timing),a	; Store timing mode
    ret


; --------------------------------------------------------------------------


; **MUST CALL DIRECTLY BEFORE PLAY_COPPER_AUDIO AND AFTER SET_COPPER_AUIDO**


; Read raster line register and wait for line A.


; > A = Line to wait for (0..255)


wait_line:	ld	bc,TBBLUE_REGISTER_SELECT
    ld	de,(RASTER_LINE_MSB_REGISTER*256)+RASTER_LINE_LSB_REGISTER

    out	(c),d		; MSB
    inc	b

.msb	in	d,(c)
    bit	0,d		; 256..312/311/262/261 ?
    jp	nz,.msb

    dec	b
    out	(c),e		; LSB
    inc	b

.lsb	in	e,(c)
    cp	a,e		; 0..255 ?
    jp	nz,.lsb

    ret


; --------------------------------------------------------------------------


; **OPTIONAL**


; > HL = Sample address (0..65535)

; < HL = As entry


set_sample_pointer	ld	(sample_ptr),hl
    ret


; --------------------------------------------------------------------------


; **OPTIONAL**


; > HL = Sample length in bytes

; < HL = As entry


set_sample_length	ld	(sample_len),hl
    ret


; --------------------------------------------------------------------------


; **OPTIONAL**


; > HL = Sample position (should be 0 to sample length)

; < HL = As entry


set_sample_position	ld	(sample_pos),hl
    ret


; --------------------------------------------------------------------------


; **OPTIONAL**


; < HL = Sample position (should be 0 to sample length)


get_sample_position	ld	hl,(sample_pos)
    ret


; --------------------------------------------------------------------------


; **OPTIONAL**


; Set sample loop count, 0 = forever / 1 = one shot / 2..255 repeats).


; > A = Loop count (0 = forever)


set_sample_loop	ld	(sample_loop),a
    ret


; --------------------------------------------------------------------------


; Call this to play sample / set looping buffer.


; > HL = Pointer to sample
; > DE = Sample length in bytes
; >  A = Loop count (0 forever).


play_sample	ld	(sample_ptr),hl	; Address of sample
    ld	(sample_len),de	; Length of sample

    ld	(sample_loop),a	; Loop mode (0 forever)

    ld	hl,0
    ld	(sample_pos),hl


; Call this to hear the sound again once muted.


set_sample_sound_on	ld	a,PAL8
    ld	a,SOUNDDRIVE_MIRROR_REGISTER
    ld	(sample_dac),a	; Sound on
    ret


; --------------------------------------------------------------------------


; Call this to mute the sound (same as stop_sample, buffer loop continues).


set_sample_sound_off


; Call this to stop sample play (copper is still active outputting NOPs).


stop_sample	xor	a,a
    ld	(sample_dac),a	; Sound off
    ret


; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------


; **MUST CALL BEFORE PLAY_COPPER_AUDIO EACH FRAME**


; Set audio copper variables and state.


; < A = Line to wait for (0..255)


set_copper_audio	di
    ld	(.stack+1),sp

    ld	ix,copper_loop	; Auto detect timing

    ld	bc,TBBLUE_REGISTER_SELECT
    ld	a,CONFIG1
    out	(c),a
    inc	b
    in	a,(c)		; Peripheral 1 register

    ld	hl,hdmi_50_config
    ld	de,vga_50_config
    bit	2,a
    jr	z,.refresh	; Refresh 50/60hz ?
    ld	hl,hdmi_60_config
    ld	de,vga_60_config
.refresh
    ld	a,(video_timing)
    cp	a,7		; HDMI ?
    jr	z,.hdmi
    ex	de,hl		; Swap to VGA
.hdmi
    ld	a,(hl)		; Copper line
    inc	hl
    ld	(.return+1),a	; Store ruturn value

    ld	sp,hl

;	------------
;	------------
;	------------

    ld	hl,(sample_len)	; Calc buffer loop offset
    ld	bc,(sample_pos)
    xor	a,a		; Clear CF
    sbc	hl,bc

    ld	b,h
    ld	c,l		; BC = loop offset (0..311)

    pop	hl		;  Samples per frame (312)
    ld	(video_lines),hl

    ld	a,h		; 16 bit negate
    cpl
    ld	h,a
    ld	a,l
    cpl
    ld	l,a
    inc	hl		; Samples per frame (-312)

    ld	a,20		; No loop (Out of range)

    add	hl,bc
    jp	c,.no_loop

;	----D---- ----E----
;	0000 0008 7654 3210
;	0000 0000 0008 7654	

    ld	a,c		; Loop offset / 16
    and	a,11110000b
    or	a,b
    swap	a
.no_loop	ld	b,a		; B = 0..19 (20 no loop)

    ld	a,c
    and	a,00001111b
    ld	c,a

;	------------

    ld	hl,.zone+1	; Build control table
    pop	de
    ld	(hl),e		; Split
    ld	a,d		; Count

    pop	hl		; 0..15 samples routine

    ld	(copper_audio_config+1),sp ; **PATCH**

    ld	sp,copper_audio_stack
    
    cp	a,b
    jr	nz,.skip	; Loop 0..15 samples ?

    ex	af,af

    ld	e,c		; 0..7
    ld	d,9
    mul	d,e		; 0..144
    ld	a,144		; 144..0
    sub	a,e

    add	hl,de
    push	hl
    push	ix		; Output loop
    ld	de,copper_out16
    add	de,a
    push	de

    ex	af,af

    jr	.next

;	------------

.skip	push	hl		; Output normal

;	------------

.next	ld	hl,copper_out16	; 16 samples routine
    dec	a

.zone	cp	a,7
    jp	nz,.no_split

    ld	de,copper_split
    push	de		; Output Split
.no_split
    cp	a,b
    jp	nz,.no_zone	; Loop 16 samples ?

    ex	af,af

    ld	e,c		; 0..15
    ld	d,9
    mul	d,e		; 0..144
    ld	a,144		; 144..0
    sub	a,e

    add	de,copper_out16
    push	de
    push	ix		; Output loop
    ld	de,copper_out16
    add	de,a
    push	de

    ex	af,af

    jr	.zone_next

.no_zone	push	hl		; Output normal

.zone_next	dec	a
    jp	p,.zone

    ld	(copper_audio_control+1),sp ; **PATCH**

.return	ld	a,0		; Copper line to wait for

.stack	ld	sp,0
    ei
    ret


; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------


; **MUST CALL EACH FRAME AFTER WAITING FOR LINE A FROM SET_COPPER_AUDIO**


; Build copper list to output one frame of sample data to DAC.


play_copper_audio	di
    ld	(play_copper_stack+1),sp

copper_audio_config	ld	sp,0		; **PATCH**

    pop	hl		; Index + VBLANK
    pop	de		; Line 180 + command WAIT

    ld	a,l
    NEXTREG	COPLO,a
    ld	a,h
    NEXTREG	COPHI,a

    ld	hl,(sample_ptr)	; Calc playback position
    ld	bc,(sample_pos)
    add	hl,bc

    ld	bc,SELECT	; Port
    ld	a,COPPER_DATA
    out	(c),a
    inc	b

    ld	a,(sample_dac)	; Register to set (DAC)

copper_audio_control	ld	sp,0		; **PATCH**
    ret			; GO!!!

;	------------

copper_out16	out	(c),d		;   0 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out15	out	(c),d		;   9 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out14	out	(c),d		;  18 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out13	out	(c),d		;  27 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out12	out	(c),d		;  36 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out11	out	(c),d		;  45 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out10	out	(c),d		;  54 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out9	out	(c),d		;  63 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out8	out	(c),d		;  72 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out7	out	(c),d		;  81 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out6	out	(c),d		;  90 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out5	out	(c),d		;  99 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out4	out	(c),d		; 108 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out3	out	(c),d		; 117 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out2	out	(c),d		; 126 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out1	out	(c),d		; 135 BYTES
    out	(c),e
    out	(c),a
    OUTINB
    inc	de
copper_out0	ret			; 144 BYTES

;	------------

copper_split	out	(c),d		; Terminate
    out	(c),e
    ld	de,32768+0	; Line 0 + command WAIT
    NEXTREG	COPPER_CONTROL_LO_BYTE_REGISTER,$00 ; Index
    NEXTREG	COPPER_CONTROL_HI_BYTE_REGISTER,$C0 ; Vblank
    ret			; GO!!!

;	------------

;;;copper_debug	dec	b
;;;	ld	a,RASLSB
;;;	out	(c),a
;;;	inc	b
;;;	in	a,(c)
;;;	jp	nx232

;	------------

copper_loop	ld	hl,sample_dac
    ld	a,(sample_loop)
    and	a,a
    jr	z,.forever
    dec	a
    jr	nz,.loop	
    ld	(hl),0		; Copper NOP (mute sound)

.loop	ld	(sample_loop),a

.forever	ld	a,(hl)		; Read DAC mute state
    ld	hl,(sample_ptr)
    ret			; GO!!!

;	------------

copper_done	ld	de,(sample_ptr)
    xor	a,a
    sbc	hl,de
    ld	(sample_pos),hl	; Update playback position

play_copper_stack	ld	sp,0
    ei
    ret


; --------------------------------------------------------------------------


; The copper list is made up of 2 instructions for each DAC write, a wait for
; a specific line and a move to the DAC register (4 BYTES in total). The list
; flows in order of the scanlines so index 0 waits for line 0 until all lines
; for that video mode are written to. Waiting for lines out of range is a
; convienent way to halt the copper so we add an extra line wait at the end
; of the code but there is no DAC write.

; The copper is in VBLANK reset mode so this means we are updating the copper
; list live. To avoid over-taking the copper, the list update has been split
; into two zones. We start on line 163. The copper has just wrote sample data
; to the DAC for line 163. We will fill the copper in advance for lines
; 183..310. The CPU can write around 10 sample instructions per line so we
; can easily race the copper to fill ahead avoiding it over-taking us. Line
; 183 will be filled well ahead of the copper writing on that line so we are
; safe from pops/clicks. Our point of no return is a delay of about 20 lines
; as we will hear pops/clicks if we attempt to fill lines 183..310 beyond
; line 183.
;
; Now that we have filled lines 183..310, we are now on line 174, 10 lines in
; front of the copper as the initial data that we filled is not needed until
; line 183 and was prepared starting on line 163. Now it's time to fill the
; remaining lines, 0..182. We will start filling data for these lines on line
; 174 and finish on line 191 in time for the VBLANK period. We will avoid
; over-take the cooper as we are filling behind it for lines 0..182 unless we
; are delayed by many lines.

; Our sample data is read in normal linear order but we fill the copper list
; out of order as zone 1 is lines 183..310 and zone two is lines 0..182 !!!

; The above method works for each of the four video configs where the line
; numbers and sample count may change slightly.


; BIS version starts 16 lines earlier ending 16 lines before vblank.



; **VGA**	311 LINES @ 50hz


; COPPER   DISPLAY

; 163 -->   183...?	START HERE TO FILL 128 SAMPLES **INTERRUPT 163**
; 164 -->   ?.....?
; 165 -->   ?.....?
; 166 -->   ?.....?
; 167 -->   ?.....?
; 168 -->   ?.....?
; 169 -->   ?.....?
; 170 -->   ?.....?
; 171 -->   ?.....?
; 172 -->   ?.....?
; 173 -->   ?.....?
; 174 -->   ?...310	ZONE 1 COMPLETE! SAMPLE DATA LINES 183..310 READY

; 174 -->   0.....?	START HERE TO FILL 183 SAMPLES
; 175 -->   ?.....?
; 176 -->   ?.....?
; 177 -->   ?.....?
; 178 -->   ?.....?
; 179 -->   ?.....?
; 180 -->   ?.....?
; 181 -->   ?.....?
; 182 -->   ?.....?
; 183 -->   ?.....?	ZONE 1 DELAY POINT OF NO RETURN (DO NOT EXCEED)
; 184 -->   ?.....?
; 185 -->   ?.....?
; 186 -->   ?.....?
; 187 -->   ?.....?
; 188 -->   ?.....?
; 189 -->   ?.....?
; 190 -->   ?.....?
; 191 -->   ?...182	ZONE 2 COMPLETE! SAMPLE DATA LINES 0..182 READY!


; **BIS VERSION**


; COPPER   DISPLAY

; 149 -->   167...?	START HERE TO FILL 144 SAMPLES **INTERRUPT 149**
; 150 -->   ?.....?
; 151 -->   ?.....?
; 152 -->   ?.....?
; 153 -->   ?.....?
; 154 -->   ?.....?
; 155 -->   ?.....?
; 156 -->   ?.....?
; 157 -->   ?.....?
; 158 -->   ?.....?
; 159 -->   ?.....?
; 160 -->   ?...310	ZONE 1 COMPLETE! SAMPLE DATA LINES 167..310 READY

; 160 -->   0.....?	START HERE TO FILL 167 SAMPLES
; 161 -->   ?.....?
; 162 -->   ?.....?
; 163 -->   ?.....?
; 164 -->   ?.....?
; 165 -->   ?.....?
; 166 -->   ?.....?
; 167 -->   ?.....?	ZONE 1 DELAY POINT OF NO RETURN (DO NOT EXCEED)
; 168 -->   ?.....?
; 169 -->   ?.....?
; 170 -->   ?.....?
; 171 -->   ?.....?
; 172 -->   ?.....?
; 173 -->   ?.....?
; 174 -->   ?.....?
; 175 -->   ?...166	ZONE 2 COMPLETE! SAMPLE DATA LINES 0..166 READY!


; --------------------------------------------------------------------------


; **VGA**	261 LINES @ 60hz


; COPPER   DISPLAY

; 167 -->   181...?	START HERE TO FILL 80 SAMPLES **INTERRUPT 167**
; 168 -->   ?.....?
; 169 -->   ?.....?
; 170 -->   ?.....?
; 171 -->   ?.....?
; 172 -->   ?.....?
; 173 -->   ?.....?
; 174 -->   ?...260	ZONE 1 COMPLETE! SAMPLE DATA LINES 181..260 READY

; 174 -->   0.....?	START HERE TO FILL 181 SAMPLES
; 175 -->   ?.....?
; 176 -->   ?.....?
; 177 -->   ?.....?
; 178 -->   ?.....?
; 179 -->   ?.....?
; 180 -->   ?.....?
; 181 -->   ?.....?	ZONE 1 DELAY POINT OF NO RETURN (DO NOT EXCEED)
; 182 -->   ?.....?
; 183 -->   ?.....?
; 184 -->   ?.....?
; 185 -->   ?.....?
; 186 -->   ?.....?
; 187 -->   ?.....?
; 188 -->   ?.....?
; 189 -->   ?.....?
; 190 -->   ?.....?
; 191 -->   ?...180	ZONE 2 COMPLETE! SAMPLE DATA LINES 0..180 READY!


; **BIS VERSION**


; COPPER   DISPLAY

; 151 -->   165...?	START HERE TO FILL 96 SAMPLES **INTERRUPT 151**
; 152 -->   ?.....?
; 153 -->   ?.....?
; 154 -->   ?.....?
; 155 -->   ?.....?
; 156 -->   ?.....?
; 157 -->   ?.....?
; 158 -->   ?.....?
; 159 -->   ?...260	ZONE 1 COMPLETE! SAMPLE DATA LINES 165..260 READY

; 159 -->   0.....?	START HERE TO FILL 165 SAMPLES
; 160 -->   ?.....?
; 161 -->   ?.....?
; 162 -->   ?.....?
; 163 -->   ?.....?
; 164 -->   ?.....?
; 165 -->   ?.....?	ZONE 1 DELAY POINT OF NO RETURN (DO NOT EXCEED)
; 166 -->   ?.....?
; 167 -->   ?.....?
; 168 -->   ?.....?
; 169 -->   ?.....?
; 170 -->   ?.....?
; 171 -->   ?.....?
; 172 -->   ?.....?
; 173 -->   ?.....?
; 174 -->   ?.....?
; 175 -->   ?...164	ZONE 2 COMPLETE! SAMPLE DATA LINES 0..164 READY!


; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------


; **HDMI**	312 LINES @ 50hz


; COPPER   DISPLAY

; 160 -->   184...?	START HERE TO FILL 128 SAMPLES **INTERRUPT 160**
; 161 -->   ?.....?
; 162 -->   ?.....?
; 163 -->   ?.....?
; 164 -->   ?.....?
; 165 -->   ?.....?
; 166 -->   ?.....?
; 167 -->   ?.....?
; 168 -->   ?.....?
; 169 -->   ?.....?
; 170 -->   ?.....?
; 171 -->   ?.....?
; 172 -->   ?...311	ZONE 1 COMPLETE! SAMPLE DATA LINES 184..311 READY

; 172 -->   0.....?	184 SAMPLES
; 173 -->   ?.....?
; 175 -->   ?.....?
; 176 -->   ?.....?
; 177 -->   ?.....?
; 178 -->   ?.....?
; 179 -->   ?.....?
; 180 -->   ?.....?
; 181 -->   ?.....?
; 182 -->   ?.....?
; 183 -->   ?.....?
; 184 -->   ?.....?	ZONE 1 DELAY POINT OF NO RETURN (DO NOT EXCEED)
; 185 -->   ?.....?
; 186 -->   ?.....?
; 187 -->   ?.....?
; 188 -->   ?.....?
; 189 -->   ?.....?
; 190 -->   ?.....?
; 191 -->   ?...183	ZONE 2 COMPLETE! SAMPLE DATA LINES 0..183 READY!


; **BIS VERSION**


; COPPER   DISPLAY

; 144 -->   168...?	START HERE TO FILL 144 SAMPLES **INTERRUPT 144**
; 145 -->   ?.....?
; 146 -->   ?.....?
; 147 -->   ?.....?
; 148 -->   ?.....?
; 149 -->   ?.....?
; 150 -->   ?.....?
; 151 -->   ?.....?
; 152 -->   ?.....?
; 153 -->   ?.....?
; 154 -->   ?.....?
; 155 -->   ?.....?
; 156 -->   ?.....?
; 157 -->   ?.....?
; 158 -->   ?...311	ZONE 1 COMPLETE! SAMPLE DATA LINES 168..311 READY

; 158 -->   0.....?	168 SAMPLES
; 159 -->   ?.....?
; 160 -->   ?.....?
; 161 -->   ?.....?
; 162 -->   ?.....?
; 163 -->   ?.....?
; 164 -->   ?.....?
; 165 -->   ?.....?
; 166 -->   ?.....?
; 167 -->   ?.....?
; 168 -->   ?.....?	ZONE 1 DELAY POINT OF NO RETURN (DO NOT EXCEED)
; 169 -->   ?.....?
; 170 -->   ?.....?
; 171 -->   ?.....?
; 172 -->   ?.....?
; 173 -->   ?.....?
; 174 -->   ?.....?
; 175 -->   ?...167	ZONE 2 COMPLETE! SAMPLE DATA LINES 0..167 READY!


; --------------------------------------------------------------------------


; **HDMI**	262 LINES @ 60hz


; COPPER   DISPLAY

; 165 -->   182...?	START HERE TO FILL 80 SAMPLES **INTERRUPT 165**
; 166 -->   ?.....?
; 167 -->   ?.....?
; 168 -->   ?.....?
; 169 -->   ?.....?
; 170 -->   ?.....?
; 171 -->   ?.....?
; 172 -->   ?.....?
; 173 -->   ?...261	ZONE 1 COMPLETE! SAMPLE DATA LINES 182..261 READY

; 173 -->   0.....?	182 SAMPLES
; 174 -->   ?.....?
; 175 -->   ?.....?
; 176 -->   ?.....?
; 177 -->   ?.....?
; 178 -->   ?.....?
; 179 -->   ?.....?
; 180 -->   ?.....?
; 181 -->   ?.....?
; 182 -->   ?.....?	ZONE 1 DELAY POINT OF NO RETURN (DO NOT EXCEED)
; 183 -->   ?.....?
; 184 -->   ?.....?
; 185 -->   ?.....?
; 186 -->   ?.....?
; 187 -->   ?.....?
; 188 -->   ?.....?
; 189 -->   ?.....?
; 190 -->   ?.....?
; 191 -->   ?...181	ZONE 2 COMPLETE! SAMPLE DATA LINES 0..181 READY!


; **BIS VERSION**


; COPPER   DISPLAY

; 149 -->   166...?	START HERE TO FILL 96 SAMPLES **INTERRUPT 149**
; 150 -->   ?.....?
; 151 -->   ?.....?
; 152 -->   ?.....?
; 153 -->   ?.....?
; 154 -->   ?.....?
; 155 -->   ?.....?
; 156 -->   ?.....?
; 157 -->   ?.....?
; 158 -->   ?...261	ZONE 1 COMPLETE! SAMPLE DATA LINES 166..261 READY

; 158 -->   0.....?	166 SAMPLES
; 159 -->   ?.....?
; 160 -->   ?.....?
; 161 -->   ?.....?
; 162 -->   ?.....?
; 163 -->   ?.....?
; 164 -->   ?.....?
; 165 -->   ?.....?
; 166 -->   ?.....?	ZONE 1 DELAY POINT OF NO RETURN (DO NOT EXCEED)
; 167 -->   ?.....?
; 168 -->   ?.....?
; 169 -->   ?.....?
; 170 -->   ?.....?
; 171 -->   ?.....?
; 172 -->   ?.....?
; 173 -->   ?.....?
; 174 -->   ?.....?
; 175 -->   ?...165	ZONE 2 COMPLETE! SAMPLE DATA LINES 0..165 READY!


; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------


; The sample output code is controlled by real-time generated lists to call
; unrolled code for speed. A loop point, zone split is inserted into the
; control list. One word is needed for 16 samples plus a small overhead for
; loop/split control.


; Example: The following routine outputs 16 samples.


;	dw	copper_out16


; Example: The following routine outputs 8 samples as 19*16+8 = 312


;	dw	copper_out8


; Example: Inserting a loop point at offset 4 into 16 sample unrolled code.


;	dw	copper_out4	; Output 4 samples
;	dw	copper_loop	; Reset read pointer (loop)
;	dw	copper_out12	; Output 12 samples


; --------------------------------------------------------------------------


; Control lists for each of the four video modes (without looping).


;		**VGA 50**

;	dw	copper_out16	; 128 (8*16) samples
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;
;	dw	copper_split
;
;	dw	copper_out16	; 183 (11*16) samples
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out7
;
;	dw	copper_done

;		**VGA 60**

;	dw	copper_out16	; 80 (5*16) samples
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;
;	dw	copper_split
;
;	dw	copper_out16	; 181 (11*16) samples
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out5
;
;	dw	copper_done

;		**HDMI 50**

;	dw	copper_out16	; 128 (8*16) samples
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;
;	dw	copper_split
;
;	dw	copper_out16	; 184 (11*16) samples
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out8
;
;	dw	copper_done

;		**HDMI 60**

;	dw	copper_out16	; 80 (5*16) samples
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;
;	dw	copper_split
;
;	dw	copper_out16	; 182 (11*16) samples
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out16
;	dw	copper_out6
;
;	dw	copper_done


; --------------------------------------------------------------------------


; Control data (11 BYTES).


;vga_50_config	db	163		; Copper line 163 (50hz)
;	dw	311		; Samples per frame
;	db	7		; Split
;	db	8+11		; Count
;	dw	copper_out7	; Routine (311-304)
;	db	$DC		; Index + VBLANK
;	db	$C2
;	dw	32768+183	; Line 183 + command WAIT
;
;vga_60_config	db	167		; Copper line 167 (60hz)
;	dw	261		; Samples per frame
;	db	4		; Split
;	db	5+11		; Count
;	dw	copper_out5	; Routine (261-256)
;	db	$D4		; Index + VBLANK
;	db	$C2
;	dw	32768+181	; Line 181 + command WAIT
;
;hdmi_50_config	db	160		; Copper line 160 (50hz)
;	dw	312		; Samples per frame
;	db	7		; Split
;	db	8+11		; Count
;	dw	copper_out8	; Routine (312-304)
;	db	$E0		; Index + VBLANK
;	db	$C2
;	dw	32768+184	; Line 184 + command WAIT
;
;hdmi_60_config	db	165		; Copper line 165 (60hz)
;	dw	262		; Samples per frame
;	db	4		; Split
;	db	5+11		; Count
;	dw	copper_out6	; Routine (262-256)
;	db	$D8		; Index + VBLANK
;	db	$C2
;	dw	32768+182	; Line 182 + command WAIT


; **BIS VERSION**


vga_50_config	db	147		; Copper line 147 (50hz)
    dw	312		; Samples per frame
    db	8		; Split
    db	9+10		; Count
    dw	copper_out8	; Routine (311-304)
    db	$A0		; Index + VBLANK
    db	$C2
    dw	32768+168	; Line 167 + command WAIT

;vga_50_config	db	147		; Copper line 147 (50hz)
;	dw	311		; Samples per frame
;	db	8		; Split
;	db	9+10		; Count
;	dw	copper_out7	; Routine (311-304)
;	db	$9C		; Index + VBLANK
;	db	$C2
;	dw	32768+167	; Line 167 + command WAIT

vga_60_config	db	151		; Copper line 151 (60hz)
    dw	261		; Samples per frame
    db	5		; Split
    db	6+10		; Count
    dw	copper_out5	; Routine (261-256)
    db	$94		; Index + VBLANK
    db	$C2
    dw	32768+165	; Line 165 + command WAIT

hdmi_50_config	db	144		; Copper line 144 (50hz)
    dw	312		; Samples per frame
    db	8		; Split
    db	9+10		; Count
    dw	copper_out8	; Routine (312-304)
    db	$A0		; Index + VBLANK
    db	$C2
    dw	32768+168	; Line 168 + command WAIT

hdmi_60_config	db	149		; Copper line 149 (60hz)
    dw	262		; Samples per frame
    db	5		; Split
    db	6+10		; Count
    dw	copper_out6	; Routine (262-256)
    db	$98		; Index + VBLANK
    db	$C2
    dw	32768+166	; Line 166 + command WAIT


; --------------------------------------------------------------------------


; Variables.


sample_ptr	dw	0		; 32768
sample_pos	dw	0
sample_len	dw	0		; 10181
sample_dac	db	0		; DAC register

sample_loop	db	0		; 0..255

video_lines:
    dw	0		; 312/311/262/261
video_timing:   
    db	0		; 0..7

    dw	0,0,0,0,0,0,0,0	;
    dw	0,0,0,0,0,0,0,0	; Define 23 WORDS
    dw	0,0,0,0,0,0,0	;

copper_audio_stack:
    dw	copper_done


; --------------------------------------------------------------------------


bisplay_code_length	equ	$-set_sample_pointer	; 576 BYTES


; --------------------------------------------------------------------------

end asm 