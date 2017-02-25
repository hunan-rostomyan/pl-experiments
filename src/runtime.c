#include<stdio.h>

/* Writes the contents of RDI to stdout. */
extern void print_int(int n) {
	printf("%d\n", n);
}

/* Read the contents of stdin onto the stack. */
extern int read_int() {
	int i;
	scanf("%d", &i);
	return i;
}
