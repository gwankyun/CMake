CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS
-------------------------------------------

.. versionadded:: 3.11

在安装文件期间通过\ :command:`install`\ 和\ :command:`file(INSTALL)`\ 隐式创建的目录\
的默认权限。

If ``make install`` is invoked and directories are implicitly created they
get permissions set by ``CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS``
variable or platform specific default permissions if the variable is not set.

Implicitly created directories are created if they are not explicitly installed
by :command:`install` command but are needed to install a file on a certain
path. Example of such locations are directories created due to the setting of
:variable:`CMAKE_INSTALL_PREFIX`.

Expected content of the ``CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS``
variable is a list of permissions that can be used by :command:`install` command
`PERMISSIONS` section.

Example usage:

::

 set(CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS
      OWNER_READ
      OWNER_WRITE
      OWNER_EXECUTE
      GROUP_READ
    )
