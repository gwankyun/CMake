步骤6: 添加对测试仪表板的支持
==============================================

添加向仪表板提交测试结果的支持很简单。我们已经在\ :ref:`测试支持 <Tutorial Testing Support>`\
中为我们的项目定义了许多测试。现在我们只需要运行这些测试并提交给CDash。


练习1 - 将结果发送到测试仪表板
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

目标
----

使用CDash展示CTest结果。

有用的资源
-----------------

* :manual:`ctest(1)`
* :command:`include`
* :module:`CTest`

待编辑的文件
-------------

* ``CMakeLists.txt``

开始
---------------

对于这个练习，通过包含\ :module:`CTest`\ 模块来完成顶层\ ``CMakeLists.txt``\ 中的\
``TODO 1``。这将允许使用CTest进行测试，并将仪表盘提交给CDash，因此我们可以安全地删除对\
:command:`enable_testing`\ 的调用。

我们还需要获取一个\ ``CTestConfig.cmake``\ 文件，将其放置在顶层目录中。运行的时候，\
:manual:`ctest <ctest(1)>`\ 可执行文件将读取该文件以收集有关测试仪表板的信息。它包含：

* 项目名称

* 项目“夜间”开始时间

  * 项目24小时“一天”开始的时间。

* 将在其中发送提交生成的文档的CDash实例的URL

在本教程中，将使用一个公共仪表板服务器，并在此步骤的根目录中为你提供相应的\
``CTestConfig.cmake``\ 文件。在实践中，这个文件将从用于承载测试结果的CDash实例上的项目\
``Settings``\ 页面下载。从CDash下载后，不应该在本地修改该文件。

.. literalinclude:: Step7/CTestConfig.cmake
  :caption: CTestConfig.cmake
  :name: CTestConfig.cmake
  :language: cmake


构建并运行
-------------

请注意，作为CDash提交的一部分，关于你的开发系统的一些信息（例如站点名称或完整路径名）可能会\
公开显示。

要创建一个简单的测试仪表板，请运行\ :manual:`cmake <cmake(1)>`\ 可执行文件或\
:manual:`cmake-gui <cmake-gui(1)>`\ 来配置项目，但先不要构建它。相反，导航到build目录\
并运行：

.. code-block:: console

  ctest [-VV] -D Experimental

不要忘了，对于多配置的生成器（比如Visual Studio），配置必须指定：

.. code-block:: console

  ctest [-VV] -C Debug -D Experimental

或者直接在IDE中编译\ ``Experimental``\ 目标。

:manual:`ctest <ctest(1)>`\ 可执行文件将构建项目，运行任何测试，并将结果提交到Kitware的\
公共仪表板：https://my.cdash.org/index.php?project=CMakeTutorial。

解决方案
--------

在这一步中唯一需要修改的CMake代码是通过在顶层的\ ``CMakeLists.txt``\ 中包含\
:module:`CTest`\ 模块来启用仪表板提交到CDash：

.. raw:: html

  <details><summary>TODO 1: 点击显示/隐藏答案</summary>

.. literalinclude:: Step7/CMakeLists.txt
  :caption: TODO 1: CMakeLists.txt
  :name: CMakeLists.txt-include-CTest
  :language: cmake
  :start-after: # 启用测试
  :end-before: # 程序是否运行

.. raw:: html

  </details>
