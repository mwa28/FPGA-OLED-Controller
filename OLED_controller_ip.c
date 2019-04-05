#include "xparameters.h"
#include "xil_io.h"
#include <string.h>
#include "oled_controller_ip.h"

/* 	Define the base memory address of the ZedboardOLED IP core */
#define OLED_BASE XPAR_OLED_CONTROLLER_IP_0_S00_AXI_BASEADDR

void OLED_clear(void)
{
	int i,j=0;
	for (i=0; i<=512; i+=32)
		{
			for (j=0; j<=32; j+=8)
			{
				OLED_CONTROLLER_IP_mWriteReg(OLED_BASE, (i+j), ' ');
			}
		}
}

int oled_print_str(char *c, int row, int col, int invert)
{
	int i,j,k,rem,spacesNum=0;
	if (strlen(c) != 64)
	{
		rem = 64 - strlen(c);
		if (rem > 0)
		{
			char spaces[rem];
			char str2[strlen(spaces)];
			char str1[strlen(c)];
			for(spacesNum = 0; spacesNum <= rem; spacesNum++)
			{
				spaces[spacesNum] = ' ';
			}
			strcpy(str1, c);
			strcpy(str2, spaces);
			strcat(str1, str2);

			for (i=0; i<=512; i+=32)
					{
						for (j=0; j<=32; j+=8)
						{
							OLED_CONTROLLER_IP_mWriteReg(OLED_BASE, (i+j), str1[k++]);
						}
					}
		}
		else return -1;
	}

	return 1;
}

int oled_print_char(char c, int row, int col, int invert)
{
	int i,j=0;
	OLED_CONTROLLER_IP_mWriteReg(OLED_BASE, (row*32+col*8), c);
	for (i=0; i<=512; i+=32)
	{
		for (j=0; j<=32; j+=8)
		{
			if(i*32+j*8 != row*32+col*8)
				OLED_CONTROLLER_IP_mWriteReg(OLED_BASE, (i+j), ' ');
		}
	}
	return 1;

}

