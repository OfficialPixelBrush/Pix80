MEM0: EQU     0b00000000
KEYBOARD: EQU 0b00010000
Device2:  EQU 0b00100000
CMD: EQU 0x8000
STR: EQU 0x9000
NEWLINE: EQU 0x0A
NULL: EQU 0x00
; IX = Command Pointer
; IY = String Pointer
LD IX,CMD      
; KEYBOARD TEST
IM 0 ; Interrupt Mode 0
LD A,'>'
OUT (MEM0),A

getNextInput:
EI ; Renable interrupts
; NOTE: HALT disables interrupts after being triggered
; So interrupts need to be re-enabled every time
HALT ; Wait for next keyboard input
IN  A,(KEYBOARD) ; Read A in
CP 8  ; Check if backspace
JR NZ,skipBackspace ; Doesn't visually update yet, but works!
DEC IX
LD (IX),NULL
JR getNextInput
skipBackspace:
CP 13 ; Check if carriage return
; If Zero flag is triggered, newline has been entered
OUT (MEM0),A ; Doesn't affect flags
LD (IX),A    ; Doesn't affect flags
INC IX       ; Doesn't affect flags
;LD IY,exampleCommand1
;CALL Z,checkCommand ; Compare string
CALL Z,instructionAnalysis
JR getNextInput  ; Jump back

instructionAnalysis:
PUSH BC
; Print Newline
LD A,NEWLINE
OUT (MEM0),A
; Check first Character of command to select mode
LD IX,CMD
LD A,(IX)
CP 'R'
CALL Z,ReadInstruction
CP 'W'
CALL Z,WriteInstruction
CP 'E'
CALL Z,ExecuteInstruction
POP BC
CALL clearCmdBuffer
; Print Newline
LD A,NEWLINE
OUT (MEM0),A
; Print leading char
LD A,'>'
OUT (MEM0),A
LD IX,CMD
RET

ReadInstruction:
CALL asciiToWord
LD A,(HL)
OUT (Device2),A
RET

WriteInstruction:
RET

ExecuteInstruction:
RET

asciiToWord:
CALL asciiToByte
LD H,L
CALL asciiToByte
RET
            
asciiToByte:
LD L,0x00
INC IX
LD A,(IX) ; load IX into A
CALL asciiToHex
; shift over into upper nibble
LD L,A
SLA L
SLA L
SLA L
SLA L
; Shift over by 4 bytes 
INC IX
LD A,(IX) ; load IX into A
CALL asciiToHex
OR L
LD L,A 
RET

; converts whatever char is in A into A
; A = (byte)A
asciiToHex:
SUB 0x30 ; To center at 0
CP 0x10  ; Check if greater than '@' (0x10)
RET C    ; Exit if greater than '@' (0x10)
SUB 0x07 ; Adjust to make letters work
RET

; IY will be loaded with pointer to command to check
checkCommand:
; Print Newline
LD A,NEWLINE
OUT (MEM0),A
; Compare string at CMD and STR
LD IX,CMD
CALL strcmp ; Should set Zero Flag if same
LD IY,exampleCommand1Output
CALL Z,printstr            ; If Same, Print Output
LD IY,unknownCommand
CALL NZ,printstr           ; IF Different, Print Invalid
CALL clearCmdBuffer
LD A,'>'
OUT (MEM0),A
LD IX,CMD
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

; probably faster to just check until end of actually written text
; instead of clearing entire buffer
clearCmdBuffer:
LD IX,CMD
LD A,0x00
LD B,0x10 ; Buffer is probably not gonna be 256 Bytes
clearCmdBufferLoop:
CP B
RET Z ; Exit if Zero
LD (IX),NULL
INC IX
INC A
JR clearCmdBufferLoop

testString:
DEFM "Type something in!",NEWLINE,NULL

exampleCommand1:
DEFM "hello",NULL

exampleCommand1Output:
DEFM "Hello there :)",NEWLINE,NULL

exampleCommand2:
DEFM "test",NULL

exampleCommand2Output:
DEFM "This is a test!",NEWLINE,NULL

unknownCommand:
DEFM "Unknown Command",NEWLINE,NULL
