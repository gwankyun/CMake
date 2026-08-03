if(RunCMake_GENERATOR STREQUAL "Ninja")
  set(rules_ninja "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/rules.ninja")
  set(build_ninja "${RunCMake_TEST_BINARY_DIR}/build.ninja")

  file(READ "${rules_ninja}" ninja_content)
  file(READ "${build_ninja}" build_ninja_content)

  if(NOT ninja_content MATCHES "command = \"[^\"]*ctest(\.exe)?\" --launch")
    set(RunCMake_TEST_FAILED
      "Expected compile command to use ctest --launch: ${ninja_content}"
    )
    return()
  endif()

  if(NOT build_ninja_content MATCHES "LAUNCHER = [^\n]*USED_LAUNCHER=1")
    set(RunCMake_TEST_FAILED
      "Expected compile command to include the compiler launcher"
    )
    return()
  endif()
endif()
