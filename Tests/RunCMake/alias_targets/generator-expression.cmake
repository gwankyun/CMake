
enable_language(CXX)

add_library(lib empty.cpp)

add_library(alias::lib ALIAS lib)
set_property(TARGET alias::lib PROPERTY COMPILE_DEFINITIONS $<TARGET_PROPERTY:alias::lib,FOO>)
set_property(TARGET lib PROPERTY FOO value)

file(GENERATE OUTPUT "generator-expression-generated.txt" CONTENT "$<TARGET_PROPERTY:lib,COMPILE_DEFINITIONS>")
