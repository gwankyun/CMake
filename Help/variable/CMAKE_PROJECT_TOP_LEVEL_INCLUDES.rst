CMAKE_PROJECT_TOP_LEVEL_INCLUDES
--------------------------------

.. versionadded:: 3.24

CMake语言文件\ :ref:`分号分隔列表 <CMake Language Lists>`，作为第一个\
:command:`project`\ 调用的一部分。在读取工具链文件（綑果指定了一个）和平台变量设置之后，\
但在启用任何语言之前，将立即包含这些文件。因此，可能不会设置特定于语言的变量，包括\
:variable:`CMAKE_<LANG>_COMPILER`\ 之类的变量。有关在\ :command:`project`\ 调用期间\
可能包含的文件的更详细讨论，请参阅\ :ref:`代码注入 <Code Injection>`。

This variable is intended for specifying files that perform one-time setup
for the build. It provides an injection point for things like configuring
package managers, adding logic the user shares between projects (e.g. defining
their own custom build types), and so on. It is primarily for users to add
things specific to their environment, but not for specifying the toolchain
details (use :variable:`CMAKE_TOOLCHAIN_FILE` for that).

By default, this variable is empty.  It is intended to be set by the user.

See also the :variable:`CMAKE_PROJECT_INCLUDE`,
:variable:`CMAKE_PROJECT_INCLUDE_BEFORE`,
:variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE`, and
:variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE_BEFORE` variables.
