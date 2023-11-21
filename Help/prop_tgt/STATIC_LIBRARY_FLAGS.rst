STATIC_LIBRARY_FLAGS
--------------------

静态库目标的归档器（或MSVC库管理）标志。共享库、模块或可执行文件的目标需要使用\
:prop_tgt:`LINK_OPTIONS`\ 或\ :prop_tgt:`LINK_FLAGS`\ 目标属性。

The ``STATIC_LIBRARY_FLAGS`` property, managed as a string, can be used to add
extra flags to the link step of a static library target.
:prop_tgt:`STATIC_LIBRARY_FLAGS_<CONFIG>` will add to the configuration
``<CONFIG>``, for example, ``DEBUG``, ``RELEASE``, ``MINSIZEREL``,
``RELWITHDEBINFO``, ...

.. note::

  This property has been superseded by :prop_tgt:`STATIC_LIBRARY_OPTIONS`
  property.
