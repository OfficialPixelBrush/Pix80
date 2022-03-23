; LCD init
LD A,0b00111000     ; set screen mode
OUT (1),A
LD A,0b00111000     ; set screen mode
OUT (1),A
LD A,0b00001100     ; turn on display
OUT (1),A
LD A,0b00000001     ; clear display
OUT (1),A
LD A,0b00000110     ; set entry mode
OUT (1),A

; Set CGRAM address
LD A,0b01000000
OUT (1),A

; Write Data to Screen
; Last 3 bits shouldn't matter
LD A,0b10000
OUT (0),A
LD A,0b10000
OUT (0),A
LD A,0b01000
OUT (0),A
LD A,0b00100
OUT (0),A
LD A,0b00010
OUT (0),A
LD A,0b00001
OUT (0),A
LD A,0b00001
OUT (0),A
LD A,0b00001
OUT (0),A
; Should be backslash

; Write Data to Screen
; Last 3 bits shouldn't matter
LD A,0b00001
OUT (0),A
LD A,0b00001
OUT (0),A
LD A,0b00010
OUT (0),A
LD A,0b00100
OUT (0),A
LD A,0b01000
OUT (0),A
LD A,0b10000
OUT (0),A
LD A,0b10000
OUT (0),A
LD A,0b10000
OUT (0),A
; Should be slash

; Set DDRAM Address
LD A,0b10000000
OUT (1),A

loop:
call rnd
ld   c,a
ld   b,0

PUSH AF
JP P, printBackslash
LD A,1
OUT (0),A
JP exit
printBackslash:
LD A,0
OUT (0),A

exit:
POP AF
JP loop       ; unconditional jump

rnd:
        ld  hl,0xA280   ; yw -> zt
        ld  de,0xC0DE   ; xz -> yw
        ld  (rnd+4),hl  ; x = y, z = w
        ld  a,l         ; w = w ^ ( w << 3 )
        add a,a
        add a,a
        add a,a
        xor l
        ld  l,a
        ld  a,d         ; t = x ^ (x << 1)
        add a,a
        xor d
        ld  h,a
        rra             ; t = t ^ (t >> 1) ^ w
        xor h
        xor l
        ld  h,e         ; y = z
        ld  l,a         ; w = t
        ld  (rnd+1),hl
        ret 