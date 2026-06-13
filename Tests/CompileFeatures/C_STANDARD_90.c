#include "c_std.h"
#if defined(C_STD) && C_STD >= C_STD_99 && !defined(C_STD_MISSING)
#  error "C_STANDARD 90 honored as higher standard"
#endif
