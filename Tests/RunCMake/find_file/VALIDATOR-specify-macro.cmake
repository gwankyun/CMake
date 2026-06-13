
macro(CHECK result path)
endmacro()

find_file(result NAMES input.txt VALIDATOR check)

add_subdirectory(subdir)
find_file(result NAMES input.txt VALIDATOR check2)
