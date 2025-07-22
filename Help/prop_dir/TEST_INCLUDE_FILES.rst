TEST_INCLUDE_FILES
------------------

.. versionadded:: 3.10

此目录属性指定了一个CMake脚本列表，当在该目录下运行\ ``ctest``\ 时，这些脚本将被\
包含并执行。使用绝对路径以避免歧义。脚本文件将按指定顺序包含。

``TEST_INCLUDE_FILES`` scripts are processed when running ``ctest``, not during
the ``cmake`` configuration phase.  These scripts should be written as if they
were CTest dashboard scripts.  It is common to generate such scripts dynamically
since many variables and commands available during configuration are not
accessible at test phase.

Examples
^^^^^^^^

Setting this directory property to append one or more CMake scripts:

.. code-block:: cmake
  :caption: CMakeLists.txt

  configure_file(script.cmake.in script.cmake)

  set_property(
    DIRECTORY
    APPEND
    PROPERTY TEST_INCLUDE_FILES
      ${CMAKE_CURRENT_BINARY_DIR}/script.cmake
      ${CMAKE_CURRENT_SOURCE_DIR}/foo.cmake
      ${dir}/bar.cmake
  )

.. code-block:: cmake
  :caption: script.cmake.in

  execute_process(
    COMMAND "@CMAKE_COMMAND@" -E echo "script.cmake executed during CTest"
  )
