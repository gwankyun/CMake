VS_DPI_AWARE
------------

.. versionadded:: 3.16

在Visual Studio目标项目属性中设置Manifest Tool -> Input and Output -> DPI Awareness。

Valid values are ``PerMonitor``, ``ON``, or ``OFF``.

For example:

.. code-block:: cmake

  add_executable(myproject myproject.cpp)
  set_property(TARGET myproject PROPERTY VS_DPI_AWARE "PerMonitor")
