
cmake_policy(SET CMP0217 OLD)

macro(FOO)
endmacro()

get_property(macros DIRECTORY PROPERTY MACROS)
if (NOT "FOO" IN_LIST macros)
  set(RunCMake_TEST_FAILED "unexpected content for MACROS directory property.")
endif()
