if(NOT DEFINED binary_dir)
  message(FATAL_ERROR "binary_dir is required")
endif()
if(NOT DEFINED target_count)
  message(FATAL_ERROR "target_count is required")
endif()

file(GLOB discovery_json_files "${binary_dir}/cmake_test_discovery_*.json")
list(LENGTH discovery_json_files discovery_json_count)

if(NOT discovery_json_count EQUAL target_count)
  message(FATAL_ERROR
    "Expected ${target_count} unique discovery JSON files, found ${discovery_json_count}. "
    "Likely shared discovery scratch file collision in POST_BUILD discovery."
  )
endif()

message(STATUS "Found ${discovery_json_count}/${target_count} unique discovery JSON files")
