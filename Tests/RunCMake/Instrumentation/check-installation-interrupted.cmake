include(${CMAKE_CURRENT_LIST_DIR}/json.cmake)

# After an interrupted `cmake --install`, exactly one cmakeInstall snippet should
# be present, marked with the interrupting signal, and the postCMakeInstall hook
# must have been skipped.
check_interrupted_snippet(cmakeInstall postCMakeInstall)

# An interrupted install is incomplete, so it must not leave behind an install
# manifest that looks complete.
if (EXISTS ${RunCMake_TEST_BINARY_DIR}/install_manifest.txt)
  add_error("install_manifest.txt should be absent after an interrupted install")
endif()
