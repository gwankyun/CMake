cmake_pkg_config(
  EXTRACT builtindirs
  PC_SYSROOT_DIR "${CMAKE_CURRENT_LIST_DIR}/Sys Root"
  TOP_BUILD_DIR "${CMAKE_CURRENT_LIST_DIR}/Top Build"
)

set(expected_dir "${CMAKE_CURRENT_LIST_DIR}/PackageRoot")
set(expected_sysroot "${CMAKE_CURRENT_LIST_DIR}/Sys Root")
set(expected_top_build "${CMAKE_CURRENT_LIST_DIR}/Top Build")
set(expected_options
  "-DROOT=${expected_sysroot}/include"
  "-DTOP=${expected_top_build}/generated"
)

if(NOT CMAKE_PKG_CONFIG_INCLUDES STREQUAL "-I${expected_sysroot}${expected_dir}/include")
  message(FATAL_ERROR "Unexpected built-in directory include: ${CMAKE_PKG_CONFIG_INCLUDES}")
endif()

if(NOT CMAKE_PKG_CONFIG_COMPILE_OPTIONS STREQUAL "${expected_options}")
  message(FATAL_ERROR
    "Unexpected built-in directory options: ${CMAKE_PKG_CONFIG_COMPILE_OPTIONS}")
endif()

if(NOT CMAKE_PKG_CONFIG_LIBDIRS STREQUAL "-L${expected_sysroot}${expected_dir}/lib")
  message(FATAL_ERROR "Unexpected built-in directory libdir: ${CMAKE_PKG_CONFIG_LIBDIRS}")
endif()
