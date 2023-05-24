MAXCOMMANDLENGTH: EQU 0xFF
ONBOARD:  EQU 0b00000000
TERMINAL: EQU 0b00010000
HEXPRINT: EQU 0b00100000
CMD: EQU 0xF000
STR: EQU 0xE000
NEWLINE: EQU 0x0A
NULL: EQU 0x00

IM

; Term V0.2
; RST is used as the equivalent to INT on x86
; BC will be used like AX of x86
; Used as reference (from TRSDOS):
; https://en.wikipedia.org/wiki/Zilog_Z80#Example_code

; purposes of registers from z80-heaven
; http://z80-heaven.wikidot.com/the-registers-and-memory
ORG 0x0000
IM 0
RST 08h
JR boot

; RST Functions
ORG 0x0008
test:
LD A,'8'
OUT (TERMINAL),A
RET

; Non-RST Stuff
boot:
ORG 0x0040
