define_property
---------------

自定义属性及添加相应文档。

.. code-block:: cmake

  define_property(<GLOBAL | DIRECTORY | TARGET | SOURCE |
                   TEST | VARIABLE | CACHED_VARIABLE>
                   PROPERTY <name> [INHERITED]
                   [BRIEF_DOCS <brief-doc> [docs...]]
                   [FULL_DOCS <full-doc> [docs...]]
                   [INITIALIZE_FROM_VARIABLE <variable>])

在某个作用域中定义一个属性，供\ :command:`set_property`\ 和\ :command:`get_property`\
命令使用。\
它主要用于定义属性的初始化或继承方式。\
从历史上看，该命令还会为属性关联文档，但这已不再被视为主要用例。

第一个参数决定了该属性应使用的作用域类型。\
它必须是以下之一：

* ``GLOBAL``          - 与全局命名空间关联。
* ``DIRECTORY``       - 与一个目录关联。
* ``TARGET``          - 与一个目标关联。
* ``SOURCE``          - 与一个源文件关联。
* ``TEST``            - 与通过\ :command:`add_test`\ 命令命名的测试关联。
* ``VARIABLE``        - 记录一个CMake语言变量。
* ``CACHED_VARIABLE`` - 记录一个CMake缓存变量。

请注意，与\ :command:`set_property`\ 和\ :command:`get_property`\ 不同，此命令\
无需指定实际的作用域，仅作用域的类型是重要的。

必需的\ ``PROPERTY``\ 选项之后需紧跟要定义的属性名称。

如果指定了\ ``INHERITED``\ 选项，那么当请求的属性在\ :command:`get_property`\
命令指定的作用域中未设置时，该命令会向上级作用域进行查找。

* ``DIRECTORY``\ 作用域会链接到其父目录的作用域，继续向上遍历父目录，直到某个目录\
  设置了该属性，或者已经没有更多父目录为止。\
  如果在顶级目录仍未找到该属性，则会链接到\ ``GLOBAL``\ 作用域。
* ``TARGET``、\ ``SOURCE``\ 和\ ``TEST``\ 属性会链接到\ ``DIRECTORY``\ 作用域，\
  必要时还会进一步向上遍历目录，依此类推。

请注意，这种作用域链式查找行为仅适用于调用\ :command:`get_property`、\
:command:`get_directory_property`、\ :command:`get_target_property`、\
:command:`get_source_file_property`\ 和\ :command:`get_test_property`\ 命令的情况。\
在\ *设置*\ 属性时不存在继承行为，因此在使用\ :command:`set_property`\ 命令搭配\
``APPEND``\ 或\ ``APPEND_STRING``\ 选项时，确定要追加的内容时不会考虑继承的值。

``BRIEF_DOCS``\ 和\ ``FULL_DOCS``\ 选项之后需紧跟字符串，这些字符串将分别作为该\
属性的简要文档和完整文档。\
CMake不会直接使用这些文档，仅通过\ :command:`get_property`\ 命令的相应选项将其\
提供给项目使用。

.. versionchanged:: 3.23

  ``BRIEF_DOCS``\ 和\ ``FULL_DOCS``\ 选项是可选的。

.. versionadded:: 3.23

  ``INITIALIZE_FROM_VARIABLE``\ 选项指定了一个变量，属性将从该变量进行初始化。\
  它仅可用于目标属性。\
  变量名\ ``<variable>``\ 必须以属性名结尾，且不能以\ ``CMAKE_``\ 或\ ``_CMAKE_``\
  开头。\
  属性名必须至少包含一个下划线。\
  建议属性名使用特定于项目的前缀。

Property Redefinition
^^^^^^^^^^^^^^^^^^^^^

Once a property is defined for a particular type of scope, it cannot be
redefined. Attempts to redefine an existing property by calling
:command:`define_property` with the same scope type and property name
will be silently ignored. Defining the same property name for two different
kinds of scope is valid.

:command:`get_property` can be used to determine whether a property is
already defined for a particular kind of scope, and if so, to examine its
definition. For example:

.. code-block:: cmake

  # Initial definition
  define_property(TARGET PROPERTY MY_NEW_PROP
    BRIEF_DOCS "My new custom property"
  )

  # Later examination
  get_property(my_new_prop_exists
    TARGET NONE
    PROPERTY MY_NEW_PROP
    DEFINED
  )

  if(my_new_prop_exists)
    get_property(my_new_prop_docs
      TARGET NONE
      PROPERTY MY_NEW_PROP
      BRIEF_DOCS
    )
    # ${my_new_prop_docs} is now set to "My new custom property"
  endif()

See Also
^^^^^^^^

* :command:`get_property`
* :command:`set_property`
