INTERPROCEDURAL_OPTIMIZATION_<CONFIG>
-------------------------------------

特定配置目标的程序间优化。

This is a per-configuration version of :prop_tgt:`INTERPROCEDURAL_OPTIMIZATION`.
If set, this property overrides the generic property for the named
configuration.

This property is initialized by the
:variable:`CMAKE_INTERPROCEDURAL_OPTIMIZATION_<CONFIG>` variable if it is set
when a target is created.
