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
    [QUERIES <queries>...]
    [CALLBACK <callback>]
  )

必须始终指定\ ``API_VERSION``\ 和\ ``DATA_VERSION``。目前，这两个字段仅支持的值为1。\
有关\ ``API_VERSION``\ 的详细信息，请参阅\ :ref:`cmake-instrumentation API v1`；有关\
``DATA_VERSION``\ 的详细信息，请参阅\ :ref:`cmake-instrumentation Data v1`。

可选关键字 ``HOOKS``、\ ``QUERIES``\ 和\ ``CALLBACK``\ 分别对应于\
:ref:`cmake-instrumentation v1 Query Files`\ 中的一个参数。\
``CALLBACK``\ 关键字可以多次使用，以创建多个回调。

每当调用\ ``cmake_instrumentation``\ 时，会在\ ``<build>/.cmake/instrumentation/v1/query/generated``\
目录下生成一个查询文件，以便使用所提供的参数启用检测功能。

示例
^^^^^^^

以下示例展示了该命令的调用方式以及与之等效的JSON查询文件。

.. code-block:: cmake

  cmake_instrumentation(
    API_VERSION 1
    DATA_VERSION 1
    HOOKS postGenerate preCMakeBuild postCMakeBuild
    QUERIES staticSystemInformation dynamicSystemInformation
    CALLBACK ${CMAKE_COMMAND} -P /path/to/handle_data.cmake
    CALLBACK ${CMAKE_COMMAND} -P /path/to/handle_data_2.cmake
  )

.. code-block:: json

  {
    "version": 1,
    "hooks": [
      "postGenerate", "preCMakeBuild", "postCMakeBuild"
    ],
    "queries": [
      "staticSystemInformation", "dynamicSystemInformation"
    ],
    "callbacks": [
      "/path/to/cmake -P /path/to/handle_data.cmake"
      "/path/to/cmake -P /path/to/handle_data_2.cmake"
    ]
  }
