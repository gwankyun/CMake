SUBDIRECTORIES
--------------

.. versionadded:: 3.7

此只读目录属性包含由\ :command:`add_subdirectory`\ 或\ :command:`subdirs`\ 命令处理\
的子目录的\ :ref:`分号分隔列表 <CMake Language Lists>`。每个条目都是源目录（包含\
``CMakeLists.txt``\ 文件）的绝对路径。这适合传递给\ :command:`get_property`\ 命令\
``DIRECTORY``\ 选项。

.. note::

  The :command:`subdirs` command does not process its arguments until
  after the calling directory is fully processed.  Therefore looking
  up this property in the current directory will not see them.
