步骤2：添加库
========================

现在我们将向我们的项目添加一个库。这个库将包含我们自己的计算数字平方根的实现。可执行文件可以使用这个库，而不是编译器提供的标准平方根函数。

在本教程中，我们将把这个库放入名为 ``MathFunctions`` 的子目录中。这个目录已经包含了一个头文件 ``MathFunctions.h`` 和一个源文件 ``mysqrt.cxx``。源文件有一个名为 ``mysqrt`` 的函数，功能类似于自带的 ``sqrt`` 函数。

将以下这个一行的 ``CMakeLists.txt`` 文件添加到 ``MathFunctions`` 目录：

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt
  :language: cmake

为了使用这个新库，我们将在顶层的 ``CMakeLists.txt`` 文件中添加一个 :command:`add_subdirectory` 调用，以便构建这个库。我们将新库添加到可执行文件中，并将  ``MathFunctions`` 作为包含目录添加，以便能够找到 ``mysqrt.h`` 头文件。顶层  ``CMakeLists.txt`` 文件的最后几行现在应该是这样的：

.. code-block:: cmake
        :caption: CMakeLists.txt
        :name: CMakeLists.txt-add_subdirectory

        # 添加MathFunctions库
        add_subdirectory(MathFunctions)

        # 添加可执行文件
        add_executable(Tutorial tutorial.cxx)

        target_link_libraries(Tutorial PUBLIC MathFunctions)

        # 添加二进制树到引用目录的搜索路径
        # 这让我们能找到TutorialConfig.h
        target_include_directories(Tutorial PUBLIC
                                  "${PROJECT_BINARY_DIR}"
                                  "${PROJECT_SOURCE_DIR}/MathFunctions"
                                  )

现在让我们使MathFunctions库成为可选的。虽然在本教程中没有必要这样做，但对于大型项目来说，这是很常见的情况。第一步是向顶层 ``CMakeLists.txt`` 文件添加一个选项。

.. literalinclude:: Step3/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-option
  :language: cmake
  :start-after: # should we use our own math functions
  :end-before: # add the MathFunctions library

这个选项将在 :manual:`cmake-gui <cmake-gui(1)>` 和 :manual:`ccmake <ccmake(1)>` 中显示，默认值ON可以由用户更改。该设置将存储在缓存中，这样用户在每次在构建目录上运行CMake时就不需要设置该值。

下一个更改是使构建和链接MathFunctions库成为有条件的。为此，我们将顶层 ``CMakeLists.txt`` 文件的结尾修改为如下所示：

.. literalinclude:: Step3/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries-EXTRA_LIBS
  :language: cmake
  :start-after: # add the MathFunctions library

注意，这里用了变量 ``EXTRA_LIBS`` 来收集任何可选库，以便稍后链接到可执行文件中。变量 ``EXTRA_INCLUDES`` 类似地用于可选头文件。在处理许多可选组件时，这是一种传统方法，我们将在下一步讨论现代方法。

对源代码的相应更改相当简单。首先，在 ``tutorial.cxx`` 中，在需要的时候包含 ``MathFunctions.h`` 头文件：

.. literalinclude:: Step3/tutorial.cxx
  :caption: tutorial.cxx
  :name: tutorial.cxx-ifdef-include
  :language: c++
  :start-after: // should we include the MathFunctions header
  :end-before: int main

然后，在同一个文件中，让 ``USE_MYMATH`` 控制使用哪个平方根函数：

.. literalinclude:: Step3/tutorial.cxx
  :caption: tutorial.cxx
  :name: tutorial.cxx-ifdef-const
  :language: c++
  :start-after: // which square root function should we use?
  :end-before: std::cout << "The square root of

由于源代码现在需要 ``USE_MYMATH`` ，我们可以通过以下一行把它添加到 ``TutorialConfig.h.in`` 中：

.. literalinclude:: Step3/TutorialConfig.h.in
  :caption: TutorialConfig.h.in
  :name: TutorialConfig.h.in-cmakedefine
  :language: c++
  :lines: 4

**练习**：为什么在 ``USE_MYMATH`` 选项后面配置 ``TutorialConfig.h.in`` 很重要？如果我们把这两个颠倒过来会发生什么？

运行 :manual:`cmake  <cmake(1)>` 可执行文件或 :manual:`cmake-gui <cmake-gui(1)>` 来配置项目，用你选择的构建工具构建它。然后运行Tutorial可执行文件。

现在让我们更新 ``USE_MYMATH`` 的值。最简单的方法是使用 :manual:`cmake-gui <cmake-gui(1)>` 或者终端环境上的 :manual:`ccmake <ccmake(1)>`。如果你想从命令行更改选项，试试：

.. code-block:: console

  cmake ../Step2 -DUSE_MYMATH=OFF

重新生成并再次运行。

哪个函数给出了更好的结果，``sqrt`` 还是 ``mysqrt``？
