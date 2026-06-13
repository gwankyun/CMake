#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD > CXX_STD_17
#  error "CUDA_STANDARD 17 honored as higher standard"
#endif
#if defined(CXX_STD) && CXX_STD <= CXX_STD_14
#  error "CUDA_STANDARD 17 not honored"
#endif
