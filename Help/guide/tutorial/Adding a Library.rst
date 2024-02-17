步骤2：添加库
========================

至此，我们已经了解了如何使用CMake创建一个基本项目。在这一步中，我们将学习如何在我们的项目中\
创建和使用库。我们还将了解如何使库的使用成为可选的。

练习1 - 创建一个库
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

要在CMake中添加库，可以使用\ :command:`add_library`\ 命令并指定应该由哪些源文件组成库。

我们可以用一个或多个子目录来组织项目，而不是将所有源文件放在一个目录中。在本例中，我们将专门\
为库创建一个子目录。在这里，我们可以添加一个新的\ ``CMakeLists.txt``\ 文件和一个或多个源\
文件。在顶层\ ``CMakeLists.txt``\ 文件中，我们将使用\ :command:`add_subdirectory`\
命令将子目录添加到构建中。

一旦创建了库，它将通过\ :command:`target_include_directories`\ 和\
:command:`target_link_libraries`\ 连接到可执行目标。

目标
----

添加并使用一个库。

有用的资源
-----------------

* :command:`add_library`
* :command:`add_subdirectory`
* :command:`target_include_directories`
* :command:`target_link_libraries`
* :variable:`PROJECT_SOURCE_DIR`

待编辑的文件
-------------

* ``CMakeLists.txt``
* ``tutorial.cxx``
* ``MathFunctions/CMakeLists.txt``

开始
---------------

在这个练习中，我们将向我们的项目中添加一个库，其中包含我们自己的用于计算数字平方根的实现。\
然后，可执行程序可以使用这个库，而不是编译器提供的标准平方根函数。

在本教程中，我们将把库放入名为\ ``MathFunctions``\ 的子目录中。这个目录已经包含了头文件\
``MathFunctions.h``\ 和\ ``mysqrt.h``。还提供了它们各自的源文件\ ``MathFunctions.cxx``\
和\ ``mysqrt.cxx``。我们不需要修改这些文件中的任何一个。\ ``mysqrt.cxx``\ 有一个名为\
``mysqrt``\ 的函数，它提供了与编译器的\ ``sqrt``\ 函数类似的功能。\ ``MathFunctions.cxx``\
包含一个函数\ ``sqrt``，用于隐藏\ ``sqrt``\ 的实现细节。

从\ ``Help/guide/tutorial/Step2``\ 目录中，从\ ``TODO 1``\ 开始，到\ ``TODO 6``\ 完成。

首先，在\ ``MathFunctions``\ 子目录中填写一行的\ ``CMakeLists.txt``。

接下来，编辑顶层的\ ``CMakeLists.txt``。

最后，在\ ``tutorial.cxx``\ 中使用新创建的\ ``MathFunctions``\ 库。

构建并运行
-------------

运行\ :manual:`cmake  <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\
来配置项目，然后用你选择的构建工具构建它。

下面是命令行中的一个刷新：

.. code-block:: console

  mkdir Step2_build
  cd Step2_build
  cmake ../Step2
  cmake --build .

尝试使用新构建的\ ``Tutorial``，并确保它仍然产生准确的平方根值。

解决方案
--------

在\ ``MathFunctions``\ 目录下的\ ``CMakeLists.txt``\ 文件中，我们使用\
:command:`add_library`\ 创建了一个名为\ ``MathFunctions``\ 的库目标。库的源文件作为参\
数传递给\ :command:`add_library`。这看起来像下面这行：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 1: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add_library

  add_library(MathFunctions MathFunctions.cxx mysqrt.cxx)

.. raw:: html

  </details>

为了使用新的库，我们将在顶层\ ``CMakeLists.txt``\ 文件中添加一个\ :command:`add_subdirectory`\
调用，以便构建库。

.. raw:: html

  <details><summary>TODO 2: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-add_subdirectory

  add_subdirectory(MathFunctions)

.. raw:: html

  </details>

接下来，使用\ :command:`target_link_libraries`\ 将新的库目标链接到可执行目标。

.. raw:: html

  <details><summary>TODO 3: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries

  target_link_libraries(Tutorial PUBLIC MathFunctions)

.. raw:: html

  </details>

最后，我们需要指定库的头文件位置。修改现存的\ :command:`target_include_directories`\
以添加\ ``MathFunctions``\ 子目录作为包含目录，以便可以找到\ ``MathFunctions.h``\ 头文件。

.. raw:: html

  <details><summary>TODO 4: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 4: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories-step2

  target_include_directories(Tutorial PUBLIC
                            "${PROJECT_BINARY_DIR}"
                            "${PROJECT_SOURCE_DIR}/MathFunctions"
                            )

.. raw:: html

  </details>

现在让我们使用库。在\ ``tutorial.cxx``\ 中，包含 ``MathFunctions.h``：

.. raw:: html

  <details><summary>TODO 5: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/tutorial.cxx
  :caption: TODO 5: tutorial.cxx
  :name: CMakeLists.txt-include-MathFunctions.h
  :language: cmake
  :start-after: #include <string>
  :end-before: #include "TutorialConfig.h"

.. raw:: html

  </details>

最后，用包装函数\ ``mathfunctions::sqrt``\ 替换\ ``sqrt``。

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/tutorial.cxx
  :caption: TODO 6: tutorial.cxx
  :name: CMakeLists.txt-option
  :language: cmake
  :start-after:   const double inputValue = std::stod(argv[1]);
  :end-before: std::cout

.. raw:: html

  </details>

练习2 - 添加选项
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

现在让我们在MathFunctions库中添加一个选项，允许开发人员选择自定义的平方根实现或内置的标准实\
现。虽然对于教程来说，确实没有必要这样做，但对于大型项目来说，这是一种常见的情况。

CMake可以使用\ :command:`option`\ 命令来做到这一点。这为用户提供了一个变量，他们可以在配\
置cmake构建时更改该变量。此设置将存储在缓存中，以便用户不需要每次在构建目录上运行CMake时都\
设置该值。

目标
----

添加不使用\ ``MathFunctions``\ 进行构建的选项。


有用的资源
-----------------

* :command:`if`
* :command:`option`
* :command:`target_compile_definitions`

待编辑的文件
-------------

* ``MathFunctions/CMakeLists.txt``
* ``MathFunctions/MathFunctions.cxx``

开始
---------------

从练习1中的结果文件开始。完成\ ``TODO 7``\ 至\ ``TODO 14``。

首先使用\ ``MathFunctions/CMakeLists.txt``\ 中的\ :command:`option`\ 命令创建一个变量\
``USE_MYMATH``。在同一个文件中，使用该选项将编译定义传递给\ ``MathFunctions``\ 库。

然后，更新\ ``MathFunctions.cxx``\ 以基于\ ``USE_MYMATH``\ 重定向编译。

最后，防止\ ``mysqrt.cxx``\ 在\ ``USE_MYMATH``\ 打开时被编译，方法是在\
``MathFunctions/CMakeLists.txt``\ 的\ ``USE_MYMATH``\ 块中使其成为自己的库。

构建并运行
-------------

因为我们已经在练习1中配置了构建目录，我们可以通过简单地调用以下命令来重新构建：

.. code-block:: console

  cd ../Step2_build
  cmake --build .

接下来，用几个数字来运行\ ``Tutorial``\ 可执行文件，以验证它仍然正确。

现在让我们将\ ``USE_MYMATH``\ 的值更新为\ ``OFF``。如果你在终端中，最简单的方法是使用\
:manual:`cmake-gui <cmake-gui(1)>`\ 或\ :manual:`ccmake <ccmake(1)>`。或者，如果你\
想从命令行更改这个选项，试试：

.. code-block:: console

  cmake ../Step2 -DUSE_MYMATH=OFF

现在，用以下代码重新构建代码：

.. code-block:: console

  cmake --build .

然后，再次运行可执行文件，以确保在\ ``USE_MYMATH``\ 设置为\ ``OFF``\ 时它仍然可以工作。\
哪个函数的结果更好，\ ``sqrt``\ 还是\ ``mysqrt``？

解决方案
--------

第一步是向顶层\ ``MathFunctions/CMakeLists.txt``\ 文件添加一个选项。该选项将显示在\
:manual:`cmake-gui <cmake-gui(1)>`\ 和\ :manual:`ccmake <ccmake(1)>`\ 中，默认值为\
``ON``，用户可以更改该值。

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 7: MathFunctions/CMakeLists.txt
  :name: CMakeLists.txt-option-library-level
  :language: cmake
  :start-after: # should we use our own math functions
  :end-before: if (USE_MYMATH)

.. raw:: html

  </details>

接下来，使用这个新选项使库与\ ``mysqrt``\ 函数的构建和链接成为有条件的。

创建一个\ :command:`if`\ 语句来检查\ ``USE_MYMATH``\ 的值。在\ :command:`if`\ 块中，\
放入\ :command:`target_compile_definitions`\ 命令和编译定义\ ``USE_MYMATH``。

.. raw:: html

  <details><summary>TODO 8: 点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 8: MathFunctions/CMakeLists.txt
  :name: CMakeLists.txt-USE_MYMATH

  if (USE_MYMATH)
    target_compile_definitions(MathFunctions PRIVATE "USE_MYMATH")
  endif()

.. raw:: html

  </details>

当\ ``USE_MYMATH``\ 为\ ``ON``\ 时，编译定义\ ``USE_MYMATH``\ 将被设置。然后，我们可\
以使用这个编译定义来启用或禁用源代码的部分。

对源代码的相应更改相当简单。在\ ``MathFunctions.cxx``\ 中，我们使用\ ``USE_MYMATH``\
来控制使用哪个平方根函数：

.. raw:: html

  <details><summary>TODO 9: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/MathFunctions.cxx
  :caption: TODO 9: MathFunctions/MathFunctions.cxx
  :name: MathFunctions-USE_MYMATH-if
  :language: c++
  :start-after: which square root function should we use?
  :end-before: }

.. raw:: html

  </details>

接下来，如果定义了\ ``USE_MYMATH``，我们需要包含\ ``mysqrt.h``。

.. raw:: html

  <details><summary>TODO 10: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/MathFunctions.cxx
  :caption: TODO 10: MathFunctions/MathFunctions.cxx
  :name: MathFunctions-USE_MYMATH-if-include
  :language: c++
  :start-after: include <cmath>
  :end-before: namespace mathfunctions

.. raw:: html

  </details>

最后，在使用\ ``std::sqrt``\ 时，我们需要包含\ ``cmath``。

.. raw:: html

  <details><summary>TODO 11: 点击显示/隐藏答案</summary>

.. code-block:: c++
  :caption: TODO 11 : MathFunctions/MathFunctions.cxx
  :name: tutorial.cxx-include_cmath

  #include <cmath>

.. raw:: html

  </details>

然后，在同一个文件中，我们让\ ``USE_MYMATH``\ 控制使用哪个平方根函数：

.. raw:: html

  <details><summary>TODO 12: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 12 : MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add_library-SqrtLibrary
  :language: cmake
  :start-after: # library that just does sqrt
  :end-before: # TODO 7: Link

.. raw:: html

  </details>

接下来，当启用\ ``USE_MYMATH``\ 时，我们将\ ``SqrtLibrary``\ 链接到\ ``MathFunctions``。

.. raw:: html

  <details><summary>TODO 13: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 13 : MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_link_libraries-SqrtLibrary
  :language: cmake
  :start-after: to tutorial_compiler_flags
  :end-before: endif()

.. raw:: html

  </details>

最后，我们可以从\ ``MathFunctions``\ 库源列表中删除\ ``mysqrt.cxx``，因为它将在包含\
``SqrtLibrary``\ 时被拉入。

.. raw:: html

  <details><summary>TODO 14: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 14 : MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-remove-mysqrt.cxx-MathFunctions
  :language: cmake
  :end-before: # TODO 1:

.. raw:: html

  </details>

通过这些更改，\ ``mysqrt``\ 函数现在对于正在构建和使用\ ``MathFunctions``\ 库的人来说完\
全是可选的。用户可以切换\ ``USE_MYMATH``\ 来操作构建中使用的库。
