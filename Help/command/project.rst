project
-------

设置项目名。

概要
^^^^^^^^

.. code-block:: cmake

 project(<PROJECT-NAME> [<language-name>...])
 project(<PROJECT-NAME>
         [VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
         [COMPAT_VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
         [DESCRIPTION <project-description-string>]
         [HOMEPAGE_URL <url-string>]
         [LANGUAGES <language-name>...])

设置项目的名称，并将其存储在变量\ :variable:`PROJECT_NAME`\ 中。当从顶层\
``CMakeLists.txt``\ 调用时，还会将项目名称存储在变量\ :variable:`CMAKE_PROJECT_NAME`\ 中。

同时设置变量：

:variable:`PROJECT_SOURCE_DIR`、\ :variable:`<PROJECT-NAME>_SOURCE_DIR`\
  项目源目录的绝对路径。

:variable:`PROJECT_BINARY_DIR`、\ :variable:`<PROJECT-NAME>_BINARY_DIR`\
  项目二进制目录的绝对路径。

:variable:`PROJECT_IS_TOP_LEVEL`、\ :variable:`<PROJECT-NAME>_IS_TOP_LEVEL`\
  .. versionadded:: 3.21

  布尔值，指示项目是否为顶层项目。

更多变量由下文\ `选项`_\ 部分中描述的可选参数设置。如果未提供某个选项，\
其对应的变量将被设置为空字符串。

请注意，形式为\ ``<name>_SOURCE_DIR``\ 和\ ``<name>_BINARY_DIR``\ 的变量也可能在调用\
``project()``\ 之前由其他命令设置（例如，参见\ :command:`FetchContent_MakeAvailable`\
命令）。\
项目不应依赖于\ ``<PROJECT-NAME>_SOURCE_DIR``\ 或\ ``<PROJECT-NAME>_BINARY_DIR``\
在调用\ ``project()``\ 的作用域或其任何子作用域之外持有特定值。

.. versionchanged:: 3.30
  如果在调用\ ``project(<PROJECT-NAME> ...)``\ 时，\ ``<PROJECT-NAME>_SOURCE_DIR``、\
  ``<PROJECT-NAME>_BINARY_DIR``\ 和\ ``<PROJECT-NAME>_IS_TOP_LEVEL``\ 已作为普通\
  变量设置，则它们会被该调用更新。\
  同名的缓存条目始终按以前的方式设置。有关详细信息，请参见3.30.3、3.30.4和3.30.5\
  版本的发行说明。

.. versionchanged:: 3.31
  ``<PROJECT-NAME>_SOURCE_DIR``、\ ``<PROJECT-NAME>_BINARY_DIR``\ 和\
  ``<PROJECT-NAME>_IS_TOP_LEVEL``\ 始终会被\ ``project(<PROJECT-NAME> ...)``\
  设置为普通变量。参见策略\ :policy:`CMP0180`。\
  具有相同名称的缓存条目始终按之前的方式设置。

选项
^^^^^^^

选项包括：

``VERSION <version>``
  可选；仅当策略\ :policy:`CMP0048`\ 设置为\ ``NEW``\ 时方可使用。

  接受由非负整数组件组成的 ``<version>`` 参数，即\ ``<major>[.<minor>[.<patch>[.<tweak>]]]``，\
  并设置变量

  * :variable:`PROJECT_VERSION`,
    :variable:`<PROJECT-NAME>_VERSION`
  * :variable:`PROJECT_VERSION_MAJOR`,
    :variable:`<PROJECT-NAME>_VERSION_MAJOR`
  * :variable:`PROJECT_VERSION_MINOR`,
    :variable:`<PROJECT-NAME>_VERSION_MINOR`
  * :variable:`PROJECT_VERSION_PATCH`,
    :variable:`<PROJECT-NAME>_VERSION_PATCH`
  * :variable:`PROJECT_VERSION_TWEAK`,
    :variable:`<PROJECT-NAME>_VERSION_TWEAK`.

  .. versionadded:: 3.12
    当从顶层\ ``CMakeLists.txt``\ 调用\ ``project()``\ 命令时，版本号也会存储在变量\
    :variable:`CMAKE_PROJECT_VERSION`\ 中。

``COMPAT_VERSION <version>``
  .. versionadded:: 4.1
  .. note::

    实验性功能。由\ ``CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_INFO``\ 开关控制。

  可选；要求同时设置\ ``VERSION``。

  接受一个由非负整数组件组成的\ ``<version>``\ 参数， 即\
  ``<major>[.<minor>[.<patch>[.<tweak>]]]``\ ， 并设置以下变量

  * :variable:`PROJECT_COMPAT_VERSION`,
    :variable:`<PROJECT-NAME>_COMPAT_VERSION`

    当从顶层\ ``CMakeLists.txt``\ 调用\ ``project()``\ 命令时，兼容性版本还会存储\
    在变量\ :variable:`CMAKE_PROJECT_COMPAT_VERSION`\ 中。

``DESCRIPTION <project-description-string>``
  .. versionadded:: 3.9

  可选。
  设置变量

  * :variable:`PROJECT_DESCRIPTION`, :variable:`<PROJECT-NAME>_DESCRIPTION`

  为\ ``<project-description-string>``。\
  建议这个描述是一个相对较短的字符串，\
  通常不超过几个词。

  当从顶层\ ``CMakeLists.txt``\ 调用\ ``project()``\ 命令时， 描述也会存储在变量\
  :variable:`CMAKE_PROJECT_DESCRIPTION`\ 中。

  .. versionadded:: 3.12
    添加了\ ``<PROJECT-NAME>_DESCRIPTION``\ 变量。

``HOMEPAGE_URL <url-string>``
  .. versionadded:: 3.12

  可选。 
  设置变量

  * :variable:`PROJECT_HOMEPAGE_URL`, :variable:`<PROJECT-NAME>_HOMEPAGE_URL`

  为\ ``<url-string>``，该URL字符串应为项目的规范主页URL。

  当从顶层\ ``CMakeLists.txt``\ 调用\ ``project()``\ 命令时，此URL还会存储在变量\
  :variable:`CMAKE_PROJECT_HOMEPAGE_URL`\ 中。

``LANGUAGES <language-name>...``
  可选。
  也可以不使用\ ``LANGUAGES``\ 关键字，按照第一种简短语法指定。

  选择构建项目所需的编程语言。

.. include:: include/SUPPORTED_LANGUAGES.rst

By default ``C`` and ``CXX`` are enabled if no language options are given.
Specify language ``NONE``, or use the ``LANGUAGES`` keyword and list no languages,
to skip enabling any languages.

The variables set through the ``VERSION``, ``COMPAT_VERSION``, ``DESCRIPTION``
and ``HOMEPAGE_URL`` options are intended for use as default values in package
metadata and documentation. The :command:`export` and :command:`install`
commands use these accordingly when generating |CPS| package descriptions.

.. |CPS| replace:: Common Package Specification

.. _`Code Injection`:

Code Injection
^^^^^^^^^^^^^^

A number of variables can be defined by the user to specify files to include
at different points during the execution of the ``project()`` command.
The following outlines the steps performed during a ``project()`` call:

* .. versionadded:: 3.15
    For every ``project()`` call regardless of the project
    name, include the file(s) and module(s) named by
    :variable:`CMAKE_PROJECT_INCLUDE_BEFORE`, if set.

* .. versionadded:: 3.17
    If the ``project()`` command specifies ``<PROJECT-NAME>`` as its project
    name, include the file(s) and module(s) named by
    :variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE_BEFORE`, if set.

* Set the various project-specific variables detailed in the `概要`_
  and `选项`_ sections above.

* For the very first ``project()`` call only:

  * If :variable:`CMAKE_TOOLCHAIN_FILE` is set, read it at least once.
    It may be read multiple times and it may also be read again when
    enabling languages later (see below).

  * Set the variables describing the host and target platforms.
    Language-specific variables might or might not be set at this point.
    On the first run, the only language-specific variables that might be
    defined are those a toolchain file may have set. On subsequent runs,
    language-specific variables cached from a previous run may be set.

  * .. versionadded:: 3.24
      Include each file listed in :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES`,
      if set. The variable is ignored by CMake thereafter.

* Enable any languages specified in the call, or the default languages if
  none were provided. The toolchain file may be re-read when enabling a
  language for the first time.

* .. versionadded:: 3.15
    For every ``project()`` call regardless of the project
    name, include the file(s) and module(s) named by
    :variable:`CMAKE_PROJECT_INCLUDE`, if set.

* If the ``project()`` command specifies ``<PROJECT-NAME>`` as its project
  name, include the file(s) and module(s) named by
  :variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE`, if set.

Usage
^^^^^

The top-level ``CMakeLists.txt`` file for a project must contain a
literal, direct call to the ``project()`` command; loading one
through the :command:`include` command is not sufficient.  If no such
call exists, CMake will issue a warning and pretend there is a
``project(Project)`` at the top to enable the default languages
(``C`` and ``CXX``).

.. note::
  Call the ``project()`` command near the top of the top-level
  ``CMakeLists.txt``, but *after* calling :command:`cmake_minimum_required`.
  It is important to establish version and policy settings before invoking
  other commands whose behavior they may affect and for this reason the
  ``project()`` command will issue a warning if this order is not kept.
  See also policy :policy:`CMP0000`.
