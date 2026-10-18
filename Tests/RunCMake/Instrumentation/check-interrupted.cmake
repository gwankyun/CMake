include(${CMAKE_CURRENT_LIST_DIR}/json.cmake)

# After an interrupted `cmake --build`, exactly one cmakeBuild snippet should be
# present, marked with the interrupting signal, and the postCMakeBuild hook must
# have been skipped.
check_interrupted_snippet(cmakeBuild postCMakeBuild)
