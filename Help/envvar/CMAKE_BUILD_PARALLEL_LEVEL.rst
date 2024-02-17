CMAKE_BUILD_PARALLEL_LEVEL
--------------------------

.. versionadded:: 3.12

.. include:: ENV_VAR.txt

指定使用\ ``cmake --build``\ 命令行\ :ref:`构建工具模式 <Build Tool Mode>`\ 进行构建\
时要使用的最大并发进程数。
For example, if ``CMAKE_BUILD_PARALLEL_LEVEL`` is set to 8, the
underlying build tool will execute up to 8 jobs concurrently as if
``cmake --build`` were invoked with the
:option:`--parallel 8 <cmake--build --parallel>` option.

If this variable is defined empty the native build tool's default number is
used.
