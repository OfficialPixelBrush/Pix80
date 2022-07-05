LCDINST: EQU 0
LCDDATA: EQU 1

; **********************
; *** UED14500-Pix80 *** 
; **********************
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

; Print UE14500 VFD Display Character
LD A,0b10000000+0x15 ; set DRAM Address
OUT (LCDINST),A
LD A,0
OUT (LCDDATA),A

; Reset Pos
LD A,0b10000000     ; set DRAM Address
OUT (LCDINST),A

; .--------------------.
; |   Emulator Start   | 
; '--------------------'

; 0-3 = INST LOW
; 4-7 = INST HIGH
; k/K = CLK
; 
; Program Counter
LD IX,program+0xE    
; 
;Remote DxxxIIII
LD B ,0b00000000     
; CPU Registers
INST: EQU 0x8001
DATA: EQU 0x8002
IEN:  EQU 0x8003
CARRY:EQU 0x8004
RR_:  EQU 0x8005
OEN:  EQU 0x8006

; Read Header (emulator-only)
  ; Read Delay (just ignore)
  ; Read Initial Setup
; Read Instructions until 0x00
runProgram:
    LD A,(IX)       ;\
    CP 0            ; |- check if end of program
    JP Z,endProgram ;/   (shown by null byte)
; Clock CPU
    CP 'k'          
    JP Z,clkCPU
; Turn DATA on
    CP 'D'          
    JP NZ,nextInst
    SET 7,B
; Turn DATA off
    CP 'd'          
    JP NZ,nextInst
    RES 7,B
; Set Inst 0 to Off
    CP '0'          
    JR NZ,nextInst
    RES 0,B
; Set Inst 1 to Off
    CP '1'     
    JR NZ,nextInst 
    RES 1,B    
; Set Inst 2 to Off
    CP '2'   
    JR NZ,nextInst 
    RES 2,B          
; Set Inst 3 to Off
    CP '3' 
    JR NZ,nextInst 
    RES 3,B           
; Set Inst 0 to On 
    CP '4'  
    JR NZ,nextInst  
    SET 0,B              
; Set Inst 1 to On
    CP '5'  
    JR NZ,nextInst  
    SET 1,B           
; Set Inst 2 to On
    CP '6'    
    JR NZ,nextInst 
    SET 2,B        
; Set Inst 3 to On  
    CP '7' 
    JR NZ,nextInst     
    SET 3,B         
nextInst:
    INC IX          ; load next instruction
    JP runProgram 
endProgram:
HALT

; .-------------------.
; |   UE14500 Clock   | 
; '-------------------'
clkCPU:
    CALL PrintHex
    PUSH AF
    BIT 7,B ; Copy DATA Bit to Zero Flag
    JR NZ,notZero
    LD A,0x1
    JR WriteToDATA
    notZero:
    LD A,0x0
WriteToDATA:
    LD (DATA),A

    POP AF
    LD A,B
    AND 0b00001111
    CP 0x0            ; NOP0 | No change in registers. RR -> RR, FLG0 ^ 
    ;JP Z,NOP0_
    CP 0x1            ; LD   | Load Result Register. Data -> RR 
    ;JP Z,LD_
    CP 0x2            ; ADD  | Add RR and Data. Data + RR -> RR
    ;JP Z,ADD_
    CP 0x3            ; SUB  | Subtract RR and Data. Data - RR -> RR
    ;JP Z,SUB_
    CP 0x4            ; ONE  | Force One into RR. 1 -> RR, 0 -> CAR
    JP Z,ONE_
    CP 0x7            ; XOR  | XOR Data and RR. If RR != Data, 1 -> RR
    JP Z,XOR_
    CP 0xA            ; IEN  | Input Enable Register. Data -> IEN
    JP Z,IEN_
    CP 0xB            ; OEN  | Output Enable Register. Data -> OEN
    JP Z,OEN_
JP nextInst

ONE_:
    LD A,(DATA)
    LD HL,RR_
    XOR (HL)
    LD (RR_),A
    JP nextInst
XOR_:
    LD A,1
    LD (RR_),A
    LD A,0
    LD (RR_),A
    JP nextInst
IEN_:
    LD A,(DATA)
    LD (IEN),A
    JP nextInst
OEN_:
    LD A,(DATA)
    LD (OEN),A
    JP nextInst



; .--------------------.
; |  Helper Functions  | 
; '--------------------'
printHex:
RLCA
RLCA
RLCA
RLCA
CALL printHexFrom4Bits
RLCA
RLCA
RLCA
RLCA
CALL printHexFrom4Bits   
RET      

printHexFrom4Bits:
PUSH AF
AND 0x0F            ; limit to 4 lowest bits
CP 0xA              ; check if less than A
JR NC,biggerThan9    ; if it's bigger than 9, move onto Chars
ADD A,'0'           ; else add ASCII 0
OUT (LCDDATA),A
POP AF
RET

biggerThan9:
ADD A,55          ; otherwise add offset to allow for printing chars
OUT (LCDDATA),A
POP AF
RET

program:
INCLUDEBINARY "hello.emu"
DEFB 0
programend:
