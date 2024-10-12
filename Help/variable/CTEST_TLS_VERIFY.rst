CTEST_TLS_VERIFY
----------------

.. versionadded:: 3.30

在包含\ :module:`CTest`\ 模块之前，在\ :manual:`ctest(1)` :ref:`Dashboard Client`\
脚本或\ ``CMakeLists.txt``\ 项目代码中指定CTest ``TLSVerify``\ 设置。这是个布尔值，\
表示通过\ ``https://`` URL提交给仪表板时是否验证服务器证书。

If ``CTEST_TLS_VERIFY`` is not set, the :variable:`CMAKE_TLS_VERIFY` variable
or :envvar:`CMAKE_TLS_VERIFY` environment variable is used instead.
If neither is set, the default is *on*.

.. versionchanged:: 3.31
  The default is on.  Previously, the default was off.
  Users may set the :envvar:`CMAKE_TLS_VERIFY` environment
  variable to ``0`` to restore the old default.
