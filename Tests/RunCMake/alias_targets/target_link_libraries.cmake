
enable_language(CXX)

add_library(foo empty.cpp)
add_library(bar empty.cpp)

add_library(alias ALIAS foo)

target_link_libraries(alias PRIVATE bar)
get_target_property(val foo LINK_LIBRARIES)
if(NOT "bar" IN_LIST val)
  message(SEND_ERROR "target_link_libraries(): Target property 'LINK_LIBRARIES' is missing value added to ALIAS 'alias' on aliased target 'foo': 'bar' not in '${val}'.")
endif()
