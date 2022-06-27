LCDINST: EQU 0
LCDDATA: EQU 1

; **********************
; *** RED PANDA SPIN *** 
; **********************
; LCD init
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Set Number of Lines and Font
OUT (LCDINST),A
LD A, 0b00001111 ; Set Display Control Properties
OUT (LCDINST),A
OUT (LCDINST),A
LD A, 0b00000001 ; Clear Screen
LD A, 0b00000110 ; Set Entry Mode
OUT (LCDINST),A


LD A,0b10010101     ; set DRAM Address
OUT (LCDINST),A

; draw the 8 characters
LD A,0
OUT (LCDDATA),A
LD A,1
OUT (LCDDATA),A
LD A,0b10000000 + 0x55     ; set DRAM Address to second row
OUT (LCDINST),A
LD A,2
OUT (LCDDATA),A
LD A,3
OUT (LCDDATA),A
; very cheap, but functional
LD A,0b11000011     ; set DRAM Address
OUT (LCDINST),A
LD A,"/"            ; print quote
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"-"            ; print dash
OUT (LCDDATA),A
LD A,"'"            ; print dash
OUT (LCDDATA),A

; print second panda
;LD A,0b10010101     ; set DRAM Address
;OUT (LCDINST),A
;IN A,(LCDDATA)
;LD B,A
;LD A,0b10010101+4     ; set DRAM Address
;OUT (LCDINST),A
;LD A,B
;OUT (LCDDATA),A

LD A,0b10000000 + 0x03    ; set DRAM Address
OUT (LCDINST),A
; Print "Hello, world!"
    ; IX used as pointer
    LD IX,hello
writeHelloWorld:
    ; hello offset + pointer
    LD A,(IX)
    ; increment IX
    INC IX
    CP 0  ; check if contents of A is 0 
    JR Z,exitHello ; if it is, exit, otherwise resume
    ; output on data bus to LCD
    OUT (LCDDATA),A
    JR writeHelloWorld

exitHello:
; Red Panda Speen
pandaLoop:
LD A,0b01000000     ; set CGRAM Address
OUT (LCDINST),A
; load byte into Char
; Panda 0
LD B,0
LD HL,panda0
panda0loop:
LD A,(HL) ; load contents of mem location HL
OUT (LCDDATA),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda0loop
; Panda 1
LD A,0b01000000     ; set CGRAM Address
OUT (LCDINST),A
; load byte into Char
LD B,0
LD HL,panda1
panda1loop:
LD A,(HL) ; load contents of mem location HL
OUT (LCDDATA),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda1loop
; Panda 2
LD A,0b01000000     ; set CGRAM Address
OUT (LCDINST),A
; load byte into Char
LD B,0
LD HL,panda2
panda2loop:
LD A,(HL) ; load contents of mem location HL
OUT (LCDDATA),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda2loop
; Panda 3
LD A,0b01000000     ; set CGRAM Address
OUT (LCDINST),A
; load byte into Char
LD B,0
LD HL,panda3
panda3loop:
LD A,(HL) ; load contents of mem location HL
OUT (LCDDATA),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda3loop
; Panda 4
LD A,0b01000000     ; set CGRAM Address
OUT (LCDINST),A
; load byte into Char
LD B,0
LD HL,panda4
panda4loop:
LD A,(HL) ; load contents of mem location HL
OUT (LCDDATA),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda4loop
; Panda 5
LD A,0b01000000     ; set CGRAM Address
OUT (LCDINST),A
; load byte into Char
LD B,0
LD HL,panda5
panda5loop:
LD A,(HL) ; load contents of mem location HL
OUT (LCDDATA),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda5loop
; Panda 6
LD A,0b01000000     ; set CGRAM Address
OUT (LCDINST),A
; load byte into Char
LD B,0
LD HL,panda6
panda6loop:
LD A,(HL) ; load contents of mem location HL
OUT (LCDDATA),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda6loop
; Panda 7
LD A,0b01000000     ; set CGRAM Address
OUT (LCDINST),A
; load byte into Char
LD B,0
LD HL,panda7
panda7loop:
LD A,(HL) ; load contents of mem location HL
OUT (LCDDATA),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda7loop

JP pandaLoop
HALT

waitForLCDbusyFlag:  
    PUSH AF
    IN A,(0)
    BIT 7,A
    JR NZ,waitForLCDbusyFlag
    POP AF
    RET

hello:
    DEFM '|',"Hello, world!",'|',0
panda0:
    INCLUDEBINARY "redPanda0.bin"
panda1:
    INCLUDEBINARY "redPanda1.bin"
panda2:
    INCLUDEBINARY "redPanda2.bin"
panda3:
    INCLUDEBINARY "redPanda3.bin"
panda4:
    INCLUDEBINARY "redPanda4.bin"
panda5:
    INCLUDEBINARY "redPanda5.bin"
panda6:
    INCLUDEBINARY "redPanda6.bin"
panda7:
    INCLUDEBINARY "redPanda7.bin"
