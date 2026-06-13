#include "c_std.h"
#if defined(C_STD) && C_STD > C_STD_11
#  error "C_STANDARD 11 honored as higher standard"
#endif
#if defined(C_STD) && C_STD <= C_STD_99 &&                                    \
  !(defined(__SUNPRO_C) && __SUNPRO_C < 0x5140 && C_STD == C_STD_99)
#  error "C_STANDARD 11 not honored"
#endif
