AUTORCC_OPTIONS
---------------

使用\ :prop_tgt:`AUTORCC`\ 时\ ``rcc``\ 的附加选项

This property holds additional command line options which will be used when
``rcc`` is executed during the build via :prop_tgt:`AUTORCC`, i.e. it is equivalent to the
optional ``OPTIONS`` argument of the :module:`qt4_add_resources() <FindQt4>` macro.

By default it is empty.

The options set on the ``.qrc`` source file may override
:prop_tgt:`AUTORCC_OPTIONS` set on the target.

EXAMPLE
^^^^^^^

.. code-block:: cmake

  # ...
  set_property(SOURCE resources.qrc PROPERTY AUTORCC_OPTIONS "--compress;9")
  # ...
