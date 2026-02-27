find_program
------------

.. |FIND_XXX| replace:: find_program
.. |NAMES| replace:: NAMES <name>... [NAMES_PER_DIR]
.. |SEARCH_XXX| replace:: 程序
.. |SEARCH_XXX_DESC| replace:: 程序
.. |prefix_XXX_SUBDIR| replace:: ``<prefix>/[s]bin``
.. |entry_XXX_SUBDIR| replace:: ``<entry>/[s]bin``

.. |FIND_XXX_REGISTRY_VIEW_DEFAULT| replace:: ``BOTH``

.. |FIND_PACKAGE_ROOT_PREFIX_PATH_XXX| replace::
   |FIND_PACKAGE_ROOT_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_PREFIX_PATH_XXX| replace::
   |CMAKE_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_XXX_PATH| replace:: :variable:`CMAKE_PROGRAM_PATH`
.. |CMAKE_XXX_MAC_PATH| replace:: :variable:`CMAKE_APPBUNDLE_PATH`

.. |ENV_CMAKE_PREFIX_PATH_XXX| replace::
   |ENV_CMAKE_PREFIX_PATH_XXX_SUBDIR|
.. |ENV_CMAKE_XXX_PATH| replace:: :envvar:`CMAKE_PROGRAM_PATH`
.. |ENV_CMAKE_XXX_MAC_PATH| replace:: :envvar:`CMAKE_APPBUNDLE_PATH`

.. |SYSTEM_ENVIRONMENT_PATH_XXX| replace:: ``PATH``\ 本身中的目录。
.. |SYSTEM_ENVIRONMENT_PATH_WINDOWS_XXX| replace:: \

.. |CMAKE_SYSTEM_PREFIX_PATH_XXX| replace::
   |CMAKE_SYSTEM_PREFIX_PATH_XXX_SUBDIR|
.. |CMAKE_SYSTEM_XXX_PATH| replace::
   :variable:`CMAKE_SYSTEM_PROGRAM_PATH`
.. |CMAKE_SYSTEM_XXX_MAC_PATH| replace::
   :variable:`CMAKE_SYSTEM_APPBUNDLE_PATH`

.. |CMAKE_FIND_ROOT_PATH_MODE_XXX| replace::
   :variable:`CMAKE_FIND_ROOT_PATH_MODE_PROGRAM`

.. include:: include/FIND_XXX.rst

当\ ``NAMES``\ 选项有多个值时，此命令默认一次只考虑一个名称，并在每个目录中搜索它。\
``NAMES_PER_DIR``\ 选项告诉这个命令一次只考虑一个目录，并在其中搜索所有名称。

被认为是程序的文件集合是特定于平台的：

* 在Windows上，文件名后缀的顺序是\ ``.com``、\ ``.exe``\ 和没有后缀。

* 在非Windows系统上，不考虑文件名后缀，但文件必须具有执行权限（参见策略\ :policy:`CMP0109`）。

要搜索脚本，需显式指定一个扩展名：

.. code-block:: cmake

  if(WIN32)
    set(_script_suffix .bat)
  else()
    set(_script_suffix .sh)
  endif()

  find_program(MY_SCRIPT NAMES my_script${_script_suffix})
