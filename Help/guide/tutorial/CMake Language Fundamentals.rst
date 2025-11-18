步骤2：CMake语言基础
===================================

在上一步中，我们匆忙地略过了\ ``CMakeLists.txt``\ 中使用的CMake语言的几个方面，\
以便尽快获得有用的构建程序。然而，在实际应用中，我们遇到的复杂性远不止简单地描述\
源文件和头文件列表。

为了应对这种复杂性，CMake提供了一种图灵完备的领域特定语言来描述构建软件的过程。\
在我们编写更复杂的CML文件和其他CMake文件时，理解这门语言的基础知识将是必要的。\
这门语言正式称为“:manual:`CMake语言 <cmake-language(7)>`”，或者更通俗地称为CMakeLang。

.. note::
  CMake语言并不适合描述与构建软件无关的事情。虽然它具有一些通用目的的功能，但开\
  发人员在CMake语言中解决与构建不直接相关的问题时应谨慎行事。

  通常，正确的做法是使用通用编程语言编写工具来解决问题，并教会CMake如何在构建过\
  程中调用该工具。代码生成、加密签名工具甚至光线追踪器都曾用CMake语言编写，但这\
  不是推荐的做法。

由于我们希望全面探索语言特性，这一步是教程序列中的例外。它既不基于\ ``Step1``，\
也不是\ ``Step3``\ 的起点。这将是一个探索语言特性的沙盒，而不构建任何软件。我们\
将在\ ``Step3``\ 中重新开始教程程序。

.. note::
  本教程致力于展示最佳实践和实际问题的解决方案。但是，在这一步中，我们将重新实现\
  一些CMake内置函数。在“现实生活”中，请不要编写自己的\ :command:`list(APPEND)`。

背景
^^^^^^^^^^

CMakeLang中唯一的基本类型是字符串和列表。CMake中的每个对象都是一个字符串，而列表\
本身就是包含分号作为分隔符的字符串。任何看起来像是在操作字符串以外的东西的命令，\
无论是布尔值、数字、JSON对象还是其他类型，实际上都是在处理字符串，执行一些内部\
转换逻辑（使用CMakeLang以外的语言），然后将结果转换回字符串以供潜在输出。

我们可以使用\ :command:`set`\ 命令创建一个变量，即为字符串命名。

.. code-block:: cmake

  set(var "World!")

可以通过大括号展开来访问变量的值，例如，如果我们想使用\ :command:`message`\
命令打印由\ ``var``\ 命名的字符串。

.. code-block:: cmake

  set(var "World!")
  message("Hello ${var}")

.. code-block:: console

  $ cmake -P CMakeLists.txt
  Hello World!

.. note::
  :option:`cmake -P`\ 被称为“脚本模式”，它告知CMake此文件不打算包含\
  :command:`project`\ 命令。我们不是在构建任何软件，而是仅将CMake用作命令解释器。

由于CMakeLang只有字符串，条件判断完全基于约定，即哪些字符串被认为是真，哪些被认\
为是假。这些约定\ *应该是*\ 直观的，“True”、“On”、“Yes”以及（表示）非零数字的\
字符串被认为是真，而“False”、“Off”、“No”、“0”、“Ignore”、“NotFound”和空字符串都\
被认为是假。

然而，有些规则比这更复杂，因此值得花些时间查阅\ :command:`if`\ 命令关于表达式的\
文档。建议在给定上下文中坚持使用单一的一对值，如“True”/“False”或“On”/“Off”。

如前所述，列表是包含分号的字符串。\ :command:`list`\ 命令对于操作这些列表很有用，\
CMake中的许多结构都期望按照这种约定操作。例如，我们可以使用\ :command:`foreach`\
命令遍历一个列表。

.. code-block:: cmake

  set(stooges "Moe;Larry")
  list(APPEND stooges "Curly")

  message("Stooges contains: ${stooges}")

  foreach(stooge IN LISTS stooges)
    message("Hello, ${stooge}")
  endforeach()

.. code-block:: console

  $ cmake -P CMakeLists.txt
  Stooges contains: Moe;Larry;Curly
  Hello, Moe
  Hello, Larry
  Hello, Curly

Exercise 1 - Macros, Functions, and Lists
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CMake allows us to craft our own functions and macros. This can be very helpful
when constructing lots of similar targets, like tests, for which we will want
to call similar sets of commands over and over again. We do so with
:command:`function` and :command:`macro`.

.. code-block:: cmake

  macro(MyMacro MacroArgument)
    message("${MacroArgument}\n\t\tFrom Macro")
  endmacro()

  function(MyFunc FuncArgument)
    MyMacro("${FuncArgument}\n\tFrom Function")
  endfunction()

  MyFunc("From TopLevel")

.. code-block:: console

  $ cmake -P CMakeLists.txt
  From TopLevel
        From Function
                From Macro

Like with many languages, the difference between functions and macros is one
of scope. In CMakeLang, both :command:`function` and :command:`macro` can "see"
all the variables created in all the frames above them. However, a
:command:`macro` acts semantically like a text replacement, similar to C/C++
macros, so any side effects the macro creates are visible in their calling
context. If we create or change a variable in a macro, the caller will see the
change.

:command:`function` creates its own variable scope, so side effects are not
visible to the caller. In order to propagate changes to the parent which called
the function, we must use ``set(<var> <value> PARENT_SCOPE)``, which works the
same as :command:`set` but for variables belonging to the caller's context.

.. note::
  In CMake 3.25, the :command:`return(PROPAGATE)` option was added, which
  works the same as :command:`set(PARENT_SCOPE)` but provides slightly better
  ergonomics.

While not necessary for this exercise, it bears mentioning that :command:`macro`
and :command:`function` both support variadic arguments via the ``ARGV``
variable, a list containing all arguments passed to the command, and the
``ARGN`` variable, containing all arguments past the last expected argument.

We're not going to build any targets in this exercise, so instead we'll
construct our own version of :command:`list(APPEND)`, which adds a value to a
list.

Goal
----

Implement a macro and a function which append a value to a list, without using
the :command:`list(APPEND)` command.

The desired usage of these commands is as follows:

.. code-block:: cmake

  set(Letters "Alpha;Beta")
  MacroAppend(Letters "Gamma")
  message("Letters contains: ${Letters}")

.. code-block:: console

  $ cmake -P Exercise1.cmake
  Letters contains: Alpha;Beta;Gamma

.. note::
  The extension for these exercises is ``.cmake``, that's the standard extension
  for CMakeLang files when not contained in a ``CMakeLists.txt``

Helpful Resources
-----------------

* :command:`macro`
* :command:`function`
* :command:`set`
* :command:`if`

Files to Edit
-------------

* ``Exercise1.cmake``

Getting Started
----------------

The source code for ``Exercise1.cmake`` is provided in the
``Help/guide/tutorial/Step2`` directory. It contains tests to verify the
append behavior described above.

.. note::
  You're not expected to handle the case of an empty or undefined list to
  append to. However, as a bonus, the case is tested if you want to try out
  your understanding of CMakeLang conditionals.

Complete ``TODO 1`` and ``TODO 2``.

Build and Run
-------------

We're going to use script mode to run these exercises. First navigate to the
``Help/guide/tutorial/Step2`` folder then you can run the code with:

.. code-block:: console

  cmake -P Exercise1.cmake

The script will report if the commands were implemented correctly.

Solution
--------

This problem relies on an understanding of the mechanisms of CMake variables.
CMake variables are names for strings; or put another way, a CMake variable
is itself a string which can brace expand into a different string.

This leads to a common pattern in CMake code where functions and macros aren't
passed values, but rather, they are passed the names of variables which contain
those values. Thus ``ListVar`` does not contain the *value* of the list we need
to append to, it contains the *name* of a list, which contains the value we
need to append to.

When expanding the variable with ``${ListVar}``, we will get the name of the
list. If we expand that name with ``${${ListVar}}``, we will get the values
the list contains.

To implement ``MacroAppend``, we need only combine this understanding of
``ListVar`` with our knowledge of the :command:`set` command.

.. raw:: html

  <details><summary>TODO 1: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 1: Exercise1.cmake
  :name: Exercise1.cmake-MacroAppend

  macro(MacroAppend ListVar Value)
    set(${ListVar} "${${ListVar}};${Value}")
  endmacro()

.. raw:: html

  </details>

We don't need to worry about scope here, because a macro operates in the same
scope as its parent.

``FuncAppend`` is almost identical, in fact it could be implemented in the
same one liner but with an added ``PARENT_SCOPE``, but the instructions ask
us to implement it in terms of ``MacroAppend``.

.. raw:: html

  <details><summary>TODO 2: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 2: Exercise1.cmake
  :name: Exercise1.cmake-FuncAppend

  function(FuncAppend ListVar Value)
    MacroAppend(${ListVar} ${Value})
    set(${ListVar} "${${ListVar}}" PARENT_SCOPE)
  endfunction()

.. raw:: html

  </details>

``MacroAppend`` transforms ``ListVar`` for us, but it won't propagate the result
to the parent scope. Because this is a function, we need to do so ourselves
with :command:`set(PARENT_SCOPE)`.

Exercise 2 - Conditionals and Loops
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The two most common flow control elements in any structured programming
language are conditionals and their close sibling loops. CMakeLang is no
different. As previously mentioned, the truthiness of a given CMake string is a
convention established by the :command:`if` command.

When given a string, :command:`if` will first check if it is one of the known
constant values previously discussed. If the string isn't one of those values
the command assumes it is a variable, and checks the brace-expanded contents of
that variable to determine the result of the conditional.

.. code-block:: cmake

  if(True)
    message("Constant Value: True")
  else()
    message("Constant Value: False")
  endif()

  if(ConditionalValue)
    message("Undefined Variable: True")
  else()
    message("Undefined Variable: False")
  endif()

  set(ConditionalValue True)

  if(ConditionalValue)
    message("Defined Variable: True")
  else()
    message("Defined Variable: False")
  endif()

.. code-block:: console

  $ cmake -P ConditionalValue.cmake
  Constant Value: True
  Undefined Variable: False
  Defined Variable: True

.. note::
    This is a good a time as any to discuss quoting in CMake. All objects in
    CMake are strings, thus the double quote, ``"``, is often unnecessary.
    CMake knows the object is a string, everything is a string.

    However, it is needed in some contexts. Strings containing whitespace require
    double quotes, else they are treated like lists; CMake will concatenate the
    elements together with semicolons. The reverse is also true, when
    brace-expanding lists it is necessary to do so inside quotes if we want to
    *preserve* the semicolons. Otherwise CMake will expand the list items into
    space-separate strings.

    A handful of commands, such as :command:`if`, recognize the difference
    between quoted and unquoted strings. :command:`if` will only check that the
    given string represents a variable when the string is unquoted.

Finally, :command:`if` provides several useful comparison modes such as
``STREQUAL`` for string matching, ``DEFINED`` for checking the existence of
a variable, and ``MATCHES`` for regular expression checks. It also supports the
typical logical operators, ``NOT``, ``AND``, and ``OR``.

In addition to conditionals CMake provides two loop structures,
:command:`while`, which follows the same rules as :command:`if` for checking a
loop variable, and the more useful :command:`foreach`, which iterates over lists
of strings and was demonstrated in the `背景`_ section.

For this exercise, we're going to use loops and conditionals to solve some
simple problems. We'll be using the aforementioned ``ARGN`` variable from
:command:`function` as the list to operate on.

Goal
----

Loop over a list, and return all the strings containing the string ``Foo``.

.. note::
  Those who read the command documentation will be aware that this is
  :command:`list(FILTER)`, resist the temptation to use it.

Helpful Resources
-----------------

* :command:`function`
* :command:`foreach`
* :command:`if`
* :command:`list`

Files to Edit
-------------

* ``Exercise2.cmake``

Getting Started
----------------

The source code for ``Exercise2.cmake`` is provided in the ``Help/guide/tutorial/Step2``
directory. It contains tests to verify the append behavior described above.

.. note::
  You should use the :command:`list(APPEND)` command this time to collect your
  final result into a list. The input can be consumed from the ``ARGN`` variable
  of the provided function.

Complete ``TODO 3``.

Build and Run
-------------

Navigate to the ``Help/guide/tutorial/Step2`` folder then you can run the code with:

.. code-block:: console

  cmake -P Exercise2.cmake

The script will report if the ``FilterFoo`` function was implemented correctly.

Solution
--------

We need to do three things, loop over the ``ARGN`` list, check if a given
item in that list matches ``"Foo"``, and if so append it to the ``OutVar``
list.

While there are a couple ways we could invoke :command:`foreach`, the
recommended way is to allow the command to do the variable expansion for us
via ``IN LISTS`` to access the ``ARGN`` list items.

The :command:`if` comparison we need is ``MATCHES`` which will check if
``"FOO"`` exists in the item. All that remains is to append the item to the
``OutVar`` list.  The trickiest part is remembering that ``OutVar`` *names* a
list, it is not the list itself, so we need to access it via ``${OutVar}``.

.. raw:: html

  <details><summary>TODO 3: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 3: Exercise2.cmake
  :name: Exercise2.cmake-FilterFoo

  function(FilterFoo OutVar)

    foreach(item IN LISTS ARGN)
      if(item MATCHES Foo)
        list(APPEND ${OutVar} ${item})
      endif()
    endforeach()

    set(${OutVar} ${${OutVar}} PARENT_SCOPE)
  endfunction()

.. raw:: html

  </details>

Exercise 3 - Organizing with Include
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We have already discussed how to incorporate subdirectories containing their
own CMLs with :command:`add_subdirectory`. In later steps we will explore
the various way CMake code can be packaged and shared across projects.

However for small CMake functions and utilities, it is often beneficial for them
to live in their own ``.cmake`` files outside the project CMLs and separate
from the rest of the build system. This allows for separation of concerns,
removing the project-specific elements from the utilities we are using to
describe them.

To incorporate these separate ``.cmake`` files into our project, we use the
:command:`include` command. This command immediately begins interpreting the
contents of the :command:`include`'d file in the scope of the parent CML. It
is as if the entire file were being called as a macro.

Traditionally, these kinds of ``.cmake`` files live in a folder named "cmake"
inside the project root. For this exercise, we'll use the ``Step2`` folder instead.

Goal
----

Use the functions from Exercises 1 and 2 to build and filter our own list of items.

Helpful Resources
-----------------

* :command:`include`

Files to Edit
-------------

* ``Exercise3.cmake``

Getting Started
----------------

The source code for ``Exercise3.cmake`` is provided in the ``Help/guide/tutorial/Step2``
directory. It contains tests to verify the correct usage of our functions
from the previous two exercises.

.. note::
  Actually it reuses tests from Exercise2.cmake, reusable code is good for
  everyone.

Complete ``TODO 4`` through ``TODO 7``.

Build and Run
-------------

Navigate to the ``Help/guide/tutorial/Step2`` folder then you can run the code with:

.. code-block:: console

  cmake -P Exercise3.cmake

The script will report if the functions were invoked and composed correctly.

Solution
--------

The :command:`include` command will interpret the included file completely,
including the tests from the first two exercises. We don't want to run these
tests again. Thanks to some forethought, these files check a variable called
``SKIP_TESTS`` prior to running their tests, setting this to ``True`` will
get us the behavior we want.

.. raw:: html

  <details><summary>TODO 4: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 4: Exercise3.cmake
  :name: Exercise3.cmake-SKIP_TESTS

  set(SKIP_TESTS True)

.. raw:: html

  </details>

Now we're ready to :command:`include` the previous exercises to grab their
functions.

.. raw:: html

  <details><summary>TODO 5: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 5: Exercise3.cmake
  :name: Exercise3.cmake-include

  include(Exercise1.cmake)
  include(Exercise2.cmake)

.. raw:: html

  </details>

Now that ``FuncAppend`` is available to us, we can use it to append new elements
to the ``InList``.

.. raw:: html

  <details><summary>TODO 6: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 6: Exercise3.cmake
  :name: Exercise3.cmake-FuncAppend

  FuncAppend(InList FooBaz)
  FuncAppend(InList QuxBaz)

.. raw:: html

  </details>

Finally, we can use ``FilterFoo`` to filter the full list. The tricky part to
remember here is that our ``FilterFoo`` wants to operate on list values via
``ARGN``, so we need to expand the ``InList`` when we call ``FilterFoo``.

.. raw:: html

  <details><summary>TODO 7: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 7: Exercise3.cmake
  :name: Exercise3.cmake-FilterFoo

  FilterFoo(OutList ${InList})

.. raw:: html

  </details>
