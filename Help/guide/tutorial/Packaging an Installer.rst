步骤7：构建安装程序
==============================

我们下个愿望是分发工程走让别人使用它。我们想同时分发源码和二进制在不同的平台。这里我们之前讨论的 :guide:`安装和测试 <tutorial/Installing and Testing>` 不同的是，必须要在源码中编译。在此例子中，我们会构建一个安装包以支持二进制安装及包管理。为了达到这个目标我们应该使用CPack创建不同平台的安装包。应该在顶层 ``CMakeLists.txt`` 开头添加几行。

.. literalinclude:: Step8/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-include-CPack
  :language: cmake
  :start-after: # setup installer

这就是我们对它的所有修改。我们在开始包含 :module:`InstallRequiredSystemLibraries`。这个模块会包含当前项目在当前平台下所需的运行时库。接着我们用一些CPack变量以设置当前项目的许可证及版本号。版本号在教程之前的步骤中已经设置，``license.txt`` 已经添加在源码目录的最高层。

最终我们引用 :module:`CPack module <CPack>` 以使用这些变量或者其他属性以我于安装包。

下一步就是按照通常习惯构建程序并运行 :manual:`cpack <cpack(1)>` 命令。生成一个二进制包，你需要在二进制目录运行：

.. code-block:: console

  cpack

若想指定生成器，使用 ``-G`` 选项。对于多配置的构建，使用 ``-C`` 指定配置，如下所示：

.. code-block:: console

  cpack -G ZIP -C Debug

如果想创建一个源码分发包你应该输入：

.. code-block:: console

  cpack --config CPackSourceConfig.cmake

作为替代，运行 ``make package`` 命令或者在IDE中右击 ``Package`` 目标并 ``Build Project``。

运行在二进制目录找到的安装包，验证是否如预期。
