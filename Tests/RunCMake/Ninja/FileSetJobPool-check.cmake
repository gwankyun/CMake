set(log "${RunCMake_BINARY_DIR}/FileSetJobPool-build/build.ninja")
file(READ "${log}" build_file)
if(NOT "${build_file}" MATCHES "pool = file_set_compile_pool")
  string(CONCAT RunCMake_TEST_FAILED "Log file:\n ${log}\n" "does not have expected line: pool = file_set_compile_pool")
endif()
if(NOT "${build_file}" MATCHES "pool = target_link_pool")
  string(CONCAT RunCMake_TEST_FAILED "Log file:\n ${log}\n" "does not have expected line: pool = target_link_pool")
endif()
# Even though `source_file_compile_pool` and `target_compile_pool` were defined as the target's compile jobs pool,
# since the file set property overrides it with `file_set_compile_pool` pool, the source file compile job
# and the target compile job pool should not exist in the generated Ninja file.
if("${build_file}" MATCHES "pool = source_file_compile_pool")
  string(CONCAT RunCMake_TEST_FAILED "Log file:\n ${log}\n" "have unexpected line: pool = source_file_compile_pool")
endif()
if("${build_file}" MATCHES "pool = target_compile_pool")
  string(CONCAT RunCMake_TEST_FAILED "Log file:\n ${log}\n" "have unexpected line: pool = target_compile_pool")
endif()
