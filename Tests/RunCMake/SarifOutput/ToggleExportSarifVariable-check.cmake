include("${CMAKE_CURRENT_LIST_DIR}/check-sarif.cmake")

# The result issued before CMAKE_EXPORT_SARIF was enabled should still be
# captured in the SARIF output
check_sarif_output("${RunCMake_TEST_BINARY_DIR}/.cmake/sarif/cmake.sarif"
  "${CMAKE_CURRENT_LIST_DIR}/ToggleExportSarifVariable-expected.sarif")
