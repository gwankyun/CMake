CMAKE_GENERATOR
---------------

用于构建项目的生成器。看到\ :manual:`cmake-generators(7)`。

The name of the generator that is being used to generate the build
files.  (e.g.  ``Unix Makefiles``, ``Ninja``, etc.)

The value of this variable should never be modified by project code.
A generator may be selected via the :option:`cmake -G` option,
interactively in :manual:`cmake-gui(1)`, or via the :envvar:`CMAKE_GENERATOR`
environment variable.
