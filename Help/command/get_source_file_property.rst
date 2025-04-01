get_source_file_property
------------------------

获取源文件的属性。

.. code-block:: cmake

  get_source_file_property(<variable> <file>
                           [DIRECTORY <dir> | TARGET_DIRECTORY <target>]
                           <property>)

从源文件中获取一个属性。该属性的值将存储在指定的\ ``<variable>``\ 中。如果\ ``<file>``\
不是源文件，或者未找到该源属性，则\ ``<variable>``\ 将被设置为\ ``NOTFOUND``。\
如果源属性被定义为\ ``INHERITED``\ 属性（请参阅\ :command:`define_property`\ ），则搜索\
将包括相关的父作用域，具体规则与\ :command:`define_property`\ 命令中描述的一致。

默认情况下，源文件的属性将从当前源目录的作用域中读取。

.. versionadded:: 3.18
  可以使用以下子选项之一来覆盖目录作用域：

  ``DIRECTORY <dir>``
    源文件属性将从\ ``<dir>``\ 目录的作用域中读取。CMake必须已经知晓该源目录，这可以通过\
    调用\ :command:`add_subdirectory`\ 来添加该目录，或者\ ``<dir>``\ 是顶层源目录。\
    相对路径将被视为相对于当前源目录的路径。

  ``TARGET_DIRECTORY <target>``
    源文件属性将从创建\ ``<target>``\ 所在的目录作用域中读取（因此\ ``<target>``\ 必须已经存在）。

使用\ :command:`set_source_files_properties`\ 来设置属性值。源文件属性通常控制文件的\
构建方式。其中一个始终存在的属性是\ :prop_sf:`LOCATION`。

.. note::

  源文件属性\ :prop_sf:`GENERATED`\ 可能全局可见。详情请参阅其文档。

另请参阅
^^^^^^^^

* :command:`define_property`
* 更通用的\ :command:`get_property`\ 命令
* :command:`set_source_files_properties`
