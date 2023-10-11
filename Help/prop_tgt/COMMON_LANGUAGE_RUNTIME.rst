COMMON_LANGUAGE_RUNTIME
-----------------------

.. versionadded:: 3.12

通过设置该目标属性，可以将目标配置为使用\ ``C++/CLI``\ 支持进行构建。

The Visual Studio generator defines the ``clr`` parameter depending on
the value of the ``COMMON_LANGUAGE_RUNTIME`` target property:

Not Set (default)

  Native C++.

``""`` (set but empty)

  Mixed unmanaged/managed C++ using .NET Framework.

``netcore``
  .. versionadded:: 3.26

  Mixed unmanaged/managed C++ using .NET Core.

  This required VS 2019's v142 toolset or higher.

``pure``

  Managed C++.

``safe``

  Managed C++.

This property is only evaluated :ref:`Visual Studio Generators` for
VS 2010 and above.

To be able to build managed C++ targets with VS 2017 and above the component
``C++/CLI support`` must be installed, which may not be done by default.

See also :prop_tgt:`IMPORTED_COMMON_LANGUAGE_RUNTIME`
