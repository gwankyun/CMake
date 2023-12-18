CMAKE_FIND_DEBUG_MODE
---------------------

.. versionadded:: 3.17

为以下命令打印额外的查找调用信息到标准错误：

* :command:`find_program`
* :command:`find_library`
* :command:`find_file`
* :command:`find_path`
* :command:`find_package`

Output is designed for human consumption and not for parsing.
Enabling this variable is equivalent to using :option:`cmake --debug-find`
with the added ability to enable debugging for a subset of find calls.

.. code-block:: cmake

  set(CMAKE_FIND_DEBUG_MODE TRUE)
  find_program(...)
  set(CMAKE_FIND_DEBUG_MODE FALSE)

Default is unset.
