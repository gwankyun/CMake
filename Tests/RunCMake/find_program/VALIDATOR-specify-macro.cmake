
macro(CHECK result path)
endmacro()

find_program(result NAMES input.txt VALIDATOR check)

add_subdirectory(subdir)
find_program(result NAMES input.txt VALIDATOR check2)
