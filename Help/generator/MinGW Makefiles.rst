MinGW Makefiles
---------------

在Windows命令提示符下生成与\ ``mingw32-make``\ 一起使用的makefiles。

Use this generator under a Windows command prompt with
MinGW (Minimalist GNU for Windows) in the ``PATH``
and using ``mingw32-make`` as the build tool.  The generated makefiles use
``cmd.exe`` as the shell to launch build rules.  They are not compatible with
MSYS or a unix shell.

To build under the MSYS shell, use the :generator:`MSYS Makefiles` generator.
