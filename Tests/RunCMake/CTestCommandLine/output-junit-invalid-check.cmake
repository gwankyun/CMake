# Verify that CTest did not create our badly formed output file.
if(EXISTS "${RunCMake_TEST_BINARY_DIR}/not-a-dir/junit.xml" OR IS_DIRECTORY "${RunCMake_TEST_BINARY_DIR}/not-a-dir")
  set(RunCMake_TEST_FAILED
    "Found output junit ${RunCMake_TEST_BINARY_DIR}/not-a-dir/junit.xml"
  )
endif()
