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

当调用该函数时，记录的\ ``<commands>``\ 首先通过用传递的参数替换形式参数（\ ``${arg1}``\
等）来修改，然后作为普通命令调用。

除了引用形式参数之外，你还可以引用\ ``ARGC``\ 变量，该变量将被设置为传入函数的参数数量，\
以及\ ``ARGV0``、\ ``ARGV1``、\ ``ARGV2``\ 等它将具有传入的参数的实际值。这有助于创建带\
有可选参数的函数。

此外，\ ``ARGV``\ 保存给函数的所有参数的列表，\ ``ARGN``\ 保存最后一个预期参数之后的参数\
列表。在\ ``ARGC``\ 之外引用\ ``ARGV#``\ 参数有未定义的行为。检查\ ``ARGC``\ 是否大于\
``#``\ 是确保\ ``ARGV#``\ 作为额外参数传递给函数的唯一方法。

另请参阅
^^^^^^^^

* :command:`cmake_parse_arguments`
* :command:`endfunction`
* :command:`return`
