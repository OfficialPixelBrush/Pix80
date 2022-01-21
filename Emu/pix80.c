#include <stdio.h>
#define CHIPS_IMPL
// Simply placed into /include/ folder that comes with TCC
#include "z80.h"
#include "vrEmuLcd.h"

// Define LCD Screen-size
#define LCD_WIDTH 20
#define LCD_HEIGHT 4

// Create LCD
VrEmuLcd *lcd;

/* 
 * This program is made to compile with TCC, no paramteres other than the
 * C-file "pix80.c" are given. (e.g. "\.tcc pix80.c")
 * The below example is a simple example program that is mostly irrelevant
 * for this discussion. It uses the basic Setup from this blog post.
 * https://floooh.github.io/2021/12/17/cycle-stepped-z80.html#a-code-sample
 *
 */
int main() {
    // 64 KB memory with test program at address 0x0000
    uint8_t mem[(1<<16)] = {
        0x3E, 0x02,     // LD A,2
        0x06, 0x03,     // LD B,3
        0x80,           // ADD A,B
        0x00,           // NOP...
    };
	
	// LCD init
	// This results in "pix80.c:21: error: 'vrEmuLcd' undeclared"
	// All that is given is the "vrEmuLcd.h" file, not the C-file
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