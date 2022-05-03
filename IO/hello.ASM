; LCD init
LD A,0b00111000     ; set screen mode
OUT (2),A
LD A,0b00111000     ; set screen mode
OUT (0),A
LD A,0b00001100     ; turn on display
OUT (0),A
LD A,0b00000001     ; clear display
OUT (0),A
LD A,0b00000110     ; set entry mode
OUT (0),A
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
    DEFM "Hello, world!",0
