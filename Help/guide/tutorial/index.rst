CMake教程
**************

.. only:: html

   .. contents::

引言
============

CMake教程提供了一个循序渐进的指南，涵盖了CMake帮助解决的常见构建系统问题。了解示例项目中各种主题是如何一起工作的可能会非常有帮助。教程文档和示例的源代码可以在CMake源代码树的 ``Help/guide/tutorial`` 目录中找到。每个步骤都有自己的子目录，其中包含可以用作起点的代码。教程示例是渐进的，因此每个步骤都为前一个步骤提供完整的解决方案。

一个基本的起点（第1步）
===============================

最基本的项目是由源代码文件构建的可执行文件。对于简单的项目，只需要一个三行 ``CMakeLists.txt`` 文件。这将是我们教程的起点。在 ``Step1`` 目录创建一个 ``CMakeLists.txt`` 文件，如下所示：

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.10)

  # set the project name
  project(Tutorial)

  # add the executable
  add_executable(Tutorial tutorial.cxx)


注意，这个例子在 ``CMakeLists.txt`` 文件中使用了小写命令。CMake支持大小写混合命令。 ``tutorial.cxx`` 的源代码在 ``Step1`` 目录中提供，可以用来计算一个数字的平方根。

添加版本号和配置的头文件
--------------------------------------------------

我们要添加的第一个特性是为我们的可执行文件和项目提供一个版本号。虽然在源码就能做到，但 ``CMakeLists.txt`` 更灵活。

首先，修改 ``CMakeLists.txt`` 文件，使用 :command:`project` 命令设置项目名称和版本号。

.. literalinclude:: Step2/CMakeLists.txt
  :language: cmake
  :end-before: # specify the C++ standard

然后，配置一个头文件来将版本号传递给源代码：

.. literalinclude:: Step2/CMakeLists.txt
  :language: cmake
  :start-after: # to the source code
  :end-before: # add the executable

由于配置的文件将被写入到二进制目录中，所以我们必须将该目录添加到搜索包含文件的路径列表中。在 ``CMakeLists.txt`` 文件的末尾添加以下行：

.. literalinclude:: Step2/CMakeLists.txt
  :language: cmake
  :start-after: # so that we will find TutorialConfig.h

用你喜欢的编辑器，在源目录中创建 ``TutorialConfig.h.in``，内容如下:

.. literalinclude:: Step2/TutorialConfig.h.in
  :language: cmake

当CMake配置这个头文件时，``@Tutorial_VERSION_MAJOR@`` 和 ``@Tutorial_VERSION_MINOR@`` 的值将被替换。

下一步，修改 ``tutorial.cxx`` 以包含已配置的头文件 ``TutorialConfig.h``。

最后，让我们通过更新 ``tutorial.cxx`` 来打印出可执行文件的名称和版本号，如下：

.. literalinclude:: Step2/tutorial.cxx
  :language: c++
  :start-after: {
  :end-before: // convert input to double

指定c++标准
-------------------------

接下来，让我们通过替换 ``tutorial.cxx`` 中的 ``atof`` 为 ``std::stod``，为我们的项目添加一些c++ 11特性。同时，删除 ``#include <cstdlib>``。

.. literalinclude:: Step2/tutorial.cxx
  :language: c++
  :start-after: // convert input to double
  :end-before: // calculate square root

我们需要在CMake代码中明确声明它应该使用正确的标志。在CMake中启用对特定C++标准的支持的最简单方法是使用 :variable:`CMAKE_CXX_STANDARD` 变量。对于本教程，将 ``CMakeLists.txt`` 文件中的 :variable:`CMAKE_CXX_STANDARD` 变量设置为11， :variable:`CMAKE_CXX_STANDARD_REQUIRED` 设置为True。确保 ``CMAKE_CXX_STANDARD`` 在调用 ``add_executable`` 前声明。

.. literalinclude:: Step2/CMakeLists.txt
  :language: cmake
  :end-before: # configure a header file to pass some of the CMake settings

构建和测试
--------------

运行 :manual:`cmake <cmake(1)>` 可执行文件或 :manual:`cmake-gui <cmake-gui(1)>` 来配置项目，然后用你选择的构建工具构建它。

例如，我们可以从命令行导航到CMake源代码树的 ``Help/guide/tutorial`` 目录，并创建一个构建目录：

.. code-block:: console

  mkdir Step1_build

接下来，导航到build目录，运行CMake来配置项目并生成一个本地构建系统：

.. code-block:: console

  cd Step1_build
  cmake ../Step1

然后调用构建系统来实际编译/链接项目：

.. code-block:: console

  cmake --build .

最后，尝试用以下命令来使用新构建的 ``Tutorial``：

.. code-block:: console

  Tutorial 4294967296
  Tutorial 10
  Tutorial

添加库（第2步）
=========================

现在我们将向我们的项目添加一个库。这个库将包含我们自己的计算数字平方根的实现。可执行文件可以使用这个库，而不是编译器提供的标准平方根函数。

在本教程中，我们将把这个库放入名为 ``MathFunctions`` 的子目录中。这个目录已经包含了一个头文件 ``MathFunctions.h`` 和一个源文件 ``mysqrt.cxx``。源文件有一个名为 ``mysqrt`` 的函数，功能类似于自带的 ``sqrt`` 函数。

将以下这个一行的 ``CMakeLists.txt`` 文件添加到 ``MathFunctions`` 目录：

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :language: cmake

为了使用这个新库，我们将在顶层的 ``CMakeLists.txt`` 文件中添加一个 :command:`add_subdirectory` 调用，以便构建这个库。我们将新库添加到可执行文件中，并将  ``MathFunctions`` 作为包含目录添加，以便能够找到 ``mysqrt.h`` 头文件。顶层  ``CMakeLists.txt`` 文件的最后几行现在应该是这样的：

.. code-block:: cmake

        # add the MathFunctions library
        add_subdirectory(MathFunctions)

        # add the executable
        add_executable(Tutorial tutorial.cxx)

        target_link_libraries(Tutorial PUBLIC MathFunctions)

        # add the binary tree to the search path for include files
        # so that we will find TutorialConfig.h
        target_include_directories(Tutorial PUBLIC
                                  "${PROJECT_BINARY_DIR}"
                                  "${PROJECT_SOURCE_DIR}/MathFunctions"
                                  )

现在让我们使MathFunctions库成为可选的。虽然在本教程中没有必要这样做，但对于大型项目来说，这是很常见的情况。第一步是向顶层 ``CMakeLists.txt`` 文件添加一个选项。

.. literalinclude:: Step3/CMakeLists.txt
  :language: cmake
  :start-after: # should we use our own math functions
  :end-before: # add the MathFunctions library

这个选项将在 :manual:`cmake-gui <cmake-gui(1)>` 和 :manual:`ccmake <ccmake(1)>` 中显示，默认值ON可以由用户更改。该设置将存储在缓存中，这样用户在每次在构建目录上运行CMake时就不需要设置该值。

下一个更改是使构建和链接MathFunctions库成为有条件的。为此，我们将顶层 ``CMakeLists.txt`` 文件的结尾修改为如下所示：

.. literalinclude:: Step3/CMakeLists.txt
  :language: cmake
  :start-after: # add the MathFunctions library

注意，这里用了变量 ``EXTRA_LIBS`` 来收集任何可选库，以便稍后链接到可执行文件中。变量 ``EXTRA_INCLUDES`` 类似地用于可选头文件。在处理许多可选组件时，这是一种传统方法，我们将在下一步讨论现代方法。

对源代码的相应更改相当简单。首先，在 ``tutorial.cxx`` 中，在需要的时候包含 ``MathFunctions.h`` 头文件：

.. literalinclude:: Step3/tutorial.cxx
  :language: c++
  :start-after: // should we include the MathFunctions header
  :end-before: int main

然后，在同一个文件中，让 ``USE_MYMATH`` 控制使用哪个平方根函数：

.. literalinclude:: Step3/tutorial.cxx
  :language: c++
  :start-after: // which square root function should we use?
  :end-before: std::cout << "The square root of

由于源代码现在需要 ``USE_MYMATH`` ，我们可以通过以下一行把它添加到 ``TutorialConfig.h.in`` 中：

.. literalinclude:: Step3/TutorialConfig.h.in
  :language: c
  :lines: 4

**练习**：为什么在 ``USE_MYMATH`` 选项后面配置 ``TutorialConfig.h.in`` 很重要？如果我们把这两个颠倒过来会发生什么？

运行 :manual:`cmake  <cmake(1)>` 可执行文件或 :manual:`cmake-gui <cmake-gui(1)>` 来配置项目，用你选择的构建工具构建它。然后运行Tutorial可执行文件。

现在让我们更新 ``USE_MYMATH`` 的值。最简单的方法是使用 :manual:`cmake-gui <cmake-gui(1)>` 或者终端环境上的 :manual:`ccmake <ccmake(1)>`。如果你想从命令行更改选项，试试：

.. code-block:: console

  cmake ../Step2 -DUSE_MYMATH=OFF

重新生成并再次运行。

哪个函数给出了更好的结果，sqrt还是mysqrt？

添加库的使用需求（第3步）
==============================================

使用需求允许对库或可执行文件的链接和include行进行更好的控制，同时也允许对CMake内部目标的传递属性进行更多的控制。利用使用需求的主要命令是：

  - :command:`target_compile_definitions`
  - :command:`target_compile_options`
  - :command:`target_include_directories`
  - :command:`target_link_libraries`

让我们从 `添加库（第2步）`_ 开始重构代码，以使用现代的CMake方法满足使用需求。我们首先声明，任何链接到MathFunctions的人都需要包括当前的源目录，而MathFunctions本身不需要。因此，这可以成为一个 ``INTERFACE`` 使用要求。

记住 ``INTERFACE`` 指的是消费者需要但生产者不需要的东西。在 ``MathFunctions/CMakeLists.txt`` 的末尾添加以下几行：

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # to find MathFunctions.h

现在我们已经指定了MathFunctions的使用要求，我们可以安全地从顶层的 ``CMakeLists.txt`` 中删除 ``EXTRA_INCLUDES`` 变量的使用，这里：

.. literalinclude:: Step4/CMakeLists.txt
  :language: cmake
  :start-after: # add the MathFunctions library
  :end-before: # add the executable

和这里：

.. literalinclude:: Step4/CMakeLists.txt
  :language: cmake
  :start-after: # so that we will find TutorialConfig.h

一旦完成，运行 :manual:`cmake  <cmake(1)>` 命令或者 :manual:`cmake-gui <cmake-gui(1)>` 来配置项目，然后用你选择的构建工具或使用 ``cmake --build .`` 在构建目录来构建它。

安装和测试（第4步）
===============================

现在我们可以开始向我们的项目添加安装规则和测试支持了。

安装规则
-------------

安装规则相当简单：对于MathFunctions，我们希望安装库和头文件，对于应用程序，我们希望安装可执行和配置的头文件。

所以在 ``MathFunctions/CMakeLists.txt`` 的末尾添加：

.. literalinclude:: Step5/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # install rules

顶层 ``CMakeLists.txt`` 的末尾添加：

.. literalinclude:: Step5/CMakeLists.txt
  :language: cmake
  :start-after: # add the install targets
  :end-before: # enable testing

这就是创建基本本地安装的全部内容。

现在可以运行 :manual:`cmake  <cmake(1)>` 或者 :manual:`cmake-gui <cmake-gui(1)>` 来配置并用构建工具来构建它。

接着使用 :manual:`cmake  <cmake(1)>` 命令的 ``install`` 选项（3.15版本开始，之前版本的CMake必须使用 ``make install``）在命令行安装。对于多配置的工具，记得用 ``--config`` 来指定配置。若使用IDE，只需构建 ``INSTALL`` 目标。这一步将安装相应的头文件、库和可执行文件，例子：

.. code-block:: console

  cmake --install .

:variable:`CMAKE_INSTALL_PREFIX` 变量用于指定安装目录。在运行 ``cmake --install`` 命令的时候，会被 ``--prefix`` 参数覆盖。例如：

.. code-block:: console

  cmake --install . --prefix "/home/myuser/installdir"

导航到安装目录并验证程序能否运行。

测试支持
---------------

接下来测试一下我们的程序。可以在顶层的 ``CMakeLists.txt`` 文件末尾启用测试，然后添加一些基本的测试用例来验证程序是否正常。

.. literalinclude:: Step5/CMakeLists.txt
  :language: cmake
  :start-after: # enable testing

第一个测试只是验证程序能否运行，是否出现段错误或者崩溃，返回值是否为0。这就是基本的CMake测试。

下一个测试使用 :prop_test:`PASS_REGULAR_EXPRESSION` 测试属性来验证测试输出是否包含某些字符串。这个例子中，验证当提供的参数数量不正确时，是否输出相关信息。

最后，有一个 ``do_test`` 函数，它运行程序并验证计算出来的平方根对于给定的输入是否正确。对于每次调用 ``do_test``，都会将另一个测试添加到项目中，并通过的参数传递名称、输入及预期结果。

重新构建程序并进入程序目录，运行 :manual:`ctest <ctest(1)>` 命令：``ctest -N`` 和 ``ctest -VV``。对于多配置生成器（例如Visual Studio），必须指定配置类型。例如，要在调试模式下运行测试，可以在构建目录（而不是Debug目录！）中运行  ``ctest -C Debug -VV``。或者，在IDE构建 ``RUN_TESTS`` 目标。

添加系统自省（第5步）
====================================

考虑向项目中添加一些依赖目标平台可能没有的特性代码。对于本例，我们将添加一些代码，这将取决于目标平台是否有 ``log`` 和 ``exp`` 函數。当然，几乎每个平台都有这些函数，但本教程假设它们并不常见。

如果平台有 ``log`` 和 ``exp`` ，那么我们将使用它们在 ``mysqrt`` 中计算平方根。首先在 ``MathFunctions/CMakeLists.txt`` 中使用  :module:`CheckSymbolExists` 模块判断这些函数是否可用。在一些平台上，需要链接到m库。如果 ``log`` 和 ``exp`` 不可用，则使用m库并重试。

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # does this system provide the log and exp functions?
  :end-before: # add compile definitions

如果可以的话，使用 :command:`target_compile_definitions` 指定 ``HAVE_LOG`` 和 ``HAVE_EXP`` 为 ``PRIVATE`` 编译器定义。

.. literalinclude:: Step6/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # add compile definitions
  :end-before: # install rules

如果 ``log`` 和 ``exp`` 在系统上可用，那么我们将在 ``mysqrt`` 函数中用来计算平方根。将以下代码添加到 ``MathFunctions/mysqrt.cxx`` 中的 ``mysqrt`` 函数中（返回結果前不要忘了 ``#endif``！）：

.. literalinclude:: Step6/MathFunctions/mysqrt.cxx
  :language: c++
  :start-after: // if we have both log and exp then use them
  :end-before: // do ten iterations

同时还要修改 ``mysqrt.cxx`` 以包含 ``cmath``：

.. literalinclude:: Step6/MathFunctions/mysqrt.cxx
  :language: c++
  :end-before: #include <iostream>

运行 :manual:`cmake  <cmake(1)>` 命令或者 :manual:`cmake-gui <cmake-gui(1)>` 来配置并用构建工具构建它，然后运行Tutorial程序。

哪个函数给了更好的结果？sqrt还是mysqrt？

添加自定义命令和生成的文件（第6步）
===================================================

假设，出于教学目的，我们决定不使用自带的 ``log`` 和 ``exp`` 函数，而希望生成一个包含预计算值的表，以便在 ``mysqrt`` 中使用。本节中，我们将创建表作为构建过程的一部分，并且将表编译到我们的程序中。

首先，删除 ``MathFunctions/CMakeLists.txt`` 中对 ``log`` 和 ``exp`` 的检查。然后删除 ``mysqrt.cxx`` 中对 ``HAVE_LOG`` 和 ``HAVE_EXP`` 的检查，与此同时可以删除 :code:`#include <cmath>`。

``MathFunctions`` 目录中有一個名为 ``MakeTable.cxx`` 的源文件来提供生成表。

检视这个文件后，可以看到这个表以C++代码展现，输出文件名通过参数传达。

下一步是将适当的命令添加文件中，以构建 ``MathFunctions/CMakeLists.txt`` 文件中以构建MakeTable程序并作为构建过程的一部分运行。需要一些命令来完成这一点。

首先在 ``MathFunctions/CMakeLists.txt`` 开头将 ``MakeTable`` 添加为其他可执行文件。

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # first we add the executable that generates the table
  :end-before: # add the command to generate the source code

然后，我们添加一个自定义命令，指定如何通过运行MakeTable生成 ``Table.h``。

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # add the command to generate the source code
  :end-before: # add the main library

接下来需要让CMake知道 ``mysqrt.cxx`` 依赖于那个生成的 ``Table.h``。这是通过将 ``Table.h`` 添加到MathFunctions的源码列表达到的。

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # add the main library
  :end-before: # state that anybody linking

我们必须将当前目录加入引入目录列表，令 ``Table.h`` 能够被 ``mysqrt.cxx`` 找到并引用。

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # state that we depend on our bin
  :end-before: # install rules

现在我们使用已生成的表。首先，修改 ``mysqrt.cxx`` 以引用 ``Table.h``。接着，我们重构mysqrt函数使用这个表：

.. literalinclude:: Step7/MathFunctions/mysqrt.cxx
  :language: c++
  :start-after: // a hack square root calculation using simple operations

运行 :manual:`cmake  <cmake(1)>` 或者 :manual:`cmake-gui <cmake-gui(1)>` 来配置并构建此项目。

当程序构建时会先构建 ``MakeTable`` 程序。它会运行 ``MakeTable`` 产生 ``Table.h``。最终，它会编译包括 ``Table.h`` 的 ``mysqrt.cxx`` 以产生MathFunctions库。

运行Tutorial程序以验证是否产生使用了这个表。

构建安装程序（第7步）
==============================

我们下个愿望是分发工程走让别人使用它。我们想同时分发源码和二进制在不同的平台。这里我们之前讨论的 `安装和测试（第4步）`_ 不同的是，必须要在源码中编译。在此例子中，我们会构建一个安装包以支持二进制安装及包管理。为了达到这个目标我们应该使用CPack创建不同平台的安装包。应该在顶层 ``CMakeLists.txt`` 开头添加几行。

.. literalinclude:: Step8/CMakeLists.txt
  :language: cmake
  :start-after: # setup installer

这就是我们对它的所有修改。我们在开始包含 :module:`InstallRequiredSystemLibraries`。这个模块会包含当前项目在当前平台下所需的运行时库。接着我们用一些CPack变量以设置当前项目的许可证及版本号。版本号在教程之前的步骤中已经设置，``license.txt`` 已经添加在源码目录的最高层。

最终我们引用 :module:`CPack module <CPack>` 以使用这些变量或者其他属性以我于安装包。

下一步就是按照通常习惯构建程序并运行 :manual:`cpack <cpack(1)>` 命令。生成一个二进制包，你需要在二进制目录运行：

.. code-block:: console

  cpack

若想指定生成器，使用 ``-G`` 选项。对于多配置的构建，使用 ``-C`` 指定配置，如下所示：

.. code-block:: console

  cpack -G ZIP -C Debug

如果想创建一个源码分发包你应该输入：

.. code-block:: console

  cpack --config CPackSourceConfig.cmake

作为替代，运行 ``make package`` 命令或者在IDE中右击 ``Package`` 目标并 ``Build Project``。

运行在二进制目录找的安装包，验证是否如预期。

添加对仪表板的支持（第8步）
=======================================

将测试结果添加到仪表板很简单。在 `测试支持`_ 我们已经添加了一系列测试到项目中。现在我们必须运行这些测试并将结果添加到仪表板中。为与做到这点，在顶层 ``CMakeLists.txt`` 
中引用 :module:`CTest` 模块。

替换：

.. code-block:: cmake

  # enable testing
  enable_testing()

为：

.. code-block:: cmake

  # enable dashboard scripting
  include(CTest)

:module:`CTest` 模块可以自动调用 ``enable_testing()``，所以我们可以将它将CMake文件中删掉。

我们同样需要创建一个 ``CTestConfig.cmake`` 文件在顶层目录以提交到仪表板。

.. literalinclude:: Step9/CTestConfig.cmake
  :language: cmake

:manual:`ctest <ctest(1)>` 命令运行时会读取此文件。你可以运行 :manual:`cmake <cmake(1)>` 命令或者用 :manual:`cmake-gui <cmake-gui(1)>` 去配置这项目，但没去构建它。相应替代的，修改二进制树目录，并运行：

  ctest [-VV] -D Experimental

不要忘了，对于多配置的生成器（比如Visual Studio），配置必须指定：

  ctest [-VV] -C Debug -D Experimental

或者直接在IDE中编译 ``Experimental`` 目标。

:manual:`ctest <ctest(1)>` 命令将构建并将结果提交到Kitware的公共仪表板：https://my.cdash.org/index.php?project=CMakeTutorial。

混合使用静态库和共享库（第9步）
=================================

在本节中，我们将展示如何使用 :variable:`BUILD_SHARED_LIBS` 变量来控制 :command:`add_library` 的默认行为，并允许控制没有显式类型的库（``STATIC``、``SHARED``、``MODULE`` 或者 ``OBJECT``）是如何构建的。

To accomplish this we need to add :variable:`BUILD_SHARED_LIBS` to the
top-level ``CMakeLists.txt``. We use the :command:`option` command as it allows
users to optionally select if the value should be ON or OFF.

Next we are going to refactor MathFunctions to become a real library that
encapsulates using ``mysqrt`` or ``sqrt``, instead of requiring the calling
code to do this logic. This will also mean that ``USE_MYMATH`` will not control
building MathFunctions, but instead will control the behavior of this library.

The first step is to update the starting section of the top-level
``CMakeLists.txt`` to look like:

.. literalinclude:: Step10/CMakeLists.txt
  :language: cmake
  :end-before: # add the binary tree

Now that we have made MathFunctions always be used, we will need to update
the logic of that library. So, in ``MathFunctions/CMakeLists.txt`` we need to
create a SqrtLibrary that will conditionally be built and installed when
``USE_MYMATH`` is enabled. Now, since this is a tutorial, we are going to
explicitly require that SqrtLibrary is built statically.

The end result is that ``MathFunctions/CMakeLists.txt`` should look like:

.. literalinclude:: Step10/MathFunctions/CMakeLists.txt
  :language: cmake
  :lines: 1-36,42-

Next, update ``MathFunctions/mysqrt.cxx`` to use the ``mathfunctions`` and
``detail`` namespaces:

.. literalinclude:: Step10/MathFunctions/mysqrt.cxx
  :language: c++

We also need to make some changes in ``tutorial.cxx``, so that it no longer
uses ``USE_MYMATH``:

#. Always include ``MathFunctions.h``
#. Always use ``mathfunctions::sqrt``
#. Don't include cmath

Finally, update ``MathFunctions/MathFunctions.h`` to use dll export defines:

.. literalinclude:: Step10/MathFunctions/MathFunctions.h
  :language: c++

At this point, if you build everything, you may notice that linking fails
as we are combining a static library without position independent code with a
library that has position independent code. The solution to this is to
explicitly set the :prop_tgt:`POSITION_INDEPENDENT_CODE` target property of
SqrtLibrary to be True no matter the build type.

.. literalinclude:: Step10/MathFunctions/CMakeLists.txt
  :language: cmake
  :lines: 37-42

**Exercise**: We modified ``MathFunctions.h`` to use dll export defines.
Using CMake documentation can you find a helper module to simplify this?


Adding Generator Expressions (Step 10)
======================================

:manual:`Generator expressions <cmake-generator-expressions(7)>` are evaluated
during build system generation to produce information specific to each build
configuration.

:manual:`Generator expressions <cmake-generator-expressions(7)>` are allowed in
the context of many target properties, such as :prop_tgt:`LINK_LIBRARIES`,
:prop_tgt:`INCLUDE_DIRECTORIES`, :prop_tgt:`COMPILE_DEFINITIONS` and others.
They may also be used when using commands to populate those properties, such as
:command:`target_link_libraries`, :command:`target_include_directories`,
:command:`target_compile_definitions` and others.

:manual:`Generator expressions <cmake-generator-expressions(7)>`  may be used
to enable conditional linking, conditional definitions used when compiling,
conditional include directories and more. The conditions may be based on the
build configuration, target properties, platform information or any other
queryable information.

There are different types of
:manual:`generator expressions <cmake-generator-expressions(7)>` including
Logical, Informational, and Output expressions.

Logical expressions are used to create conditional output. The basic
expressions are the 0 and 1 expressions. A ``$<0:...>`` results in the empty
string, and ``<1:...>`` results in the content of "...".  They can also be
nested.

A common usage of
:manual:`generator expressions <cmake-generator-expressions(7)>` is to
conditionally add compiler flags, such as those for language levels or
warnings. A nice pattern is to associate this information to an ``INTERFACE``
target allowing this information to propagate. Let's start by constructing an
``INTERFACE`` target and specifying the required C++ standard level of ``11``
instead of using :variable:`CMAKE_CXX_STANDARD`.

So the following code:

.. literalinclude:: Step10/CMakeLists.txt
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: # control where the static and shared libraries are built so that on windows

Would be replaced with:

.. literalinclude:: Step11/CMakeLists.txt
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: # add compiler warning flags just when building this project via


Next we add the desired compiler warning flags that we want for our project. As
warning flags vary based on the compiler we use the ``COMPILE_LANG_AND_ID``
generator expression to control which flags to apply given a language and a set
of compiler ids as seen below:

.. literalinclude:: Step11/CMakeLists.txt
  :language: cmake
  :start-after: # the BUILD_INTERFACE genex
  :end-before: # control where the static and shared libraries are built so that on windows

Looking at this we see that the warning flags are encapsulated inside a
``BUILD_INTERFACE`` condition. This is done so that consumers of our installed
project will not inherit our warning flags.


**Exercise**: Modify ``MathFunctions/CMakeLists.txt`` so that all targets have
a :command:`target_link_libraries` call to ``tutorial_compiler_flags``.


Adding Export Configuration (Step 11)
=====================================

During `安装和测试（第4步）`_ of the tutorial we added the ability
for CMake to install the library and headers of the project. During
`构建安装程序（第7步）`_ we added the ability to package up this
information so it could be distributed to other people.

The next step is to add the necessary information so that other CMake projects
can use our project, be it from a build directory, a local install or when
packaged.

The first step is to update our :command:`install(TARGETS)` commands to not
only specify a ``DESTINATION`` but also an ``EXPORT``. The ``EXPORT`` keyword
generates and installs a CMake file containing code to import all targets
listed in the install command from the installation tree. So let's go ahead and
explicitly ``EXPORT`` the MathFunctions library by updating the ``install``
command in ``MathFunctions/CMakeLists.txt`` to look like:

.. literalinclude:: Complete/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # install rules

Now that we have MathFunctions being exported, we also need to explicitly
install the generated ``MathFunctionsTargets.cmake`` file. This is done by
adding the following to the bottom of the top-level ``CMakeLists.txt``:

.. literalinclude:: Complete/CMakeLists.txt
  :language: cmake
  :start-after: # install the configuration targets
  :end-before: include(CMakePackageConfigHelpers)

At this point you should try and run CMake. If everything is setup properly
you will see that CMake will generate an error that looks like:

.. code-block:: console

  Target "MathFunctions" INTERFACE_INCLUDE_DIRECTORIES property contains
  path:

    "/Users/robert/Documents/CMakeClass/Tutorial/Step11/MathFunctions"

  which is prefixed in the source directory.

What CMake is trying to say is that during generating the export information
it will export a path that is intrinsically tied to the current machine and
will not be valid on other machines. The solution to this is to update the
MathFunctions :command:`target_include_directories` to understand that it needs
different ``INTERFACE`` locations when being used from within the build
directory and from an install / package. This means converting the
:command:`target_include_directories` call for MathFunctions to look like:

.. literalinclude:: Step12/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # to find MathFunctions.h, while we don't.
  :end-before: # should we use our own math functions

Once this has been updated, we can re-run CMake and verify that it doesn't
warn anymore.

At this point, we have CMake properly packaging the target information that is
required but we will still need to generate a ``MathFunctionsConfig.cmake`` so
that the CMake :command:`find_package` command can find our project. So let's go
ahead and add a new file to the top-level of the project called
``Config.cmake.in`` with the following contents:

.. literalinclude:: Step12/Config.cmake.in

Then, to properly configure and install that file, add the following to the
bottom of the top-level ``CMakeLists.txt``:

.. literalinclude:: Step12/CMakeLists.txt
  :language: cmake
  :start-after: # install the configuration targets
  :end-before: # generate the export

At this point, we have generated a relocatable CMake Configuration for our
project that can be used after the project has been installed or packaged. If
we want our project to also be used from a build directory we only have to add
the following to the bottom of the top level ``CMakeLists.txt``:

.. literalinclude:: Step12/CMakeLists.txt
  :language: cmake
  :start-after: # needs to be after the install(TARGETS ) command

With this export call we now generate a ``Targets.cmake``, allowing the
configured ``MathFunctionsConfig.cmake`` in the build directory to be used by
other projects, without needing it to be installed.

Packaging Debug and Release (Step 12)
=====================================

**Note:** This example is valid for single-configuration generators and will
not work for multi-configuration generators (e.g. Visual Studio).

By default, CMake's model is that a build directory only contains a single
configuration, be it Debug, Release, MinSizeRel, or RelWithDebInfo. It is
possible, however, to setup CPack to bundle multiple build directories and
construct a package that contains multiple configurations of the same project.

First, we want to ensure that the debug and release builds use different names
for the executables and libraries that will be installed. Let's use `d` as the
postfix for the debug executable and libraries.

Set :variable:`CMAKE_DEBUG_POSTFIX` near the beginning of the top-level
``CMakeLists.txt`` file:

.. literalinclude:: Complete/CMakeLists.txt
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: target_compile_features(tutorial_compiler_flags

And the :prop_tgt:`DEBUG_POSTFIX` property on the tutorial executable:

.. literalinclude:: Complete/CMakeLists.txt
  :language: cmake
  :start-after: # add the executable
  :end-before: # add the binary tree to the search path for include files

Let's also add version numbering to the MathFunctions library. In
``MathFunctions/CMakeLists.txt``, set the :prop_tgt:`VERSION` and
:prop_tgt:`SOVERSION` properties:

.. literalinclude:: Complete/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # setup the version numbering
  :end-before: # install rules

From the ``Step12`` directory, create ``debug`` and ``release``
subbdirectories. The layout will look like:

.. code-block:: none

  - Step12
     - debug
     - release

Now we need to setup debug and release builds. We can use
:variable:`CMAKE_BUILD_TYPE` to set the configuration type:

.. code-block:: console

  cd debug
  cmake -DCMAKE_BUILD_TYPE=Debug ..
  cmake --build .
  cd ../release
  cmake -DCMAKE_BUILD_TYPE=Release ..
  cmake --build .

Now that both the debug and release builds are complete, we can use a custom
configuration file to package both builds into a single release. In the
``Step12`` directory, create a file called ``MultiCPackConfig.cmake``. In this
file, first include the default configuration file that was created by the
:manual:`cmake  <cmake(1)>` executable.

Next, use the ``CPACK_INSTALL_CMAKE_PROJECTS`` variable to specify which
projects to install. In this case, we want to install both debug and release.

.. literalinclude:: Complete/MultiCPackConfig.cmake
  :language: cmake

From the ``Step12`` directory, run :manual:`cpack <cpack(1)>` specifying our
custom configuration file with the ``config`` option:

.. code-block:: console

  cpack --config MultiCPackConfig.cmake
