CMAKE_FIND_DEBUG_MODE_NO_IMPLICIT_CONFIGURE_LOG
-----------------------------------------------

.. versionadded:: 4.1

当以下命令遇到查找结果在找到和未找到状态间转换，或者首次确定查找结果时，\
将会记录配置日志事件：

* :command:`find_program`
* :command:`find_library`
* :command:`find_file`
* :command:`find_path`
* :command:`find_package`

The ``CMAKE_FIND_DEBUG_MODE_NO_IMPLICIT_CONFIGURE_LOG`` boolean variable
suppresses these implicit events from the configure log when set to a true
value.

.. code-block:: cmake

  set(CMAKE_FIND_DEBUG_MODE_NO_IMPLICIT_CONFIGURE_LOG TRUE)
  find_program(...)
  set(CMAKE_FIND_DEBUG_MODE_NO_IMPLICIT_CONFIGURE_LOG FALSE)

Default is unset.
