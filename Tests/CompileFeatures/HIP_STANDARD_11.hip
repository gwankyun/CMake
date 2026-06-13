#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD > CXX_STD_11
#  error "HIP_STANDARD 11 honored as higher standard"
#endif
#if defined(CXX_STD) && CXX_STD < CXX_STD_11
#  error "HIP_STANDARD 11 not honored"
#endif
