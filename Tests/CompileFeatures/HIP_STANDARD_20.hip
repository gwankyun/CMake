#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD > CXX_STD_20
#  error "HIP_STANDARD 20 honored as higher standard"
#endif
#if defined(CXX_STD) && CXX_STD <= CXX_STD_17
#  error "HIP_STANDARD 20 not honored"
#endif
