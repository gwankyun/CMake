UNITY_BUILD_MODE
----------------

.. versionadded:: 3.18

CMake提供了不同的算法来选择哪些源被分组到一个\ *bucket*\ 中。选择由此属性决定，该属性具有\
以下可接受的值：

``BATCH``
  When in this mode CMake determines which files are grouped together.
  The :prop_tgt:`UNITY_BUILD_BATCH_SIZE` property controls the upper limit on
  how many sources can be combined per unity source file.

  Example usage:

  .. code-block:: cmake

    add_library(example_library
                source1.cxx
                source2.cxx
                source3.cxx
                source4.cxx)

    set_target_properties(example_library PROPERTIES
                          UNITY_BUILD_MODE BATCH
                          UNITY_BUILD_BATCH_SIZE 2
                          )

``GROUP``
  When in this mode each target explicitly specifies how to group
  source files. Each source file that has the same
  :prop_sf:`UNITY_GROUP` value will be grouped together. Any sources
  that don't have this property will be compiled individually. The
  :prop_tgt:`UNITY_BUILD_BATCH_SIZE` property is ignored when using
  this mode.

  Example usage:

  .. code-block:: cmake

    add_library(example_library
                source1.cxx
                source2.cxx
                source3.cxx
                source4.cxx)

    set_target_properties(example_library PROPERTIES
                          UNITY_BUILD_MODE GROUP
                          )

    set_source_files_properties(source1.cxx source2.cxx source3.cxx
                                PROPERTIES UNITY_GROUP "bucket1"
                                )
    set_source_files_properties(source4.cxx
                                PROPERTIES UNITY_GROUP "bucket2"
                                )

If no explicit ``UNITY_BUILD_MODE`` has been specified, CMake will
default to ``BATCH``.
