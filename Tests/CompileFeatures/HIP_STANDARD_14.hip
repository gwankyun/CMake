#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD > CXX_STD_14
#  error "HIP_STANDARD 14 honored as higher standard"
#endif
#if defined(CXX_STD) && CXX_STD <= CXX_STD_11
#  error "HIP_STANDARD 14 not honored"
#endif
