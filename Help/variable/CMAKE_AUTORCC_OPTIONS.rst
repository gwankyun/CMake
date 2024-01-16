CMAKE_AUTORCC_OPTIONS
---------------------

使用\ :variable:`CMAKE_AUTORCC`\ 时\ ``rcc``\ 的附加选项。

This variable is used to initialize the :prop_tgt:`AUTORCC_OPTIONS` property on
all the targets.  See that target property for additional information.

EXAMPLE
^^^^^^^

.. code-block:: cmake

  # ...
  set(CMAKE_AUTORCC_OPTIONS "--compress;9")
  # ...
