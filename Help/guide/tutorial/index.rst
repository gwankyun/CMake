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

为此，我们需要将 :variable:`BUILD_SHARED_LIBS` 添加到顶层 ``CMakeLists.txt`` 中。我们使用 :command:`option` 命令，因为它能用户选择值为ON或者OFF。

接下来，我们将重构MathFunctions，使其成为一个使用 ``mysqrt`` 或 ``sqrt`` 封装的真正的库，而不是要求在代码处理这些逻辑。这也意味着 ``USE_MYMATH`` 将不再控制构建MathFunctions，而是控制这个库的行为。

第一步是像下面那样更新顶层 ``CMakeLists.txt``：

.. literalinclude:: Step10/CMakeLists.txt
  :language: cmake
  :end-before: # add the binary tree

现在我们已经使MathFunctions始终被使用，需要更新这个库的逻辑。因此，在 ``MathFunctions/CMakeLists.txt`` 中需要创建一个当 ``USE_MYMATH`` 被启用时有条件构建和安装的SqrtLibrary。现在，由于这是一个教程，我们明确要求SqrtLibrary是静态构建的。

``MathFunctions/CMakeLists.txt`` 最终应该像下面那样：

.. literalinclude:: Step10/MathFunctions/CMakeLists.txt
  :language: cmake
  :lines: 1-36,42-

接下来使用 ``mathfunctions`` 函数及 ``detail`` 命名空间修改 ``MathFunctions/mysqrt.cxx``：

.. literalinclude:: Step10/MathFunctions/mysqrt.cxx
  :language: c++

我们还需要在 ``tutorial.cxx`` 中做一些修改，使它不再使用 ``USE_MYMATH``：

#. 总是包含 ``MathFunctions.h``
#. 总是使用 ``mathfunctions::sqrt``
#. 不要包含cmath

最后，更新 ``MathFunctions/MathFunctions.h`` 以使用dll导出的定义：

.. literalinclude:: Step10/MathFunctions/MathFunctions.h
  :language: c++

此时，如果您构建了所有内容，您可能会注意到，当我们将一个没有位置独立代码的静态库与一个有位置独立代码的库组合在一起时，链接会失败。解决这个问题的方法是显式地将SqrtLibrary的 

.. literalinclude:: Step10/MathFunctions/CMakeLists.txt
  :language: cmake
  :lines: 37-42

**练习**：我们修改了 ``MathFunctions.h`` 以使用dll导出的定义。使用CMake文档你能找到一个帮助模块来简化这个吗?


添加生成器表达式（第10步）
======================================

:manual:`Generator expressions <cmake-generator-expressions(7)>` 在生成生成系统期间计算，以生成特定于每个生成配置的信息。

:manual:`Generator expressions <cmake-generator-expressions(7)>` 可以在许多目标属性的上下文中使用，比如 :prop_tgt:`LINK_LIBRARIES`、:prop_tgt:`INCLUDE_DIRECTORIES`、:prop_tgt:`COMPILE_DEFINITIONS` 等等。它们也可以在使用命令填充那些属性时使用，比如 :command:`target_link_libraries`、:command:`target_include_directories`、:command:`target_compile_definitions` 等等。

:manual:`Generator expressions <cmake-generator-expressions(7)>` 可用于启用条件链接、编译时使用的条件定义、条件包含目录等等。这些条件可能基于构建配置、目标属性、平台信息或任何其他可查询的信息。

:manual:`generator expressions <cmake-generator-expressions(7)>` 有不同的类型，包括逻辑表达式、信息表达式和输出表达式。

逻辑表达式用于创建条件输出。基本表达式是0和1表达式。``$<0:...>`` 结果为空字符串，而 ``<1:...>`` 则会生成“…”。可以互相嵌套。

:manual:`generator expressions <cmake-generator-expressions(7)>` 的常见用法是有条件地添加编译器标志，例如用于语言级别或警告的标志。一个不错的模式是将此信息关联到允许传播此信息的 ``INTERFACE`` 接口目标。让我们首先构造一个 ``INTERFACE`` 目标，并指定所需的C++标准级别为 ``11``，而非用 :variable:`CMAKE_CXX_STANDARD`。

所以下面的代码：

.. literalinclude:: Step10/CMakeLists.txt
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: # control where the static and shared libraries are built so that on windows

会被替换成：

.. literalinclude:: Step11/CMakeLists.txt
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: # add compiler warning flags just when building this project via


接下来，我们为项目添加所需的编译器警告标志。由于警告标志会根据编译器的不同而变化，因此我们使用 ``COMPILE_LANG_AND_ID`` 生成器表达式来控制在给定的语言和一组编译器id中应用哪些标志，如下所示：

.. literalinclude:: Step11/CMakeLists.txt
  :language: cmake
  :start-after: # the BUILD_INTERFACE genex
  :end-before: # control where the static and shared libraries are built so that on windows

我们看到警告标志被封装在 ``BUILD_INTERFACE`` 条件中。这样做是为了使已安装项目的使用者不会继承我们的警告标志。


**练习**：修改 ``MathFunctions/CMakeLists.txt`` ，使所有目标都有一个 :command:`target_link_libraries` 调用 ``tutorial_compiler_flags``。


添加导出配置（第11步）
=====================================

在 `安装和测试（第4步）`_ 教程中，我们增加了CMake安装项目库和头文件的能力。在 `构建安装程序（第7步）`_ 期间，我们添加了打包这些信息的功能，以便将其分发给其他人。

下一步是添加必要的信息，以便其他CMake项目可以使用我们的项目，无论是在构建目录、本地安装还是打包时。

第一步是更新我们的 :command:`install(TARGETS)` 命令，不仅指定 ``DESTINATION``，还指定 ``EXPORT``。 ``EXPORT`` 关键字生成并安装一个CMake文件，其中包含从安装树导入安装命令中列出的所有目标的代码。所以让我们继续，通过更新 ``MathFunctions/CMakeLists.txt`` 中的 ``install`` 命令来显式 ``EXPORT`` MathFunctions库，如下所示：

.. literalinclude:: Complete/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # install rules

现在我们已经导出了MathFunctions，我们还需要显式安装生成的 ``MathFunctionsTargets.cmake`` 文件。这是通过在顶层 ``CMakeLists.txt`` 的底部添加以下内容来实现的：

.. literalinclude:: Complete/CMakeLists.txt
  :language: cmake
  :start-after: # install the configuration targets
  :end-before: include(CMakePackageConfigHelpers)

此时，你应该尝试运行CMake。如果一切都设置正确，你会看到CMake将产生一个错误，看起来像：

.. code-block:: console

  Target "MathFunctions" INTERFACE_INCLUDE_DIRECTORIES property contains
  path:

    "/Users/robert/Documents/CMakeClass/Tutorial/Step11/MathFunctions"

  which is prefixed in the source directory.

CMake试图说明的是，在生成导出信息的过程中，它将导出一个本质上与当前机器相关联的路径，该路径在其他机器上无效。解决这个问题的方法是更新MathFunctions   :command:`target_include_directories` ，以理解在构建目录和安装/包中使用它时需要不同的 ``INTERFACE`` 位置。这意味着将MathFunctions的 :command:`target_include_directories` 调用转换成如下所示：

.. literalinclude:: Step12/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # to find MathFunctions.h, while we don't.
  :end-before: # should we use our own math functions

一旦它被更新，我们可以重新运行CMake并验证它不再发出警告。

此时，我们已经让CMake正确地打包了所需的目标信息，但我们仍然需要生成  ``MathFunctionsConfig.cmake``。让CMake的 :command:`find_package` 命令可以找到我们的项目。因此，让我们继续往项目的顶层添加一个名为 ``Config.cmake.in`` 的新文件。内附以下内容：

.. literalinclude:: Step12/Config.cmake.in

然后，为了正确地配置和安装该文件，将以下文件添加到顶层 ``CMakeLists.txt`` 的底部：

.. literalinclude:: Step12/CMakeLists.txt
  :language: cmake
  :start-after: # install the configuration targets
  :end-before: # generate the export

至此，我们已经为我们的项目生成了一个可重定位的CMake配置，可以在安装或打包项目之后使用。如果我们想要我们的项目也从一个构建目录中使用，我们只需要添加以下顶层 ``CMakeLists.txt`` 的底部：

.. literalinclude:: Step12/CMakeLists.txt
  :language: cmake
  :start-after: # needs to be after the install(TARGETS ) command

使用这个导出调用，我们现在生成一个 ``Targets.cmake``，允许配置 ``MathFunctionsConfig.cmake`` 文件，以供其他项目使用，而无需安装。

打包调试和发布（第12步）
=====================================

**注意**：这个例子只适用于单配置生成器，而不适用于多配置生成器(例如Visual Studio)。

默认情况下，CMake的模型是一个构建目录只包含一个配置，可以是Debug、Release、MinSizeRel或RelWithDebInfo。但是，可以通过安装CPack来捆绑多个构建目录，并构建一个包含同一项目的多个配置的包。

首先，我们希望确保调试版本和发布版本对将要安装的可执行文件和库使用不同的名称。让我们使用 `d` 作为调试可执行文件和库的后缀。

在顶层 ``CMakeLists.txt`` 文件的开头设置 :variable:`CMAKE_DEBUG_POSTFIX`：

.. literalinclude:: Complete/CMakeLists.txt
  :language: cmake
  :start-after: project(Tutorial VERSION 1.0)
  :end-before: target_compile_features(tutorial_compiler_flags

还有tutorial可执行文件的 :prop_tgt:`DEBUG_POSTFIX` 属性：

.. literalinclude:: Complete/CMakeLists.txt
  :language: cmake
  :start-after: # add the executable
  :end-before: # add the binary tree to the search path for include files

让我们再向MathFunctions库添加版本号。在 ``MathFunctions/CMakeLists.txt`` 设置  :prop_tgt:`VERSION` 和 :prop_tgt:`SOVERSION` 属性：

.. literalinclude:: Complete/MathFunctions/CMakeLists.txt
  :language: cmake
  :start-after: # setup the version numbering
  :end-before: # install rules

在 ``Step12`` 目录中，创建 ``debug`` 和 ``release`` 子目录。布局将看起来像：

.. code-block:: none

  - Step12
     - debug
     - release

现在我们需要设置调试和发布构建。我们可以使用 :variable:`CMAKE_BUILD_TYPE` 来设置配置类型：

.. code-block:: console

  cd debug
  cmake -DCMAKE_BUILD_TYPE=Debug ..
  cmake --build .
  cd ../release
  cmake -DCMAKE_BUILD_TYPE=Release ..
  cmake --build .

现在调试版本和发布版本都已经完成了，我们可以使用一个定制的配置文件将这两个版本打包到一个版本中。在 ``Step12`` 目录中，创建一个名为 ``MultiCPackConfig.cmake`` 的文件。在这个文件中，首先包含 :manual:`cmake  <cmake(1)>` 可执行文件创建的默认配置文件。

接下来，使用 ``CPACK_INSTALL_CMAKE_PROJECTS`` 变量来指定要安装哪些项目。在这种情况下，我们希望同时安装调试和发布。

.. literalinclude:: Complete/MultiCPackConfig.cmake
  :language: cmake

在 ``Step12`` 目录下，运行 :manual:`cpack <cpack(1)>` ，指定我们的配置文件  ``config`` 选项：

.. code-block:: console

  cpack --config MultiCPackConfig.cmake
