set(CMake_TEST_Qt5 ON CACHE BOOL "")
set(CMake_TEST_Qt6 ON CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_fedora44_valgrind.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/configure_fedora44_ninja.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/configure_external_test.cmake")
