CMAKE_PROJECT_INCLUDE
---------------------

.. versionadded:: 3.15

一个CMake语言文件或模块，作为所有\ :command:`project`\ 命令调用的最后一步。这是为了在不\
修改源代码的情况下将自定义代码注入到项目构建中。有关在\ :command:`project`\ 调用期间可能\
包含的文件的更详细讨论，请参阅\ :ref:`Code Injection`。

See also the :variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE`,
:variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE_BEFORE`,
:variable:`CMAKE_PROJECT_INCLUDE_BEFORE`, and
:variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES` variables.
