load_cache
----------

从另一个项目的CMake缓存中加载值。

.. code-block:: cmake

  load_cache(pathToBuildDirectory READ_WITH_PREFIX prefix entry1...)

读取缓存并将请求的数据项存储在变量中，变量名前加上给定的前缀。这只读取值，不会在本地项目的缓存\
中创建条目。

.. code-block:: cmake

  load_cache(pathToBuildDirectory [EXCLUDE entry1...]
             [INCLUDE_INTERNALS entry1...])

从另一个缓存加载值，并将它们作为内部条目存储在本地项目的缓存中。这对于依赖于在不同树中构建的\
另一个项目的项目很有用。\ ``EXCLUDE``\ 选项可用于提供要排除的条目列表。\
``INCLUDE_INTERNALS``\ 可用于提供要包含的内部项的列表。通常情况下，不会引入内部条目。\
强烈建议使用这种形式的命令，但这样做是为了向后兼容。
