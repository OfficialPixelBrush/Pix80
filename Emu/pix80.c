#include <stdio.h>
#define CHIPS_IMPL
#include "z80.h"
#include "vrEmuLcd.h"

#define LCD_WIDTH 20
#define LCD_HEIGHT 4
VrEmuLcd *lcd;

int main() {
    // 64 KB memory with test program at address 0x0000
    uint8_t mem[(1<<16)] = {
        0x3E, 0x02,     // LD A,2
        0x06, 0x03,     // LD B,3
        0x80,           // ADD A,B
        0x00,           // NOP...
    };
	
	// LCD init
	VrEmuLcd *lcd = vrEmuLcd.vrEmuLcdNew(LCD_WIDTH, LCD_HEIGHT, EmuLcdRomA00);

    // initialize Z80 emu and execute some clock cycles 
    z80_t cpu;
    uint64_t pins = z80_init(&cpu);
    for (int i = 0; i < 20; i++) {
        
        // tick the CPU
        pins = z80_tick(&cpu, pins);

        // handle memory read or write access
        if (pins & Z80_MREQ) {
            if (pins & Z80_RD) {
                Z80_SET_DATA(pins, mem[Z80_GET_ADDR(pins)]);
            }
            else if (pins & Z80_WR) {
                mem[Z80_GET_ADDR(pins)] = Z80_GET_DATA(pins);
            }
        }
    }

    // register A should now be 5
    printf("\nRegister A: %d\n", cpu.a);
    return 0;
}