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

从版本\ ``7``\ 开始，\ ``include``\ 字段支持\ `宏扩展`_，但只支持\ ``$penv{}``\ 宏扩展。

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
  An optional object specifying output options. The object may contain the
  following fields.

  ``shortProgress``
    An optional bool. If true, equivalent to passing
    :option:`--progress <ctest --progress>` on the command line.

  ``verbosity``
    An optional string specifying verbosity level. Must be one of the
    following:

    ``default``
      Equivalent to passing no verbosity flags on the command line.

    ``verbose``
      Equivalent to passing :option:`--verbose <ctest --verbose>` on
      the command line.

    ``extra``
      Equivalent to passing :option:`--extra-verbose <ctest --extra-verbose>`
      on the command line.

  ``debug``
    An optional bool. If true, equivalent to passing
    :option:`--debug <ctest --debug>` on the command line.

  ``outputOnFailure``
    An optional bool. If true, equivalent to passing
    :option:`--output-on-failure <ctest --output-on-failure>` on the command
    line.

  ``quiet``
    An optional bool. If true, equivalent to passing
    :option:`--quiet <ctest --quiet>` on the command line.

  ``outputLogFile``
    An optional string specifying a path to a log file. Equivalent to
    passing :option:`--output-log <ctest --output-log>` on the command line.
    This field supports macro expansion.

  ``outputJUnitFile``
    An optional string specifying a path to a JUnit file. Equivalent to
    passing :option:`--output-junit <ctest --output-junit>` on the command line.
    This field supports macro expansion. This is allowed in preset files
    specifying version ``6`` or above.

  ``labelSummary``
    An optional bool. If false, equivalent to passing
    :option:`--no-label-summary <ctest --no-label-summary>` on the command
    line.

  ``subprojectSummary``
    An optional bool. If false, equivalent to passing
    :option:`--no-subproject-summary <ctest --no-subproject-summary>`
    on the command line.

  ``maxPassedTestOutputSize``
    An optional integer specifying the maximum output for passed tests in
    bytes. Equivalent to passing
    :option:`--test-output-size-passed <ctest --test-output-size-passed>`
    on the command line.

  ``maxFailedTestOutputSize``
    An optional integer specifying the maximum output for failed tests in
    bytes. Equivalent to passing
    :option:`--test-output-size-failed <ctest --test-output-size-failed>`
    on the command line.

  ``testOutputTruncation``
    An optional string specifying the test output truncation mode. Equivalent
    to passing
    :option:`--test-output-truncation <ctest --test-output-truncation>` on
    the command line. This is allowed in preset files specifying version
    ``5`` or above.

  ``maxTestNameWidth``
    An optional integer specifying the maximum width of a test name to
    output. Equivalent to passing :option:`--max-width <ctest --max-width>`
    on the command line.

``filter``
  An optional object specifying how to filter the tests to run. The object
  may contain the following fields.

  ``include``
    An optional object specifying which tests to include. The object may
    contain the following fields.

    ``name``
      An optional string specifying a regex for test names. Equivalent to
      passing :option:`--tests-regex <ctest --tests-regex>` on the command
      line. This field supports macro expansion. CMake regex syntax is
      described under :ref:`string(REGEX) <Regex Specification>`.

    ``label``
      An optional string specifying a regex for test labels. Equivalent to
      passing :option:`--label-regex <ctest --label-regex>` on the command
      line. This field supports macro expansion.

    ``useUnion``
      An optional bool. Equivalent to passing :option:`--union <ctest --union>`
      on the command line.

    ``index``
      An optional object specifying tests to include by test index. The
      object may contain the following fields. Can also be an optional
      string specifying a file with the command line syntax for
      :option:`--tests-information <ctest --tests-information>`.
      If specified as a string, this field supports macro expansion.

      ``start``
        An optional integer specifying a test index to start testing at.

      ``end``
        An optional integer specifying a test index to stop testing at.

      ``stride``
        An optional integer specifying the increment.

      ``specificTests``
        An optional array of integers specifying specific test indices to
        run.

  ``exclude``
    An optional object specifying which tests to exclude. The object may
    contain the following fields.

    ``name``
      An optional string specifying a regex for test names. Equivalent to
      passing :option:`--exclude-regex <ctest --exclude-regex>` on the
      command line. This field supports macro expansion.

    ``label``
      An optional string specifying a regex for test labels. Equivalent to
      passing :option:`--label-exclude <ctest --label-exclude>` on the
      command line. This field supports macro expansion.

    ``fixtures``
      An optional object specifying which fixtures to exclude from adding
      tests. The object may contain the following fields.

      ``any``
        An optional string specifying a regex for text fixtures to exclude
        from adding any tests. Equivalent to
        :option:`--fixture-exclude-any <ctest --fixture-exclude-any>` on
        the command line. This field supports macro expansion.

      ``setup``
        An optional string specifying a regex for text fixtures to exclude
        from adding setup tests. Equivalent to
        :option:`--fixture-exclude-setup <ctest --fixture-exclude-setup>`
        on the command line. This field supports macro expansion.

      ``cleanup``
        An optional string specifying a regex for text fixtures to exclude
        from adding cleanup tests. Equivalent to
        :option:`--fixture-exclude-cleanup <ctest --fixture-exclude-cleanup>`
        on the command line. This field supports macro expansion.

``execution``
  An optional object specifying options for test execution. The object may
  contain the following fields.

  ``stopOnFailure``
    An optional bool. If true, equivalent to passing
    :option:`--stop-on-failure <ctest --stop-on-failure>` on the command
    line.

  ``enableFailover``
    An optional bool. If true, equivalent to passing :option:`-F <ctest -F>`
    on the command line.

  ``jobs``
    An optional integer. Equivalent to passing
    :option:`--parallel <ctest --parallel>` on the command line.

  ``resourceSpecFile``
    An optional string. Equivalent to passing
    :option:`--resource-spec-file <ctest --resource-spec-file>` on
    the command line. This field supports macro expansion.

  ``testLoad``
    An optional integer. Equivalent to passing
    :option:`--test-load <ctest --test-load>` on the command line.

  ``showOnly``
    An optional string. Equivalent to passing
    :option:`--show-only <ctest --show-only>` on the
    command line. The string must be one of the following values:

    ``human``

    ``json-v1``

  ``repeat``
    An optional object specifying how to repeat tests. Equivalent to
    passing :option:`--repeat <ctest --repeat>` on the command line.
    The object must have the following fields.

    ``mode``
      A required string. Must be one of the following values:

      ``until-fail``

      ``until-pass``

      ``after-timeout``

    ``count``
      A required integer.

  ``interactiveDebugging``
    An optional bool. If true, equivalent to passing
    :option:`--interactive-debug-mode 1 <ctest --interactive-debug-mode>`
    on the command line. If false, equivalent to passing
    :option:`--interactive-debug-mode 0 <ctest --interactive-debug-mode>`
    on the command line.

  ``scheduleRandom``
    An optional bool. If true, equivalent to passing
    :option:`--schedule-random <ctest --schedule-random>` on the command
    line.

  ``timeout``
    An optional integer. Equivalent to passing
    :option:`--timeout <ctest --timeout>` on the command line.

  ``noTestsAction``
    An optional string specifying the behavior if no tests are found. Must
    be one of the following values:

    ``default``
      Equivalent to not passing any value on the command line.

    ``error``
      Equivalent to passing :option:`--no-tests=error <ctest --no-tests>`
      on the command line.

    ``ignore``
      Equivalent to passing :option:`--no-tests=ignore <ctest --no-tests>`
      on the command line.

包预设
^^^^^^^^^^^^^^

Package presets may be used in schema version ``6`` or above. Each entry of
the ``packagePresets`` array is a JSON object that may contain the following
fields:

``name``
  A required string representing the machine-friendly name of the preset.
  This identifier is used in the :option:`cpack --preset` option.
  There must not be two package presets in the union of ``CMakePresets.json``
  and ``CMakeUserPresets.json`` in the same directory with the same name.
  However, a package preset may have the same name as a configure, build,
  test, or workflow preset.

``hidden``
  An optional boolean specifying whether or not a preset should be hidden.
  If a preset is hidden, it cannot be used in the
  :option:`--preset <cpack --preset>` argument
  and does not have to have a valid ``configurePreset``, even from
  inheritance. ``hidden`` presets are intended to be used as a base for
  other presets to inherit via the ``inherits`` field.

``inherits``
  An optional array of strings representing the names of presets to inherit
  from. This field can also be a string, which is equivalent to an array
  containing one string.

  The preset will inherit all of the fields from the
  ``inherits`` presets by default (except ``name``, ``hidden``,
  ``inherits``, ``description``, and ``displayName``), but can override
  them as desired. If multiple ``inherits`` presets provide conflicting
  values for the same field, the earlier preset in the ``inherits`` array
  will be preferred.

  A preset can only inherit from another preset that is defined in the
  same file or in one of the files it includes (directly or indirectly).
  Presets in ``CMakePresets.json`` may not inherit from presets in
  ``CMakeUserPresets.json``.

``condition``
  An optional `条件`_ object.

``vendor``
  An optional map containing vendor-specific information. CMake does not
  interpret the contents of this field except to verify that it is a map
  if it does exist. However, it should follow the same conventions as the
  root-level ``vendor`` field. If vendors use their own per-preset
  ``vendor`` field, they should implement inheritance in a sensible manner
  when appropriate.

``displayName``
  An optional string with a human-friendly name of the preset.

``description``
  An optional string with a human-friendly description of the preset.

``environment``
  An optional map of environment variables. The key is the variable name
  (which may not be an empty string), and the value is either ``null`` or
  a string representing the value of the variable. Each variable is set
  regardless of whether or not a value was given to it by the process's
  environment. This field supports macro expansion, and environment
  variables in this map may reference each other, and may be listed in any
  order, as long as such references do not cause a cycle (for example, if
  ``ENV_1`` is ``$env{ENV_2}``, ``ENV_2`` may not be ``$env{ENV_1}``.)

  Environment variables are inherited through the ``inherits`` field, and
  the preset's environment will be the union of its own ``environment``
  and the ``environment`` from all its parents. If multiple presets in
  this union define the same variable, the standard rules of ``inherits``
  are applied. Setting a variable to ``null`` causes it to not be set,
  even if a value was inherited from another preset.

``configurePreset``
  An optional string specifying the name of a configure preset to
  associate with this package preset. If ``configurePreset`` is not
  specified, it must be inherited from the inherits preset (unless this
  preset is hidden). The build directory is inferred from the configure
  preset, so packaging will run in the same ``binaryDir`` that the
  configuration did and build did.

``inheritConfigureEnvironment``
  An optional boolean that defaults to true. If true, the environment
  variables from the associated configure preset are inherited after all
  inherited package preset environments, but before environment variables
  explicitly specified in this package preset.

``generators``
  An optional array of strings representing generators for CPack to use.

``configurations``
  An optional array of strings representing build configurations for CPack to
  package.

``variables``
  An optional map of variables to pass to CPack, equivalent to
  :option:`-D <cpack -D>` arguments. Each key is the name of a variable, and
  the value is the string to assign to that variable.

``configFile``
  An optional string representing the config file for CPack to use.

``output``
  An optional object specifying output options. Valid keys are:

  ``debug``
    An optional boolean specifying whether or not to print debug information.
    A value of ``true`` is equivalent to passing
    :option:`--debug <cpack --debug>` on the command line.

  ``verbose``
    An optional boolean specifying whether or not to print verbosely. A value
    of ``true`` is equivalent to passing :option:`--verbose <cpack --verbose>`
    on the command line.

``packageName``
  An optional string representing the package name.

``packageVersion``
  An optional string representing the package version.

``packageDirectory``
  An optional string representing the directory in which to place the package.

``vendorName``
  An optional string representing the vendor name.

.. _`Workflow Preset`:

工作流预设
^^^^^^^^^^^^^^^

Workflow presets may be used in schema version ``6`` or above. Each entry of
the ``workflowPresets`` array is a JSON object that may contain the following
fields:

``name``
  A required string representing the machine-friendly name of the preset.
  This identifier is used in the
  :ref:`cmake --workflow --preset <Workflow Mode>` option. There must not be
  two workflow presets in the union of ``CMakePresets.json`` and
  ``CMakeUserPresets.json`` in the same directory with the same name. However,
  a workflow preset may have the same name as a configure, build, test, or
  package preset.

``vendor``
  An optional map containing vendor-specific information. CMake does not
  interpret the contents of this field except to verify that it is a map
  if it does exist. However, it should follow the same conventions as the
  root-level ``vendor`` field.

``displayName``
  An optional string with a human-friendly name of the preset.

``description``
  An optional string with a human-friendly description of the preset.

``steps``
  A required array of objects describing the steps of the workflow. The first
  step must be a configure preset, and all subsequent steps must be non-
  configure presets whose ``configurePreset`` field matches the starting
  configure preset. Each object may contain the following fields:

  ``type``
    A required string. The first step must be ``configure``. Subsequent steps
    must be either ``build``, ``test``, or ``package``.

  ``name``
    A required string representing the name of the configure, build, test, or
    package preset to run as this workflow step.

条件
^^^^^^^^^

The ``condition`` field of a preset, allowed in preset files specifying version
``3`` or above, is used to determine whether or not the preset is enabled. For
example, this can be used to disable a preset on platforms other than Windows.
``condition`` may be either a boolean, ``null``, or an object. If it is a
boolean, the boolean indicates whether the preset is enabled or disabled. If it
is ``null``, the preset is enabled, but the ``null`` condition is not inherited
by any presets that may inherit from the preset. Sub-conditions (for example in
a ``not``, ``anyOf``, or ``allOf`` condition) may not be ``null``. If it is an
object, it has the following fields:

``type``
  A required string with one of the following values:

  ``"const"``
    Indicates that the condition is constant. This is equivalent to using a
    boolean in place of the object. The condition object will have the
    following additional fields:

    ``value``
      A required boolean which provides a constant value for the condition's
      evaluation.

  ``"equals"``

  ``"notEquals"``
    Indicates that the condition compares two strings to see if they are equal
    (or not equal). The condition object will have the following additional
    fields:

    ``lhs``
      First string to compare. This field supports macro expansion.

    ``rhs``
      Second string to compare. This field supports macro expansion.

  ``"inList"``

  ``"notInList"``
    Indicates that the condition searches for a string in a list of strings.
    The condition object will have the following additional fields:

    ``string``
      A required string to search for. This field supports macro expansion.

    ``list``
      A required array of strings to search. This field supports macro
      expansion, and uses short-circuit evaluation.

  ``"matches"``

  ``"notMatches"``
    Indicates that the condition searches for a regular expression in a string.
    The condition object will have the following additional fields:

    ``string``
      A required string to search. This field supports macro expansion.

    ``regex``
      A required regular expression to search for. This field supports macro
      expansion.

  ``"anyOf"``

  ``"allOf"``

    Indicates that the condition is an aggregation of zero or more nested
    conditions. The condition object will have the following additional fields:

    ``conditions``
      A required array of condition objects. These conditions use short-circuit
      evaluation.

  ``"not"``
    Indicates that the condition is an inversion of another condition. The
    condition object will have the following additional fields:

    ``condition``
      A required condition object.

宏扩展
^^^^^^^^^^^^^^^

As mentioned above, some fields support macro expansion. Macros are
recognized in the form ``$<macro-namespace>{<macro-name>}``. All macros are
evaluated in the context of the preset being used, even if the macro is in a
field that was inherited from another preset. For example, if the ``Base``
preset sets variable ``PRESET_NAME`` to ``${presetName}``, and the
``Derived`` preset inherits from ``Base``, ``PRESET_NAME`` will be set to
``Derived``.

It is an error to not put a closing brace at the end of a macro name. For
example, ``${sourceDir`` is invalid. A dollar sign (``$``) followed by
anything other than a left curly brace (``{``) with a possible namespace is
interpreted as a literal dollar sign.

Recognized macros include:

``${sourceDir}``
  Path to the project source directory (i.e. the same as
  :variable:`CMAKE_SOURCE_DIR`).

``${sourceParentDir}``
  Path to the project source directory's parent directory.

``${sourceDirName}``
  The last filename component of ``${sourceDir}``. For example, if
  ``${sourceDir}`` is ``/path/to/source``, this would be ``source``.

``${presetName}``
  Name specified in the preset's ``name`` field.

``${generator}``
  Generator specified in the preset's ``generator`` field. For build and
  test presets, this will evaluate to the generator specified by
  ``configurePreset``.

``${hostSystemName}``
  The name of the host operating system. Contains the same value as
  :variable:`CMAKE_HOST_SYSTEM_NAME`. This is allowed in preset files
  specifying version ``3`` or above.

``${fileDir}``
  Path to the directory containing the preset file which contains the macro.
  This is allowed in preset files specifying version ``4`` or above.

``${dollar}``
  A literal dollar sign (``$``).

``${pathListSep}``
  Native character for separating lists of paths, such as ``:`` or ``;``.

  For example, by setting ``PATH`` to
  ``/path/to/ninja/bin${pathListSep}$env{PATH}``, ``${pathListSep}`` will
  expand to the underlying operating system's character used for
  concatenation in ``PATH``.

  This is allowed in preset files specifying version ``5`` or above.

``$env{<variable-name>}``
  Environment variable with name ``<variable-name>``. The variable name may
  not be an empty string. If the variable is defined in the ``environment``
  field, that value is used instead of the value from the parent environment.
  If the environment variable is not defined, this evaluates as an empty
  string.

  Note that while Windows environment variable names are case-insensitive,
  variable names within a preset are still case-sensitive. This may lead to
  unexpected results when using inconsistent casing. For best results, keep
  the casing of environment variable names consistent.

``$penv{<variable-name>}``
  Similar to ``$env{<variable-name>}``, except that the value only comes from
  the parent environment, and never from the ``environment`` field. This
  allows you to prepend or append values to existing environment variables.
  For example, setting ``PATH`` to ``/path/to/ninja/bin:$penv{PATH}`` will
  prepend ``/path/to/ninja/bin`` to the ``PATH`` environment variable. This
  is needed because ``$env{<variable-name>}`` does not allow circular
  references.

``$vendor{<macro-name>}``
  An extension point for vendors to insert their own macros. CMake will not
  be able to use presets which have a ``$vendor{<macro-name>}`` macro, and
  effectively ignores such presets. However, it will still be able to use
  other presets from the same file.

  CMake does not make any attempt to interpret ``$vendor{<macro-name>}``
  macros. However, to avoid name collisions, IDE vendors should prefix
  ``<macro-name>`` with a very short (preferably <= 4 characters) vendor
  identifier prefix, followed by a ``.``, followed by the macro name. For
  example, the Example IDE could have ``$vendor{xide.ideInstallDir}``.

模式
======

:download:`This file </manual/presets/schema.json>` provides a machine-readable
JSON schema for the ``CMakePresets.json`` format.
