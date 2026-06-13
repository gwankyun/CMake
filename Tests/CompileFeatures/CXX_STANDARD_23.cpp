#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD > CXX_STD_23 && !defined(CXX_STD_LATEST)
#  error "CXX_STANDARD 23 honored as higher standard"
#endif
#if defined(CXX_STD) && CXX_STD <= CXX_STD_20
#  error "CXX_STANDARD 23 not honored"
#endif
