macro
-----

开始记录宏，以便之后作命令调用。

.. code-block:: cmake

  macro(<name> [<arg1> ...])
    <commands>
  endmacro()

定义一个名为\ ``<name>``\ 的宏，该宏接受名为\ ``<arg1>``\ 等的参数。在macro命令之后、\
对应的\ :command:`endmacro()`\ 命令之前列出的命令，直到该宏被调用时才会执行。

按照传统做法，\ :command:`endmacro`\ 命令允许使用一个可选的\ ``<name>``\ 参数。\
如果使用该参数，它必须与开头\ ``macro``\ 命令的参数完全一致。

有关宏内部策略的行为，请参阅\ :command:`cmake_policy()`\ 命令文档。

有关CMake宏与\ :command:`functions <function>`\ 之间的差异，请参阅下面的\
:ref:`Macro vs Function`\ 部分。

调用
^^^^^^^^^^

宏调用不区分大小写。\
一个宏定义如下

.. code-block:: cmake

  macro(foo)
    <commands>
  endmacro()

可以通过以下任意一种方式调用

.. code-block:: cmake

  foo()
  Foo()
  FOO()
  cmake_language(CALL foo)

等等。不过，强烈建议使用宏定义时采用的大小写形式。通常，宏使用全小写名称。

.. versionadded:: 3.18
  :command:`cmake_language(CALL ...)`\ 命令同样可用于调用宏。

参数
^^^^^^^^^

When a macro is invoked, first all commands recorded in the macro are
modified by replacing formal parameters (``${arg1}``, ...)
with the arguments passed. Then all modified commands are invoked as
normal commands.

除了引用形式参数外，你还可以引用\ ``${ARGC}``\ 的值，它会被设置为传递给宏的参数数量。\
同时，还能引用\ ``${ARGV0}``、\ ``${ARGV1}``、\ ``${ARGV2}``\ 等，这些变量将包含\
传入参数的实际值。\
这有助于创建带有可选参数的宏。

此外，\ ``${ARGV}``\ 包含传递给宏的所有参数列表，而\ ``${ARGN}``\ 包含超出最后一个\
预期参数的所有参数列表。\
引用超出\ ``${ARGC}``\ 范围的\ ``${ARGV#}``\ 参数会产生未定义行为。要确保\ ``${ARGV#}``\
作为额外参数传递给宏，唯一的方法是检查\ ``${ARGC}``\ 是否大于\ ``#``。

.. _`Macro vs Function`:

宏对比函数
^^^^^^^^^^^^^^^^^

``macro``\ 命令与\ :command:`function`\ 命令非常相似。\
不过，二者仍存在一些重要差异。

在函数里，\ ``ARGN``、\ ``ARGC``、\ ``ARGV``\ 以及\ ``ARGV0``、\ ``ARGV1``\ 等，\
在常规CMake概念里属于真正的变量。\
在宏中，它们并非真正的变量，而是类似于C预处理器处理宏时所做的字符串替换。\
这会产生一些影响，具体内容将在下面的\ :ref:`Argument Caveats`\ 部分进行解释。

宏和函数之间的另一个区别在于控制流。\
函数的执行是通过将控制权从调用语句转移到函数体来实现的。\
宏的执行就好像将宏体直接粘贴到调用语句的位置一样。\
这就导致了在宏体中使用\ :command:`return()`\ 命令时，它不仅仅是终止宏的执行，\
而是从宏调用所在的作用域返回控制权。\
为避免混淆，建议在宏中完全避免使用\ :command:`return()`\ 命令。

与函数不同，宏不会设置\ :variable:`CMAKE_CURRENT_FUNCTION`、\
:variable:`CMAKE_CURRENT_FUNCTION_LIST_DIR`、\ :variable:`CMAKE_CURRENT_FUNCTION_LIST_FILE`\
和\ :variable:`CMAKE_CURRENT_FUNCTION_LIST_LINE`\ 这些变量。

.. _`Argument Caveats`:

参数注意事项
^^^^^^^^^^^^^^^^

由于\ ``ARGN``、\ ``ARGC``、\ ``ARGV``、\ ``ARGV0``\ 等并非变量，你将\ **无法**\
使用类似如下的命令

.. code-block:: cmake

 if(ARGV1) # ARGV1不是一个变量
 if(DEFINED ARGV2) # ARGV2不是一个变量
 if(ARGC GREATER 2) # ARGC不是一个变量
 foreach(loop_var IN LISTS ARGN) # ARGN不是一个变量

在第一种情况下，你可以使用\ ``if(${ARGV1})``。\
在第二和第三种情况下，检查是否有可选变量传递给宏的正确方法是使用\
``if(${ARGC} GREATER 2)``。\
在最后一种情况下，你可以使用\ ``foreach(loop_var ${ARGN})``，但这会跳过空参数。\
如果你需要包含这些空参数，你可以使用

.. code-block:: cmake

 set(list_var "${ARGN}")
 foreach(loop_var IN LISTS list_var)

请注意，如果在调用宏的作用域中存在同名变量，使用未引用的名称时将使用现有变量，\
而不是宏的参数。例如：

.. code-block:: cmake

 macro(bar)
   foreach(arg IN LISTS ARGN)
     <commands>
   endforeach()
 endmacro()

 function(foo)
   bar(x y z)
 endfunction()

 foo(a b c)

将会遍历\ ``a;b;c``，而不是像人们可能预期的那样遍历\ ``x;y;z``。\
如果你想要真正的CMake变量和（或）更好的CMake作用域控制，你应该使用function命令。

另请参阅
^^^^^^^^

* :command:`cmake_parse_arguments`
* :command:`endmacro`
