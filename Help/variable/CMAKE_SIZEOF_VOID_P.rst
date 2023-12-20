CMAKE_SIZEOF_VOID_P
-------------------

``void``\ 指针的大小。

This is set to the size of a pointer on the target machine, and is determined
when a compiled language is enabled.  If a 64-bit size is found, then the
library search path is modified to look for 64-bit libraries first.
