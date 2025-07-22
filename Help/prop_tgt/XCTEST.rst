XCTEST
------

.. versionadded:: 3.3

布尔类型的目标属性，用于指示某个目标在苹果系统上是否为XCTest CFBundle\
（核心基础捆绑包）。

This property is usually set automatically by the :command:`xctest_add_bundle`
command provided by the :module:`FindXCTest` module.

If a module library target has this property set to boolean true, it will be
built as a CFBundle when built on Apple system, with the required CFBundle
directory structure.

This property depends on :prop_tgt:`BUNDLE` target property to be effective.
