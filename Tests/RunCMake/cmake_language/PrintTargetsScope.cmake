add_library(zz_parent INTERFACE)

# Before the subdirectory: only the parent target exists.
cmake_language(PRINT_TARGETS REGEX "^zz_")

add_subdirectory(PrintTargetsScope)

# After: the child's target is visible too.
cmake_language(PRINT_TARGETS REGEX "^zz_")
