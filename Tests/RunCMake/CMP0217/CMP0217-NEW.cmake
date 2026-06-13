
cmake_policy(SET CMP0217 NEW)

macro(FOO)
endmacro()

get_property(macros DIRECTORY PROPERTY MACROS)
if (macros)
  set(RunCMake_TEST_FAILED "unexpected content for MACROS directory property.")
endif()
