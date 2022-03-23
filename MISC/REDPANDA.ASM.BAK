; RED PANDA SPIN

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
LD A,0b11000000     ; set DRAM Address
OUT (1),A

; draw the 8 characters
LD A,0
OUT (0),A
LD A,1
OUT (0),A
LD A,0b10010100     ; set DRAM Address to second row
OUT (1),A
LD A,2
OUT (0),A
LD A,3
OUT (0),A
; very cheap, but functional

LD A,0b11000010     ; set DRAM Address
OUT (1),A
LD A,'/'            ; print /
OUT (0),A

LD A,0b10000011     ; set DRAM Address
OUT (1),A
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
    OUT (0),A
    JR writeHelloWorld

exitHello:
; Red Panda Speen
pandaLoop:
LD A,0b01000000     ; set CGRAM Address
OUT (1),A
; load byte into Char
; Panda 0
LD B,0
LD HL,panda0
panda0loop:
LD A,(HL) ; load contents of mem location HL
OUT (0),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda0loop
; Panda 1
LD A,0b01000000     ; set CGRAM Address
OUT (1),A
; load byte into Char
LD B,0
LD HL,panda1
panda1loop:
LD A,(HL) ; load contents of mem location HL
OUT (0),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda1loop
; Panda 2
LD A,0b01000000     ; set CGRAM Address
OUT (1),A
; load byte into Char
LD B,0
LD HL,panda2
panda2loop:
LD A,(HL) ; load contents of mem location HL
OUT (0),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda2loop
; Panda 3
LD A,0b01000000     ; set CGRAM Address
OUT (1),A
; load byte into Char
LD B,0
LD HL,panda3
panda3loop:
LD A,(HL) ; load contents of mem location HL
OUT (0),A ; output pixel data
INC HL    ; increase to next location
LD A,64   ; load 32 into A
INC B     ; count B up
CP B      ; check if B is 32
JP NZ,panda3loop

JP pandaLoop
HALT

hello:
    DEFM "Hello, world!",0
panda0:
    INCLUDEBINARY "redPanda0.bin"
panda1:
    INCLUDEBINARY "redPanda1.bin"
panda2:
    INCLUDEBINARY "redPanda2.bin"
panda3:
    INCLUDEBINARY "redPanda3.bin"
