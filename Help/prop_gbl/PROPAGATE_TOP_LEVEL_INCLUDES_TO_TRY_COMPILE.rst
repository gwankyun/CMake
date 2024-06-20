PROPAGATE_TOP_LEVEL_INCLUDES_TO_TRY_COMPILE
-------------------------------------------

.. versionadded:: 3.30

当这个全局属性设置为true时，\ :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES`\ 变量会被\
传播到\ :command:`try_compile`\ 调用中，并使用\
:ref:`整个项目的签名 <Try Compiling Whole Projects>`。对\
:ref:`源文件签名 <Try Compiling Source Files>`\ 的调用不受此属性的影响。默认情况下未设置\
``PROPAGATE_TOP_LEVEL_INCLUDES_TO_TRY_COMPILE``。

For :ref:`dependency providers <dependency_providers_overview>` that want to
be enabled in whole-project :command:`try_compile` calls, set this global
property to true just before or after registering the provider.
Note that all files listed in :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES`
will need to be able to handle being included in such :command:`try_compile`
calls, and it is the user's responsibility to ensure this.
