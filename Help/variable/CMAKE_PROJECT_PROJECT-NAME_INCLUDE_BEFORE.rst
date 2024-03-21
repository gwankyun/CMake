CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE_BEFORE
-------------------------------------------

.. versionadded:: 3.17

一个CMake语言文件，作为任何指定\ ``<PROJECT-NAME>``\ 作为项目名称的\
:command:`project`\ 命令调用的第一步。这是为了在不修改源代码的情况下将自定义代码注入到项\
目构建中。有关在\ :command:`project`\ 调用期间可能包含的文件的更详细讨论，请参阅\
:ref:`代码注入 <Code Injection>`。

.. versionadded:: 3.29
  This variable can be a :ref:`semicolon-separated list <CMake Language Lists>`
  of CMake language files to be included sequentially. It can also now refer to
  module names to be found in :variable:`CMAKE_MODULE_PATH` or as a builtin
  CMake module.

See also the :variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE`,
:variable:`CMAKE_PROJECT_INCLUDE`, :variable:`CMAKE_PROJECT_INCLUDE_BEFORE`,
and :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES` variables.
