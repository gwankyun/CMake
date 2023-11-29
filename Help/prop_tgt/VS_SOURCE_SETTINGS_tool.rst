VS_SOURCE_SETTINGS_<tool>
-------------------------

.. versionadded:: 3.18

在使用<tool>的所有非构建文件上设置任何项元数据。

Takes a list of ``Key=Value`` pairs. Tells the Visual Studio generator
to set ``Key`` to ``Value`` as item metadata on all non-built files
that use ``<tool>``.

For example:

.. code-block:: cmake

  set_property(TARGET main PROPERTY VS_SOURCE_SETTINGS_FXCompile "Key=Value" "Key2=Value2")

will set ``Key`` to ``Value`` and ``Key2`` to ``Value2`` for all
non-built files that use ``FXCompile``.

:manual:`Generator expressions <cmake-generator-expressions(7)>` are supported.
