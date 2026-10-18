include_guard()

# Read the JSON `filename` into `outvar`.
function(read_json filename outvar)
  file(READ "${filename}" ${outvar})
  return(PROPAGATE ${outvar})
endfunction()

# Utility for error messages.
function(add_error error)
  string(APPEND RunCMake_TEST_FAILED " ${error}\n")
  string(APPEND ERROR_MESSAGE " ${error}\n")
  return(PROPAGATE RunCMake_TEST_FAILED ERROR_MESSAGE)
endfunction()

# Utility for JSON-specific error messages.
function(json_error file error)
  add_error("Error in JSON file ${file}:\n${error}")
  return(PROPAGATE RunCMake_TEST_FAILED ERROR_MESSAGE)
endfunction()

# Check if the JSON string `json` has `key` when it's not
# UNEXPECTED. If so, return it in `key`.
function(json_has_key file json key)
  cmake_parse_arguments(ARG "UNEXPECTED" "" "" ${ARGN})
  unset(missingKey)
  string(JSON ${key} ERROR_VARIABLE missingKey GET "${json}" ${key})
  if (NOT ARG_UNEXPECTED AND missingKey)
    json_error("${file}" "Missing key \'${key}\':\n${json}")
  elseif (ARG_UNEXPECTED AND NOT missingKey)
    json_error("${file}" "\nUnexpected key \'${key}\':\n${json}")
  endif()
  return(PROPAGATE RunCMake_TEST_FAILED ERROR_MESSAGE ${key})
endfunction()

# Check if the JSON string `json` does not have `key`.
function(json_missing_key file json key)
  string(JSON data ERROR_VARIABLE missingKey GET "${json}" ${key})
  if (NOT missingKey)
    json_error("${file}" "Has unexpected ${key}.")
  endif()
  return(PROPAGATE RunCMake_TEST_FAILED ERROR_MESSAGE)
endfunction()

# Check if the JSON string `json` has `key` and its value matches `expected`.
# If successful, return its value in `key`.
function(json_assert_key file json key expected)
  string(JSON data ERROR_VARIABLE missingKey GET "${json}" ${key})
  if (missingKey)
    json_error("${file}" "Missing ${key}.")
  endif()
  if (NOT ${data} MATCHES ${expected})
    json_error(
      "${file}"
      "Unexpected data in custom content file:\nGot ${data}, Expected ${expected}."
    )
  endif()
  set(${key} ${data} PARENT_SCOPE)
  return(PROPAGATE RunCMake_TEST_FAILED ERROR_MESSAGE)
endfunction()

# Check if the two given JSON files are equal.
function(json_equals expected_file actual_file)
  read_json("${expected_file}" expected_contents)
  read_json("${actual_file}" actual_contents)
  string(JSON equal EQUAL ${expected_contents} ${actual_contents})
  if (NOT equal)
    add_error(
      "JSON ${expected_file} does not equal ${actual_file}."
    )
  endif()
  return(PROPAGATE RunCMake_TEST_FAILED ERROR_MESSAGE)
endfunction()

# Verify the aftermath of an interrupted top-level command whose overall
# instrumentation snippet has role `role` and whose post-command hook is `hook`.
# Exactly one such snippet must be present and marked with the interrupting
# signal (any snippet from an earlier uninterrupted warm-up run was collated and
# removed by its hook).  The hook must have been skipped entirely, so its
# callback (hook.cmake writes a `${hook}.hook` marker whenever it runs, and any
# earlier copy was removed before the interrupted run) must not have run.
function(check_interrupted_snippet role hook)
  file(GLOB snippets LIST_DIRECTORIES false ${v1}/data/${role}-*.json)
  list(LENGTH snippets num)
  if (NOT num EQUAL 1)
    add_error("Expected exactly one ${role} snippet, found ${num}: ${snippets}")
  else()
    read_json("${snippets}" contents)
    string(JSON interruptSignal ERROR_VARIABLE noSignal GET "${contents}" interruptSignal)
    if (noSignal OR NOT interruptSignal MATCHES "^[1-9][0-9]*$")
      add_error("${role} snippet is not marked interrupted:\n${contents}")
    endif()
  endif()

  if (EXISTS ${v1}/${hook}.hook)
    add_error("${hook} hook should be skipped on interrupt, but it ran")
  endif()

  return(PROPAGATE RunCMake_TEST_FAILED ERROR_MESSAGE)
endfunction()
