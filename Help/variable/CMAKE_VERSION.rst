CMAKE_VERSION
-------------

CMake版本字符串作为三个非负整数组成部分，由\ ``.``\ 分隔。可能还会有\ ``-``\ 和其他信息。\
前两个组件表示特性级别，第三个组件表示bug修复级别或开发日期。

Release versions and release candidate versions of CMake use the format::

  <major>.<minor>.<patch>[-rc<n>]

where the ``<patch>`` component is less than ``20000000``.  Development
versions of CMake use the format::

  <major>.<minor>.<date>[-<id>]

where the ``<date>`` component is of format ``CCYYMMDD`` and ``<id>``
may contain arbitrary text.  This represents development as of a
particular date following the ``<major>.<minor>`` feature release.

Individual component values are also available in variables:

* :variable:`CMAKE_MAJOR_VERSION`
* :variable:`CMAKE_MINOR_VERSION`
* :variable:`CMAKE_PATCH_VERSION`
* :variable:`CMAKE_TWEAK_VERSION`

Use the :command:`if` command ``VERSION_LESS``, ``VERSION_GREATER``,
``VERSION_EQUAL``, ``VERSION_LESS_EQUAL``, or ``VERSION_GREATER_EQUAL``
operators to compare version string values against ``CMAKE_VERSION`` using a
component-wise test.  Version component values may be 10 or larger so do not
attempt to compare version strings as floating-point numbers.

.. note::

  CMake versions 2.8.2 through 2.8.12 used three components for the
  feature level.  Release versions represented the bug-fix level in a
  fourth component, i.e. ``<major>.<minor>.<patch>[.<tweak>][-rc<n>]``.
  Development versions represented the development date in the fourth
  component, i.e. ``<major>.<minor>.<patch>.<date>[-<id>]``.

  CMake versions prior to 2.8.2 used three components for the
  feature level and had no bug-fix component.  Release versions
  used an even-valued second component, i.e.
  ``<major>.<even-minor>.<patch>[-rc<n>]``.  Development versions
  used an odd-valued second component with the development date as
  the third component, i.e. ``<major>.<odd-minor>.<date>``.

  The ``CMAKE_VERSION`` variable is defined by CMake 2.6.3 and higher.
  Earlier versions defined only the individual component variables.
