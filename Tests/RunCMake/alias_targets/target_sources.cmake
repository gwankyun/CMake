
enable_language(CXX)

add_library(foo)

add_library(alias ALIAS foo)

target_sources(alias PRIVATE empty.cpp)
get_target_property(val foo SOURCES)
if(NOT "empty.cpp" IN_LIST val)
  message(SEND_ERROR "target_sources(): Target property 'SOURCES' is missing value added to ALIAS 'alias' on aliased target 'foo': 'empty.cpp' not in '${val}'.")
endif()
