unset
-----

取消变量、缓存变量或者环境变量的值。

取消普通变量或缓存项的值
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

  unset(<variable> [CACHE | PARENT_SCOPE])

从当前作用域中移除一个普通变量，使其变为未定义状态。如果指定了\ ``CACHE``，则移除的是一个\
缓存变量而非普通变量。

如果指定了\ ``PARENT_SCOPE``，则会从当前作用域的上一级作用域中移除该变量。有关更多详细信息，\
请参阅\ :command:`set`\ 命令中的相同选项。

.. include:: UNSET_NOTE.txt

取消设置环境变量
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

  unset(ENV{<variable>})

从当前可用的\ :manual:`环境变量 <cmake-env-variables(7)>`\ 中移除\ ``<variable>``。\
后续调用\ ``$ENV{<variable>}``\ 将返回空字符串。

此命令仅影响当前的CMake进程，不会影响调用CMake的进程，也不会影响整个系统环境，同样不会影响\
后续构建或测试进程的环境。

另请参阅
^^^^^^^^

* :command:`set`
