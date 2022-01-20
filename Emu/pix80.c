// Code made to compile with TCC (Tiny C Compiler)

#include <stdio.h>
#include <windows.h>
#include "z80.h"
#include "vrEmuLcd.h"
#define CHIPS_IMPL

#define LCD_WIDTH 20
#define LCD_HEIGHT 4

int clock      = 1000; // Clockspeed in Hz 

uint16_t getDevice(uint64_t pins) {
    const uint16_t addr = Z80_GET_ADDR(pins) & 0b111;
	return addr;
}

// Only exists for debugging purposes
void bin(unsigned n, int maxbits) {
    unsigned i;
	maxbits--;
    for (i = 1 << maxbits; i > 0; i = i / 2)
        (n & i) ? printf("1") : printf("0");
}

int main() {
	// CPU init
	int clockspeed = (1000/clock); // Clockspeed
    // 64 KB memory with test program at address 0x0000
	FILE *in_file  = fopen("F:/Pix80/IO/hello.BIN", "rb"); // read only 
	uint8_t mem[(1<<16)];
	
	// LCD init
	VrEmuLcd *lcd = vrEmuLcd.vrEmuLcdNew(LCD_WIDTH, LCD_HEIGHT, EmuLcdRomA00);
	
	// Load ROM into Memory
	int loadROM;
	char c;
	while ((c = fgetc(in_file)) != EOF)
	{
		mem[loadROM] = c;
		loadROM++;
	}
	if (feof(in_file))
	{
	  // hit end of file
	}
	else
	{
	  // some other error interrupted the read
	}
	
    // initialize Z80 emu and execute some clock cycles 
    z80_t cpu;
    uint64_t pins = z80_init(&cpu);
    //for (int i = 0; i < sizeof(mem); i++) {
	// Reset CPU to make sure it is in a pre-defined state
	z80_reset(&cpu);
	// End if HALT pin goes low
    while(!(pins & Z80_HALT)) {  
        // tick the CPU
        pins = z80_tick(&cpu, pins);

        // handle memory read or write access
        if (pins & Z80_MREQ) {
            if (pins & Z80_RD) {
                Z80_SET_DATA(pins, mem[Z80_GET_ADDR(pins)]);
				//printf("%c ", mem[Z80_GET_ADDR(pins)]);
            }
            else if (pins & Z80_WR) {
                mem[Z80_GET_ADDR(pins)] = Z80_GET_DATA(pins);
            }
        }
		
		// Very primitive ASCII output via I/O
		if ((pins & Z80_IORQ) && getDevice(pins)==1) {
			printf("%c", Z80_GET_DATA(pins));
		}
		//Sleep(clockspeed);
    }
    return 0;
}