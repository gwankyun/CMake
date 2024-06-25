CTEST_TLS_VERSION
-----------------

.. versionadded:: 3.30

在包含\ :module:`CTest`\ 模块之前，在\ :manual:`ctest(1)` :ref:`Dashboard Client`\
脚本或\ ``CMakeLists.txt``\ 项目代码中指定CTest ``TLSVersion``\ 设置。该值是通过\
``https://`` URL提交到仪表板时允许的最小TLS版本。

The value may be one of:

.. include:: CMAKE_TLS_VERSION-VALUES.txt

If ``CTEST_TLS_VERSION`` is not set, the :variable:`CMAKE_TLS_VERSION` variable
or :envvar:`CMAKE_TLS_VERSION` environment variable is used instead.
