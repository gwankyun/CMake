cmake_policy(SET CMP0157 NEW)

if(NOT CMAKE_GENERATOR MATCHES "Ninja")
  message(SEND_ERROR "this test must use a Ninja generator, found ${CMAKE_GENERATOR}")
endif()

enable_language(Swift)

# A target with hyphens in the name.  Swift module names cannot contain
# hyphens, so CMake should replace them with underscores.
add_library(L-hyphen STATIC L.swift)
