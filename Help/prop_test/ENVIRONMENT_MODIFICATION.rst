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

  - ``reset``: Reset to the unmodified value, ignoring all modifications to
    ``MYVAR`` prior to this entry. Note that this will reset the variable to
    the value set by :prop_test:`ENVIRONMENT`, if it was set, and otherwise
    to its state from the rest of the CTest execution.
  - ``set``: Replaces the current value of ``MYVAR`` with ``VALUE``.
  - ``unset``: Unsets the current value of ``MYVAR``.
  - ``string_append``: Appends singular ``VALUE`` to the current value of
    ``MYVAR``.
  - ``string_prepend``: Prepends singular ``VALUE`` to the current value of
    ``MYVAR``.
  - ``path_list_append``: Appends singular ``VALUE`` to the current value of
    ``MYVAR`` using the host platform's path list separator (``;`` on Windows
    and ``:`` elsewhere).
  - ``path_list_prepend``: Prepends singular ``VALUE`` to the current value of
    ``MYVAR`` using the host platform's path list separator (``;`` on Windows
    and ``:`` elsewhere).
  - ``cmake_list_append``: Appends singular ``VALUE`` to the current value of
    ``MYVAR`` using ``;`` as the separator.
  - ``cmake_list_prepend``: Prepends singular ``VALUE`` to the current value of
    ``MYVAR`` using ``;`` as the separator.

Unrecognized ``OP`` values will result in the test failing before it is
executed. This is so that future operations may be added without changing
valid behavior of existing tests.

The environment changes from this property do not affect other tests.
