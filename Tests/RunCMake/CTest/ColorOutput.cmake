include(CTest)

add_test(NAME OutputLogNoEscape-Pass
  COMMAND ${CMAKE_COMMAND} -E true)

add_test(NAME OutputLogNoEscape-Fail
  COMMAND ${CMAKE_COMMAND} -E false)
