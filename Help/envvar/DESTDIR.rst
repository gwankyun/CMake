DESTDIR
-------

.. include:: ENV_VAR.txt

在UNIX上，可以使用\ ``DESTDIR``\ 机制来重新定位整个安装。\ ``DESTDIR``\ 表示目的目录。\
它通常被打包者用来在暂存目录中安装软件。

For example, running

.. code-block:: shell

  make DESTDIR=/package/stage install

will install the software using the installation prefix, e.g. ``/usr/local``,
prepended with the ``DESTDIR`` value which gives ``/package/stage/usr/local``.
The packaging tool may then construct the package from the content of the
``/package/stage`` directory.

See the :variable:`CMAKE_INSTALL_PREFIX` variable to control the
installation prefix when configuring a build tree.  Or, when using
the :manual:`cmake(1)` command-line tool's :option:`--install <cmake --install>`
mode, one may specify a different prefix using the
:option:`--prefix <cmake--install --prefix>` option.

.. note::

  ``DESTDIR`` may not be used on Windows because installation
  prefix usually contains a drive letter like in ``C:/Program Files``
  which cannot be prepended with some other prefix.
