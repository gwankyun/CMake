
enable_language(CXX)

add_library(foo empty.cpp)

add_library(alias ALIAS foo)

target_compile_definitions(alias PRIVATE MY_DEFINE)
get_target_property(val foo COMPILE_DEFINITIONS)
if(NOT "MY_DEFINE" STREQUAL "${val}")
  message(SEND_ERROR "target_compile_definitions(): Target property 'COMPILE_DEFINITIONS' set on ALIAS 'alias' has wrong value on aliased target 'foo': '${val}' instead of 'MY_DEFINE'.")
endif()
