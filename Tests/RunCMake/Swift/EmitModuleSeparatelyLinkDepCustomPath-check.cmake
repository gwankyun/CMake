# Same as EmitModuleSeparatelyLinkDep but with a custom module directory.
# The link edge must depend on the actual emit-module output path, not a
# default that doesn't match the target's configuration.
if(RunCMake_GENERATOR_IS_MULTI_CONFIG)
  set(path "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/impl-Debug.ninja")
else()
  set(path "${RunCMake_TEST_BINARY_DIR}/build.ninja")
endif()
file(READ "${path}" build_ninja)

if(NOT build_ninja MATCHES "build [^\n]*(libL\\.a|L\\.lib)[^\n]*:.*\\|[^\n]*custom(/|\\\\)[^\n]*L\\.swiftmodule")
  string(APPEND RunCMake_TEST_FAILED
    "Link edge for L does not depend on custom/.../L.swiftmodule.\n")
endif()
