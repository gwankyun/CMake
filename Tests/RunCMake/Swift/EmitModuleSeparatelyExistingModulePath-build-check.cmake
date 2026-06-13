# When the target's flags already contain -emit-module-path, the emit-module
# edge should not append a second one that clobbers it.
# Match command lines that have two -emit-module-path flags on the same line.
string(
  REGEX MATCHALL
  "-emit-module-path [^\n]*-emit-module-path"
  duplicate_flags "${actual_stdout}")
if(duplicate_flags)
  string(APPEND RunCMake_TEST_FAILED
    "Found command with duplicate -emit-module-path flags.\n")
endif()
