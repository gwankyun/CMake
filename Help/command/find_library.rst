find_library
------------

.. |FIND_XXX| replace:: find_library
.. |NAMES| replace:: NAMES name1 [name2 ...] [NAMES_PER_DIR]
.. |SEARCH_XXX| replace:: 库
.. |SEARCH_XXX_DESC| replace:: 库
.. |prefix_XXX_SUBDIR| replace:: ``<prefix>/lib``
.. |entry_XXX_SUBDIR| replace:: ``<entry>/lib``

.. |FIND_XXX_REGISTRY_VIEW_DEFAULT| replace:: ``TARGET``

.. |FIND_PACKAGE_ROOT_PREFIX_PATH_XXX| replace::
   ``<prefix>/lib/<arch>``，如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，\
   以及\ |FIND_PACKAGE_ROOT_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_PREFIX_PATH_XXX| replace::
   ``<prefix>/lib/<arch>``，如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，\
   以及\ |CMAKE_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_XXX_PATH| replace:: :variable:`CMAKE_LIBRARY_PATH`
.. |CMAKE_XXX_MAC_PATH| replace:: :variable:`CMAKE_FRAMEWORK_PATH`

.. |ENV_CMAKE_PREFIX_PATH_XXX| replace::
   ``<prefix>/lib/<arch>``，如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，\
   以及\ |ENV_CMAKE_PREFIX_PATH_XXX_SUBDIR|
.. |ENV_CMAKE_XXX_PATH| replace:: :envvar:`CMAKE_LIBRARY_PATH`
.. |ENV_CMAKE_XXX_MAC_PATH| replace:: :envvar:`CMAKE_FRAMEWORK_PATH`

.. |SYSTEM_ENVIRONMENT_PATH_XXX| replace:: ``LIB``\ 和\ ``PATH``\ 中的目录。
.. |SYSTEM_ENVIRONMENT_PATH_WINDOWS_XXX| replace::
   在Windows主机上，CMake 3.3到3.27会搜索额外的路径：\ ``<prefix>/lib/<arch>``，\
   如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，以及\
   |SYSTEM_ENVIRONMENT_PREFIX_PATH_XXX_SUBDIR|。这个行为在CMake 3.28被移除。

.. |CMAKE_SYSTEM_PREFIX_PATH_XXX| replace::
   ``<prefix>/lib/<arch>``，如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，\
   以及\ |CMAKE_SYSTEM_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_SYSTEM_XXX_PATH| replace::
   :variable:`CMAKE_SYSTEM_LIBRARY_PATH`
.. |CMAKE_SYSTEM_XXX_MAC_PATH| replace::
   :variable:`CMAKE_SYSTEM_FRAMEWORK_PATH`

.. |CMAKE_FIND_ROOT_PATH_MODE_XXX| replace::
   :variable:`CMAKE_FIND_ROOT_PATH_MODE_LIBRARY`

.. include:: FIND_XXX.txt

当\ ``NAMES``\ 选项有多个值时，此命令默认一次只考虑一个名称，并在每个目录中搜索它。\
``NAMES_PER_DIR``\ 选项告诉这个命令一次只考虑一个目录，并在其中搜索所有名称。

传递给\ ``NAMES``\ 选项的每个库名，若其包含库后缀，则首先按原样进行考虑；\
然后，会根据变量\ :variable:`CMAKE_FIND_LIBRARY_PREFIXES`\ 和\
:variable:`CMAKE_FIND_LIBRARY_SUFFIXES`\ 的定义，为其添加特定平台的前缀（例如\ ``lib``）\
和后缀（例如\ ``.so``）再进行考虑。因此，用户可以直接指定像\ ``libfoo.a``\ 这样的库文件名。\
这可用于在类UNIX系统上定位静态库。

如果找到的库是一个框架，那么\ ``<VAR>``\ 将被设置为框架\ ``<fullPath>/A.framework``\
的完整路径。当一个框架的完整路径被用作库时，CMake将使用\ ``-framework A``\ 和\
``-F<fullPath>``\ 将框架链接到目标。

.. versionadded:: 3.28

  现在找到的库可以在\ ``.xcframework``\ 文件夹中。

如果设置了\ :variable:`CMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX`\ 变量，则所有搜索路径都\
将被正常测试，后缀被附加，并且所有匹配的\ ``lib/``\ 都将被\
``lib${CMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX}/``\ 替换。该变量覆盖了\
:prop_gbl:`FIND_LIBRARY_USE_LIB32_PATHS`、\ :prop_gbl:`FIND_LIBRARY_USE_LIBX32_PATHS`\
和\ :prop_gbl:`FIND_LIBRARY_USE_LIB64_PATHS`\ 全局属性。

如果设置了\ :prop_gbl:`FIND_LIBRARY_USE_LIB32_PATHS`\ 全局属性，那么所有搜索路径都将被\
正常测试，其中附加了\ ``32/``，并且所有匹配\ ``lib/``\ 的路径都将被替换为\ ``lib32/``。\
对于已知需要该属性的平台，如果至少启用了\ :command:`project`\ 命令支持的一种语言，则会自动\
设置该属性。

如果设置了\ :prop_gbl:`FIND_LIBRARY_USE_LIBX32_PATHS`\ 全局属性，所有搜索路径都将正常\
测试，添加\ ``x32/``，并且\ ``lib/``\ 的所有匹配都将替换为\ ``libx32/``。对于已知需要该\
属性的平台，如果至少启用了\ :command:`project`\ 命令支持的一种语言，则会自动设置该属性。

如果设置了\ :prop_gbl:`FIND_LIBRARY_USE_LIB64_PATHS`\ 全局属性，所有搜索路径将被正常\
测试，附加\ ``64/``，并且\ ``lib/``\ 的所有匹配都被替换为\ ``lib64/``。对于已知需要该\
属性的平台，如果至少启用了\ :command:`project`\ 命令支持的一种语言，则会自动设置该属性。
