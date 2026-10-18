#include <libb.h>
#include <stdio.h>

extern int gen(void);

int main(void)
{
  printf("%i\n", ask() + gen());
  return 0;
}
