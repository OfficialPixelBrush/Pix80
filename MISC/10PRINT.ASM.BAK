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

; Set CGRAM address
LD A,0b01000000
OUT (1),A

; Write Data to Screen
; Last 3 bits shouldn't matter
LD A,0b10000
OUT (0),A
LD A,0b10000
OUT (0),A
LD A,0b01000
OUT (0),A
LD A,0b00100
OUT (0),A
LD A,0b00010
OUT (0),A
LD A,0b00001
OUT (0),A
LD A,0b00001
OUT (0),A
LD A,0b00001
OUT (0),A
; Should be backslash

; Write Data to Screen
; Last 3 bits shouldn't matter
LD A,0b00001
OUT (0),A
LD A,0b00001
OUT (0),A
LD A,0b00010
OUT (0),A
LD A,0b00100
OUT (0),A
LD A,0b01000
OUT (0),A
LD A,0b10000
OUT (0),A
LD A,0b10000
OUT (0),A
LD A,0b10000
OUT (0),A
; Should be slash

; Set DDRAM Address
LD A,0b10000000
OUT (1),A

LD HL,0x0000

loop:
CALL rand_8
PUSH AF
JP P, printBackslash
LD A,1
CALL printCharToLCD
JP exit
printBackslash:
LD A,0
CALL printCharToLCD

exit:
POP AF
INC HL
JP loop       ; unconditional jump
HALT 

printCharToLCD:
PUSH AF
INC D            ; if the character is printable, increment D
LD A,D           ; load D into A
CP 0x14          ; check if A is equal to 0x14
CALL Z, NEXTLINE2
CP 0x28          ; check if A is equal to 0x28
CALL Z, NEXTLINE3
CP 0x3C          ; check if A is equal to 0x3C
CALL Z, NEXTLINE4
CP 0x50          ; check if A is equal to 0x50
CALL Z, NEXTLINE1
POP AF
OUT (0),A        ; otherwise print the character that was found
RET

NEXTLINE1:
LD D,0
LD A,0b10000000
OUT (1),A
RET 

NEXTLINE2:
LD A,0x40+0b10000000
OUT (1),A
RET 

NEXTLINE3:
LD A,0x14+0b10000000
OUT (1),A
RET 

NEXTLINE4:
LD A,0x54+0b10000000
OUT (1),A
RET

rand_8:
          LD          A,(r_seed)          ; get seed
          AND          0xB8                    ; mask non feedback bits
          SCF                              ; set carry
          JP          PO,no_clr          ; skip clear if odd
          CCF                              ; complement carry (clear it)
no_clr:
          LD          A,(r_seed)          ; get seed back
          RLA                              ; rotate carry into byte
          LD          (r_seed),A          ; save back for next prn
          RET                              ; done

r_seed:
          DEFB          0x1                    ; prng seed byte (must not be zero)
