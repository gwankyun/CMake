# Test helper run as a CTest test command:
#   cmake -DMARKER=<path> [-DSECONDS=<n>] -P runtest.cmake
#
# It records that the test started by touching MARKER, then optionally sleeps
# for SECONDS.  The marker lets the interrupt tests observe exactly which tests
# ran (and thus which pending tests were canceled, or which finished tests a
# `ctest -F` resume skipped).
cmake_minimum_required(VERSION 3.30)

cmake_path(GET MARKER PARENT_PATH marker_dir)
file(MAKE_DIRECTORY "${marker_dir}")
file(TOUCH "${MARKER}")

if (SECONDS)
  execute_process(COMMAND "${CMAKE_COMMAND}" -E sleep "${SECONDS}")
endif()
