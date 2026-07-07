.. cmake-manual-description: CMake Presets Reference
.. |includes| replace:: :ref:`CMakePresets includes`
.. |configure-preset| replace:: :ref:`CMakePresets configure-preset`
.. |build-preset| replace:: :ref:`CMakePresets build-preset`
.. |test-preset| replace:: :ref:`CMakePresets test-preset`
.. |package-preset| replace:: :ref:`CMakePresets package-preset`
.. |condition| replace:: :ref:`CMakePresets condition`
.. |macro-expansion| replace:: :ref:`CMakePresets macro-expansion`
.. |Versions| replace:: :ref:`CMakePresets Versions`

cmake-presets(7)
****************

.. only:: html

   .. contents::

引言
============

.. versionadded:: 3.19

CMake用户经常面临的一个问题是与其他人共享配置项目的常用方法。这样做可能是为了支持CI构建，或\
者是为了经常使用相同构建的用户。CMake支持两个主要文件，\ ``CMakePresets.json``\ 和\
``CMakeUserPresets.json``，它们允许用户指定通用的配置选项并与他人共享。

.. presets-versionadded:: 4

  CMake 还支持通过 :preset:`include` 字段包含的文件。更多细节请参阅\ |includes|。

``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 存在于项目的根目录中。它们都具\
有完全相同的格式，并且都是可选的（尽管如果指定了\ :cmake-option:`--preset`，\
则必须至少存在一个）。\ ``CMakePresets.json``\ 旨在指定项目范围内的构建细节，而\
``CMakeUserPresets.json``\ 旨在让开发人员指定他们自己的本地构建细节。

``CMakePresets.json``\ 可能会被签入版本控制系统，而\ ``CMakeUserPresets.json``\ 则不\
应被签入。例如，如果一个项目正在使用Git, ``CMakePresets.json``\ 可能会被跟踪，\
``CMakeUserPresets.json``\ 应该被添加到\ ``.gitignore``\ 中。

.. versionadded:: 4.4

  CMake 还支持通过 :cmake-option:`--presets-file` 选项指定一个文件来读取预设。如果指定了\
  此选项，则不要求 ``CMakePresets.json`` 或 ``CMakeUserPresets.json`` 存在，且这些文件\
  中定义的任何预设将被忽略/不可用。

格式
======

这些文件是一个JSON文档，以一个对象作为根：

.. literalinclude:: presets/example.json
  :language: json

.. presets-versionadded:: 10

  预设文件可以在 JSON 对象的任意层级使用键 ``$comment`` 来添加注释，以提供文档说明。

根对象识别以下字段：

.. include:: presets/root-properties.rst

.. _`CMakePresets includes`:

包含
^^^^^^^^

.. presets-versionadded:: 4

CMake 预设文件可以通过 :preset:`include` 字段包含其他文件。\
通过这种方式包含的文件也可以继续包含其他文件。如果
``CMakePresets.json`` 和 ``CMakeUserPresets.json`` 同时存在，\
``CMakeUserPresets.json`` 会隐式包含 ``CMakePresets.json``，\
即使没有 :preset:`include` 字段，在所有版本的格式中均是如此。

如果一个预置文件包含从另一个文件中的预置继承的预置，则该文件必须直接或间接地包含另一个文件。\
文件之间不允许包含循环。如果\ ``a.json``\ 包含\ ``b.json``，\ ``b.json``\ 不能包含\
``a.json``。但是，一个文件可能会从同一个文件或不同的文件中被包含多次。

``CMakePresets.json``\ 中直接或间接包含的文件应保证由项目提供。\ ``CMakeUserPresets.json``\
可以包含来自任何地方的文件。

.. presets-versionchanged:: 7

  :preset:`include` 字段支持\ |macro-expansion|，但仅支持 ``$penv{}``
  宏展开。

.. presets-versionchanged:: 9

  :preset:`include` 字段支持\ |macro-expansion|，但不支持
  ``$env{}`` 和预设专属宏（即源自预设定义内部字段的宏，如 ``presetName``）。

.. _`Configure Preset`:
.. _`CMakePresets configure-preset`:

配置预设
^^^^^^^^^^^^^^^^

``configurePresets``\ 数组的每个条目都是一个JSON对象，可能包含以下字段：

.. include:: presets/configurePresets-properties.rst

.. _`Build Preset`:

.. _`CMakePresets build-preset`:

构建预设
^^^^^^^^^^^^

.. presets-versionadded:: 2

``buildPresets``\ 数组的每个条目都是一个JSON对象，可能包含以下字段：

.. include:: presets/buildPresets-properties.rst

.. _`Test Preset`:

.. _`CMakePresets test-preset`:

测试预设
^^^^^^^^^^^

.. presets-versionadded:: 2

``testPresets``\ 数组的每个条目都是一个JSON对象，可能包含以下字段：

.. include:: presets/testPresets-properties.rst

.. _`Package Preset`:

.. _`CMakePresets package-preset`:

包预设
^^^^^^^^^^^^^^

.. presets-versionadded:: 6

Each entry of the ``packagePresets`` array is a JSON object
that may contain the following fields:

.. include:: presets/packagePresets-properties.rst

.. _`Workflow Preset`:

工作流预设
^^^^^^^^^^^^^^^

.. presets-versionadded:: 6

Each entry of the ``workflowPresets`` array is a JSON object
that may contain the following fields:

.. include:: presets/workflowPresets-properties.rst

.. _`CMakePresets condition`:

条件
^^^^^^^^^

.. presets-versionadded:: 3

The ``condition`` field of a preset is used to determine whether or not the
preset is enabled. For example, this can be used to disable a preset on
platforms other than Windows. ``condition`` may be either a boolean, ``null``,
or an object. If it is a boolean, the boolean indicates whether the preset is
enabled or disabled. If it is ``null``, the preset is enabled, but the ``null``
condition is not inherited by any presets that may inherit from the preset.
Sub-conditions (for example in a ``not``, ``anyOf``, or ``allOf`` condition)
may not be ``null``. If it is an object, it has the following fields:

``type``
  必须的字符串，具有以下值之一：

  ``"const"``
    指示条件是恒定的。这相当于使用布尔值代替对象。条件对象将具有以下附加字段：

    ``value``
      一个必需的布尔值，它为条件的求值提供一个常量值。

  ``"equals"``, ``"notEquals"``
    指示条件比较两个字符串，看它们是否相等（或不相等）。条件对象将具有以下附加字段：

    ``lhs``
      第一个要比较的字符串。该字段支持宏扩展。

    ``rhs``
      第二个要比较的字符串。该字段支持宏扩展。

  ``"inList"``, ``"notInList"``
    指示该条件在字符串列表中搜索字符串。条件对象将具有以下附加字段：

    ``string``
      需要搜索的字符串。该字段支持宏扩展。

    ``list``
      需要搜索的字符串数组。该字段支持宏扩展，并使用短路求值。

  ``"matches"``, ``"notMatches"``
    表示该条件在字符串中搜索正则表达式。条件对象将具有以下附加字段：

    ``string``
      需要搜索的字符串。该字段支持宏扩展。

    ``regex``
      需要搜索的正则表达式。该字段支持宏扩展。

  ``"anyOf"``, ``"allOf"``

    指示条件是零个或多个嵌套条件的聚合。条件对象将具有以下附加字段：

    ``conditions``
      必需的条件对象数组。这些条件使用短路求值。

  ``"not"``
    指示条件是另一个条件的反转。条件对象将具有以下附加字段：

    ``condition``
      必需条件对象。

.. _`CMakePresets macro-expansion`:

宏扩展
^^^^^^^^^^^^^^^

As mentioned above, some fields support macro expansion. Macros are
recognized in the form ``$<macro-namespace>{<macro-name>}``.

In general, macros are evaluated in the context of the preset being used, even
if the macro is in a field that was inherited from another preset. For example,
if the ``Base`` preset sets variable ``PRESET_NAME`` to ``${presetName}``, and
the ``Derived`` preset inherits from ``Base``, ``PRESET_NAME`` will be set to
``Derived``. The ``${fileDir}`` macro as of preset version ``12`` is an
exception to this rule.

在宏名称的末尾不加上右括号是错误的。例如，\ ``${sourceDir``\ 无效。美元符号（\ ``$``\ ）\
后面跟一个可能的命名空间的左花括号（\ ``{``\ ）以外的任何东西都会被解释为字面的美元符号。

可识别的宏包括：

``${sourceDir}``
  项目源目录的路径（即与\ :variable:`CMAKE_SOURCE_DIR`\ 相同）。

``${sourceParentDir}``
  项目源目录的父目录的路径。

``${sourceDirName}``
  ``${sourceDir}``\ 的最后一个文件名组件。例如，如果\ ``${sourceDir}``\ 是\
  ``/path/to/source``，这将是\ ``source``。

``${presetName}``
  在预设的\ ``name``\ 字段中指定的名称。

  这是一个预设特定的宏。

``${generator}``
  在预设的\ ``generator``\ 字段中指定的生成器。对于构建和测试预设，这将计算为\
  ``configurePreset``\ 指定的生成器。

  这是一个预设特定的宏。

.. _`CMakePresets hostSystemName`:

``${hostSystemName}``
  .. presets-versionadded:: 3

  The name of the host operating system. Contains the same value as
  :variable:`CMAKE_HOST_SYSTEM_NAME`.

.. _`CMakePresets fileDir`:

``${fileDir}``
  .. presets-versionadded:: 4

  Path to the directory containing the presets file which defines the preset
  being used.

  .. presets-versionchanged:: 12

    This macro *always* expands to the directory of the current presets file
    containing the macro, regardless of the preset being used.

    For example, consider the following scenario.

    * ``/path/to/CMakePresets.json`` includes
      ``/path/to/subdir/CMakePresets.json``.
    * ``/path/to/subdir/CMakePresets.json`` defines preset ``Base``, which
      sets variable ``MY_DIR`` to ``${fileDir}``.
    * ``/path/to/CMakePresets.json`` defines preset ``Derived``, and
      ``Derived`` inherits from ``Base``.

    Under preset versions ``4``-``11``, ``MY_DIR`` will be set to ``/path/to/``
    when using the ``Derived`` preset, and ``/path/to/subdir/`` when using the
    ``Base`` preset.

    When ``/path/to/subdir/CMakePresets.json`` specifies version ``12`` or
    above, ``MY_DIR`` will always be set to ``/path/to/subdir/``, regardless of
    the preset being used.

    .. note::

      Since the ``${fileDir}`` macro in version 12 is expanded in the context
      of the current presets file, it is the version of the current file, rather
      than the version of the root file containing the preset being used, which
      dictates this behavior.

``${dollar}``
  字面上的美元符号（\ ``$``\ ）。

.. _`CMakePresets pathListSep`:

``${pathListSep}``
  .. presets-versionadded:: 5

  分隔路径列表的本地字符，如\ ``:``\ 或\ ``;``

  例如，通过将\ ``PATH``\ 设置为\ ``/path/to/ninja/bin${pathListSep}$env{PATH}``，\
  ``${pathListSep}``\ 将扩展为用于在\ ``PATH``\ 中连接的底层操作系统的字符。

``$env{<variable-name>}``
  名称为\ ``<variable-name>``\ 的环境变量。变量名不能是空字符串。如果变量在\
  ``environment``\ 字段中定义，则使用该值而不是来自父环境的值。如果没有定义环境变量，则计\
  算结果为空字符串。

  请注意，虽然Windows环境变量名是不区分大小写的，但预设中的变量名仍然是区分大小写的。当使用\
  不一致的套管时，这可能会导致意想不到的结果。为了获得最佳效果，请保持环境变量名称的大小写一致。

``$penv{<variable-name>}``
  类似于\ ``$env{<variable-name>}``，不同之处在于该值只来自父环境，而不来自\
  ``environment``\ 字段。这允许在现有环境变量上添加或追加值。例如，将\ ``PATH``\ 设置为\
  ``/path/to/ninja/bin:$penv{PATH}``\ 将把\ ``/path/to/ninja/bin``\ 添加到\ ``PATH``\
  环境变量中。这是必需的，因为\ ``$env{<variable-name>}``\ 不允许循环引用。

``$vendor{<macro-name>}``
  一个扩展点，供供应商插入他们自己的宏。CMake将不能使用带有\ ``$vendor{<macro-name>}``\
  宏的预置，并且会有效地忽略这些预置。但是，它仍然可以使用同一文件中的其他预设。

  CMake不会尝试解释\ ``$vendor{<macro-name>}``\ 宏。但是，为了避免名称冲突，IDE供应商\
  应该在\ ``<macro-name>``\ 前面加上一个非常短的（最好是<=4个字符）供应商标识符前缀，后\
  跟一个\ ``.``，再后跟宏名称。例如，示例IDE可以有\ ``$vendor{xide.ideInstallDir}``。

.. _`CMakePresets Versions`:

版本
========

The JSON schema of CMake presets files follows a version scheme where new
versions are added and allowed in newer versions of CMake.

以下列出了支持的版本以及它们在哪个CMake版本中添加，同时提供了新特性和变更的摘要。

  ``1``
    .. versionadded:: 3.19

    初始版本支持\ |configure-preset|\ 和\ |macro-expansion|。

  ``2``
    .. versionadded:: 3.20

    * 添加了\ |build-preset|。
    * 添加了\ |test-preset|。

  ``3``
    .. versionadded:: 3.21

    * 为\ :ref:`配置 <CMakePresets configure-preset>`、\
      :ref:`构建 <CMakePresets build-preset>`\ 和\ |test-preset|\ 添加了\
      |condition|\ 对象。
    * 对\ |configure-preset|\ 的更改

      * The :preset:`configurePresets.installDir` field was added.
      * The :preset:`configurePresets.toolchainFile` field was added.
      * The :preset:`configurePresets.binaryDir` field is now optional.
      * The :preset:`configurePresets.generator` field is now optional.


    * 对\ |macro-expansion|\ 的更改

      * 添加了\ `${hostSystemName} <CMakePresets hostSystemName_>`_\ 宏。

  ``4``
    .. versionadded:: 3.23

    * 添加了\ |includes|\ 以支持在\ ``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\
      中包含其他JSON文件。
    * 对\ |build-preset|\ 的更改

      * The :preset:`buildPresets.resolvePackageReferences` field was added.

    * 对\ |macro-expansion|\ 的更改

      * 添加了\ `${fileDir} <CMakePresets fileDir_>`_\ 宏。

  ``5``
    .. versionadded:: 3.24

    * 对\ |test-preset|\ 的更改

      * 向\ :preset:`testPresets.output.testOutputTruncation`\ 对象添加了\
        :preset:`testPresets.output`\ 字段。

    * 对\ |macro-expansion|\ 的更改

      * 添加了\ `${pathListSep} <CMakePresets pathListSep_>`_\ 宏。

  ``6``
    .. versionadded:: 3.25

    * 添加了\ |package-preset|。
    * 添加了\ `工作流预设 <Workflow Preset_>`_。
    * 对\ |test-preset|\ 的更改

      * 向\ :preset:`testPresets.output.outputJUnitFile`\ 对象添加了\
        :preset:`testPresets.output`\ 字段。

  ``7``
    .. versionadded:: 3.27

    * 对\ |configure-preset|\ 的更改

      * 添加了\ :preset:`configurePresets.trace`\ 字段。

    * 对\ |includes|\ 的更改

      * :preset:`include`\ 字段现在支持\ ``$penv{}``\ |macro-expansion|。

  ``8``
    .. versionadded:: 3.28

    * 向根对象添加了\ :preset:`$schema`\ 字段。

  ``9``
    .. versionadded:: 3.30

    * 对\ |includes|\ 的更改

      * :preset:`include`\ 字段现在支持其他类型的\ |macro-expansion|。

  ``10``
    .. versionadded:: 3.31

    * 添加了可选的\ ``$comment``\ 字段，以支持在整个\ ``CMakePresets.json``\ 和\
      ``CMakeUserPresets.json``\ 中添加文档。
    * 对\ |configure-preset|\ 的更改：

      * 添加了\ :preset:`configurePresets.graphviz`\ 字段。

  ``11``
    .. versionadded

    * 对\ |test-preset|\ 的更改

      * :preset:`testPresets.execution.jobs`\ 字段现在接受一个空字符串，\
        表示省略\ ``<jobs>``\ 的\ :ctest-option:`--parallel`。

  ``12``
    .. versionadded:: 4.4

    * Changes to `Configure Presets <Configure Preset_>`_:

      * The ``dev`` field is renamed to ``author`` in
        :preset:`configurePresets.warnings` and
        :preset:`configurePresets.errors`.

      * The ``uninitialized`` and ``unusedCli`` fields were added to
        :preset:`configurePresets.errors`.

      * The ``installAbsoluteDestination`` field was added to
        :preset:`configurePresets.warnings` and :preset:`configurePresets.errors`.

    * Changes to |macro-expansion|:
      
      * The `${fileDir} <CMakePresets fileDir_>`_ macro now always expands to
        the directory of presets file containing the ``${fileDir}`` macro,
        regardless of whether it is inherited by another preset in a different
        directory.

    * Changes to `Test Presets <Test Preset_>`_

      * The :preset:`testPresets.execution.testPassthroughArguments` field was
        added to forward arguments to test executables.

Schema
======

:download:`此文件 </manual/presets/schema.json>`\ 为\ CMake presets file\
格式提供了一个机器可读的JSON模式。
