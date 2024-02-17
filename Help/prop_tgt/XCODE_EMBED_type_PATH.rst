XCODE_EMBED_<type>_PATH
-----------------------

.. versionadded:: 3.20

这个属性只被\ :generator:`Xcode`\ 生成器使用。定义后，它指定了当嵌入由\
:prop_tgt:`XCODE_EMBED_<type>`\ 指定的项时要使用的相对路径。该路径相对于与\ ``<type>``\
相关联的\ ``Embed XXX``\ 构建阶段的基本位置。请参阅Xcode文档了解每个\ ``<type>``\ 的基\
本位置。

The supported values for ``<type>`` are:

``FRAMEWORKS``

``APP_EXTENSIONS``
  .. versionadded:: 3.21

``EXTENSIONKIT_EXTENSIONS``
  .. versionadded:: 3.26

``PLUGINS``
  .. versionadded:: 3.23

``RESOURCES``
  .. versionadded:: 3.28

``XPC_SERVICES``
  .. versionadded:: 3.29
