步骤1：一个基本的起点
==============================

我从哪里开始使用CMake？这一步将介绍CMake的一些基本语法、命令和变量。\
随着这些概念的介绍，我们将完成三个练习并创建一个简单的CMake项目。

这一步中的每个练习都将从一些背景信息开始。然后，提供了一个目标和有用的资源列表。\
``待编辑的文件``\ 部分中的每个文件都位于\ ``Step1``\ 目录中，并包含一个或多个\ ``TODO``\ 注释。\
每个\ ``TODO``\ 表示要更改或添加的一到两行代码。这些\ ``TODO``\ 将按数字顺序完成，\
首先完成\ ``TODO 1``，然后完成\ ``TODO 2``，以此类推。\ ``Getting Started``\ 部分将提供一些有用的提示并指导你完成练习。\
然后，\ ``Build and Run``\ 部分将逐步介绍如何构建和测试该练习。最后，在每次练习结束时讨论预期的解决方案。

还要注意，教程中的每个步骤都是建立在下一个步骤之上的。因此，如 \ ``Step2``\ 的开始代码就是\ ``Step1``\ 的完整解决方案。

练习1 - 创建一个基本项目
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

最基本的CMake项目是从单个源代码文件构建的可执行文件。对于像这样的简单项目，只需要一个带有三个命令的\ ``CMakeLists.txt``\ 文件。

**注意：**\ 尽管CMake支持大写、小写和混合大小写命令，但小写命令是首选，并将在整个教程中使用。

任何项目的最顶层的CMakeLists.txt必须通过使用\ :command:`cmake_minimum_required`\ 命令指定最小的CMake版本开始。\
这将建立策略设置，并确保随后的CMake函数在CMake的兼容版本中运行。

要启动一个项目，我们使用\ :command:`project`\ 命令来设置项目名称。每个项目都需要这个调用，应紧随\ :command:`cmake_minimum_required`\ 其后。\
正如我们稍后将看到的，该命令还可以用于指定其他项目级别的信息，如语言或版本号。

最后，:command:`add_executable`\ 命令告诉CMake使用指定的源代码文件创建一个可执行文件。

目标
----

了解如何创建一个简单的CMake项目。

有用的资源
-----------------

* :command:`add_executable`
* :command:`cmake_minimum_required`
* :command:`project`

待编辑的文件
-------------

* ``CMakeLists.txt``

开始
----------------

``tutorial.cxx``\ 的源代码在\ ``Help/guide/tutorial/Step1``\ 目录中提供，可用于计算一个数的平方根。在此步骤中不需要编辑此文件。

在同一个目录中有一个待你完成的\ ``CMakeLists.txt``\ 文件。从\ ``TODO 1``\ 开始，真到\ ``TODO 3``。

构建和运行
-------------

Once ``TODO 1`` through ``TODO 3`` have been completed, we are ready to build
and run our project! First, run the :manual:`cmake <cmake(1)>` executable or the
:manual:`cmake-gui <cmake-gui(1)>` to configure the project and then build it
with your chosen build tool.

例如，我们可以在命令行中导航到CMake源代码树的\ ``Help/guide/tutorial``\ 目录，并创建一个构建目录：

.. code-block:: console

  mkdir Step1_build

Next, navigate to that build directory and run
:manual:`cmake <cmake(1)>` to configure the project and generate a native build
system:

.. code-block:: console

  cd Step1_build
  cmake ../Step1

然后调用构建系统来实际编译/链接项目：

.. code-block:: console

  cmake --build .

最后，试着用以下命令来使用新构建的\ ``Tutorial``：

.. code-block:: console

  Tutorial 4294967296
  Tutorial 10
  Tutorial

Solution
--------

As mentioned above, a three line ``CMakeLists.txt`` is all that we need to get
up and running. The first line is to use :command:`cmake_minimum_required` to
set the CMake version as follows:

.. raw:: html

  <details><summary>TODO 1: Click to show/hide answer</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-cmake_minimum_required
  :language: cmake
  :end-before: # 设置工程名和版本号

.. raw:: html

  </details>

The next step to make a basic project is to use the :command:`project`
command as follows to set the project name:

.. raw:: html

  <details><summary>TODO 2: Click to show/hide answer</summary>

.. code-block:: cmake
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-project

  project(Tutorial)

.. raw:: html

  </details>

The last command to call for a basic project is
:command:`add_executable`. We call it as follows:

.. raw:: html

  <details><summary>TODO 3: Click to show/hide answer</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-add_executable
  :language: cmake
  :start-after: # add the executable
  :end-before: # TODO 9:

.. raw:: html

  </details>

Exercise 2 - Specifying the C++ Standard
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CMake has some special variables that are either created behind the scenes or
have meaning to CMake when set by project code. Many of these variables start
with ``CMAKE_``. Avoid this naming convention when creating variables for your
projects. Two of these special user settable variables are
:variable:`CMAKE_CXX_STANDARD` and :variable:`CMAKE_CXX_STANDARD_REQUIRED`.
These may be used together to specify the C++ standard needed to build the
project.

Goal
----

Add a feature that requires C++11.

Helpful Resources
-----------------

* :variable:`CMAKE_CXX_STANDARD`
* :variable:`CMAKE_CXX_STANDARD_REQUIRED`
* :command:`set`

Files to Edit
-------------

* ``CMakeLists.txt``
* ``tutorial.cxx``

Getting Started
---------------

Continue editing files in the ``Step1`` directory. Start with ``TODO 4`` and
complete through ``TODO 6``.

First, edit ``tutorial.cxx`` by adding a feature that requires C++11. Then
update ``CMakeLists.txt`` to require C++11.

Build and Run
-------------

Let's build our project again. Since we already created a build directory and
ran CMake for Exercise 1, we can skip to the build step:

.. code-block:: console

  cd Step1_build
  cmake --build .

Now we can try to use the newly built ``Tutorial`` with same commands as
before:

.. code-block:: console

  Tutorial 4294967296
  Tutorial 10
  Tutorial

Solution
--------

We start by adding some C++11 features to our project by replacing
``atof`` with ``std::stod`` in ``tutorial.cxx``. This looks like
the following:

.. raw:: html

  <details><summary>TODO 4: Click to show/hide answer</summary>

.. literalinclude:: Step2/tutorial.cxx
  :caption: TODO 4: tutorial.cxx
  :name: tutorial.cxx-cxx11
  :language: c++
  :start-after: // 将输入转换为double类型
  :end-before: // TODO 12:

.. raw:: html

  </details>

To complete ``TODO 5``, simply remove ``#include <cstdlib>``.

We will need to explicitly state in the CMake code that it should use the
correct flags. One way to enable support for a specific C++ standard in CMake
is by using the :variable:`CMAKE_CXX_STANDARD` variable. For this tutorial, set
the :variable:`CMAKE_CXX_STANDARD` variable in the ``CMakeLists.txt`` file to
``11`` and :variable:`CMAKE_CXX_STANDARD_REQUIRED` to ``True``. Make sure to
add the :variable:`CMAKE_CXX_STANDARD` declarations above the call to
:command:`add_executable`.

.. raw:: html

  <details><summary>TODO 6: Click to show/hide answer</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-CXX_STANDARD
  :language: cmake
  :start-after: # 指定C++标准
  :end-before: # TODO 7:

.. raw:: html

  </details>

Exercise 3 - Adding a Version Number and Configured Header File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes it may be useful to have a variable that is defined in your
``CMakelists.txt`` file also be available in your source code. In this case, we
would like to print the project version.

One way to accomplish this is by using a configured header file. We create an
input file with one or more variables to replace. These variables have special
syntax which looks like ``@VAR@``.
Then, we use the :command:`configure_file` command to copy the input file to a
given output file and replace these variables with the current value of ``VAR``
in the ``CMakelists.txt`` file.

While we could edit the version directly in the source code, using this
feature is preferred since it creates a single source of truth and avoids
duplication.

Goal
----

Define and report the project's version number.

Helpful Resources
-----------------

* :variable:`<PROJECT-NAME>_VERSION_MAJOR`
* :variable:`<PROJECT-NAME>_VERSION_MINOR`
* :command:`configure_file`
* :command:`target_include_directories`

Files to Edit
-------------

* ``CMakeLists.txt``
* ``tutorial.cxx``

Getting Started
---------------

Continue to edit files from ``Step1``. Start on ``TODO 7`` and complete through
``TODO 12``. In this exercise, we start by adding a project version number in
``CMakeLists.txt``. In that same file, use :command:`configure_file` to copy a
given input file to an output file and substitute some variable values in the
input file content.

Next, create an input header file ``TutorialConfig.h.in`` defining version
numbers which will accept variables passed from :command:`configure_file`.

Finally, update ``tutorial.cxx`` to print out its version number.

Build and Run
-------------

Let's build our project again. As before, we already created a build directory
and ran CMake so we can skip to the build step:

.. code-block:: console

  cd Step1_build
  cmake --build .

Verify that the version number is now reported when running the executable
without any arguments.

Solution
--------

In this exercise, we improve our executable by printing a version number.
While we could do this exclusively in the source code, using ``CMakeLists.txt``
lets us maintain a single source of data for the version number.

First, we modify the ``CMakeLists.txt`` file to use the
:command:`project` command to set both the project name and version number.
When the :command:`project` command is called, CMake defines
``Tutorial_VERSION_MAJOR`` and ``Tutorial_VERSION_MINOR`` behind the scenes.

.. raw:: html

  <details><summary>TODO 7: Click to show/hide answer</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-project-VERSION
  :language: cmake
  :start-after: # 设置工程名和版本号
  :end-before: # 指定C++标准

.. raw:: html

  </details>

Then we used :command:`configure_file` to copy the input file with the
specified CMake variables replaced:

.. raw:: html

  <details><summary>TODO 8: Click to show/hide answer</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 8: CMakeLists.txt
  :name: CMakeLists.txt-configure_file
  :language: cmake
  :start-after: # to the source code
  :end-before: # TODO 8:

.. raw:: html

  </details>

Since the configured file will be written into the project binary
directory, we must add that directory to the list of paths to search for
include files.

**Note:** Throughout this tutorial, we will refer to the project build and
the project binary directory interchangeably. These are the same and are not
meant to refer to a `bin/` directory.

We used :command:`target_include_directories` to specify
where the executable target should look for include files.

.. raw:: html

  <details><summary>TODO 9: Click to show/hide answer</summary>

.. literalinclude:: Step2/CMakeLists.txt
  :caption: TODO 9: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories
  :language: cmake
  :start-after: # so that we will find TutorialConfig.h

.. raw:: html

  </details>

``TutorialConfig.h.in`` is the input header file to be configured.
When :command:`configure_file` is called from our ``CMakeLists.txt``, the
values for ``@Tutorial_VERSION_MAJOR@`` and ``@Tutorial_VERSION_MINOR@`` will
be replaced with the corresponding version numbers from the project in
``TutorialConfig.h``.

.. raw:: html

  <details><summary>TODO 10: Click to show/hide answer</summary>

.. literalinclude:: Step2/TutorialConfig.h.in
  :caption: TODO 10: TutorialConfig.h.in
  :name: TutorialConfig.h.in
  :language: c++
  :end-before: // TODO 13:

.. raw:: html

  </details>

Next, we need to modify ``tutorial.cxx`` to include the configured header file,
``TutorialConfig.h``.

.. raw:: html

  <details><summary>TODO 11: Click to show/hide answer</summary>

.. code-block:: c++
  :caption: TODO 11: tutorial.cxx

  #include "TutorialConfig.h"

.. raw:: html

  </details>

Finally, we print out the executable name and version number by updating
``tutorial.cxx`` as follows:

.. raw:: html

  <details><summary>TODO 12: Click to show/hide answer</summary>

.. literalinclude:: Step2/tutorial.cxx
  :caption: TODO 12 : tutorial.cxx
  :name: tutorial.cxx-print-version
  :language: c++
  :start-after: {
  :end-before: // 将输入转换为double类型

.. raw:: html

  </details>
