#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD <= CXX_STD_23
#  error "CXX_STANDARD 26 not honored"
#endif
