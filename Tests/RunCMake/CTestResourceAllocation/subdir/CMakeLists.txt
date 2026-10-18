add_test(NAME RealTest COMMAND "${CMAKE_COMMAND}" -E true)
add_test(NAME GenerateSpecFile COMMAND "${CMAKE_COMMAND}" -E copy "${CMAKE_SOURCE_DIR}/dynamic-resspec.json" "${CMAKE_CURRENT_BINARY_DIR}")
set_tests_properties(GenerateSpecFile PROPERTIES
  GENERATED_RESOURCE_SPEC_FILE "subdir/dynamic-resspec.json"
  FIXTURES_SETUP "ResourceSpec"
  )
set_tests_properties(RealTest PROPERTIES
  FIXTURES_REQUIRED "ResourceSpec"
  RESOURCE_GROUPS "widgets:1"
  )
