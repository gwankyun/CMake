CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT
-------------------------------------------

.. versionadded:: 3.7.1

当\ :variable:`CMAKE_INSTALL_PREFIX`\ 刚刚初始化为默认值时，CMake将该变量设置为\
``TRUE``\ 值，通常是在CMake在新构建树中的第一次运行时。项目代码可以使用它来更改默认值，而\
无需覆盖用户提供的值：

.. code-block:: cmake

  if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "/my/default" CACHE PATH "..." FORCE)
  endif()
