CPACK_CUSTOM_INSTALL_VARIABLES
------------------------------

.. versionadded:: 3.21

CPack变量（通过\ :option:`cpack -D`、\ ``CPackConfig.cmake``\ 或\
:variable:`CPACK_PROJECT_CONFIG_FILE`\ 脚本设置）在安装脚本中不直接可见。相反，可以在\ ``CPACK_CUSTOM_INSTALL_VARIABLES``\ 变量中传递\ ``varName=value``\ 对的列表。\
在安装时，每个列表项将导致指定名称的变量（\ ``varName``\ ）被设置为给定的\ ``value``。\
对于空\ ``value``，可以省略\ ``=``。

``CPACK_CUSTOM_INSTALL_VARIABLES`` allows the packaging installation to be
influenced by the user or driving script at CPack runtime without having to
regenerate the install scripts.

Example
"""""""

.. code-block:: cmake

  install(FILES large.txt DESTINATION data)

  install(CODE [[
    if(ENABLE_COMPRESSION)
      # "run-compressor" is a fictional tool that produces
      # large.txt.xz from large.txt and then removes the input file
      execute_process(COMMAND run-compressor $ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/large.txt)
    endif()
  ]])

With the above example snippet, :manual:`cpack <cpack(1)>` will by default
run the installation script with ``ENABLE_COMPRESSION`` unset, resulting in
a package containing the uncompressed ``large.txt``.  This can be overridden
when invoking :manual:`cpack <cpack(1)>` like so:

.. code-block:: shell

  cpack -D "CPACK_CUSTOM_INSTALL_VARIABLES=ENABLE_COMPRESSION=TRUE"

The installation script will then run with ``ENABLE_COMPRESSION`` set to
``TRUE``, resulting in a package containing the compressed ``large.txt.xz``
instead.
