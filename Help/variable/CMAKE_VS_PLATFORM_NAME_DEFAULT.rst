CMAKE_VS_PLATFORM_NAME_DEFAULT
------------------------------

.. versionadded:: 3.14.3

当前生成器的默认Visual Studio目标平台名，不考虑\ :variable:`CMAKE_GENERATOR_PLATFORM`\
变量的值。对于VS 2017及以下版本的\ :ref:`Visual Studio Generators` ，这始终是\
``Win32``。对于VS 2019及以上版本，则基于主机平台。

See also the :variable:`CMAKE_VS_PLATFORM_NAME` variable.
