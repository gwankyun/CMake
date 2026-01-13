步骤5：深入CMake库概念
=======================================

虽然可执行文件大多是通用的，但库有多种不同的形式。有静态归档库、共享对象、模块、\
对象库、仅头文件库，以及描述高级CMake属性以被其他目标继承的库，仅举几例。

在这一步中，你将学习CMake可以描述的一些最常见的库类型。这将涵盖项目内使用的大部分\
:command:`add_library`\ 命令。从依赖项导入的库（或由项目导出以作为依赖项被使用）\
将在后续步骤中介绍。

背景
^^^^^^^^^^

正如我们在\ ``Step1``\ 中所学到的，\ :command:`add_library`\ 命令接受要创建的库\
目标名称作为其第一个参数。第二个参数是可选的\ ``<type>``，有效值如下：

  ``STATIC``
    :ref:`静态库 <Static Libraries>`：\
    一个用于链接其他目标时使用的对象文件归档。

  ``SHARED``
    :ref:`共享库 <Shared Libraries>`：
    一个可由其他目标链接并在运行时加载的动态库。

  ``MODULE``
    :ref:`模块库 <Module Libraries>`：
    一个插件，不能被其他目标直接链接，但可以在运行时通过类似dlopen的功能动态加载。

  ``OBJECT``
    :ref:`对象库 <Object Libraries>`：
    一组尚未归档或链接成库的对象文件集合。

  ``INTERFACE``
    :ref:`接口库 <Interface Libraries>`：
    一种指定依赖项使用要求的库目标，但不编译源代码，也不在磁盘上生成库工件。

此外，还有\ ``IMPORTED``\ 库，它们描述了从外部项目或模块导入到当前项目的库目标。\
我们将在后续步骤中简要介绍这些内容。

``MODULE``\ 库最常见于插件系统，或作为Python或Javascript等运行时加载语言的扩展。\
它们的行为与普通共享库非常相似，只是不能被其他目标直接链接。由于它们足够相似，\
因此我们不会在这里进一步深入讨论。

练习1 - 静态库和共享库
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

虽然\ :command:`add_library`\ 命令支持显式设置\ ``STATIC``\ 或\ ``SHARED``，并且\
有时这是必要的，但对于大多数可以作为任一种类型运行的“正常”库，最好将第二个参数留空。

当未指定类型时，:command:`add_library`\ 将根据\ :variable:`BUILD_SHARED_LIBS`\
的值创建\ ``STATIC``\ 或\ ``SHARED``\ 库。如果\ :variable:`BUILD_SHARED_LIBS`\
为true，则创建\ ``SHARED``\ 库，否则创建\ ``STATIC``\ 库。

.. code-block:: cmake

  add_library(MyLib-static STATIC)
  add_library(MyLib-shared SHARED)

  # Depends on BUILD_SHARED_LIBS
  add_library(MyLib)

这是理想的行为，因为它允许打包者确定将生成哪种类型的库，并确保依赖项链接到该版本\
的库，而无需修改其源代码。在某些情况下，完全静态构建是合适的，而在其他情况下，\
共享库更受欢迎。

.. note::
  CMake默认不定义\ :variable:`BUILD_SHARED_LIBS`\ 变量，这意味着在没有项目或用户\
  干预的情况下，:command:`add_library`\ 将生成\ ``STATIC``\ 库。

通过将\ :command:`add_library()`\ 的第二个参数留空，项目为其打包者和下游依赖项\
提供了额外的灵活。

目标
----

将\ ``MathFunctions``\ 构建为共享库。

.. note::
  在Windows上，你可能会看到关于空DLL的警告，因为\ ``MathFunctions``\ 没有导出\
  任何符号。

参考资源
-----------------

* :variable:`BUILD_SHARED_LIBS`

待编辑文件
-------------

无需编辑任何文件。

开始操作
---------------

``Help/guide/tutorial/Step5``\ 目录包含\ ``Step4``\ 的完整推荐解决方案。本步骤是\
关于构建\ ``MathFunctions``\ 库的，不需要任何\ ``TODOs``。你可以直接进入构建步骤。

构建和运行
-------------

我们可以使用预设进行配置，通过\ :option:`-D <cmake -D>`\ 标志启用\
:variable:`BUILD_SHARED_LIBS`。

.. code-block:: console

  cmake --preset tutorial -DBUILD_SHARED_LIBS=ON

然后我们可以使用\ :option:`-t <cmake--build -t>`\ 只构建\ ``MathFunctions``\ 库。

.. code-block:: console

  cmake --build build -t MathFunctions

验证为\ ``MathFunctions``\ 生成了共享库，然后重置\ :variable:`BUILD_SHARED_LIBS`，\
可以通过使用\ ``-DBUILD_SHARED_LIBS=OFF``\ 重新配置或删除\ ``CMakeCache.txt``。

解决方案
--------

本练习不需要对项目进行任何更改。

练习2 - 接口库
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

接口库仅用于向其他目标传达使用要求，它们自身不进行构建或生成任何产物。因此，接口\
库的所有属性本身必须是接口属性，使用\ ``INTERFACE``\
:ref:`作用域关键字 <Target Command Scope>`\ 指定。

.. code-block:: cmake

  add_library(MyInterface INTERFACE)
  target_compile_definitions(MyInterface INTERFACE MYINTERFACE_COMPILE_DEF)

C++开发中最常见的接口库类型是仅头文件库。这类库不构建任何内容，仅提供发现其头\
文件所需的标志。

目标
----

向教程项目添加仅头文件库，并在\ ``Tutorial``\ 可执行文件中使用它。

参考资源
-----------------

* :command:`add_library`
* :command:`target_sources`

待编辑文件
-------------

* ``MathFunctions/MathLogger/CMakeLists.txt``
* ``MathFunctions/CMakeLists.txt``
* ``MathFunctions/MathFunctions.cxx``

开始操作
---------------

在我们之前讨论\ :command:`target_sources(FILE_SET)`\ 时，我们提到如果文件集的名称\
与文件集的类型相同，可以省略\ ``TYPE``\ 参数。我们还说过，如果希望将当前源目录用\
作唯一的基础目录，可以省略\ ``BASE_DIRS``\ 参数。

现在我们准备介绍第三个快捷方式：只有当头文件打算被安装时（例如库的公共头文件），\
我们才需要包含\ ``FILES``\ 参数。

本练习中的\ ``MathLogger``\ 头文件仅由\ ``MathFunctions``\ 实现内部使用，不会被\
安装。这应该会使对\ :command:`target_sources(FILE_SET)`\ 的调用非常简洁。

.. note::
  编译器的依赖扫描器会发现这些头文件，以确保正确的增量构建。无论如何，在这些上下\
  文中列出头文件可能很有用，因为该列表可用于生成某些IDE依赖的元数据。

你可以开始编辑\ ``Step5``\ 目录，完成\ ``TODO 1``\ 到\ ``TODO 7``。

构建和运行
-------------

预设已经更新为使用\ ``mathfunctions::sqrt``\ 而不是\ ``std::sqrt``。我们可以像\
往常一样进行构建和配置。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

验证\ ``Tutorial``\ 输出现在是否使用了日志框架。

解决方案
--------

首先，我们添加一个名为\ ``MathLogger``\ 的新\ ``INTERFACE``\ 库。

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/MathFunctions/MathLogger/CMakeLists.txt
  :caption: TODO 1: MathFunctions/MathLogger/CMakeLists.txt
  :name: MathFunctions/MathLogger/CMakeLists.txt-add_library
  :language: cmake
  :start-at: add_library
  :end-at: add_library

.. raw:: html

  </details>

然后，我们添加适当的\ :command:`target_sources`\ 调用来捕获头文件信息。我们将这个\
文件集命名为\ ``HEADERS``，这样我们可以省略\ ``TYPE``；我们不需要\ ``BASE_DIRS``，\
因为我们将使用当前源目录的默认值；并且我们可以排除\ ``FILES``\ 列表，因为我们不\
打算安装该库。

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/MathFunctions/MathLogger/CMakeLists.txt
  :caption: TODO 2: MathFunctions/MathLogger/CMakeLists.txt
  :name: MathFunctions/MathLogger/CMakeLists.txt-target_sources
  :language: cmake
  :start-at: target_sources(
  :end-at: )

.. raw:: html

  </details>

现在，我们可以将\ ``MathLogger``\ 库添加到\ ``MathFunctions``\ 的链接库中，并将\
``MathLogger``\ 文件夹添加到项目中。

.. raw:: html

  <details><summary>TODO 3-4: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :caption: TODO 3: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-link-mathlogger
  :language: cmake
  :start-at: target_link_libraries(
  :end-at: MathLogger
  :append: )

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :caption: TODO 4: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add-mathlogger
  :language: cmake
  :start-at: add_subdirectory(MathLogger
  :end-at: add_subdirectory(MathLogger

.. raw:: html

  </details>

最后，我们可以更新\ ``MathFunctions.cxx``\ 以利用新的日志记录器。

.. raw:: html

  <details><summary>TODO 5-7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step6/MathFunctions/MathFunctions.cxx
  :caption: TODO 5: MathFunctions/MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-mathlogger-header
  :language: c++
  :start-at: cmath
  :end-at: MathLogger

.. literalinclude:: Step6/MathFunctions/MathFunctions.cxx
  :caption: TODO 6: MathFunctions/MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-mathlogger-logger
  :language: c++
  :start-at: mathlogger::Logger Logger
  :end-at: mathlogger::Logger Logger

.. literalinclude:: Step6/MathFunctions/MathFunctions.cxx
  :caption: TODO 7: MathFunctions/MathFunctions.cxx
  :name: MathFunctions/MathFunctions.cxx-mathlogger-code
  :language: c++
  :start-at: Logger.Log(std::format("Computing sqrt of {} to be {}\n"
  :end-at: std::format
  :dedent: 4

.. raw:: html

  </details>

练习3 - 对象库
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

对象库有几种高级用法，但也有一些棘手的细微差别，在本教程的范围内难以完全列举。

.. code-block:: cmake

  add_library(MyObjects OBJECT)

对象库最明显的缺点是对象本身不能被传递链接。如果一个对象库出现在某个目标的\
:prop_tgt:`INTERFACE_LINK_LIBRARIES`\ 中，链接该目标的依赖项将无法“看到”这些对象。\
在这种情况下，对象库的行为将类似于\ ``INTERFACE``\ 库。一般来说，对象库仅适用于\
通过\ :command:`target_link_libraries`\ 进行\ ``PRIVATE``\ 或\ ``PUBLIC``\ 消费。

对象库的一个常见用例是将多个库目标合并为单个存档或共享库对象。即使在单个项目中，\
库也可能因各种原因被维护为不同的目标，例如属于组织内的不同团队。然而，将它们作为\
单个面向消费者的二进制文件分发可能是可取的。对象库使这成为可能。

目标
----

向\ ``MathFunctions``\ 库添加几个对象库。

参考资源
-----------------

* :command:`target_link_libraries`
* :command:`add_subdirectory`

待编辑文件
-------------

* ``MathFunctions/CMakeLists.txt``
* ``MathFunctions/MathFunctions.h``
* ``Tutorial/Tutorial.cxx``

Getting Started
---------------

Several extensions for our ``MathFunctions`` library have been made available
(we can imagine these coming from other teams in our organization). Take
a minute to look at the targets made available in ``MathFunctions/MathExtensions``.
Then complete ``TODO 8`` through ``TODO 11``.

Build and Run
-------------

There's no reconfiguration needed, we can build as usual.

.. code-block:: console

  cmake --build build

Verify the output of ``Tutorial`` now includes the verification message. Also
take a minute to inspect the build directory under
``build/MathFunctions/MathExtensions``. You should find that, unlike
``MathFunctions``, no archives are produced for any of the object libraries.

Solution
--------

First we will add links for all the object libraries to ``MathFunctions``.
These are ``PUBLIC``, because we want the objects to be added to the
``MathFunctions`` library as part of its own build step, and we want the
headers to be available to consumers of the library.

Then we add the ``MathExtensions`` subdirectoy to the project.

.. raw:: html

  <details><summary>TODO 8-9: Click to show/hide answer</summary>

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :caption: TODO 8: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-link-objects
  :language: cmake
  :start-at: target_link_libraries(
  :end-at: )

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :caption: TODO 9: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add-objs
  :language: cmake
  :start-at: add_subdirectory(MathExtensions
  :end-at: add_subdirectory(MathExtensions

.. raw:: html

  </details>


To make the extensions available to consumers, we include their headers in the
``MathFunctions.h`` header.

.. raw:: html

  <details><summary>TODO 10: Click to show/hide answer</summary>

.. literalinclude:: Step6/MathFunctions/MathFunctions.h
  :caption: TODO 10: MathFunctions/MathFunctions.h
  :name: MathFunctions/MathFunctions.h-include-objects
  :language: c++
  :start-at: OpAdd
  :end-at: OpSub

.. raw:: html

  </details>

Finally we can take advantage of the extensions in the ``Tutorial`` program.

.. raw:: html

  <details><summary>TODO 11: Click to show/hide answer</summary>

.. literalinclude:: Step6/Tutorial/Tutorial.cxx
  :caption: TODO 11: Tutorial/Tutorial.cxx
  :name: Tutorial/Tutorial.cxx-use-objects
  :language: c++
  :start-at: OpMul
  :end-at: checkValue);
  :dedent: 2

.. raw:: html

  </details>
