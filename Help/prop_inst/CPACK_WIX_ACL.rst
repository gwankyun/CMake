CPACK_WIX_ACL
-------------

.. versionadded:: 3.1

指定WiX安装程序安装的文件或目录的访问权限。

The property can contain multiple list entries,
each of which has to match the following format.

::

  <user>[@<domain>]=<permission>[,<permission>]

``<user>`` and ``<domain>`` specify the windows user and domain for which the
``<Permission>`` element should be generated.

``<permission>`` is any of the YesNoType attributes listed here::

 https://wixtoolset.org/documentation/manual/v3/xsd/wix/permission.html

The property is currently only supported by the :cpack_gen:`CPack WIX Generator`.
