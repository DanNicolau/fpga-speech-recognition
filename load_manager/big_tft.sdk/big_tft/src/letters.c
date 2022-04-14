/*
 * letters.c
 *
 *  Created on: Mar 22, 2022
 *      Author: nicolau1
 */
#include "letters.h"
#include <stdio.h>

void setupLetters(){
	vgaLine = 0;
	for (int i = 0; i < 128; i++) {
		char_to_byte[i] = 0x0000000000000000; //everything else is blank space
//		wordmap[i] = NULL;
	}
	char_to_byte['a'] = 0x3078ccccfccccc00;
	char_to_byte['b'] = 0xfc66667c6666fc00;
	char_to_byte['c'] = 0x3c66c0c0c0663c00;
	char_to_byte['d'] = 0xf86c6666666cf800;
	char_to_byte['e'] = 0xfe6268786862fe00;
	char_to_byte['f'] = 0xfe6268786860f000;
	char_to_byte['g'] = 0x3c66c0c0ce663e00;
	char_to_byte['h'] = 0xccccccfccccccc00;
	char_to_byte['i'] = 0x7830303030307800;
	char_to_byte['j'] = 0x1e0c0c0ccccc7800;
	char_to_byte['k'] = 0xe6666c786c66e600;
	char_to_byte['l'] = 0xf06060606266fe00;
	char_to_byte['m'] = 0xc6eefefed6666600;
	char_to_byte['n'] = 0xc6e6f6decec6c600;
	char_to_byte['o'] = 0x386cc6c6c66c3800;
	char_to_byte['p'] = 0xfc66667c6060f000;
	char_to_byte['q'] = 0x78ccccccdc7c1c00;
	char_to_byte['r'] = 0xfc66667c6c66e600;
	char_to_byte['s'] = 0x78cce0701ccc7800;
	char_to_byte['t'] = 0xfcb4303030307800;
    char_to_byte['u'] = 0xccccccccccccfc00;
    char_to_byte['v'] = 0xcccccccccc783000;
    char_to_byte['w'] = 0xc6c6c6d6feeec600;
    char_to_byte['x'] = 0xc6c66c38386cc600;
    char_to_byte['y'] = 0xcccccc7830307800;
    char_to_byte['z'] = 0xfec68c183266fe00;
    char_to_byte['0'] = 0x7cc6cedef6e67c00;
    char_to_byte['1'] = 0x307030303030fc00;
    char_to_byte['2'] = 0x78cc0c3860ccfc00;
    char_to_byte['3'] = 0x78cc0c380ccc7800;
    char_to_byte['4'] = 0x1c3c6cccfe0c1e00;
    char_to_byte['5'] = 0xfcc0f80c0ccc7800;
    char_to_byte['6'] = 0x3860c0fccccc7100;
    char_to_byte['7'] = 0xfccc0c1830303000;
    char_to_byte['8'] = 0x78cccc78cccc7800;
    char_to_byte['9'] = 0x78cccc7c0c187000;
    char_to_byte['('] = 0x1830606060301800;
    char_to_byte[')'] = 0x6030181818306000;
    char_to_byte['%'] = 0x00c6cc183066c600;
    char_to_byte['_'] = 0x00000000000000ff;
    char_to_byte['-'] = 0x000000fc00000000;
    char_to_byte['|'] = 0x1818181818181800;
    char_to_byte['.'] = 0x0000000000c0c000;

}

void drawChar(int* DDR_addr, int top_left_x, int top_left_y, char ch, color c, color background){
	int64_t bitmap = char_to_byte[ch];

	int i, j;

	for (i = 0; i < 8; i++) {
		for (j = 0; j < 8; j++){
			if ((bitmap & 0x8000000000000000) == 0){
//				xil_printf("bg\n");
				writeRGB(DDR_addr, j + top_left_x, i + top_left_y, background);
			} else {
//				xil_printf("fg\n");
				writeRGB(DDR_addr, j + top_left_x, i + top_left_y, c);
			}
			bitmap = bitmap << 1;
		}
	}
}

void drawSentence(int* DDR_addr, int top_left_x, int top_left_y, char* str, color c, color background){
	int len = strlen(str);

	for (int i = 0; i < len; i++) {
		drawChar(DDR_addr, top_left_x + i*8, top_left_y, str[i], c, background);
	}
}

//below this is not my code

/* draws a filled rectangle */
void drawFilledRect(int* DDR_addr, int top_left_x, int top_left_y, int length,
		int width, color c) {
	int i, j;

	for (i = 0; i < length; i++) {
		for (j = 0; j < width; j++) {
			writeRGB(DDR_addr, i + top_left_x, j + top_left_y, c);
		}
	}

}



/* draws a filled circle */
void drawFilledCircle(int* DDR_addr, int cent_x, int cent_y, int radius,
		color c) {

	int x, y;
	for (x = cent_x - radius; x < cent_x + radius; x++) {
		for (y = cent_y - radius; y < cent_y + radius; y++) {
			if ((cent_x - x) * (cent_x - x) + (cent_y - y) * (cent_y - y)
					<= radius * radius) {
				writeRGB(DDR_addr, x, y, c);
			}
		}
	}
}

/* empties the video buffer. DDR_addr must be aligned to 2M */
void clearScreen(int* DDR_addr) {
	int* DDR_addr_MAX = DDR_addr + 0x200000;
	for (; DDR_addr < DDR_addr_MAX; DDR_addr++) {
		*DDR_addr = 0x00000000;
	}
}

/* sets the argument pixel in the buffer to the argument color */
void writeRGB(int* DDR_addr, int x, int y, color c) {
	// take the least significant nybble
	char R = c.R & 0b00001111;
	char G = c.G & 0b00001111;
	char B = c.B & 0b00001111;

	// pixel info encoding
	int pixel_value = R * 0x100000 + G * 0x1000 + B * 0x10;

	DDR_addr[1024 * y + x] = pixel_value;
}

/* sets the video buffer address for the VGA display */
void setVideoMemAddr(volatile int* TFT_addr, int* DDR_addr) {
	TFT_addr[0] = (int) DDR_addr;
}

/* turns off the VGA display */
void disableVGA(volatile int* TFT_addr) {
	TFT_addr[1] = 0x00;
}

/* turns on the VGA display */
void enableVGA(volatile int* TFT_addr) {
	TFT_addr[1] = 0x01;
}

int getNextVgaLine(){
	printf("allocating new line\n");
	nextLine += 1;
	if (nextLine >= 10 + 48)
		nextLine = 49;
	return nextLine;
}
