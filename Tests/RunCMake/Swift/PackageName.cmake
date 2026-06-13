cmake_policy(SET CMP0157 NEW)

enable_language(Swift)

add_library(L1 L.swift)
set_target_properties(L1 PROPERTIES
  Swift_PACKAGE_NAME "SwiftPackageTest"
)

add_library(L2 L.swift)
set_target_properties(L2 PROPERTIES
  Swift_PACKAGE_NAME ""
)
