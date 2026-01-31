set
---

将一个普通变量、缓存变量或环境变量设置为给定值。请参考\
:ref:`cmake-language(7)变量 <CMake Language Variables>`，了解普通变量和缓存\
项的作用域和交互。

此命令的签名中若指定了\ ``<value>...``\ 占位符，则表示该命令可接受零个或多个参数。\
多个参数将被合并为一个\ :ref:`以分号分隔的列表 <CMake Language Lists>`，以此构成\
要设置的实际变量值。

设置普通变量
^^^^^^^^^^^^^^^^^^^

.. signature::
  set(<variable> <value>... [PARENT_SCOPE])
  :target: normal

  在当前函数或目录作用域中设置或取消设置\ ``<variable>``：

  * 如果至少提供一个\ ``<value>...``\ 参数，则将该变量设置为这些值。
  * 如果未提供任何值，则取消设置该变量。这等效于\ :command:`unset(<variable>) <unset>`。

  如果指定了\ ``PARENT_SCOPE``\ 选项，变量将在当前作用域的上一级作用域中设置。\
  每个新目录或\ :command:`function`\ 命令都会创建一个新的作用域。\
  也可以使用\ :command:`block`\ 命令创建一个作用域。\
  ``set(PARENT_SCOPE)``\ 会将变量的值设置到父目录、调用函数或包含当前作用域的\
  上一级作用域中（具体取决于实际情况）。\
  变量的值在当前作用域中的先前状态保持不变（例如，如果之前未定义，现在仍然未定义；\
  如果之前有值，现在仍然是该值）。

  :command:`block(PROPAGATE)`\ 和\ :command:`return(PROPAGATE)`\ 命令可作为\
  :command:`set(PARENT_SCOPE)`\ 和\ :command:`unset(PARENT_SCOPE)`\ 命令的替代方法，\
  用于更新父作用域。

.. include:: include/UNSET_NOTE.rst

设置缓存条目
^^^^^^^^^^^^^^^

.. signature::
  set(CACHE{<variable>} [TYPE <type>] [HELP <helpstring>...] [FORCE]
                        VALUE [<value>...])
  :target: CACHE

  .. versionadded:: 4.2

  设置给定的缓存\ ``<variable>``\ （缓存条目）。选项包括：

  ``TYPE <type>``
    指定缓存条目的类型。\ ``<type>``\ 必须是以下类型之一：

    ``BOOL``
      布尔类型的\ ``ON/OFF``\ 值。\
      :manual:`cmake-gui(1)`\ 提供一个复选框。

    ``FILEPATH``
      磁盘上文件的路径。\
      :manual:`cmake-gui(1)`\ 提供一个文件选择对话框。

    ``PATH``
      磁盘上某个目录的路径。\
      :manual:`cmake-gui(1)`\ 提供一个文件选择对话框。

    ``STRING``
      一行文本。\
      如果设置了\ :prop_cache:`STRINGS`\ 缓存项属性，\ :manual:`cmake-gui(1)`\
      将提供一个文本框或下拉选择框。

    ``INTERNAL``
      一行文本。\
      :manual:`cmake-gui(1)`\ 不会显示内部条目。\
      它们可用于在多次运行之间持久存储变量。\
      使用此类型意味着隐含\ ``FORCE``\ 选项。

    如果未指定\ ``TYPE``，且缓存变量已存在且其类型不是\ ``UNINITIALIZED``，则将\
    保留之前指定的类型；否则，将使用\ ``STRING``\ 类型。

  ``HELP <helpstring>...``
    ``<helpstring>``\ 必须指定为一行文本，用于为\ :manual:`cmake-gui(1)`\ 用户\
    提供该选项的快速摘要。如果提供了多个字符串，它们将被连接成一个没有分隔符的\
    字符串。

    如果未指定\ ``HELP``，将使用空字符串。

  ``FORCE``
    由于缓存条目旨在提供用户可设置的值，因此默认情况下不会覆盖现有缓存条目。使用\
    ``FORCE``\ 选项可以覆盖现有条目。

  ``VALUE <value>...``
    要设置给缓存\ ``<variable>``\ 的值列表。此参数必须始终是最后一个。

  如果调用前缓存条目不存在，或者提供了\ ``FORCE``\ 选项，则缓存条目将被设置为给定值。

  .. note::

    如果同名的普通变量已经存在，缓存变量的内容将无法直接访问（请参阅\
    :ref:`变量计算规则 <CMake Language Variables>`）。\
    如果策略\ :policy:`CMP0126`\ 设置为\ ``OLD``，当前作用域内的任何普通变量绑定\
    都将被移除。

  在调用此命令之前，缓存条目就可能已经存在，但如果用户是通过\ :manual:`cmake(1)`\
  命令行，使用\ :option:`-D\<var\>=\<value\> <cmake -D>`\ 选项创建该条目且未指定类型，\
  那么该缓存条目将不会设置类型。\
  在这种情况下，\ ``set``\ 命令会添加类型。\
  此外，如果\ ``<type>``\ 为\ ``PATH``\ 或\ ``FILEPATH``，并且命令行中提供的\
  ``<value>``\ 是相对路径，那么\ ``set``\ 命令会将该路径视为相对于当前工作目录的\
  路径，并将其转换为绝对路径。

.. signature::
  set(<variable> <value>... CACHE <type> <docstring> [FORCE])
  :target: CACHE_legacy

  支持此签名是为了兼容性目的。优先使用另一个。

设置环境变量
^^^^^^^^^^^^^^^^^^^^^^^^

.. signature::
  set(ENV{<variable>} [<value>])
  :target: ENV

  将一个\ :manual:`环境变量 <cmake-env-variables(7)>`\ 设置为给定的值。\
  后续调用\ ``$ENV{<variable>}``\ 时将返回这个新值。

  此命令仅影响当前的CMake进程，不会影响调用CMake的进程，也不会影响整个系统环境，\
  同样不会影响后续构建或测试进程的环境。

  如果在\ ``ENV{<variable>}``\ 之后未提供任何参数，或者\ ``<value>``\ 为空字符串，\
  那么此命令将清除环境变量的任何现有值。

  ``<value>``\ 之后的参数将被忽略。如果发现额外的参数，将会发出作者警告。

另请参阅
^^^^^^^^

* :command:`unset`
