add_library(zz_present INTERFACE)

# A REGEX matching no target prints no header, just a warning.
cmake_language(PRINT_TARGETS REGEX "^zz_no_match_")
