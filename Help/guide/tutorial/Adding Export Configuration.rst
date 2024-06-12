步骤11：添加导出配置
====================================

在\ :guide:`安装和测试 <tutorial/Installing and Testing>`\ 教程中，我们增加了CMake\
安装项目库和头文件的能力。在\ :guide:`构建安装程序 <tutorial/Packaging an Installer>`\
期间，我们添加了打包这些信息的功能，以便将其分发给其他人。

下一步是添加必要的信息，以便其他CMake项目可以使用我们的项目，无论是在构建目录、本地安装还是\
打包时。

第一步是更新我们的\ :command:`install(TARGETS)`\ 命令，不仅指定\ ``DESTINATION``，还\
指定\ ``EXPORT``。\ ``EXPORT``\ 关键字生成并安装一个CMake文件，其中包含从安装树导入安装\
命令中列出的所有目标的代码。所以让我们继续，通过更新\ ``MathFunctions/CMakeLists.txt``\
中的\ ``install``\ 命令来显式\ ``EXPORT`` ``MathFunctions``\ 库，如下所示：

.. literalinclude:: Complete/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-install-TARGETS-EXPORT
  :language: cmake
  :start-after: # install libs

现在我们已经导出了\ ``MathFunctions``，我们还需要显式安装生成的\
``MathFunctionsTargets.cmake``\ 文件。这是通过在顶层\ ``CMakeLists.txt``\ 的底部添\
加以下内容来实现的：

.. literalinclude:: Complete/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-install-EXPORT
  :language: cmake
  :start-after: # install the configuration targets
  :end-before: include(CMakePackageConfigHelpers)

此时，你应该尝试运行CMake。如果一切都设置正确，你会看到CMake将产生一个错误，看起来像：

.. code-block:: console

  Target "MathFunctions" INTERFACE_INCLUDE_DIRECTORIES property contains
  path:

    "/Users/robert/Documents/CMakeClass/Tutorial/Step11/MathFunctions"

  which is prefixed in the source directory.

CMake在生成导出信息时告诉你这一点
它将导出一个本质上与当前机器绑定的路径
在其他机器上无效。解决这个问题的方法是更新\ ``MathFunctions``\ 的\
:command:`target_include_directories`，以理解在构建目录和安装/包中使用它时需要不同的\
``INTERFACE``\ 位置。这意味着将\ ``MathFunctions``\ 的\
:command:`target_include_directories` \调用转换成如下所示：

.. literalinclude:: Step12/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-target_include_directories
  :language: cmake
  :start-after: # 我们自己除外
  :end-before: # 是否使用自己的数学函数

一旦它被更新，我们可以重新运行CMake并验证它不再发出警告。

此时，我们已经让CMake正确地打包了所需的目标信息，但我们仍然需要生成\
``MathFunctionsConfig.cmake``。让CMake的\ :command:`find_package`\ 命令可以找到我\
们的项目。因此，让我们继续往项目的顶层添加一个名为\ ``Config.cmake.in``\ 的新文件。内附以\
下内容：

.. literalinclude:: Step12/Config.cmake.in
  :caption: Config.cmake.in
  :name: Config.cmake.in

然后，为了正确地配置和安装该文件，将以下文件添加到顶层\ ``CMakeLists.txt``\ 的底部：

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-install-Config.cmake
  :language: cmake
  :start-after: # 安装配置目标
  :end-before: # 生成包含导出的配置文件


接下来，我们执行\ :command:`configure_package_config_file`。该命令将配置提供的文件，\
但与标准\ :command:`configure_file`\ 方法有一些特定的区别。为了正确地使用这个函数，除了\
所需的内容外，输入文件应该有一行文本\ ``@PACKAGE_INIT@``。该变量将被一个代码块替换，该代\
码块将把设置值转换为相对路径。这些新值可以通过相同的名称引用，但可以在其前面加上\
``PACKAGE_``\ 前缀。

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-configure-package-config.cmake
  :language: cmake
  :start-after: # 安装配置目标
  :end-before: # 为配置文件生成版本文件

接下来是\ :command:`write_basic_package_version_file`。该命令写入\
:command:`find_package`\ 文档所使用的文件，以确定所需包的版本和兼容性。在这里，我们使用\
``Tutorial_VERSION_*``\ 变量，并说它与\ ``AnyNewerVersion``\ 兼容，这表示该版本或任\
何更高版本与请求的版本兼容。

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-basic-version-file.cmake
  :language: cmake
  :start-after: # 为配置文件生成版本文件
  :end-before: # 安装生成的配置文件

最后，将两个生成的文件设置为需安装：

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-install-configured-files.cmake
  :language: cmake
  :start-after: # 安装生成的配置文件
  :end-before: # 为构建树生成导出目标

至此，我们已经为我们的项目生成了一个可重定位的CMake配置，可以在安装或打包项目之后使用。如果\
我们想要我们的项目也从一个构建目录中使用，我们只需要添加以下顶层\ ``CMakeLists.txt``\ 的底部：

.. literalinclude:: Step12/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-export
  :language: cmake
  :start-after: # needs to be after the install(TARGETS) command

使用这个导出调用，我们现在生成一个\ ``MathFunctionsTargets.cmake``，允许配置\
``MathFunctionsConfig.cmake``\ 文件，以供其他项目使用，而无需安装。
