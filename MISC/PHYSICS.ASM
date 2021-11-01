LD H,0 ; x pos
LD L,0 ; y pos
LD B,10; x accel
LD C,5 ; y accel
LD D,2 ; gravity
sim: 
    ; x cyclce
    LD A,H
    ADD B
    LD H,A
    ; y cycle
    LD A,L
    ADD C
    LD L,A
    ; gravity applies
    LD A,C
    CP D
    JP C,keep0


    keep0:
    LD C,0
