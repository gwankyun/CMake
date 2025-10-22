ENVIRONMENT_MODIFICATION
------------------------

.. versionadded:: 3.22

指定运行测试时应该修改的环境变量。注意，这个属性执行的操作是在已经应用了\
:prop_test:`ENVIRONMENT`\ 属性之后执行的。

Set to a :ref:`semicolon-separated list <CMake Language Lists>` of
environment variables and values of the form ``MYVAR=OP:VALUE``,
where ``MYVAR`` is the case-sensitive name of an environment variable
to be modified.  Entries are considered in the order specified in the
property's value.  The ``OP`` may be one of:

 .. include:: ../include/ENVIRONMENT_MODIFICATION_OPS.rst

Unrecognized ``OP`` values will result in the test failing before it is
executed. This is so that future operations may be added without changing
valid behavior of existing tests.

The environment changes from this property do not affect other tests.
