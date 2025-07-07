CTEST_USE_VERBOSE_INSTRUMENTATION
---------------------------------

.. versionadded:: 4.0

.. include:: include/ENV_VAR.rst

.. note::

   此功能仅在通过\ ``CMAKE_EXPERIMENTAL_INSTRUMENTATION``\ 开关启用了对插桩的实验性支持\
   时才可用。

设置此环境变量后，CTest会将每个插桩命令的完整命令行（包括参数）报告给CDash。默认情况下，CTest\
会在遇到第一个空格时截断命令行。

See also :envvar:`CTEST_USE_INSTRUMENTATION`
