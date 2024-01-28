CMAKE_<LANG>_BYTE_ORDER
-----------------------

.. versionadded:: 3.20

在知道的前排下，\ ``<LANG>``\ 编译器目标体系结构。如果已定义且不为空，则值为：

``BIG_ENDIAN``
  The target architecture is Big Endian.

``LITTLE_ENDIAN``
  The target architecture is Little Endian.

This is defined for languages ``C``, ``CXX``, ``OBJC``, ``OBJCXX``,
and ``CUDA``.

If :variable:`CMAKE_OSX_ARCHITECTURES` specifies multiple architectures, the
value of ``CMAKE_<LANG>_BYTE_ORDER`` is non-empty only if all architectures
share the same byte order.
