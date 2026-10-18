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

.. versionadded:: 4.5

  Include paths may use :manual:`generator expressions
  <cmake-generator-expressions(7)>`.  This is most useful with
  :prop_gbl:`multi-config generators <GENERATOR_IS_MULTI_CONFIG>`, where a
  ``$<CONFIG>``-parameterized path selects a different script per
  configuration.  On multi-config generators, an entry whose evaluated result
  varies by configuration is emitted under a per-configuration guard, so it is
  included only for the matching ``ctest -C <config>`` run.  A path whose result
  is the same for all configurations is included unconditionally.

  No build dependency is added for targets referenced in an include path.

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

Selecting a per-configuration script with a generator expression:

.. code-block:: cmake
  :caption: CMakeLists.txt

  file(GENERATE
    OUTPUT "props_$<CONFIG>.cmake"
    CONTENT "set_tests_properties(some.test PROPERTIES LABELS \"$<CONFIG>\")\n"
  )

  set_property(
    DIRECTORY
    APPEND
    PROPERTY TEST_INCLUDE_FILES
      "${CMAKE_CURRENT_BINARY_DIR}/props_$<CONFIG>.cmake"
  )
