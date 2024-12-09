fltk_wrap_ui
------------

创建FLTK用户界面包装器。

.. code-block:: cmake

  fltk_wrap_ui(resultingLibraryName source1
               source2 ... sourceN )

为列出的所有.fl和.fld文件生成.h和.cxx文件。生成的.h和.cxx文件将被添加到一个名为\
``resultingLibraryName_FLTK_UI_SRCS``\ 的变量中，该变量应该添加到库中。
