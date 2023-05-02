LCDINST: EQU 0
r_seed: EQU 0x8000

LD A, 15
LD (r_seed),A

loop:
CALL RAND
PUSH AF
AND 0x1
JP Z, printBackslash
LD A,'/'
CALL printCharToLCD
JP exit
printBackslash:
LD A,'\'
CALL printCharToLCD

exit:
POP AF
INC HL
JP loop       ; unconditional jump
HALT 

printCharToLCD:
OUT (1),A        ; otherwise print the character that was found
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
