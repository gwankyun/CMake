#include "cxx_std.h"
#if defined(CXX_STD) && CXX_STD > CXX_STD_11 && !defined(CXX_STD_MISSING)
#  error "CXX_STANDARD 11 honored as higher standard"
#endif
#if defined(CXX_STD) && CXX_STD < CXX_STD_11 &&                               \
  !(CXX_STD == CXX_STD_98 &&                                                  \
    (defined(__IBMCPP__) && defined(_AIX) && __IBMCPP__ == 1610))
#  error "CXX_STANDARD 11 not honored"
#endif
