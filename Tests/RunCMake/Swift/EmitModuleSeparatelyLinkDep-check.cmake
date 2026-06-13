# The link edge for a Swift library must implicitly depend on the
# .swiftmodule so the emit-module edge runs even when no other target
# in the build depends on it.
if(RunCMake_GENERATOR_IS_MULTI_CONFIG)
  set(path "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/impl-Debug.ninja")
else()
  set(path "${RunCMake_TEST_BINARY_DIR}/build.ninja")
endif()
file(READ "${path}" build_ninja)

if(NOT build_ninja MATCHES "build [^\n]*(libL\\.a|L\\.lib)[^\n]*:.*\\|[^\n]*L\\.swiftmodule")
  string(APPEND RunCMake_TEST_FAILED
    "Link edge for L does not depend on L.swiftmodule.\n")
endif()
