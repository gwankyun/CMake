if (NOT RunCMake_GENERATOR_IS_MULTI_CONFIG)
  set(foobar_pch_h_header "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/foobar.dir/CMakeFiles/foobar.dir/cmake_pch.h")
  set(foobar_pch_hxx_header "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/foobar.dir/CMakeFiles/foobar.dir/cmake_pch.hxx")
else()
  set(foobar_pch_h_header "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/foobar.dir/cmake_pch.h")
  set(foobar_pch_hxx_header "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/foobar.dir/cmake_pch.hxx")
endif()

if (NOT EXISTS ${foobar_pch_h_header})
  set(RunCMake_TEST_FAILED "Generated foobar C pch header ${foobar_pch_h_header} does not exist")
  return()
endif()

if (NOT EXISTS ${foobar_pch_hxx_header})
  set(RunCMake_TEST_FAILED "Generated foobar C++ pch header ${foobar_pch_hxx_header} does not exist")
  return()
endif()