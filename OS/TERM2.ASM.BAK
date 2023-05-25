MAXCOMMANDLENGTH: EQU 0xFF
ONBOARD:  EQU 0b00000000
TERMINAL: EQU 0b00010000
HEXPRINT: EQU 0b00100000
CMD: EQU 0xF000
STR: EQU 0xE000
NEWLINE: EQU 0x0A
NULL: EQU 0x00

; *** Term V0.2 ***
; RST is used as the equivalent to INT on x86
; BC will be used like AX of x86
; Used as reference (from TRSDOS):
; https://en.wikipedia.org/wiki/Zilog_Z80#Example_code

; purposes of registers from z80-heaven:
; http://z80-heaven.wikidot.com/the-registers-and-memory

; Z80 Docs:
; https://www.zilog.com/docs/z80/um0080.pdf

; *** GOALS ***
; - Posix-like Syscalls
; - Abstraction is key

; *** INIT ***
ORG 0x0000
; Idea: Keyboard buffering
; Idea: 
; Set I to 0
LD A,0x00
LD I,A
; setting to interrupt mode 0
IM 0 
; this is done to establish x86-like interrupt handling
JP boot

; *** RST Functions ***
; Note: RST 00h causes system reboot
; 08h: terminal communication
; 10h:
; 18h:
; 20h:
; 28h:
; 30h:
; 38h:
ORG 0x0008 ; terminal interrupt
IN A,(TERMINAL)
RET

; Non-RST Stuff
boot:
ORG 0x0040
RST 0x8

osbuild:
