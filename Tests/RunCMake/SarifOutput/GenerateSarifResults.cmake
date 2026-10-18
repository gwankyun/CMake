# Write some user messages to produce SARIF results
message(WARNING "Example warning message")

# The second warning should be logged, but the rule should not be duplicated
message(WARNING "A second example warning message")

# Status message should not be logged
message(STATUS "Example status message")

# Test diagnostic reporting
message(AUTHOR_WARNING "Example author warning message")

# Diagnostic results should include a level specific to each reported item
# Change it and issue another one
cmake_diagnostic(SET CMD_AUTHOR SEND_ERROR)
message(AUTHOR_WARNING "Another example author warning message")

# Define and call some functions to test stack reporting
function(a)
  message(WARNING "Warning from a nested function call")
endfunction()

function(b)
  a()
endfunction()

b()

# Include another file that generates a warning
include("${CMAKE_CURRENT_LIST_DIR}/GenerateSarifResults-Included.cmake")

# variable_watch and deferred calls add placeholders to the CMake backtrace.
# Placeholders on the stack are prone to accidental reporting as a stack frame
# or line number. Ensure location info is reported but the stack is not
# polluted with placeholders.

function(warn_callback variable access value file stack)
  message(WARNING "Warning from a variable_watch callback")
endfunction()

variable_watch(x warn_callback)
set(x "x_value")

# A result from a deferred call should report the location it was deferred from
# and the list file that finished processing and executed the deferred call.
cmake_language(DEFER CALL message SEND_ERROR "Encabulator: a deferred error")
