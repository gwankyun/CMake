VS_SOLUTION_ITEMS
-----------------

.. versionadded:: 4.0

指定生成的Visual Studio解决方案中包含的解决方案级别的项目。

The :ref:`Visual Studio Generators` create a ``.sln`` file for each directory
whose ``CMakeLists.txt`` file calls the :command:`project` command. Append paths
to this property in the same directory as the top-level :command:`project`
command call (e.g. in the top-level ``CMakeLists.txt`` file) to specify files
included in the corresponding solution file.

If a file specified in ``VS_SOLUTION_ITEMS`` matches a :command:`source_group`
command call, the affected solution level items are placed in a hierarchy of
solution level folders according to the name specified in that command.
Otherwise the items are placed in a default solution level directory named
``Solution Items``. This name matches the default directory name used by Visual
Studio when attempting to add solution level items at the root of the solution.
