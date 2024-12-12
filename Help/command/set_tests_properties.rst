set_tests_properties
--------------------

设置测试的属性。

.. code-block:: cmake

  set_tests_properties(<tests>...
                       [DIRECTORY <dir>]
                       PROPERTIES <prop1> <value1>
                       [<prop2> <value2>]...)

设置测试的属性。如果没有找到测试，CMake将报告一个错误。

可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 为\
:command:`add_test(NAME)`\ 签名创建的测试指定测试属性值。

.. versionadded:: 3.28
  在其他目录范围中可以使用以下选项设置可见性：

  ``DIRECTORY <dir>``
    测试属性将在\ ``<dir>``\ 目录的范围内设置。CMake必须已经知道这个目录，要么通过调用\
    :command:`add_subdirectory`\ 添加它，要么它是顶层源目录。相对路径被视为相对于当前\
    源目录。\ ``<dir>``\ 可以引用二进制目录。

另请参阅
^^^^^^^^

* :command:`add_test`
* :command:`define_property`
* 更通用的\ :command:`set_property`\ 命令
* 已知CMake属性列表的\ :ref:`Test Properties`
