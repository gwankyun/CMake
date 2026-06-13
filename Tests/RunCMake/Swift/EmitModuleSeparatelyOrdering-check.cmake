# The Swift object compile edge must order-only depend on the .swiftmodule
# produced by the separate emit-module edge.  Both edges share the same
# -output-file-map; running them concurrently corrupts the module-level
# swift-dependencies file referenced by that map.
if(RunCMake_GENERATOR_IS_MULTI_CONFIG)
  set(path "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/impl-Debug.ninja")
else()
  set(path "${RunCMake_TEST_BINARY_DIR}/build.ninja")
endif()
file(READ "${path}" build_ninja)

# Find the object compile edge for L and confirm L.swiftmodule appears
# after the order-only `||` separator.  The edge ends at the next `build `
# at the start of a line (or end of file).
string(REGEX MATCH
  "build [^\n]*L\\.swift\\.o[^\n]*:[^\n]*(\n [^\n]+)*"
  obj_edge "${build_ninja}")

if(NOT obj_edge)
  string(APPEND RunCMake_TEST_FAILED
    "Could not find object compile edge for L.swift.\n")
  return()
endif()

if(NOT obj_edge MATCHES "\\|\\|[^\n]*L\\.swiftmodule")
  string(APPEND RunCMake_TEST_FAILED
    "Object compile edge for L.swift is missing an order-only dependency on L.swiftmodule.\nEdge:\n${obj_edge}\n")
endif()
