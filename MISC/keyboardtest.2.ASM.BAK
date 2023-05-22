MEM0: EQU     0b00000000
KEYBOARD: EQU 0b00010000
CMD: EQU 0x8000
STR: EQU 0x9000
NEWLINE: EQU 0x0A
NULL: EQU 0x00
; IX = Command Pointer
; IY = String Pointer
LD IX,CMD      
; KEYBOARD TEST
IM 0 ; Interrupt Mode 0

getNextInput:
EI ; Renable interrupts
; NOTE: HALT disables interrupts after being triggered
; So interrupts need to be re-enabled every time
HALT ; Wait for next keyboard input
IN  A,(KEYBOARD) ; Read A in
CP 13 ; Check if carriage return
; If Zero flag is triggered, newline has been entered
CALL Z,checkCommand ; Compare string
OUT (MEM0),A     ; Print it out
LD (IX),A
INC IX
JR getNextInput  ; Jump back

checkCommand:
; Print Newline
LD A,NEWLINE
OUT (MEM0),A
; Compare string at CMD and STR
LD IX,CMD
LD IY,exampleCommand
CALL strcmp ; Should set Zero Flag if same
LD IY,exampleCommandOutput
CALL Z,printstr            ; If Same, Print Output
LD IY,unknownCommand
CALL NZ,printstr           ; IF Different, Print Invalid
LD IX,CMD ; Reset Command Pointer
RET

strcmp:
LD A,(IY) ; Load content of IY in
CP NULL   ; Check for Null pointer
RET Z     ; Exit if NULL
CP (IX)   ; Compare against IX
RET NZ    ; Exit if not the same
INC IX
INC IY
JR strcmp

; Print string at location given by STR
printstr:
LD A,(IY) ; load value in
CP NULL
JR Z,stringEnd 
OUT (MEM0),A
INC IY
JR printstr
stringEnd:
RET

testString:
DEFM "Type something in!",NEWLINE,NULL

exampleCommand:
DEFM "hello",NULL

exampleCommandOutput:
DEFM "Hello there :)",NEWLINE,NULL

unknownCommand:
DEFM "Unknown Command",NEWLINE,NULL
