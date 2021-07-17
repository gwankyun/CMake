步骤3：添加库的使用需求
===============================================

使用需求允许对库或可执行文件的链接和include行进行更好的控制，同时也允许对CMake内部目标的传递属性进行更多的控制。利用使用需求的主要命令是：

  - :command:`target_compile_definitions`
  - :command:`target_compile_options`
  - :command:`target_include_directories`
  - :command:`target_link_libraries`

让我们从 :guide:`添加库 <tutorial/Adding a Library>` 开始重构代码，以使用现代的CMake方法满足使用需求。我们首先声明，任何链接到 ``MathFunctions`` 的人都需要包括当前的源目录，而 ``MathFunctions`` 本身不需要。因此，这可以成为一个 ``INTERFACE`` 使用要求。

记住 ``INTERFACE`` 指的是消费者需要但生产者不需要的东西。在 ``MathFunctions/CMakeLists.txt`` 的末尾添加以下几行：

.. literalinclude:: Step4/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_include_directories-INTERFACE
  :language: cmake
  :start-after: # to find MathFunctions.h

现在我们已经指定了 ``MathFunctions`` 的使用要求，我们可以安全地从顶层的 ``CMakeLists.txt`` 中删除 ``EXTRA_INCLUDES`` 变量的使用，这里：

.. literalinclude:: Step4/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: # add the MathFunctions library
  :end-before: # add the executable

和这里：

.. literalinclude:: Step4/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-target_include_directories-remove-EXTRA_INCLUDES
  :language: cmake
  :start-after: # so that we will find TutorialConfig.h

一旦完成，运行 :manual:`cmake  <cmake(1)>` 命令或者 :manual:`cmake-gui <cmake-gui(1)>` 来配置项目，然后用你选择的构建工具或使用 ``cmake --build .`` 在构建目录来构建它。
