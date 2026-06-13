build_command
-------------

获取用于生成当前项目的命令行。一般由\ :module:`CTest`\ 模块内部使用。

.. code-block:: cmake

  build_command(<variable>
                [CONFIGURATION <config>]
                [PARALLEL_LEVEL <parallel>]
                [TARGET <target>]
                [PROJECT_NAME <projname>] # legacy, causes warning
               )

将给定的\ ``<variable>``\ 设置为以下形式的命令行字符串::

 <cmake> --build . [--config <config>] [--parallel <parallel>] [--target <target>...]

其中，\ ``<cmake>``\ 是\ :manual:`cmake(1)`\ 命令行工具的路径，而\ ``<config>``、\
``<parallel>``\ 和\ ``<target>``\ 分别是传递给\ ``CONFIGURATION``、\ ``PARALLEL_LEVEL``\
和\ ``TARGET``\ 选项的值（如果有的话）。在CMake 4.0之前的版本中，如果策略\ :policy:`CMP0061`\
未设置为\ ``NEW``，则会为\ :ref:`Makefile Generators`\ 添加一个尾随的\ ``-- -i``\ 选项。

当调用此\ :option:`cmake --build`\ 命令行时，将启动底层的构建系统工具。

.. versionadded:: 3.21
  ``PARALLEL_LEVEL``\ 参数可用于设置\
  :cmake-build-option:`--parallel`\ 标志。

.. code-block:: cmake

  build_command(<cachevariable> <makecommand>)

第二种签名形式已被弃用，但为了向后兼容仍可使用。请使用第一种签名形式。

它会将给定的\ ``<cachevariable>``\ 设置为上述形式的命令行字符串，但不包含\
:cmake-build-option:`--target`\ 选项。\ ``<makecommand>``\ 会被忽略，\
但在进行旧版调用时，它应该是devenv、nmake、make或其他终端用户构建工具的完整路径。

.. note::
 在CMake 3.0之前的版本中，此命令返回的命令行可直接调用当前生成器对应的原生构建工具。当时对\
 ``PROJECT_NAME``\ 选项的实现并无实际作用，因此现在使用该选项时，CMake会给出警告。
