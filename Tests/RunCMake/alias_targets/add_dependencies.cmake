
enable_language(CXX)

add_library(foo empty.cpp)
add_library(bar empty.cpp)

add_library(alias ALIAS foo)

add_dependencies(alias bar)

get_property(DEPS TARGET foo PROPERTY MANUALLY_ADDED_DEPENDENCIES)
if(NOT DEPS STREQUAL "bar")
  message(SEND_ERROR "add_dependencies(): Expected 'bar' as dependency of 'foo' but got: '${DEPS}' instead of 'bar'.")
endif()
