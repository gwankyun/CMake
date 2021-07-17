步骤6：添加自定义命令和生成的文件
==================================================

假设，出于教学目的，我们决定不使用自带的 ``log`` 和 ``exp`` 函数，而希望生成一个包含预计算值的表，以便在 ``mysqrt`` 中使用。本节中，我们将创建表作为构建过程的一部分，并且将表编译到我们的程序中。

首先，删除 ``MathFunctions/CMakeLists.txt`` 中对 ``log`` 和 ``exp`` 的检查。然后删除 ``mysqrt.cxx`` 中对 ``HAVE_LOG`` 和 ``HAVE_EXP`` 的检查，与此同时可以删除 :code:`#include <cmath>`。

``MathFunctions`` 目录中有一個名为 ``MakeTable.cxx`` 的源文件来提供生成表。

检视这个文件后，可以看到这个表以C++代码展现，输出文件名通过参数传达。

下一步是将适当的命令添加文件中，以构建 ``MathFunctions/CMakeLists.txt`` 文件中以构建MakeTable程序并作为构建过程的一部分运行。需要一些命令来完成这一点。

首先在 ``MathFunctions/CMakeLists.txt`` 开头将 ``MakeTable`` 添加为其他可执行文件。

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add_executable-MakeTable
  :language: cmake
  :start-after: # first we add the executable that generates the table
  :end-before: # add the command to generate the source code

然后，我们添加一个自定义命令，指定如何通过运行MakeTable生成 ``Table.h``。

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add_custom_command-Table.h
  :language: cmake
  :start-after: # add the command to generate the source code
  :end-before: # add the main library

接下来需要让CMake知道 ``mysqrt.cxx`` 依赖于那个生成的 ``Table.h``。这是通过将 ``Table.h`` 添加到MathFunctions的源码列表达到的。

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add_library-Table.h
  :language: cmake
  :start-after: # add the main library
  :end-before: # state that anybody linking

我们必须将当前目录加入引入目录列表，令 ``Table.h`` 能够被 ``mysqrt.cxx`` 找到并引用。

.. literalinclude:: Step7/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_include_directories-Table.h
  :language: cmake
  :start-after: # state that we depend on our bin
  :end-before: # install rules

现在我们使用已生成的表。首先，修改 ``mysqrt.cxx`` 以引用 ``Table.h``。接着，我们重构 ``mysqrt`` 函数使用这个表：

.. literalinclude:: Step7/MathFunctions/mysqrt.cxx
  :caption: MathFunctions/mysqrt.cxx
  :name: MathFunctions/mysqrt.cxx
  :language: c++
  :start-after: // a hack square root calculation using simple operations

运行 :manual:`cmake  <cmake(1)>` 或者 :manual:`cmake-gui <cmake-gui(1)>` 来配置并构建此项目。

当程序构建时会先构建 ``MakeTable`` 程序。它会运行 ``MakeTable`` 产生 ``Table.h``。最终，它会编译包括 ``Table.h`` 的 ``mysqrt.cxx`` 以产生MathFunctions库。

运行Tutorial程序以验证是否产生使用了这个表。
