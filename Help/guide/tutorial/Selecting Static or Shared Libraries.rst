步骤10: 选择使用静态库或共享库
=============================================

在本节中，我们将展示如何使用\ :variable:`BUILD_SHARED_LIBS`\ 变量来控制\
:command:`add_library`\ 的默认行为，并允许控制没有显式类型的库（\ ``STATIC``、\
``SHARED``、\ ``MODULE``\ 或者\ ``OBJECT``）是如何构建的。

为此，我们需要将\ :variable:`BUILD_SHARED_LIBS`\ 添加到顶层\ ``CMakeLists.txt``\ 中。\
我们使用\ :command:`option`\ 命令，因为它能用户选择值为\ ``ON``\ 或者\ ``OFF``。

.. literalinclude:: Step11/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-option-BUILD_SHARED_LIBS
  :language: cmake
  :start-after: set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
  :end-before: # 配置头文件，只传递版本号

接下来，我们需要为静态库和共享库指定输出目录。

.. literalinclude:: Step11/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-cmake-output-directories
  :language: cmake
  :start-after: # 这样就不用考虑可执行文件的运行路径
  :end-before: # 配置头文件，只传递版本号

最后，更新\ ``MathFunctions/MathFunctions.h``\ 以使用dll导出的定义：

.. literalinclude:: Step11/MathFunctions/MathFunctions.h
  :caption: MathFunctions/MathFunctions.h
  :name: MathFunctions/MathFunctions.h
  :language: c++

此时，如果您构建了所有内容，您可能会注意到，当我们将一个没有位置独立代码的静态库与一个有位置\
独立代码的库组合在一起时，链接会失败。解决这个问题的方法是当构建共享库时，显式地将SqrtLibrary\
的\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ 属性设置为\ ``True``。

.. literalinclude:: Step11/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-POSITION_INDEPENDENT_CODE
  :language: cmake
  :start-at: # state that SqrtLibrary need PIC when the default is shared libraries
  :end-at:  )

Define ``EXPORTING_MYMATH`` stating we are using ``declspec(dllexport)`` when
building on Windows.

.. literalinclude:: Step11/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-dll-export
  :language: cmake
  :start-at: # define the symbol stating we are using the declspec(dllexport) when
  :end-at: target_compile_definitions(MathFunctions PRIVATE "EXPORTING_MYMATH")

**练习**：我们修改了\ ``MathFunctions.h``\ 以使用dll导出的定义。使用CMake文档你能找到一\
个帮助模块来简化这个吗?
