; Counter
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
LD A,0b10000000     ; set DRAM Address
OUT (1),A

loop:
LD A,0b00000010     ; go home
OUT (1),A
LD A,R
OUT (0),A
JR loop
HALT
