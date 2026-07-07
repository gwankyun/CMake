discover_tests
--------------

.. versionadded:: 4.4

使用在测试时由 :manual:`ctest(1)` 发现的名称和属性注册测试。

.. code-block:: cmake

  discover_tests(COMMAND <command> [<arg>...] [COMMAND_EXPAND_LISTS]
    [CONFIGURATIONS <config>...]
    DISCOVERY_ARGS <arg>...
    DISCOVERY_MATCH <regex>
    [DISCOVERY_PROPERTIES <key> <value> [<key> <value>]...]
    TEST_NAME <replacement>
    TEST_ARGS <replacement>...
    [TEST_PROPERTIES <key> <replacement> [<key> <replacement>]...]
  )

该命令配置测试发现机制，而非在配置阶段定义单个测试。在测试执行时，:manual:`ctest(1)`
运行指定的发现命令，解析其输出，并根据提供的正则表达式和替换字符串注册一个或多个测试。

``discover_tests`` 的选项如下：

``COMMAND``
  指定用于测试发现的命令行。

  该命令由 :manual:`ctest(1)` 在测试时执行（而非由 CMake 在配置阶段执行）。附加
  ``DISCOVERY_ARGS`` 后，该命令必须以 ``DISCOVERY_MATCH`` 所匹配的格式打印可用测试列表。

  如果 ``<command>`` 指定的是由 :command:`add_executable` 创建的可执行目标：

  * 它将自动被替换为构建时生成的可执行文件的位置。

  * 如果目标设置了 :prop_tgt:`CROSSCOMPILING_EMULATOR`，将使用该模拟器在主机上运行命令::

      <emulator> <command>

    该模拟器仅在\ :variable:`交叉编译 <CMAKE_CROSSCOMPILING>`\ 时使用。

  * 如果目标设置了 :prop_tgt:`TEST_LAUNCHER`，将使用该启动器启动命令::

      <launcher> <command>

    如果同时设置了 :prop_tgt:`CROSSCOMPILING_EMULATOR`，则两者同时使用::

      <launcher> <emulator> <command>

  该命令可以使用 :manual:`生成器表达式 <cmake-generator-expressions(7)>` 来指定。

``COMMAND_EXPAND_LISTS``
  ``COMMAND`` 参数中的列表将被展开，包括由\
  :manual:`生成器表达式 <cmake-generator-expressions(7)>`\ 创建的列表。

``CONFIGURATIONS``
  仅在指定的配置中执行测试发现。

``DISCOVERY_ARGS``
  执行测试发现时传递给 ``COMMAND`` 的额外参数。

``DISCOVERY_MATCH``
  用于解析发现命令输出的每一行的正则表达式。捕获组可通过 ``TEST_NAME``、 ``TEST_ARGS``
  以及 ``TEST_PROPERTIES`` 中的值使用 ``\1``、 ``\2`` 等来引用。

``DISCOVERY_PROPERTIES``
  为发现运行本身指定属性。

``TEST_NAME``
  用于为每个发现的测试生成测试名称的替换字符串。可引用 ``DISCOVERY_MATCH`` 中的捕获组。

``TEST_ARGS``
  用于为每个发现的测试生成传入参数的替换字符串。每个参数均可引用 ``DISCOVERY_MATCH`` 中的捕获组。

``TEST_PROPERTIES``
  为每个发现的测试指定要设置的测试属性。值为替换字符串，可引用 ``DISCOVERY_MATCH`` 中的捕获组。

CTest 执行发现步骤以获取测试列表，然后使用由 ``COMMAND`` 和 ``TEST_ARGS`` 生成的命令行\
来运行每个发现的测试。每个发现的测试的通过/失败行为遵循常规 CTest 规则（退出码 ``0`` 表示成功，\
除非通过 :prop_test:`WILL_FAIL` 属性反转）。写入 stdout 或 stderr 的输出由
:manual:`ctest(1)` 捕获，仅通过 :prop_test:`PASS_REGULAR_EXPRESSION`、\
:prop_test:`FAIL_REGULAR_EXPRESSION` 或 :prop_test:`SKIP_REGULAR_EXPRESSION`
测试属性影响通过/失败状态。

示例用法：

.. code-block:: cmake

  discover_tests(COMMAND testDriver --exe $<TARGET_FILE:myexe>
    DISCOVERY_ARGS --list-tests
    DISCOVERY_MATCH "^([^,]+),([^,]+),([^,]+),(.*)$"
    TEST_NAME "${PROJECT_NAME}.\\1.\\2"
    TEST_ARGS --run-test "\\1.\\2"
    TEST_PROPERTIES
      PROCESSORS "\\3"
      LABELS "\\4"
  )

此示例通过运行 ``testDriver --list-tests`` 来配置测试发现。\
对于每行与 ``DISCOVERY_MATCH`` 匹配的输出，使用 ``TEST_NAME`` 生成测试名称，\
使用 ``TEST_ARGS`` 生成每个测试的命令行，并从其余捕获组填充测试属性。
