; factor = 64 (6 bit-shifts)
LD H,-128 ; X coordinate
LD L,-128 ; Y coordinate
LD IX,25 ; Iteration counter

startSet:
    startRow:
        LD A, 127 
        CP L
        JP Z,endProg
        startColumn:
            LD B,0 ; cx
            LD C,0 ; cy
            LD D,0 ; zx
            LD E,0 ; zy             
            mapRangeX:
                LD A,H
                ; multiply by 255
                sla A
                sla A
                sla A
                sla A
                sla A
                sla A
                sla A
                sla A
                ; divide by 255
                sra A
                sra A
                sra A
                sra A
                sra A
                sra A
                sra A
                sra A
                SUB 128
            LD B,A ; cx = maprange()

            mapRangeY:
                LD A,L
                ; multiply by 255
                sla A
                sla A
                sla A
                sla A
                sla A
                sla A
                sla A
                sla A
                ; divide by 255
                sra A
                sra A
                sra A
                sra A
                sra A
                sra A
                sra A
                sra A
                SUB 128
            LD C,A ; cy = maprange()
            LD D, B ; zx = cx
            LD E, C ; zy = cy

            ; iteration start;
            iterStart:
                
                



                


endProg:
HALT
