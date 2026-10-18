
enable_language(CXX)

add_library(foo empty.cpp)

add_library(alias ALIAS foo)

target_include_directories(alias PRIVATE $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)
get_target_property(val foo INCLUDE_DIRECTORIES)
if(NOT "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>" STREQUAL "${val}")
  message(SEND_ERROR "target_include_directories(): Target property 'INCLUDE_DIRECTORIES' set on ALIAS 'alias' has wrong value on aliased target 'foo': '${val}' instead of '$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>'.")
endif()
