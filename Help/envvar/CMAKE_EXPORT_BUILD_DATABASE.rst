CMAKE_EXPORT_BUILD_DATABASE
---------------------------

.. versionadded:: 3.31

.. include:: ENV_VAR.txt

当第一次运行创建新构建树时没有给出显式配置时，:variable:`CMAKE_EXPORT_BUILD_DATABASE`\
的默认值。稍后在现有构建树中运行时，该值将作为\ :variable:`CMAKE_EXPORT_BUILD_DATABASE`\
保存在缓存中。

.. note ::

   This variable is meaningful only when experimental support for build
   databases has been enabled by the
   ``CMAKE_EXPERIMENTAL_EXPORT_BUILD_DATABASE`` gate.
