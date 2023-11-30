XCODE_EMBED_<type>_CODE_SIGN_ON_COPY
------------------------------------

.. versionadded:: 3.20

布尔属性，仅由\ :generator:`Xcode`\ 生成器使用。它指定是否对使用\
:prop_tgt:`XCODE_EMBED_<type>`\ 属性嵌入的项执行代码签名。

The supported values for ``<type>`` are:

``FRAMEWORKS``

``APP_EXTENSIONS``
  .. versionadded:: 3.21

``EXTENSIONKIT_EXTENSIONS``
  .. versionadded:: 3.26

``PLUGINS``
  .. versionadded:: 3.23

If a ``XCODE_EMBED_<type>_CODE_SIGN_ON_COPY`` property is not defined on the
target, no code signing on copy will be performed for that ``<type>``.
