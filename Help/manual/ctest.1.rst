.. cmake-manual-description: CTest Command-Line Reference

ctest(1)
********

.. contents::

简介
========

.. parsed-literal::

 `运行测试`_
  ctest [<options>] [--test-dir <path-to-build>]

 `Build and Test Mode`_
  ctest --build-and-test <path-to-source> <path-to-build>
        --build-generator <generator> [<options>...]
       [--build-options <opts>...]
       [--test-command <command> [<args>...]]

 `Dashboard Client`_
  ctest -D <dashboard>         [-- <dashboard-options>...]
  ctest -M <model> -T <action> [-- <dashboard-options>...]
  ctest -S <script>            [-- <dashboard-options>...]
  ctest -SP <script>           [-- <dashboard-options>...]

 `查看帮助`_
  ctest --help[-<topic>]


描述
===========

:program:`ctest`\ 可执行文件是CMake测试驱动程序。为使用\ :command:`enable_testing`\
和\ :command:`add_test`\ 命令的项目创建的CMake生成的构建树具有测试支持。此程序将运行测试\
并报告结果。

.. _`Run Tests`:

运行测试
=========

.. program:: ctest

.. option:: --preset <preset>, --preset=<preset>

 使用测试预设来指定测试选项。项目二进制目录是从\ ``configurePreset``\ 键推断出来的。当前工\
 作目录必须包含CMake预置文件。有关更多详细信息，请参阅\ :manual:`preset <cmake-presets(7)>`。

.. option:: --list-presets

 列出可用的测试预设。当前工作目录必须包含CMake预置文件。

.. option:: -C <cfg>, --build-config <cfg>

 选择要测试的配置。

 一些CMake生成的构建树可以在同一树中有多个构建配置。此选项可用于指定应该测试哪一个。示例配置是\
 ``Debug``\ 和\ ``Release``。

.. option:: --progress

 启用测试的短进度输出。

 当\ :program:`ctest`\ 的输出直接发送到终端时，通过更新同一行来报告测试集的进度，而不是在\
 新行上为每个测试打印开始和结束消息。这可以显著减少测试输出的冗长性。对于失败的测试，测试完成\
 消息仍将在其单独的行上输出，并且仍将记录最终的测试摘要。

 这个选项也可以通过设置环境变量\ :envvar:`CTEST_PROGRESS_OUTPUT`\ 来启用。

.. option:: -V, --verbose

 启用测试的详细输出。

 测试输出通常被抑制，只显示摘要信息。此选项将显示所有测试输出。

.. option:: -VV, --extra-verbose

 从测试中启用更详细的输出。

 测试输出通常被抑制，只显示摘要信息。这个选项将显示更多的测试输出。

.. option:: --debug

 显示CTest的更详细的内部信息。

 该特性将产生大量输出，这些输出对调试仪表板问题非常有用。

.. option:: --output-on-failure

 如果测试失败，输出测试程序输出的任何内容。这个选项也可以通过设置\
 :envvar:`CTEST_OUTPUT_ON_FAILURE`\ 环境变量来启用。

.. option:: --stop-on-failure

 当出现第一个故障时，停止运行测试。

.. option:: -F

 支持故障转移。

 此选项允许CTest恢复先前中断的测试集执行。如果没有中断发生，\ ``-F``\ 选项将不起作用。

.. option:: -j [<level>], --parallel [<level>]

 并行运行测试，可选地限制在给定的并行度级别。

 .. versionadded:: 3.29

    ``<level>``\ 可以省略或为\ ``0``，在这种情况下：

    * 在\ `作业服务器集成`_\ 下，并行性受到可用作业令牌的限制。

    * 否则，如果省略该值，则并行性限制为处理器数量，或者为2，以较大者为准。

    * 否则，如果该值为\ ``0``，则并行度不受限制。

 这个选项可以由\ :envvar:`CTEST_PARALLEL_LEVEL`\ 环境变量指定。

 这个选项可以与\ :prop_test:`PROCESSORS`\ 测试属性一起使用。请查看\ `标签和子项目摘要`_。

.. option:: --resource-spec-file <file>

 使用\ ``<file>``\ 中指定的\
 :ref:`资源规范文件 <ctest-resource-specification-file>`，在启用\
 :ref:`资源分配 <ctest-resource-allocation>`\ 的情况下运行CTest。

 当\ :program:`ctest`\ 作为\ `仪表板客户端`_\ 运行时，这将设置\ `CTest测试步骤`_\ 的\
 ``ResourceSpecFile``\ 选项。

.. option:: --test-load <level>

 在并行运行测试时（例如使用\ :option:`-j <ctest -j>`），当测试可能导致CPU负载超过给定阈\
 值时，尽量不要启动测试。

 当\ :program:`ctest`\ 作为\ `仪表板客户端`_\ 运行时，这将设置\ `CTest测试步骤`_\ 的\
 ``TestLoad``\ 选项。

.. option:: -Q, --quiet

 让CTest保持安静。

 此选项将抑制所有输出。如果指定了\ :option:`--output-log <ctest --output-log>`，仍然\
 会生成输出日志文件。如果指定了\ ``--quiet``，那么\ :option:`--verbose <ctest --verbose>`、\
 :option:`--extra-verbose <ctest --extra-verbose>`\ 和\
 :option:`--debug <ctest --debug>`\ 等选项将被忽略。

.. option:: -O <file>, --output-log <file>

 输出到日志文件。

 该选项告诉CTest将其所有输出写入\ ``<file>``\ 日志文件。

.. option:: --output-junit <file>

 .. versionadded:: 3.21

 以JUnit格式编写测试结果。

 这个选项告诉CTest将测试结果写入\ ``<file>``\ 在JUnit XML格式。如果\ ``<file>``\ 已经\
 存在，它将被覆盖。如果使用\ :option:`-S <ctest -S>`\ 选项运行仪表板脚本，则使用\
 ``OUTPUT_JUNIT``\ 关键字和\ :command:`ctest_test`\ 命令代替。

.. option:: -N, --show-only[=<format>]

 禁用测试的实际执行。

 这个选项告诉CTest列出将要运行但没有实际运行的测试。与\ :option:`-R <ctest -R>`\ 和\
 :option:`-E <ctest -E>`\ 选项一起使用。

 .. versionadded:: 3.14

   ``--show-only``\ 选项接受\ ``<format>``\ 值。

 ``<format>``\ 可以是以下值之一。

   ``human``
     人性化的输出。这不能保证是稳定的。这是默认值。

   ``json-v1``
     以JSON格式转储测试信息。参见显示为\ `显示为JSON对象模型`_。

.. option:: -L <regex>, --label-regex <regex>

 运行与\ :ref:`string(REGEX) <Regex Specification>`\ 下描述的正则表达式匹配的标签的测试。

 此选项告诉CTest只运行标签与给定正则表达式匹配的测试。当给出多个\ ``-L``\ 选项时，只有当每\
 个正则表达式匹配至少一个测试的标签（即多个\ ``-L``\ 标签形成一个\ ``AND``\ 关系）时，才\
 会运行测试。参见\ `标签匹配`_。

.. option:: -R <regex>, --tests-regex <regex>

 运行匹配正则表达式的测试。

 此选项告诉CTest只运行名称与给定正则表达式匹配的测试。

.. option:: -E <regex>, --exclude-regex <regex>

 排除匹配正则表达式的测试。

 此选项告诉CTest\ **不**\ 运行名称与给定正则表达式匹配的测试。

.. option:: -LE <regex>, --label-exclude <regex>

 排除标签与正则表达式匹配的测试。

 此选项告诉CTest\ **不**\ 运行标签与给定正则表达式匹配的测试。当给出多个\ ``-LE``\ 选项时，\
 只有当每个正则表达式匹配至少一个测试的标签（即多个\ ``-LE``\ 标签形成一个\ ``AND``\
 关系）时，才会排除测试。参考\ `标签匹配`_。

.. option:: --tests-from-file <filename>

 .. versionadded:: 3.29

 运行给定文件中列出的测试。

 此选项告诉CTest运行给定文件中列出的测试。该文件每行必须包含一个确切的测试名称。不完全匹配\
 任何测试名称的行将被忽略。此选项可以与\ ``-R``、\ ``-E``、\ ``-L``\ 或\ ``-LE``\ 等\
 其他选项组合使用。

.. option:: --exclude-from-file <filename>

 .. versionadded:: 3.29

 排除给定文件中列出的测试。

 这个选项告诉CTest\ **不**\ 运行给定文件中列出的测试。该文件每行必须包含一个确切的测试名称。\
 不完全匹配任何测试名称的行将被忽略。此选项可以与\ ``-R``、\ ``-E``、\ ``-L``\ 或\
 ``-LE``\ 等其他选项组合使用。

.. option:: -FA <regex>, --fixture-exclude-any <regex>

 排除与\ ``<regex>``\ 匹配的fixture自动向测试集中添加任何测试。

 如果要执行的测试集中的一个测试需要一个特定的fixture，那么该fixture的设置和清理测试通常会\
 自动添加到测试集中。此选项可防止为匹配\ ``<regex>``\ 的fixture添加安装或清理测试。注意，\
 保留所有其他fixture行为，包括测试依赖项和跳过fixture设置测试失败的测试。

.. option:: -FS <regex>, --fixture-exclude-setup <regex>

 与\ :option:`-FA <ctest -FA>`\ 相同，但只排除匹配的设置测试。

.. option:: -FC <regex>, --fixture-exclude-cleanup <regex>

 与\ :option:`-FA <ctest -FA>`\ 相同，但只排除匹配的清理测试。

.. option:: -I [Start,End,Stride,test#,test#|Test file], --tests-information

 按编号运行特定数量的测试。

 此选项使CTest运行从编号\ ``Start``\ 开始，以编号\ ``End``\ 结束并按\ ``Stride``\ 递\
 增的测试。\ ``Stride``\ 之后的任何附加数字都被视为单独的测试数字。\ ``Start``、\ ``End``\
 和\ ``Stride``\ 可以为空。可以选择一个包含与命令行相同语法的文件。

.. option:: -U, --union

 取\ :option:`-I <ctest -I>`\ 和\ :option:`-R <ctest -R>`\ 的并集。

 默认情况下，同时指定\ :option:`-R <ctest -R>`\ 和\ :option:`-I <ctest -I>`\ 时，将\
 运行测试交集。通过指定\ ``-U``，将运行测试的并集。

.. option:: --rerun-failed

 只运行先前失败的测试。

 此选项告诉CTest只执行在上次运行期间失败的测试。指定此选项后，CTest将忽略用于修改要运行的测\
 试列表的所有其他选项（:option:`-L <ctest -L>`、:option:`-R <ctest -R>`、\
 :option:`-E <ctest -E>`、:option:`-LE <ctest -LE>`、:option:`-I <ctest -I>`\ 等）。\
 如果CTest运行并且没有测试失败，则使用\ ``--rerun-failed``\ 选项对CTest的后续调用将运行\
 最近失败的测试集（如果有的话）。

.. option:: --repeat <mode>:<n>

  根据给定的\ ``<mode>``\ 重复运行测试，最多可运行\ ``<n>``\ 次。模式有：

  ``until-fail``
    要求每个测试运行\ ``<n>``\ 次而不失败才能通过。这对于发现测试用例中的零星故障很有用。

  ``until-pass``
    允许每个测试最多运行\ ``<n>``\ 次才能通过。如果测试因任何原因失败，则重复测试。这对于\
    容忍测试用例中的零星故障是很有用的。

  ``after-timeout``
    允许每个测试最多运行\ ``<n>``\ 次才能通过。只有当测试超时时才重复测试。这对于在繁忙的\
    机器上容忍测试用例中的零星超时非常有用。

.. option:: --repeat-until-fail <n>

 相当于\ :option:`--repeat until-fail:\<n\> <ctest --repeat>`。

.. option:: --max-width <width>

 设置测试名称输出的最大宽度。

 设置要在输出中显示的每个测试名称的最大宽度。这允许用户扩大输出，以避免剪切测试名称，这可能\
 是非常烦人的。

.. option:: --interactive-debug-mode [0|1]

 设置交互模式为\ ``0``\ 或\ ``1``。

 此选项可使CTest以交互模式或非交互模式运行测试。在仪表板模式下（\ ``Experimental``、\
 ``Nightly``、\ ``Continuous``），默认为非交互式。在非交互模式下，设置环境变量\
 :envvar:`DASHBOARD_TEST_FROM_CTEST`。

 在CMake 3.11之前，Windows上的交互模式允许出现系统调试弹出窗口。现在，由于CTest使用\
 ``libuv``\ 来启动测试进程，所有系统调试弹出窗口总是被禁止。

.. option:: --no-label-summary

 禁用标签的定时汇总信息。

 此选项告诉CTest不要打印与测试运行相关联的每个标签的摘要信息。如果测试上没有标签，就不会打\
 印任何额外的内容。

 请参阅\ `标签和子项目摘要`_。

.. option:: --no-subproject-summary

 禁用子项目的定时摘要信息。

 此选项告诉CTest不要打印与测试运行相关联的每个子项目的摘要信息。如果测试中没有子项目，则不会\
 打印额外的内容。

 请参阅\ `标签和子项目摘要`_。

.. option:: --test-dir <dir>

 .. versionadded:: 3.20

 指定要查找测试的目录，通常是CMake项目构建目录。如果未指定，则使用当前目录。

.. option:: --test-output-size-passed <size>

 .. versionadded:: 3.4

 将通过的测试的输出限制为\ ``<size>``\ 字节。

.. option:: --test-output-size-failed <size>

 .. versionadded:: 3.4

 将失败测试的输出限制为\ ``<size>``\ 字节。

.. option:: --test-output-truncation <mode>

 .. versionadded:: 3.24

 一旦达到最大输出大小，截断测试输出的\ ``tail``\ （默认）、\ ``middle``\ 或\ ``head``。

.. option:: --overwrite

 覆盖CTest配置选项。

 默认情况下，CTest使用配置文件中的配置选项。此选项将覆盖配置选项。

.. option:: --force-new-ctest-process

 将子CTest实例作为新进程运行。

 默认情况下，CTest将在同一进程中运行子CTest实例。如果不需要这种行为，这个参数将为子CTest进\
 程强制新的进程。

.. option:: --schedule-random

 使用随机顺序安排测试。

 此选项将以随机顺序运行测试。它通常用于检测测试套件中的隐式依赖关系。

.. option:: --submit-index

 旧的Dart2仪表板服务器功能的遗留选项。请勿使用。

.. option:: --timeout <seconds>

 设置默认测试超时时间。

 此选项有效地为尚未通过\ :prop_test:`TIMEOUT`\ 属性对其设置超时的所有测试设置超时。

.. option:: --stop-time <time>

 设置所有测试应停止运行的时间。

 设置一天中所有测试应该超时的实际时间。例如\ ``7:00:00 -0400``。可以接受curl日期解析器理\
 解的任何时间格式。如果没有指定时区，则假定为本地时间。

.. option:: --print-labels

 打印所有可用的测试标签。

 此选项不会运行任何测试，它只会打印与测试集关联的所有标签的列表。

.. option:: --no-tests=<action>

 将未发现的测试视为错误（当\ ``<action>``\ 设置为\ ``error``\ 时）或忽略它（当\
 ``<action>``\ 设置为\ ``ignore``\ 时）。

 如果未找到任何测试，CTest的默认行为是始终记录错误消息，但仅在脚本模式下返回错误代码。该选项\
 通过在没有找到测试时返回错误代码或忽略它来统一CTest的行为。

 .. versionadded:: 3.26

 这个选项也可以通过设置\ :envvar:`CTEST_NO_TESTS_ACTION`\ 环境变量来设置。

查看帮助
=========

要打印版本详细信息或从CMake文档中选择的页面，使用以下选项之一：

.. include:: OPTIONS_HELP.txt

.. _`Label Matching`:

标签匹配
==============

测试可能附有标签。通过筛选标签，可以将测试包括在测试运行中，也可以将测试排除在测试运行中。每\
个单独的过滤器都是一个正则表达式，应用于附加到测试的标签。

当使用\ :option:`-L <ctest -L>`\ 时，为了将测试包含在测试运行中，每个正则表达式必须匹配\
至少一个标签。使用多个\ :option:`-L <ctest -L>`\ 选项意味着“匹配\ **所有**\ 这些”。

:option:`-LE <ctest -LE>`\ 选项的工作原理与\ :option:`-L <ctest -L>`\ 类似，但它排除\
测试而不是包括测试。如果每个正则表达式匹配至少一个标签，则排除测试。

如果一个测试没有附加标签，那么\ :option:`-L <ctest -L>`\ 将永远不会包括该测试，并且\
:option:`-LE <ctest -LE>`\ 将永远不会排除该测试。以带标签的测试为例，考虑五个测试，它们\
带有以下标签：

* *test1*\ 有\ *tuesday*\ 和\ *production*\ 标签
* *test2*\ 有\ *tuesday*\ 和\ *test*\ 标签
* *test3*\ 有\ *wednesday*\ 和\ *production*\ 标签
* *test4*\ 有\ *wednesday*\ 的标签
* *test5*\ 有标签\ *friday*\ 和\ *test*

用\ ``-L tuesday -L test``\ 命令运行\ :program:`ctest`，将选择\ *test2*，它有两个标签。\
使用\ ``-L test``\ 运行CTest将选择\ *test2*\ 和\ *test5*，因为它们都有一个与正则表达式\
匹配的标签。

因为匹配使用正则表达式，所以请注意，使用\ ``-L es``\ 运行CTest将匹配所有五个测试。若要同时\
选择\ *tuesday*\ 和\ *wednesday*\ 测试，请使用匹配其中一个的单个正则表达式，如\
``-L "tue|wed"``。

.. _`Label and Subproject Summary`:

标签和子项目摘要
============================

CTest打印与测试运行相关联的每个\ ``LABEL``\ 和子项目的计时摘要信息。标签时间摘要将不包括映\
射到子项目的标签。

.. versionadded:: 3.22
  在测试执行期间动态添加的标签也会在计时摘要中报告。请参阅\ :ref:`Additional Labels`。

当设置了 :prop_test:`PROCESSORS` 测试属性时，CTest将在标签和子项目摘要中显示加权测试计时\
结果。时间是用\ `sec*proc`\ 报告的，而不仅仅是\ `sec`。

每个标签或子项目\ ``j``\ 报告的加权时间汇总计算为：\ ::

  Weighted Time Summary for Label/Subproject j =
      sum(raw_test_time[j,i] * num_processors[j,i], i=1...num_tests[j])

  for labels/subprojects j=1...total

其中：

* ``raw_test_time[j,i]``： ``j``\ 标签或子项目的\ ``i``\ 测试的时钟时间
* ``num_processors[j,i]``： 用于\ ``j``\ 标签或子项目的\ ``i``\ 测试的CTest\
  :prop_test:`PROCESSORS`\ 属性的值
* ``num_tests[j]``： 与\ ``j``\ 标签或子项目关联的测试数
* ``total``： 至少有一个测试运行的标签或子项目的总数

因此，每个标签或子项目的加权时间摘要表示CTest为每个标签或子项目运行测试所花费的时间量，并很\
好地表示了与其他标签或子项目相比，每个标签或子项目的测试总费用。

例如，如果\ ``SubprojectA``\ 显示\ ``100 sec*proc``，而\ ``SubprojectB``\ 显示\
``10 sec*proc``，那么CTest分配大约10倍的CPU/核心时间来运行\ ``SubprojectA``\ 的测试，\
而不是\ ``SubprojectB``\ 的测试（例如，如果要花费精力来减少整个项目测试套件的成本，那么减少\
``SubprojectA``\ 测试套件的成本可能会比减少\ ``SubprojectB``\ 测试套件的成本产生更大的\
影响）。

.. _`Build and Test Mode`:

构建和测试模式
===================

CTest提供了一个命令行签名来配置（即运行cmake）、构建和/或执行测试：\ ::

  ctest --build-and-test <path-to-source> <path-to-build>
        --build-generator <generator>
        [<options>...]
        [--build-options <opts>...]
        [--test-command <command> [<args>...]]

配置和测试步骤是可选的。该命令行的参数是源目录和二进制目录。\ *必须*\ 提供\
``--build-generator``\ 选项才能使用\ ``--build-and-test``。如果指定了\
``--test-command``，那么它将在构建完成后运行。影响此模式的其他选项包括：

.. option:: --build-and-test

 切换到构建和测试模式。

.. option:: --build-target

 指定要构建的特定目标。可以使用不同的目标多次给出该选项，在这种情况下，依次构建每个目标。除非\
 给出了\ :option:`--build-noclean`\ 选项，否则将在构建每个目标之前执行一次清理。

 如果不指定\ ``--build-target``，则构建\ ``all``\ 目标。

.. option:: --build-nocmake

 运行构建，但不要先运行cmake。

 跳过cmake步骤。

.. option:: --build-run-dir

 指定要运行程序的目录。

 编译后程序所在的目录。

.. option:: --build-two-config

 运行两次CMake。

.. option:: --build-exe-dir

 指定可执行文件的目录。

.. option:: --build-generator

 指定要使用的生成器。请参阅\ :manual:`cmake-generators(7)`\ 手册。

.. option:: --build-generator-platform

 指定特定于生成器的平台。

.. option:: --build-generator-toolset

 指定特定于生成器的工具集。

.. option:: --build-project

 指定要生成的项目的名称。

.. option:: --build-makeprogram

 指定CMake在配置和构建项目时使用的显式make程序。仅适用于基于Make和Ninja的生成器。

.. option:: --build-noclean

 跳过清理步骤。

.. option:: --build-config-sample

 用于确定应该使用的配置的示例可执行文件。例如\ ``Debug``、\ ``Release``\ 等。

.. option:: --build-options

 配置构建的附加选项（即CMake，而不是构建工具）。注意，如果指定了这个选项，\
 ``--build-options``\ 关键字及其参数必须是命令行上给出的最后一个选项，可能的例外是\
 ``--test-command``。

.. option:: --test-command

 使用\ :option:`--build-and-test <ctest --build-and-test>`\ 选项作为测试步骤运行的\
 命令。这个关键字后面的所有参数都被认为是test命令行的一部分，所以它必须是给出的最后一个选项。

.. option:: --test-timeout

 以秒为单位的时间限制

.. _`Dashboard Client`:

仪表板客户端
================

CTest可以作为\ `CDash`_\ 软件质量指示板应用程序的客户端操作。作为仪表板客户机，CTest执行\
一系列步骤来配置、构建和测试软件，然后将结果提交给CDash服务器。提交到\ `CDash`_\ 的命令行\
签名是：\ ::

  ctest -D <dashboard>         [-- <dashboard-options>...]
  ctest -M <model> -T <action> [-- <dashboard-options>...]
  ctest -S <script>            [-- <dashboard-options>...]
  ctest -SP <script>           [-- <dashboard-options>...]

.. _`CDash`: https://www.cdash.org

仪表板客户端的选项包括：

.. option:: -D <dashboard>, --dashboard <dashboard>

 执行仪表板测试。

 这个选项告诉CTest充当一个CDash客户端并执行一个指示板测试。所有测试都是\ ``<Mode><Test>``，\
 其中\ ``<Mode>``\ 可以是\ ``Experimental``、\ ``Nightly``\ 和\ ``Continuous``， \
 ``<Test>``\ 可以是\ ``Start``、\ ``Update``、\ ``Configure``、\ ``Build``、\
 ``Test``、\ ``Coverage``\ 和\ ``Submit``。

 如果\ ``<dashboard>``\ 不是可识别的\ ``<Mode><Test>``\ 值之一，则将其视为变量定义（请\
 参阅下面的\ :ref:`dashboard-options <Dashboard Options>`）。

.. option:: -M <model>, --test-model <model>

 设置指示板的模型。

 这个选项告诉CTest充当一个CDash客户端，其中\ ``<model>``\ 可以是\ ``Experimental``、\
 ``Nightly``\ 和\ ``Continuous``。\ ``-M``\ 和\ :option:`-T <ctest -T>`\ 的组合类\
 似于\ :option:`-D <ctest -D>`。

.. option:: -T <action>, --test-action <action>

 设置要执行的指示板操作。

 这个选项告诉CTest充当一个CDash客户端，并执行一些操作，如\ ``start``、\ ``build``、\
 ``test``\ 等。有关操作的完整列表，请参阅\ `仪表板客户端步骤`_ 。\ :option:`-M <ctest -M>`\
 和\ ``-T``\ 的组合类似于\ :option:`-D <ctest -D>`。

.. option:: -S <script>, --script <script>

 为配置执行指示板。

 这个选项告诉CTest加载一个配置脚本，该脚本设置了一些参数，比如二进制文件和源目录。然后，\
 CTest将执行创建和运行仪表板所需的操作。这个选项基本上设置了一个指示板，然后使用适当的选项\
 运行\ :option:`ctest -D`。

.. option:: -SP <script>, --script-new-process <script>

 为配置执行指示板。

 此选项执行与\ :option:`-S <ctest -S>`\ 相同的操作，但它将在单独的进程中执行。当脚本可能\
 会修改环境，而你不希望修改后的环境影响其他\ :option:`-S <ctest -S>`\ 脚本时，相当有用。

.. _`Dashboard Options`:

可用的\ ``<dashboard-options>``\ 如下：

.. option:: -D <var>:<type>=<value>

 为脚本模式定义变量。

 在命令行上传递变量值。与\ :option:`-S <ctest -S>`\ 一起使用可将变量值传递给指示板脚本。\
 只有当\ ``-D``\ 后面的值与任何已知的指示板类型不匹配时，才会尝试将\ ``-D``\ 参数解析为变\
 量值。

.. option:: --group <group>

 指定要将结果提交给哪个组

 提交仪表板到指定组，而不是默认组。默认情况下，仪表板被提交到Nightly、Experimental或\
 Continuous组，但通过指定此选项，该组可以是任意的。

 这将取代已弃用的选项\ ``--track``。尽管名称改变了它的行为是不变的。

.. option:: -A <file>, --add-notes <file>

 添加带有提交的注释文件。

 这个选项告诉CTest在提交指示板时包含一个注释文件。

.. option:: --tomorrow-tag

 ``Nightly``\ 或\ ``Experimental``\ 开始与第二天标签。

 如果构建不能在一天内完成，这是很有用的。

.. option:: --extra-submit <file>[;<file>]

 向仪表板提交额外的文件。

 此选项将向指示板提交额外的文件。

.. option:: --http-header <header>

 .. versionadded:: 3.29

 提交到仪表板时附加HTTP头。

 这个选项将导致CTest在提交到仪表板时附加指定的头。此选项可以指定多次。

.. option:: --http1.0

 使用\ `HTTP 1.0`\ 提交。

 这个选项将强制CTest使用\ `HTTP 1.0`\ 向仪表板提交文件，而不是\ `HTTP 1.1`。

.. option:: --no-compress-output

 提交时不要压缩测试输出。

 此标志将关闭测试输出的自动压缩。使用它可以保持与旧版本的CDash的兼容性，该版本不支持压缩测试\
 输出。

仪表板客户端步骤
----------------------

CTest定义了一个有序的测试步骤列表，其中一些或全部可以作为仪表板客户端运行：

``Start``
  启动一个新的仪表板提交，由以下步骤记录的结果组成。请参阅下面的\ `CTest开始步骤`_\ 章节。

``Update``
  从其版本控制存储库更新源代码树。记录新旧版本和更新的源文件列表。请参阅下面的\
  `CTest更新步骤`_\ 章节。

``Configure``
  通过在构建树中运行命令来配置软件。记录配置输出日志。请参阅下面的\ `CTest配置步骤`_\ 章节。

``Build``
  通过在构建树中运行命令来构建软件。记录构建输出日志并检测警告和错误。请参阅下面的\
  `CTest构建步骤`_\ 部分。

``Test``
  通过从构建树中加载\ ``CTestTestfile.cmake``\ 并执行定义的测试来测试软件。记录每次测试\
  的输出和结果。请参阅下面的\ `CTest测试步骤`_\ 章节。

``Coverage``
  通过运行覆盖率分析工具并记录其输出来计算源代码的覆盖率。请参阅下面的\ `CTest覆盖步骤`_\
  章节。

``MemCheck``
  通过内存检查工具运行软件测试套件。记录工具报告的测试输出、结果和问题。请参阅下面的\
  `CTest内存测试步骤`_\ 章节。

``Submit``
  将其他测试步骤记录的结果提交到软件质量仪表板服务器。请参阅下面的\ `CTest提交步骤`_\ 章节。

仪表板客户端模式
----------------------

CTest作为仪表板客户端定义了三种操作模式：

``Nightly``
  此模式打算每天调用一次，通常在晚上。默认情况下，它启用\ ``Start``、\ ``Update``、\
  ``Configure``、\ ``Build``、\ ``Test``、\ ``Coverage``\ 和\ ``Submit``\ 步骤。\
  即使\ ``Update``\ 步骤没有向源树报告任何更改，也会运行所选步骤。

``Continuous``
  此模式打算在一天中反复调用。默认情况下，它启用\ ``Start``、\ ``Update``、\
  ``Configure``、\ ``Build``、\ ``Test``、\ ``Coverage``\ 和\ ``Submit``\ 步骤，\
  但是如果它没有向源代码树报告任何更改，则在\ ``Update``\ 步骤之后退出。

``Experimental``
  此模式旨在由开发人员调用以测试本地更改。默认情况下，它启用\ ``Start``、\ ``Configure``、\
  ``Build``、\ ``Test``、\ ``Coverage``\ 和\ ``Submit``\ 步骤。

通过CTest命令行运行仪表板客户端
---------------------------------------

CTest可以在已经生成的构建树上执行测试。运行\ :program:`ctest`\ 命令，将当前工作目录设置\
为构建树，并使用以\
下签名之一：\ ::

  ctest -D <mode>[<step>]
  ctest -M <mode> [-T <step>]...

``<mode>``\ 必须是上述\ `仪表板客户端模式`_\ 之一，每个\ ``<step>``\ 必须是上述\
`仪表板客户端步骤`_\ 之一。

CTest从构建树中的一个名为\ ``CTestConfiguration.ini``\ 或\ ``DartConfiguration.tcl``\
（名称是历史的）的文件中读取\ `仪表板客户端配置`_\ 设置。文件格式为：\ ::

  # Lines starting in '#' are comments.
  # Other non-blank lines are key-value pairs.
  <setting>: <value>

其中\ ``<setting>``\ 为设置名称，\ ``<value>``\ 为设置值。

在CMake生成的构建树中，这个配置文件是由\ :module:`CTest`\ 模块生成的，如果包含在项目中。\
该模块使用变量获取每个设置的值，如下面的设置文档所示。

.. _`CTest Script`:

通过CTest脚本运行仪表板客户端
---------------------------------

CTest可以执行由\ :manual:`cmake-language(7)`\ 脚本驱动的测试，该脚本创建并维护源代码和\
构建树，以及执行测试步骤。运行\ :program:`ctest`\ 命令，将当前工作目录设置在任何构建树之外，\
并使用以下签名之一：\ ::

  ctest -S <script>
  ctest -SP <script>

``<script>``\ 文件必须调用\ :ref:`CTest Commands`\ 命令来显式地运行测试步骤，如下所示。\
这些命令从它们的参数或脚本中设置的变量中获取\ `仪表板客户端配置`_\ 设置。

仪表板客户端配置
==============================

`仪表板客户端步骤`_\ 步骤可以通过以下部分中记录的命名设置进行配置。

.. _`CTest Start Step`:

CTest开始步骤
----------------

启动一个新的仪表板提交，由以下步骤记录的结果组成。

在\ `CTest Script`_\ 中，\ :command:`ctest_start`\ 命令运行此步骤。命令的参数可以指定\
一些步骤设置。该命令首先运行\ ``CTEST_CHECKOUT_COMMAND`` \变量（如果设置了）指定的命令行，\
以初始化源目录。

配置设置包括：

``BuildDirectory``
  项目构建树的完整路径。

  * `CTest Script`_\ 变量：:variable:`CTEST_BINARY_DIRECTORY`
  * :module:`CTest`\ 变量：:variable:`PROJECT_BINARY_DIR`

``SourceDirectory``
  项目源代码树的完整路径。

  * `CTest Script`_\ 变量：:variable:`CTEST_SOURCE_DIRECTORY`
  * :module:`CTest`\ 变量：:variable:`PROJECT_SOURCE_DIR`

.. _`CTest Update Step`:

CTest更新步骤
-----------------

在\ `CTest Script`_\ 中，\ :command:`ctest_update`\ 命令运行此步骤。命令的参数可以指\
定一些步骤设置。

指定版本控制工具的配置设置包括：

``BZRCommand``
  如果源代码树由Bazaar管理，则使用\ ``bzr``\ 命令行工具。

  * `CTest Script`_\ 变量：:variable:`CTEST_BZR_COMMAND`
  * :module:`CTest`\ 变量：无

``BZRUpdateOptions``
  在更新源代码时，将命令行选项设置为\ ``BZRCommand``。

  * `CTest Script`_\ 变量：:variable:`CTEST_BZR_UPDATE_OPTIONS`
  * :module:`CTest`\ 变量：无

``CVSCommand``
  如果源代码树由CVS管理，则使用\ ``cvs``\ 命令行工具。

  * `CTest Script`_\ 变量：:variable:`CTEST_CVS_COMMAND`
  * :module:`CTest`\ 变量：\ ``CVSCOMMAND``

``CVSUpdateOptions``
  在更新源代码时，将命令行选项设置为\ ``CVSCommand``。

  * `CTest Script`_\ 变量：:variable:`CTEST_CVS_UPDATE_OPTIONS`
  * :module:`CTest`\ 变量：\ ``CVS_UPDATE_OPTIONS``

``GITCommand``
  ``git``\ 命令行工具，如果源代码树是由Git管理的。

  * `CTest Script`_\ 变量：:variable:`CTEST_GIT_COMMAND`
  * :module:`CTest`\ 变量：\ ``GITCOMMAND``

  源代码树通过\ ``git fetch``\ 更新，然后\ ``git reset --hard``\ 更新到\ ``FETCH_HEAD``。\
  结果与\ ``git pull``\ 相同，只是所有的本地修改都会被覆盖。使用\ ``GITUpdateCustom``\
  来指定不同的方法。

``GITInitSubmodules``
  如果设置了，CTest将在更新之前更新存储库的子模块。

  * `CTest Script`_\ 变量：:variable:`CTEST_GIT_INIT_SUBMODULES`
  * :module:`CTest`\ 变量：\ ``CTEST_GIT_INIT_SUBMODULES``

``GITUpdateCustom``
  指定一个自定义命令行（以分号分隔的列表形式）在源代码树（Git工作树）中运行以更新它，而不是\
  运行\ ``GITCommand``。

  * `CTest Script`_\ 变量：:variable:`CTEST_GIT_UPDATE_CUSTOM`
  * :module:`CTest`\ 变量：\ ``CTEST_GIT_UPDATE_CUSTOM``

``GITUpdateOptions``
  在更新源代码时，将命令行选项设置为\ ``GITCommand``。

  * `CTest Script`_\ 变量：:variable:`CTEST_GIT_UPDATE_OPTIONS`
  * :module:`CTest`\ 变量：\ ``GIT_UPDATE_OPTIONS``

``HGCommand``
  如果源代码树由Mercurial管理，则使用\ ``hg``\ 命令行工具。

  * `CTest Script`_\ 变量：:variable:`CTEST_HG_COMMAND`
  * :module:`CTest`\ 变量：无

``HGUpdateOptions``
  在更新源代码时，将命令行选项设置为\ ``HGCommand``。

  * `CTest Script`_\ 变量：:variable:`CTEST_HG_UPDATE_OPTIONS`
  * :module:`CTest`\ 变量：无

``P4Client``
  ``P4Command``\ 的\ ``-c``\ 选项的值。

  * `CTest Script`_\ 变量：:variable:`CTEST_P4_CLIENT`
  * :module:`CTest`\ 变量：\ ``CTEST_P4_CLIENT``

``P4Command``
  ``p4``\ 命令行工具，如果源代码树是由Perforce管理。

  * `CTest Script`_\ 变量：:variable:`CTEST_P4_COMMAND`
  * :module:`CTest`\ 变量：\ ``P4COMMAND``

``P4Options``
  ``P4Command``\ 的命令行选项，用于所有调用。

  * `CTest Script`_\ 变量：:variable:`CTEST_P4_OPTIONS`
  * :module:`CTest`\ 变量：\ ``CTEST_P4_OPTIONS``

``P4UpdateCustom``
  指定要在源树（Perforce树）中运行的自定义命令行（以分号分隔的列表形式）来更新源树，而不是\
  运行\ ``P4Command``。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：\ ``CTEST_P4_UPDATE_CUSTOM``

``P4UpdateOptions``
  在更新源代码时将命令行选项设置为\ ``P4Command`` 。

  * `CTest Script`_\ 变量：:variable:`CTEST_P4_UPDATE_OPTIONS`
  * :module:`CTest`\ 变量：\ ``CTEST_P4_UPDATE_OPTIONS``

``SVNCommand``
  ``svn``\ 命令行工具，如果源代码树是由Subversion管理的。

  * `CTest Script`_\ 变量：:variable:`CTEST_SVN_COMMAND`
  * :module:`CTest`\ 变量：\ ``SVNCOMMAND``

``SVNOptions``
  ``SVNCommand``\ 所有调用的命令行选项。

  * `CTest Script`_\ 变量：:variable:`CTEST_SVN_OPTIONS`
  * :module:`CTest`\ 变量：\ ``CTEST_SVN_OPTIONS``

``SVNUpdateOptions``
  更新源时，\ ``SVNCommand``\ 的命令行选项。

  * `CTest Script`_\ 变量：:variable:`CTEST_SVN_UPDATE_OPTIONS`
  * :module:`CTest`\ 变量：\ ``SVN_UPDATE_OPTIONS``

``UpdateCommand``
  指定要使用的版本控制命令行工具，而不检测管理源代码树的VCS。

  * `CTest Script`_\ 变量：:variable:`CTEST_UPDATE_COMMAND`
  * :module:`CTest`\ 变量：当\ ``UPDATE_TYPE``\ 为\ ``<vcs>``\ 时为\
    ``<VCS>COMMAND``，否则为\ ``UPDATE_COMMAND``

``UpdateOptions``
  ``UpdateCommand``\ 的命令行选项。

  * `CTest Script`_\ 变量：:variable:`CTEST_UPDATE_OPTIONS`
  * :module:`CTest`\ 变量：当\ ``UPDATE_TYPE``\ 为\ ``<vcs>``\ 时为\
    ``<VCS>_UPDATE_OPTIONS``，否则为\ ``UPDATE_OPTIONS``

``UpdateType``
  如果无法自动检测到源代码树，则指定管理该源代码树的版本控制系统。取值为\ ``bzr``、\ ``cvs``、\
  ``git``、\ ``hg``、\ ``p4``\ 及\ ``svn``。

  * `CTest Script`_\ 变量：无，从源代码树检测
  * :module:`CTest`\ 变量：如果设置了，则为\ ``UPDATE_TYPE``，否则为\
    ``CTEST_UPDATE_TYPE``

.. _`UpdateVersionOnly`:

``UpdateVersionOnly``
  指定希望版本控制更新命令只发现签出的当前版本，而不更新到不同的版本。

  * `CTest Script`_\ 变量：:variable:`CTEST_UPDATE_VERSION_ONLY`

.. _`UpdateVersionOverride`:

``UpdateVersionOverride``
  指定源代码树的当前版本。

  当将该变量设置为非空字符串时，CTest将报告你指定的值，而不是使用update命令来发现已检出的\
  当前版本。这个变量的使用取代了\ ``UpdateVersionOnly``。与\ ``UpdateVersionOnly``\
  一样，使用这个变量告诉CTest不要将源树更新为不同的版本。

  * `CTest Script`_\ 变量：:variable:`CTEST_UPDATE_VERSION_OVERRIDE`

其他配置设置包括：

``NightlyStartTime``
  在\ ``Nightly``\ 仪表板模式下，指定“夜间开始时间”。使用集中式版本控制系统（\ ``cvs``\
  和\ ``svn``），\ ``Update``\ 步骤会检出此时的软件版本，以便多个客户机选择一个通用版本\
  进行测试。这在分布式版本控制系统中没有明确定义，因此该设置被忽略。

  * `CTest Script`_\ 变量：:variable:`CTEST_NIGHTLY_START_TIME`
  * :module:`CTest`\ 变量：如果设置了，则为\ ``NIGHTLY_START_TIME``，否则为\
    ``CTEST_NIGHTLY_START_TIME``

.. _`CTest Configure Step`:

CTest配置步骤
--------------------

在\ `CTest Script`_\ 中，\ :command:`ctest_configure`\ 命令运行此步骤。命令的参数可\
以指定一些步骤设置。

配置设置包括：

``ConfigureCommand``
  命令行启动软件配置过程。它将在\ ``BuildDirectory``\ 设置指定的位置执行。

  * `CTest Script`_\ 变量：:variable:`CTEST_CONFIGURE_COMMAND`
  * :module:`CTest`\ 变量：:variable:`CMAKE_COMMAND`，后面跟着\
    :variable:`PROJECT_SOURCE_DIR`

``LabelsForSubprojects``
  指定一个分号分隔的标签列表，这些标签将被视为子项目。当提交配置、测试或构建结果时，该映射将\
  传递给CDash。

  * `CTest Script`_\ 变量：:variable:`CTEST_LABELS_FOR_SUBPROJECTS`
  * :module:`CTest`\ 变量：\ ``CTEST_LABELS_FOR_SUBPROJECTS``

  请参阅\ `标签和子项目摘要`_。

.. _`CTest Build Step`:

CTest构建步骤
----------------

在\ `CTest Script`_\ 中，\ :command:`ctest_build`\ 命令运行此步骤。命令的参数可以指定\
一些步骤设置。

配置设置包括：

``DefaultCTestConfigurationType``
  当要启动的构建系统允许在构建时选择配置（例如\ ``Debug``、\ ``Release``）时，这指定了在\
  没有给\ :program:`ctest`\ 命令\ :option:`-C <ctest -C>`\ 选项时要构建的默认配置。\
  如果出现，该值将被替换为\ ``MakeCommand``\ 的值，以替换文字字符串\
  ``${CTEST_CONFIGURATION_TYPE}`` 。

  * `CTest Script`_\ 变量：:variable:`CTEST_CONFIGURATION_TYPE`
  * :module:`CTest`\ 变量：\ ``DEFAULT_CTEST_CONFIGURATION_TYPE``，被\
    :envvar:`CMAKE_CONFIG_TYPE`\ 环境变量初始值。 

``LabelsForSubprojects``
  指定一个分号分隔的标签列表，这些标签将被视为子项目。当提交配置、测试或构建结果时，该映射将\
  传递给CDash。

  * `CTest Script`_\ 变量：:variable:`CTEST_LABELS_FOR_SUBPROJECTS`
  * :module:`CTest`\ 变量：\ ``CTEST_LABELS_FOR_SUBPROJECTS``

  请参阅\ `标签和子项目摘要`_。

``MakeCommand``
  命令行启动软件构建过程。它将在\ ``BuildDirectory``\ 设置指定的位置执行。

  * `CTest Script`_\ 变量：:variable:`CTEST_BUILD_COMMAND`
  * :module:`CTest`\ 变量：\ ``MAKECOMMAND``，被\
    :command:`build_command`\ 命令初始值。 

``UseLaunchers``
  对于使用\ :ref:`Makefile Generators`\ 或\ :generator:`Ninja`\ 生成器之一的CMake生\
  成的构建树，指定\ ``CTEST_USE_LAUNCHERS``\ 特性是否被\ :module:`CTestUseLaunchers`\
  模块（也包含在\ :module:`CTest`\ 模块中）启用。当启用时，生成的构建系统将编译器、链接器\
  或自定义命令行的每次调用包装为一个“启动器”，该“启动器”通过环境变量和文件与CTest通信，以报\
  告粒度构建警告和错误信息。否则，CTest必须“抓取”构建输出日志以进行诊断。

  * `CTest Script`_\ 变量：:variable:`CTEST_USE_LAUNCHERS`
  * :module:`CTest`\ 变量：\ ``CTEST_USE_LAUNCHERS``

.. _`CTest Test Step`:

CTest测试步骤
---------------

在\ `CTest Script`_\ 中，\ :command:`ctest_test`\ 命令运行此步骤。命令的参数可以指定\
一些步骤设置。

配置设置包括：

``ResourceSpecFile``
  指定\ :ref:`资源规范文件 <ctest-resource-specification-file>`。

  * `CTest Script`_\ 变量：:variable:`CTEST_RESOURCE_SPEC_FILE`
  * :module:`CTest`\ 变量：\ ``CTEST_RESOURCE_SPEC_FILE``

  有关更多信息，请参见\ :ref:`ctest-resource-allocation`。

``LabelsForSubprojects``
  指定一个分号分隔的标签列表，这些标签将被视为子项目。当提交配置、测试或构建结果时，该映射将\
  传递给CDash。

  * `CTest Script`_\ 变量：:variable:`CTEST_LABELS_FOR_SUBPROJECTS`
  * :module:`CTest`\ 变量：\ ``CTEST_LABELS_FOR_SUBPROJECTS``

  请参阅\ `标签和子项目摘要`_。

``TestLoad``
  在并行运行测试时（例如使用\ :option:`-j <ctest -j>`），当测试可能导致CPU负载超过给定阈\
  值时，尽量不要启动测试。

  * `CTest Script`_\ 变量：:variable:`CTEST_TEST_LOAD`
  * :module:`CTest`\ 变量：\ ``CTEST_TEST_LOAD``

``TimeOut``
  如果未由\ :prop_test:`TIMEOUT`\ 属性或者\ :option:`--timeout <ctest --timeout>`\
  标识指定，则为每个测试的默认超时。

  * `CTest Script`_\ 变量：:variable:`CTEST_TEST_TIMEOUT`
  * :module:`CTest`\ 变量：\ ``DART_TESTING_TIMEOUT``

要向CDash报告额外的测试值，请参阅\ :ref:`Additional Test Measurements`。

.. _`CTest Coverage Step`:

CTest覆盖步骤
-------------------

在\ `CTest Script`_\ 中，\ :command:`ctest_coverage`\ 命令运行这个步骤。命令的参数可\
以指定一些步骤设置。

配置设置包括：

``CoverageCommand``
  执行软件覆盖率分析的命令行工具。它将在\ ``BuildDirectory``\ 设置指定的位置执行。

  * `CTest Script`_\ 变量：:variable:`CTEST_COVERAGE_COMMAND`
  * :module:`CTest`\ 变量：\ ``COVERAGE_COMMAND``

``CoverageExtraFlags``
  为\ ``CoverageCommand``\ 工具指定命令行选项。

  * `CTest Script`_\ 变量：:variable:`CTEST_COVERAGE_EXTRA_FLAGS`
  * :module:`CTest`\ 变量：\ ``COVERAGE_EXTRA_FLAGS``

  这些选项是传递给\ ``CoverageCommand``\ 的第一个参数。

.. _`CTest MemCheck Step`:

CTest内存测试步骤
-------------------

在\ `CTest Script`_\ 中，\ :command:`ctest_memcheck`\ 命令运行此步骤。命令的参数可以\
指定一些步骤设置。

配置设置包括：

``MemoryCheckCommand``
  执行动态分析的命令行工具。测试命令行将通过这个工具启动。

  * `CTest Script`_\ 变量：:variable:`CTEST_MEMORYCHECK_COMMAND`
  * :module:`CTest`\ 变量：\ ``MEMORYCHECK_COMMAND``

``MemoryCheckCommandOptions``
  为\ ``MemoryCheckCommand``\ 工具指定命令行选项。它们将被放置在测试命令行之前。

  * `CTest Script`_\ 变量：:variable:`CTEST_MEMORYCHECK_COMMAND_OPTIONS`
  * :module:`CTest`\ 变量：\ ``MEMORYCHECK_COMMAND_OPTIONS``

``MemoryCheckType``
  指定要执行的内存检查类型。

  * `CTest Script`_\ 变量：:variable:`CTEST_MEMORYCHECK_TYPE`
  * :module:`CTest`\ 变量：\ ``MEMORYCHECK_TYPE``

``MemoryCheckSanitizerOptions``
  在使用启用了杀毒功能的构建运行时，指定杀毒功能的选项。

  * `CTest Script`_\ 变量：:variable:`CTEST_MEMORYCHECK_SANITIZER_OPTIONS`
  * :module:`CTest`\ 变量：\ ``MEMORYCHECK_SANITIZER_OPTIONS``

``MemoryCheckSuppressionFile``
  指定包含\ ``MemoryCheckCommand``\ 工具抑制规则的文件。它将与适合于工具的选项一起传递。

  * `CTest Script`_\ 变量：:variable:`CTEST_MEMORYCHECK_SUPPRESSIONS_FILE`
  * :module:`CTest`\ 变量：\ ``MEMORYCHECK_SUPPRESSIONS_FILE``

其他配置设置包括：

``BoundsCheckerCommand``
  指定已知与边界检查器兼容的命令行\ ``MemoryCheckCommand``。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：无

``PurifyCommand``
  指定一个已知与Purify命令行兼容的\ ``MemoryCheckCommand``。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：\ ``PURIFYCOMMAND``

``ValgrindCommand``
  指定一个已知与Valgrind命令行兼容的\ ``MemoryCheckCommand``。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：\ ``VALGRIND_COMMAND``

``ValgrindCommandOptions``
  为\ ``ValgrindCommand``\ 工具指定命令行选项。它们将被放置在测试命令行之前。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：\ ``VALGRIND_COMMAND_OPTIONS``

``DrMemoryCommand``
  指定一个已知与DrMemory兼容的命令行\ ``MemoryCheckCommand``。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：\ ``DRMEMORY_COMMAND``

``DrMemoryCommandOptions``
  为\ ``DrMemoryCommand``\ 工具指定命令行选项。它们将被放置在测试命令行之前。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：\ ``DRMEMORY_COMMAND_OPTIONS``

``CudaSanitizerCommand``
  指定一个\ ``MemoryCheckCommand``，已知它是与cuda-memcheck或compute-sanitizer兼容\
  的命令行。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：\ ``CUDA_SANITIZER_COMMAND``

``CudaSanitizerCommandOptions``
  为\ ``CudaSanitizerCommand``\ 工具指定命令行选项。它们将被放置在测试命令行之前。

  * `CTest Script`_\ 变量：无
  * :module:`CTest`\ 变量：\ ``CUDA_SANITIZER_COMMAND_OPTIONS``

.. _`CTest Submit Step`:

CTest提交步骤
-----------------

在\ `CTest Script`_\ 中，\ :command:`ctest_submit`\ 命令运行此步骤。命令的参数可以指\
定一些步骤设置。

配置设置包括：

``BuildName``
  用一个短字符串描述仪表板客户端平台。（操作系统、编译器等）

  * `CTest Script`_\ 变量：:variable:`CTEST_BUILD_NAME`
  * :module:`CTest`\ 变量：\ ``BUILDNAME``

``CDashVersion``
  遗留的选项。不用。

  * `CTest Script`_\ 变量：无，由服务器检测
  * :module:`CTest`\ 变量：\ ``CTEST_CDASH_VERSION``

``CTestSubmitRetryCount``
  指定在网络故障时重试提交的次数。

  * `CTest Script`_\ 变量：无，使用\ :command:`ctest_submit` ``RETRY_COUNT``\ 选项。
  * :module:`CTest`\ 变量：\ ``CTEST_SUBMIT_RETRY_COUNT``

``CTestSubmitRetryDelay``
  指定在网络故障时重试提交之前的延迟。

  * `CTest Script`_\ 变量：无，使用\ :command:`ctest_submit` ``RETRY_DELAY``\ 选项。
  * :module:`CTest`\ 变量：\ ``CTEST_SUBMIT_RETRY_DELAY``

``CurlOptions``
  指定一个以分号分隔的选项列表来控制Curl库，CTest在内部使用Curl库连接到服务器。可能的选项是\
  ``CURLOPT_SSL_VERIFYPEER_OFF``\ 和\ ``CURLOPT_SSL_VERIFYHOST_OFF``。

  * `CTest Script`_\ 变量：:variable:`CTEST_CURL_OPTIONS`
  * :module:`CTest`\ 变量：\ ``CTEST_CURL_OPTIONS``

``DropLocation``
  遗留的选择。当未设置 ``SubmitURL`` 时，它由\ ``DropMethod``、\ ``DropSiteUser``、\
  ``DropSitePassword``、\ ``DropSite``\ 和\ ``DropLocation``\ 构造。

  * `CTest Script`_\ 变量：:variable:`CTEST_DROP_LOCATION`
  * :module:`CTest`\ 变量：如果设置了，则为\ ``DROP_LOCATION``，否则\
    ``CTEST_DROP_LOCATION``

``DropMethod``
  遗留的选择。当未设置 ``SubmitURL`` 时，它由\ ``DropMethod``、\ ``DropSiteUser``、\
  ``DropSitePassword``、\ ``DropSite``\ 和\ ``DropLocation``\ 构造。

  * `CTest Script`_\ 变量：:variable:`CTEST_DROP_METHOD`
  * :module:`CTest`\ 变量：如果设置了，则为\ ``DROP_METHOD``，否则\
    ``CTEST_DROP_METHOD``

``DropSite``
  遗留的选择。当未设置 ``SubmitURL`` 时，它由\ ``DropMethod``、\ ``DropSiteUser``、\
  ``DropSitePassword``、\ ``DropSite``\ 和\ ``DropLocation``\ 构造。

  * `CTest Script`_\ 变量：:variable:`CTEST_DROP_SITE`
  * :module:`CTest`\ 变量：如果设置了，则为\ ``DROP_SITE``，否则\ ``CTEST_DROP_SITE``

``DropSitePassword``
  遗留的选择。当未设置 ``SubmitURL`` 时，它由\ ``DropMethod``、\ ``DropSiteUser``、\
  ``DropSitePassword``、\ ``DropSite``\ 和\ ``DropLocation``\ 构造。

  * `CTest Script`_\ 变量：:variable:`CTEST_DROP_SITE_PASSWORD`
  * :module:`CTest`\ 变量：如果设置了，则为\ ``DROP_SITE_PASSWORD``，否则\
    ``CTEST_DROP_SITE_PASWORD``

``DropSiteUser``
  遗留的选择。当未设置 ``SubmitURL`` 时，它由\ ``DropMethod``、\ ``DropSiteUser``、\
  ``DropSitePassword``、\ ``DropSite``\ 和\ ``DropLocation``\ 构造。

  * `CTest Script`_\ 变量：:variable:`CTEST_DROP_SITE_USER`
  * :module:`CTest`\ 变量：如果设置了，则为\ ``DROP_SITE_USER``，否则\
    ``CTEST_DROP_SITE_USER``

``IsCDash``
  遗留的选项。不用。

  * `CTest Script`_\ 变量：:variable:`CTEST_DROP_SITE_CDASH`
  * :module:`CTest`\ 变量：\ ``CTEST_DROP_SITE_CDASH``

``ScpCommand``
  遗留的选项。不用。

  * `CTest Script`_\ 变量：:variable:`CTEST_SCP_COMMAND`
  * :module:`CTest`\ 变量：\ ``SCPCOMMAND``

``Site``
  用短字符串描述仪表板客户端主机站点。（主机名、域名等）

  * `CTest Script`_\ 变量：:variable:`CTEST_SITE`
  * :module:`CTest`\ 变量：\ ``SITE``，被\ :command:`site_name`\ 命令初始值。 

``SubmitURL``
  将提交发送到的仪表板服务器的\ ``http``\ 或\ ``https`` URL。

  * `CTest Script`_\ 变量：:variable:`CTEST_SUBMIT_URL`
  * :module:`CTest`\ 变量：如果设置了，则为\ ``SUBMIT_URL``，否则\ ``CTEST_SUBMIT_URL``

``SubmitInactivityTimeout``
  等待提交的时间，如果提交未完成，提交将被取消。指定一个零值来禁用超时。

  * `CTest Script`_\ 变量：:variable:`CTEST_SUBMIT_INACTIVITY_TIMEOUT`
  * :module:`CTest`\ 变量：\ ``CTEST_SUBMIT_INACTIVITY_TIMEOUT``

``TriggerSite``
  遗留的选项。不用。

  * `CTest Script`_\ 变量：:variable:`CTEST_TRIGGER_SITE`
  * :module:`CTest`\ 变量：如果设置了，则为\ ``TRIGGER_SITE``，否则\
    ``CTEST_TRIGGER_SITE``

.. _`Show as JSON Object Model`:

显示为JSON对象模型
=========================

.. versionadded:: 3.14

当给出\ ``--show-only=json-v1``\ 命令行选项时，测试信息以JSON格式输出。版本1.0的JSON对\
象模型定义如下：

``kind``
  字符串“ctestInfo”。

``version``
  指定版本组件的JSON对象。其成员是

  ``major``
    一个非负整数，指定主版本组件。
  ``minor``
    指定次要版本组件的非负整数。

``backtraceGraph``
    JSON对象，使用以下成员表示回溯信息：

    ``commands``
      命令名称列表。
    ``files``
      文件名列表。
    ``nodes``
      包含成员的节点JSON对象列表：

      ``command``
        索引到\ ``backtraceGraph``\ 的\ ``commands``\ 成员。
      ``file``
        索引到\ ``backtraceGraph``\ 的\ ``files``\ 成员。
      ``line``
        添加回溯的文件中的行号。
      ``parent``
        索引到表示图中父节点的\ ``backtraceGraph``\ 的\ ``nodes``\ 成员。

``tests``
  一个JSON数组，列出关于每个测试的信息。每个条目都是一个JSON对象，包含以下成员：

  ``name``
    测试名称。
  ``config``
    测试可以运行的配置。空字符串表示任何配置。
  ``command``
    列表，其中第一个元素是测试命令，其余元素是命令参数。
  ``backtrace``
    索引到\ ``backtraceGraph``\ 的\ ``nodes``\ 成员。
  ``properties``
    测试属性。可以包含每个支持的测试属性的键。

.. _`ctest-resource-allocation`:

资源分配
===================

CTest为测试提供了一种机制，以细粒度的方式指定它们所需的资源，并为用户指定正在运行的机器上可\
用的资源。这允许CTest在内部跟踪哪些资源正在使用，哪些资源是空闲的，以一种防止它们试图声明不\
可用的资源的方式调度测试。

当使用资源分配特性时，CTest不会过度订阅资源。例如，如果一个资源有8个插槽，CTest将不会运行一\
次总共使用超过8个插槽的测试。这样做的效果是限制在任何给定时间内可以运行的测试数量，即使使用了\
高\ ``-j``\ 参数，如果这些测试都使用来自同一资源的一些插槽。此外，这意味着单个测试使用的资源\
超过了机器上可用的资源，将根本不会运行（并且将报告为\ ``Not Run``）。

此功能的一个常见用例是需要使用GPU的测试。多个测试可以同时从一个GPU分配内存，但是如果有太多测\
试试图一次这样做，其中一些测试将分配失败，导致测试失败，即使测试如果拥有所需的内存也会成功。\
通过使用资源分配特性，每个测试都可以指定它从GPU需要多少内存，从而允许CTest以一种同时运行几个\
测试而不会耗尽GPU内存池的方式来安排测试。

请注意，CTest没有GPU是什么或它有多少内存的概念。它没有任何与GPU通信的方式来检索这些信息或\
执行任何内存管理，尽管项目可以定义一个测试，提供有关测试机器的详细信息（参见\
:ref:`ctest-resource-dynamically-generated-spec-file`）。

CTest跟踪抽象资源类型的列表，其中每个类型都有一定数量的槽可供测试使用。每个测试指定它从某个\
资源中需要的插槽数量，然后CTest以一种防止正在使用的插槽总数超过列出的容量的方式调度它们。\
当执行测试时，资源中的插槽被分配给该测试，测试可以假设它们在测试进程的持续时间内独占使用这些插槽。

CTest资源分配特性由最少两个输入组成：

* :ref:`资源规范文件 <ctest-resource-specification-file>`，如下所述，它描述了系统上可\
  用的资源。
* 测试的\ :prop_test:`RESOURCE_GROUPS`\ 属性，它描述测试所需的资源。

当CTest运行测试时，分配给该测试的资源以一组\
:ref:`环境变量 <ctest-resource-environment-variables>`\ 的形式传递，如下所述。使用此\
信息来决定将连接到哪个资源留给测试编写者。

``RESOURCE_GROUPS``\ 属性告诉CTest测试期望使用什么资源，以对测试有意义的方式进行分组。测\
试本身必须读取\ :ref:`环境变量 <ctest-resource-environment-variables>`，以确定分配给\
每个组的资源。例如，每个组可能对应于测试在执行时将产生的一个进程。

注意，即使测试指定了\ ``RESOURCE_GROUPS``\ 属性，如果用户没有传递资源规范文件，该测试仍然\
有可能在没有任何资源分配（并且没有相应的\
:ref:`环境变量 <ctest-resource-environment-variables>`）的情况下运行。通过\
``--resource-spec-file``\ 命令行参数或\ ``RESOURCE_SPEC_FILE``\ 参数将该文件传递给\
:command:`ctest_test`，将激活资源分配特性。测试应该检查\ ``CTEST_RESOURCE_GROUP_COUNT``\
环境变量，以确定是否激活了资源分配。如果激活了资源分配，这个变量将始终（且仅）被定义。如果没有\
激活资源分配，那么\ ``CTEST_RESOURCE_GROUP_COUNT``\ 变量将不存在，即使它存在于父\
:program:`ctest`\ 进程中。如果测试绝对必须有资源分配，那么它可以返回失败的退出代码，或者使\
用\ :prop_test:`SKIP_RETURN_CODE`\ 或\ :prop_test:`SKIP_REGULAR_EXPRESSION`\ 属性\
来指示跳过的测试。

.. _`ctest-resource-specification-file`:

资源规格文件
---------------------------

资源规范文件是一个JSON文件，以多种方式传递给CTest。它可以在命令行上使用\
:option:`ctest --resource-spec-file`\ 选项指定，也可以使用\ :command:`ctest_test`\
的\ ``RESOURCE_SPEC_FILE``\ 参数指定，或者可以作为测试执行的一部分动态生成（参见\
:ref:`ctest-resource-dynamically-generated-spec-file`）。

如果使用仪表板脚本，并且没有指定\ ``RESOURCE_SPEC_FILE``，则使用仪表板脚本中的\
:variable:`CTEST_RESOURCE_SPEC_FILE`\ 的值。如果没有指定仪表板脚本中的\
:option:`--resource-spec-file <ctest --resource-spec-file>`、\
``RESOURCE_SPEC_FILE``\ 和\ :variable:`CTEST_RESOURCE_SPEC_FILE`，则使用CMake构建\
中的\ :variable:`CTEST_RESOURCE_SPEC_FILE`\ 的值。如果这些都没有指定，则不使用资源规范文件。

资源规范文件必须是一个JSON对象。本文档中的所有例子都假设了以下资源规范文件：

.. code-block:: json

  {
    "version": {
      "major": 1,
      "minor": 0
    },
    "local": [
      {
        "gpus": [
          {
            "id": "0",
            "slots": 2
          },
          {
            "id": "1",
            "slots": 4
          },
          {
            "id": "2",
            "slots": 2
          },
          {
            "id": "3"
          }
        ],
        "crypto_chips": [
          {
            "id": "card0",
            "slots": 4
          }
        ]
      }
    ]
  }

The members are:

成员包括：

``version``
  包含一个\ ``major``\ 整数字段和一个\ ``minor``\ 整数字段的对象。目前，唯一支持的版本是\
  major ``1``, minor ``0``。任何其他值都是错误的。

``local``
  系统上呈现的资源集的JSON数组。目前，这个数组的大小被限制为1。

  每个数组元素都是一个JSON对象，其成员的名称等于所需的资源类型，例如\ ``gpus``。这些名称必\
  须以小写字母或下划线开头，后面的字符可以是小写字母、数字或下划线。不允许使用大写字母，因为\
  某些平台有不区分大小写的环境变量。有关更多信息，请参阅下面的\ `环境变量`_\ 部分。建议资源\
  类型名称为名词的复数形式，如\ ``gpus``\ 或\ ``crypto_chips``\ （而不是\ ``gpu``\ 或\
  ``crypto_chip``）。

  请注意，名称\ ``gpus``\ 和\ ``crypto_chips``\ 只是示例，CTest不会以任何方式解释它们。\
  你可以自由地创建任何想要满足自己需求的资源类型。

  每种资源类型的值都是由JSON对象组成的JSON数组，每个对象描述指定资源的特定实例。这些对象有\
  以下成员：

  ``id``
    由资源标识符组成的字符串。标识符中的每个字符可以是小写字母、数字或下划线。不允许使用大写字母。

    标识符在资源类型中必须是唯一的。但是，它们不必在资源类型之间是唯一的。例如，一个名为\
    ``0``\ 的\ ``gpus``\ 资源和一个名为\ ``0``\ 的\ ``crypto_chips``\ 资源是有效的，\
    但不能两个都名为\ ``0``\ 的\ ``gpus``\ 资源。

    请注意，ID ``0``、\ ``1``、\ ``2``、\ ``3``\ 和\ ``card0``\ 只是示例，CTest不会\
    以任何方式解释它们。你可以自由地创建任何你想要的ID来满足你自己的需求。

  ``slots``
    一个可选的无符号数，指定资源上可用的插槽数。例如，这可能是GPU上的兆字节RAM，或者是加密\
    芯片上可用的加密单元。如果未指定\ ``slots``，则假定缺省值为\ ``1``。

在上面的示例文件中，有四个ID为0到3的GPU。GPU 0有2个槽位，GPU 1有4个槽位，GPU 2有2个槽位，\
GPU 3默认有1个槽位。还有一个带4插槽的密码芯片。

``RESOURCE_GROUPS``\ 属性
----------------------------

有关此属性的描述，请参阅\ :prop_test:`RESOURCE_GROUPS`。

.. _`ctest-resource-environment-variables`:

环境变量
---------------------

一旦CTest决定将哪些资源分配给测试，它就会将这些信息作为一系列环境变量传递给测试可执行文件。\
对于下面的每个示例，我们将假设所讨论的测试的\ :prop_test:`RESOURCE_GROUPS`\ 属性为\
``2,gpus:2;gpus:4,gpus:1,crypto_chips:2``。

以下变量被传递给测试过程：

.. envvar:: CTEST_RESOURCE_GROUP_COUNT

  :prop_test:`RESOURCE_GROUPS`\ 属性指定的组的总数。例如：

  * ``CTEST_RESOURCE_GROUP_COUNT=3``

  只有在给\ :manual:`ctest(1)`\ 指定了\ ``--resource-spec-file``，或者给\
  :command:`ctest_test`\ 指定了\ ``RESOURCE_SPEC_FILE``\ 时，才会定义这个变量。如果没\
  有给出资源规范文件，则不会定义该变量。

.. envvar:: CTEST_RESOURCE_GROUP_<num>

  分配给每个组的资源类型列表，每个项之间用逗号分隔。\ ``<num>``\ 是一个从零到\
  ``CTEST_RESOURCE_GROUP_COUNT``\ 减一的数字。\ ``CTEST_RESOURCE_GROUP_<num>``\ 是\
  为这个范围中的每个\ ``<num>``\ 定义的。例如：

  * ``CTEST_RESOURCE_GROUP_0=gpus``
  * ``CTEST_RESOURCE_GROUP_1=gpus``
  * ``CTEST_RESOURCE_GROUP_2=crypto_chips,gpus``

.. envvar:: CTEST_RESOURCE_GROUP_<num>_<resource-type>

  资源ID的列表和分配给给定资源类型的每个组的每个ID的插槽数量。这个变量由一系列对组成，每一对\
  由分号分隔，其中的两个项目由逗号分隔。每对中的第一项是\ ``id:``\ 后面是类型为\
  ``<resource-type>``\ 的资源的ID，第二项是\ ``slots:``\ 后面是分配给给定组的资源的插槽\
  数。例如：

  * ``CTEST_RESOURCE_GROUP_0_GPUS=id:0,slots:2``
  * ``CTEST_RESOURCE_GROUP_1_GPUS=id:2,slots:2``
  * ``CTEST_RESOURCE_GROUP_2_GPUS=id:1,slots:4;id:3,slots:1``
  * ``CTEST_RESOURCE_GROUP_2_CRYPTO_CHIPS=id:card0,slots:2``

  在本例中，组0从GPU ``0``\ 获得2个插槽，组1从GPU ``2``\ 获得2个插槽，组2从GPU ``1``\
  获得4个插槽，从GPU ``3``\ 获得1个插槽，从加密芯片\ ``card0``\ 获得2个插槽。

  ``<num>``\ 是一个从零到\ ``CTEST_RESOURCE_GROUP_COUNT``\ 减一的数字。\
  ``<resource-type>``\ 是资源类型的名称，转换成大写。\
  ``CTEST_RESOURCE_GROUP_<num>_<resource-type>``\ 是为上面列出的范围中的每个\
  ``<num>``\ 和\ ``CTEST_RESOURCE_GROUP_<num>``\ 中列出的每个资源类型的乘积定义的。

  由于某些平台对环境变量具有不区分大小写的名称，因此资源类型的名称在不区分大小写的环境中可能\
  不会冲突。因此，为了简单起见，在\ :ref:`资源规范文件 <ctest-resource-specification-file>`\
  和\ :prop_test:`RESOURCE_GROUPS`\ 属性中，所有资源类型都必须以小写形式列出，并且在\
  ``CTEST_RESOURCE_GROUP_<num>_<resource-type>``\ 环境变量中将它们全部转换为大写形式。

.. _`ctest-resource-dynamically-generated-spec-file`:

动态生成的资源规范文件
-------------------------------------------------

.. versionadded:: 3.28

项目可以选择指定单个测试，该测试将用于动态生成资源规范文件，CTest将使用该文件调度使用资源的\
测试。生成文件的测试必须设置\ :prop_test:`GENERATED_RESOURCE_SPEC_FILE`\ 属性，并且在\
其\ :prop_test:`FIXTURES_SETUP`\ 属性中必须只有一个fixture。CTest认为这个fixture具有\
特殊的含义：它是生成资源规范文件的fixture。fixture可以有任何名称。如果存在这样的fixture，\
那么设置了\ :prop_test:`RESOURCE_GROUPS`\ 的所有测试必须在其\
:prop_test:`FIXTURES_REQUIRED`\ 中包含该fixture，并且资源规范文件不能使用\
``--resource-spec-file``\ 参数或\ :variable:`CTEST_RESOURCE_SPEC_FILE`\ 变量指定。

.. _`ctest-job-server-integration`:

作业服务器集成
======================

.. versionadded:: 3.29

在POSIX系统上，当在\ `Job Server`_\ 上下文中运行时，CTest共享其作业槽。这独立于\
:prop_test:`PROCESSORS`\ 测试属性，该属性仍然对CTest的\ :option:`-j <ctest -j>`\
并行级别进行计数。CTest在运行每个测试之前从作业服务器获取一个令牌，并在测试结束时返回它。

例如，考虑\ ``Makefile``：

.. literalinclude:: CTEST_EXAMPLE_MAKEFILE_JOB_SERVER.make
  :language: make

当通过\ ``make -j 2 test``\ 调用时，\ ``ctest``\ 连接到作业服务器，为每个测试获取一个\
令牌，并同时运行最多2个测试。

在Windows系统上，作业服务器集成尚未实现。

.. _`Job Server`: https://www.gnu.org/software/make/manual/html_node/Job-Slots.html

另请参阅
========

.. include:: LINKS.txt
