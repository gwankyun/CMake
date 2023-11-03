FOLDER
------

对于使用文件夹层次结构呈现目标的IDE，此属性指定要放置目标的文件夹的名称。要嵌套文件夹，使用\
``FOLDER``\ 值，如\ ``GUI/Dialogs``，用\ ``/``\ 字符分隔文件夹级别。没有\ ``FOLDER``\
属性的目标将显示为顶级实体。具有相同\ ``FOLDER``\ 属性值的目标将与同级目标出现在同一文件夹中。

Only some CMake generators honor the ``FOLDER`` property
(e.g. :generator:`Xcode` or any of the
:ref:`Visual Studio <Visual Studio Generators>` generators).
Those generators that don't will simply ignore it.

This property is initialized by the value of the variable
:variable:`CMAKE_FOLDER` if it is set when a target is created.

The global property :prop_gbl:`USE_FOLDERS` must be set to true, otherwise
the ``FOLDER`` property is ignored.
