CMAKE_CONFIG_DIR
----------------

.. versionadded:: 3.31

.. include:: ENV_VAR.txt

为\ :manual:`cmake-file-api(7)`\ 查询指定一个CMake用户范围的配置目录。

If this environment variable is not set, the default user-wide
configuration directory is platform-specific:

- Windows: ``%LOCALAPPDATA%\CMake``
- macOS: ``$XDG_CONFIG_HOME/CMake`` if set, otherwise
  ``$HOME/Library/Application Support/CMake``
- Linux/Other: ``$XDG_CONFIG_HOME/cmake`` if set, otherwise
  ``$HOME/.config/cmake``
