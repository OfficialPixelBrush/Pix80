; LCD init
start:
LD A,0b00111000     ; set screen mode
OUT (0),A
LD A,0b00001100     ; turn on display
OUT (0),A
LD A,0b00000001     ; clear display
OUT (0),A
LD A,0b00000110     ; set entry mode
OUT (0),A
JR start
