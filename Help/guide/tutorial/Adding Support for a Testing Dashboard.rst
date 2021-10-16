步骤8：添加对仪表板的支持
==============================================

将测试结果添加到仪表板很简单。在 :ref:`测试支持 <Tutorial Testing Support>` 我们已经添加了一系列测试到项目中。现在我们必须运行这些测试并将结果添加到仪表板中。为与做到这点，在顶层 ``CMakeLists.txt`` 
中引用 :module:`CTest` 模块。

替换：

.. code-block:: cmake
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-enable_testing-remove

  # 启用测试
  enable_testing()

为：

.. code-block:: cmake
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-include-CTest

  # 启用仪表板脚本
  include(CTest)

:module:`CTest` 模块可以自动调用 ``enable_testing()``，所以我们可以将它将CMake文件中删掉。

We will also need to acquire a ``CTestConfig.cmake`` file to be placed in the
top-level directory where we can specify information to CTest about the
project. It contains:

* The project name

* The project "Nightly" start time

  *  The time when a 24 hour "day" starts for this project.

* The URL of the CDash instance where the submission's generated documents
  will be sent

One has been provided for you in this directory.  It would normally be
downloaded from the ``Settings`` page of the project on the CDash
instance that will host and display the test results.  Once downloaded from
CDash, the file should not be modified locally.

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
