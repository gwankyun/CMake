#ifndef _CRT_SECURE_NO_DEPRECATE
#  define _CRT_SECURE_NO_DEPRECATE
#endif

#include <stdio.h>

int main(int argc, char* argv[])
{
  FILE* out;

  if (argc < 2) {
    return 1;
  }

  out = fopen(argv[1], "w");
  if (!out) {
    return 1;
  }

  fprintf(out, "int gen(void)\n{\n  return 42;\n}\n");
  fclose(out);

  return 0;
}
