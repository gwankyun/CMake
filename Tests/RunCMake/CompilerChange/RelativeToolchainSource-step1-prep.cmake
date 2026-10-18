file(REMOVE_RECURSE "${RunCMake_TEST_SOURCE_DIR}")
file(MAKE_DIRECTORY "${RunCMake_TEST_SOURCE_DIR}")
file(COPY
  "${RunCMake_SOURCE_DIR}/CMakeLists.txt"
  "${RunCMake_SOURCE_DIR}/RelativeToolchainSource-step1.cmake"
  "${RunCMake_SOURCE_DIR}/RelativeToolchainSource-step2.cmake"
  "${RunCMake_BINARY_DIR}/foo.cmake"
  DESTINATION "${RunCMake_TEST_SOURCE_DIR}"
)
