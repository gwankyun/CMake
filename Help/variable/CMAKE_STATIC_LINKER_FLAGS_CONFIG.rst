CMAKE_STATIC_LINKER_FLAGS_<CONFIG>
----------------------------------

用于创建静态库的标志。当在\ ``<CONFIG>``\ 配置中创建静态库时，这些标志将传递给归档器。

See also :variable:`CMAKE_STATIC_LINKER_FLAGS`.

.. note::
  Static libraries do not actually link.  They are essentially archives
  of object files.  The use of the name "linker" in the name of this
  variable is kept for compatibility.
