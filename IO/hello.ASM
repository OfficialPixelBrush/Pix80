    ; IX used as pointer
    LD IX,0
writeHelloWorld:
    ; hello offset + pointer
    LD A,(IX+hello)
    ; output on data bus to LCD
    OUT (0),A
    ; increment IX
    INC IX
    CP 0
    JP NZ,writeHelloWorld 
    HALT
hello:
    DEFM "Hello, world!",0
