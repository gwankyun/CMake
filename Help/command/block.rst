block
-----

.. versionadded:: 3.25

使用专用变量和/或范围策略计算一组命令。

.. code-block:: cmake

  block([SCOPE_FOR [DIAGNOSTICS] [POLICIES] [VARIABLES]]
        [PROPAGATE <var-name>...])
    <commands>
  endblock()

在\ ``block()``\ 和与之匹配的\ :command:`endblock`\ 之间的所有命令都会被记录下来，但不会\
被立即执行。当\ :command:`endblock`\ 被求值时，记录的命令列表会在请求的作用域内被执行，\
然后由\ ``block()``\ 命令创建的作用域会被移除。

``SCOPE_FOR``
  指定必须创建哪些作用域。

  ``DIAGNOSTICS``
    .. versionadded:: 4.4

    创建一个新的诊断作用域。这等同于带有自动 :command:`cmake_diagnostic(POP)`
    的 :command:`cmake_diagnostic(PUSH)`，在离开块作用域时自动弹出。

  ``POLICIES``
    创建一个新的策略作用域。这等同于\ :command:`cmake_policy(PUSH)`，并在离开块作用域时\
    自动执行\ :command:`cmake_policy(POP)`。

  ``VARIABLES``
    创建一个新的变量作用域。

  如果未指定\ ``SCOPE_FOR``，则等同于：

  .. code-block:: cmake

    block(SCOPE_FOR VARIABLES POLICIES DIAGNOSTICS)

``PROPAGATE``
  当\ :command:`block`\ 命令创建了一个变量作用域时，此选项会在父作用域中设置或取消设置指定的\
  变量。这等同于\ :command:`set(PARENT_SCOPE)`\ 或\ :command:`unset(PARENT_SCOPE)`\ 命令。

  .. code-block:: cmake

    set(var1 "INIT1")
    set(var2 "INIT2")
    set(var3 "INIT3")

    block(PROPAGATE var1 var2)
      set(var1 "VALUE1")
      unset(var2)
      set(var3 "VALUE3")
    endblock()

    # 现在var1的值为VALUE1，var2被取消设置, 并且var3保持初始值INIT3

  此选项仅在创建变量作用域时允许使用。在其他情况下会引发错误。

当\ ``block()``\ 位于\ :command:`foreach`\ 或\ :command:`while`\ 命令内部时，\
:command:`break`\ 和\ :command:`continue`\ 命令可在块内部使用。

.. code-block:: cmake

  while(TRUE)
    block()
       ...
       # break()命令将终止while()命令
       break()
    endblock()
  endwhile()


另请参阅
^^^^^^^^

* :command:`endblock`
* :command:`return`
* :command:`cmake_policy`
