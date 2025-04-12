CMAKE_OSX_SYSROOT
-----------------

指定要使用的macOS平台SDK的位置或名称。CMake使用这个值来计算\ ``-isysroot``\ 标志或同等\
标志的值，并帮助\ ``find_*``\ 命令在SDK中定位文件。

If not set explicitly, the value is initialized by the ``SDKROOT``
environment variable, if set.  Otherwise, the value defaults to empty,
so no explicit ``-isysroot`` flag is passed, and the compiler's default
sysroot is used.

.. versionchanged:: 4.0
  The default is now empty.  Previously a default was computed based on
  the :variable:`CMAKE_OSX_DEPLOYMENT_TARGET` or the host platform.

.. note::

  Xcode's compilers, when not invoked with ``-isysroot``, search for
  headers in ``/usr/local/include`` before system SDK paths, matching the
  convention on many platforms.  Users on macOS-x86_64 hosts with Homebrew
  installed in ``/usr/local`` should pass ``-DCMAKE_OSX_SYSROOT=macosx``,
  or ``export SDKROOT=macosx``, when not building with Homebrew tools.

.. include:: CMAKE_OSX_VARIABLE.txt
