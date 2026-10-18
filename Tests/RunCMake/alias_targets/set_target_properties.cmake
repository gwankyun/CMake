
enable_language(CXX)

add_library(foo empty.cpp)

add_library(alias ALIAS foo)

set_target_properties(alias PROPERTIES ANYTHING 1)

get_target_property(val foo ANYTHING)
if(NOT val STREQUAL "1")
  message(SEND_ERROR "set_target_properties(): Target property 'ANYTHING' set on ALIAS 'alias' has wrong value on aliased target 'foo': '${val}' instead of '1'.")
endif()
