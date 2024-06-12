add_dependencies
----------------

添加顶层目标之间的依赖关系。

.. code-block:: cmake

  add_dependencies(<target> [<target-dependency>]...)

使一个顶层\ ``<target>``\ 依赖于其他顶层目标，以确保它们在\ ``<target>``\ 之前构建。\
顶层目标是由\ :command:`add_executable`、\ :command:`add_library`\ 或\
:command:`add_custom_target`\ 命令创建的目标（但不是由如\ ``install``\ 这样的CMake生\
成目标）。

添加到\ :ref:`导入的目标 <Imported Targets>`\ 或\ :ref:`接口库 <Interface Libraries>`\
中的依赖项会在其位置传递，因为目标本身不会构建。

.. versionadded:: 3.3
  允许向接口库添加依赖项。

.. versionadded:: 3.8
  Dependencies will populate the :prop_tgt:`MANUALLY_ADDED_DEPENDENCIES`
  property of ``<target>``.

.. versionchanged:: 3.9
  The :ref:`Ninja Generators` use weaker ordering than
  other generators in order to improve available concurrency.
  They only guarantee that the dependencies' custom commands are
  finished before sources in ``<target>`` start compiling; this
  ensures generated sources are available.

另请参阅
^^^^^^^^

* :command:`add_custom_target`\ 和\ :command:`add_custom_command`\ 命令的\
  ``DEPENDS``\ 选项用于在自定义规则中添加文件级依赖项。

* :prop_sf:`OBJECT_DEPENDS`\ 源文件属性用于向对象文件添加文件级依赖项。
