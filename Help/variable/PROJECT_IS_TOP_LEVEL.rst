PROJECT_IS_TOP_LEVEL
--------------------

.. versionadded:: 3.21

一个布尔变量，指示当前或以上范围内最近调用的\ :command:`project`\ 命令是否在顶层\
``CMakeLists.txt``\ 文件中。

Some modules should only be included as part of the top level
``CMakeLists.txt`` file to not cause unintended side effects in the build
tree, and this variable can be used to conditionally execute such code. For
example, consider the :module:`CTest` module, which creates targets and
options:

.. code-block:: cmake

  project(MyProject)
  ...
  if(PROJECT_IS_TOP_LEVEL)
    include(CTest)
  endif()

The variable value will be true in:

* the top-level directory of the project
* the top-level directory of an external project added by
  :module:`ExternalProject`
* a directory added by :command:`add_subdirectory` that does not also contain
  a :command:`project` call
* a directory added by :command:`FetchContent_MakeAvailable`,
  if the fetched content does not contain a :command:`project` call

The variable value will be false in:

* a directory added by :command:`add_subdirectory` that also contains
  a :command:`project` call
* a directory added by :command:`FetchContent_MakeAvailable`,
  if the fetched content contains a :command:`project` call
