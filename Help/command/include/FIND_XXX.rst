一个简短的签名是：

.. parsed-literal::

   |FIND_XXX| (<VAR> <name> [<path>...])

一般签名为：

.. parsed-literal::

   |FIND_XXX| (
             <VAR>
             {<name> | |NAMES|}
             [HINTS {<path> | ENV <var>}...]
             [PATHS {<path> | ENV <var>}...]
             [REGISTRY_VIEW {64|32|64_32|32_64|HOST|TARGET|BOTH}]
             [PATH_SUFFIXES <suffix>...]
             [VALIDATOR <function>]
             [DOC "cache documentation string"]
             [NO_CACHE]
             [REQUIRED|OPTIONAL]
             [NO_DEFAULT_PATH]
             [NO_PACKAGE_ROOT_PATH]
             [NO_CMAKE_PATH]
             [NO_CMAKE_ENVIRONMENT_PATH]
             [NO_SYSTEM_ENVIRONMENT_PATH]
             [NO_CMAKE_SYSTEM_PATH]
             [NO_CMAKE_INSTALL_PREFIX]
             [CMAKE_FIND_ROOT_PATH_BOTH |
              ONLY_CMAKE_FIND_ROOT_PATH |
              NO_CMAKE_FIND_ROOT_PATH]
            )

This command is used to find a |SEARCH_XXX_DESC|.

Prior to searching, |FIND_XXX| checks if variable ``<VAR>`` is defined. If
the variable is not defined, the search will be performed. If the variable is
defined and its value is ``NOTFOUND``, or ends in ``-NOTFOUND``, the search
will be performed. If the variable contains any other value the search is not
performed.

  .. note::
      ``VAR`` is considered defined if it is available in the current scope. See
      the :ref:`cmake-language(7) variables <CMake Language Variables>`
      documentation for details on scopes, and the interaction of normal
      variables and cache entries.

The results of the search will be stored in a cache entry named ``<VAR>``.
Future calls to |FIND_XXX| will inspect this cache entry when specifying the
same ``<VAR>``. This optimization ensures successful searches will not be
repeated unless the cache entry is :command:`unset`.

If the |SEARCH_XXX| is found the recorded value in cache entry ``<VAR>`` will
be the result of the search. If nothing is found, the recorded value will be
``<VAR>-NOTFOUND``.

Options include:

``NAMES``
  为\ |SEARCH_XXX|\ 指定一个或多个可能的名称。

  当使用它来指定带有或不带版本后缀的名称时，我们建议先指定未版本化的名称，这样本地构建的包就\
  可以在发行版提供的包之前找到。

``HINTS``, ``PATHS``
  除了默认位置之外，指定要搜索的目录。\ ``ENV var``\ 子选项从系统环境变量中读取路径。

  .. versionchanged:: 3.24
    在\ ``Windows``\ 平台上，可以使用\ :ref:`专用语法 <Find Using Windows Registry>`\
    将注册表查询包含在目录中。在所有其他平台上，这些规范将被忽略。

``REGISTRY_VIEW``
  .. versionadded:: 3.24

  .. include:: include/FIND_XXX_REGISTRY_VIEW.rst

``PATH_SUFFIXES``
  在每个目录位置下面指定要检查的附加子目录。

``VALIDATOR``
  .. versionadded:: 3.25

  指定要为找到的每个候选项调用的\ :command:`function`\ （无法提供\ :command:`macro`，会\
  导致错误）。有两个参数将传递给验证函数：结果变量的名称和候选项的绝对路径。除非函数在调用作用\
  域中将result变量的值设置为false，否则该项将被接受并结束搜索。当输入验证函数时，result变\
  量将保存true值。

  .. parsed-literal::

     function(my_check validator_result_var item)
       if(NOT item MATCHES ...)
         set(${validator_result_var} FALSE PARENT_SCOPE)
       endif()
     endfunction()

     |FIND_XXX| (result NAMES ... VALIDATOR my_check)

  注意，如果使用缓存的结果，则跳过搜索，并忽略任何\ ``VALIDATOR``。缓存的结果不需要传递验证\
  函数。

``DOC``
  为\ ``<VAR>``\ 缓存项指定文档字符串。

``NO_CACHE``
  .. versionadded:: 3.21

  搜索结果将存储在普通变量中，而不是缓存项中。

  .. note::

    |FIND_XXX| will still check for ``<VAR>`` as usual, checking first for a
    variable, and then a cache entry. If either indicate a previous successful
    search, the search will not be performed.

  .. warning::

    应该谨慎使用这个选项，因为它会大大增加重复配置步骤的成本。

``REQUIRED``
  .. versionadded:: 3.18

  如果没有找到，则停止处理，并给出错误消息，否则在下次用相同的变量调用\ |FIND_XXX|\ 时，\
  将再次尝试搜索。

  .. versionadded:: 4.1

    当\ :variable:`CMAKE_FIND_REQUIRED`\ 变量启用时，每个\ |FIND_XXX|\
    命令都将被视为\ ``REQUIRED``。

``OPTIONAL``
  .. versionadded:: 4.1

  忽略\ :variable:`CMAKE_FIND_REQUIRED`\ 的值，如果未找到任何内容，将继续执行且\
  不显示错误消息。与\ ``REQUIRED``\ 不兼容。

如果指定了\ ``NO_DEFAULT_PATH``，则不会向搜索添加其他路径。如果没有指定\ ``NO_DEFAULT_PATH``，\
搜索过程如下：

.. |FIND_PACKAGE_ROOT_PREFIX_PATH_XXX_SUBDIR| replace::
   对于\ :variable:`<PackageName>_ROOT` CMake变量中每个\ ``<prefix>``\ 的\
   |prefix_XXX_SUBDIR|\ 及如果在查找模块调用中被\ :command:`find_package(<PackageName>)`\
   加载的\ :envvar:`<PackageName>_ROOT`\ 环境变量

.. |CMAKE_PREFIX_PATH_XXX_SUBDIR| replace::
   对于\ :variable:`CMAKE_PREFIX_PATH`\ 中的每个\ ``<prefix>``\ 的\ |prefix_XXX_SUBDIR|

.. |ENV_CMAKE_PREFIX_PATH_XXX_SUBDIR| replace::
   对于\ :envvar:`CMAKE_PREFIX_PATH`\ 中的每个\ ``<prefix>``\ 的\ |prefix_XXX_SUBDIR|

.. |SYSTEM_ENVIRONMENT_PREFIX_PATH_XXX_SUBDIR| replace::
   对于\ ``PATH``\ 中的每个\ ``<prefix>/[s]bin``\ 的\ |prefix_XXX_SUBDIR|，以及对于\
   ``PATH``\ 中的其他条目的\ |entry_XXX_SUBDIR|

.. |CMAKE_SYSTEM_PREFIX_PATH_XXX_SUBDIR| replace::
   对于\ :variable:`CMAKE_SYSTEM_PREFIX_PATH`\ 中的每个\ ``<prefix>``\ 的\ |prefix_XXX_SUBDIR|

1. 如果在查找模块中调用，或者调用\ :command:`find_package(<PackageName>)`\ 加载的任何\
   其他脚本中调用，搜索前缀与当前查找的包是唯一的。参见策略\ :policy:`CMP0074`。

   .. versionadded:: 3.12

   具体来说，按以下变量指定的顺序搜索路径：

   a. :variable:`<PackageName>_ROOT` CMake变量，其中\ ``<PackageName>``\ 是保留大小\
      写的包名。

   b. :variable:`<PACKAGENAME>_ROOT` CMake变量，其中\ ``<PACKAGENAME>``\ 为大写的\
      包名。参见策略\ :policy:`CMP0144`。

      .. versionadded:: 3.27

   c. :envvar:`<PackageName>_ROOT`\ 环境变量，其中\ ``<PackageName>``\ 是保留大小写\
      的包名。

   d. :envvar:`<PACKAGENAME>_ROOT`\ 环境变量，其中\ ``<PACKAGENAME>``\ 为大写的包名。\
      参见策略\ :policy:`CMP0144`。

      .. versionadded:: 3.27

   包的根变量以栈的形式维护，因此如果从嵌套的查找模块或配置包中调用，则将在当前模块或包的路径\
   之后搜索父模块的查找模块或配置包的根路径。也就是说，查找顺序为\ ``<CurrentPackage>_ROOT``、\
   ``ENV{<CurrentPackage>_ROOT}``、\ ``<ParentPackage>_ROOT``、\
   ``ENV{<ParentPackage>_ROOT}``\ 等等。如果传递了\ ``NO_PACKAGE_ROOT_PATH``，或者将\
   :variable:`CMAKE_FIND_USE_PACKAGE_ROOT_PATH`\ 设置为\ ``FALSE``，则可以跳过该操作。

   * |FIND_PACKAGE_ROOT_PREFIX_PATH_XXX|

2. 搜索指定在cmake专用缓存变量中的路径。它们通常在命令行中使用\ ``-DVAR=value``。这些值被\
   解释为\ :ref:`以分号分隔的列表 <CMake Language Lists>`。如果传递了\ ``NO_CMAKE_PATH``，\
   或者将\ :variable:`CMAKE_FIND_USE_CMAKE_PATH`\ 设置为\ ``FALSE``，则可以跳过该操作。

   * |CMAKE_PREFIX_PATH_XXX|
   * |CMAKE_XXX_PATH|
   * |CMAKE_XXX_MAC_PATH|

3. 在cmake特定的环境变量中搜索指定的路径。这些分隔符需要在用户的shell配置中设置，因此要使用\
   主机的本地路径分隔符（\ ``;``\ 在Windows和\ ``:``\ 在UNIX上）。如果传递了\
   ``NO_CMAKE_ENVIRONMENT_PATH``，或者将\ :variable:`CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH`\
   设置为\ ``FALSE``，则可以跳过此操作。

   * |ENV_CMAKE_PREFIX_PATH_XXX|
   * |ENV_CMAKE_XXX_PATH|
   * |ENV_CMAKE_XXX_MAC_PATH|

4. 搜索由\ ``HINTS``\ 选项指定的路径。这些路径应该是由系统自省计算出来的，例如由已经找到的\
   另一项的位置提供的提示。硬编码的猜测应该用\ ``PATHS``\ 选项指定。

5. 搜索标准系统环境变量。如果传递了\ ``NO_SYSTEM_ENVIRONMENT_PATH``，或者将\
   :variable:`CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH`\ 设置为\ ``FALSE``，就可以\
   跳过这一步。

   * |SYSTEM_ENVIRONMENT_PATH_XXX|

   |SYSTEM_ENVIRONMENT_PATH_WINDOWS_XXX|

6. 在平台文件中搜索当前系统中定义的cmake变量。如果传递了\ ``NO_CMAKE_INSTALL_PREFIX``\
   或将\ :variable:`CMAKE_FIND_USE_INSTALL_PREFIX`\ 设置为\ ``FALSE``.，可以跳过对\
   ``CMAKE_INSTALL_PREFIX`` 和\ ``CMAKE_STAGING_PREFIX``\ 的搜索。如果传递了\
   ``NO_CMAKE_SYSTEM_PATH``，或者将\ :variable:`CMAKE_FIND_USE_CMAKE_SYSTEM_PATH`\
   设置为\ ``FALSE``，那么可以跳过所有这些位置。

   * |CMAKE_SYSTEM_PREFIX_PATH_XXX|
   * |CMAKE_SYSTEM_XXX_PATH|
   * |CMAKE_SYSTEM_XXX_MAC_PATH|

   这些变量包含的平台路径通常包含已安装软件的位置。一个例子是基于UNIX平台的\ ``/usr/local``。

7. 搜索由\ ``PATHS``\ 选项或简写版命令指定的路径。这些通常是硬编码的猜测。

:variable:`CMAKE_IGNORE_PATH`、\ :variable:`CMAKE_IGNORE_PREFIX_PATH`、\
:variable:`CMAKE_SYSTEM_IGNORE_PATH`\ 和\ :variable:`CMAKE_SYSTEM_IGNORE_PREFIX_PATH`\
变量也可能导致上述一些位置被忽略。

.. versionadded:: 3.16
  增加了\ ``CMAKE_FIND_USE_<CATEGORY>_PATH``\ 变量来全局禁用各种搜索位置。

.. |FIND_ARGS_XXX| replace:: <VAR> NAMES name

在macOS上，\ :variable:`CMAKE_FIND_FRAMEWORK`\ 和\ :variable:`CMAKE_FIND_APPBUNDLE`\
变量决定了苹果风格的包组件和unix风格的包组件的偏好顺序。

.. include:: include/FIND_XXX_ROOT.rst
.. include:: include/FIND_XXX_ORDER.rst
