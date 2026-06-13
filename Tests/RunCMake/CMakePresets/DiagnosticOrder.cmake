cmake_diagnostic(GET CMD_DEPRECATED action)
if(NOT "${action}" STREQUAL IGNORE)
   message(SEND_ERROR
     "wrong action for diagnostic CMD_DEPRECATED"
     " (expected 'IGNORE', actual '${action}')")
endif()
