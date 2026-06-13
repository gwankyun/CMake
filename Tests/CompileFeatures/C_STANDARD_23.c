#include "c_std.h"
#if defined(C_STD) && C_STD > C_STD_23 && !defined(C_STD_LATEST)
#  error "C_STANDARD 23 honored as higher standard"
#endif
#if defined(C_STD) && C_STD <= C_STD_17 &&                                    \
  !(C_STD == C_STD_17 && defined(__clang_major__) && __clang_major__ < 14)
#  error "C_STANDARD 23 not honored"
#endif
