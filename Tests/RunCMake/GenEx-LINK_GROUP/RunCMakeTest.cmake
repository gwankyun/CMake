include(RunCMake)

run_cmake(add_custom_target)
run_cmake(add_custom_command)
run_cmake(add_link_options)
run_cmake(link_directories)
run_cmake(target_link_options)
run_cmake(target_link_directories)
run_cmake(no-arguments)
run_cmake(empty-arguments)
run_cmake(forbidden-arguments)
run_cmake(nested-incompatible-genex)
run_cmake(invalid-feature)
run_cmake(multiple-definitions)
run_cmake(bad-feature1)
run_cmake(bad-feature2)
run_cmake(bad-feature3)
run_cmake(bad-feature4)
run_cmake(bad-feature5)
run_cmake(feature-not-supported)
run_cmake(library-ignored)
run_cmake(compatible-features1)
run_cmake(compatible-features2)
run_cmake(compatible-features3)
run_cmake(incompatible-features1)
run_cmake(nested-incompatible-features1)
run_cmake(nested-incompatible-features2)
run_cmake(circular-dependencies1)
run_cmake(circular-dependencies2)
run_cmake(only-targets)

# usage of LINK_LIBRARY with LINK_GROUP
run_cmake(incompatible-library-features1)
run_cmake(incompatible-library-features2)
run_cmake(override-library-features1)
run_cmake(override-library-features2)
