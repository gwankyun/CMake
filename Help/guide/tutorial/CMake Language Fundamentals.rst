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

练习1 - 宏、函数和列表
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CMake允许我们创建自己的函数和宏。这在构建许多类似的目标（如测试）时非常有用，\
因为我们需要一遍又一遍地调用类似的命令集。我们可以使用\ :command:`function`\ 和\
:command:`macro`\ 命令来实现这一点。

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

与许多语言一样，函数和宏之间的区别在于作用域。在CMake语言中，\ :command:`function`\
和\ :command:`macro`\ 都可以“看到”在它们上面的所有框架中创建的所有变量。然而，\
:command:`macro`\ 在语义上就像文本替换，类似于C/C++宏，因此宏创建的任何副作用在\
其调用上下文中都是可见的。如果我们在宏中创建或更改变量，调用者将看到这些更改。

:command:`function`\ 创建自己的变量作用域，因此副作用对调用者不可见。为了将更改\
传播到调用该函数的父级，我们必须使用\ ``set(<var> <value> PARENT_SCOPE)``，\
它的工作方式与\ :command:`set`\ 相同，但适用于属于调用者上下文的变量。

.. note::
  在CMake 3.25中，添加了\ :command:`return(PROPAGATE)`\ 选项，它的工作方式与\
  :command:`set(PARENT_SCOPE)`\ 相同，但提供了稍好的使用体验。

虽然在本练习中不是必需的，但值得一提的是，\ :command:`macro`\ 和\ :command:`function`\
都通过\ ``ARGV``\ 变量（包含传递给命令的所有参数的列表）和\ ``ARGN``\ 变量（包\
含超过最后一个预期参数的所有参数）支持可变参数。

在本练习中，我们不会构建任何目标，而是将构建我们自己的\ :command:`list(APPEND)`\
版本，它可以向列表添加值。

目标
----

实现一个宏和一个函数，用于向列表追加值，但不使用\ :command:`list(APPEND)`\ 命令。

这些命令的期望用法如下：

.. code-block:: cmake

  set(Letters "Alpha;Beta")
  MacroAppend(Letters "Gamma")
  message("Letters contains: ${Letters}")

.. code-block:: console

  $ cmake -P Exercise1.cmake
  Letters contains: Alpha;Beta;Gamma

.. note::
  这些练习的文件扩展名为\ ``.cmake``，这是CMake语言文件不在\ ``CMakeLists.txt``\
  中的标准扩展名。

参考资源
-----------------

* :command:`macro`
* :command:`function`
* :command:`set`
* :command:`if`

待编辑文件
-------------

* ``Exercise1.cmake``

开始操作
----------------

``Exercise1.cmake``\ 的源代码位于\ ``Help/guide/tutorial/Step2``\ 目录中。\
它包含用于验证上述追加行为的测试。

.. note::
  你无须处理向空列表或未定义列表追加值的情况。但是，作为额外挑战，如果你想测试\
  对CMake语言条件语句的理解，该情况也包含在测试中。

完成\ ``TODO 1``\ 和\ ``TODO 2``。

构建和运行
-------------

我们将使用脚本模式来运行这些练习。首先导航到\ ``Help/guide/tutorial/Step2``\
文件夹，然后可以使用以下命令运行代码：

.. code-block:: console

  cmake -P Exercise1.cmake

脚本将报告命令是否正确实现。

解决方案
--------

这个问题依赖于对CMake变量机制的理解。CMake变量是字符串的名称；或者换句话说，\
CMake变量本身是一个可以通过花括号展开成不同字符串的字符串。

这导致了CMake代码中的一个常见模式：函数和宏不会传递值，而是传递包含这些值的变量\
的名称。因此，\ ``ListVar``\ 不包含我们需要追加的列表的\ *值*，而是包含一个列表的\
*名称*，该列表包含我们需要追加的值。

当使用\ ``${ListVar}``\ 展开变量时，我们会得到列表的名称。如果我们使用\
``${${ListVar}}``\ 展开该名称，我们将得到列表包含的值。

要实现\ ``MacroAppend``，我们只需要将对\ ``ListVar``\ 的这种理解与我们对\
:command:`set`\ 命令的知识结合起来。

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 1: Exercise1.cmake
  :name: Exercise1.cmake-MacroAppend

  macro(MacroAppend ListVar Value)
    set(${ListVar} "${${ListVar}};${Value}")
  endmacro()

.. raw:: html

  </details>

在这里我们不需要担心作用域，因为宏在其父作用域中运行。

``FuncAppend``\ 几乎完全相同，实际上它可以用相同的一行代码实现，但需要添加\
``PARENT_SCOPE``，但根据指令，我们需要用\ ``MacroAppend``\ 来实现它。

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 2: Exercise1.cmake
  :name: Exercise1.cmake-FuncAppend

  function(FuncAppend ListVar Value)
    MacroAppend(${ListVar} ${Value})
    set(${ListVar} "${${ListVar}}" PARENT_SCOPE)
  endfunction()

.. raw:: html

  </details>

``MacroAppend``\ 为我们转换了\ ``ListVar``，但它不会将结果传播到父作用域。因为\
这是一个函数，我们需要使用\ :command:`set(PARENT_SCOPE)`\ 自己完成这一操作。

练习2 - 条件和循环
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

任何结构化编程语言中最常见的两种流程控制元素是条件语句及其密切相关的循环。CMake\
语言也不例外。如前所述，给定CMake字符串的真值是由\ :command:`if`\ 命令建立的约定。

当给定一个字符串时，\ :command:`if`\ 会首先检查它是否是前面讨论过的已知常量值之一。\
如果该字符串不是这些值之一，命令会假设它是一个变量，并检查该变量的花括号展开内容\
来确定条件的结果。

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
    现在是讨论CMake中引号使用的好时机。CMake中的所有对象都是字符串，因此双引号\
    ``"``\ 通常是不必要的。CMake知道对象是字符串，一切都是字符串。

    但是，在某些上下文中它是必需的。包含空格的字符串需要双引号，否则它们将被视为\
    列表；CMake会使用分号将元素连接在一起。反之亦然，当花括号展开列表时，如果我\
    们想\ *保留*\ 分号，则必须在引号内进行。否则，CMake会将列表项展开为以空格分\
    隔的字符串。

    少数命令，如\ :command:`if`\ ，可以识别带引号和不带引号的字符串之间的区别。\
    :command:`if`\ 只有在字符串不带引号时才会检查给定的字符串是否表示一个变量。

最后，\ :command:`if`\ 提供了几种有用的比较模式，如用于字符串匹配的\ ``STREQUAL``，\
用于检查变量存在性的\ ``DEFINED``，以及用于正则表达式检查的\ ``MATCHES``。它还\
支持典型的逻辑运算符\ ``NOT``、\ ``AND``\ 和\ ``OR``。

除了条件语句外，CMake还提供了两种循环结构：\ :command:`while`\ ，它遵循与\
:command:`if`\ 相同的规则来检查循环变量；以及更有用的\ :command:`foreach`，\
它迭代字符串列表，这在\ `背景`_\ 部分中已经演示过。

在这个练习中，我们将使用循环和条件语句来解决一些简单的问题。我们将使用前面提到的\
来自\ :command:`function`\ 的\ ``ARGN``\ 变量作为要操作的列表。

目标
----

遍历列表，并返回所有包含字符串\ ``Foo``\ 的字符串。

.. note::
  阅读命令文档的人会知道这是\ :command:`list(FILTER)`，请克制使用它的冲动。

参考资源
-----------------

* :command:`function`
* :command:`foreach`
* :command:`if`
* :command:`list`

待编辑文件
-------------

* ``Exercise2.cmake``

开始操作
----------------

``Exercise2.cmake``\ 的源代码位于\ ``Help/guide/tutorial/Step2``\ 目录中。它包含\
用于验证上述追加行为的测试。

.. note::
  这次你应该使用\ :command:`list(APPEND)`\ 命令将最终结果收集到列表中。输入可以\
  从提供的函数的\ ``ARGN``\ 变量中获取。

完成\ ``TODO 3``。

构建和运行
-------------

导航到\ ``Help/guide/tutorial/Step2``\ 文件夹，然后可以使用以下命令运行代码：

.. code-block:: console

  cmake -P Exercise2.cmake

该脚本将报告\ ``FilterFoo``\ 函数是否正确实现。

解决方案
--------

我们需要做三件事：遍历\ ``ARGN``\ 列表，检查该列表中的给定项是否匹配\ ``"Foo"``，\
如果匹配，则将其追加到\ ``OutVar``\ 列表中。

虽然我们可以通过几种方式调用\ :command:`foreach`，但推荐的方式是通过\ ``IN LISTS``\
让命令为我们进行变量展开，以访问\ ``ARGN``\ 列表项。

我们需要的\ :command:`if`\ 比较是\ ``MATCHES``，它将检查项中是否存在\ ``"FOO"``。\
剩下的就是将该项追加到\ ``OutVar``\ 列表中。最棘手的部分是记住\ ``OutVar``\ *命名*\
了一个列表，而不是列表本身，因此我们需要通过\ ``${OutVar}``\ 访问它。

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

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

练习3 - 使用Include组织代码
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

我们已经讨论了如何通过\ :command:`add_subdirectory`\ 整合包含自己的CMakeLists.txt\
的子目录。在后续步骤中，我们将探索CMake代码可以跨项目打包和共享的各种方式。

然而，对于小型CMake函数和实用程序，将它们放在项目的CMakeLists.txt外部并与构建系统\
其余部分分开的独立\ ``.cmake``\ 文件中通常是有益的。这允许关注点分离，将项目特定\
元素从我们用来描述它们的实用程序中移除。

要将这些单独的\ ``.cmake``\ 文件整合到我们的项目中，我们使用\ :command:`include`\
命令。该命令立即开始在父CMakeLists.txt的作用域内解释被包含文件的内容。就好像整个\
文件被作为宏调用一样。

传统上，这类\ ``.cmake``\ 文件位于项目根目录中的名为“cmake”的文件夹内。对于本练习，\
我们将改用\ ``Step2``\ 文件夹。

目标
----

使用练习1和练习2中的函数来构建和过滤我们自己的项目列表。

参考资源
-----------------

* :command:`include`

待编辑文件
-------------

* ``Exercise3.cmake``

开始操作
----------------

``Exercise3.cmake``\ 的源代码位于\ ``Help/guide/tutorial/Step2``\ 目录中。它包含\
用于验证前两个练习中函数正确使用的测试。

.. note::
  实际上，它重用了Exercise2.cmake中的测试，可重用代码对所有人都有好处。

完成\ ``TODO 4``\ 到\ ``TODO 7``。

构建和运行
-------------

导航到\ ``Help/guide/tutorial/Step2``\ 文件夹，然后可以使用以下命令运行代码：

.. code-block:: console

  cmake -P Exercise3.cmake

该脚本将报告函数是否被正确调用和组合。

解决方案
--------

:command:`include`\ 命令将完全解释被包含的文件，包括前两个练习中的测试。我们不想\
再次运行这些测试。由于一些前瞻性设计，这些文件在运行测试前会检查一个名为\
``SKIP_TESTS``\ 的变量，将其设置为\ ``True``\ 可以获得我们想要的行为。

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 4: Exercise3.cmake
  :name: Exercise3.cmake-SKIP_TESTS

  set(SKIP_TESTS True)

.. raw:: html

  </details>

现在我们准备好使用\ :command:`include`\ 包含之前的练习来获取它们的函数。

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 5: Exercise3.cmake
  :name: Exercise3.cmake-include

  include(Exercise1.cmake)
  include(Exercise2.cmake)

.. raw:: html

  </details>

现在\ ``FuncAppend``\ 可用了，我们可以使用它将新元素追加到\ ``InList``\ 中。

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 6: Exercise3.cmake
  :name: Exercise3.cmake-FuncAppend

  FuncAppend(InList FooBaz)
  FuncAppend(InList QuxBaz)

.. raw:: html

  </details>

最后，我们可以使用\ ``FilterFoo``\ 来过滤完整列表。这里需要记住的棘手部分是，\
我们的\ ``FilterFoo``\ 希望通过\ ``ARGN``\ 对列表值进行操作，因此在调用\
``FilterFoo``\ 时需要展开\ ``InList``。

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 7: Exercise3.cmake
  :name: Exercise3.cmake-FilterFoo

  FilterFoo(OutList ${InList})

.. raw:: html

  </details>
