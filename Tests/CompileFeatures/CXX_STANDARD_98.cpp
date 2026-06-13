#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD >= CXX_STD_11 && !defined(CXX_STD_MISSING)
#  error "CXX_STANDARD 98 honored as higher standard"
#endif
