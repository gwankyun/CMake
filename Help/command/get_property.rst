get_property
------------

获取属性。

.. code-block:: cmake

  get_property(<variable>
               <GLOBAL                                                  |
                DIRECTORY [<dir>]                                       |
                TARGET    <target>                                      |
                FILE_SET  <file_set> TARGET <target>                    |
                SOURCE    <source>
                          [DIRECTORY <dir> | TARGET_DIRECTORY <target>] |
                INSTALL   <file>                                        |
                TEST      <test>
                          [DIRECTORY <dir>]                             |
                CACHE     <entry>                                       |
                VARIABLE>
               PROPERTY <name>
               [SET | DEFINED | BRIEF_DOCS | FULL_DOCS])

从某个作用域中的一个对象获取一个属性。

第一个参数指定用于存储结果的变量。\
第二个参数决定从哪个作用域获取属性。\
它必须是以下之一：

``GLOBAL``
  作用域是唯一的，且不接受名称参数。

``DIRECTORY``
  作用域默认是当前目录，但也可以通过完整路径或相对路径\ ``<dir>``\ 指定另一个已由CMake处理过的目录。\
  相对路径会被视为相对于当前源目录。另请参阅\ :command:`get_directory_property`\ 命令。

  .. versionadded:: 3.19
    ``<dir>``\ 可以引用一个二进制目录。

``TARGET``
  作用域必须指定一个已存在的目标。\
  另请参阅\ :command:`get_target_property`\ 命令。

``FILE_SET``
  .. versionadded:: 4.3

  Scope must name one existing file set.

  The following option is required:

  ``TARGET <target>``
    The target to which the file set is attached.

``SOURCE``
  作用域必须指定一个源文件。默认情况下，源文件的属性将从当前源目录的作用域中读取。

  .. versionadded:: 3.18
    目录作用域可以通过以下子选项之一进行覆盖：

    ``DIRECTORY <dir>``
      源文件属性将从\ ``<dir>``\ 目录的作用域中读取。CMake必须已经知晓该目录，这可以通过调用\
      :command:`add_subdirectory`\ 命令添加该目录，或者\ ``<dir>``\ 为顶级目录来实现。\
      相对路径会被视为相对于当前源目录。

      .. versionadded:: 3.19
        ``<dir>``\ 可以引用一个二进制目录。

    ``TARGET_DIRECTORY <target>``
      源文件属性将从创建\ ``<target>``\ 所在目录的作用域中读取（因此\ ``<target>``\ 必须\
      已经存在）。

  另请参阅\ :command:`get_source_file_property`\ 命令。

``INSTALL``
  .. versionadded:: 3.1

  作用域必须指定一个已安装文件的路径。

``TEST``
  作用域必须指定一个已存在的测试。\
  另请参阅\ :command:`get_test_property`\ 命令。

  .. versionadded:: 3.28
    目录作用域可以通过以下子选项进行覆盖：

    ``DIRECTORY <dir>``
      测试属性将从\ ``<dir>``\ 目录的作用域中读取。CMake必须已经知晓该目录，这可以通过调用\
      :command:`add_subdirectory`\ 命令添加该目录，或者\ ``<dir>``\ 为顶级目录来实现。\
      相对路径会被视为相对于当前源目录。\ ``<dir>``\ 可以引用一个二进制目录。

``CACHE``
  作用域必须指定一个缓存项。

``VARIABLE``
  作用域是唯一的，且不接受名称参数。

必需的\ ``PROPERTY``\ 选项后面需紧接着要获取的属性名称。如果该属性未设置，返回时指定的\
``<variable>``\ 将在调用作用域中被取消设置。不过，某些属性如果被定义为可从父作用域继承，\
则会遵循继承规则（详见\ :command:`define_property`\ 命令）。

如果指定了\ ``SET``\ 选项，变量将被设置为一个布尔值，用于指示该属性是否已被设置。如果指定了\
``DEFINED``\ 选项，变量将被设置为一个布尔值，用于指示该属性是否已被定义，例如通过\
:command:`define_property`\ 命令进行定义。

如果指定了\ ``BRIEF_DOCS``\ 或\ ``FULL_DOCS``\ 选项，变量将被设置为一个字符串，其中包含\
所请求属性的文档。如果请求的是一个未定义属性的文档，则返回\ ``NOTFOUND``。

.. note::

  源文件属性\ :prop_sf:`GENERATED`\ 可能是全局可见的。\
  有关详细信息，请参阅其文档。

另请参阅
^^^^^^^^

* :command:`define_property`
* :command:`set_property`
