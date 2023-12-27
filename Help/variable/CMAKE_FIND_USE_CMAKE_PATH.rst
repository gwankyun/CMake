CMAKE_FIND_USE_CMAKE_PATH
-------------------------

.. versionadded:: 3.16

控制以下命令的默认行为，以决定是否搜索由cmake特定缓存变量提供的路径：

* :command:`find_program`
* :command:`find_library`
* :command:`find_file`
* :command:`find_path`
* :command:`find_package`

This is useful in cross-compiling environments.

By default this variable is not set, which is equivalent to it having
a value of ``TRUE``.  Explicit options given to the above commands
take precedence over this variable.

See also the :variable:`CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH`,
:variable:`CMAKE_FIND_USE_CMAKE_SYSTEM_PATH`,
:variable:`CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH`,
:variable:`CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY`,
:variable:`CMAKE_FIND_USE_PACKAGE_REGISTRY`,
and :variable:`CMAKE_FIND_USE_PACKAGE_ROOT_PATH` variables.
