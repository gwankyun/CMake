<LANG>_STANDARD_REQUIRED
------------------------

这些变体是：

* :prop_tgt:`C_STANDARD_REQUIRED`
* :prop_tgt:`CXX_STANDARD_REQUIRED`
* :prop_tgt:`CUDA_STANDARD_REQUIRED`
* :prop_tgt:`HIP_STANDARD_REQUIRED`
* :prop_tgt:`OBJC_STANDARD_REQUIRED`
* :prop_tgt:`OBJCXX_STANDARD_REQUIRED`

这些属性指定\ :prop_tgt:`<LANG>_STANDARD`\ 的值是否是必需的。当false或未设置时，\
:prop_tgt:`<LANG>_STANDARD`\ 目标属性被视为可选属性，如果请求的标准不可用，则可能“衰减”\
到前一个标准。当\ ``<LANG>_STANDARD_REQUIRED``\ 设置为true时，\
:prop_tgt:`<LANG>_STANDARD`\ 将成为硬性要求，如果不能满足该要求，将发出致命错误。

Note that the actual language standard used may be higher than that specified
by :prop_tgt:`<LANG>_STANDARD`, regardless of the value of
``<LANG>_STANDARD_REQUIRED``.  In particular,
:ref:`usage requirements <Target Usage Requirements>` or the use of
:manual:`compile features <cmake-compile-features(7)>` can raise the required
language standard above what :prop_tgt:`<LANG>_STANDARD` specifies.

These properties are initialized by the value of the
:variable:`CMAKE_<LANG>_STANDARD_REQUIRED` variable if it is set when a target
is created.

See the :manual:`cmake-compile-features(7)` manual for information on
compile features and a list of supported compilers.
