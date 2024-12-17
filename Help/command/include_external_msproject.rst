include_external_msproject
--------------------------

在\ :ref:`Visual Studio Generators`\ 生成的解决方案文件中包含外部Microsoft项目文件。\
在其他生成器上被忽略。

.. code-block:: cmake

  include_external_msproject(projectname location
                             [TYPE projectTypeGUID]
                             [GUID projectGUID]
                             [PLATFORM platformName]
                             dep1 dep2 ...)

在生成的解决方案文件中包含一个外部Microsoft项目。这将创建一个名为\ ``[projectname]``\
的目标。这可以在\ :command:`add_dependencies`\ 命令中使用，使一些事物依赖于外部项目。

``TYPE``、\ ``GUID``\ 和\ ``PLATFORM``\ 是可选参数，允许指定项目的类型、项目的id （\
``GUID``\ ）和目标平台的名称。这对于需要默认值以外的项目（例如WIX项目）很有用。

.. versionadded:: 3.9
  如果导入的项目与当前项目具有不同的配置名称，则设置\ :prop_tgt:`MAP_IMPORTED_CONFIG_<CONFIG>`\
  目标属性来指定映射。
