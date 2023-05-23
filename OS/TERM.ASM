MAXCOMMANDLENGTH: EQU 0xFF
ONBOARD:  EQU 0b00000000
TERMINAL: EQU 0b00010000
HEXPRINT: EQU 0b00100000
CMD: EQU 0xF000
STR: EQU 0xE000
NEWLINE: EQU 0x0A
NULL: EQU 0x00
; IX = Command Pointer
; IY = String Pointer
LD IX,CMD
LD IY,startupMessage
CALL printstr     
; KEYBOARD TEST
IM 0 ; Interrupt Mode 0
LD A,'>'
OUT (TERMINAL),A

getNextInput:
EI ; Renable interrupts
; NOTE: HALT disables interrupts after being triggered
; So interrupts need to be re-enabled every time
HALT ; Wait for next keyboard input
IN  A,(TERMINAL) ; Read A in
CP 8  ; Check if backspace
JR NZ,skipBackspace ; Doesn't visually update yet, but works!
DEC IX
LD (IX),NULL
JR getNextInput
skipBackspace:
CP 13 ; Check if carriage return
; If Zero flag is triggered, newline has been entered
OUT (TERMINAL),A ; Doesn't affect flags
LD (IX),A    ; Doesn't affect flags
INC IX       ; Doesn't affect flags
;LD IY,exampleCommand1
;CALL Z,checkCommand ; Compare string
CALL Z,instructionAnalysis
JR getNextInput  ; Jump back

instructionAnalysis:
; Print Newline
LD A,NEWLINE
OUT (TERMINAL),A
; Check first Character of command to select mode
LD IX,CMD
LD A,(IX)
; Check instruction
CP 'R'
CALL Z,ReadInstruction
CP 'W'
CALL Z,WriteInstruction
CP 'E'
CALL Z,ExecuteInstruction
; Fall through
CALL clearCmdBuffer
; Print Newline
LD A,NEWLINE
OUT (TERMINAL),A
; Print leading char
LD A,'>'
OUT (TERMINAL),A
LD IX,CMD
RET

ReadInstruction:
    CALL asciiToWord ; load start address into HL
    LD DE, HL ; copy start address to DE
    INC IX ; go to next char
    LD A, (IX)
    CP ':'
    JR Z, ReadInstructionMultiple
    LD A, (HL)
    CALL printByte
    RET

ReadInstructionMultiple:
    EX DE, HL ; DE <- HL
    CALL asciiToWord ; load end address into HL
    nextCycleOfRead:
        LD A,E
        AND 0x0F
        JR NZ,skipNewLine
        ; print seperator
        LD A,NEWLINE
        OUT (TERMINAL),A
          EX DE, HL ; DE <- HL
        CALL printWord
          EX DE, HL ; DE <- HL
        LD A,':'
        OUT (TERMINAL),A
    skipNewLine:
        LD A,(DE)
        CALL printByte   ; print the found byte
        LD A, ' '
        OUT (TERMINAL), A     ; add a space for readability
        INC DE           ; go to next mem location
        LD A,D
        CP H             ; compare current address with end address
        JP NZ, nextCycleOfRead
        LD A,E
        CP L
        JP NZ, nextCycleOfRead
    RET
; NOTE:
; while this does mostly work, it doesn't work as intendend
; mainly, that the very last byte, defined by the second part
; of the command, is not present, only the ones from DE until HL-1


WriteInstruction:
;read address
;read byte
;auto increment address for every subsequent byte
CALL asciiToWord
readNextByte:
INC IX ; go to next char
LD A,(IX)
CP ','
RET NZ
PUSH HL
CALL Z,asciiToByte ; implement Auto increment
POP HL
; Error if ROM
BIT 7,H ; Check Bit 15
JR NZ,notWithinROM
LD IY,errorFailedAccessingROM
CALL printstr ; print error message
RET
notWithinROM:
LD (HL),A
INC HL
JR readNextByte

ExecuteInstruction:
CALL asciiToWord
JP (HL)
RET

asciiToWord:
LD HL,0x0000
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

printWord:
PUSH AF
LD A,H
CALL printByte
LD A,L
CALL printByte
POP AF
RET

; printByte
; byte to print in A
printByte:
PUSH HL
LD L,A
SRL A
SRL A
SRL A
SRL A  ; extract upper nibble
CALL hexToAscii
OUT (TERMINAL),A
LD A,L
CALL hexToAscii
OUT (TERMINAL),A
POP HL
RET

; converts whatever char is in A into A
; A = (byte)A
asciiToHex:
SUB 0x30 ; To center at 0
CP 0x10  ; Check if greater than '@' (0x10)
RET C    ; Exit if greater than '@' (0x10)
SUB 0x07 ; Adjust to make letters work
RET

; converts whatever number is given into ASCII
; A = (char)A
hexToAscii:
AND 0x0F ; Make sure we're only dealing with lower nibble
ADD A,0x30
CP 0x3A  ; Check if greater than 9
RET C
ADD A,0x07 ; Adjust to get to letters
RET

; IY will be loaded with pointer to command to check
; checkCommand:
; Print Newline
; LD A,NEWLINE
; OUT (MEM0),A
; Compare string at CMD and STR
; LD IX,CMD
; CALL strcmp ; Should set Zero Flag if same
; LD IY,exampleCommand1Output
; CALL Z,printstr            ; If Same, Print Output
; LD IY,unknownCommand
; CALL NZ,printstr           ; IF Different, Print Invalid
; CALL clearCmdBuffer
; LD A,'>'
; OUT (MEM0),A
; LD IX,CMD
; RET

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
RET Z
OUT (TERMINAL),A
INC IY
JR printstr

; probably faster to just check until end of actually written text
; instead of clearing entire buffer
clearCmdBuffer:
LD IX,CMD
LD A,0x00
LD B,MAXCOMMANDLENGTH ; Buffer is probably not gonna be 256 Bytes
clearCmdBufferLoop:
CP B
RET Z ; Exit if Zero
LD (IX),NULL
INC IX
INC A
JR clearCmdBufferLoop

unknownCommand:
DEFM "Unknown",NULL
errorFailedAccessingROM:
DEFM "Cannot access ROM",NULL
startupMessage:
DEFM "Build-"
DEFDATETIME
DEFM NEWLINE,NULL
