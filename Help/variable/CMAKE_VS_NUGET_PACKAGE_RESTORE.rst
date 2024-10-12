CMAKE_VS_NUGET_PACKAGE_RESTORE
------------------------------

.. versionadded:: 3.23

当使用Visual Studio生成器时，这个缓存变量控制msbuild是否应该在构建之前自动尝试恢复NuGet包。\
NuGet包可以使用目标上的\ :prop_tgt:`VS_PACKAGE_REFERENCES`\ 属性来定义。如果没有定义\
包引用，此设置将不执行任何操作。

The command line option
:option:`--resolve-package-references <cmake--build --resolve-package-references>`
can be used alternatively to control the resolve behavior globally.
This option will take precedence over the cache variable.

Targets that use the :prop_tgt:`DOTNET_SDK` are required to run a
restore before building. Disabling this option may cause the build
to fail in such projects.

This setting is stored as a cache entry. Default value is ``ON``.

See also the :prop_tgt:`VS_PACKAGE_REFERENCES` property.
