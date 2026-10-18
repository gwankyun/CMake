file(READ "${RunCMake_TEST_BINARY_DIR}/someFile.cmake" content)

if(NOT "${content}" MATCHES "add_library\\(foo ")
  set(RunCMake_TEST_FAILED "export(): Exported file does not define aliased target 'foo'.\n")
endif()

if("${content}" MATCHES "add_library\\(alias ")
  set(RunCMake_TEST_FAILED "export(): Exported file lists 'alias' instead of the aliased target 'foo'.\n")
endif()
