MSVC_IDE
--------

在使用Microsoft Visual C++ IDE时为\ ``True``。

Set to ``true`` when the target platform is the Microsoft Visual C++ IDE, as
opposed to the command line compiler.

.. note::

  This variable is only available after compiler detection has been performed,
  so it is not available to toolchain files or before the first
  :command:`project` or :command:`enable_language` call which uses an
  MSVC-like compiler.
