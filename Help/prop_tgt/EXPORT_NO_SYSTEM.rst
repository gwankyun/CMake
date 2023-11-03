EXPORT_NO_SYSTEM
----------------

.. versionadded:: 3.25

此属性影响\ :command:`install(EXPORT)`\ 和\ :command:`export`\ 命令分别安装或导出目\
标时的行为。当\ ``EXPORT_NO_SYSTEM``\ 设置为true时，这些命令生成一个导入的目标，\
:prop_tgt:`SYSTEM`\ 属性设置为false。

See the :prop_tgt:`NO_SYSTEM_FROM_IMPORTED` target property to set this
behavior on the target *consuming* the include directories rather than the
one *providing* them.
