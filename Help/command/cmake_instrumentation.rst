cmake_instrumentation
---------------------

.. versionadded:: 4.3

开启与\ :manual:`CMake Instrumentation API <cmake-instrumentation(7)>`\ 交互。

这允许在项目级别配置检测功能。

.. code-block:: cmake

  cmake_instrumentation(
    API_VERSION <version>
    DATA_VERSION <version>
    [HOOKS <hooks>...]
    [OPTIONS <options>...]
    [CALLBACK <callback>]
    [CUSTOM_CONTENT <name> <type> <content>]
  )

必须始终指定 ``API_VERSION`` 和 ``DATA_VERSION``。

``API_VERSION`` 是一个整数。当前唯一支持的值为 ``1``。\
详见 :ref:`cmake-instrumentation API v1`。

``DATA_VERSION`` 是形如 ``major`` 或 ``major.minor`` 的版本值。\
当前支持的最大版本为 ``1.1``。详见 :ref:`cmake-instrumentation Data Version`。

可选关键字 ``HOOKS``、\ ``OPTIONS``\ 和\ ``CALLBACK``\ 分别对应于\
:ref:`cmake-instrumentation v1 Query Files`\ 中的一个参数。\
``CALLBACK``\ 关键字可以多次使用，以创建多个回调。

每当调用\ ``cmake_instrumentation``\ 时，会在\ ``<build>/.cmake/instrumentation/v1/query/generated``\
目录下生成一个查询文件，以便使用所提供的参数启用检测功能。

.. _`cmake_instrumentation CUSTOM_CONTENT`:

自定义 CMake 内容
^^^^^^^^^^^^^^^^^^^^

``CUSTOM_CONTENT`` 参数指定了来自配置阶段的特定数据，以包含在每个
:ref:`cmake-instrumentation v1 CMake Content File` 中。这可用于将\
插桩数据与其配置相关的信息进行关联，例如优化级别或是否属于覆盖率构建的一部分。

``CUSTOM_CONTENT`` 接受 ``name``、 ``type`` 和 ``content`` 参数。

``name`` 是用于标识所报告内容的标识符。

``type`` 指定内容的解释方式。支持的值为：
  * ``STRING`` —— 内容是一个字符串。
  * ``BOOL`` —— 内容应被解释为布尔值。在 ``if()`` 对给定值为真的相同条件下，\
    其值将为 ``true``。
  * ``LIST`` —— 内容是一个以 CMake ``;`` 分隔的列表，应被解析。
  * ``JSON`` —— 内容应被解析为 JSON 字符串。可以是数字，如 ``1`` 或 ``5.0``；
    引号字符串，如 ``\"string\"``；布尔值 ``true``/``false``；或 JSON 对象，
    如 ``{ \"key\" : \"value\" }``，可使用 ``string(JSON ...)`` 命令构造。

``content`` 是要报告的实际内容。

示例
^^^^^^^

以下示例展示了该命令的调用方式以及与之等效的JSON查询文件。

.. code-block:: cmake

  cmake_instrumentation(
    API_VERSION 1
    DATA_VERSION 1.0
    HOOKS postGenerate preCMakeBuild postCMakeBuild
    OPTIONS staticSystemInformation dynamicSystemInformation compileTrace trace
    CALLBACK ${CMAKE_COMMAND} -P /path/to/handle_data.cmake
    CALLBACK ${CMAKE_COMMAND} -P /path/to/handle_data_2.cmake
    CUSTOM_CONTENT myString STRING string
    CUSTOM_CONTENT myList   LIST   "item1;item2"
    CUSTOM_CONTENT myObject JSON   "{ \"key\" : \"value\" }"
  )

.. code-block:: json

  {
    "version": 1,
    "hooks": [
      "postGenerate", "preCMakeBuild", "postCMakeBuild"
    ],
    "options": [
      "staticSystemInformation", "dynamicSystemInformation", "compileTrace", "trace"
    ],
    "callbacks": [
      "/path/to/cmake -P /path/to/handle_data.cmake",
      "/path/to/cmake -P /path/to/handle_data_2.cmake"
    ]
  }

这还将导致以下内容被包含在每个
:ref:`cmake-instrumentation v1 CMake Content File` 中：

.. code-block:: json

  "custom": {
    "myString": "string",
    "myList": [
      "item1", "item2"
    ],
    "myObject": {
      "key": "value"
    }
  }
