set(CMake_TEST_CXX OFF CACHE BOOL "")
set(CMake_TEST_Java OFF CACHE BOOL "")

set(CMake_TEST_C_STANDARDS "90;99;11;17;23" CACHE STRING "")

set(configure_no_sccache 1)

include("${CMAKE_CURRENT_LIST_DIR}/configure_external_test.cmake")
