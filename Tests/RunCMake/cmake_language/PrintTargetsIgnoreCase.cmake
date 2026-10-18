add_library(zz_ic_lower INTERFACE)

# Case-sensitive: an uppercase pattern does not match the lowercase target.
cmake_language(PRINT_TARGETS REGEX "ZZ_IC_LOWER")

# IGNORE_CASE: the same pattern now matches.
cmake_language(PRINT_TARGETS REGEX "ZZ_IC_LOWER" IGNORE_CASE)
