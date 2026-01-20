步骤7：自定义命令和生成文件
===========================================

代码生成是一种普遍的机制，用于扩展编程语言超越其语言模型的界限。CMake为Qt的元对\
象编译器提供了一流的支持，但很少有其他代码生成器值得付出那样的努力。

相反，代码生成器往往是定制的和特定于用途的。CMake提供了描述代码生成器使用方法的\
工具，因此项目可以根据其个别需求添加支持。

在这一步中，我们将使用\ :command:`add_custom_command`\ 在教程项目中添加对代码生\
成器的支持。

背景
^^^^^^^^^^

构建过程中的任何步骤通常都可以用其输入和输出来描述。CMake假设代码生成器和其他自\
定义进程遵循相同的原则。这样，代码生成器的作用就与编译器、链接器和其他工具链元素\
相同；当输入比输出新（或者输出不存在）时，将运行用户指定的命令来更新输出。

.. note::
  此模型假定在运行之前已知进程的输出。CMake缺乏描述代码生成器的能力，其中输出的\
  名称和位置取决于输入的\ *内容*。存在各种黑客技术将此功能引入CMake，但它们超出\
  了本教程的范围。

描述代码生成器（或任何自定义进程）通常分为两个部分。首先，独立于CMake目标模型描\
述输入和输出，只关注生成过程本身。其次，将输出与CMake目标关联，以将其插入CMake\
目标模型。

对于源文件，这就像将生成的文件添加到\ ``STATIC``、\ ``SHARED``\ 或\ ``OBJECT``\
库的源列表一样简单。对于仅头文件的生成器，通常需要使用通过\
:command:`add_custom_target`\ 创建的中间目标将头文件生成添加到构建阶段（因为\
``INTERFACE``\ 库没有构建步骤）。

练习1 - 使用代码生成器
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

描述代码生成器的主要机制是\ :command:`add_custom_command`\ 命令。就\
:command:`add_custom_command`\ 而言，“命令”可以是构建环境中可用的可执行文件，\
也可以是CMake可执行目标名称。

.. code-block:: cmake

  add_executable(Tool)
  # ...
  add_custom_command(
    OUTPUT Generated.cxx
    COMMAND Tool -i input.txt -o Generated.cxx
    DEPENDS Tool input.txt
    VERBATIM
  )
  # ...
  add_library(GeneratedObject OBJECT)
  target_sources(GeneratedObject
    PRIVATE
      Generated.cxx
  )

除了\ ``VERBATIM``\ 之外，大多数关键字都是自解释的。由于一些在现代背景下不太有趣\
的遗留原因，这个参数实际上是必需的。有兴趣的读者可以查阅\
:command:`add_custom_command`\ 的文档以获取更多详细信息。

``Tool``\ 可执行目标同时出现在\ ``COMMAND``\ 和\ ``DEPENDS``\ 参数中。虽然\
``COMMAND``\ 已足够使代码正确构建，但将\ ``Tool``\ 本身作为自定义命令的依赖项，\
可以确保如果\ ``Tool``\ 被更新，自定义命令将重新运行。

对于仅头文件的生成，还需要额外的命令，因为库本身没有构建步骤。我们可以使用\
:command:`add_custom_target`\ 为库创建一个“人工”构建步骤。然后，我们使用\
:command:`add_dependencies`\ 命令强制在任何链接该库的目标之前运行这个自定义目标。

.. code-block:: cmake

  add_custom_target(RunGenerator DEPENDS Generated.h)

  add_library(GeneratedLib INTERFACE)
  target_sources(GeneratedLib
    INTERFACE
      FILE_SET HEADERS
      BASE_DIRS
        ${CMAKE_CURRENT_BINARY_DIR}
      FILES
        ${CMAKE_CURRENT_BINARY_DIR}/Generated.h
  )

  add_dependencies(GeneratedLib RunGenerator)

.. note::
  我们将\ :variable:`CMAKE_CURRENT_BINARY_DIR`\ （一个命名当前构建树中放置工件的\
  位置的变量）添加到基础目录中，因为这是我们的代码生成器将在其中运行的工作目录。\
  列出\ ``FILES``\ 对于构建来说是不必要的，这里只是为了清晰起见。

目标
----

向\ ``MathFunctions``\ 库添加一个预计算平方根的生成表。

参考资源
-----------------

* :command:`add_executable`
* :command:`add_library`
* :command:`target_sources`
* :command:`add_custom_command`
* :command:`add_custom_target`
* :command:`add_dependencies`

待编辑文件
-------------

* ``MathFunctions/CMakeLists.txt``
* ``MathFunctions/MakeTable/CMakeLists.txt``
* ``MathFunctions/MathFunctions.cxx``

开始操作
---------------

``MathFunctions``\ 库已被修改为在处理小于10的数字时使用预计算表。然而，硬编码的\
表不是特别准确，仅包含最接近的截断整数值。

``MakeTable.cxx``\ 源文件描述了一个将生成更好表格的程序。它接受一个参数作为输入，\
即要生成的表格的文件名。

完成\ ``TODO 1``\ 到\ ``TODO 10``。

构建和运行
-------------

不需要特殊配置，像往常一样进行配置和构建。注意\ ``MakeTable``\ 可执行文件会在\
``MathFunctions``\ 之前生成。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

验证\ ``Tutorial``\ 的输出现在对小于10的值使用预计算表。

解决方案
--------

首先，我们添加一个新的可执行文件来生成表格，将\ ``MakeTable.cxx``\ 文件作为源文件。

.. raw:: html

  <details><summary>TODO 1-2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/MakeTable/CMakeLists.txt
  :caption: TODO 1-2: MathFunctions/MakeTable/CMakeLists.txt
  :name: MathFunctions/MakeTable/CMakeLists.txt-add_executable
  :language: cmake
  :start-at: add_executable
  :end-at: MakeTable.cxx
  :append: )

.. raw:: html

  </details>

然后，我们添加一个生成表格的自定义命令，以及一个依赖于该表格的自定义目标。

.. raw:: html

  <details><summary>TODO 3-4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/MakeTable/CMakeLists.txt
  :caption: TODO 3-4: MathFunctions/MakeTable/CMakeLists.txt
  :name: MathFunctions/MakeTable/CMakeLists.txt-add_custom_command
  :language: cmake
  :start-at: add_custom_command
  :end-at: add_custom_target

.. raw:: html

  </details>

我们需要添加一个接口库，用于描述将出现在\ :variable:`CMAKE_CURRENT_BINARY_DIR`\
中的输出。\ ``FILES``\ 参数是可选的。

.. raw:: html

  <details><summary>TODO 5-6: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/MakeTable/CMakeLists.txt
  :caption: TODO 5-6: MathFunctions/MakeTable/CMakeLists.txt
  :name: MathFunctions/MakeTable/CMakeLists.txt-add_library
  :language: cmake
  :start-at: add_library
  :end-at: SqrtTable.h
  :append: )

.. raw:: html

  </details>

现在所有目标都已描述完毕，我们可以通过使用\ :command:`add_dependencies`\
将自定义目标与接口库关联起来，强制自定义目标在接口库的任何依赖项之前运行。

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/MakeTable/CMakeLists.txt
  :caption: TODO 7: MathFunctions/MakeTable/CMakeLists.txt
  :name: MathFunctions/MakeTable/CMakeLists.txt-add_dependencies
  :language: cmake
  :start-at: add_dependencies
  :end-at: add_dependencies

.. raw:: html

  </details>

现在我们可以将接口库添加到\ ``MathFunctions``\ 的链接库中，并将整个\ ``MakeTable``\
文件夹添加到项目中。

.. raw:: html

  <details><summary>TODO 8-9: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/CMakeLists.txt
  :caption: TODO 8: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-link-sqrttable
  :language: cmake
  :start-at: target_link_libraries(MathFunctions
  :end-at: )

.. literalinclude:: Step8/MathFunctions/CMakeLists.txt
  :caption: TODO 9: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add-maketable
  :language: cmake
  :start-at: add_subdirectory(MakeTable
  :end-at: add_subdirectory(MakeTable

.. raw:: html

  </details>

最后，我们更新\ ``MathFunctions``\ 库本身，以利用生成的表格。

.. raw:: html

  <details><summary>TODO 10: 点击显示/隐藏答案</summary>

.. literalinclude:: Step8/MathFunctions/MathFunctions.cxx
  :caption: TODO 10: MathFunctions/MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-include-sqrttable
  :language: c++
  :start-at: #include <SqrtTable.h>
  :end-at: {

.. raw:: html

  </details>
