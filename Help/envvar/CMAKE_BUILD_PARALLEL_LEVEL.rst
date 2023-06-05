CMAKE_BUILD_PARALLEL_LEVEL
--------------------------

.. versionadded:: 3.12

.. include:: ENV_VAR.txt

指定使用\ ``cmake --build``\ 命令行\ :ref:`构建工具模式 <Build Tool Mode>`\ 进行构建\
时要使用的最大并发进程数。

If this variable is defined empty the native build tool's default number is
used.
