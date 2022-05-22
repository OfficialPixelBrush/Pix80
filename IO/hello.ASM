; LCD init
LD A,0b00111000     ; set screen mode
CALL waitForLCDbusyFlag
OUT (0),A
LD A,0b00001100     ; turn on display
CALL waitForLCDbusyFlag
OUT (0),A
LD A,0b00000001     ; clear display
CALL waitForLCDbusyFlag
OUT (0),A
LD A,0b00000110     ; set entry mode
CALL waitForLCDbusyFlag
OUT (0),A
    ; IX used as pointer
    LD IX,0
writeHelloWorld:
    ; hello offset + pointer
    LD A,(IX+hello)
    ; output on data bus to LCD
    CALL waitForLCDbusyFlag
    OUT (1),A
    ; increment IX
    INC IX
    CP 0
    JP NZ,writeHelloWorld 
    HALT
hello:
    DEFM "Hello, world!",0  

waitForLCDbusyFlag:  
    PUSH AF
    IN A,(0)
    BIT 7,A
    JR NZ,waitForLCDbusyFlag
    POP AF
    RET
