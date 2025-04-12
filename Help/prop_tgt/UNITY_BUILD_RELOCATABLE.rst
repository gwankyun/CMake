UNITY_BUILD_RELOCATABLE
-----------------------

.. versionadded:: 4.0

默认情况下，当启用\ :prop_tgt:`UNITY_BUILD`\ 时生成的统一文件会使用绝对路径来引用原始源文件。\
这会导致统一文件根据源文件的位置产生不同的输出。

When this property is set to true, the ``#include`` lines inside the generated
unity source files will attempt to use relative paths to the original source
files if possible in order to standardize the output of the unity file.

The unity file's path to an original source file uses the following priority:

* a path relative to the generated unity file if the source file exists
  directly in :variable:`CMAKE_BINARY_DIR`, or in a subfolder under it.

* a path relative to :variable:`CMAKE_SOURCE_DIR` if the source file exists
  directly in :variable:`CMAKE_SOURCE_DIR`, or in a subfolder under it.

* an absolute path to the source file.

This target property *does not* guarantee a consistent unity file across
different environments as the final priority is an absolute path.

Example usage:

.. code-block:: cmake

  add_library(example_library
              source1.cxx
              source2.cxx
              source3.cxx)

  set_target_properties(example_library PROPERTIES
                        UNITY_BUILD True
                        UNITY_BUILD_RELOCATABLE TRUE)
