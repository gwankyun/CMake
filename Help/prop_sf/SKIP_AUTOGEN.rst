SKIP_AUTOGEN
------------

.. versionadded:: 3.8

从\ :prop_tgt:`AUTOMOC`、\ :prop_tgt:`AUTOUIC`\ 和\ :prop_tgt:`AUTORCC`\ 处理中排\
除源文件（对于Qt项目）。

For finer exclusion control see :prop_sf:`SKIP_AUTOMOC`,
:prop_sf:`SKIP_AUTOUIC` and :prop_sf:`SKIP_AUTORCC`.

EXAMPLE
^^^^^^^

.. code-block:: cmake

  # ...
  set_property(SOURCE file.h PROPERTY SKIP_AUTOGEN ON)
  # ...
