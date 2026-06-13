
macro(CHECK result path)
endmacro()

find_path(result NAMES input.txt VALIDATOR check)

add_subdirectory(subdir)
find_path(result NAMES input.txt VALIDATOR check2)
