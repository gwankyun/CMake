include(RunCTest)

set(RunCMake_TEST_TIMEOUT 60)

set(CASE_CTEST_TEST_ARGS "")
set(CASE_CTEST_TEST_LOAD "")
set(CASE_CTEST_TEST_RAW_ARGS "")

function(run_ctest_test CASE_NAME)
  set(CASE_CTEST_TEST_ARGS "${ARGN}")
  run_ctest(${CASE_NAME})
endfunction()

run_ctest_test(TestQuiet QUIET)

set(CASE_CMAKELISTS_SUFFIX_CODE [[
foreach(i RANGE 1 4)
  add_test(NAME test${i} COMMAND ${CMAKE_COMMAND} -E true)
  set_property(TEST test${i} PROPERTY RESOURCE_LOCK resource)
endforeach()
]])
run_ctest_test(ResourceLock INCLUDE test PARALLEL_LEVEL 4)
unset(CASE_CMAKELISTS_SUFFIX_CODE)

set(ENV{__CTEST_FAKE_PROCESSOR_COUNT_FOR_TESTING} 4)
set(CASE_CMAKELISTS_SUFFIX_CODE [[
foreach(i RANGE 1 6)
  add_test(NAME test${i} COMMAND ${CMAKE_COMMAND} -E true)
endforeach()
set_property(TEST test1 PROPERTY COST -2)
set_property(TEST test2 PROPERTY COST -1)
set_property(TEST test3 PROPERTY COST 0)
set_property(TEST test4 PROPERTY COST 1)
set_property(TEST test5 PROPERTY COST 2)
set_property(TEST test6 PROPERTY COST 3)
set_property(TEST test6 PROPERTY DEPENDS test1)
]])
run_ctest_test(SerialOrder INCLUDE test)
unset(CASE_CMAKELISTS_SUFFIX_CODE)
unset(ENV{__CTEST_FAKE_PROCESSOR_COUNT_FOR_TESTING)

set(CASE_CMAKELISTS_SUFFIX_CODE [[
add_test(NAME skip COMMAND ${CMAKE_COMMAND} -E true)
set_property(TEST skip PROPERTY SKIP_RETURN_CODE 0)
]])
run_ctest_test(SkipReturnCode)
unset(CASE_CMAKELISTS_SUFFIX_CODE)

# Spoof a number of processors to make these tests predictable.
set(ENV{__CTEST_FAKE_PROCESSOR_COUNT_FOR_TESTING} 1)
set(CASE_CMAKELISTS_SUFFIX_CODE [[
foreach(i RANGE 1 6)
  add_test(NAME test${i} COMMAND ${CMAKE_COMMAND} -E true)
endforeach()
]])
run_ctest_test(ParallelBad   INCLUDE test PARALLEL_LEVEL bad)
set(CASE_CTEST_TEST_RAW_ARGS "PARALLEL_LEVEL \"\"")
run_ctest_test(ParallelEmpty INCLUDE test) # With 1 processor, defaults to 2.
unset(CASE_CTEST_TEST_RAW_ARGS)
run_ctest_test(ParallelOmit  INCLUDE test PARALLEL_LEVEL) # With 1 processor, defaults to 2.
run_ctest_test(Parallel0     INCLUDE test PARALLEL_LEVEL 0)
run_ctest_test(Parallel4     INCLUDE test PARALLEL_LEVEL 4)
set(ENV{CTEST_PARALLEL_LEVEL} bad)
run_ctest_test(ParallelEnvBad INCLUDE test)
if(CMAKE_HOST_WIN32)
  set(ENV{CTEST_PARALLEL_LEVEL} " ")
else()
  set(ENV{CTEST_PARALLEL_LEVEL} "")
endif()
run_ctest_test(ParallelEnvEmpty INCLUDE test) # With 1 processor, defaults to 2.
set(ENV{CTEST_PARALLEL_LEVEL} 0)
run_ctest_test(ParallelEnv0  INCLUDE test)
set(ENV{CTEST_PARALLEL_LEVEL} 3)
run_ctest_test(ParallelEnv3  INCLUDE test)
unset(ENV{CTEST_PARALLEL_LEVEL})
unset(CASE_CMAKELISTS_SUFFIX_CODE)
unset(ENV{__CTEST_FAKE_PROCESSOR_COUNT_FOR_TESTING)

# Tests for the 'Test Load' feature of ctest
#
# Spoof a load average value to make these tests more reliable.
set(ENV{__CTEST_FAKE_LOAD_AVERAGE_FOR_TESTING} 7)
set(RunCTest_VERBOSE_FLAG -VV)
set(CASE_CMAKELISTS_SUFFIX_CODE [[
set_property(TEST RunCMakeVersion PROPERTY PROCESSORS 2)
]])

# Verify that new tests are started when the load average falls below
# our threshold.
run_ctest_test(TestLoadPass TEST_LOAD 8)

# Verify that new tests are not started when the load average exceeds
# our threshold and that they then run once the load average drops.
run_ctest_test(TestLoadWait0 TEST_LOAD 4 PARALLEL_LEVEL 8)
run_ctest_test(TestLoadWait1 TEST_LOAD 8 PARALLEL_LEVEL 8)

# Verify that when an invalid "TEST_LOAD" value is given, a warning
# message is displayed and the value is ignored.
run_ctest_test(TestLoadInvalid TEST_LOAD "ERR1")

# Verify that new tests are started when the load average falls below
# our threshold.
set(CASE_CTEST_TEST_LOAD 9)
run_ctest_test(CTestTestLoadPass)

# Verify that new tests are not started when the load average exceeds
# our threshold and that they then run once the load average drops.
set(CASE_CTEST_TEST_LOAD 6)
run_ctest_test(CTestTestLoadWait0 PARALLEL_LEVEL 8)
set(CASE_CTEST_TEST_LOAD 8)
run_ctest_test(CTestTestLoadWait1 PARALLEL_LEVEL 8)

# Verify that when an invalid "CTEST_TEST_LOAD" value is given,
# a warning message is displayed and the value is ignored.
set(CASE_CTEST_TEST_LOAD "ERR2")
run_ctest_test(CTestTestLoadInvalid)

# Verify that the "TEST_LOAD" value has higher precedence than
# the "CTEST_TEST_LOAD" value
set(CASE_CTEST_TEST_LOAD "ERR3")
run_ctest_test(TestLoadOrder TEST_LOAD "ERR4")

unset(ENV{__CTEST_FAKE_LOAD_AVERAGE_FOR_TESTING})
unset(CASE_CTEST_TEST_LOAD)
unset(CASE_CMAKELISTS_SUFFIX_CODE)
unset(RunCTest_VERBOSE_FLAG)

block()
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
    add_test(NAME testNotRun COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/does_not_exist)
  ]])
  run_ctest_test(NotRun)
endblock()

function(run_TestChangeId)
  set(CASE_TEST_PREFIX_CODE [[
    set(CTEST_CHANGE_ID "<>1")
  ]])

  run_ctest(TestChangeId)
endfunction()
run_TestChangeId()

function(run_TestOutputSize)
  set(CASE_CTEST_TEST_ARGS EXCLUDE RunCMakeVersion)
  set(CASE_TEST_PREFIX_CODE [[
set(CTEST_CUSTOM_MAXIMUM_PASSED_TEST_OUTPUT_SIZE 10)
set(CTEST_CUSTOM_MAXIMUM_FAILED_TEST_OUTPUT_SIZE 12)
  ]])
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
add_test(NAME PassingTest COMMAND ${CMAKE_COMMAND} -E echo PassingTestOutput)
add_test(NAME FailingTest COMMAND ${CMAKE_COMMAND} -E no_such_command)
  ]])

  run_ctest(TestOutputSize)
endfunction()
run_TestOutputSize()

# Test --test-output-truncation
function(run_TestOutputTruncation mode expected)
  set(CASE_CTEST_TEST_ARGS EXCLUDE RunCMakeVersion)
  set(TRUNCATED_OUTPUT ${expected})  # used in TestOutputTruncation-check.cmake
  string(CONCAT CASE_TEST_PREFIX_CODE "
set(CTEST_CUSTOM_MAXIMUM_PASSED_TEST_OUTPUT_SIZE 5)
set(CTEST_CUSTOM_TEST_OUTPUT_TRUNCATION ${mode})" )
  set(CASE_CMAKELISTS_SUFFIX_CODE "
add_test(NAME Truncation_${mode} COMMAND \${CMAKE_COMMAND} -E echo 123456789)")

  run_ctest(TestOutputTruncation_${mode})
endfunction()
run_TestOutputTruncation("head" "\\.\\.\\.6789")
run_TestOutputTruncation("middle" "12\\.\\.\\..*\\.\\.\\.89")
run_TestOutputTruncation("tail" "12345\\.\\.\\.")
run_TestOutputTruncation("bad" "")

run_ctest_test(TestRepeatBad1 REPEAT UNKNOWN:3)
run_ctest_test(TestRepeatBad2 REPEAT UNTIL_FAIL:-1)

function(run_TestRepeat case return_value )
  set(CASE_CTEST_TEST_ARGS RETURN_VALUE result EXCLUDE RunCMakeVersion ${ARGN})
  string(CONCAT suffix_code [[
add_test(NAME testRepeat
  COMMAND ${CMAKE_COMMAND} -D COUNT_FILE=${CMAKE_CURRENT_BINARY_DIR}/count.cmake
                           -P "]] "${RunCMake_SOURCE_DIR}/TestRepeat${case}" [[.cmake")
set_property(TEST testRepeat PROPERTY TIMEOUT 5)
  ]])
  string(APPEND CASE_CMAKELISTS_SUFFIX_CODE "${suffix_code}")

  run_ctest(TestRepeat${case})

  #write to end of the test file logic to Verify we get the expected
  #return code
  string(REPLACE "RETURN_VALUE:" "" return_value "${return_value}" )
  file(APPEND "${RunCMake_BINARY_DIR}/TestRepeat${case}/test.cmake"
"

  set(expected_result ${return_value})
  message(STATUS \${result})
  if(NOT result EQUAL expected_result)
    message(FATAL_ERROR \"expected a return value of: \${expected_result},
                         instead got: \${result}\")
  endif()
"
  )
endfunction()

run_TestRepeat(UntilFail RETURN_VALUE:1 REPEAT UNTIL_FAIL:3)
run_TestRepeat(UntilPass RETURN_VALUE:0 REPEAT UNTIL_PASS:3)
run_TestRepeat(AfterTimeout RETURN_VALUE:0 REPEAT AFTER_TIMEOUT:3)

# test repeat and not run tests interact correctly
set(CASE_CMAKELISTS_SUFFIX_CODE [[
  add_test(NAME testNotRun COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/does_not_exist)
  set_property(TEST testNotRun PROPERTY TIMEOUT 5)
  ]])
run_TestRepeat(NotRun RETURN_VALUE:1 REPEAT UNTIL_PASS:3)
unset(CASE_CMAKELISTS_SUFFIX_CODE)

# test --stop-on-failure
function(run_stop_on_failure)
  set(CASE_CTEST_TEST_ARGS EXCLUDE RunCMakeVersion)
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
add_test(NAME StoppingTest COMMAND ${CMAKE_COMMAND} -E false)
add_test(NAME NotRunTest COMMAND ${CMAKE_COMMAND} -E true)
  ]])

  run_ctest_test(stop-on-failure STOP_ON_FAILURE)
endfunction()
run_stop_on_failure()


# test include/exclude tests from file
function(run_tests_from_file case)
  set(CASE_CTEST_TEST_ARGS ${ARGN})
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
add_test(NAME Test1 COMMAND ${CMAKE_COMMAND} -E true)
add_test(NAME Test2 COMMAND ${CMAKE_COMMAND} -E true)
add_test(NAME Test11 COMMAND ${CMAKE_COMMAND} -E true)
  ]])

  run_ctest(TestsFromFile-${case})
endfunction()
run_tests_from_file(include INCLUDE_FROM_FILE ${RunCMake_SOURCE_DIR}/TestsFromFile-TestList.txt)
run_tests_from_file(exclude EXCLUDE_FROM_FILE ${RunCMake_SOURCE_DIR}/TestsFromFile-TestList.txt)
run_tests_from_file(include-empty INCLUDE_FROM_FILE ${RunCMake_SOURCE_DIR}/TestsFromFile-TestList-empty.txt)
run_tests_from_file(exclude-empty EXCLUDE_FROM_FILE ${RunCMake_SOURCE_DIR}/TestsFromFile-TestList-empty.txt)
run_tests_from_file(include-missing INCLUDE_FROM_FILE ${RunCMake_SOURCE_DIR}/TestsFromFile-TestList-missing.txt)
run_tests_from_file(exclude-missing EXCLUDE_FROM_FILE ${RunCMake_SOURCE_DIR}/TestsFromFile-TestList-missing.txt)


# Make sure environment gets logged
function(run_environment)
  set(ENV{BAD_ENVIRONMENT_VARIABLE} "Bad environment variable")
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
set_property(TEST RunCMakeVersion PROPERTY ENVIRONMENT "ENV1=env1;ENV2=env2")
  ]])

  run_ctest(TestEnvironment)
endfunction()
run_environment()

# test for OUTPUT_JUNIT
run_ctest_test(OutputJUnit OUTPUT_JUNIT junit.xml REPEAT UNTIL_FAIL:2)

# Verify that extra measurements get reported.
function(run_measurements)
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
add_test(
  NAME double_measurement
  COMMAND ${CMAKE_COMMAND} -E
  echo <DartMeasurement type="numeric/double" name="my_custom_value">1.4847</DartMeasurement>)
add_test(
  NAME img_measurement
  COMMAND ${CMAKE_COMMAND} -E
  echo <DartMeasurementFile name="TestImage" type="image/png">]] ${IMAGE_DIR}/cmake-logo-16.png [[</DartMeasurementFile>)
add_test(
  NAME file_measurement
  COMMAND ${CMAKE_COMMAND} -E
  echo <DartMeasurementFile name="my_test_input_data" type="file">]] ${IMAGE_DIR}/cmake-logo-16.png [[</DartMeasurementFile>)
  ]])
  run_ctest(TestMeasurements)
endfunction()
run_measurements()

# Verify that test output can override the Completion Status.
function(run_completion_status)
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
add_test(
  NAME custom_details
  COMMAND ${CMAKE_COMMAND} -E
  echo test output\n<CTestDetails>CustomDetails</CTestDetails>\nmore output)
  ]])
  run_ctest(TestCompletionStatus)
endfunction()
run_completion_status()

# Verify that running ctest_test() multiple times with different label arguments
# doesn't break.
function(run_changing_labels)
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
add_test(NAME a COMMAND ${CMAKE_COMMAND} -E true)
set_property(TEST a PROPERTY LABELS a)
add_test(NAME b COMMAND ${CMAKE_COMMAND} -E true)
set_property(TEST b PROPERTY LABELS b)
  ]])
  run_ctest(TestChangingLabels)
endfunction()
run_changing_labels()

# Verify that test output can add additional labels
function(run_extra_labels)
  set(CASE_CMAKELISTS_SUFFIX_CODE [[
add_test(
  NAME custom_labels
  COMMAND ${CMAKE_COMMAND} -E
  echo before\n<CTestLabel>label2</CTestLabel>\n<CTestLabel>label1</CTestLabel>\n<CTestLabel>label3</CTestLabel>\n<CTestLabel>label2</CTestLabel>\nafter)
set_tests_properties(custom_labels PROPERTIES LABELS "label1")
  ]])
  run_ctest(TestExtraLabels)
endfunction()
run_extra_labels()
