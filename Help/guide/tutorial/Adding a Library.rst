步骤2：添加库
========================

至此，我们已经了解了如何使用CMake创建一个基本项目。在这一步中，我们将学习如何在我们的项目中创建和使用库。\
我们还将了解如何使库的使用成为可选的。

练习1 - 创建一个库
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

要在CMake中添加库，可以使用\ :command:`add_library`\ 命令并指定应该由哪些源文件组成库。

我们可以用一个或多个子目录来组织项目，而不是将所有源文件放在一个目录中。在本例中，我们将专门为库创建一个子目录。\
在这里，我们可以添加一个新的\ ``CMakeLists.txt``\ 文件和一个或多个源文件。\
在顶层\ ``CMakeLists.txt``\ 文件中，我们将使用\ :command:`add_subdirectory`\ 命令将子目录添加到构建中。

一旦创建了库，它将通过\ :command:`target_include_directories`\ 和\ :command:`target_link_libraries`\ 连接到可执行目标。

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

在本教程中，我们将把库放入名为\ ``MathFunctions``\ 的子目录中。\
这个目录已经包含了一个头文件\ ``MathFunctions.h``\ 和一个源文件\ ``mysqrt.cxx``。我们不需要修改这些文件。\
源文件有一个名为\ ``mysqrt``\ 的函数，它提供了与编译器的\ ``sqrt``\ 函数类似的功能。

从\ ``Help/guide/tutorial/Step2``\ 目录中，从\ ``TODO 1``\ 开始，到\ ``TODO 6``\ 完成。

首先，在\ ``MathFunctions``\ 子目录中填写一行的\ ``CMakeLists.txt``。

接下来，编辑顶层的\ ``CMakeLists.txt``。

最后，在\ ``tutorial.cxx``\ 中使用新创建的\ ``MathFunctions``\ 库。

构建并运行
-------------

运行\ :manual:`cmake  <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，\
然后用你选择的构建工具构建它。

下面是命令行中的一个刷新：

.. code-block:: console

  mkdir Step2_build
  cd Step2_build
  cmake ../Step2
  cmake --build .

尝试使用新构建的\ ``Tutorial``，并确保它仍然产生准确的平方根值。

解决方案
--------

在\ ``MathFunctions``\ 目录下的\ ``CMakeLists.txt``\ 文件中，我们用\ :command:`add_library`\ 创建了一个名为\ ``MathFunctions``\ 的库目标。\
库的源文件作为参数传递给\ :command:`add_library`。这看起来像下面这行：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/MathFunctions/CMakeLists.txt
  :caption: TODO 1: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add_library
  :language: cmake
  :end-before: # TODO 1

.. raw:: html

  </details>

为了使用新的库，我们将在顶层\ ``CMakeLists.txt``\ 文件中添加一个\ :command:`add_subdirectory`\ 调用，以便构建库。

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

最后，我们需要指定库的头文件位置。修改\ :command:`target_include_directories`\ 以\
添加\ ``MathFunctions``\ 子目录作为包含目录，以便可以找到\ ``MathFunctions.h``\ 头文件。

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

.. code-block:: c++
  :caption: TODO 5 : tutorial.cxx
  :name: tutorial.cxx-include_MathFunctions.h

  #include "MathFunctions.h"

.. raw:: html

  </details>

最后，用库函数\ ``mysqrt``\ 替换\ ``sqrt``。

.. raw:: html

  <details><summary>TODO 6: 点击显示/隐藏答案</summary>

.. code-block:: c++
  :caption: TODO 6 : tutorial.cxx
  :name: tutorial.cxx-call_mysqrt

  const double outputValue = mysqrt(inputValue);

.. raw:: html

  </details>

练习2 - 令我们的库成为可选
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

现在让我们将MathFunctions库设置为可选的。虽然对于本教程来说，真的没有必要这样做，\
但对于较大的项目来说，这是很常见的情况。

CMake可以使用\ :command:`option`\ 命令来做到这一点。这为用户提供了一个变量，\
他们可以在配置cmake构建时更改该变量。此设置将存储在缓存中，以便用户不需要每次在构建目录上运行CMake时都设置该值。

目标
----

添加不使用\ ``MathFunctions``\ 进行构建的选项。


有用的资源
-----------------

* :command:`if`
* :command:`list`
* :command:`option`
* :command:`cmakedefine <configure_file>`

待编辑的文件
-------------

* ``CMakeLists.txt``
* ``tutorial.cxx``
* ``TutorialConfig.h.in``

开始
---------------

从练习1中的结果文件开始。完成\ ``TODO 7``\ 至\ ``TODO 13``。

首先在顶层的\ ``CMakeLists.txt``\ 文件中使用\ :command:`option`\ 命令创建一个变量\ ``USE_MYMATH``。\
在同一文件中，使用该选项来确定是否构建和使用\ ``MathFunctions``\ 库。

然后，更新\ ``tutorial.cxx``\ 和\ ``TutorialConfig.h.in``\ 以使用\ ``USE_MYMATH``。

构建并运行
-------------

因为我们已经在练习1中配置了构建目录，我们可以通过简单地调用以下命令来重新构建：

.. code-block:: console

  cd ../Step2_build
  cmake --build .

接下来，用几个数字来运行\ ``Tutorial``\ 可执行文件，以验证它仍然正确。

现在让我们将\ ``USE_MYMATH``\ 的值更新为\ ``OFF``。如果你在终端中，\
最简单的方法是使用\ :manual:`cmake-gui <cmake-gui(1)>`\ 或\ :manual:`ccmake <ccmake(1)>`。\
或者，如果你想从命令行更改这个选项，试试：

.. code-block:: console

  cmake ../Step2 -DUSE_MYMATH=OFF

现在，用以下代码重新构建代码：

.. code-block:: console

  cmake --build .

然后，再次运行可执行文件，以确保在\ ``USE_MYMATH``\ 设置为\ ``OFF``\ 时它仍然可以工作。\
哪个函数的结果更好，\ ``sqrt``\ 还是\ ``mysqrt``？

解决方案
--------

第一步是向顶层\ ``CMakeLists.txt``\ 文件添加一个选项。\
该选项将显示在\ :manual:`cmake-gui <cmake-gui(1)>`\ 和\ :manual:`ccmake <ccmake(1)>`\ 中，\
默认值为\ ``ON``，用户可以更改该值。

.. raw:: html

  <details><summary>TODO 7: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-option
  :language: cmake
  :start-after: # 是否使用我们自己的数学函数
  :end-before: # 配置一个头文件，将一些CMake设置

.. raw:: html

  </details>

接下来，令\ ``MathFunctions``\ 库的构建和链接成为有条件的。

首先为我们的项目创建一个可选库目标\ :command:`list`。目前，它只是\ ``MathFunctions``。\
我们把这个列表命名为\ ``EXTRA_LIBS``。

类似地，我们需要为可选include创建一个\ :command:`list`，我们将其称为\ ``EXTRA_INCLUDES``。\
在这个列表中，我们将\ ``APPEND``\ 库所需的头文件路径。

接下来，创建\ :command:`if`\ 语句，检查\ ``USE_MYMATH``\ 的值。在\ :command:`if`\ 块中，\
放入练习1中的\ :command:`add_subdirectory`\ 命令和额外的\ :command:`list`\ 命令。

当\ ``USE_MYMATH``\ 为\ ``ON``\ 时，列表将生成并添加到我们的项目中。\
当\ ``USE_MYMATH``\ 为\ ``OFF``\ 时，列表保持为空。通过这种策略，\
我们允许用户切换\ ``USE_MYMATH``\ 来操作构建中使用的库。

顶层的CMakeLists.txt文件现在看起来如下所示：

.. raw:: html

  <details><summary>TODO 8: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 8: CMakeLists.txt
  :name: CMakeLists.txt-USE_MYMATH
  :language: cmake
  :start-after: # add the MathFunctions library
  :end-before: # 添加可执行文件

.. raw:: html

  </details>

Now that we have these two lists, we need to update
:command:`target_link_libraries` and :command:`target_include_directories` to
use them. Changing them is fairly straightforward.

For :command:`target_link_libraries`, we replace the written out
library names with ``EXTRA_LIBS``. This looks like the following:

.. raw:: html

  <details><summary>TODO 9: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 9: CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries-EXTRA_LIBS
  :language: cmake
  :start-after: add_executable(Tutorial tutorial.cxx)
  :end-before: # TODO 3

.. raw:: html

  </details>

Then, we do the same thing with :command:`target_include_directories` and
``EXTRA_INCLUDES``.

.. raw:: html

  <details><summary>TODO 10: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/CMakeLists.txt
  :caption: TODO 10 : CMakeLists.txt
  :name: CMakeLists.txt-target_link_libraries-EXTRA_INCLUDES
  :language: cmake
  :start-after: # so that we will find TutorialConfig.h

.. raw:: html

  </details>

Note that this is a classic approach when dealing with many components. We
will cover the modern approach in the Step 3 of the tutorial.

The corresponding changes to the source code are fairly straightforward.
First, in ``tutorial.cxx``, we include the ``MathFunctions.h`` header if
``USE_MYMATH`` is defined.

.. raw:: html

  <details><summary>TODO 11: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/tutorial.cxx
  :caption: TODO 11 : tutorial.cxx
  :name: tutorial.cxx-ifdef-include
  :language: c++
  :start-after: // 是否包括MathFunctions头文件？
  :end-before: int main

.. raw:: html

  </details>

Then, in the same file, we make ``USE_MYMATH`` control which square root
function is used:

.. raw:: html

  <details><summary>TODO 12: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/tutorial.cxx
  :caption: TODO 12 : tutorial.cxx
  :name: tutorial.cxx-ifdef-const
  :language: c++
  :start-after: // 应该用哪个平方根函数？
  :end-before: std::cout << "The square root of

.. raw:: html

  </details>

Since the source code now requires ``USE_MYMATH`` we can add it to
``TutorialConfig.h.in`` with the following line:

.. raw:: html

  <details><summary>TODO 13: 点击显示/隐藏答案</summary>

.. literalinclude:: Step3/TutorialConfig.h.in
  :caption: TODO 13 : TutorialConfig.h.in
  :name: TutorialConfig.h.in-cmakedefine
  :language: c++
  :lines: 4

.. raw:: html

  </details>

With these changes, our library is now completely optional to whoever is
building and using it.

Bonus Question
--------------

Why is it important that we configure ``TutorialConfig.h.in``
after the option for ``USE_MYMATH``? What would happen if we inverted the two?

Answer
------

.. raw:: html

  <details><summary>点击显示/隐藏答案</summary>

We configure after because ``TutorialConfig.h.in`` uses the value of
``USE_MYMATH``. If we configure the file before
calling :command:`option`, we won't be using the expected value of
``USE_MYMATH``.

.. raw:: html

  </details>
