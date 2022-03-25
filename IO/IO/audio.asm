; IX used as pointer
LD IX,0
loop:
; hello offset + pointer
LD A,(IX+audio)
; output on data bus to LCD
OUT (1),A
; increment IX
INC IX
JP NZ,loop 
HALT

audio:
    INCLUDE audio.bin
