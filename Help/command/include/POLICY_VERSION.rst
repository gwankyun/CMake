这指定了当前的CMake代码是为给定范围的CMake版本编写的，即\ ``<min>[...<policy_max>]``。它会将\
“策略版本”设置为：

* 如果指定了范围，则设置为该范围的\ ``<policy_max>``\ 版本，否则
* 设置为 ``<min>``\ 版本，或者
* 如果\ :variable:`CMAKE_POLICY_VERSION_MINIMUM`\ 变量的值高于前两个版本，则设置为该变量的值。

策略版本实际上是请求采用指定CMake版本所偏好的行为，并告知较新的CMake版本针对其新策略发出警告。\
运行中的CMake版本已知且在该策略版本或更早版本中引入的所有策略都将设置为使用\ ``NEW``\ 行为。\
所有在后续版本中引入的策略将保持未设置状态（除非\ :variable:`CMAKE_POLICY_DEFAULT_CMP<NNNN>`\
变量设置了默认值）。\
这实际上是请求采用指定CMake版本所偏好的行为，并告知较新的CMake版本针对其新策略发出警告。
This effectively requests behavior preferred as of a given CMake
version and tells newer CMake versions to warn about their new policies.
.. note::

  ``...<policy_max>`` does *not* signify that later CMake versions are
  forbidden.  It merely specifies the highest CMake version for which
  the project or module has been actively updated and maintained.
