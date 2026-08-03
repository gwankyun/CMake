enable_language(CXX)
include(GoogleTest)

enable_testing()

include(xcode_sign_adhoc.cmake)

set(race_target_count 16)
set(race_targets)

foreach(i RANGE 1 ${race_target_count})
  set(t race_fake_gtest_${i})
  add_executable(${t} fake_gtest.cpp)
  xcode_sign_adhoc(${t})
  # Avoid timeouts on low-resource hardware at high parallelism.
  gtest_discover_tests(${t} DISCOVERY_MODE POST_BUILD DISCOVERY_TIMEOUT 30)
  list(APPEND race_targets ${t})
endforeach()

add_custom_target(check_discovery_json_files
  COMMAND ${CMAKE_COMMAND}
    -Dbinary_dir=${CMAKE_CURRENT_BINARY_DIR}
    -Dtarget_count=${race_target_count}
    -P ${CMAKE_CURRENT_LIST_DIR}/GoogleTest-discovery-post-build-race-check.cmake
  DEPENDS ${race_targets}
  VERBATIM
)
