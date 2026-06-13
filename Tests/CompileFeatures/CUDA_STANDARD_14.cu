#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD > CXX_STD_14
#  error "CUDA_STANDARD 14 honored as higher standard"
#endif
#if defined(CXX_STD) && CXX_STD <= CXX_STD_11
#  error "CUDA_STANDARD 14 not honored"
#endif
