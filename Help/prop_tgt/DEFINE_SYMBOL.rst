DEFINE_SYMBOL
-------------

在编译此目标的源代码时定义一个预处理符号。

CMake adds this definition when compiling sources of a ``SHARED`` library,
a ``MODULE`` library, or an ``EXECUTABLE`` with :prop_tgt:`ENABLE_EXPORTS`
enabled.  If ``DEFINE_SYMBOL`` is not set, the default definition is of
the form ``<target>_EXPORTS`` (with some substitutions if the target is
not a valid C identifier).

The symbol is only defined while compiling the target itself and is not
propagated to dependent targets.

On POSIX platforms, this can optionally be used to control the visibility
of symbols.

CMake provides support for such decorations with the :module:`GenerateExportHeader`
module.

See also the ``COMPILE_DEFINITIONS`` under :ref:`Target Compile Properties`.
