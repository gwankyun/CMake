load_cache
----------

从另一个项目的\ ``CMakeCache.txt``\ 缓存文件中加载值。这对于依赖于在单独目录树中构建的另一个\
项目的项目很有用。

此命令有两种签名形式。推荐的签名为：

.. signature::
  load_cache(<build-dir> READ_WITH_PREFIX <prefix> <entry>...)
  :target: READ_WITH_PREFIX

  从指定的 ``<build-dir>`` 构建目录加载缓存文件，并获取所列出的缓存条目。获取的值存储在局部\
  变量中，其名称以提供的 ``<prefix>`` 为前缀。此操作仅读取缓存值；不会创建或修改本地项目缓存中\
  的条目。

  ``READ_WITH_PREFIX <prefix>``
    对于每个缓存 ``<entry>``，使用指定的 ``<prefix>`` 加条目名称创建一个局部变量。

  此签名也可用于 :option:`cmake -P` 脚本模式。

此命令的以下签名形式强烈不建议使用，但为向后兼容而提供。

.. signature::
  load_cache(<build-dir> [EXCLUDE <entry>...] [INCLUDE_INTERNALS <entry>...])
  :target: raw

  此形式从指定的 ``<build-dir>`` 构建目录加载缓存文件，并将其所有非内部缓存条目导入到本地\
  项目的缓存中作为内部缓存变量。默认情况下，仅导入非内部条目，除非使用了 ``INCLUDE_INTERNALS``
  选项。

  选项如下：

  ``EXCLUDE <entry>...``
    此选项可用于在导入值时排除给定的非内部缓存条目列表。
  ``INCLUDE_INTERNALS <entry>...``
    此选项可用于提供一份内部缓存条目列表，以便在非内部缓存条目之外额外包含这些条目。

  此签名只能在 CMake 项目中使用。不支持脚本模式。

.. note::

  与加载外部项目的缓存文件并手动访问变量相比，更稳健且更便捷的方法是在外部项目中使用
  :command:`export` 命令（如果可用）。这允许项目以结构化且可维护的方式提供其目标、\
  配置或特性，使集成更简单且更不易出错。

示例
^^^^^^^^

从另一个项目读取特定的缓存变量并将其存储为局部变量：

.. code-block:: cmake

  load_cache(
    path/to/other-project/build-dir
    READ_WITH_PREFIX prefix_
    OTHER_PROJECT_CACHE_VAR_1
    OTHER_PROJECT_CACHE_VAR_2
  )

  message(STATUS "${prefix_OTHER_PROJECT_CACHE_VAR_1")
  message(STATUS "${prefix_OTHER_PROJECT_CACHE_VAR_2")
  # Outputs:
  # -- some-value...
  # -- another-value...

使用过时的签名从另一个项目读取所有非内部缓存条目并将其存储为内部缓存变量：

.. code-block:: cmake

  load_cache(path/to/other-project/build-dir)

  message(STATUS "${OTHER_PROJECT_CACHE_VAR_1")
  message(STATUS "${OTHER_PROJECT_CACHE_VAR_2")
  # Outputs:
  # -- some-value...
  # -- another-value...

使用过时的签名排除特定的非内部缓存条目并包含内部缓存条目：

.. code-block:: cmake

  load_cache(
    path/to/other-project/build-dir
    EXCLUDE OTHER_PROJECT_CACHE_VAR_2
    INCLUDE_INTERNALS OTHER_PROJECT_INTERNAL_CACHE_VAR
  )

  message(STATUS "${OTHER_PROJECT_CACHE_VAR_1")
  message(STATUS "${OTHER_PROJECT_CACHE_VAR_2")
  message(STATUS "${OTHER_PROJECT_INTERNAL_CACHE_VAR}")
  # Outputs:
  # -- some-value...
  # --
  # -- some-internal-value...
