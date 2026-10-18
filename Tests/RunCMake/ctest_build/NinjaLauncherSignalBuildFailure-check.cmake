# A signal-killed build rule wrapped by ctest --launch must be recorded as a
# build error in Build.xml.
file(GLOB build_xml_file "${RunCMake_TEST_BINARY_DIR}/Testing/*/Build.xml")
if(NOT build_xml_file)
  set(RunCMake_TEST_FAILED "Build.xml not found")
  return()
endif()
file(READ "${build_xml_file}" build_xml)
if(NOT build_xml MATCHES [[<Failure type="Error">]] OR
   NOT build_xml MATCHES "Terminated abnormally")
  string(REPLACE "\n" "\n  " build_xml "  ${build_xml}")
  set(RunCMake_TEST_FAILED
    "Build.xml does not report the signal-killed rule as an abnormal-termination error:\n${build_xml}")
endif()
