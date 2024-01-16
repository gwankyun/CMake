CMAKE_AUTOMOC_MACRO_NAMES
----------------------------

.. versionadded:: 3.10

:variable:`CMAKE_AUTOMOC`\ 使用的宏名称\ :ref:`分号分隔列表 <CMake Language Lists>`，\
以确定是否需要由\ ``moc``\ 处理一个C++文件。

This variable is used to initialize the :prop_tgt:`AUTOMOC_MACRO_NAMES`
property on all the targets. See that target property for additional
information.

The default value is ``Q_OBJECT;Q_GADGET;Q_NAMESPACE;Q_NAMESPACE_EXPORT``.

Example
^^^^^^^
Let CMake know that source files that contain ``CUSTOM_MACRO`` must be ``moc``
processed as well::

  set(CMAKE_AUTOMOC ON)
  list(APPEND CMAKE_AUTOMOC_MACRO_NAMES "CUSTOM_MACRO")
