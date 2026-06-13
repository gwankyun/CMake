
macro(CHECK result path)
endmacro()

find_library(result NAMES input.txt VALIDATOR check)

add_subdirectory(subdir)
find_library(result NAMES input.txt VALIDATOR check2)
