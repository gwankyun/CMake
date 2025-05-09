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

当宏被调用时，宏中记录的命令首先会将形式参数（如\ ``${arg1}``\ 等）替换为传入的\
实际参数，然后再作为普通命令执行。

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

In a function, ``ARGN``, ``ARGC``, ``ARGV`` and ``ARGV0``, ``ARGV1``, ...
are true variables in the usual CMake sense.  In a macro, they are not,
they are string replacements much like the C preprocessor would do
with a macro.  This has a number of consequences, as explained in
the :ref:`Argument Caveats` section below.

Another difference between macros and functions is the control flow.
A function is executed by transferring control from the calling
statement to the function body.  A macro is executed as if the macro
body were pasted in place of the calling statement.  This has the
consequence that a :command:`return()` in a macro body does not
just terminate execution of the macro; rather, control is returned
from the scope of the macro call.  To avoid confusion, it is recommended
to avoid :command:`return()` in macros altogether.

Unlike a function, the :variable:`CMAKE_CURRENT_FUNCTION`,
:variable:`CMAKE_CURRENT_FUNCTION_LIST_DIR`,
:variable:`CMAKE_CURRENT_FUNCTION_LIST_FILE`,
:variable:`CMAKE_CURRENT_FUNCTION_LIST_LINE` variables are not
set for a macro.

.. _`Argument Caveats`:

Argument Caveats
^^^^^^^^^^^^^^^^

Since ``ARGN``, ``ARGC``, ``ARGV``, ``ARGV0`` etc. are not variables,
you will NOT be able to use commands like

.. code-block:: cmake

 if(ARGV1) # ARGV1 is not a variable
 if(DEFINED ARGV2) # ARGV2 is not a variable
 if(ARGC GREATER 2) # ARGC is not a variable
 foreach(loop_var IN LISTS ARGN) # ARGN is not a variable

In the first case, you can use ``if(${ARGV1})``.  In the second and
third case, the proper way to check if an optional variable was
passed to the macro is to use ``if(${ARGC} GREATER 2)``.  In the
last case, you can use ``foreach(loop_var ${ARGN})`` but this will
skip empty arguments.  If you need to include them, you can use

.. code-block:: cmake

 set(list_var "${ARGN}")
 foreach(loop_var IN LISTS list_var)

Note that if you have a variable with the same name in the scope from
which the macro is called, using unreferenced names will use the
existing variable instead of the arguments. For example:

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

Will loop over ``a;b;c`` and not over ``x;y;z`` as one might have expected.
If you want true CMake variables and/or better CMake scope control you
should look at the function command.

See Also
^^^^^^^^

* :command:`cmake_parse_arguments`
* :command:`endmacro`
