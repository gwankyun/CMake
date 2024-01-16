CMAKE_AUTOUIC_OPTIONS
---------------------

使用\ :variable:`CMAKE_AUTOUIC`\ 时为\ ``uic``\ 提供的附加选项。

This variable is used to initialize the :prop_tgt:`AUTOUIC_OPTIONS` property on
all the targets.  See that target property for additional information.

EXAMPLE
^^^^^^^

.. code-block:: cmake

  # ...
  set_property(CMAKE_AUTOUIC_OPTIONS "--no-protection")
  # ...
