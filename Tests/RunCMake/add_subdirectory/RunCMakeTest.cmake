include(RunCMake)

run_cmake(DoesNotExist)
run_cmake(Missing)
run_cmake(Function)
set(RunCMake_TEST_OPTIONS -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER})
run_cmake(System)
unset(RunCMake_TEST_OPTIONS)

macro(run_cmake_install case)
  set(RunCMake_TEST_BINARY_DIR ${RunCMake_BINARY_DIR}/${case}-build)
  set(RunCMake_TEST_NO_CLEAN 1)
  set(RunCMake_TEST_OPTIONS ${ARGN})

  run_cmake(${case})
  run_cmake_command(${case}-install ${CMAKE_COMMAND} -P cmake_install.cmake)
  run_cmake_command(${case}-install-component ${CMAKE_COMMAND} -DCOMPONENT=Unspecified -P cmake_install.cmake)

  unset(RunCMake_TEST_BINARY_DIR)
  unset(RunCMake_TEST_NO_CLEAN)
  unset(RunCMake_TEST_OPTIONS)
endmacro()

run_cmake_install(CMP0082-WARN)
run_cmake_install(CMP0082-WARN-Nested)
run_cmake_install(CMP0082-WARN-NestedSub)
run_cmake_install(CMP0082-WARN-None)
run_cmake_install(CMP0082-WARN-NoTopInstall)
run_cmake_install(CMP0082-OLD -DCMP0082_VALUE=OLD)
run_cmake_install(CMP0082-NEW -DCMP0082_VALUE=NEW)

set(RunCMake_TEST_BINARY_DIR ${RunCMake_BINARY_DIR}/ExcludeFromAll-build)
if(NOT RunCMake_GENERATOR_IS_MULTI_CONFIG)
  set(RunCMake_TEST_OPTIONS -DCMAKE_BUILD_TYPE=Debug)
endif()
run_cmake(ExcludeFromAll)
set(RunCMake_TEST_NO_CLEAN 1)
set(RunCMake-check-file ExcludeFromAll/check.cmake)
run_cmake_command(ExcludeFromAll-build ${CMAKE_COMMAND} --build . --config Debug)
if(RunCMake_GENERATOR STREQUAL "Ninja")
  if(WIN32)
    set(slash [[\]])
  else()
    set(slash [[/]])
  endif()
  set(RunCMake-check-file ExcludeFromAll/check-sub.cmake)
  run_cmake_command(ExcludeFromAll-build-sub ${CMAKE_COMMAND} --build . --target "ExcludeFromAll${slash}all")
elseif(RunCMake_GENERATOR MATCHES "Make")
  set(RunCMake-check-file ExcludeFromAll/check-sub.cmake)
  set(RunCMake_TEST_COMMAND_WORKING_DIRECTORY ${RunCMake_BINARY_DIR}/ExcludeFromAll-build/ExcludeFromAll)
  run_cmake_command(ExcludeFromAll-build-sub "${RunCMake_MAKE_PROGRAM}")
elseif(RunCMake_GENERATOR MATCHES "^Visual Studio [1-9][0-9]")
  set(RunCMake-check-file ExcludeFromAll/check-sub.cmake)
  run_cmake_command(ExcludeFromAll-build-sub ${CMAKE_COMMAND} --build ExcludeFromAll --config Debug)
elseif(RunCMake_GENERATOR STREQUAL "Xcode")
  set(RunCMake-check-file ExcludeFromAll/check-sub.cmake)
  set(RunCMake_TEST_COMMAND_WORKING_DIRECTORY ${RunCMake_BINARY_DIR}/ExcludeFromAll-build/ExcludeFromAll)
  run_cmake_command(ExcludeFromAll-build-sub xcodebuild -configuration Debug)
endif()
unset(RunCMake-check-file)
unset(RunCMake_TEST_NO_CLEAN)
unset(RunCMake_TEST_OPTIONS)
unset(RunCMake_TEST_BINARY_DIR)
