file(READ "${RunCMake_TEST_BINARY_DIR}/generator-expression-generated.txt" content)

if(NOT content STREQUAL "value")
  set(RunCMake_TEST_FAILED "set_property(): Target property 'COMPILE_DEFINITIONS' set on ALIAS 'alias::lib' has wrong value on aliased target 'lib': '${content}' instead of 'value'.")
endif()
