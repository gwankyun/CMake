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

Exercise 2 - Interface Libraries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Interface libraries are those which only communicate usage requirements for
other targets, they do not build or produce any artifacts of their own. As such
all the properties of an interface library must themselves be interface
properties, specified with the ``INTERFACE`` :ref:`scope keywords <Target Command Scope>`.

.. code-block:: cmake

  add_library(MyInterface INTERFACE)
  target_compile_definitions(MyInterface INTERFACE MYINTERFACE_COMPILE_DEF)

The most common kind of interface library in C++ development is a header-only
library. Such libraries do not build anything, only providing the flags
necessary to discover their headers.

Goal
----

Add a header-only library to the tutorial project, and use it inside the
``Tutorial`` executable.

Helpful Resources
-----------------

* :command:`add_library`
* :command:`target_sources`

Files to Edit
-------------

* ``MathFunctions/MathLogger/CMakeLists.txt``
* ``MathFunctions/CMakeLists.txt``
* ``MathFunctions/MathFunctions.cxx``

Getting Started
---------------

In our previous discussions of :command:`target_sources(FILE_SET)`, we noted
we can omit the ``TYPE`` parameter if the file set's name is the same as the
file set's type. We also said we can omit the ``BASE_DIRS`` parameter if
we want to use the current source directory as the only base directory.

We're ready to introduce a third shortcut, we only need to include the ``FILES``
parameter if the headers are intended to be installed, such as public headers
of a library.

The ``MathLogger`` headers in this exercise are only used internally by the
``MathFunctions`` implementation. They will not be installed. This should
make for a very abbreviated call to :command:`target_sources(FILE_SET)`.

.. note::
  The headers will be discovered by the compiler's dependency scanner to ensure
  correct incremental builds. It can be useful to list header files in these
  contexts anyway, as the list can be used to generate metadata some IDEs
  rely on.

You can begin editing the ``Step5`` directory. Complete ``TODO 1`` through
``TODO 7``.

Build and Run
-------------

The preset has already been updated to use ``mathfunctions::sqrt`` instead of
``std::sqrt``. We can build and configure as usual.

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

Verify that the ``Tutorial`` output now uses the logging framework.

Solution
--------

First we add a new ``INTERFACE`` library named ``MathLogger``.

.. raw:: html

  <details><summary>TODO 1: Click to show/hide answer</summary>

.. literalinclude:: Step6/MathFunctions/MathLogger/CMakeLists.txt
  :caption: TODO 1: MathFunctions/MathLogger/CMakeLists.txt
  :name: MathFunctions/MathLogger/CMakeLists.txt-add_library
  :language: cmake
  :start-at: add_library
  :end-at: add_library

.. raw:: html

  </details>

Then we add the appropriate :command:`target_sources` call to capture the
header information. We give this file set the name ``HEADERS`` so we can
omit the ``TYPE``, we don't need ``BASE_DIRS`` as we will use the default
of the current source directory, and we can exclude the ``FILES`` list because
we don't intend to install the library.

.. raw:: html

  <details><summary>TODO 2: Click to show/hide answer</summary>

.. literalinclude:: Step6/MathFunctions/MathLogger/CMakeLists.txt
  :caption: TODO 2: MathFunctions/MathLogger/CMakeLists.txt
  :name: MathFunctions/MathLogger/CMakeLists.txt-target_sources
  :language: cmake
  :start-at: target_sources(
  :end-at: )

.. raw:: html

  </details>

Now we can add the ``MathLogger`` library to the ``MathFunctions`` linked
libraries, and at the ``MathLogger`` folder to the project.

.. raw:: html

  <details><summary>TODO 3-4: Click to show/hide answer</summary>

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

Finally we can update ``MathFunctions.cxx`` to take advantage of the new logger.

.. raw:: html

  <details><summary>TODO 5-7: Click to show/hide answer</summary>

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

Exercise 3 - Object Libraries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Object libraries have several advanced uses, but also tricky nuances which
are difficult to fully enumerate in the scope of this tutorial.

.. code-block:: cmake

  add_library(MyObjects OBJECT)

The most obvious drawback to object libraries is the objects themselves cannot
be transitively linked. If an object library appears in the
:prop_tgt:`INTERFACE_LINK_LIBRARIES` of a target, the dependents which link that
target will not "see" the objects. The object library will act like an
``INTERFACE`` library in such contexts. In the general case, object libraries
are only suitable for ``PRIVATE`` or ``PUBLIC`` consumption via
:command:`target_link_libraries`.

A common use case for object libraries is coalescing several library targets
into a single archive or shared library object. Even within a single project
libraries may be maintained as different targets for a variety of reasons, such
as belonging to different teams within an organization. However, it may be
desirable to distribute these as a single consumer-facing binary. Object
libraries make this possible.

Goal
----

Add several object libraries to the ``MathFunctions`` library.

Helpful Resources
-----------------

* :command:`target_link_libraries`
* :command:`add_subdirectory`

Files to Edit
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
