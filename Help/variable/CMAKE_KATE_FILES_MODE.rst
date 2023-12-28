CMAKE_KATE_FILES_MODE
---------------------

.. versionadded:: 3.27

该缓存变量由Kate项目生成器使用，并控制将项目文件中的\ ``files``\ 条目设置为何种模式。参阅\
:manual:`cmake-generators(7)`。

Possible values are ``AUTO``, ``SVN``, ``GIT``, ``HG``, ``FOSSIL`` and ``LIST``.

When set to ``LIST``, CMake will put the list of source files known to CMake
in the project file.
When set to ``SVN``, ``GIT``, ``HG`` or ``FOSSIL``, CMake will set
the generated project accordingly to Subversion, git, Mercurial
or Fossil, and Kate will then use the respective command line tool to
retrieve the list of files in the project.
When unset or set to ``AUTO``, CMake will try to detect whether the
source directory is part of a git or svn checkout or not, and put the
respective entry into the project file.
