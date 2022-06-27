LCDINST: EQU 0
LCDDATA: EQU 1
r_seed: EQU 0x8000

LD A, 15
LD (r_seed),A

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

; Set CGRAM address
LD A,0b01000000
OUT (LCDINST),A

; Write Data to Screen
; Last 3 bits shouldn't matter
LD A,0b10000
OUT (LCDDATA),A
LD A,0b10000
OUT (LCDDATA),A
LD A,0b01000
OUT (LCDDATA),A
LD A,0b00100
OUT (LCDDATA),A
LD A,0b00010
OUT (LCDDATA),A
LD A,0b00001
OUT (LCDDATA),A
LD A,0b00001
OUT (LCDDATA),A
LD A,0b00001
OUT (LCDDATA),A
; Should be backslash

; Write Data to Screen
; Last 3 bits shouldn't matter
LD A,0b00001
OUT (LCDDATA),A
LD A,0b00001
OUT (LCDDATA),A
LD A,0b00010
OUT (LCDDATA),A
LD A,0b00100
OUT (LCDDATA),A
LD A,0b01000
OUT (LCDDATA),A
LD A,0b10000
OUT (LCDDATA),A
LD A,0b10000
OUT (LCDDATA),A
LD A,0b10000
OUT (LCDDATA),A
; Should be slash

; Set DDRAM Address
LD A,0b10000000
OUT (LCDINST),A

LD HL,0x0000

loop:
CALL RAND
PUSH AF
AND 0x1
JP Z, printBackslash
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
OUT (1),A        ; otherwise print the character that was found
RET

NEXTLINE1:
LD D,0
LD A,0b10000000
OUT (LCDINST),A
RET 

NEXTLINE2:
LD A,0x40+0b10000000
OUT (LCDINST),A
RET  

NEXTLINE3:
LD A,0x14+0b10000000
OUT (LCDINST),A
RET 

NEXTLINE4:
LD A,0x54+0b10000000
OUT (LCDINST),A
RET


;-----> Generate a random number
; output a=answer 0<=a<=255
; all registers are preserved except: af
RAND:
          LD          A,(r_seed)          ; get seed
          AND         0xB8                    ; mask non feedback bits
          SCF                              ; set carry
          JP          PO,no_clr          ; skip clear if odd
          CCF                              ; complement carry (clear it)
no_clr:
          LD          A,(r_seed)          ; get seed back
          RLA                              ; rotate carry into byte
          LD          (r_seed),A          ; save back for next prn
          RET                              ; done
