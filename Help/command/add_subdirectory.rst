add_subdirectory
----------------

向构建添加一个子目录。

.. code-block:: cmake

  add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL] [SYSTEM])

在构建中添加一个子目录。\ ``source_dir``\ 指定了源文件\ ``CMakeLists.txt``\ 和代码文件\
所在的目录。如果它是一个相对路径，它将相对于当前目录进行计算（典型用法），但它也可以是一个绝\
对路径。\ ``binary_dir``\ 指定了放置输出文件的目录。如果它是一个相对路径，它将相对于当前\
输出目录进行计算，但它也可以是一个绝对路径。如果没有指定\ ``binary_dir``\ ，则在展开任何\
相对路径之前使用\ ``source_dir``\ 的值（典型用法）。CMake会立即处理指定源目录下的\
``CMakeLists.txt``\ 文件，然后再处理当前输入文件。

If the ``EXCLUDE_FROM_ALL`` argument is provided then the
:prop_dir:`EXCLUDE_FROM_ALL` property will be set on the added directory.
This will exclude the directory from a default build. See the directory
property :prop_dir:`EXCLUDE_FROM_ALL` for full details.

.. versionadded:: 3.25
  如果提供了\ ``SYSTEM``\ 参数，子目录的\ :prop_dir:`SYSTEM`\ 目录属性将被设置为true。\
  此属性用于初始化在该子目录中创建的每个未导入目标的\ :prop_tgt:`SYSTEM`\ 属性。
