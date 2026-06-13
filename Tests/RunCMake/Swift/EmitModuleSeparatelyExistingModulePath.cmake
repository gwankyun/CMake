cmake_minimum_required(VERSION 4.0)

cmake_policy(SET CMP0157 NEW)
cmake_policy(SET CMP0195 NEW)
cmake_policy(SET CMP0215 NEW)

if(NOT CMAKE_GENERATOR MATCHES "Ninja")
  message(SEND_ERROR "this test must use a Ninja generator, found ${CMAKE_GENERATOR}")
endif()

enable_language(Swift)

add_library(L STATIC L.swift)
add_library(LClient STATIC LClient.swift)
target_link_libraries(LClient PRIVATE L)

# Simulate a target whose flags already contain -emit-module-path with a
# directory-style path (as seen with swift-syntax's CMake config).  Use the
# real module triple so the path matches GetSwiftModulePath() and the build
# would succeed outside of dry-run.
target_compile_options(L PRIVATE
  -emit-module-path ${CMAKE_CURRENT_BINARY_DIR}/L.swiftmodule/${CMAKE_Swift_MODULE_TRIPLE}.swiftmodule)
