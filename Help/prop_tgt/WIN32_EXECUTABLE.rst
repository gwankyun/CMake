WIN32_EXECUTABLE
----------------

在windows上构建一个带有WinMain入口点的可执行文件。

When this property is set to true the executable when linked on
Windows will be created with a WinMain() entry point instead of just
main().  This makes it a GUI executable instead of a console application.
See the :variable:`CMAKE_MFC_FLAG` variable documentation to
configure use of the Microsoft Foundation Classes (MFC) for WinMain
executables.  This property is initialized by the value of the
:variable:`CMAKE_WIN32_EXECUTABLE` variable if it is set when
a target is created.

This property supports
:manual:`generator expressions <cmake-generator-expressions(7)>`, except if the
target is managed (contains C# code.)
