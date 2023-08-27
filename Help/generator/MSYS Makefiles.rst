MSYS Makefiles
--------------

在MSYS shell下生成与MSYS（Minimal SYStem）\ ``make``\ 一起使用的makefiles。

Use this generator in a MSYS shell prompt and using ``make`` as the build
tool.  The generated makefiles use ``/bin/sh`` as the shell to launch build
rules.  They are not compatible with a Windows command prompt.

To build under a Windows command prompt, use the
:generator:`MinGW Makefiles` generator.
