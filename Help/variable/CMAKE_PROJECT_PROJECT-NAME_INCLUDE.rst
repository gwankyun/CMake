CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE
------------------------------------

一个CMake语言文件，作为指定\ ``<PROJECT-NAME>``\ 作为项目名的\ :command:`project`\
命令调用的最后一步。这是为了在不修改源代码的情况下将自定义代码注入到项目构建中。有关在\
:command:`project`\ 调用期间可能包含的文件的更详细讨论，请参阅\
:ref:`代码注入 <Code Injection>`。

.. versionadded:: 3.29
  This variable can be a :ref:`semicolon-separated list <CMake Language Lists>`
  of CMake language files to be included sequentially. It can also now refer to
  module names to be found in :variable:`CMAKE_MODULE_PATH` or builtin to CMake.

See also the :variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE_BEFORE`,
:variable:`CMAKE_PROJECT_INCLUDE`, :variable:`CMAKE_PROJECT_INCLUDE_BEFORE`,
and :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES` variables.
