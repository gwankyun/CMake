步骤6：深入系统检测
=====================================

为了发现有关系统环境和工具链的信息，CMake通常会编译小型测试程序来验证编译器标志、\
头文件、内置函数或其他语言结构的可用性。

在这一步中，我们将在自己的项目代码中利用CMake使用的相同测试程序机制。

背景
^^^^^^^^^^

一个可以追溯到配置和构建系统早期的古老技巧是通过编译一个使用该功能的小程序来验证\
某些功能的可用性。

对于许多情况，CMake使这变得不必要。正如我们将在后续步骤中提到的，如果CMake能够\
找到一个库依赖项，我们可以依赖它拥有我们期望的所有设施（头文件、代码生成器、\
测试工具等）。相反，如果CMake找不到依赖项，尝试使用该依赖项几乎肯定会失败。

然而，关于工具链还有一些其他信息是CMake不容易传达的。对于这些高级情况，我们可以\
编写自己的测试程序和编译命令来检查可用性。

CMake提供了模块来简化这些检查。这些在\ :manual:`cmake-modules(7)`\ 中有文档记录。\
任何以\ ``Check``\ 开头的模块都是系统探测模块，我们可以用来查询工具链和系统环境。\
一些值得注意的包括：

  ``CheckIncludeFiles``
    检查一个或多个C/C++头文件。

  ``CheckCompilerFlag``
    检查编译器是否支持给定标志。

  ``CheckSourceCompiles``
    检查是否可以为给定语言构建源代码。

  ``CheckIPOSupported``
    检查编译器是否支持过程间优化（IPO/LTO）。


练习1 - 检查头文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

一个快速简单的检查是确定给定的头文件是否在特定平台上可用，CMake为此提供了\
:module:`CheckIncludeFiles`\ 模块。这对于系统头文件和内在函数头文件最为适用，\
这些头文件可能不是由特定包提供的，但预期在许多构建环境中可用。

.. code-block:: cmake

  include(CheckIncludeFiles)
  check_include_files(sys/socket.h HAVE_SYS_SOCKET_H LANGUAGE CXX)

.. note::
  这些函数在CMake中不是立即可用的，必须通过\ :command:`include`\ 它们相关联的模块\
  （即CMakeLang文件）来添加。许多模块位于CMake自己的\ ``Modules``\ 文件夹中。\
  这个内置的\ ``Modules``\ 文件夹是CMake在评估\ :command:`include`\ 命令时搜索的\
  位置之一。你可以将这些模块视为标准库头文件，它们应该是可用的。

一旦知道头文件存在，我们可以使用已经介绍过的条件语句和目标命令等机制将这一信息\
传达给我们的代码。

目标
----

检查x86 SSE2内在函数头文件是否可用，如果可用，则使用它来改进\
``mathfunctions::sqrt``。

参考资源
-----------------

* :module:`CheckIncludeFiles`
* :command:`target_compile_definitions`

待编辑文件
-------------

* ``MathFunctions/CMakeLists.txt``
* ``MathFunctions/MathFunctions.cxx``

开始操作
---------------

``Help/guide/tutorial/Step6``\ 目录包含\ ``Step5``\ 的完整推荐解决方案以及此步骤\
的相关\ ``TODO``\ 任务。该目录还包含针对各种条件的\ ``sqrt``\ 函数专用实现，\
你可以在\ ``MathFunctions/MathFunctions.cxx``\ 中找到这些实现。

完成\ ``TODO 1``\ 到\ ``TODO 3``。请注意，库中已添加了一些\ ``#ifdef``\ 指令，\
这些指令将在我们完成此步骤时改变库的操作方式。

构建和运行
-------------

我们可以使用常规命令进行配置。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

在配置步骤的输出中，我们应该能看到CMake检查\ ``emmintrin.h``\ 头文件。

.. code-block:: console

  -- Looking for include file emmintrin.h
  -- Looking for include file emmintrin.h - found

如果该头文件在你的系统上可用，请验证\ ``Tutorial``\ 输出包含关于使用SSE2的消息。\
反之，如果该头文件不可用，你应该看到\ ``Tutorial``\ 的常规行为。

解决方案
--------

首先，我们包含并使用\ ``CheckIncludeFiles``\ 模块，验证\ ``emmintrin.h``\ 头文件\
是否可用。

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :caption: TODO 1: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-check-include-files
  :language: cmake
  :start-at: include(CheckIncludeFiles
  :end-at: check_include_files(

.. raw:: html

  </details>

然后，我们使用检查结果有条件地在\ ``MathFunctions``\ 上设置编译定义。

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :caption: TODO 2: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-define-use-sse2
  :language: cmake
  :start-at: if(HAS_EMMINTRIN)
  :end-at: endif()

.. raw:: html

  </details>

最后，我们可以在\ ``MathFunctions``\ 库中有条件地包含该头文件。

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. literalinclude:: Step7/MathFunctions/MathFunctions.cxx
  :caption: TODO 3: MathFunctions/MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-include-sse2
  :language: c++
  :start-at: #ifdef TUTORIAL_USE_SSE2
  :end-at: #endif

.. raw:: html

  </details>


练习2 - 检查源代码编译
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

有时候，仅仅检查头文件是不够的。当没有可用的头文件可以检查时（例如编译器内置函数\
的情况），这一点尤为正确。对于这些场景，我们有\ :module:`CheckSourceCompiles`\
模块。

.. code-block:: cmake

  include(CheckSourceCompiles)
  check_source_compiles(CXX
    "
      int main() {
        int a, b, c;
        __builtin_add_overflow(a, b, &c);
      }
    "
    HAS_CHECKED_ADDITION
  )

.. note::
  默认情况下，\ :module:`CheckSourceCompiles`\ 会构建并链接一个可执行文件。\
  要检查的代码必须提供有效的\ ``int main()``\ 函数才能成功。

执行检查后，这种系统检查的应用方式与我们讨论的头文件检查方式完全相同。

目标
----

检查GNU SSE2内置函数是否可用，如果可用，则使用它们来改进\ ``mathfunctions::sqrt``。

参考资源
-----------------

* :module:`CheckSourceCompiles`
* :command:`target_compile_definitions`

待编辑文件
-------------

* ``MathFunctions/CMakeLists.txt``

开始操作
---------------

完成\ ``TODO 4``\ 和\ ``TODO 5``。不需要对\ ``MathFunctions``\ 实现进行任何代码\
更改，因为这些已经提供好了。

构建和运行
-------------

我们只需要重新构建教程即可。

.. code-block:: console

  cmake --build build

.. note::
  如果检查失败但你认为应该成功，你需要通过删除\ ``CMakeCache.txt``\ 文件来清除\
  CMake缓存。如果CMake已有缓存结果，后续运行时将不会重新执行编译检查。

在配置步骤的输出中，我们应该能看到CMake检查提供的源代码是否可以编译，检查结果将\
我们传递给\ ``check_source_compiles()``\ 的变量名报告。

.. code-block:: console

  -- Performing Test HAS_GNU_BUILTIN
  -- Performing Test HAS_GNU_BUILTIN - Success

如果你的编译器支持内置函数，请验证\ ``Tutorial``\ 输出包含关于使用GNU内置函数的\
消息。反之，如果不支持内置函数，你应该看到\ ``Tutorial``\ 之前的行为。

解决方案
--------

首先，我们包含并使用\ ``CheckSourceCompiles``\ 模块，验证提供的源代码可以被构建。

..
  pygments doesn't like the [=[ <string> ]=] literals in the following
  literalinclude, so use :language: none

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :caption: TODO 4: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-check-source-compiles
  :language: none
  :start-at: include(CheckSourceCompiles
  :end-at: HAS_GNU_BUILTIN
  :append: )

.. raw:: html

  </details>

然后，我们使用检查结果有条件地在\ ``MathFunctions``\ 上设置编译定义。

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :caption: TODO 5: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-define-use-gnu-builtin
  :language: cmake
  :start-at: if(HAS_GNU_BUILTIN)
  :end-at: endif()

.. raw:: html

  </details>

练习3 - 检查过程间优化
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

过程间优化（Interprocedural Optimization）和链接时间优化（Link Time Optimization）\
可以为某些软件带来显著的性能提升。CMake能够通过\ :module:`CheckIPOSupported`\
模块检查IPO标志的可用性。

.. code-block:: cmake

  include(CheckIPOSupported)
  check_ipo_supported() # fatal error if IPO is not supported
  set_target_properties(MyApp
    PROPERTIES
      INTERPROCEDURAL_OPTIMIZATION TRUE
  )

.. note::
  关于项目内IPO配置，有几个重要的注意事项：

  * CMake并非了解所有编译器上的每一个IPO/LTO标志，针对已知工具链进行单独调优通常\
    可以获得更好的结果。
  * 在目标上设置\ :prop_tgt:`INTERPROCEDURAL_OPTIMIZATION`\ 属性不会改变它链接的\
    任何目标，也不会改变来自其他项目的依赖关系。IPO只能“看到”同样经过适当编译的\
    其他目标。

  由于这些原因，应该认真考虑通过外部机制（预设、\ :option:`-D <cmake -D>`\ 标志、\
  :manual:`工具链文件 <cmake-toolchains(7)>`\ 等）为依赖树中的所有项目手动设置\
  IPO/LTO标志，而不是在项目内部进行控制。

然而，特别是对于极其大型的项目，拥有一个在项目内使用IPO的机制（只要IPO可用）可能\
会很有用。

目标
----

当工具链支持IPO时，为整个教程项目启用IPO。

参考资源
-----------------

* :module:`CheckIPOSupported`
* :variable:`CMAKE_INTERPROCEDURAL_OPTIMIZATION`

待编辑文件
-------------

* ``CMakeLists.txt``

开始操作
---------------

继续编辑\ ``Step6``\ 目录中的文件。完成\ ``TODO 6``\ 和\ ``TODO 7``。

构建和运行
-------------

我们只需要重新构建教程。

.. code-block:: console

  cmake --build build

如果IPO不可用，我们将在配置过程中看到错误消息。否则不会有任何变化。

.. note::
  无论IPO检查的结果如何，我们都不应期望\ ``Tutorial``\ 或\ ``MathFunctions``\
  的行为发生任何变化。

解决方案
--------

第一个\ ``TODO``\ 很简单，我们需要为项目添加另一个选项。

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. literalinclude:: Step7/CMakeLists.txt
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-enable-ipo
  :language: cmake
  :start-at: option(TUTORIAL_ENABLE_IPO
  :end-at: option(TUTORIAL_ENABLE_IPO

.. raw:: html

  </details>

下一步涉及到一些操作，但\ :module:`CheckIPOSupported`\ 的文档已经提供了一个几乎\
完整的示例，展示了我们需要做什么。唯一的区别是我们将在整个项目范围内启用IPO，\
而不是仅针对单个目标。

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step7/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-check-ipo
  :language: cmake
  :start-at: if(TUTORIAL_ENABLE_IPO)
  :end-at: endif()
  :append: endif()

.. raw:: html

  </details>

.. note::
  通常我们不建议在项目内部设置\ ``CMAKE_``\ 变量。在这里，我们通过\
  :command:`option()`\ 来控制这种行为，这样打包者可以选择不使用我们的覆盖设置。\
  这是一个不完美但可接受的解决方案，用于处理我们想要提供选项来控制由\ ``CMAKE_``\
  变量控制的项目范围行为的情况。
