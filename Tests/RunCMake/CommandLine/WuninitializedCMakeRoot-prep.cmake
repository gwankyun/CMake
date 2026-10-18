# Place CMAKE_ROOT under the project source and run that nested cmake.
set(WuninitializedCMakeRoot_SAVED_CMAKE_COMMAND "${CMAKE_COMMAND}")
set(WuninitializedCMakeRoot_SAVED_PATH "$ENV{PATH}")

set(RunCMake_TEST_SOURCE_DIR "${RunCMake_BINARY_DIR}/WuninitializedCMakeRoot-src")
set(nested "${RunCMake_TEST_SOURCE_DIR}/nested")
set(cmake_root "${RunCMake_TEST_SOURCE_DIR}/cmake_root")

file(REMOVE_RECURSE "${RunCMake_TEST_SOURCE_DIR}")
file(MAKE_DIRECTORY "${RunCMake_TEST_SOURCE_DIR}" "${nested}/bin" "${nested}/CMakeFiles")

file(COPY "${RunCMake_SOURCE_DIR}/CMakeLists.txt"
          "${RunCMake_SOURCE_DIR}/WuninitializedCMakeRoot.cmake"
     DESTINATION "${RunCMake_TEST_SOURCE_DIR}")

file(CREATE_LINK "${CMAKE_ROOT}" "${cmake_root}" SYMBOLIC RESULT _link_result)
if(_link_result)
  file(COPY "${CMAKE_ROOT}/Modules" DESTINATION "${cmake_root}")
endif()
file(WRITE "${nested}/CMakeFiles/CMakeSourceDir.txt" "${cmake_root}\n")

# Use the same file name as CMAKE_COMMAND (script mode may leave
# CMAKE_EXECUTABLE_SUFFIX empty).
get_filename_component(_cmake_name "${CMAKE_COMMAND}" NAME)
set(_nested_cmake "${nested}/bin/${_cmake_name}")
file(CREATE_LINK "${CMAKE_COMMAND}" "${_nested_cmake}" COPY_ON_ERROR RESULT _link_result)
if(_link_result)
  message(FATAL_ERROR "Failed to link/copy cmake for WuninitializedCMakeRoot: ${_link_result}")
endif()

get_filename_component(_cmake_bin_dir "${CMAKE_COMMAND}" DIRECTORY)
if(CMAKE_HOST_WIN32)
  set(ENV{PATH} "${_cmake_bin_dir};$ENV{PATH}")
else()
  set(ENV{PATH} "${_cmake_bin_dir}:$ENV{PATH}")
endif()

set(CMAKE_COMMAND "${_nested_cmake}")
