# ctest --instrument writes one snippet per wrapped command when an
# instrumentation query is present.  The snippet's "result" field must carry
# the wrapped command's exit code, which for a signal-killed command is
# non-zero.
set(datadir
  "${RunCMake_BINARY_DIR}/instrument-signal-data/.cmake/instrumentation/v1/data")
file(GLOB snippets "${datadir}/test-*.json")
if(NOT snippets)
  set(RunCMake_TEST_FAILED "No instrumentation snippet was written to ${datadir}")
  return()
endif()
list(GET snippets 0 snippet)
file(READ "${snippet}" contents)
string(JSON result GET "${contents}" result)
if(NOT result STREQUAL "1")
  set(RunCMake_TEST_FAILED
    "Instrumentation snippet result field is [${result}], expected [1]")
endif()
