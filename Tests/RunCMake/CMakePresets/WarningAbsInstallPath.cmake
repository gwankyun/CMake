cmake_diagnostic(GET CMD_INSTALL_ABSOLUTE_DESTINATION action)
if(NOT "${action}" STREQUAL WARN)
   message(SEND_ERROR
     "wrong action for diagnostic CMD_INSTALL_ABSOLUTE_DESTINATION"
     " (expected 'WARN', actual '${action}')")
endif()
