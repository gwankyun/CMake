VISIBILITY_INLINES_HIDDEN
-------------------------

是否添加编译标志以隐藏内联函数的符号

The ``VISIBILITY_INLINES_HIDDEN`` property determines whether a flag for
hiding symbols for inline functions, such as ``-fvisibility-inlines-hidden``,
should be used when invoking the compiler.  This property affects compilation
in sources of all types of targets (subject to policy :policy:`CMP0063`).

This property is initialized by
the value of the :variable:`CMAKE_VISIBILITY_INLINES_HIDDEN` variable if it
is set when a target is created.
