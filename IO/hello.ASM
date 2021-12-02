writeHelloWorld:
; IX used as pointer
LD IX,0
; hello offset + pointer
LD A,(IX+hello)
; output on data bus to LCD
OUT (1),A
; increment IX
INC IX
JP NZ,writeHelloWorld 
HALT

hello:
    DEFM  "Hello, world!",0

