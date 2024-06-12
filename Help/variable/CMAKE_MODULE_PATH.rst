CMAKE_MODULE_PATH
-----------------

目录的\ :ref:`分号分隔列表 <CMake Language Lists>`，使用正斜杠表示，指定在检查CMake附\
带的默认模块之前由\ :command:`include`\ 或\ :command:`find_package`\ 命令加载的CMake\
模块的搜索路径。默认为空。它是由项目设定的。

It's fairly common for a project to have a directory containing various
``*.cmake`` files to assist in development. Adding the directory to the
:variable:`CMAKE_MODULE_PATH` simplifies loading them. For example, a
project's top-level ``CMakeLists.txt`` file may contain:

.. code-block:: cmake

  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

  include(Foo) # Loads ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Foo.cmake

  find_package(Bar) # Loads ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindBar.cmake
