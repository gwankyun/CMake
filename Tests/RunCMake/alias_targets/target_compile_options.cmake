
enable_language(CXX)

add_library(foo empty.cpp)

add_library(alias ALIAS foo)

target_compile_options(alias PRIVATE -Wall)
get_target_property(val foo COMPILE_OPTIONS)
if(NOT "-Wall" STREQUAL "${val}")
  message(SEND_ERROR "target_compile_options(): Target property 'COMPILE_OPTIONS' set on ALIAS 'alias' has wrong value on aliased target 'foo': '${val}' instead of '-Wall'.")
endif()
