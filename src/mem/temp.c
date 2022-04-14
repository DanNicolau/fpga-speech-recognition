	//setup vga
	int* vid_addr = (int*) 0x80800000; //was previously 8000 0000 but that crashes
	volatile int* TFT_addr = (int*) 0x44a00000;

	disableVGA(TFT_addr);
	setVideoMemAddr(TFT_addr, vid_addr);
	clearScreen(vid_addr);
	enableVGA(TFT_addr);
	setupLetters();
	// some predefined colors
	color black = { .R = 0x0, .G = 0x0, .B = 0x0 };
	color white = { .R = 0xF, .G = 0xF, .B = 0xF };
	color yellow = { .R = 0xF, .G = 0xF, .B = 0x0 };
	color green = { .R = 0x0, .G = 0xF, .B = 0x0 };
	color red = { .R = 0xF, .G = 0x0, .B = 0x0 };

	drawSentence(vid_addr, 130, 50, "fpga speech recognition", white, black);