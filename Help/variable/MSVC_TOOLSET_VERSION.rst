MSVC_TOOLSET_VERSION
--------------------

.. versionadded:: 3.12

如果使用了Microsoft Visual C/C++的工具集版本的话。如果正在使用MSVC类编译器，则该变量是根据\
:variable:`MSVC_VERSION`\ 变量给出的编译器版本设置的。

Known toolset version numbers are::

  80        = VS 2005 (8.0)
  90        = VS 2008 (9.0)
  100       = VS 2010 (10.0)
  110       = VS 2012 (11.0)
  120       = VS 2013 (12.0)
  140       = VS 2015 (14.0)
  141       = VS 2017 (15.0)
  142       = VS 2019 (16.0)
  143       = VS 2022 (17.0)

Compiler versions newer than those known to CMake will be reported
as the latest known toolset version.

See also the :variable:`MSVC_VERSION` variable.
