VS_USER_PROPS
-------------

.. versionadded:: 3.8

设置要包含在visual studio C++项目文件中的用户属性文件。标准路径为\
``$(UserRootDir)\\Microsoft.Cpp.$(Platform).user.props``。在大多数情况下，它与\
``%LOCALAPPDATA%\\Microsoft\\MSBuild\\v4.0\\Microsoft.Cpp.Win32.user.props``\
或者\ ``%LOCALAPPDATA%\\Microsoft\\MSBuild\\v4.0\\Microsoft.Cpp.x64.user.props``\
相同。

The ``*.user.props`` files can be used for Visual Studio wide
configuration which is independent from cmake.
