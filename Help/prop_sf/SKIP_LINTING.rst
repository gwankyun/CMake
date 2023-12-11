SKIP_LINTING
------------

.. versionadded:: 3.27

此属性允许你从检查进程中排除特定的源文件。检查过程包括在源文件上运行诸如\
:prop_tgt:`<LANG>_CPPLINT`、\ :prop_tgt:`<LANG>_CLANG_TIDY`、\
:prop_tgt:`<LANG>_CPPCHECK`\ 和\ :prop_tgt:`<LANG>_INCLUDE_WHAT_YOU_USE`\ 等工具，\
以及编译头文件作为\ :prop_tgt:`VERIFY_INTERFACE_HEADER_SETS`\ 的一部分。通过在源文件\
上设置\ ``SKIP_LINTING``，将不会为该特定文件执行上述检测工具。

Example
^^^^^^^

Consider a C++ project that includes multiple source files,
such as ``main.cpp``, ``things.cpp``, and ``generatedBindings.cpp``.
In this example, you want to exclude the ``generatedBindings.cpp``
file from the linting process. To achieve this, you can utilize
the ``SKIP_LINTING`` property with the :command:`set_source_files_properties`
command as shown below:

.. code-block:: cmake

  add_executable(MyApp main.cpp things.cpp generatedBindings.cpp)

  set_source_files_properties(generatedBindings.cpp PROPERTIES
      SKIP_LINTING ON
  )

In the provided code snippet, the ``SKIP_LINTING`` property is set to true
for the ``generatedBindings.cpp`` source file. As a result, when the linting
tools specified by :prop_tgt:`<LANG>_CPPLINT`, :prop_tgt:`<LANG>_CLANG_TIDY`,
:prop_tgt:`<LANG>_CPPCHECK`, or :prop_tgt:`<LANG>_INCLUDE_WHAT_YOU_USE`
are executed, they will skip analyzing the ``generatedBindings.cpp`` file.

By using the ``SKIP_LINTING`` property, you can selectively exclude specific
source files from the linting process. This allows you to focus the
linting tools on the relevant parts of your project, enhancing the efficiency
and effectiveness of the linting workflow.
