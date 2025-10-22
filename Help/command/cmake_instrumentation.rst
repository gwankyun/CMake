cmake_instrumentation
---------------------

.. versionadded:: 4.0

.. note::

   仅当通过\ ``CMAKE_EXPERIMENTAL_INSTRUMENTATION``\ 开关启用了对检测功能的实验性支持时，\
   此命令才可用。

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

必须始终指定\ ``API_VERSION``\ 和\ ``DATA_VERSION``。目前，这两个字段仅支持的值为1。\
有关\ ``API_VERSION``\ 的详细信息，请参阅\ :ref:`cmake-instrumentation API v1`；有关\
``DATA_VERSION``\ 的详细信息，请参阅\ :ref:`cmake-instrumentation Data v1`。

可选关键字 ``HOOKS``、\ ``OPTIONS``\ 和\ ``CALLBACK``\ 分别对应于\
:ref:`cmake-instrumentation v1 Query Files`\ 中的一个参数。\
``CALLBACK``\ 关键字可以多次使用，以创建多个回调。

每当调用\ ``cmake_instrumentation``\ 时，会在\ ``<build>/.cmake/instrumentation/v1/query/generated``\
目录下生成一个查询文件，以便使用所提供的参数启用检测功能。

.. _`cmake_instrumentation CUSTOM_CONTENT`:

Custom CMake Content
^^^^^^^^^^^^^^^^^^^^

The ``CUSTOM_CONTENT`` argument specifies certain data from configure time to
include in each :ref:`cmake-instrumentation v1 CMake Content File`. This
may be used to associate instrumentation data with certain information about its
configuration, such as the optimization level or whether it is part of a
coverage build.

``CUSTOM_CONTENT`` expects ``name``, ``type`` and ``content`` arguments.

``name`` is a specifier to identify the content being reported.

``type`` specifies how the content should be interpreted. Supported values are:
  * ``STRING`` the content is a string.
  * ``BOOL`` the content should be interpreted as a boolean. It will be ``true``
    under the same conditions that ``if()`` would be true for the given value.
  * ``LIST`` the content is a CMake ``;`` separated list that should be parsed.
  * ``JSON`` the content should be parsed as a JSON string. This can be a
    number such as ``1`` or ``5.0``, a quoted string such as ``\"string\"``,
    a boolean value ``true``/``false``, or a JSON object such as
    ``{ \"key\" : \"value\" }`` that may be constructed using
    ``string(JSON ...)`` commands.

``content`` is the actual content to report.

Example
^^^^^^^

以下示例展示了该命令的调用方式以及与之等效的JSON查询文件。

.. code-block:: cmake

  cmake_instrumentation(
    API_VERSION 1
    DATA_VERSION 1
    HOOKS postGenerate preCMakeBuild postCMakeBuild
    OPTIONS staticSystemInformation dynamicSystemInformation trace
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
      "staticSystemInformation", "dynamicSystemInformation", "trace"
    ],
    "callbacks": [
      "/path/to/cmake -P /path/to/handle_data.cmake"
      "/path/to/cmake -P /path/to/handle_data_2.cmake"
    ]
  }

This will also result in the following content included in each
:ref:`cmake-instrumentation v1 CMake Content File`:

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
