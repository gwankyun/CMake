function
--------

开始记录一个函数以便以后作为命令调用。

.. code-block:: cmake

  function(<name> [<arg1> ...])
    <commands>
  endfunction()

定义了一个名为\ ``<name>``\ 的函数，它接受名为\ ``<arg1>``\ 等参数用于记录函数定义中的\
``<commands>``。在调用函数之前，它们不会执行。

根据传统，\ :command:`endfunction`\ 命令允许一个可选的\ ``<name>``\ 参数。如果使用，\
它必须是开始\ ``function``\ 命令的参数的逐字重复。

函数会打开一个新的作用域：详情参见\ :command:`set(var PARENT_SCOPE)`。

有关函数中策略的行为，请参阅\ :command:`cmake_policy()`\ 命令文档。

有关CMake函数和宏之间的区别，请参阅\ :command:`macro()`\ 命令文档。

调用
^^^^^^^^^^

函数调用不区分大小写。定义为：

.. code-block:: cmake

  function(foo)
    <commands>
  endfunction()

可以通过任何方式调用

.. code-block:: cmake

  foo()
  Foo()
  FOO()
  cmake_language(CALL foo)

等等。但是，强烈建议使用函数定义中选择的情况。通常函数使用全小写的名称。

.. versionadded:: 3.18
  :command:`cmake_language(CALL ...)`\ 命令也可以用来调用该函数。

参数
^^^^^^^^^

当调用该函数时，记录的 ``<commands>`` 首先通过用传递的参数替换形式参数（ ``${arg1}``
等）来修改，然后作为普通命令调用。以下变量会被设置在函数的作用域中：

``ARGC``
  传递给函数的参数个数。

``ARGV``
  传递给函数的所有参数的列表。

``ARGV#``
  变量 ``ARGV0``、 ``ARGV1``、 ``ARGV2``、……，它们将持有传入参数的实际值。
  引用超出 ``ARGC`` 范围的 ``ARGV#`` 属于未定义行为。要确保 ``ARGV#`` 确实
  作为额外参数传递给了函数，唯一的办法是检查 ``ARGC`` 是否大于 ``#``。

``ARGN``
  排在最后一个形参之后的参数列表。

``ARGNC``
  .. versionadded:: 4.5

  排在最后一个形参之后的参数个数。

另请参阅
^^^^^^^^

* :command:`cmake_parse_arguments`
* :command:`endfunction`
* :command:`return`
