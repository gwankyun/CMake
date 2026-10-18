string(MD5 _hash "lib/cmake")
file(READ "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/Export/${_hash}/theTargets.cmake" content)

if(NOT "${content}" MATCHES "add_library\\(foo ")
  set(RunCMake_TEST_FAILED "install(): Aliased target 'foo' was not registered in the export set.\n")
endif()

if("${content}" MATCHES "add_library\\(alias ")
  set(RunCMake_TEST_FAILED "install(): 'alias' was registered in the export set instead of the aliased target 'foo'.\n")
endif()
