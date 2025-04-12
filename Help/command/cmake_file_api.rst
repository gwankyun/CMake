cmake_file_api
--------------

.. versionadded:: 3.27

启用与\ :manual:`CMake文件API <cmake-file-api(7)>`\ 的交互。

.. signature::
  cmake_file_api(QUERY ...)

  ``QUERY``\ 子命令为当前的CMake调用添加一个文件API查询。

  .. code-block:: cmake

    cmake_file_api(
      QUERY
      API_VERSION <version>
      [CODEMODEL <versions>...]
      [CACHE <versions>...]
      [CMAKEFILES <versions>...]
      [TOOLCHAINS <versions>...]
    )

  必须始终指定\ ``API_VERSION``。目前，\ ``<version>``\ 唯一支持的值是1。有关回复内容\
  和位置的详细信息，请参阅\ :ref:`file-api v1`。

  可选关键字\ ``CODEMODEL``、\ ``CACHE``、\ ``CMAKEFILES``\ 和\ ``CMAKEFILES``\
  分别对应项目可以请求的一种对象类型。\ ``configureLog``\ 对象类型不能使用此命令进行设置，\
  因为它必须在CMake开始读取顶层\ ``CMakeLists.txt``\ 文件之前进行设置。

  对于每个可选关键字，\ ``<versions>``\ 列表必须包含一个或多个版本值，其格式为\ ``major``\
  或\ ``major.minor``，其中\ ``major``\ 和\ ``minor``\ 为整数。项目应按其偏好顺序列出\
  其接受的版本，因为只会选择列表中第一个受支持的值。如果某个版本的\ ``major``\ 版本号高于\
  该对象类型所支持的任何主要版本号，该命令将忽略该版本。\
  如果遇到无效的版本号，或者所请求的版本均不受支持，该命令将抛出错误。

  对于所请求的每种对象类型，内部会添加一个等同于共享的、无状态查询的查询。不会在文件系统中创建\
  查询文件。但在生成阶段，查询回复\ *会*\ 被写入文件系统。

  多次添加针对同一内容的查询并非错误，无论这些查询是来自查询文件，还是来自对\
  ``cmake_file_api(QUERY)``\ 的多次调用。\
  最终的查询集合将是磁盘上指定的所有查询以及项目提交的查询的合并结果。

示例
^^^^^^^

项目可能希望在构建时利用文件API的回复来执行某种验证任务。项目无需依赖CMake外部的工具来创建\
查询文件，而是可以使用\ ``cmake_file_api(QUERY)``\ 命令为当前运行请求所需的信息。然后，\
项目可以创建一个自定义命令，在构建时运行该命令，并且可以确保所请求的信息始终可用。

.. code-block:: cmake

  cmake_file_api(
    QUERY
    API_VERSION 1
    CODEMODEL 2.3
    TOOLCHAINS 1
  )

  add_custom_target(verify_project
    COMMAND ${CMAKE_COMMAND}
      -D BUILD_DIR=${CMAKE_BINARY_DIR}
      -D CONFIG=$<CONFIG>
      -P ${CMAKE_CURRENT_SOURCE_DIR}/verify_project.cmake
  )
