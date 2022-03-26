/*
 *  ___        ___  __   ___
 * | . \<>__  < . >|  | | __| _ _  _  _
 * |  _/||\ \// . \| \| | _| / | \| || |
 * |_|  ||/\_\\___/`__' |___|| | |\____|
 *
 * An Emulator written in C, made to emulate 
 * the Z80-based Pix80 Computer.
 * It should, best case, run all software
 * flawlessly and with high accuracy.
 *
 */


#include <vrEmuLcd.h>
#define CHIPS_IMPL
#include <z80.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include <string.h>
#include <SDL2/SDL.h>
// Normally SDL2 will redefine the main entry point of the program for Windows applications
// this doesn't seem to play nice with TCC, so we just undefine the redefinition
#ifdef __TINYC__
    #undef main
#endif

// Utility macros
#define CHECK_ERROR(test, message) \
    do { \
        if((test)) { \
            fprintf(stderr, "%s\n", (message)); \
            exit(1); \
        } \
    } while(0)

#define LCD_WIDTH 20
#define LCD_HEIGHT 4

// Initialize a few things
VrEmuLcd *lcd;
SDL_Renderer *renderer;
bool running = true;
SDL_Event event;
static const int scale = 7;

// Window dimensions
static const int width = 119*7;
static const int height = 35*7;

// Get the current I/O Device number
uint16_t getDevice(uint64_t pins) {
    const uint16_t addr = Z80_GET_ADDR(pins) & 0b111;
	return addr;
}

// Update and Redraw LCD
int refreshLCD() {
	// Clear screen
	SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
	SDL_RenderClear(renderer);
	// then periodically, render it. 
	vrEmuLcdUpdatePixels(lcd);   // generates a snapshot of the pixels state
	
	for (int y = 0; y < vrEmuLcdNumPixelsY(lcd); ++y) {
	  for (int x = 0; x < vrEmuLcdNumPixelsX(lcd); ++x) {
		// do whatever you like with the pixel information. render it to a texture, output it to  a console, whatever
	   // values returned are:  -1 = no pixel (character borders), 0 = pixel off, 1 = pixel on
		char pixel = vrEmuLcdPixelState(lcd, x, y);
		SDL_Rect pixDraw[] = {
			{ x*scale, y*scale, x*scale+scale, y*scale+scale }
		};
		switch (pixel) {
			case -1:
				SDL_SetRenderDrawColor(renderer, 50, 72, 253, 255);
				// OLD SDL_SetRenderDrawColor(renderer, 31, 139, 255, 255);
				SDL_RenderFillRect(renderer,pixDraw);
				break;
			case 0:
				SDL_SetRenderDrawColor(renderer, 50, 60, 254, 255);
				// OLD SDL_SetRenderDrawColor(renderer, 61, 171, 255, 255);
				SDL_RenderFillRect(renderer,pixDraw);
				break;
			case 1:
				SDL_SetRenderDrawColor(renderer, 240, 252, 253, 255);
				// OLD SDL_SetRenderDrawColor(renderer, 245, 253, 255, 255);
				SDL_RenderFillRect(renderer,pixDraw);
				break;
		}
	  }
	}
	
	// Show what was drawn
	SDL_RenderPresent(renderer);
	return 0;
}

int main(int argc, char **argv) {
	// ---------------------- Rendering ----------------------
    
    // Initialize SDL
    CHECK_ERROR(SDL_Init(SDL_INIT_VIDEO) != 0, SDL_GetError());

    // Create an SDL window
    SDL_Window *window = SDL_CreateWindow("Pix80Emu", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_OPENGL);
    CHECK_ERROR(window == NULL, SDL_GetError());

    // Create a renderer (accelerated and in sync with the display refresh rate)
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);    
    CHECK_ERROR(renderer == NULL, SDL_GetError());

    // Initial renderer color
    SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
	
	// ---------------------- Hardware ----------------------
	// LCD init
	lcd = vrEmuLcdNew(LCD_WIDTH, LCD_HEIGHT, EmuLcdRomA00);
	
    // 32 KB of ROM memory (0x0000 - 0x7FFF)
	// 32 KB of RAM memory (0x8000 - 0xFFFF)
	FILE *in_file;
	if (in_file = fopen(argv[1], "rb")) { // read only
		// file exists
	} else {
		// If no file is found, print it on the LCD
		vrEmuLcdSendCommand(lcd, LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON);
		vrEmuLcdSendCommand(lcd, LCD_CMD_FUNCTION | LCD_CMD_FUNCTION_LCD_2LINE | 0x10);
		vrEmuLcdSendCommand(lcd, LCD_CMD_CLEAR);
		vrEmuLcdSendCommand(lcd, LCD_CMD_SET_DRAM_ADDR | 0x43);
		vrEmuLcdWriteString(lcd, "No file found!");
		refreshLCD();
		goto stop;
	}
	// Initalize all memory
	uint8_t mem[(1<<16)];
	
	// Load ROM file into Memory
	int loadROM;
	char c;
	while ((c = fgetc(in_file)) != EOF)
	{
		mem[loadROM] = c;
		loadROM++;
	
		// end-of-file related
		if (feof(in_file)) {
		  // hit end of file
		} else {
		  // some other error interrupted the read
		}
	}

    // initialize Z80 CPU
    z80_t cpu;
    uint64_t pins = z80_init(&cpu);
	
	// reset Z80 CPU for it to be in a known state
	z80_reset(&cpu);
	
	// ---------------------- Actual Emulation ----------------------
	// run code until HALT pin (active low) goes low
	char keyboard;
	char capslock = 0;
	while(running) {  
		// Process Keyboard Inputs
		while(SDL_PollEvent(&event)) {
			if(event.type == SDL_QUIT) {
				running = false;
			} else if(event.type == SDL_KEYDOWN) {
				const char *key = SDL_GetKeyName(event.key.keysym.sym);
				//printf("%s\n",key);
                if(strcmp(key, "Backspace") == 0) {
					keyboard = 8;
				} else if (strcmp(key, "Return") == 0) {
					keyboard = 13;
				} else if (strcmp(key, "Escape") == 0) {
					keyboard = 27;
					running = false;
				} else if (strcmp(key, "Space") == 0) {
					keyboard = ' ';
				} else if (strcmp(key, "CapsLock") == 0) {
					capslock = !capslock;
				} else if (key[0] > ' ') {
					if (capslock)
						keyboard = key[0];
					else
						keyboard = key[0]+32;
				}
			}
		}
		
        // tick the CPU
        pins = z80_tick(&cpu, pins);  

        // handle memory read or write access
        if (pins & Z80_MREQ) {
            if (pins & Z80_RD) {
				// Read Instructions
                Z80_SET_DATA(pins, mem[Z80_GET_ADDR(pins)]);
				//printf("%X - %X\n", Z80_GET_DATA(pins), Z80_GET_ADDR(pins));
            }
            else if (pins & Z80_WR) {
				// Write to Memory 
                mem[Z80_GET_ADDR(pins)] = Z80_GET_DATA(pins);
            }
        } else if (pins & Z80_IORQ) { // Handle I/O Devices (Read)
			switch (getDevice(pins)) {
				case 0: // LCD Data
					vrEmuLcdWriteByte(lcd, Z80_GET_DATA(pins));
					refreshLCD();
					break;
				case 1: // LCD Instruction
					if (pins & Z80_WR) {
						vrEmuLcdSendCommand(lcd, Z80_GET_DATA(pins));
					} else if (pins & Z80_RD) {
						Z80_SET_DATA(pins, vrEmuLcdReadAddress(lcd));
					}
					refreshLCD();
					break;
				case 2: // Keyboard Input
					Z80_SET_DATA(pins, keyboard);
					pins = pins | Z80_INT
					keyboard = 0;
					refreshLCD();
					break;
				case 3: // Serial I/O
					if (pins & Z80_WR) {
						printf("%c",Z80_GET_DATA(pins));//vrEmuLcdSendCommand(lcd, Z80_GET_DATA(pins));
					} else if (pins & Z80_RD) {
						//Z80_SET_DATA(pins, serialIn[cpu.hl]);
					}
					refreshLCD();
					break;
			}
		}
		// Wait to simulate CPU Clock
		//SDL_Delay(100);
    }
	
	stop:
    while(running) {
		// Process events
		while(SDL_PollEvent(&event)) {
			if(event.type == SDL_QUIT) {
				running = false;
			} else if(event.type == SDL_KEYDOWN) {
				const char *key = SDL_GetKeyName(event.key.keysym.sym);
				if(strcmp(key, "Q") == 0) {
					running = false;
				}                 
			}
		}
	}

    // Release resources
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
