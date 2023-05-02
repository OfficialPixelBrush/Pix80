        org 0x0000      ; start at memory address 0x0100

start:  ld hl, 0x0000   ; set HL to the start of memory
        ld bc, 0xffff   ; set BC to the length of memory
        call print_mem   ; call the print_mem subroutine
        jp start        ; loop back to the start

print_mem:
        push bc         ; save BC
        push de         ; save DE
        push hl         ; save HL

        ld a, (hl)      ; load the first byte of memory into A
        call print_byte ; call the print_byte subroutine
        inc hl          ; increment HL to point to the next byte
        dec bc          ; decrement BC to count down the remaining bytes
        jr nz, print_mem ; if BC is not zero, loop back to print_mem

        pop hl          ; restore HL
        pop de          ; restore DE
        pop bc          ; restore BC
        ret             ; return from the subroutine

print_byte:
        push af         ; save AF

        and 0xf0        ; mask the lower 4 bits
        rrca            ; rotate A right by 4 bits
        rrca            ; rotate A right by 4 bits again
        rrca            ; rotate A right by 4 bits again
        rrca            ; rotate A right by 4 bits again
        add a, 0x30     ; convert the value to ASCII
        out (0), a      ; output the ASCII character to device 0

        pop af          ; restore AF
        and 0x0f        ; mask the upper 4 bits
        rrca            ; rotate A right by 4 bits
        rrca            ; rotate A right by 4 bits again
        rrca            ; rotate A right by 4 bits again
        rrca            ; rotate A right by 4 bits again
        add a, 0x30     ; convert the value to ASCII
        out (0), a      ; output the ASCII character to device 0

        ret             ; return from the subroutine

