EXCLUDE_FROM_ALL
----------------

在子目录上将此目录属性设置为true值，以将其目标从其父目录的“all”目标中排除。如果排除，在父目\
录中运行例如\ ``make``\ 将不会在默认情况下以子目录为目标。这不会影响子目录本身的“all”目标。\
在子目录中运行例如\ ``make``\ 仍然会构建它的目标。

If the :prop_tgt:`EXCLUDE_FROM_ALL` target property is set on a target
then its value determines whether the target is included in the "all"
target of this directory and its ancestors.
