CTEST_USE_INSTRUMENTATION
-------------------------

.. versionadded:: 4.0

.. include:: include/ENV_VAR.rst

.. note::

   此功能仅在通过\ ``CMAKE_EXPERIMENTAL_INSTRUMENTATION``\ 开关启用了对插桩的实验性支持\
   时才可用。

Setting this environment variable to ``1``, ``True``, or ``ON`` enables
:manual:`instrumentation <cmake-instrumentation(7)>` for CTest in
:ref:`Dashboard Client` mode.
