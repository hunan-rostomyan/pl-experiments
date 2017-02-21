#include<stdio.h>

/* Read the contents of stdin onto the stack. */
extern int read_int() {
  int i;
  scanf("%d", &i);
  return i;
}
