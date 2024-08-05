add_test
--------

向由\ :manual:`ctest(1)`\ 运行的项目添加一个测试。

.. code-block:: cmake

  add_test(NAME <name> COMMAND <command> [<arg>...]
           [CONFIGURATIONS <config>...]
           [WORKING_DIRECTORY <dir>]
           [COMMAND_EXPAND_LISTS])

​添加一个名为\ ``<name>``\ 的测试。测试名可以包含任意字符，必要时用\ :ref:`Quoted Argument`\
或\ :ref:`Bracket Argument`\ 表示。参见策略\ :policy:`CMP0110`。

​CMake仅在调用\ :command:`enable_testing`\ 命令时生成测试。除非\ ``BUILD_TESTING``\
设置为\ ``OFF``，否则\ :module:`CTest`\ 模块会自动调用\ ``enable_testing``。

​通过\ ``add_test(NAME)``\ 签名添加的测试支持在\ :command:`set_property(TEST)`\ 或\
:command:`set_tests_properties`\ 设置的测试属性中使用\
:manual:`生成器表达式 <cmake-generator-expressions(7)>`。测试属性只能在创建测试的目录中设置。

``add_test``\ 选项有：

``COMMAND``
  ​指定测试命令行。

  ​如果\ ``<command>``\ 指定由\ :command:`add_executable`\ 创建的可执行目标：

  * ​它将自动被构建时创建的可执行文件的位置替换。

  * .. versionadded:: 3.3

      目标的\ :prop_tgt:`CROSSCOMPILING_EMULATOR`，如果设置了，将用于在主机上运行命令：\ ::

        <emulator> <command>

      .. versionchanged:: 3.29

        仅在\ :variable:`交叉编译 <CMAKE_CROSSCOMPILING>`\ 时使用模拟器。参见策略\
        :policy:`CMP0158`。

  * .. versionadded:: 3.29

      如果设置了目标的\ :prop_tgt:`TEST_LAUNCHER`，将用于启动命令：\ ::

        <launcher> <command>

      ​如果也设置了\ :prop_tgt:`CROSSCOMPILING_EMULATOR`，则两者都会使用：\ ::

        <launcher> <emulator> <command>

  ​该命令可以使用\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 指定。

``CONFIGURATIONS``
  ​限制只对命名配置执行测试。

``WORKING_DIRECTORY``
  ​设置测试属性\ :prop_test:`WORKING_DIRECTORY`，在其中执行测试。如果没有指定，将在\
  :variable:`CMAKE_CURRENT_BINARY_DIR`\ 中运行测试。工作目录可以使用\
  :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 指定。

``COMMAND_EXPAND_LISTS``
  .. versionadded:: 3.16

  ``COMMAND``\ 参数中的列表将被扩展，包括那些用\
  :manual:`生器表达式 <cmake-generator-expressions(7)>`\ 创建的列表。

​如果测试命令以代码\ ``0``\ 退出，则测试通过。非零的退出代码是一个“失败”的测试。测试属性\
:prop_test:`WILL_FAIL`\ 会反转​这个逻辑。请注意，系统级测试，如分段错误或堆错误，总会失败，\
即使\ ``WILL_FAIL``\ 为true。写入stdout或stderr的输出由\ :manual:`ctest(1)`\ 捕获，\
仅通过\ :prop_test:`PASS_REGULAR_EXPRESSION`、\ :prop_test:`FAIL_REGULAR_EXPRESSION`\
或\ :prop_test:`SKIP_REGULAR_EXPRESSION`\ 测试属性影响通过/失败状态。

.. versionadded:: 3.16
  添加了\ :prop_test:`SKIP_REGULAR_EXPRESSION`\ 属性。

​使用示例：

.. code-block:: cmake

  add_test(NAME mytest
           COMMAND testDriver --config $<CONFIG>
                              --exe $<TARGET_FILE:myexe>)

这创建了一个\ ``mytest``\ 测试，它的命令运行一个\ ``testDriver``\ 工具，将配置名称和\
完整路径传递给目标\ ``myexe``\ 生成的可执行文件。

---------------------------------------------------------------------

​上面的命令语法比旧的、不太灵活的形式更推荐使用：

.. code-block:: cmake

  add_test(<name> <command> [<arg>...])

​使用给定的命令行添加一个名为\ ``<name>``\ 的测试。

​与上面的\ ``NAME``\ 签名不同，在命令行中不支持目标名称。此外，添加此签名的测试在命令行或\
测试属性中不支持\ :manual:`生成器表达式 <cmake-generator-expressions(7)>`。
