add_library(zz_child INTERFACE)

# The child sees its own target and the ancestor's.
cmake_language(PRINT_TARGETS REGEX "^zz_")
