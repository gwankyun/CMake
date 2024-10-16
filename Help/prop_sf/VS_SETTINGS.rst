VS_SETTINGS
-----------

.. versionadded:: 3.18

在文件上设置任何项元数据。

.. versionadded:: 3.22

  This property is honored for all source file types.
  Previously it worked only for non-built files.

Takes a list of ``Key=Value`` pairs. Tells the Visual Studio generator to set
``Key`` to ``Value`` as item metadata on the file.

For example:

.. code-block:: cmake

  set_property(SOURCE file.hlsl PROPERTY VS_SETTINGS "Key=Value" "Key2=Value2")

will set ``Key`` to ``Value`` and ``Key2`` to ``Value2`` on the
``file.hlsl`` item as metadata.

:manual:`Generator expressions <cmake-generator-expressions(7)>` are supported.
