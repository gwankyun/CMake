find_file
---------

.. |FIND_XXX| replace:: find_file
.. |NAMES| replace:: NAMES name1 [name2 ...]
.. |SEARCH_XXX| replace:: 文件的完整路径
.. |SEARCH_XXX_DESC| replace:: 命名文件的完整路径
.. |prefix_XXX_SUBDIR| replace:: ``<prefix>/include``
.. |entry_XXX_SUBDIR| replace:: ``<entry>/include``

.. |FIND_XXX_REGISTRY_VIEW_DEFAULT| replace:: ``TARGET``

.. |FIND_PACKAGE_ROOT_PREFIX_PATH_XXX| replace::
   ``<prefix>/include/<arch>``，如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，\
   以及\ |FIND_PACKAGE_ROOT_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_PREFIX_PATH_XXX| replace::
   ``<prefix>/include/<arch>``，如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，\
   以及\ |CMAKE_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_XXX_PATH| replace:: :variable:`CMAKE_INCLUDE_PATH`
.. |CMAKE_XXX_MAC_PATH| replace:: :variable:`CMAKE_FRAMEWORK_PATH`

.. |ENV_CMAKE_PREFIX_PATH_XXX| replace::
   ``<prefix>/include/<arch>``，如果设置了 :variable:`CMAKE_LIBRARY_ARCHITECTURE`，以及\
   |ENV_CMAKE_PREFIX_PATH_XXX_SUBDIR|
.. |ENV_CMAKE_XXX_PATH| replace:: :envvar:`CMAKE_INCLUDE_PATH`
.. |ENV_CMAKE_XXX_MAC_PATH| replace:: :envvar:`CMAKE_FRAMEWORK_PATH`


.. |SYSTEM_ENVIRONMENT_PATH_XXX| replace:: ``INCLUDE``\ 和\ ``PATH``\ 中的目录。
.. |SYSTEM_ENVIRONMENT_PATH_WINDOWS_XXX| replace::
   在Windows主机上，CMake 3.3到3.27会搜索额外的路径：\ ``<prefix>/include/<arch>``，\
   如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，以及\
   |SYSTEM_ENVIRONMENT_PREFIX_PATH_XXX_SUBDIR|。这个行为在CMake 3.28被移除。

.. |CMAKE_SYSTEM_PREFIX_PATH_XXX| replace::
   ``<prefix>/include/<arch>``，如果设置了\ :variable:`CMAKE_LIBRARY_ARCHITECTURE`，\
   以及\ |CMAKE_SYSTEM_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_SYSTEM_XXX_PATH| replace::
   :variable:`CMAKE_SYSTEM_INCLUDE_PATH`
.. |CMAKE_SYSTEM_XXX_MAC_PATH| replace::
   :variable:`CMAKE_SYSTEM_FRAMEWORK_PATH`

.. |CMAKE_FIND_ROOT_PATH_MODE_XXX| replace::
   :variable:`CMAKE_FIND_ROOT_PATH_MODE_INCLUDE`

.. include:: include/FIND_XXX.rst
