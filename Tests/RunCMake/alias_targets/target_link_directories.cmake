
enable_language(CXX)

add_library(foo empty.cpp)

add_library(alias ALIAS foo)

target_link_directories(alias PRIVATE /usr/local/lib)
get_target_property(val foo LINK_DIRECTORIES)
if(NOT "/usr/local/lib" STREQUAL "${val}")
  message(SEND_ERROR "target_link_directories(): Target property 'LINK_DIRECTORIES' set on ALIAS 'alias' has wrong value on aliased target 'foo': '${val}' instead of '/usr/local/lib'.")
endif()
