include(${CMAKE_CURRENT_LIST_DIR}/json.cmake)

# This checks a `ctest -F` resume of an interrupted test set.  The overall
# ctest snippet and the postCTest hook are exercised by the seam and
# interrupt-only cases; here the resuming run re-runs (and re-indexes) the
# instrumentation, so only the resume behavior is asserted.

set(ran_interrupt ${RunCMake_TEST_BINARY_DIR}/ran-interrupt)
set(ran_resume ${RunCMake_TEST_BINARY_DIR}/ran-resume)

if (NOT EXISTS ${ran_interrupt})
  add_error("Expected the interrupted run to record which tests ran")
elseif (NOT EXISTS ${ran_interrupt}/ctestFast)
  add_error("ctestFast should have finished before the interrupt, but did not")
endif()

if (NOT EXISTS ${ran_resume})
  add_error("Expected the `ctest -F` resume to record which tests ran")
else ()
  # Failover: `ctest -F` must skip the already-finished fast test (it was
  # checkpointed) and re-run the interrupted and pending slow tests (the
  # in-flight test killed by the interrupt was deliberately not checkpointed).
  if (EXISTS ${ran_resume}/ctestFast)
    add_error("ctestFast finished before the interrupt and should be skipped "
      "by `ctest -F`, but it ran again")
  endif()
  foreach (n 1 2 3)
    if (NOT EXISTS ${ran_resume}/ctestSlow${n})
      add_error("ctestSlow${n} was not finished before the interrupt and must "
        "run on `ctest -F` resume, but it did not")
    endif()
  endforeach()
endif()
