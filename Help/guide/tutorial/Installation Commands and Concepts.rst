步骤9： 安装命令和概念
==========================================

项目不仅需要构建和测试代码，还需要将其提供给用户使用。构建树中的文件布局不适合\
其他项目使用：二进制文件位于非预期位置，头文件在源代码树中位置过深，并且没有明确\
的方法来了解提供了哪些目标或如何使用它们。

将制品从源代码树和构建树移动到适合使用的最终布局的过程被称为安装。CMake支持\
将完整的安装工作流程作为项目描述的一部分，它既控制安装树中制品的布局，也为其他想\
要使用安装树提供的库的CMake项目重建目标。

背景
^^^^^^^^^^

所有CMake安装都通过一个命令完成，即\ :command:`install`，该命令分为许多子命令，\
负责安装过程的各个方面。对于基于目标的CMake工作流，通常只需使用\
:command:`install(TARGETS)`\ 来安装目标本身即可，而无需使用\ :command:`install(FILES)`\
或\ :command:`install(DIRECTORY)`\ 手动移动文件。

.. note::
  这就是为什么我们需要将\ ``FILES``\ 添加到旨在被安装的头文件集中。当关联的目标\
  被安装时，CMake需要能够定位这些文件。

CMake将基于目标的安装划分为多种制品类型。可用的制品类型（在CMake 3.23中）包括：

  ``ARCHIVE``
    静态库（\ ``.a`` / ``.lib``\ ）、DLL导入库（\ ``.lib``\ ）以及其他少量“类归档”对象。

  ``LIBRARY``
    共享库（\ ``.so``\ ）、模块和其他动态可加载对象。\ **不**\ 包括Windows的DLL\
    文件（\ ``.dll``\ ）或MacOS框架。

  ``RUNTIME``
    各种可执行文件（MacOS捆绑包除外）；以及Windows的DLL文件（\ ``.dll``\ ）。

  ``OBJECT``
    来自\ ``OBJECT``\ 库的对象文件。

  ``FRAMEWORK``
    静态和共享MacOS框架

  ``BUNDLE``
    MacOS捆绑包可执行文件

  ``PUBLIC_HEADER`` / ``PRIVATE_HEADER`` / ``RESOURCE``
    由\ :prop_tgt:`PUBLIC_HEADER`、\ :prop_tgt:`PRIVATE_HEADER`\ 和\
    :prop_tgt:`RESOURCE`\ 目标属性描述的文件，通常用于MacOS框架。

  ``FILE_SET <set-name>``
    与目标关联的文件集。这是头文件通常的安装方式。

大多数重要的制品类型都有已知的默认安装路径，CMake会默认安装到这些路径，除非明确\
指定其他路径。例如，如果变量可用，\ ``RUNTIME``\ 类型将安装到由\
:module:`CMAKE_INSTALL_BINDIR <GNUInstallDirs>`\ 指定的位置，否则默认安装到\
``bin``\ 目录。

与使用\ :option:`cmake -B`\ 控制CMake使用的构建目录类似，我们也有多种选项来告知CMake\
将内容安装到何处。这个位置通常被称为安装前缀（install prefix）。若要在配置时设置它，\
使得使用该构建树执行的每次\ :option:`cmake --install`\ 都默认使用指定的前缀，我们可以\
使用以下任一方式：

* :option:`cmake --install-prefix`\ 选项；
* CMake预置文件中的\ :ref:`installDir <CMakePresets.configurePresets.installDir>`\ 字段；或
* :variable:`CMAKE_INSTALL_PREFIX`\ 变量。

.. note::
  我们不建议在项目内部设置\ ``CMAKE_``\ 变量。设置\ :variable:`CMAKE_INSTALL_PREFIX`\
  是\ *尤其*\ 不好的做法，除非有非常充分的理由，因为它会阻止用户覆盖该值。在提供默认值时，\
  项目应检查\ :variable:`CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT`。

另外，我们还可以使用\ :option:`cmake --install --prefix <cmake--install --prefix>`\
选项为单次安装调用设置安装前缀。

各类构建产物默认安装目标的完整列表如下表所述。

=============================== =============================== ======================
      目标类型                                 变量                内置默认值
=============================== =============================== ======================
``RUNTIME``                     ``${CMAKE_INSTALL_BINDIR}``     ``bin``
``LIBRARY``                     ``${CMAKE_INSTALL_LIBDIR}``     ``lib``
``ARCHIVE``                     ``${CMAKE_INSTALL_LIBDIR}``     ``lib``
``PRIVATE_HEADER``              ``${CMAKE_INSTALL_INCLUDEDIR}`` ``include``
``PUBLIC_HEADER``               ``${CMAKE_INSTALL_INCLUDEDIR}`` ``include``
``FILE_SET`` (type ``HEADERS``) ``${CMAKE_INSTALL_INCLUDEDIR}`` ``include``
=============================== =============================== ======================

在大多数情况下，项目应保持默认设置，除非需要将文件安装到默认位置的特定子目录中。

CMake默认不定义\ ``CMAKE_INSTALL_<dir>``\ 变量。如果项目希望指定安装到这些位置中\
的某个子目录，则需要包含\ :module:`GNUInstallDirs`\ 模块，该模块将为所有尚未定义的\
``CMAKE_INSTALL_<dir>``\ 变量提供值。

练习1 - 安装制品
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

对于现代的、基于目标的CMake项目，制品的安装非常简单，只需调用一次\
:command:`install(targets)`\ 命令即可。

.. code-block:: cmake

  install(
    TARGETS MyApp MyLib

    FILE_SET HEADERS
    FILE_SET anotherHeaderFileSet
  )

大多数制品类型默认会被安装，无需在\ :command:`install`\ 命令中列出。但是，\
``FILE_SET``\ 必须命名，以让CMake知道你想要安装它们。在上面的示例中，我们安装了\
两个文件集，一个名为\ ``HEADERS``，另一个名为\ ``anotherHeaderFileSet``。

当命名制品类型时，可以为其指定各种选项，例如目标路径。

.. code-block:: cmake

  include(GNUInstallDirs)

  install(
    TARGETS MyApp MyLib

    RUNTIME
      DESTINATION ${CMAKE_INSTALL_BINDIR}/Subfolder

    FILE_SET HEADERS
  )

这会将\ ``MyApp``\ 目标安装到\ ``bin/Subfolder``\ 目录（如果打包者未修改\
:module:`CMAKE_INSTALL_BINDIR <GNUInstallDirs>`\ ）。

重要的是，如果\ ``OBJECT``\ 制品类型从未被指定目标路径，它将表现得像一个\
``INTERFACE``\ 库，只安装其头文件。

目标
----

安装教程项目中描述的库和可执行文件（测试除外）的制品。

参考资源
-----------------

* :command:`install`
* :option:`cmake --install-prefix`
* :option:`cmake --install --prefix <cmake--install --prefix>`

待编辑文件
-------------

* ``CMakeLists.txt``

开始操作
---------------

``Help/guide/tutorial/Step9``\ 目录包含针对\ ``Step8``\ 的完整推荐解决方案。完成\
``TODO 1``\ 和\ ``TODO 2``。

构建和运行
-------------

无需特殊配置，按常规方式进行配置和构建即可。

.. code-block:: console

  cmake --preset tutorial
  cmake --build build

我们可以使用\ :option:`cmake --install`\ 选项验证安装是否正确。

.. note::

  与CTest类似，当使用Visual Studio等多配置生成器时，需要通过\
  :option:`cmake --install --config <cmake--install --config>`\ 来指定配置，例如\
  ``Debug``\ 或\ ``Release``。只要使用多配置生成器就需如此操作，后续命令中不再单独说明。

.. code-block:: console

  cmake --install build --prefix install

``install``\ 文件夹应正确填充我们的制品。

解决方案
--------

首先，我们为条件构建的（因此也是条件安装的）\ ``Tutorial``\ 可执行文件添加一个\
:command:`install(TARGETS)`\ 命令。

.. raw:: html

  <details><summary>TODO 1点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-install-tutorial

  if(TUTORIAL_BUILD_UTILITIES)
    add_subdirectory(Tutorial)
    install(
      TARGETS Tutorial
    )
  endif()

.. raw:: html

  </details>

然后我们可以安装其余目标。

.. raw:: html

  <details><summary>TODO 2点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 2: CMakeLists.txt
  :name: CMakeLists.txt-install-libs

  install(
    TARGETS MathFunctions OpAdd OpMul OpSub MathLogger SqrtTable
    FILE_SET HEADERS
  )

.. raw:: html

  </details>

.. note::
  我们可以在定义目标的每个子文件夹中本地添加\ :command:`install(TARGETS)`\ 命令。\
  这在大型项目中很常见，因为在这类项目中很难跟踪所有可安装的目标。

安装\ ``SqrtTable``\ 和\ ``MathLogger``\ 看起来可能没有必要，在当前阶段确实如此。\
但由于CMake对目标关系的建模方式，当我们在下一个练习中重建目标模型时，我们将需要\
这些目标可用。

练习2 - 导出目标
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

这种已安装文件的原始集合是一个良好的开端，但我们失去了CMake目标模型。它们实际上\
并不比我们在\ ``Step 4``\ 中讨论的预编译第三方库更好。我们需要某种方法，让其他\
项目能够从我们在安装树中提供的内容重建我们的目标。

CMake提供的解决此问题的机制是一种名为“目标导出文件”的CMakeLang文件。它由\
:command:`install(EXPORT)`\ 命令创建。

.. code-block:: cmake

  install(
    TARGETS MyApp MyLib
    EXPORT MyProjectTargets
  )

  include(GNUInstallDirs)

  install(
    EXPORT MyProjectTargets
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/MyProject
    NAMESPACE MyProject::
  )

上述示例包含几个部分。首先，\ :command:`install(TARGETS)`\ 命令接受一个导出名称，\
本质上是一个用于添加已安装目标的列表。

之后，\ :command:`install(EXPORT)`\ 命令使用此目标列表生成目标导出文件。这将是\
一个名为\ ``<ExportName>.cmake``\ 的文件，位于指定的\ ``DESTINATION``\ 中。本示\
例中提供的\ ``DESTINATION``\ 是常规位置，但任何可被\ :command:`find_package`\
命令搜索到的位置都是有效的。

最后，由目标导出文件创建的目标将以\ ``NAMESPACE``\ 字符串为前缀，即它们的形式为\
``<NAMESPACE><TargetName>``。通常，这是项目名称后接两个冒号。

由于在后续步骤中会更清楚的原因，我们通常不直接使用此文件。而是通过\
:command:`include()`\ 命令让名为\ ``<ProjectName>Config.cmake``\ 的文件来使用它。

.. code-block:: cmake

  include(${CMAKE_CURRENT_LIST_DIR}/MyProjectTargets.cmake)

.. note::
  :variable:`CMAKE_CURRENT_LIST_DIR`\ 变量表示当前运行的CMake语言文件所在的目录，\
  无论该文件是如何被包含或启动的。

然后，此文件通过\ :command:`install(FILES)`\ 命令与目标导出文件一起安装。

.. code-block:: cmake

  install(
    FILES
      cmake/MyProjectConfig.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/MyProject
  )

.. note::
  此文件的名称及其位置由\ :command:`find_package`\ 命令的发现语义决定，我们将在\
  下一步中详细讨论。

目标
----

导出Tutorial项目的目标，以便其他项目可以使用它们。

参考资源
-----------------

* :command:`install`
* :module:`GNUInstallDirs`
* :variable:`CMAKE_CURRENT_LIST_DIR`

待编辑文件
-------------

* ``CMakeLists.txt``
* ``cmake/TutorialConfig.cmake``

开始操作
---------------

继续编辑\ ``Help/guide/tutorial/Step9``\ 目录中的文件。完成\ ``TODO 3``\ 至\ ``TODO 8``。

构建和运行
-------------

构建命令足以重新配置项目。

.. code-block:: console

  cmake --build build

我们可以使用\ :option:`cmake --install`\ 验证安装是否正确。

.. code-block:: console

  cmake --install build --prefix install

.. note::
  CMake不会更新未更改的文件，仅从构建树和源代码树安装新的或已更新的文件。

``install``\ 文件夹应正确填充我们的制品和导出文件。我们将在下一步中演示如何使用\
这些文件。

解决方案
--------

首先，我们将\ ``Tutorial``\ 目标添加到\ ``TutorialTargets``\ 导出中。

.. raw:: html

  <details><summary>TODO 3点击显示/隐藏答案</summary>

.. literalinclude:: Step10/TutorialProject/CMakeLists.txt
  :caption: TODO 3: CMakeLists.txt
  :name: CMakeLists.txt-install-tutorial-export
  :language: cmake
  :start-at: install(
  :end-at: )

.. raw:: html

  </details>

很快我们将需要访问\ ``CMAKE_INSTALL_<dir>``\ 变量，因此接下来我们包含\
:module:`GNUInstallDirs`\ 模块。

.. raw:: html

  <details><summary>TODO 4点击显示/隐藏答案</summary>

.. literalinclude:: Step10/TutorialProject/CMakeLists.txt
  :caption: TODO 4: CMakeLists.txt
  :name: CMakeLists.txt-gnuinstalldirss
  :language: cmake
  :start-at: include(GNUInstallDirs)
  :end-at: include(GNUInstallDirs)

.. raw:: html

  </details>

现在我们将其余目标添加到\ ``TutorialTargets``\ 导出中。

.. raw:: html

  <details><summary>TODO 5点击显示/隐藏答案</summary>

.. literalinclude:: Step10/TutorialProject/CMakeLists.txt
  :caption: TODO 5: CMakeLists.txt
  :name: CMakeLists.txt-install-libs-export
  :language: cmake
  :start-at: TARGETS MathFunctions
  :end-at: )
  :prepend: install(

.. raw:: html

  </details>

接下来我们安装导出本身，以生成我们的目标导出文件。

.. raw:: html

  <details><summary>TODO 6点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 6: CMakeLists.txt
  :name: CMakeLists.txt-install-export

  install(
    EXPORT TutorialTargets
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Tutorial
    NAMESPACE Tutorial::
  )

.. raw:: html

  </details>

然后我们安装我们的“配置”文件，我们将用它来包含我们的目标导出文件。

.. raw:: html

  <details><summary>TODO 7点击显示/隐藏答案</summary>

.. code-block:: cmake
  :caption: TODO 7: CMakeLists.txt
  :name: CMakeLists.txt-install-config

  install(
    FILES
      cmake/TutorialConfig.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Tutorial
  )

.. raw:: html

  </details>

最后，我们可以将必要的\ :command:`include`\ 命令添加到配置文件中。

.. raw:: html

  <details><summary>TODO 8点击显示/隐藏答案</summary>

.. literalinclude:: Step10/TutorialProject/cmake/TutorialConfig.cmake
  :caption: TODO 8: cmake/TutorialConfig.cmake
  :name: cmake/TutorialConfig.cmake
  :language: cmake
  :start-at: include
  :end-at: include

.. raw:: html

  </details>

练习3 - 导出版本文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

从目标导出文件导入CMake目标时，无法“退出”或“撤销”该操作。如果发现某个包是我们请\
求版本的错误或不兼容版本，我们将受困于在了解版本信息过程中产生的任何副作用。

CMake 为解决此问题提供的方案是一种轻量级版本文件，它仅描述此版本兼容性信息，\
可以在CMake提交完全导入文件之前进行检查。

CMake提供了用于生成这些版本文件的辅助模块和脚本，即\
:module:`CMakePackageConfigHelpers`\ 模块。

.. code-block:: cmake

  include(CMakePackageConfigHelpers)

  write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/MyProjectConfigVersion.cmake
    COMPATIBILITY ExactVersion
  )

可用的版本类型包括：

* ``AnyNewerVersion``
* ``SameMajorVersion``
* ``SameMinorVersion``
* ``ExactVersion``

此外，软件包可以将自身标记为\ ``ARCH_INDEPENDENT``\ （架构无关），适用于不包含会\
将其绑定到特定机器架构的二进制文件的软件包。

默认情况下，\ ``write_basic_package_version_file()``\ 使用的\ ``VERSION``\
是传递给\ :command:`project`\ 命令的\ ``VERSION``\ 号。

目标
----

为Tutorial项目导出版本文件。

参考资源
-----------------

* :command:`project`
* :command:`install`
* :module:`CMakePackageConfigHelpers`
* :variable:`PROJECT_VERSION`

待编辑文件
-------------

* ``CMakeLists.txt``

开始操作
---------------

继续编辑\ ``Help/guide/tutorial/Step9``\ 目录中的文件。\
完成\ ``TODO 9``\ 至\ ``TODO 12``。

构建和运行
-------------

按照之前的步骤重新构建并安装。

.. code-block:: console

  cmake --build build
  cmake --install build --prefix install

``install``\ 文件夹应正确填充我们新生成并安装的版本文件。

解决方案
--------

首先，我们向\ :command:`project`\ 命令添加 ``VERSION`` 参数。

.. raw:: html

  <details><summary>TODO 9点击显示/隐藏答案</summary>

.. literalinclude:: Step10/TutorialProject/CMakeLists.txt
  :caption: TODO 9: CMakeLists.txt
  :name: CMakeLists.txt-project-version
  :language: cmake
  :start-at: project(
  :end-at: )

.. raw:: html

  </details>

接下来，我们包含\ :module:`CMakePackageConfigHelpers`\ 模块并使用它生成配置版本文件。

.. raw:: html

  <details><summary>TODO 10-11点击显示/隐藏答案</summary>

.. literalinclude:: Step10/TutorialProject/CMakeLists.txt
  :caption: TODO 10-11: CMakeLists.txt
  :name: CMakeLists.txt-write_basic_package_version_file
  :language: cmake
  :start-at: include(CMakePackageConfigHelpers
  :end-at: COMPATIBILITY ExactVersion
  :append: )

.. raw:: html

  </details>

最后，我们将配置版本文件添加到待安装文件列表中。

.. raw:: html

  <details><summary>TODO 12点击显示/隐藏答案</summary>

.. literalinclude:: Step10/TutorialProject/CMakeLists.txt
  :caption: TODO 12: CMakeLists.txt
  :name: CMakeLists.txt-install-version-config
  :language: cmake
  :start-at: FILES
  :end-at: )
  :prepend: install(

.. raw:: html

  </details>
