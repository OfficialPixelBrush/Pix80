MAXCOMMANDLENGTH: EQU 0xFF
ONBOARD:  EQU 0b00000000
TERMINAL: EQU 0b00010000
HEXPRINT: EQU 0b00100000
CMD: EQU 0xF000
STR: EQU 0xE000
NEWLINE: EQU 0x0A
NULL: EQU 0x00
SerialOut: EQU 0x10
SerialIn: EQU 0x08

; *** Term V0.2 ***
; USING RASM now!!
; RST is used as the equivalent to INT on x86
; BC will be used like AX of x86
; Used as reference (from TRSDOS):
; https://en.wikipedia.org/wiki/Zilog_Z80#Example_code

; purposes of registers from z80-heaven:
; http://z80-heaven.wikidot.com/the-registers-and-memory

; Z80 Docs:
; https://www.zilog.com/docs/z80/um0080.pdf
;
; Info on Interrupts
; http://jgmalcolm.com/z80/intermediate/rstc

; *** GOALS ***
; - Posix-like Syscalls
; - Abstraction is key

; *** INIT ***
ORG 0x0000 
; this is done to establish x86-like interrupt handling
JP boot

; *** RST Functions ***
; Note: RST 00h causes system reboot
; 08h: terminal communication
ORG SerialIn
IN A,(C) ; initial interrupt to find out which device it's from?
; TODO: Buffer Keyboard input
RET
; 10h:
ORG SerialOut ; serial output
; TODO: Mode for single-character printing
printstr:
LD A,(IY) ; load value in
CP NULL
JR Z,endPrint
OUT (C),A
INC IY
JR printstr
endPrint:
EI
RET
; 18h:
; 20h:
; 28h:
; 30h:
; 38h:

; boot-up sequence
boot:
ORG 0x0040
; Idea: Keyboard buffering
; Idea: 
; Set I to 0
LD A,0x00
LD I,A
; setting to interrupt mode 2
; to do RST functions
IM 2
EI ; enable interrupts
LD C,HEXPRINT
LD IY,testString
RST SerialOut
RST SerialOut
RST SerialOut
RST SerialOut

; IX: start character pointer
; continues until NULL character hit
; Print string at location given by STR

testString:
DEFM "Test123",NULL
