CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT
-------------------------------------------

.. versionadded:: 3.7.1

当\ :variable:`CMAKE_INSTALL_PREFIX`\ 刚刚初始化为默认值时，CMake将此变量设置为\
``TRUE``\ 值，通常是在CMake在新构建树中的第一次运行时，并且\
:envvar:`CMAKE_INSTALL_PREFIX`\ 环境变量未在CMake的第一次运行时设置。项目代码可以使用\
它来更改默认值，而无需覆盖用户提供的值：

.. code-block:: cmake

  if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "/my/default" CACHE PATH "..." FORCE)
  endif()
