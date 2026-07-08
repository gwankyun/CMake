project
-------

设置项目名。

概要
^^^^^^^^

.. code-block:: cmake

 project(<PROJECT-NAME> [<language-name>...])
 project(<PROJECT-NAME>
         [VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
         [COMPAT_VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
         [SPDX_LICENSE <license-string>]
         [DESCRIPTION <description-string>]
         [HOMEPAGE_URL <url-string>]
         [LANGUAGES <language-name>...])

设置项目的名称，并将其存储在变量\ :variable:`PROJECT_NAME`\ 中。当从顶层\
``CMakeLists.txt``\ 调用时，还会将项目名称存储在变量\ :variable:`CMAKE_PROJECT_NAME`\ 中。

同时设置变量：

:variable:`PROJECT_SOURCE_DIR`、\ :variable:`<PROJECT-NAME>_SOURCE_DIR`\
  项目源目录的绝对路径。

:variable:`PROJECT_BINARY_DIR`、\ :variable:`<PROJECT-NAME>_BINARY_DIR`\
  项目二进制目录的绝对路径。

:variable:`PROJECT_IS_TOP_LEVEL`、\ :variable:`<PROJECT-NAME>_IS_TOP_LEVEL`\
  .. versionadded:: 3.21

  布尔值，指示项目是否为顶层项目。

更多变量由下文\ `选项`_\ 部分中描述的可选参数设置。如果未提供某个选项，\
其对应的变量将被设置为空字符串。

请注意，形式为\ ``<name>_SOURCE_DIR``\ 和\ ``<name>_BINARY_DIR``\ 的变量也可能在调用\
``project()``\ 之前由其他命令设置（例如，参见\ :command:`FetchContent_MakeAvailable`\
命令）。\
项目不应依赖于\ ``<PROJECT-NAME>_SOURCE_DIR``\ 或\ ``<PROJECT-NAME>_BINARY_DIR``\
在调用\ ``project()``\ 的作用域或其任何子作用域之外持有特定值。

.. versionchanged:: 3.30
  如果在调用\ ``project(<PROJECT-NAME> ...)``\ 时，\ ``<PROJECT-NAME>_SOURCE_DIR``、\
  ``<PROJECT-NAME>_BINARY_DIR``\ 和\ ``<PROJECT-NAME>_IS_TOP_LEVEL``\ 已作为普通\
  变量设置，则它们会被该调用更新。\
  同名的缓存条目始终按以前的方式设置。有关详细信息，请参见3.30.3、3.30.4和3.30.5\
  版本的发行说明。

.. versionchanged:: 3.31
  ``<PROJECT-NAME>_SOURCE_DIR``、\ ``<PROJECT-NAME>_BINARY_DIR``\ 和\
  ``<PROJECT-NAME>_IS_TOP_LEVEL``\ 始终会被\ ``project(<PROJECT-NAME> ...)``\
  设置为普通变量。参见策略\ :policy:`CMP0180`。\
  具有相同名称的缓存条目始终按之前的方式设置。

选项
^^^^^^^

选项包括：

``VERSION <version>``
  可选；仅当策略\ :policy:`CMP0048`\ 设置为\ ``NEW``\ 时方可使用。

  接受由非负整数组件组成的 ``<version>`` 参数，即\ ``<major>[.<minor>[.<patch>[.<tweak>]]]``，\
  并设置变量

  * :variable:`PROJECT_VERSION`,
    :variable:`<PROJECT-NAME>_VERSION`
  * :variable:`PROJECT_VERSION_MAJOR`,
    :variable:`<PROJECT-NAME>_VERSION_MAJOR`
  * :variable:`PROJECT_VERSION_MINOR`,
    :variable:`<PROJECT-NAME>_VERSION_MINOR`
  * :variable:`PROJECT_VERSION_PATCH`,
    :variable:`<PROJECT-NAME>_VERSION_PATCH`
  * :variable:`PROJECT_VERSION_TWEAK`,
    :variable:`<PROJECT-NAME>_VERSION_TWEAK`.

  .. versionadded:: 3.12
    当从顶层\ ``CMakeLists.txt``\ 调用\ ``project()``\ 命令时，版本号也会存储在变量\
    :variable:`CMAKE_PROJECT_VERSION`\ 中。

``COMPAT_VERSION <version>``
  .. versionadded:: 4.3

  可选；要求同时设置\ ``VERSION``。

  接受一个由非负整数组件组成的\ ``<version>``\ 参数， 即\
  ``<major>[.<minor>[.<patch>[.<tweak>]]]``\ ， 并设置以下变量

  * :variable:`PROJECT_COMPAT_VERSION`,
    :variable:`<PROJECT-NAME>_COMPAT_VERSION`.

  当从顶层\ ``CMakeLists.txt``\ 调用\ ``project()``\ 命令时，兼容性版本还会存储\
  在变量\ :variable:`CMAKE_PROJECT_COMPAT_VERSION`\ 中。

``SPDX_LICENSE <license-string>``
  .. versionadded:: 4.3

  可选。
  设置以下变量

  * :variable:`PROJECT_SPDX_LICENSE`,
    :variable:`<PROJECT-NAME>_SPDX_LICENSE`

  为 ``<license-string>``，该值应为 |SPDX|_ (SPDX)
  `许可证表达式`_，用于描述项目整体的许可证，包括随项目分发的文档、资源或其他材料，以及软件产物。
  有关常用许可证及其标识符的列表，请参阅 SPDX `许可证列表`_。有关为单个软件产物指定许可证的信息，\
  请参阅 :prop_tgt:`SPDX_LICENSE` 属性。

  .. note::
    项目许可证\ *不会*\ 用于初始化单个目标的 :prop_tgt:`SPDX_LICENSE` 属性。这使得在\
    导出包信息时指定的包许可证和默认组件许可证具有实际意义。仅 |CPS| 导出会使用此信息。

    项目许可证在某些情况下\ *会*\ 被继承为包许可证。有关更多信息，请参阅 :command:`export`
    和 :command:`install` 命令的 ``PROJECT`` 选项及相关文档。

.. _SPDX: https://spdx.dev/
.. |SPDX| replace:: System Package Data Exchange

.. _License Expression: https://spdx.github.io/spdx-spec/v3.0.1/annexes/spdx-license-expressions/
.. _License List: https://spdx.org/licenses/
.. _许可证表达式: `License Expression`_
.. _许可证列表: `License List`_

``DESCRIPTION <description-string>``
  .. versionadded:: 3.9

  可选。
  设置变量

  * :variable:`PROJECT_DESCRIPTION`, :variable:`<PROJECT-NAME>_DESCRIPTION`

  为\ ``<description-string>``。\
  建议这个描述是一个相对较短的字符串，\
  通常不超过几个词。

  当从顶层\ ``CMakeLists.txt``\ 调用\ ``project()``\ 命令时， 描述也会存储在变量\
  :variable:`CMAKE_PROJECT_DESCRIPTION`\ 中。

  .. versionadded:: 3.12
    添加了\ ``<PROJECT-NAME>_DESCRIPTION``\ 变量。

``HOMEPAGE_URL <url-string>``
  .. versionadded:: 3.12

  可选。 
  设置变量

  * :variable:`PROJECT_HOMEPAGE_URL`, :variable:`<PROJECT-NAME>_HOMEPAGE_URL`

  为\ ``<url-string>``，该URL字符串应为项目的规范主页URL。

  当从顶层\ ``CMakeLists.txt``\ 调用\ ``project()``\ 命令时，此URL还会存储在变量\
  :variable:`CMAKE_PROJECT_HOMEPAGE_URL`\ 中。

``LANGUAGES <language-name>...``
  可选。
  也可以不使用\ ``LANGUAGES``\ 关键字，按照第一种简短语法指定。

  选择构建项目所需的编程语言。

  .. include:: include/SUPPORTED_LANGUAGES.rst

默认情况下，如果未指定语言选项，则会启用\ ``C``\ 和\ ``CXX``。指定语言为\ ``NONE``，\
或者使用\ ``LANGUAGES``\ 关键字且不列出任何语言，可以跳过启用任何语言。

通过\ ``VERSION``、\ ``COMPAT_VERSION``、\ ``SPDX_LICENSE``、\ ``DESCRIPTION``\ 和\ ``HOMEPAGE_URL``\
选项设置的变量旨在用作包元数据和文档中的默认值。:command:`export`\ 和\
:command:`install`\ 命令在生成\ |CPS|\ 包描述时会相应地使用这些值。

.. _`Code Injection`:

代码注入
^^^^^^^^^^^^^^

用户可以定义多个变量，以指定在执行 ``project()`` 命令期间的不同位置要包含的文件。\
以下概述了 ``project()`` 调用期间执行的步骤：

* .. versionadded:: 3.15
    对于每次 ``project()`` 调用，无论项目名称如何，都包含由
    :variable:`CMAKE_PROJECT_INCLUDE_BEFORE` 指定的文件和模块（如果已设置）。

* .. versionadded:: 3.17
    如果 ``project()`` 命令指定 ``<PROJECT-NAME>`` 作为其项目名称，则包含由
    :variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE_BEFORE`
    指定的文件和模块（如果已设置）。

* 设置上面\ `概要`_\ 和\ `选项`_\ 部分中详述的各种项目特定变量。

* 仅针对第一次 ``project()`` 调用：

  * 如果 :variable:`CMAKE_TOOLCHAIN_FILE` 已设置，则至少读取一次。\
    它可能会被读取多次，并且在稍后启用语言时也可能再次被读取（见下文）。

  * 设置描述主机和目标平台的变量。此时语言特定变量可能已设置，也可能尚未设置。\
    在首次运行时，可能已定义的唯一语言特定变量是工具链文件可能已设置的变量。\
    在后续运行中，可能会设置从先前运行中缓存的语言特定变量。

  * .. versionadded:: 3.24
      包含 :variable:`CMAKE_PROJECT_TOP_LEVEL_INCLUDES` 中列出的每个文件，\
      如果已设置。此后 CMake 将忽略该变量。

* 启用调用中指定的任何语言，如果未提供则启用默认语言。当首次启用某种语言时，可能会重新\
  读取工具链文件。

* .. versionadded:: 3.15
    对于每次 ``project()`` 调用，无论项目名称如何，都包含由
    :variable:`CMAKE_PROJECT_INCLUDE` 指定的文件和模块（如果已设置）。

* 如果 ``project()`` 命令指定 ``<PROJECT-NAME>`` 作为其项目名称，则包含由
  :variable:`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE`
  指定的文件和模块（如果已设置）。

用法
^^^^^

项目的顶层 ``CMakeLists.txt`` 文件必须包含对 ``project()`` 命令的直接调用；\
通过 :command:`include` 命令加载是不够的。如果不存在此类调用，CMake 将发出警告，\
并在顶层假装存在一个 ``project(Project)`` 以启用默认语言（ ``C`` 和 ``CXX`` ）。

.. note::
  在顶层 ``CMakeLists.txt`` 的靠近顶部位置调用 ``project()`` 命令，但必须在调用
  :command:`cmake_minimum_required` *之后*。在调用其他可能受版本和策略设置影响\
  行为的命令之前建立这些设置非常重要，因此如果未保持此顺序， ``project()`` 命令将\
  发出警告。另见策略 :policy:`CMP0000`。

.. |CPS| replace:: Common Package Specification
