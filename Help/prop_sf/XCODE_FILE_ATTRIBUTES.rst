XCODE_FILE_ATTRIBUTES
---------------------

.. versionadded:: 3.7

添加值到\ :generator:`Xcode`\ 的\ ``ATTRIBUTES``\ 设置对源文件的引用。除此之外，这可以\
用来设置\ ``.mig``\ 文件上的角色：\ ::

  set_source_files_properties(defs.mig
      PROPERTIES
          XCODE_FILE_ATTRIBUTES "Client;Server"
  )
