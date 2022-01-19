; I/O Device 0 is LCD Instructions (RS = 0)
; I/O Device 1 is LCD Data         (RS = 1)
; Startup setup
; Clear Display
LD A,0b00000001
OUT (0),A
; Display ON
LD A,0b00000001
OUT (0),A
; Function Set
LD A,0b00101000
OUT (0),A


; Set CGRAM address
LD A,0b01000000
OUT (0),A

; Write Data to Screen
; Last 3 bits shouldn't matter
LD A,0b00010101
OUT (1),A
OUT (1),A
OUT (1),A
OUT (1),A
OUT (1),A
OUT (1),A
OUT (1),A
OUT (1),A
; Should be alternating lines

; Set DDRAM Address
LD A,0b10000000
OUT (0),A

; Print Character
LD A,1
OUT (1),A 
   
; IX used as pointer
LD IX,0
writeHelloWorld:
; hello offset + pointer
LD A,(IX+hello)
; output on data bus to LCD
OUT (1),A
; increment IX
INC IX
CP 0
JP NZ,writeHelloWorld 
HALT

hello:
    DEFM  "Hello, world!",0

panda:
    ;INCLUDE "redPanda.bin"
