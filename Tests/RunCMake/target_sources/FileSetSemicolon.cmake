enable_language(C)

add_library(lib1 STATIC empty.c)

set_property(
  SOURCE ${CMAKE_CURRENT_BINARY_DIR}/h\\;1.h
  PROPERTY GENERATED TRUE
)

set_property(
  SOURCE ${CMAKE_CURRENT_BINARY_DIR}/h\\;2.h
  PROPERTY GENERATED TRUE
)

set_property(
  SOURCE ${CMAKE_CURRENT_BINARY_DIR}/h\\;3.h
  PROPERTY GENERATED TRUE
)

target_sources(lib1
  PRIVATE FILE_SET HEADERS
  BASE_DIRS ${CMAKE_CURRENT_BINARY_DIR}
  FILES ${CMAKE_CURRENT_BINARY_DIR}/h\\\\\\\\;1.h
)

set_property(TARGET lib1 APPEND PROPERTY HEADER_SET
  ${CMAKE_CURRENT_BINARY_DIR}/h\\\\\\\\;2.h
  ${CMAKE_CURRENT_BINARY_DIR}/h\\\\\\\\;3.h
)

# Ensure we get the expected number of escapes when reading back the file set
# files.
get_property(headers TARGET lib1 PROPERTY HEADER_SET)
if (NOT headers MATCHES "h\\\\\\\\\\\\;1[.]h")
  message(STATUS "headers: '${headers}'")
  message(SEND_ERROR "'h;1.h' has wrong level of escaping")
endif()
if (NOT headers MATCHES "h\\\\\\\\\\\\;2[.]h")
  message(STATUS "headers: '${headers}'")
  message(SEND_ERROR "'h;2.h' has wrong level of escaping")
endif()
if (NOT headers MATCHES "h\\\\\\\\\\\\;3[.]h$")
  message(STATUS "headers: '${headers}'")
  message(SEND_ERROR "'h;3.h' has wrong level of escaping")
endif()
