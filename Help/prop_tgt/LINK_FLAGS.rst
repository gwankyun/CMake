LINK_FLAGS
----------

如果此目标是共享库、模块库或可执行文件，则在链接此目标时要使用的其他标志。静态库需要使用\
:prop_tgt:`STATIC_LIBRARY_OPTIONS`\ 或\ :prop_tgt:`STATIC_LIBRARY_FLAGS`\ 属性。

The ``LINK_FLAGS`` property, managed as a string, can be used to add extra
flags to the link step of a target.  :prop_tgt:`LINK_FLAGS_<CONFIG>` will add
to the configuration ``<CONFIG>``, for example, ``DEBUG``, ``RELEASE``,
``MINSIZEREL``, ``RELWITHDEBINFO``, ...

.. note::

  This property has been superseded by :prop_tgt:`LINK_OPTIONS` property.
