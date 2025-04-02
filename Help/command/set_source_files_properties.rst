set_source_files_properties
---------------------------

源文件可以具有影响其构建方式的属性。

.. code-block:: cmake

  set_source_files_properties(<files> ...
                              [DIRECTORY <dirs> ...]
                              [TARGET_DIRECTORY <targets> ...]
                              PROPERTIES <prop1> <value1>
                              [<prop2> <value2>] ...)

使用键值对列表设置与源文件关联的属性。

.. versionadded:: 3.18
  默认情况下，源文件属性仅对在同一目录（\ ``CMakeLists.txt``\ ）中添加的目标可见。可以使用\
  以下一个或两个选项在其他目录作用域中设置可见性：

  ``DIRECTORY <dirs>...``
    源文件属性将在每个\ ``<dirs>``\ 目录的作用域中设置。CMake必须已经知晓这些源目录，\
    这可以通过调用\ :command:`add_subdirectory`\ 命令添加这些目录，或者这些目录是顶层源\
    目录来实现。\
    相对路径会被视为相对于当前源目录。

  ``TARGET_DIRECTORY <targets>...``
    源文件属性将在指定的每个\ ``<targets>``\ 被创建的目录作用域中设置（因此，这些\
    ``<targets>``\ 必须已经存在）。

使用\ :command:`get_source_file_property`\ 来获取属性值。\
另请参阅\ :command:`set_property(SOURCE)`\ 命令。

.. note::

  :prop_sf:`GENERATED`\ 源文件属性可能是全局可见的。具体细节请参阅其文档。

另请参阅
^^^^^^^^

* :command:`define_property`
* :command:`get_source_file_property`
* 有关CMake已知的属性列表，请参阅\ :ref:`Source File Properties`
