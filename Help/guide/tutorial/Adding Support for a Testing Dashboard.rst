步骤8：添加对仪表板的支持
==============================================

将测试结果添加到仪表板很简单。在 :ref:`测试支持 <Tutorial Testing Support>` 我们已经添加了一系列测试到项目中。现在我们必须运行这些测试并将结果添加到仪表板中。为与做到这点，在顶层 ``CMakeLists.txt`` 
中引用 :module:`CTest` 模块。

替换：

.. code-block:: cmake
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-enable_testing-remove

  # enable testing
  enable_testing()

为：

.. code-block:: cmake
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-include-CTest

  # enable dashboard scripting
  include(CTest)

:module:`CTest` 模块可以自动调用 ``enable_testing()``，所以我们可以将它将CMake文件中删掉。

我们同样需要创建一个 ``CTestConfig.cmake`` 文件在顶层目录以提交到仪表板。

.. literalinclude:: Step9/CTestConfig.cmake
  :caption: CTestConfig.cmake
  :name: CTestConfig.cmake
  :language: cmake

:manual:`ctest <ctest(1)>` 命令运行时会读取此文件。你可以运行 :manual:`cmake <cmake(1)>` 命令或者用 :manual:`cmake-gui <cmake-gui(1)>` 去配置这项目，但没去构建它。相应替代的，修改二进制树目录，并运行：

.. code-block:: console

  ctest [-VV] -D Experimental

不要忘了，对于多配置的生成器（比如Visual Studio），配置必须指定：

.. code-block:: console

  ctest [-VV] -C Debug -D Experimental

或者直接在IDE中编译 ``Experimental`` 目标。

:manual:`ctest <ctest(1)>` 命令将构建并将结果提交到Kitware的公共仪表板：https://my.cdash.org/index.php?project=CMakeTutorial。
