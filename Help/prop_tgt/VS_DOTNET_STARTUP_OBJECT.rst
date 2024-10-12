VS_DOTNET_STARTUP_OBJECT
------------------------

.. versionadded:: 3.24

设置Visual Studio .NET目标中的启动对象属性。属性值定义了一个完整的限定类名（包括包名），\
例如：\ ``MyCompany.Package.MyStarterClass``。

If the property is unset, Visual Studio uses the first matching
``static void Main(string[])`` function signature by default. When more
than one ``Main()`` method is available in the current project, the property
becomes mandatory for building the project.

This property only works for :ref:`Visual Studio Generators`;
it is ignored on other generators.

.. code-block:: cmake

  set_property(TARGET ${TARGET_NAME} PROPERTY
    VS_DOTNET_STARTUP_OBJECT "MyCompany.Package.MyStarterClass")
