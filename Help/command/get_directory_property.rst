get_directory_property
----------------------

获取\ ``DIRECTORY``\ 范围的属性。

.. code-block:: cmake

  get_directory_property(<variable> [DIRECTORY <dir>] <prop-name>)

将目录作用域的属性存储在名为\ ``<variable>``\ 的变量中。

``DIRECTORY``\ 参数指定了一个用于获取属性值的目录，而非当前目录。相对路径会被视为相对于当前\
源目录的路径。CMake必须已经知晓该目录，这可以通过调用\ :command:`add_subdirectory`\ 命令\
添加该目录，或者该目录是顶层目录来实现。

.. versionadded:: 3.19
  ``<dir>``\ 可以引用一个二进制目录。

如果指定目录作用域中未定义该属性，则返回空字符串。对于\ ``INHERITED``\（继承）属性，如果在\
指定目录作用域中未找到该属性，则会按照\ :command:`define_property`\ 命令所描述的那样，\
将搜索链延伸到父作用域。

.. code-block:: cmake

  get_directory_property(<variable> [DIRECTORY <dir>]
                         DEFINITION <var-name>)

从一个目录中获取变量定义。这种形式有助于从另一个目录中获取变量定义。


另请参阅
^^^^^^^^

* :command:`define_property`
* 更通用的\ :command:`get_property`\ 命令
