XCODE_LINK_BUILD_PHASE_MODE
---------------------------

.. versionadded:: 3.19

当使用\ :generator:`Xcode`\ 生成器时，要链接的库将在Xcode项目文件中使用\
“Link Binary With libraries”构建阶段或直接作为链接器标志指定。前者允许Xcode管理构建路径，\
这在创建Xcode存档时可能是必要的，因为它可能会使用不同的构建路径来进行常规构建。

This property controls usage of "Link Binary With Libraries" build phase for
a target that is an app bundle, executable, shared library, shared framework
or a module library.

Possible values are:

* ``NONE``
  The libraries will be linked by specifying the linker flags directly.

* ``BUILT_ONLY``
  The "Link Binary With Libraries" build phase will be used to link to another
  target under the following conditions:

  - The target to be linked to is a regular non-imported, non-interface library
    target.
  - The output directory of the target being built has not been changed from
    its default (see :prop_tgt:`RUNTIME_OUTPUT_DIRECTORY` and
    :prop_tgt:`LIBRARY_OUTPUT_DIRECTORY`).

* ``KNOWN_LOCATION``
  The "Link Binary With Libraries" build phase will be used to link to another
  target under the same conditions as with ``BUILT_ONLY`` and also:

  - Imported library targets except those of type ``UNKNOWN``.
  - Any non-target library specified directly with a path.

For all other cases, the libraries will be linked by specifying the linker
flags directly.

.. warning::
  Libraries linked using "Link Binary With Libraries" are linked after the
  ones linked through regular linker flags.  This order should be taken into
  account when different static libraries contain symbols with the same name,
  as the former ones will take precedence over the latter.

.. warning::
  If two or more directories contain libraries with identical file names and
  some libraries are linked from those directories, the library search path
  lookup will end up linking libraries from the first directory.  This is a
  known limitation of Xcode.

This property is initialized by the value of the
:variable:`CMAKE_XCODE_LINK_BUILD_PHASE_MODE` variable if it is set when a
target is created.
