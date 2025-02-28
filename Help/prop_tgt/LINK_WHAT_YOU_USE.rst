LINK_WHAT_YOU_USE
-----------------

.. versionadded:: 3.7

这是一个布尔选项，当设置为\ ``TRUE``\ 时，会添加一个链接时检查，用于打印出那些被链接但未为\
目标提供任何符号的共享库列表。此功能旨在进行代码检查。

The flag specified by :variable:`CMAKE_<LANG>_LINK_WHAT_YOU_USE_FLAG` will
be passed to the linker so that all libraries specified on the command line
will be linked into the target.  Then the command specified by
:variable:`CMAKE_LINK_WHAT_YOU_USE_CHECK` will run after the target is linked
to check the binary for unnecessarily-linked shared libraries.

.. note::

  For now, it is only supported for ``ELF`` platforms and is only applicable to
  executable and shared or module library targets. This property will be
  ignored for any other targets and configurations.

This property is initialized by the value of
the :variable:`CMAKE_LINK_WHAT_YOU_USE` variable if it is set
when a target is created.
