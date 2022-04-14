/*
 * letters.h
 *
 *  Created on: Mar 22, 2022
 *      Author: nicolau1
 */
#include <stdint.h>

#ifndef SRC_LETTERS_H_
#define SRC_LETTERS_H_

#define TL_X 50
#define TL_Y 50
#define VID_ADDR 0x80800000
#define TL_X_2 400

int64_t char_to_byte[128];
int vgaLine;

/* a struct that holds a color. The R, G, B value should not be larger than 0xF (16) */
typedef struct color_struct {
	char R;
	char G;
	char B;
} color;

// some predefined colors
static const color black = { .R = 0x0, .G = 0x0, .B = 0x0 };
static const color white = { .R = 0xF, .G = 0xF, .B = 0xF };
static const color yellow = { .R = 0xF, .G = 0xF, .B = 0x0 };
static const color green = { .R = 0x0, .G = 0xF, .B = 0x0 };
static const color red = { .R = 0xF, .G = 0x0, .B = 0x0 };

static int nextLine = 48; // ascii 0

//static char* wordmap[128];
//
//static char redString[64] = "red";
//static char naiveString[64] = "naive";
//static char poleString[64] = "pole";

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
int getNextVgaLine();

#endif /* SRC_LETTERS_H_ */
