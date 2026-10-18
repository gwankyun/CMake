include(${CMAKE_CURRENT_LIST_DIR}/json.cmake)

# After an interrupted `ctest`, exactly one ctest snippet should be present,
# marked with the interrupting signal, and the postCTest hook must have been
# skipped.
check_interrupted_snippet(ctest postCTest)

# The real-signal case (CTEST_INTERRUPT) records which tests ran in a marker
# directory.  The deterministic seam case runs no tests, so guard on the
# directory's existence.
set(ran_interrupt ${RunCMake_TEST_BINARY_DIR}/ran-interrupt)

if (EXISTS ${ran_interrupt})
  # Cancellation: the fast test finished but the pending slow tests must not all
  # have started, proving the scheduler stopped launching tests on interrupt.
  if (NOT EXISTS ${ran_interrupt}/ctestFast)
    add_error("ctestFast should have run before the interrupt, but did not")
  endif()
  file(GLOB slow_ran LIST_DIRECTORIES false ${ran_interrupt}/ctestSlow*)
  list(LENGTH slow_ran num_slow_ran)
  if (num_slow_ran GREATER_EQUAL 3)
    add_error("Expected some slow tests to remain pending on interrupt, "
      "but all ${num_slow_ran} ran: ${slow_ran}")
  endif()
endif()
