get_test_property
-----------------

获取测试的属性。

.. code-block:: cmake

  get_test_property(<test> <property> [DIRECTORY <dir>] <variable>)

从测试中获取一个属性。属性的值存储在指定的\ ``<variable>``\ 中。如果\ ``<test>``\ 没有\
定义，或者测试属性没有找到，\ ``<variable>``\ 将被设置为\ ``NOTFOUND``。如果测试属性被定\
义为一个\ ``INHERITED``\ 属性（参见\ :command:`define_property`\ ），那么搜索将包括相关\
的父作用域，正如\ :command:`define_property`\ 命令所描述的那样。

对于标准属性列表，可以输入\ :option:`cmake --help-property-list`。

.. versionadded:: 3.28
  目录范围可以用以下子选项覆盖：

  ``DIRECTORY <dir>``
    测试属性将从\ ``<dir>``\ 目录的作用域读取。CMake必须已经知道源目录，要么通过调用\
    :command:`add_subdirectory`\ 添加它，要么\ ``<dir>``\ 是顶层源目录。相对路径被视\
    为相对于当前源目录。\ ``<dir>``\ 可以引用二进制目录。

另请参阅
^^^^^^^^

* :command:`define_property`
* 更通用的\ :command:`get_property`\ 命令
