步骤9：选择使用静态库和共享库
============================================

在本节中，我们将展示如何使用 :variable:`BUILD_SHARED_LIBS` 变量来控制 :command:`add_library` 的默认行为，并允许控制没有显式类型的库（``STATIC``、``SHARED``、``MODULE`` 或者 ``OBJECT``）是如何构建的。

为此，我们需要将 :variable:`BUILD_SHARED_LIBS` 添加到顶层 ``CMakeLists.txt`` 中。我们使用 :command:`option` 命令，因为它能用户选择值为ON或者OFF。

接下来，我们将重构MathFunctions，使其成为一个使用 ``mysqrt`` 或 ``sqrt`` 封装的真正的库，而不是要求在代码处理这些逻辑。这也意味着 ``USE_MYMATH`` 将不再控制构建MathFunctions，而是控制这个库的行为。

第一步是像下面那样更新顶层 ``CMakeLists.txt``：

.. literalinclude:: Step10/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-option-BUILD_SHARED_LIBS
  :language: cmake
  :end-before: # add the binary tree

现在我们已经使 ``MathFunctions`` 始终被使用，需要更新这个库的逻辑。因此，在 ``MathFunctions/CMakeLists.txt`` 中需要创建一个当 ``USE_MYMATH`` 被启用时有条件构建和安装的SqrtLibrary。现在，由于这是一个教程，我们明确要求SqrtLibrary是静态构建的。

``MathFunctions/CMakeLists.txt`` 最终应该像下面那样：

.. literalinclude:: Step10/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-add_library-STATIC
  :language: cmake
  :lines: 1-36,42-

接下来使用 ``mathfunctions`` 函数及 ``detail`` 命名空间修改 ``MathFunctions/mysqrt.cxx``：

.. literalinclude:: Step10/MathFunctions/mysqrt.cxx
  :caption: MathFunctions/mysqrt.cxx
  :name: MathFunctions/mysqrt.cxx-namespace
  :language: c++

我们还需要在 ``tutorial.cxx`` 中做一些修改，使它不再使用 ``USE_MYMATH``：

#. 总是包含 ``MathFunctions.h``
#. 总是使用 ``mathfunctions::sqrt``
#. 不再引用 ``cmath``

最后，更新 ``MathFunctions/MathFunctions.h`` 以使用dll导出的定义：

.. literalinclude:: Step10/MathFunctions/MathFunctions.h
  :caption: MathFunctions/MathFunctions.h
  :name: MathFunctions/MathFunctions.h
  :language: c++

此时，如果您构建了所有内容，您可能会注意到，当我们将一个没有位置独立代码的静态库与一个有位置独立代码的库组合在一起时，链接会失败。解决这个问题的方法是不管构建类型，显式地将SqrtLibrary的 :prop_tgt:`POSITION_INDEPENDENT_CODE` 属性设置为  ``True``。

.. literalinclude:: Step10/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-POSITION_INDEPENDENT_CODE
  :language: cmake
  :lines: 37-42

**练习**：我们修改了 ``MathFunctions.h`` 以使用dll导出的定义。使用CMake文档你能找到一个帮助模块来简化这个吗?
