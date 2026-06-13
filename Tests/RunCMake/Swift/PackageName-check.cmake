if(RunCMake_GENERATOR MATCHES "Ninja")
  if(RunCMake_GENERATOR_IS_MULTI_CONFIG)
    set(path "${RunCMake_TEST_BINARY_DIR}/CMakeFiles/impl-Debug.ninja")
  else()
    set(path "${RunCMake_TEST_BINARY_DIR}/build.ninja")
  endif()
  file(READ "${path}" build_ninja)

  if(NOT build_ninja MATCHES "Swift_COMPILER__L1[^\n]*(\n  [^\n]+)*\n  FLAGS = [^\n]*-package-name SwiftPackageTest")
    string(APPEND RunCMake_TEST_FAILED
      "Expected L1 compile FLAGS to contain -package-name SwiftPackageTest\n")
  endif()

  if(build_ninja MATCHES "Swift_COMPILER__L2[^\n]*(\n  [^\n]+)*\n  FLAGS = [^\n]*-package-name")
    string(APPEND RunCMake_TEST_FAILED
      "L2 compile FLAGS should not contain -package-name\n")
  endif()

elseif(RunCMake_GENERATOR MATCHES "Xcode")
  file(READ
    "${RunCMake_TEST_BINARY_DIR}/PackageName.xcodeproj/project.pbxproj"
    pbxproj)
  if(NOT pbxproj MATCHES "SWIFT_PACKAGE_NAME = SwiftPackageTest")
    string(APPEND RunCMake_TEST_FAILED
      "Expected SWIFT_PACKAGE_NAME = SwiftPackageTest in Xcode project for L1\n")
  endif()
endif()
