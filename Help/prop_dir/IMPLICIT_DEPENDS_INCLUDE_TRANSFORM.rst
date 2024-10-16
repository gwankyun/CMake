IMPLICIT_DEPENDS_INCLUDE_TRANSFORM
----------------------------------

为目录中的依赖项指定\ ``#include``\ 行转换。

This property specifies rules to transform macro-like ``#include`` lines
during implicit dependency scanning of C and C++ source files.  The
list of rules must be semicolon-separated with each entry of the form
``A_MACRO(%)=value-with-%`` (the ``%`` must be literal).  During dependency
scanning occurrences of ``A_MACRO(...)`` on ``#include`` lines will be
replaced by the value given with the macro argument substituted for
``%``.  For example, the entry

::

  MYDIR(%)=<mydir/%>

will convert lines of the form

::

  #include MYDIR(myheader.h)

to

::

  #include <mydir/myheader.h>

allowing the dependency to be followed.

This property applies to sources in all targets within a directory.
The property value is initialized in each directory by its value in
the directory's parent.
