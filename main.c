#include "functions.h"
#include <stdio.h>

int main(void)
{
	OLED_clear();
	oled_print_char('c', 1, 1, 0);
	printf("done");
	return 1;
}
