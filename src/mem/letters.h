/*
 * letters.h
 *
 *  Created on: Mar 22, 2022
 *      Author: nicolau1
 */
#include <stdint.h>

#ifndef SRC_LETTERS_H_
#define SRC_LETTERS_H_

int64_t char_to_byte[128];

/* a struct that holds a color. The R, G, B value should not be larger than 0xF (16) */
typedef struct color_struct {
	char R;
	char G;
	char B;
} color;

// some predefined colors
color black = { .R = 0x0, .G = 0x0, .B = 0x0 };
color white = { .R = 0xF, .G = 0xF, .B = 0xF };
color yellow = { .R = 0xF, .G = 0xF, .B = 0x0 };
color green = { .R = 0x0, .G = 0xF, .B = 0x0 };
color red = { .R = 0xF, .G = 0x0, .B = 0x0 };

void setupLetters();
void drawChar(int* DDR_addr, int top_left_x, int top_left_y, char ch, color c, color background);
void drawSentence(int* DDR_addr, int top_left_x, int top_left_y, char* str, color c, color background);

//below this is not my code

/* function declarations */
void drawFilledRect(int* DDR_addr, int top_left_x, int top_left_y, int length,
		int width, color c);
void drawFilledCircle(int* DDR_addr, int cent_x, int cent_y, int radius,
		color c);
void clearScreen(int* DDR_addr);
void writeRGB(int* DDR_addr, int x, int y, color c);
void setVideoMemAddr(volatile int* TFT_addr, int* DDR_addr);
void disableVGA(volatile int* TFT_addr);
void enableVGA(volatile int* TFT_addr);

#endif /* SRC_LETTERS_H_ */
