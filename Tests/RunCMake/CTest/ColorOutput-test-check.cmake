set(log "${RunCMake_TEST_BINARY_DIR}/output-log.txt")
if(NOT EXISTS "${log}")
  set(RunCMake_TEST_FAILED "The expected output log file is missing:\n  ${log}")
  return()
endif()

file(READ "${log}" log_content)

string(ASCII 27 esc)
set(esc_re "${esc}\\[[0-9;]*m")

if(log_content MATCHES "${esc_re}")
  set(RunCMake_TEST_FAILED
    "output-log.txt contains ANSI color escape sequences from CTest output.")
endif()

if(NOT actual_stdout MATCHES "${esc_re}" AND NOT actual_stderr MATCHES "${esc_re}")
  set(RunCMake_TEST_FAILED
    "Neither stdout nor stderr contains ANSI color escape sequences with CLICOLOR_FORCE=1.")
  return()
endif()

if(NOT actual_stdout MATCHES
    "${esc_re}[\n][0-9]+% tests passed, [0-9]+ tests failed out of [0-9]+[\n]${esc_re}")
  set(RunCMake_TEST_FAILED "stdout does not contain color-wrapped failed-summary line.")
endif()

if(actual_stdout MATCHES "${esc_re}The following tests FAILED:")
  set(RunCMake_TEST_FAILED "The failed-tests header is unexpectedly colorized.")
endif()
if(NOT actual_stdout MATCHES
    "The following tests FAILED:[\n]${esc_re}[^\n]*OutputLogNoEscape-Fail \\\(Failed\\\)")
  set(RunCMake_TEST_FAILED "stdout does not contain color-wrapped failed-test entry.")
endif()

if(actual_stdout MATCHES "${esc_re}Total Test time \\\(real\\\)")
  set(RunCMake_TEST_FAILED "The total test time line is unexpectedly colorized.")
endif()
