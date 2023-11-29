VS_SOLUTION_DEPLOY
------------------

.. versionadded:: 3.18

指定目标在不针对Windows CE、Windows Phone或Windows Store应用程序时应标记为部署。

If the target platform doesn't support deployment, this property won't have
any effect.

:manual:`Generator expressions <cmake-generator-expressions(7)>` are supported.

Examples
^^^^^^^^

Always deploy target ``foo``:

.. code-block:: cmake

  add_executable(foo SHARED foo.cpp)
  set_property(TARGET foo PROPERTY VS_SOLUTION_DEPLOY ON)

Deploy target ``foo`` for all configurations except ``Release``:

.. code-block:: cmake

  add_executable(foo SHARED foo.cpp)
  set_property(TARGET foo PROPERTY VS_SOLUTION_DEPLOY "$<NOT:$<CONFIG:Release>>")
