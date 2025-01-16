mark_as_advanced
----------------

将cmake缓存变量标记为高级。

.. code-block:: cmake

  mark_as_advanced([CLEAR|FORCE] <var1> ...)

设置已命名缓存变量的高级/非高级状态。

除非\ ``show advanced``\ 选项开启，否则在任何cmake GUI中都不会显示advanced变量。在脚本\
模式下，“高级/非高级”状态无效。

如果给出了\ ``CLEAR``\ 关键字，则高级变量会变回非高级。如果给出了关键字\ ``FORCE``，则变量\
将设为高级。如果既没有指定\ ``FORCE``\ 也没有指定\ ``CLEAR``，则新值将标记为高级，但如果\
变量已经具有高级/非高级状态，则不会更改它。

.. versionchanged:: 3.17
  传递给此命令的变量如果不在缓存中则会被忽略。参见策略\ :policy:`CMP0102`。
