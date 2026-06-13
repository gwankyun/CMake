#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD <= CXX_STD_23
#  error "CUDA_STANDARD 26 not honored"
#endif
