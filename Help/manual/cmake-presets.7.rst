.. cmake-manual-description: CMakePresets.json

cmake-presets(7)
****************

.. only:: html

   .. contents::

引言
============

.. versionadded:: 3.19

CMake用户经常面临的一个问题是与其他人共享配置项目的常用方法。这样做可能是为了支持CI构建，或\
者是为了经常使用相同构建的用户。CMake支持两个主要文件，\ ``CMakePresets.json``\ 和\
``CMakeUserPresets.json``，它们允许用户指定通用的配置选项并与他人共享。CMake也支持包含在\
``include``\ 字段中的文件。

``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 存在于项目的根目录中。它们都具\
有完全相同的格式，并且都是可选的（尽管如果指定了\ :option:`--preset <cmake --preset>`，\
则必须至少存在一个）。\ ``CMakePresets.json``\ 旨在指定项目范围内的构建细节，而\
``CMakeUserPresets.json``\ 旨在让开发人员指定他们自己的本地构建细节。

``CMakePresets.json``\ 可能会被签入版本控制系统，而\ ``CMakeUserPresets.json``\ 则不\
应被签入。例如，如果一个项目正在使用Git, ``CMakePresets.json``\ 可能会被跟踪，\
``CMakeUserPresets.json``\ 应该被添加到\ ``.gitignore``\ 中。

格式
======

这些文件是一个JSON文档，以一个对象作为根：

.. literalinclude:: presets/example.json
  :language: json

根对象识别以下字段：

``$schema``
  一个可选字符串，它向描述该JSON文档结构的JSON模式提供一个URI。该字段用于在支持JSON模式的\
  编辑器中进行验证和自动完成。它不会影响文档本身的行为。如果没有指定这个字段，JSON文档仍然有\
  效，但是使用JSON模式进行验证和自动完成的工具可能无法正常工作。这在指定版本\ ``8``\ 或以\
  上的预设文件中是允许的。

``version``
  必需的整数，表示JSON模式的版本。支持的版本有：

  ``1``
    .. versionadded:: 3.19

  ``2``
    .. versionadded:: 3.20

  ``3``
    .. versionadded:: 3.21

  ``4``
    .. versionadded:: 3.23

  ``5``
    .. versionadded:: 3.24

  ``6``
    .. versionadded:: 3.25

  ``7``
    .. versionadded:: 3.27

  ``8``
    .. versionadded:: 3.28

  ``9``
    .. versionadded:: 3.30

``cmakeMinimumRequired``
  一个可选对象，表示构建此项目所需的CMake的最小版本。该节点由以下字段组成：

  ``major``
    一个可选的整数，表示主版本。

  ``minor``
    一个可选的整数，表示次版本。

  ``patch``
    一个可选的整数，表示补丁版本。

``include``
  表示要包含的文件的可选字符串数组。如果文件名不是绝对的，则认为它们是相对于当前文件的。这在\
  指定版本\ ``4``\ 或以上的预设文件中是允许的。有关所包含文件的约束的讨论，请参阅\ `包含`_。

``vendor``
  一个可选的映射，包含特定于供应商的信息。CMake不会解释这个字段的内容，除非验证它是否存在。\
  但是，密钥应该是特定于供应商的域名，后跟以\ ``/``\ 分隔的路径。例如，示例IDE 1.0可以使用\
  ``example.com/ExampleIDE/1.0``。每个字段的值可以是供应商想要的任何值，但通常是一个映射。

``configurePresets``
  `配置预设`_\ 对象的可选数组。
  在指定版本\ ``1``\ 或更高版本的预设文件中允许这样做。

``buildPresets``
  `构建预设`_\ 对象的可选数组。
  在指定版本\ ``2``\ 或更高版本的预设文件中允许这样做。

``testPresets``
  `测试预设`_\ 对象的可选数组。
  在指定版本\ ``2``\ 或更高版本的预设文件中允许这样做。

``packagePresets``
  `包预设`_\ 对象的可选数组。
  在指定版本\ ``6``\ 或更高版本的预设文件中允许这样做。

``workflowPresets``
  `工作流预设`_\ 对象的可选数组。
  在指定版本\ ``6``\ 或更高版本的预设文件中允许这样做。

包含
^^^^^^^^

``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 可以在文件版本\ ``4``\ 及以后\
包含\ ``include``\ 字段的其他文件。这些文件包含的文件还可以包含其他文件。如果\
``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 都存在，\
``CMakeUserPresets.json``\ 隐式包含\ ``CMakePresets.json``，即使没有\ ``include``\
字段，在所有版本的格式。

如果一个预置文件包含从另一个文件中的预置继承的预置，则该文件必须直接或间接地包含另一个文件。\
文件之间不允许包含循环。如果\ ``a.json``\ 包含\ ``b.json``，\ ``b.json``\ 不能包含\
``a.json``。但是，一个文件可能会从同一个文件或不同的文件中被包含多次。

``CMakePresets.json``\ 中直接或间接包含的文件应保证由项目提供。\ ``CMakeUserPresets.json``\
可以包含来自任何地方的文件。

从版本\ ``7``\ 开始，\ ``include``\ 字段支持\ `宏扩展`_，但只支持\ ``$penv{}``\ 宏扩展。 Starting from version
``9``, other macro expansions are also available, except for ``$env{}`` and
preset-specific macros, i.e., those derived from the fields inside a preset's
definition like ``presetName``.

配置预设
^^^^^^^^^^^^^^^^

``configurePresets``\ 数组的每个条目都是一个JSON对象，可能包含以下字段：

``name``
  必需的字符串，表示预设的机器友好的名称。这个标识符在\ :ref:`cmake --preset <CMake Options>`\
  选项中使用。\ ``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 的联合目录下，\
  不能有两个同名的配置预置。但是，配置预设可能与构建、测试、包或工作流预设具有相同的名称。

``hidden``
  一个可选的布尔值，指定是否应该隐藏预设。如果预设是隐藏的，它不能在\ ``--preset=``\ 参数\
  中使用，不会显示在\ :manual:`CMake GUI <cmake-gui(1)>`\ 中，并且不必有一个有效的\
  ``generator``\ 或\ ``binaryDir``，即使是从继承。\ ``hidden``\ 预设被用作其他预设通过\
  ``inherits``\ 字段继承的基础。

``inherits``
  一个可选的字符串数组，表示要继承的预设的名称。该字段也可以是字符串，相当于包含一个字符串的数组。

  默认情况下，预设将继承\ ``inherits``\ 预设中的所有字段（除了\ ``name``、\ ``hidden``、\
  ``inherits``、\ ``description``\ 和\ ``displayName``），但是可以根据需要覆盖它们。\
  如果多个\ ``inherits``\ 预设为同一字段提供冲突的值，则优先选择\ ``inherits``\ 数组中\
  较早的预设。

  预设只能从定义在同一文件或其包含的其中一个文件中的另一个预设继承（直接或间接）。\
  ``CMakePresets.json``\ 中的预置不能继承\ ``CMakeUserPresets.json``\ 中的预置。

``condition``
  一个可选的\ `条件`_\ 对象。这在指定版本\ ``3``\ 或以上的预设文件中是允许的。

``vendor``
  一个可选的映射，包含特定于供应商的信息。CMake不会解释这个字段的内容，除非验证它是否存在。\
  但是，它应该遵循与根级\ ``vendor``\ 字段相同的约定。如果供应商使用他们自己预置的\
  ``vendor``\ 字段，他们应该在适当的时候以合理的方式实现继承。

``displayName``
  一个可选字符串，具有预设的人性化名称。

``description``
  一个可选的字符串，具有对预设的人性化描述。

``generator``
  一个可选字符串，表示要用于预设的生成器。如果未指定\ ``generator``，则必须从所\
  ``inherits``\ 的预设继承（除非该预设是\ ``hidden``）。在版本\ ``3``\ 或更高版本中，可\
  以省略此字段以返回到常规生成器发现过程。

  请注意，对于Visual Studio生成器，与命令行\ :option:`-G <cmake -G>`\ 参数不同，你不能\
  在生成器名称中包含平台名称。请使用\ ``architecture``\ 字段。

``architecture``, ``toolset``
  可选字段，分别表示支持它们的\ :manual:`generators <cmake-generators(7)>`\ 的平台和\
  工具集。

  请参阅\ :option:`cmake -A`\ 选项了解\ ``architecture``\ 的可能值，并参阅\
  :option:`cmake -T`\ 了解\ ``toolset``。

  每个字段都可以是字符串或具有以下字段的对象：

  ``value``
    表示值的可选字符串。

  ``strategy``
    一个可选的字符串，告诉CMake如何处理\ ``architecture``\ 或\ ``toolset``\ 字段。有\
    效值为：

    ``"set"``
      设置各自的值。这将导致不支持相应字段的生成器出现错误。

    ``"external"``
      即使生成器支持该值，也不要设置该值。例如，如果预设使用Ninja生成器，并且IDE知道如何从\
      ``architecture``\ 和\ ``toolset``\ 字段设置Visual C++环境，则这很有用。在这种情\
      况下，CMake将忽略该字段，但IDE可以在调用CMake之前使用它们来设置环境。

    如果没有给出\ ``strategy``\ 字段，或者该字段使用字符串形式而不是对象形式，则行为与\
    ``"set"``\ 相同。

``toolchainFile``
  表示工具链文件路径的可选字符串。该字段支持\ `宏扩展`_。如果指定了相对路径，则计算相对于构\
  建目录的路径，如果没有找到，则计算相对于源目录的路径。该字段优先于\
  :variable:`CMAKE_TOOLCHAIN_FILE`\ 的任何值。在指定版本\ ``3``\ 或更高版本的预设文件\
  中允许使用。

``binaryDir``
  一个可选字符串，表示输出二进制目录的路径。该字段支持\ `宏扩展`_.。如果指定了相对路径，则计\
  算相对于源目录的路径。如果未指定\ ``binaryDir``，则必须从\ ``inherits``\ 预设继承（除\
  非该预设是\ ``hidden``）。在版本\ ``3``\ 或更高版本中，此字段可能被省略。

``installDir``
  表示安装目录路径的可选字符串。该字段支持\ `宏扩展`_。如果指定了相对路径，则计算相对于源目\
  录的路径。这在指定版本\ ``3``\ 或以上的预设文件中是允许的。

``cmakeExecutable``
  一个可选的字符串，表示用于此预设的CMake可执行文件的路径。这是保留给IDE使用的，而不是由\
  CMake本身使用。使用该字段的IDE应该展开其中的任何宏。

``cacheVariables``
  缓存变量的可选映射。关键字是变量名（可能不是空字符串），值要么为\ ``null``，要么为布尔值\
  （相当于\ ``"TRUE"``\ 或\ ``"FALSE"``\ 的值和\ ``BOOL``\ 类型），要么为表示变量值的\
  字符串（支持\ `宏扩展`_），要么为具有以下字段的对象：

  ``type``
    表示变量类型的可选字符串。

  ``value``
    表示变量值的必需字符串或布尔值。布尔值相当于\ ``"TRUE"``\ 或\ ``"FALSE"``。该字段支持\
    `宏扩展`_。

  缓存变量通过\ ``inherits``\ 字段继承，预设的变量将是它自己的\ ``cacheVariables``\ 和\
  它所有父变量的\ ``cacheVariables``\ 的联合。如果此联合中的多个预设定义了相同的变量，则\
  应用\ ``inherits``\ 的标准规则。将变量设置为\ ``null``\ 将导致不设置该变量，即使该值是\
  从另一个预设继承的。

``environment``
  环境变量的可选映射。关键字是变量名（可能不是空字符串），值要么为\ ``null``，要么为表示变\
  量值的字符串。无论进程的环境是否给每个变量赋值，都会设置它。该字段支持\ `宏扩展`_，并且该\
  映射中的环境变量可以相互引用，并且可以以任何顺序列出，只要这些引用不引起循环（例如，如果\
  ``ENV_1``\ 是\ ``$env{ENV_2}``，则\ ``ENV_2``\ 不可是\ ``$env{ENV_1}``）。

  环境变量通过\ ``inherits``\ 字段继承，预设的环境将是它自己的\ ``environment``\ 和来自\
  所有父\ ``environment``\ 的环境的结合。如果此联合中的多个预设定义了相同的变量，则应用\
  ``inherits``\ 的标准规则。将变量设置为\ ``null``\ 将导致不设置该变量，即使该值是从另一\
  个预设继承的。

``warnings``
  一个可选对象，指定要启用的警告。该对象可以包含以下字段：

  ``dev``
    可选的布尔值。相当于在命令行上传递\ :option:`-Wdev <cmake -Wdev>`\ 或\
    :option:`-Wno-dev <cmake -Wno-dev>` 。如果\ ``errors.dev``\ 被设置为\ ``true``，\
    这个值可能不会被设置为\ ``false``。

  ``deprecated``
    可选的布尔值。相当于在命令行上传递\ :option:`-Wdeprecated <cmake -Wdeprecated>`\
    或\ :option:`-Wno-deprecated <cmake -Wno-deprecated>`。如果\ ``errors.deprecated``\
    被设置为\ ``true``，则该值可能不会被设置为\ ``false``。

  ``uninitialized``
    可选的布尔值。将其设置为\ ``true``\ 相当于在命令行上传递\
    :option:`--warn-uninitialized <cmake --warn-uninitialized>`。

  ``unusedCli``
    可选的布尔值。将其设置为\ ``false``\ 相当于在命令行上传递\
    :option:`--no-warn-unused-cli <cmake --no-warn-unused-cli>`。

  ``systemVars``
    可选的布尔值。将其设置为\ ``true``\ 相当于在命令行上传递\
    :option:`--check-system-vars <cmake --check-system-vars>`。

``errors``
  一个可选对象，指定要启用的错误。该对象可以包含以下字段：

  ``dev``
    可选的布尔值。相当于在命令行上传递\ :option:`-Werror=dev <cmake -Werror>`\ 或\
    :option:`-Wno-error=dev <cmake -Werror>`。如果\ ``warnings.dev``\ 设置为\
    ``false``，则可能不会将其设置为\ ``true``。

  ``deprecated``
    可选的布尔值。相当于在命令行上传递\ :option:`-Werror=deprecated <cmake -Werror>`\
    或\ :option:`-Wno-error=deprecated <cmake -Werror>`。如果\ ``warnings.deprecated``\
    设置为\ ``false``，则可能不会将其设置为\ ``true``。

``debug``
  指定调试选项的可选对象。该对象可以包含以下字段：

  ``output``
    可选的布尔值。将其设置为\ ``true``\ 相当于在命令行上传递\
    :option:`--debug-output <cmake --debug-output>`。

  ``tryCompile``
    可选的布尔值。将其设置为\ ``true``\ 相当于在命令行上传递\
    :option:`--debug-trycompile <cmake --debug-trycompile>`。

  ``find``
    可选的布尔值。将其设置为\ ``true``\ 相当于在命令行上传递\
    :option:`--debug-find <cmake --debug-find>`。

``trace``
  指定跟踪选项的可选对象。这在指定版本\ ``7``\ 的预设文件中是允许的。该对象可以包含以下字段：

  ``mode``
    指定跟踪模式的可选字符串。有效值为：

    ``on``
      导致所有调用的跟踪，以及从哪里打印。相当于在命令行上传递\
      :option:`--trace <cmake --trace>`。

    ``off``
      不会打印所有调用的跟踪。

    ``expand``
      使用展开的所有调用的变量和要从何处打印的变量进行跟踪。相当于在命令行上传递\
      :option:`--trace-expand <cmake --trace-expand>`。

  ``format``
    指定跟踪的格式输出的可选字符串。有效值为：

    ``human``
      以人类可读的格式打印每个跟踪行。这是默认格式。相当于在命令行上传递\
      :option:`--trace-format=human <cmake --trace-format>`。

    ``json-v1``
      将每行打印为单独的JSON文档。相当于在命令行上传递\
      :option:`--trace-format=json-v1 <cmake --trace-format>`。

  ``source``
    表示要跟踪的源文件路径的可选字符串数组。该字段也可以是字符串，相当于包含一个字符串的数组。\
    相当于在命令行上传递\ :option:`--trace-source <cmake --trace-source>`。

  ``redirect``
    指定跟踪输出文件路径的可选字符串。相当于在命令行上传递\
    :option:`--trace-redirect <cmake --trace-redirect>`。

构建预设
^^^^^^^^^^^^

``buildPresets``\ 数组的每个条目都是一个JSON对象，可能包含以下字段：

``name``
  必需的字符串，表示预设的机器友好的名称。这个标识符在\
  :ref:`cmake --build --preset <Build Tool Mode>`\ 选项中使用。在\
  ``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 的联合目录中，不能有两个构建\
  预置，且名称相同。但是，构建预设可能与配置、测试、打包或工作流预设具有相同的名称。

``hidden``
  一个可选的布尔值，指定是否应该隐藏预设。如果一个预设是隐藏的，那么它就不能在\
  :option:`--preset <cmake --preset>`\ 参数中使用，也不必有一个有效的\
  ``configurePreset``，即使是从继承中也是如此。\ ``hidden``\ 预设被用作其他预设通过\
  ``inherits``\ 字段继承的基础。

``inherits``
  一个可选的字符串数组，表示要继承的预设的名称。该字段也可以是字符串，相当于包含一个字符串的\
  数组。

  默认情况下，预设将继承\ ``inherits``\ 预设中的所有字段（除了\ ``name``、\ ``hidden``、\
  ``inherits``、\ ``description``\ 和\ ``displayName``），但是可以根据需要覆盖它们。\
  如果多个\ ``inherits``\ 预设为同一字段提供冲突的值，则优先选择\ ``inherits``\ 数组中\
  较早的预设。

  预设只能从定义在同一文件或其包含的其中一个文件中的另一个预设继承（直接或间接）。\
  ``CMakePresets.json``\ 中的预置不能继承\ ``CMakeUserPresets.json``\ 中的预置。

``condition``
  可选的\ `条件`_\ 对象。这在指定版本\ ``3``\ 或以上的预设文件中是允许的。

``vendor``
  一个可选的映射，包含特定于供应商的信息。CMake不会解释这个字段的内容，除非验证它是否存在。\
  但是，它应该遵循与根级\ ``vendor``\ 字段相同的约定。如果供应商使用他们自己预置的\
  ``vendor``\ 字段，他们应该在适当的时候以合理的方式实现继承。

``displayName``
  一个可选字符串，具有预设的人性化名称。

``description``
  一个可选的字符串，具有对预设的人性化描述。

``environment``
  环境变量的可选映射。关键字是变量名（可能不是空字符串），值要么为\ ``null``，要么为表示变\
  量值的字符串。无论进程的环境是否给每个变量赋值，都会设置它。该字段支持宏扩展，并且该映射中\
  的环境变量可以相互引用，并且可以以任何顺序列出，只要这些引用不引起循环（例如，如果\
  ``ENV_1``\ 是\ ``$env{ENV_2}``，则\ ``ENV_2``\ 不能是\ ``$env{ENV_1}``）。

  环境变量通过\ ``inherits``\ 字段继承，预设的环境将是它自己的\ ``environment``\ 和来\
  自所有父\ ``environment``\ 的环境的结合。如果此联合中的多个预设定义了相同的变量，则应用\
  ``inherits``\ 的标准规则。将变量设置为\ ``null``\ 将导致不设置该变量，即使该值是从另一\
  个预设继承的。

  .. note::

    对于使用ExternalProject的CMake项目，使用具有ExternalProject中需要的环境变量的配置\
    预置，使用继承该配置预置的构建预置，否则ExternalProject将不会在配置预置中设置环境变量。\
    示例：假设主机默认使用一个编译器（比如Clang），而用户希望使用另一个编译器（比如GCC）。\
    设置配置预设环境变量\ ``CC``\ 和\ ``CXX``，并使用继承该配置预设的构建预设。否则，\
    ExternalProject可能会使用与顶级CMake项目不同的（系统默认）编译器。

``configurePreset``
  一个可选字符串，指定要与此生成预设关联的配置预设的名称。如果未指定\ ``configurePreset``，\
  则必须从所继承的预设中继承（除非该预设是隐藏的）。构建目录是从配置预设中推断出来的，因此构\
  建将在与配置相同的\ ``binaryDir``\ 中进行。

``inheritConfigureEnvironment``
  默认为true的可选布尔值。如果为true，则在所有继承的构建预设环境之后，但在此构建预设中显式\
  指定的环境变量之前，继承相关配置预设的环境变量。

``jobs``
  可选整数。相当于在命令行上传递\ :option:`--parallel <cmake--build --parallel>`\ 或\
  ``-j``。

``targets``
  一个可选的字符串或字符串数组。相当于在命令行上传递\
  :option:`--target <cmake--build --target>`\ 或\ ``-t``。供应商可以忽略目标属性或隐\
  藏显式指定目标的构建预设。该字段支持宏扩展。

``configuration``
  可选字符串。相当于在命令行上传递\ :option:`--config <cmake--build --config>`。

``cleanFirst``
  可选bool。如果为true，相当于在命令行上传递\
  :option:`--clean-first <cmake--build --clean-first>`。

``resolvePackageReferences``
  指定包解析模式的可选字符串。这在指定版本\ ``4``\ 或以上的预设文件中是允许的。

  包引用用于定义对来自外部包管理器的包的依赖。目前只支持NuGet与Visual Studio生成器的组合。\
  如果没有定义包引用的目标，则此选项不执行任何操作。有效值为：

  ``on``
    导致在尝试构建之前解析包引用。

  ``off``
    包引用将不会被解析。请注意，这可能会在某些构建环境中导致错误，例如.NET SDK风格的项目。

  ``only``
    仅解析包引用，但不执行构建。

  .. note::

    命令行参数\
    :option:`--resolve-package-references <cmake--build --resolve-package-references>`\
    将优先于此设置。如果未提供命令行参数并且未指定此设置，则将评估特定于环境的缓存变量以决定\
    是否应该执行包恢复。

    当使用Visual Studio生成器时，包引用是使用\ :prop_tgt:`VS_PACKAGE_REFERENCES`\ 属\
    性定义的。使用NuGet恢复包引用。可以通过将\ ``CMAKE_VS_NUGET_PACKAGE_RESTORE``\ 变\
    量设置为\ ``OFF``\ 来禁用它。这也可以在配置预设中完成。

``verbose``
  可选bool。如果为true，相当于在命令行上传递\ :option:`--verbose <cmake--build --verbose>`。

``nativeToolOptions``
  一个可选的字符串数组。相当于在命令行上在\ ``--``\ 之后传递选项。数组值支持宏扩展。

测试预设
^^^^^^^^^^^

``testPresets``\ 数组的每个条目都是一个JSON对象，可能包含以下字段：

``name``
  必需的字符串，表示预设的机器友好的名称。这个标识符在\ :option:`ctest --preset`\ 选项中\
  使用。\ ``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 的联合目录中不能有\
  两个测试预置，且名称相同。然而，测试预设可能与配置、构建、打包或工作流预设具有相同的名称。

``hidden``
  一个可选的布尔值，指定是否应该隐藏预设。如果一个预设是隐藏的，那么它就不能在\
  :option:`--preset <ctest --preset>`\ 参数中使用，也不必有一个有效的\
  ``configurePreset``，即使是从继承中也是如此。\ ``hidden``\ 预设被用作其他预设通过\
  ``inherits``\ 字段继承的基础。

``inherits``
  一个可选的字符串数组，表示要继承的预设的名称。该字段也可以是字符串，相当于包含一个字符串的\
  数组。

  默认情况下，预设将继承\ ``inherits``\ 预设中的所有字段（除了\ ``name``、\ ``hidden``、\
  ``inherits``、\ ``description``\ 和\ ``displayName``），但是可以根据需要覆盖它们。\
  如果多个\ ``inherits``\ 预设为同一字段提供冲突的值，则优先选择\ ``inherits``\ 数组中\
  较早的预设。

  预设只能从定义在同一文件或其包含的其中一个文件中的另一个预设继承（直接或间接）。\
  ``CMakePresets.json``\ 中的预置不能继承\ ``CMakeUserPresets.json``\ 中的预置。

``condition``
  一个可选的\ `条件`_\ 对象。这在指定版本\ ``3``\ 或以上的预设文件中是允许的。

``vendor``
  一个可选的映射，包含特定于供应商的信息。CMake不会解释这个字段的内容，除非验证它是否存在。\
  但是，它应该遵循与根级\ ``vendor``\ 字段相同的约定。如果供应商使用他们自己预置的\
  ``vendor``\ 字段，他们应该在适当的时候以合理的方式实现继承。

``displayName``
  一个可选字符串，具有预设的人性化名称。

``description``
  一个可选的字符串，具有对预设的人性化描述。

``environment``
  环境变量的可选映射。关键字是变量名（可能不是空字符串），值要么为\ ``null``，要么为表示变\
  量值的字符串。无论进程的环境是否给每个变量赋值，都会设置它。该字段支持宏扩展，并且该映射中\
  的环境变量可以相互引用，并且可以以任何顺序列出，只要这些引用不引起循环（例如，如果\
  ``ENV_1``\ 是\ ``$env{ENV_2}``，则\ ``ENV_2``\ 不可是\ ``$env{ENV_1}``）。

  环境变量通过\ ``inherits``\ 字段继承，预设的环境将是它自己的\ ``environment``\ 和来\
  自所有父\ ``environment``\ 环境的结合。如果此联合中的多个预设定义了相同的变量，则应用\
  ``inherits``\ 的标准规则。将变量设置为\ ``null``\ 将导致不设置该变量，即使该值是从另一\
  个预设继承的。

``configurePreset``
  一个可选字符串，指定要与此测试预置关联的配置预置的名称。如果未指定\ ``configurePreset``，\
  则必须从所继承的预设中继承（除非该预设是隐藏的）。构建目录是从配置预设中推断出来的，因此测\
  试将在配置和构建所使用的相同的\ ``binaryDir``\ 中运行。

``inheritConfigureEnvironment``
  默认为true的可选布尔值。如果为true，则在所有继承的测试预设环境之后，但是在此测试预设中显\
  式指定的环境变量之前，从关联的配置预设中继承环境变量。

``configuration``
  可选字符串。相当于在命令行上传递\ :option:`--build-config <ctest --build-config>`。

``overwriteConfigurationFile``
  一个可选的配置选项数组，用于覆盖CTest配置文件中指定的选项。相当于为数组中的每个值传递\
  :option:`--overwrite <ctest --overwrite>`。数组值支持宏扩展。

``output``
  指定输出选项的可选对象。该对象可以包含以下字段。

  ``shortProgress``
    可选bool。如果为true，相当于在命令行上传递\ :option:`--progress <ctest --progress>`。

  ``verbosity``
    指定冗长级别的可选字符串。必须是下列之一：

    ``default``
      相当于在命令行上不传递冗长标志。

    ``verbose``
      相当于在命令行上传递\ :option:`--verbose <ctest --verbose>`。

    ``extra``
      相当于在命令行上传递\ :option:`--extra-verbose <ctest --extra-verbose>`。

  ``debug``
    可选bool。如果为true，相当于在命令行上传递\ :option:`--debug <ctest --debug>`。

  ``outputOnFailure``
    可选bool。如果为真，相当于在命令行上传递\
    :option:`--output-on-failure <ctest --output-on-failure>`。

  ``quiet``
    可选bool。如果为true，相当于在命令行上传递\ :option:`--quiet <ctest --quiet>`。

  ``outputLogFile``
    指定日志文件路径的可选字符串。相当于在命令行上传递\
    :option:`--output-log <ctest --output-log>`。该字段支持宏扩展。

  ``outputJUnitFile``
    指定JUnit文件路径的可选字符串。相当于在命令行上传递\
    :option:`--output-junit <ctest --output-junit>`。该字段支持宏扩展。这在指定版本\
    ``6``\ 或以上的预设文件中是允许的。

  ``labelSummary``
    可选bool。如果为false，相当于在命令行上传递\
    :option:`--no-label-summary <ctest --no-label-summary>`。

  ``subprojectSummary``
    可选bool。如果为false，相当于在命令行上传递\
    :option:`--no-subproject-summary <ctest --no-subproject-summary>`。

  ``maxPassedTestOutputSize``
    可选整数，以字节为单位指定通过测试的最大输出。相当于在命令行上传递\
    :option:`--test-output-size-passed <ctest --test-output-size-passed>`。

  ``maxFailedTestOutputSize``
    可选整数，以字节为单位指定失败测试的最大输出。相当于在命令行上传递\
    :option:`--test-output-size-failed <ctest --test-output-size-failed>`。

  ``testOutputTruncation``
    指定测试输出截断模式的可选字符串。相当于在命令行上传递\
    :option:`--test-output-truncation <ctest --test-output-truncation>`。这在指定\
    版本\ ``5``\ 或以上的预设文件中是允许的。

  ``maxTestNameWidth``
    可选整数，指定要输出的测试名的最大宽度。相当于在命令行上传递\
    :option:`--max-width <ctest --max-width>`。

``filter``
  指定如何筛选要运行的测试的可选对象。该对象可以包含以下字段。

  ``include``
    指定要包含哪些测试的可选对象。该对象可以包含以下字段。

    ``name``
      一个可选字符串，指定测试名称的正则表达式。相当于在命令行上传递\
      :option:`--tests-regex <ctest --tests-regex>`。该字段支持宏扩展。CMake正则表\
      达式语法在\ :ref:`string(REGEX) <Regex Specification>`\ 下描述。

    ``label``
      一个可选字符串，指定测试标签的正则表达式。相当于在命令行上传递\
      :option:`--label-regex <ctest --label-regex>`。该字段支持宏扩展。

    ``useUnion``
      可选bool。相当于在命令行上传递\ :option:`--union <ctest --union>`。

    ``index``
      一个可选对象，按测试索引指定要包含的测试。该对象可以包含以下字段。也可以是一个可选字符\
      串，用命令行语法\ :option:`--tests-information <ctest --tests-information>`\
      指定一个文件。如果指定为字符串，则此字段支持宏展开。

      ``start``
        一个可选的整数，指定要开始测试的测试索引。

      ``end``
        一个可选整数，指定要停止测试的测试索引。

      ``stride``
        指定增量的可选整数。

      ``specificTests``
        一个可选的整数数组，指定要运行的特定测试索引。

  ``exclude``
    指定要排除哪些测试的可选对象。该对象可以包含以下字段。

    ``name``
      一个可选字符串，指定测试名称的正则表达式。相当于在命令行上传递\
      :option:`--exclude-regex <ctest --exclude-regex>`。该字段支持宏扩展。

    ``label``
      一个可选字符串，指定测试标签的正则表达式。相当于在命令行上传递\
      :option:`--label-exclude <ctest --label-exclude>`。该字段支持宏扩展。

    ``fixtures``
      一个可选对象，指定要从添加测试中排除哪些fixture。该对象可以包含以下字段。

      ``any``
        一个可选字符串，指定要在添加任何测试时排除的文本fixture的正则表达式。相当于命令行上\
        的\ :option:`--fixture-exclude-any <ctest --fixture-exclude-any>`。该字段\
        支持宏扩展。

      ``setup``
        一个可选字符串，指定要在添加安装测试时排除的文本fixture的正则表达式。相当于命令行上\
        的\ :option:`--fixture-exclude-setup <ctest --fixture-exclude-setup>`。\
        该字段支持宏扩展。

      ``cleanup``
        一个可选字符串，指定要在添加清理测试时排除的文本fixture的正则表达式。相当于命令行上\
        的\ :option:`--fixture-exclude-cleanup <ctest --fixture-exclude-cleanup>`。\
        该字段支持宏扩展。

``execution``
  指定测试执行选项的可选对象。该对象可以包含以下字段。

  ``stopOnFailure``
    可选bool。如果为true，相当于在命令行上传递\
    :option:`--stop-on-failure <ctest --stop-on-failure>`。

  ``enableFailover``
    可选bool。如果为true，相当于在命令行上传递\ :option:`-F <ctest -F>`。

  ``jobs``
    可选整数。相当于在命令行上传递\
    :option:`--parallel <ctest --parallel>` on the command line。

  ``resourceSpecFile``
    可选字符串。相当于在命令行上传递\
    :option:`--resource-spec-file <ctest --resource-spec-file>`。该字段支持宏扩展。

  ``testLoad``
    可选整数。相当于在命令行上传递\ :option:`--test-load <ctest --test-load>`。

  ``showOnly``
    可选字符串。相当于在命令行上传递\ :option:`--show-only <ctest --show-only>`。字符\
    串必须是以下值之一：

    ``human``

    ``json-v1``

  ``repeat``
    指定如何重复测试的可选对象。相当于在命令行上传递\ :option:`--repeat <ctest --repeat>`。\
    该对象必须具有以下字段。

    ``mode``
      必需的字符串。必须是以下值之一：

      ``until-fail``

      ``until-pass``

      ``after-timeout``

    ``count``
      必需的整数。

  ``interactiveDebugging``
    可选bool。如果为true，相当于在命令行上传递\
    :option:`--interactive-debug-mode 1 <ctest --interactive-debug-mode>`。如果\
    为false，相当于在命令行上传递\
    :option:`--interactive-debug-mode 0 <ctest --interactive-debug-mode>`。

  ``scheduleRandom``
    可选bool。如果为true，相当于在命令行上传递\
    :option:`--schedule-random <ctest --schedule-random>`。

  ``timeout``
    可选整数。相当于在命令行上传递\ :option:`--timeout <ctest --timeout>`。

  ``noTestsAction``
    一个可选字符串，指定未找到测试时的行为。必须是以下值之一：

    ``default``
      相当于在命令行上不传递任何值。

    ``error``
      相当于在命令行上传递\ :option:`--no-tests=error <ctest --no-tests>`。

    ``ignore``
      相当于在命令行上传递\ :option:`--no-tests=ignore <ctest --no-tests>`。

包预设
^^^^^^^^^^^^^^

包预设可以在架构版本\ ``6``\ 或更高版本中使用。\ ``packagePresets``\ 数组的每个条目都是\
一个JSON对象，可能包含以下字段：

``name``
  必需的字符串，表示预设的机器友好的名称。这个标识符在\ :option:`cpack --preset`\ 选项中\
  使用。在\ ``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 的联合目录中，不\
  能有两个包预置，且名称相同。但是，包预置可能与配置、构建、测试或工作流预置具有相同的名称。

``hidden``
  一个可选的布尔值，指定是否应该隐藏预设。如果一个预设是隐藏的，那么它就不能在\
  :option:`--preset <cpack --preset>`\ 参数中使用，也不必有一个有效的\
  ``configurePreset``，即使是从继承中也是如此。\ ``hidden``\ 预设被用作其他预设通过\
  ``inherits``\ 字段继承的基础。

``inherits``
  一个可选的字符串数组，表示要继承的预设的名称。该字段也可以是字符串，相当于包含一个字符串的数组。

  默认情况下，预设将继承\ ``inherits``\ 预设中的所有字段（除了\ ``name``、\ ``hidden``、\
  ``inherits``、\ ``description``\ 和\ ``displayName``），但是可以根据需要覆盖它们。\
  如果多个\ ``inherits``\ 预设为同一字段提供冲突的值，则优先选择\ ``inherits``\ 数组中\
  较早的预设。

  预设只能从定义在同一文件或其包含的其中一个文件中的另一个预设继承（直接或间接）。\
  ``CMakePresets.json``\ 中的预置不能继承\ ``CMakeUserPresets.json``\ 中的预置。

``condition``
  一个可选的\ `条件`_\ 对象。

``vendor``
  一个可选的映射，包含特定于供应商的信息。CMake不会解释这个字段的内容，除非验证它是否存在。\
  但是，它应该遵循与根级\ ``vendor``\ 字段相同的约定。如果供应商使用他们自己预置的\
  ``vendor``\ 字段，他们应该在适当的时候以合理的方式实现继承。

``displayName``
  一个可选字符串，具有预设的人性化名称。

``description``
  一个可选的字符串，具有对预设的人性化描述。

``environment``
  环境变量的可选映射。关键字是变量名（可能不是空字符串），值要么为\ ``null``，要么为表示变\
  量值的字符串。无论进程的环境是否给每个变量赋值，都会设置它。该字段支持宏扩展，并且该映射中\
  的环境变量可以相互引用，并且可以以任何顺序列出，只要这些引用不引起循环（例如，如果\
  ``ENV_1``\ 是\ ``$env{ENV_2}``，则\ ``ENV_2``\ 不能是\ ``$env{ENV_1}``）。

  环境变量通过\ ``inherits``\ 字段继承，预设的环境将是它自己的\ ``environment``\ 和来\
  自所有父\ ``environment``\ 的环境的结合。如果此联合中的多个预设定义了相同的变量，则应用\
  ``inherits``\ 的标准规则。将变量设置为\ ``null``\ 将导致不设置该变量，即使该值是从另一\
  个预设继承的。

``configurePreset``
  一个可选字符串，指定要与此包预置关联的配置预置的名称。如果未指定\ ``configurePreset``，\
  则必须从所继承的预设中继承（除非该预设是隐藏的）。构建目录是从配置预设中推断出来的，因此打\
  包将在配置和构建所运行的同一个\ ``binaryDir``\ 下运行。

``inheritConfigureEnvironment``
  默认为true的可选布尔值。如果为true，则在所有继承的包预置环境之后，但在此包预置中显式指定\
  的环境变量之前继承相关配置预置的环境变量。

``generators``
  一个可选的字符串数组，表示供CPack使用的生成器。

``configurations``
  一个可选的字符串数组，表示CPack要打包的构建配置。

``variables``
  传递给CPack的可选变量映射，相当于\ :option:`-D <cpack -D>`\ 参数。每个键是一个变量的\
  名称，值是要分配给该变量的字符串。

``configFile``
  一个可选字符串，表示供CPack使用的配置文件。

``output``
  指定输出选项的可选对象。有效的密钥有：

  ``debug``
    一个可选的布尔值，指定是否打印调试信息。值为\ ``true``\ 相当于在命令行上传递\
    :option:`--debug <cpack --debug>`。

  ``verbose``
    一个可选的布尔值，指定是否详细打印。值为\ ``true``\ 等同于在命令行上传递\
    :option:`--verbose <cpack --verbose>`。

``packageName``
  表示包名的可选字符串。

``packageVersion``
  表示包版本的可选字符串。

``packageDirectory``
  一个可选字符串，表示放置包的目录。

``vendorName``
  表示供应商名称的可选字符串。

.. _`Workflow Preset`:

工作流预设
^^^^^^^^^^^^^^^

工作流预设可以在架构版本\ ``6``\ 或更高版本中使用。\ ``workflowPresets``\ 数组的每个条\
目都是一个JSON对象，可能包含以下字段：

``name``
  必需的字符串，表示预设的机器友好的名称。这个标识符在\
  :ref:`cmake --workflow --preset <Workflow Mode>`\ 选项中使用。在\
  ``CMakePresets.json``\ 和\ ``CMakeUserPresets.json``\ 的联合目录中，不能有两个同\
  名的工作流预置。然而，工作流预设可能与配置、构建、测试或包预设具有相同的名称。

``vendor``
  一个可选的映射，包含特定于供应商的信息。CMake不会解释这个字段的内容，除非验证它是否存在。\
  但是，它应该遵循与根级\ ``vendor``\ 字段相同的约定。

``displayName``
  一个可选字符串，具有预设的人性化名称。

``description``
  一个可选的字符串，具有对预设的人性化描述。

``steps``
  描述工作流步骤的必要对象数组。第一步必须是配置预设，所有后续步骤必须是非配置预设，其\
  ``configurePreset``\ 字段与开始的配置预设匹配。每个对象可能包含以下字段：

  ``type``
    必需的字符串。第一步必须\ ``configure``。后续步骤必须是\ ``build``、\ ``test``\ 或\
    ``package``。

  ``name``
    一个必需的字符串，表示作为此工作流步骤运行的配置、构建、测试或包预置的名称。

条件
^^^^^^^^^

指定版本\ ``3``\ 或更高版本的预置文件中允许的预置\ ``condition``\ 字段用于确定是否启用该\
预置。例如，这可以用于在Windows以外的平台上禁用预设。\ ``condition``\ 可以是布尔值、\
``null``\ 或对象。如果是布尔值，则布尔值表示该预置是启用还是禁用。如果为\ ``null``，则启\
用该预设，但任何可能从该预设继承的预设都不会继承\ ``null``\ 条件。子条件（例如\ ``not``、\
``anyOf``\ 或\ ``allOf``\ 条件）不能为\ ``null``。如果它是一个对象，它有以下字段：

``type``
  必须的字符串，具有以下值之一：

  ``"const"``
    指示条件是恒定的。这相当于使用布尔值代替对象。条件对象将具有以下附加字段：

    ``value``
      一个必需的布尔值，它为条件的求值提供一个常量值。

  ``"equals"``

  ``"notEquals"``
    指示条件比较两个字符串，看它们是否相等（或不相等）。条件对象将具有以下附加字段：

    ``lhs``
      第一个要比较的字符串。该字段支持宏扩展。

    ``rhs``
      第二个要比较的字符串。该字段支持宏扩展。

  ``"inList"``

  ``"notInList"``
    指示该条件在字符串列表中搜索字符串。条件对象将具有以下附加字段：

    ``string``
      需要搜索的字符串。该字段支持宏扩展。

    ``list``
      需要搜索的字符串数组。该字段支持宏扩展，并使用短路求值。

  ``"matches"``

  ``"notMatches"``
    表示该条件在字符串中搜索正则表达式。条件对象将具有以下附加字段：

    ``string``
      需要搜索的字符串。该字段支持宏扩展。

    ``regex``
      需要搜索的正则表达式。该字段支持宏扩展。

  ``"anyOf"``

  ``"allOf"``

    指示条件是零个或多个嵌套条件的聚合。条件对象将具有以下附加字段：

    ``conditions``
      必需的条件对象数组。这些条件使用短路求值。

  ``"not"``
    指示条件是另一个条件的反转。条件对象将具有以下附加字段：

    ``condition``
      必需条件对象。

宏扩展
^^^^^^^^^^^^^^^

如上所述，一些字段支持宏扩展。宏的识别形式为\ ``$<macro-namespace>{<macro-name>}``。所\
有宏都在正在使用的预设上下文中求值，即使宏位于从另一个预设继承的字段中。例如，如果\ ``Base``\
预置将变量\ ``PRESET_NAME``\ 设置为\ ``${presetName}``，而\ ``Derived``\ 预置继承自\
``Base``，则\ ``PRESET_NAME``\ 将被设置为\ ``Derived``。

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

  This is a preset-specific macro.

``${generator}``
  在预设的\ ``generator``\ 字段中指定的生成器。对于构建和测试预设，这将计算为\
  ``configurePreset``\ 指定的生成器。

  This is a preset-specific macro.

``${hostSystemName}``
  主机操作系统的名称。与\ :variable:`CMAKE_HOST_SYSTEM_NAME`\ 相同。这在指定版本\
  ``3``\ 或以上的预设文件中是允许的。

``${fileDir}``
  包含包含宏的预设文件的目录的路径。这在指定版本\ ``4``\ 或以上的预设文件中是允许的。

``${dollar}``
  字面上的美元符号（\ ``$``\ ）。

``${pathListSep}``
  分隔路径列表的本地字符，如\ ``:``\ 或\ ``;``。

  例如，通过将\ ``PATH``\ 设置为\ ``/path/to/ninja/bin${pathListSep}$env{PATH}``，\
  ``${pathListSep}``\ 将扩展为用于在\ ``PATH``\ 中连接的底层操作系统的字符。

  这在指定版本\ ``5``\ 或以上的预设文件中是允许的。

``$env{<variable-name>}``
  名称为\ ``<variable-name>``\ 的环境变量。变量名不能是空字符串。如果变量在\
  ``environment``\ 字段中定义，则使用该值而不是来自父环境的值。如果没有定义环境变量，则计\
  算结果为空字符串。

  请注意，虽然Windows环境变量名是不区分大小写的，但预设中的变量名仍然是区分大小写的。当使用\
  不一致的套管时，这可能会导致意想不到的结果。为了获得最佳效果，请保持环境变量名称的大小写一致。

``$penv{<variable-name>}``
  类似于\ ``$env{<variable-name>}``，不同之处在于该值只来自父环境，而不来自\
  ``environment``\ 字段。这允许你在现有环境变量上添加或追加值。例如，将\ ``PATH``\ 设置为\
  ``/path/to/ninja/bin:$penv{PATH}``\ 将把\ ``/path/to/ninja/bin``\ 添加到\ ``PATH``\
  环境变量中。这是必需的，因为\ ``$env{<variable-name>}``\ 不允许循环引用。

``$vendor{<macro-name>}``
  一个扩展点，供供应商插入他们自己的宏。CMake将不能使用带有\ ``$vendor{<macro-name>}``\
  宏的预置，并且会有效地忽略这些预置。但是，它仍然可以使用同一文件中的其他预设。

  CMake不会尝试解释\ ``$vendor{<macro-name>}``\ 宏。但是，为了避免名称冲突，IDE供应商\
  应该在\ ``<macro-name>``\ 前面加上一个非常短的（最好是<=4个字符）供应商标识符前缀，后\
  跟一个\ ``.``，再后跟宏名称。例如，示例IDE可以有\ ``$vendor{xide.ideInstallDir}``。

模式
======

:download:`This file </manual/presets/schema.json>`\ 为\ ``CMakePresets.json``\
格式提供了一个机器可读的JSON模式。
