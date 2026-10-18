include(RunCMake)

# cmCTestLaunch backs both `ctest --launch` and `ctest --instrument`.  It runs a
# wrapped command and classifies how it terminated.  In the default "passthru"
# mode (the CTEST_LAUNCH_LOGS environment variable is not set) a bare
# `ctest --launch -- <command>` simply runs <command> and returns its
# classified exit code, which makes these cases exercise
# cmCTestLaunch::RunChild's status classification directly.

# Merge stderr into stdout so incidental child output does not trip the default
# empty-stderr expectation; none of these cases assert stdout content.
set(RunCMake_TEST_OUTPUT_MERGE 1)

# --- Regression guards (cross-platform): normal exits pass through unchanged.

# A clean success stays 0.
run_cmake_command(launch-success
  ${CMAKE_CTEST_COMMAND} --launch -- ${CMAKE_COMMAND} -E true)

# A normal non-zero exit is reported as failure.
run_cmake_command(launch-fail
  ${CMAKE_CTEST_COMMAND} --launch -- ${CMAKE_COMMAND} -E false)

# The no-op make rule (":") short-circuits to success before spawning.
run_cmake_command(launch-noop
  ${CMAKE_CTEST_COMMAND} --launch -- :)

# A command that cannot be spawned is reported as failure.
run_cmake_command(launch-spawn-failure
  ${CMAKE_CTEST_COMMAND} --launch -- command-that-does-not-exist-cmctl)

# The signal cases require POSIX signal semantics.
if(UNIX)
  # A normal non-zero exit code is passed through exactly, not collapsed to 1.
  run_cmake_command(launch-exit-code
    ${CMAKE_CTEST_COMMAND} --launch -- /bin/sh -c "exit 3")

  # A command terminated by a signal reports a non-zero exit code.
  run_cmake_command(launch-signal
    ${CMAKE_CTEST_COMMAND} --launch -- /bin/sh -c "kill -s TERM $$")

  # Full launcher mode (CTEST_LAUNCH_LOGS set): a signal-killed rule is treated
  # as an error and an error-*.xml fragment is written for the dashboard.
  set(logdir ${RunCMake_BINARY_DIR}/launch-signal-logs-logs)
  file(REMOVE_RECURSE "${logdir}")
  file(MAKE_DIRECTORY "${logdir}")
  set(ENV{CTEST_LAUNCH_LOGS} "${logdir}")
  run_cmake_command(launch-signal-logs
    ${CMAKE_CTEST_COMMAND} --launch
      --target-name sig --build-dir ${RunCMake_BINARY_DIR}
      -- /bin/sh -c "kill -s TERM $$")
  unset(ENV{CTEST_LAUNCH_LOGS})

  # `ctest --instrument`: with an instrumentation query present, the snippet's
  # `result` field must carry the same non-zero exit code.  Use a dedicated
  # directory name (not "instrument-signal-build") so the harness does not wipe
  # the query we plant here when it cleans the default per-case binary dir.
  set(instrbin ${RunCMake_BINARY_DIR}/instrument-signal-data)
  set(v1 ${instrbin}/.cmake/instrumentation/v1)
  file(REMOVE_RECURSE "${instrbin}")
  file(MAKE_DIRECTORY "${v1}/query")
  file(WRITE "${v1}/query/test.json" "{ \"version\": 1 }\n")
  run_cmake_command(instrument-signal
    ${CMAKE_CTEST_COMMAND} --instrument
      --build-dir ${instrbin} --command-type test
      -- /bin/sh -c "kill -s TERM $$")
endif()
