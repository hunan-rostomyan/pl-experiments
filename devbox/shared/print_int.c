#include<stdio.h>

/* Writes the contents of RDI to stdout. */
extern void print_int(int n) {
	printf("%d\n", n);
}
