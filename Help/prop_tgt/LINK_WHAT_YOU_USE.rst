LINK_WHAT_YOU_USE
-----------------

.. versionadded:: 3.7

这是一个布尔选项，当设置为\ ``TRUE``\ 时，将在链接目标后自动运行变量\
:variable:`CMAKE_LINK_WHAT_YOU_USE_CHECK`\ 的内容。此外，变量\
:variable:`CMAKE_<LANG>_LINK_WHAT_YOU_USE_FLAG`\ 指定的链接器标志将通过链接命令传递\
给目标，这样命令行上指定的所有库都将被链接到目标中。这将导致链接生成一个库列表，这些库不提供\
此目标使用的符号，但正在被链接到它。

.. note::

  For now, it is only supported for ``ELF`` platforms and is only applicable to
  executable and shared or module library targets. This property will be
  ignored for any other targets and configurations.

This property is initialized by the value of
the :variable:`CMAKE_LINK_WHAT_YOU_USE` variable if it is set
when a target is created.
