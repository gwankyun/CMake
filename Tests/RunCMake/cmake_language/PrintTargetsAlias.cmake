# Aliases are not listed; the aliased (real) target is.
add_library(zz_real INTERFACE)
add_library(zz_alias ALIAS zz_real)
cmake_language(PRINT_TARGETS REGEX "^zz_")
