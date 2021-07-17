步骤4：安装和测试
==============================

现在我们可以开始向我们的项目添加安装规则和测试支持了。

安装规则
-------------

安装规则相当简单：对于 ``MathFunctions``，我们希望安装库和头文件，对于应用程序，我们希望安装可执行和配置的头文件。

所以在 ``MathFunctions/CMakeLists.txt`` 的末尾添加：

.. literalinclude:: Step5/MathFunctions/CMakeLists.txt
  :caption: MathFunctions/CMakeLists.txt
  :name: MathFunctions/CMakeLists.txt-install-TARGETS
  :language: cmake
  :start-after: # install rules

顶层 ``CMakeLists.txt`` 的末尾添加：

.. literalinclude:: Step5/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-install-TARGETS
  :language: cmake
  :start-after: # add the install targets
  :end-before: # enable testing

这就是创建基本本地安装的全部内容。

现在可以运行 :manual:`cmake  <cmake(1)>` 或者 :manual:`cmake-gui <cmake-gui(1)>` 来配置并用构建工具来构建它。

接着使用 :manual:`cmake  <cmake(1)>` 命令的 ``install`` 选项（3.15版本开始，之前版本的CMake必须使用 ``make install``）在命令行安装。对于多配置的工具，记得用 ``--config`` 来指定配置。若使用IDE，只需构建 ``INSTALL`` 目标。这一步将安装相应的头文件、库和可执行文件，例子：

.. code-block:: console

  cmake --install .

:variable:`CMAKE_INSTALL_PREFIX` 变量用于指定安装目录。在运行 ``cmake --install`` 命令的时候，会被 ``--prefix`` 参数覆盖。例如：

.. code-block:: console

  cmake --install . --prefix "/home/myuser/installdir"

导航到安装目录并验证程序能否运行。

.. _`Tutorial Testing Support`:

测试支持
---------------

接下来测试一下我们的程序。可以在顶层的 ``CMakeLists.txt`` 文件末尾启用测试，然后添加一些基本的测试用例来验证程序是否正常。

.. literalinclude:: Step5/CMakeLists.txt
  :caption: CMakeLists.txt
  :name: CMakeLists.txt-enable_testing
  :language: cmake
  :start-after: # enable testing

第一个测试只是验证程序能否运行，是否出现段错误或者崩溃，返回值是否为0。这就是基本的CMake测试。

下一个测试使用 :prop_test:`PASS_REGULAR_EXPRESSION` 测试属性来验证测试输出是否包含某些字符串。这个例子中，验证当提供的参数数量不正确时，是否输出相关信息。

最后，有一个 ``do_test`` 函数，它运行程序并验证计算出来的平方根对于给定的输入是否正确。对于每次调用 ``do_test``，都会将另一个测试添加到项目中，并通过的参数传递名称、输入及预期结果。

重新构建程序并进入程序目录，运行 :manual:`ctest <ctest(1)>` 命令：``ctest -N`` 和 ``ctest -VV``。对于多配置生成器（例如Visual Studio），必须指定配置类型。例如，要在调试模式下运行测试，可以在构建目录（而不是Debug目录！）中运行  ``ctest -C Debug -VV``。或者，在IDE构建 ``RUN_TESTS`` 目标。
