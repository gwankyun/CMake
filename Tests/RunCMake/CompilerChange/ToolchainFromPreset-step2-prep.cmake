file(COPY
  "${RunCMake_SOURCE_DIR}/CMakeLists.txt"
  "${RunCMake_SOURCE_DIR}/ToolchainFromPreset-step2.cmake"
  DESTINATION "${RunCMake_TEST_SOURCE_DIR}"
)
set(CompilerChange_Toolchain "${RunCMake_BINARY_DIR}/bar.cmake")
configure_file(
  "${RunCMake_SOURCE_DIR}/CMakePresets.json.in"
  "${RunCMake_TEST_SOURCE_DIR}/CMakePresets.json"
  @ONLY
)
