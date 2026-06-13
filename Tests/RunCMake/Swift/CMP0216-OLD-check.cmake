if(RunCMake_GENERATOR MATCHES "Ninja")
  if(RunCMake_GENERATOR_IS_MULTI_CONFIG)
    set(path "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/impl-Debug.ninja")
  else()
    set(path "${RunCMake_TEST_BINARY_DIR}/build.ninja")
  endif()
  file(READ "${path}" build_ninja)
  if(_content MATCHES "-package-name")
    set(RunCMake_TEST_FAILED
      "Unexpected -package-name in generated Ninja build files when CMP0216 is OLD")
  endif()
elseif(RunCMake_GENERATOR MATCHES "Xcode")
  file(READ
    "${RunCMake_TEST_BINARY_DIR}/CMP0216-OLD.xcodeproj/project.pbxproj"
    pbxproj)
  if(pbxproj MATCHES "SWIFT_PACKAGE_NAME")
    set(RunCMake_TEST_FAILED
      "Unexpected SWIFT_PACKAGE_NAME in generated Xcode project when CMP0216 is OLD")
  endif()
endif()
