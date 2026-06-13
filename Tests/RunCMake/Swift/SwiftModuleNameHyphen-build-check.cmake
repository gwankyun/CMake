# The module name should have underscores, not hyphens.
if(NOT actual_stdout MATCHES "-module-name L_hyphen")
  string(APPEND RunCMake_TEST_FAILED
    "Expected '-module-name L_hyphen', hyphens should be replaced with underscores.\n")
endif()
if(actual_stdout MATCHES "-module-name L-hyphen")
  string(APPEND RunCMake_TEST_FAILED
    "Found '-module-name L-hyphen', hyphens are not valid in Swift module names.\n")
endif()
