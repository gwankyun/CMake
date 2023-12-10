SKIP_AUTORCC
------------

.. versionadded:: 3.8

从\ :prop_tgt:`AUTORCC`\ 处理中排除源文件（对于Qt项目）。

For broader exclusion control see :prop_sf:`SKIP_AUTOGEN`.

EXAMPLE
^^^^^^^

.. code-block:: cmake

  # ...
  set_property(SOURCE file.qrc PROPERTY SKIP_AUTORCC ON)
  # ...
