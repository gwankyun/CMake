CMAKE_XCODE_SCHEME_ENVIRONMENT
------------------------------

.. versionadded:: 3.17

指定应该添加到生成的Xcode方案的Arguments部分的环境变量。

If set to a list of environment variables and values of the form
``MYVAR=value`` those environment variables will be added to the
scheme.

This variable initializes the :prop_tgt:`XCODE_SCHEME_ENVIRONMENT`
property on all targets.

.. include:: ../include/XCODE_SCHEME_NOTE.rst
