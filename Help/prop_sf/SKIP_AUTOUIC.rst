SKIP_AUTOUIC
------------

.. versionadded:: 3.8

从\ :prop_tgt:`AUTOUIC`\ 处理中排除源文件（对于Qt项目）。

``SKIP_AUTOUIC`` can be set on C++ header and source files and on
``.ui`` files.

For broader exclusion control see :prop_sf:`SKIP_AUTOGEN`.

EXAMPLE
^^^^^^^

.. code-block:: cmake

  # ...
  set_property(SOURCE file.h PROPERTY SKIP_AUTOUIC ON)
  set_property(SOURCE file.cpp PROPERTY SKIP_AUTOUIC ON)
  set_property(SOURCE widget.ui PROPERTY SKIP_AUTOUIC ON)
  # ...
