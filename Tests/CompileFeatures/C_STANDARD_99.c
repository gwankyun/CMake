#include "c_std.h"
#if defined(C_STD) && C_STD > C_STD_99 && !defined(C_STD_MISSING)
#  error "C_STANDARD 99 honored as higher standard"
#endif
#if defined(C_STD) && C_STD < C_STD_99
#  error "C_STANDARD 99 not honored"
#endif
