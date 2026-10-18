
enable_language(CXX)

add_library(foo empty.cpp)

add_library(alias ALIAS foo)

target_link_options(alias PRIVATE LINKER:--test)
get_target_property(val foo LINK_OPTIONS)
if(NOT "LINKER:--test" STREQUAL "${val}")
  message(SEND_ERROR "target_link_options(): Target property 'LINK_OPTIONS' set on ALIAS 'alias' has wrong value on aliased target 'foo': '${val}' instead of 'LINKER:--test'.")
endif()
