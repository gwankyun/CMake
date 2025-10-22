CTEST_USE_VERBOSE_INSTRUMENTATION
---------------------------------

.. versionadded:: 4.0

.. include:: include/ENV_VAR.rst

.. note::

   此功能仅在通过\ ``CMAKE_EXPERIMENTAL_INSTRUMENTATION``\ 开关启用了对插桩的实验性支持\
   时才可用。

Setting this environment variable to ``1``, ``True``, or ``ON`` causes CTest to
report the full command line (including arguments) to CDash for each
instrumented command. By default, CTest truncates the command line at the first
space.

See also :envvar:`CTEST_USE_INSTRUMENTATION`
