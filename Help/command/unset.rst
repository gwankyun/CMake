unset
-----

取消变量、缓存变量或者环境变量的值。

Unset Normal Variable
^^^^^^^^^^^^^^^^^^^^^

.. signature::
  unset(<variable> [PARENT_SCOPE])
  :target: normal

  Removes a normal variable from the current scope, causing it
  to become undefined.

  If ``PARENT_SCOPE`` is present then the variable is removed from the scope
  above the current scope.  See the same option in the :command:`set` command
  for further details.

.. include:: include/UNSET_NOTE.rst

Unset Cache Entry
^^^^^^^^^^^^^^^^^

.. signature::
  unset(CACHE{<variable>})
  :target: CACHE

  .. versionadded:: 4.2

  Removes ``<variable>`` from the cache, causing it to become undefined.

.. signature::
  unset(<variable> CACHE)
  :target: CACHE_legacy

  This signature is supported for compatibility purpose. Use preferably the
  other one.

Unset Environment Variable
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. signature::
  unset(ENV{<variable>})
  :target: ENV

  从当前可用的\ :manual:`环境变量 <cmake-env-variables(7)>`\ 中移除\ ``<variable>``。\
  后续调用\ ``$ENV{<variable>}``\ 将返回空字符串。

  此命令仅影响当前的CMake进程，不会影响调用CMake的进程，也不会影响整个系统环境，同样不会影响\
  后续构建或测试进程的环境。

另请参阅
^^^^^^^^

* :command:`set`
