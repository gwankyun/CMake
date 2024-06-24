CMAKE_CXX_MODULE_STD
--------------------

.. versionadded:: 3.30

是否将实用程序目标作为依赖项添加到\ ``cxx_std_23``\ 以上的目标。

.. note ::

   This setting is meaningful only when experimental support for ``import
   std;`` has been enabled by the ``CMAKE_EXPERIMENTAL_CXX_IMPORT_STD`` gate.

This variable is used to initialize the :prop_tgt:`CXX_MODULE_STD` property on
all targets.  See that target property for additional information.
