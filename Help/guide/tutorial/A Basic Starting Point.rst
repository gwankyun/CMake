步骤1：一个基本的起点
==============================

最基本的项目是由源代码文件构建的可执行文件。对于简单的项目，只需要一个三行\ ``CMakeLists.txt``\ 文件。\
这将是我们教程的起点。在\ ``Step1``\ 目录创建一个\ ``CMakeLists.txt``\ 文件，如下所示：

.. code-block:: cmake
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-start

  cmake_minimum_required(VERSION 3.10)

  # 设置工程名
  project(Tutorial)

  # 添加可执行文件
  add_executable(Tutorial tutorial.cxx)


注意，这个例子在\ ``CMakeLists.txt``\ 文件中使用了小写命令。\
CMake支持大小写混合命令。``tutorial.cxx``\ 的源代码在\ ``Step1``\ 目录中提供，可以用来计算一个数字的平方根。

构建和运行
-------------

这就是所需要的一切——我们现在就可以构建并运行我们的项目了！\
首先，运行\ :manual:`cmake <cmake(1)>`\ 可执行文件或\ :manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，然后使用你选择的构建工具来构建它。

例如，我们可以在命令行中导航到CMake源代码树的\ ``Help/guide/tutorial``\ 目录，并创建一个构建目录：

.. code-block:: console

  mkdir Step1_build

接下来，导航到构建目录并运行CMake来配置项目并生成一个本地构建系统：

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


添加版本号和配置头文件
--------------------------------------------------

我们要添加的第一个特性是为我们的可执行文件和项目提供一个版本号。虽然在源码就能做到，但\ ``CMakeLists.txt``\ 更灵活。

首先，修改\ ``CMakeLists.txt``\ 文件，使用\ :command:`project`\ 命令设置项目名称和版本号。

.. literalinclude:: Step2/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-project-VERSION
  :language: cmake
  :end-before: # 指定C++标准

然后，配置一个头文件来将版本号传递给源代码：

.. literalinclude:: Step2/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-configure_file
  :language: cmake
  :start-after: # 到源码中
  :end-before: # 添加一个可执行文件

由于配置的文件将被写入到二进制目录中，所以我们必须将该目录添加到搜索包含文件的路径列表中。在\ ``CMakeLists.txt``\ 文件的末尾添加以下行：

.. literalinclude:: Step2/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories
  :language: cmake
  :start-after: # 以便找到TutorialConfig.h

用你喜欢的编辑器，在源目录中创建\ ``TutorialConfig.h.in``，内容如下:

.. literalinclude:: Step2/TutorialConfig.h.in
  :caption: TutorialConfig.h.in
  :name: TutorialConfig.h.in
  :language: c++

当CMake配置这个头文件时，``@Tutorial_VERSION_MAJOR@``\ 和\ ``@Tutorial_VERSION_MINOR@``\ 的值将被替换。

下一步，修改\ ``tutorial.cxx``\ 以包含已配置的头文件\ ``TutorialConfig.h``。

最后，让我们通过更新\ ``tutorial.cxx``\ 来打印出可执行文件的名称和版本号，如下：

.. literalinclude:: Step2/tutorial.cxx
  :caption: tutorial.cxx
  :name: tutorial.cxx-print-version
  :language: c++
  :start-after: {
  :end-before: // 将输入转换为double类型

指定c++标准
-------------------------

接下来，让我们通过替换\ ``tutorial.cxx``\ 中的\ ``atof``\ 为\ ``std::stod``，为我们的项目添加一些c++ 11特性。\
同时，删除\ ``#include <cstdlib>``。

.. literalinclude:: Step2/tutorial.cxx
  :caption: tutorial.cxx
  :name: tutorial.cxx-cxx11
  :language: c++
  :start-after: // 将输入转换为double类型
  :end-before: // 计算平方根

我们需要在CMake代码中明确声明它应该使用正确的标志。\
在CMake中启用对特定C++标准的支持的最简单方法是使用\ :variable:`CMAKE_CXX_STANDARD`\ 变量。\
对于本教程，将\ ``CMakeLists.txt``\ 文件中的\ :variable:`CMAKE_CXX_STANDARD`\ 变量设置为11，:variable:`CMAKE_CXX_STANDARD_REQUIRED`\ 设置为True。\
确保\ ``CMAKE_CXX_STANDARD``\ 在调用\ ``add_executable``\ 前声明。

.. literalinclude:: Step2/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-CXX_STANDARD
  :language: cmake
  :end-before: # 配置一个头文件以传递一些CMake设置

重新构建
--------

让我们重新构建我们的项目。我们已经创建了一个构建目录并运行了CMake，所以我们可以跳过构建步骤：

.. code-block:: console

  cd Step1_build
  cmake --build .

现在，我们可以用之前一样的命令来尝试使用新构建的\ ``Tutorial``：

.. code-block:: console

  Tutorial 4294967296
  Tutorial 10
  Tutorial

当运行不带任何参数的可执行文件时，检查现在报告的版本号。
