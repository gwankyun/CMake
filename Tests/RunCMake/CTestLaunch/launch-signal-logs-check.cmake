# Full launcher mode writes an error-*.xml fragment when the wrapped rule fails.
# A signal-killed rule must produce one.
file(GLOB error_files "${RunCMake_BINARY_DIR}/launch-signal-logs-logs/error-*.xml")
if(NOT error_files)
  set(RunCMake_TEST_FAILED
    "No error-*.xml fragment was written for the signal-killed launched rule")
endif()
