#include "c_std.h"
#if defined(C_STD) && C_STD > C_STD_17
#  error "C_STANDARD 17 honored as higher standard"
#endif
#if defined(C_STD) && C_STD <= C_STD_11
#  error "C_STANDARD 17 not honored"
#endif
