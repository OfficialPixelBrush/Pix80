LCDINST: EQU 0
LCDDATA: EQU 1

loop:
; LCD init
LD A,0b00111000     ; set screen mode
OUT (LCDINST),A
LD A,0b00001100     ; turn on display
OUT (LCDINST),A
LD A,0b00000001     ; clear display
OUT (LCDINST),A
LD A,0b00000110     ; set entry mode
OUT (LCDINST),A

; Set DDRAM Address
LD A,0b10000000
OUT (LCDINST),A
 
; IX used as pointer
LD HL,hello
LD C,LCDDATA
LD B,afterhello-hello
OTIR
JR loop
HALT

hello:
    DEFM  "Hello, world! "
afterhello:
