cmake_minimum_required(VERSION 3.24...3.28)
project(cxx_modules_multi_config_synth CXX)

include("${CMAKE_SOURCE_DIR}/../cxx-modules-rules.cmake")

add_library(importable)
target_sources(importable
  PUBLIC FILE_SET CXX_MODULES FILES importable.cxx)
target_compile_features(importable PUBLIC cxx_std_20)

export(TARGETS importable
  NAMESPACE CXXModules::
  FILE "${CMAKE_CURRENT_BINARY_DIR}/importable-targets.cmake"
  CXX_MODULES_DIRECTORY "importable-cxx-modules"
  )

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/importable-config.cmake"
  "include(\"\${CMAKE_CURRENT_LIST_DIR}/importable-targets.cmake\")\n"
  )

set(generator
  -G "${CMAKE_GENERATOR}")
if (CMAKE_GENERATOR_TOOLSET)
  list(APPEND generator -T "${CMAKE_GENERATOR_TOOLSET}")
endif ()
if (CMAKE_GENERATOR_PLATFORM)
  list(APPEND generator -A "${CMAKE_GENERATOR_PLATFORM}")
endif ()

add_test(NAME multi_config_synth_consumer
  COMMAND
    "${CMAKE_COMMAND}"
    "-DCMAKE_PREFIX_PATH=${CMAKE_CURRENT_BINARY_DIR}"
    ${generator}
    -S "${CMAKE_CURRENT_SOURCE_DIR}/consumer"
    -B "${CMAKE_CURRENT_BINARY_DIR}/consumer"
  )
add_test(NAME multi_config_synth_build_debug
  COMMAND
    "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/consumer" --config Debug
  )
add_test(NAME multi_config_synth_build_release
  COMMAND
    "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}/consumer" --config Release
  )
set_tests_properties(
  multi_config_synth_build_debug
  multi_config_synth_build_release
  PROPERTIES DEPENDS multi_config_synth_consumer)
add_test(NAME multi_config_synth_run
  COMMAND "${CMAKE_CTEST_COMMAND}" -C Debug --test-dir "${CMAKE_CURRENT_BINARY_DIR}/consumer"
  )
set_tests_properties(multi_config_synth_run
  PROPERTIES DEPENDS multi_config_synth_build_debug)
