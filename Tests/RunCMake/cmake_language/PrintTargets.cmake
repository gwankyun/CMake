enable_language(C)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/zz_stub.c" "int zz_stub(void) { return 0; }\n")

add_library(zz_print_targets_iface INTERFACE)
add_library(zz_print_targets_imp STATIC IMPORTED)
add_library(zz_print_targets_lib STATIC "${CMAKE_CURRENT_BINARY_DIR}/zz_stub.c")
add_custom_target(zz_print_targets_util)

# Default: both imported and non-imported targets.
cmake_language(PRINT_TARGETS REGEX "^zz_print_targets_")

# NO_IMPORTED drops the imported target.
cmake_language(PRINT_TARGETS REGEX "^zz_print_targets_" NO_IMPORTED)

# IMPORTED_ONLY keeps only the imported target.
cmake_language(PRINT_TARGETS REGEX "^zz_print_targets_" IMPORTED_ONLY)
