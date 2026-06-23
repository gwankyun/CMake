unset
-----

取消变量、缓存变量或者环境变量的值。

取消设置普通变量
^^^^^^^^^^^^^^^^^^^^^

.. signature::
  unset(<variable> [PARENT_SCOPE])
  :target: normal

  从当前作用域移除普通变量，使其变为未定义状态。

  如果存在 ``PARENT_SCOPE``，则从当前作用域的上一级作用域中移除该变量。\
  详见 :command:`set` 命令中的相同选项说明。

.. include:: include/UNSET_NOTE.rst

取消设置缓存条目
^^^^^^^^^^^^^^^^^

.. signature::
  unset(CACHE{<variable>})
  :target: CACHE

  .. versionadded:: 4.2

  从缓存中移除 ``<variable>``，使其变为未定义状态。

.. signature::
  unset(<variable> CACHE)
  :target: CACHE_legacy

  此签名仅为兼容性目的而保留。建议优先使用另一种签名。

取消设置环境变量
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
