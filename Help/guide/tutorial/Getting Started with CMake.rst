步骤1： CMake入门
==================================

CMake教程的第一步旨在作为使用CMake为小型项目编写实用构建脚本的快速入门。到最后，\
你将能够使用CMake描述可执行文件、库、源文件和头文件以及它们之间的链接关系。

本步骤中的每个练习都将从讨论该练习所需的概念和命令开始。然后，会提供一个目标和\
有用的资源列表。\ ``Files to Edit``\ 部分中的每个文件都位于\ ``Step1``\ 目录中，\
并包含一个或多个\ ``TODO``\ 注释。每个\ ``TODO``\ 代表需要修改或添加的一两行代码。\
这些\ ``TODOs``\ 应按数字顺序完成，先完成\ ``TODO 1``，然后是\ ``TODO 2``，依此类推。

.. note::
  教程中的每个步骤都建立在之前的步骤之上，但步骤并非严格连续。与学习CMake无关的\
  代码（例如C++函数实现或教程范围之外的CMake代码）有时会在步骤之间添加。

``Getting Started``\ 部分将提供一些有用的提示并指导你完成练习。然后\ ``Build and Run``\
部分将逐步介绍如何构建和测试练习。最后，在每个练习的末尾会回顾预期的解决方案。

背景
^^^^^^^^^^

CMake的典型用法围绕着一个或多个名为\ ``CMakeLists.txt``\ 的文件展开。此文件有时\
也被称为“列表文件”或“CML”。在特定的软件项目中，任何我们希望向CMake提供关于如何处\
理该目录或子目录中本地文件和操作的指令的目录中，都会存在一个\ ``CMakeLists.txt``\
文件。每个文件都包含一组命令，这些命令描述了与构建软件项目相关的一些信息或操作。

并非软件项目中的每个目录都需要CML，但强烈建议项目根目录包含一个。它将作为CMake\
在配置期间进行初始设置的入口点。这个\ *根*\ CML文件在文件顶部或附近应该始终包含\
两个相同的命令。

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.23)

  project(MyProjectName)

命令\ :command:`cmake_minimum_required`\ 是CMake向项目开发者提供的兼容性保证。\
调用它时，它确保CMake将采用列出版本的行为。如果在包含上述代码的CML上调用更高版本的\
CMake，它的行为将完全如同是CMake 3.23版本。

:command:`project`\ 命令在概念上是一个简单的命令，但却提供了复杂的功能。它告诉\
CMake，接下来是对一个具有给定名称的独立软件项目的描述（而不是类似shell的脚本）。\
当CMake看到\ :command:`project`\ 命令时，它会执行各种检查以确保环境适合构建软件；\
例如检查编译器和其他构建工具，以及发现主机和目标机器的字节序等属性。

.. note::
  虽然每个命令都提供了完整文档的链接，但并不要求读者理解他们使用的每个CMake命令\
  的全部语义。与学习任何软件一样，有效地学习CMake是一个渐进的过程。

本教程步骤的其余部分将主要关注四个命令的使用。\ :command:`add_executable`\ 和\
:command:`add_library`\ 命令用于描述软件项目想要生成的输出产物，\
:command:`target_sources`\ 命令用于将输入文件与其各自的输出产物相关联，以及\
:command:`target_link_libraries`\ 命令用于将输出产物彼此关联起来。

这四个命令是大多数CMake使用场景的核心。正如我们将了解到的，它们足以描述典型项目\
的大多数需求。

练习1 - 构建可执行文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

最基本的CMake项目是一个从单个源代码文件构建的可执行文件。对于这样的简单项目，\
只需要一个包含四个命令的\ ``CMakeLists.txt``\ 文件。

.. note::
  尽管CMake支持大写、小写和混合大小写的命令，但更推荐使用小写命令，并且在本教程\
  中将始终使用小写命令。

我们已经介绍了前两个命令：\ :command:`cmake_minimum_required`\ 和\ :command:`project`。\
在CMake使用中，根CML文件中的第一个命令必定是\ :command:`cmake_minimum_required`。\
虽然在一些高级用法中，\ :command:`project`\ 可能不是CML的第二个命令，但就我们的\
目的而言，它始终是第二个命令。

接下来我们需要的命令是\ :command:`add_executable`。\
这个命令会创建一个\ *目标*。在CMake术语中，目标是开发者为一组属性赋予的名称。

目标可能需要跟踪的一些属性示例包括:
  - 构件类型（可执行文件、库、头文件集合等）
  - 源文件
  - 包含目录
  - 可执行文件或库的输出名称
  - 依赖项
  - 编译器和链接器标志

CMake的机制通常最好被理解为对目标及其属性的描述和操作。目标的属性远不止这里列出的\
这些。CMake命令的文档通常会从它们所操作的目标属性的角度来讨论其功能。

Targets themselves are simply names, a handle to this collection of properties.
Using the :command:`add_executable` command is as easy as specifying the name
we want to use for the target.

.. code-block:: cmake

  add_executable(MyProgram)

Now that we have a name for our target, we can start associating properties
with it like source files we want to build and link. The primary command for
this is :command:`target_sources`, which takes as arguments a target name
followed by one or more collections of files.

.. code-block:: cmake

  target_sources(MyProgram
    PRIVATE
      main.cxx
  )

.. note::
  Paths in CMake are generally either absolute, or relative to the
  :variable:`CMAKE_CURRENT_SOURCE_DIR`. We haven't talked about variables like
  that yet, so you can read this as "relative to the location of the current
  CML".

Each collection of files is prefixed by a :ref:`scope keyword <Target Command Scope>`.
We'll discuss the complete semantics of these keywords when we talk about
linking targets together, but the quick explanation is these describe how a
property should be inherited by dependents of our target.

Typically, nothing depends on an executable. Other programs and libraries don't
need to link to an executable, or inherit headers, or anything of that nature.
So the appropriate scope to use here is ``PRIVATE``, which informs CMake that
this property only belongs to ``MyProgram`` and is not inheritable.

.. note::
  This rule is true almost everywhere. Outside advanced and esoteric usages,
  the scope keyword for executables should *always* be ``PRIVATE``. The same
  holds for implementation files generally, regardless of whether the target
  is an executable or a library. The only target which needs to "see" the
  ``.cxx`` files is the target building them.

Goal
----

Understand how to create a simple CMake project with a single executable.

Helpful Resources
-----------------

* :command:`project`
* :command:`cmake_minimum_required`
* :command:`add_executable`
* :command:`target_sources`

Files to Edit
-------------

* ``CMakeLists.txt``

Getting Started
----------------

The source code for ``Tutorial.cxx`` is provided in the
``Help/guide/tutorial/Step1/Tutorial`` directory and can be used to compute the
square root of a number. This file does not need to be edited in this exercise.

In the parent directory, ``Help/guide/tutorial/Step1``, is a ``CMakeLists.txt``
file which you will complete. Start with ``TODO 1`` and work through ``TODO 4``.

Build and Run
-------------

Once ``TODO 1`` through ``TODO 4`` have been completed, we are ready to build
and run our project! First, run the :manual:`cmake <cmake(1)>` executable or the
:manual:`cmake-gui <cmake-gui(1)>` to configure the project and then build it
with your chosen build tool.

For example, from the command line we could navigate to the
``Help/guide/tutorial/Step1`` directory and invoke CMake for configuration
as follows:

.. code-block:: console

  cmake -B build

The :option:`-B <cmake -B>` flag tells CMake to use the given relative
path as the location to generate files and store artifacts during the build
process. If it is omitted, the current working directory is used. It is
generally considered bad practice to do "in-source" builds, placing these
generated files in the source tree itself.

Next, tell CMake to build the project with
:option:`cmake --build <cmake --build>`, passing it the same relative path
we did with the :option:`-B <cmake -B>` flag.

.. code-block:: console

  cmake --build build

The ``Tutorial`` executable will be built into the ``build`` directory. For
multi-config generators (e.g. Visual Studio), it might be placed in a
subdirectory such as ``build/Debug``.

Finally, try to use the newly built ``Tutorial``:

.. code-block:: console

  Tutorial 4294967296
  Tutorial 10
  Tutorial

.. note::
  Depending on the shell, the correct syntax may be ``Tutorial``,
  ``./Tutorial``, ``.\Tutorial``, or even ``.\Tutorial.exe``. For simplicity,
  the exercises will use ``Tutorial`` throughout.

Solution
--------

As mentioned above, a four command ``CMakeLists.txt`` is all that we need to get
up and running. The first line should be :command:`cmake_minimum_required`, to
set the CMake version as follows:

.. raw:: html

  <details><summary>TODO 1: Click to show/hide answer</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-cmake_minimum_required
  :language: cmake
  :start-at: cmake_minimum_required
  :end-at: cmake_minimum_required

.. raw:: html

  </details>

The next step to make a basic project is to use the :command:`project`
command as follows to set the project name and inform CMake we intend to build
software with this ``CMakeLists.txt``.

.. raw:: html

  <details><summary>TODO 2: Click to show/hide answer</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-project
  :language: cmake
  :start-at: project
  :end-at: project

.. raw:: html

  </details>

Now we can setup our executable target for the Tutorial with :command:`add_executable`.

.. raw:: html

  <details><summary>TODO 3: Click to show/hide answer</summary>

.. literalinclude:: Step3/Tutorial/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-add_executable
  :language: cmake
  :start-at: add_executable
  :end-at: add_executable

.. raw:: html

  </details>

Finally, we can associate our source file with the Tutorial executable target
using :command:`target_sources`.

.. raw:: html

  <details><summary>TODO 4: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 4: CMakeLists.txt
  :name: CMakeLists.txt-target_sources

  target_sources(Tutorial
    PRIVATE
      Tutorial/Tutorial.cxx
  )


.. raw:: html

  </details>

Exercise 2 - Building a Library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We only need to introduce one more command to build a library,
:command:`add_library`. This works exactly like :command:`add_executable`, but
for libraries.

.. code-block:: cmake

  add_library(MyLibrary)

However, now is a good time to introduce header files. Header files are not
directly built as translation units, which is to say they are not a *build*
requirement. They are a *usage* requirement. We need to know about header files
in order to build other parts of a given target.

As such, header files are described slightly differently than implementation
files like ``tutorial.cxx``. They're also going to need different
:ref:`scope keywords <Target Command Scope>` than the ``PRIVATE`` keyword we
have used so far.

To describe a collection of header files, we're going to use what's known as a
``FILE_SET``.

.. code-block:: cmake

  target_sources(MyLibrary
    PRIVATE
      library_implementation.cxx

    PUBLIC
      FILE_SET myHeaders
      TYPE HEADERS
      BASE_DIRS
        include
      FILES
        include/library_header.h
  )

This is a lot of complexity, but we'll go through it point by point. First,
note that we have our implementation file as a ``PRIVATE`` source, same as
with the executable previously. However, we now use ``PUBLIC`` for our
header file. This allows consumers of our library to "see" the library's
header files.

.. note::
  We're not quite ready to discuss the full semantics of scope keywords. We'll
  cover them more completely in Exercise 3.

Following the scope keyword is a ``FILE_SET``, a collection of files to be
described as a single unit. A ``FILE_SET`` consists of the following parts:

* ``FILE_SET <name>`` is the name of the ``FILE_SET``. This is a handle which
  we can use to describe the collection in other contexts.

* ``TYPE <type>`` is the kind of files we are describing. Most commonly this
  will be headers, but newer versions of CMake support other types like C++20
  modules.

* ``BASE_DIRS`` is the "base" locations for the files. This can be most easily
  understood as the locations that will be described to compilers for header
  discovery via ``-I`` flags.

* ``FILES`` is the list of files, same as with the implementation sources list
  earlier.

This is a lot of information to describe, so there are some useful shortcuts
we can take. Notably, if the ``FILE_SET`` name is the same as the type, we
don't need to provide the ``TYPE`` field.

.. code-block:: cmake

  target_sources(MyLibrary
    PRIVATE
      library_implementation.cxx

    PUBLIC
      FILE_SET HEADERS
      BASE_DIRS
        include
      FILES
        include/library_header.h
  )

There are other shortcuts we can take, but we'll discuss those more in later
steps.

Goal
----

Build a library.

Helpful Resources
-----------------

* :command:`add_library`
* :command:`target_sources`

Files to Edit
-------------

* ``CMakeLists.txt``

Getting Started
---------------

Continue editing files in the ``Step1`` directory. Start with ``TODO 5`` and
complete through ``TODO 6``.

Build and Run
-------------

Let's build our project again. Since we already created a build directory and
ran CMake for Exercise 1, we can skip to the build step:

.. code-block:: console

  cmake --build build

We should be able to see our library created alongside the Tutorial executable.

Solution
--------

We start by adding the library target in the same manner as the the Tutorial
executable.

.. raw:: html

  <details><summary>TODO 5: Click to show/hide answer</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 5: CMakeLists.txt
  :name: CMakeLists.txt-add_library
  :language: cmake
  :start-at: add_library
  :end-at: add_library

.. raw:: html

  </details>

Next we need to describe the source files. For the implementation file,
``MathFunctions.cxx``, this is straight-forward; for the header file
``MathFunctions.h`` we will need to use a ``FILE_SET``.

We can either give this ``FILE_SET`` its own name, or use the shortcut of naming
it ``HEADERS``. For this tutorial, we'll be using the shortcut, but either
solution is valid.

For ``BASE_DIRS`` we need to determine the directory which will allow for the
desired ``#include <MathFunctions.h>`` directive. To achieve this, the
``MathFunctions`` folder itself will be a base directory. We would make a
different choice if the desired include directive were
``#include <MathFunctions/MathFunctions.h>`` or similar.

.. raw:: html

  <details><summary>TODO 6: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-library_sources

  target_sources(MathFunctions
    PRIVATE
      MathFunctions/MathFunctions.cxx

    PUBLIC
      FILE_SET HEADERS
      BASE_DIRS
        MathFunctions
      FILES
        MathFunctions/MathFunctions.h
  )

.. raw:: html

  </details>

Exercise 3 - Linking Together Libraries and Executables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We're ready to combine our library with our executable, for this we must
introduce a new command, :command:`target_link_libraries`. The name of this
command can be somewhat misleading, as it does a great deal more than just
invoke linkers. It describes relationships between targets generally.

.. code-block:: cmake

  target_link_libraries(MyProgram
    PRIVATE
      MyLibrary
  )

We're finally ready to discuss the :ref:`scope keywords <Target Command Scope>`.
There are three of them, ``PRIVATE``, ``INTERFACE``, and ``PUBLIC``. These
describe how properties are made available to targets.

* A ``PRIVATE`` property (also called a "non-interface" property) is only
  available to the target which owns it, for example ``PRIVATE`` headers will
  only be visible to the target they're attached to.

* An ``INTERFACE`` property is only available to targets *which link* the
  owning target. The owning target does not have access to these properties. A
  header-only library is an example of a collection of ``INTERFACE`` properties,
  as header-only libraries do not build anything themselves and do not need to
  access their own files.

* ``PUBLIC`` is not a distinct kind of property, but rather is the union of the
  ``PRIVATE`` and ``INTERFACE`` properties. Thus requirements described with
  ``PUBLIC`` are available to both the owning target and consuming targets.

Consider the following concrete example:

.. code-block:: cmake

  target_sources(MyLibrary
    PRIVATE
      FILE_SET internalOnlyHeaders
      TYPE HEADERS
      FILES
        InternalOnlyHeader.h

    INTERFACE
      FILE_SET consumerOnlyHeaders
      TYPE HEADERS
      FILES
        ConsumerOnlyHeader.h

    PUBLIC
      FILE_SET publicHeaders
      TYPE HEADERS
      FILES
        PublicHeader.h
  )

.. note::
  We excluded ``BASE_DIRS`` for each file set here, that's another shortcut.
  When excluded, ``BASE_DIRS`` defaults to the current source directory.

The ``MyLibrary`` target has several properties which will be modified by this
call to :command:`target_sources`. Until now we've used the term "properties"
generically, but properties are themselves named values we can reason about.
Two specific properties which will be modified here are :prop_tgt:`HEADER_SETS`
and :prop_tgt:`INTERFACE_HEADER_SETS`, which both contain lists of header file
sets added via :command:`target_sources`.

The value ``internalOnlyHeaders`` will be added to :prop_tgt:`HEADER_SETS`,
``consumerOnlyHeaders`` to :prop_tgt:`INTERFACE_HEADER_SETS`, and
``publicHeaders`` will be added to both.

When a given target is being built, it will use its own *non-interface*
properties (eg, :prop_tgt:`HEADER_SETS`), combined with the *interface*
properties of any targets it links to (eg, :prop_tgt:`INTERFACE_HEADER_SETS`).

.. note::
  **It is not necessary to reason about CMake properties at this level of
  detail.** The above is described for completeness. Most of the time you don't
  need to be concerned with the specific properties a command is modifying.

  Scope keywords have a simple intuition associated with them, when considering
  a command from the point of view of the target it is being applied to:
  **PRIVATE** is for me, **INTERFACE** is for others, **PUBLIC** is for all of
  us.

Goal
----

In the Tutorial executable, use the ``sqrt()`` function provided by the
``MathFunctions`` library.

Helpful Resources
-----------------

* :command:`target_link_libraries`

Files to Edit
-------------

* ``CMakeLists.txt``
* ``Tutorial/Tutorial.cxx``

Getting Started
---------------

Continue to edit files from ``Step1``. Start on ``TODO 7`` and complete through
``TODO 9``. In this exercise, we need to add the ``MathFunctions`` target to
the ``Tutorial`` target's linked libraries using :command:`target_link_libraries`.

After modifying the CML, update ``tutorial.cxx`` to use the
``mathfunctions::sqrt()`` function instead of ``std::sqrt``.

Build and Run
-------------

Let's build our project again. As before, we already created a build directory
and ran CMake so we can skip to the build step:

.. code-block:: console

  cmake --build build

Verify that the output matches what you would expect from the ``MathFunctions``
library.

Solution
--------

In this exercise, we are describing the ``Tutorial`` executable as a consumer
of the ``MathFunctions`` target by adding ``MathFunctions`` to the linked
libraries of the ``Tutorial``.

To achieve this, we modify ``CMakeLists.txt`` file to use the
:command:`target_link_libraries` command, using ``Tutorial`` as the target to
be modified and ``MathFunctions`` as the library we want to add.

.. raw:: html

  <details><summary>TODO 7: Click to show/hide answer</summary>

.. literalinclude:: Step3/Tutorial/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries
  :language: cmake
  :start-at: target_link_libraries(Tutorial
  :end-at: )

.. raw:: html

  </details>

.. note::
  The order here is only loosely relevant. That we call
  :command:`target_link_libraries` prior to defining ``MathFunctions`` with
  :command:`add_library` doesn't matter to CMake. We are recording that
  ``Tutorial`` has a dependency on something named ``MathFunctions``, but what
  ``MathFunctions`` means isn't resolved at this stage.

  The only target which needs to be defined when calling a CMake command like
  :command:`target_sources` or :command:`target_link_libraries` is the target
  being modified.

Finally, all that's left to do is modify ``Tutorial.cxx`` to use the newly
provided ``mathfunctions::sqrt`` function. That means adding the appropriate
header file and modifying our ``sqrt()`` call.

.. raw:: html

  <details><summary>TODO 8-9: Click to show/hide answer</summary>

.. literalinclude:: Step3/Tutorial/Tutorial.cxx
  :caption: TODO 8: Tutorial/Tutorial.cxx
  :name: Tutorial/Tutorial.cxx-MathFunctions-headers
  :language: c++
  :start-at: iostream
  :end-at: MathFunctions.h

.. literalinclude:: Step3/Tutorial/Tutorial.cxx
  :caption: TODO 9: Tutorial/Tutorial.cxx
  :name: Tutorial/Tutorial.cxx-MathFunctions-code
  :language: c++
  :start-at: calculate square root
  :end-at: mathfunctions::sqrt
  :dedent: 2

.. raw:: html

  </details>

Exercise 4 - Subdirectories
^^^^^^^^^^^^^^^^^^^^^^^^^^^

As we move through the tutorial, we will be adding more commands to manipulate
the ``Tutorial`` executable and the ``MathFunctions`` library. We want to make
sure we keep commands local to the files they are dealing with. While not a
major concern for a small project like this, it can be very useful for large
projects with many targets and thousands of files.

The :command:`add_subdirectory` command allows us to incorporate CMLs located
in subdirectories of the project.

.. code-block:: cmake

  add_subdirectory(SubdirectoryName)

When a ``CMakeLists.txt`` in a subdirectory is being processed by CMake all
relative paths described in the subdirectory CML are relative to that
subdirectory, not the top-level CML.

Goal
----

Use :command:`add_subdirectory` to organize the project.

Helpful Resources
-----------------

* :command:`add_subdirectory`

Files to Edit
-------------

* ``CMakeLists.txt``
* ``Tutorial/CMakeLists.txt``
* ``MathFunctions/CMakeLists.txt``

Getting Started
---------------

The ``TODOs`` for this step are spread across three ``CMakeLists.txt`` files.
Be sure to pay attention to the path changes necessary when moving the
:command:`target_sources` commands into subdirectories.

.. note::
  Previously we said that ``BASE_DIRS`` defaults to the current source
  directory. As the desired include directory for ``MathFunctions`` will now be
  the same directory as the CML calling :command:`target_sources`, we should
  remove the ``BASE_DIRS`` keyword and argument entirely.

Complete ``TODO 10`` through ``TODO 13``.

Build and Run
-------------

Because of the reorganization, we'll need to clean the original build
directory prior to rebuilding (otherwise our new ``Target`` build folder would
conflict with our previously created ``Target`` executable). We can achieve
this with the :option:`--clean-first <cmake--build --clean-first>` flag.

There's no need for a reconfiguration. CMake will automatically
re-configure itself due to the changes in the CMLs.

.. code-block:: console

  cmake --build build --clean-first

.. note::
  Our executable and library will be output to a new location in the build tree.
  A subdirectory which mirrors where :command:`add_executable` and
  :command:`add_library` were called in the source tree. You will need to
  navigate to this subdirectory in the build tree to run the tutorial
  executable in future steps.

  You can verify this behavior by deleting the old ``Tutorial`` executable,
  and observing that the new one is produced at ``Tutorial/Tutorial``.

Solution
--------

We need to move all the commands concerning the ``Tutorial`` executable into
``Tutorial/CMakeLists.txt``, and replace them with an
:command:`add_subdirectory` command. We also need to update the path for
``Tutorial.cxx``.

.. raw:: html

  <details><summary>TODO 10-11: Click to show/hide answer</summary>

.. literalinclude:: Step3/Tutorial/CMakeLists.txt
  :caption: TODO 10: Tutorial/CMakeLists.txt
  :name: Tutorial/CMakeLists.txt-moved
  :language: cmake

.. code-block:: cmake
  :caption: TODO 11: CMakeLists.txt
  :name: CMakeLists.txt-add_subdirectory-Tutorial

  add_subdirectory(Tutorial)

.. raw:: html

  </details>

We need to do the same with the commands for ``MathFunctions``, changing the
relative paths as appropriate and removing ``BASE_DIRS`` as it is no longer
necessary, the default value will work.

.. raw:: html

  <details><summary>TODO 12-13: Click to show/hide answer</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 12: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-moved
  :language: cmake

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 13: CMakeLists.txt
  :name: CMakeLists.txt-add_subdirectory-MathFunctions
  :language: cmake
  :start-at: add_subdirectory(MathFunctions
  :end-at: add_subdirectory(MathFunctions

.. raw:: html

  </details>
