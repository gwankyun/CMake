enable_language(CXX)
include(GoogleTest)

enable_testing()

include(xcode_sign_adhoc.cmake)

add_executable(fake_gtest fake_gtest.cpp)
xcode_sign_adhoc(fake_gtest)

gtest_discover_tests(fake_gtest
  DISCOVERY_MODE POST_BUILD
  TEST_PREFIX DUPLICATE:
  PROPERTIES LABELS DUPLICATE
)
gtest_discover_tests(fake_gtest
  DISCOVERY_MODE POST_BUILD
  TEST_PREFIX DUPLICATE:
  PROPERTIES LABELS DUPLICATE
)
