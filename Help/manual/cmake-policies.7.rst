.. cmake-manual-description: CMake Policies Reference

cmake-policies(7)
*****************

.. only:: html

   .. contents::

引言
============

CMake policies introduce behavior changes while preserving compatibility
for existing project releases.  Policies are deprecation mechanisms, not
feature toggles.  Each policy documents a deprecated ``OLD`` behavior and
a preferred ``NEW`` behavior.  Projects must be updated over time to
use the ``NEW`` behavior, but their existing releases will continue to
work with the ``OLD`` behavior.

Updating Projects
-----------------

When policies are newly introduced by a version of CMake, their ``OLD``
behaviors are immediately deprecated by that version of CMake and later.
Projects should be updated to use the ``NEW`` behaviors of the policies
as soon as possible.

Use the :command:`cmake_minimum_required` command to record the latest
version of CMake for which a project has been updated.
For example:

..
  Sync this cmake_minimum_required example with ``Help/dev/maint.rst``.

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.10...3.31)

This uses the ``<min>...<max>`` syntax to enable the ``NEW`` behaviors
of policies introduced in CMake 3.31 and earlier while only requiring a
minimum version of CMake 3.10.  The project is expected to work with
both the ``OLD`` and ``NEW`` behaviors of policies introduced between
those versions.

Transition Schedule
-------------------

To help projects port to the ``NEW`` behaviors of policies on their own
schedule, CMake offers a transition period:

* If a policy is not set by a project, CMake uses its ``OLD`` behavior,
  but may warn that the policy has not been set.

  * Users running CMake may silence the warning without modifying a
    project by setting the :variable:`CMAKE_POLICY_DEFAULT_CMP<NNNN>`
    variable as a cache entry on the :manual:`cmake(1)` command line:

    .. code-block:: shell

      cmake -DCMAKE_POLICY_DEFAULT_CMP0990=OLD ...

  * Projects may silence the warning by using the :command:`cmake_policy`
    command to explicitly set the policy to ``OLD`` or ``NEW`` behavior:

    .. code-block:: cmake

      if(POLICY CMP0990)
        cmake_policy(SET CMP0990 NEW)
      endif()

    .. note::

      A policy should almost never be set to ``OLD``, except to silence
      warnings in an otherwise frozen or stable codebase, or temporarily
      as part of a larger migration path.

* If a policy is set to ``OLD`` by a project, CMake versions released
  at least |POLICY_OLD_DELAY_WARNING| after the version that introduced
  a policy may issue a warning that the policy's ``OLD`` behavior will
  be removed from a future version of CMake.

* If a policy is not set to ``NEW`` by a project, CMake versions released
  at least |POLICY_OLD_DELAY_ERROR| after the version that introduced a
  policy, and whose major version number is higher, may issue an error
  that the policy's ``OLD`` behavior has been removed.

.. |POLICY_OLD_DELAY_WARNING| replace:: 2 years
.. |POLICY_OLD_DELAY_ERROR| replace:: 6 years

Supported Policies
==================

The following policies are supported.

Policies Introduced by CMake 4.0
--------------------------------

.. toctree::
   :maxdepth: 1

   CMP0185: FindRuby no longer provides upper-case RUBY_* variables. </policy/CMP0185>
   CMP0184: MSVC runtime checks flags are selected by an abstraction. </policy/CMP0184>
   CMP0183: add_feature_info() supports full Condition Syntax. </policy/CMP0183>
   CMP0182: Create shared library archives by default on AIX. </policy/CMP0182>
   CMP0181: Link command-line fragment variables are parsed and re-quoted. </policy/CMP0181>

Policies Introduced by CMake 3.31
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0180: project()总是将<PROJECT-NAME>_*设置为普通变量。 </policy/CMP0180>
   CMP0179: 删除链接上的重复静态库保留第一个发现。 </policy/CMP0179>
   CMP0178: 测试命令行保留空参数。 </policy/CMP0178>
   CMP0177: 规范install() DESTINATION路径。 </policy/CMP0177>
   CMP0176: 默认情况下，execute_process() ENCODING是UTF-8。 </policy/CMP0176>
   CMP0175: add_custom_command()拒绝无效参数。 </policy/CMP0175>
   CMP0174: cmake_parse_arguments(PARSE_ARGV)在单值关键字之后定义一个空字符串变量。 </policy/CMP0174>
   CMP0173: CMakeFindFrameworks模块被移除。 </policy/CMP0173>
   CMP0172: CPack模块默认在CPack WIX生成器中启用各自机器安装。 </policy/CMP0172>
   CMP0171: 'codegen'是保留的目标名称。 </policy/CMP0171>

CMake 3.30引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0170: 强制执行FETCHCONTENT_FULLY_DISCONNECTED需求。 </policy/CMP0170>
   CMP0169: FetchContent_Populate(depName)单参数签名被废弃。 </policy/CMP0169>
   CMP0168: FetchContent直接实现步骤，而不是通过子构建。 </policy/CMP0168>
   CMP0167: 删除FindBoost模块。 </policy/CMP0167>
   CMP0166: TARGET_PROPERTY在静态库的私有依赖项上传递计算链接属性。 </policy/CMP0166>
   CMP0165: 在调用project()之前不能调用enable_language()。 </policy/CMP0165>
   CMP0164: add_library()拒绝平台不支持的SHARED库。 </policy/CMP0164>
   CMP0163: GENERATED源文件属性现在在所有目录中可见。 </policy/CMP0163>
   CMP0162: Visual Studio生成器默认添加UseDebugLibraries指示符。 </policy/CMP0162>

CMake 3.29引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0161: CPACK_PRODUCTBUILD_DOMAINS默认值为true。 </policy/CMP0161>
   CMP0160: 更多只读目标属性在试图设置它们时报错。 </policy/CMP0160>
   CMP0159: file(STRINGS)用REGEX更新CMAKE_MATCH_<n>。 </policy/CMP0159>
   CMP0158: add_test()仅在交叉编译时启用CMAKE_CROSSCOMPILING_EMULATOR。 </policy/CMP0158>
   CMP0157: Swift编译模式由抽象选择。 </policy/CMP0157>
   CMP0156: 基于链接器功能对链接上的库进行去重。 </policy/CMP0156>

CMake 3.28引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0155: 在支持的情况下，会扫描目标中C++源代码，至少需要C++20支持。 </policy/CMP0155>
   CMP0154: 生成的文件在使用文件集的目标中默认是私有的。 </policy/CMP0154>
   CMP0153: 不应该调用exec_program命令。 </policy/CMP0153>
   CMP0152: file(REAL_PATH)在解析符号链接之前折叠../组件。 </policy/CMP0152>

CMake 3.27引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0151: AUTOMOC包含目录默认为系统包含目录。 </policy/CMP0151>
   CMP0150: ExternalProject_Add和FetchContent_Declare将相对git仓库路径视为相对于父项目的远程仓库的相对路径。 </policy/CMP0150>
   CMP0149: Visual Studio生成器默认选择最新的Windows SDK。 </policy/CMP0149>
   CMP0148: FindPythonInterp和FindPythonLibs模块被删除。 </policy/CMP0148>
   CMP0147: Visual Studio生成器可以并行构建自定义命令。 </policy/CMP0147>
   CMP0146: FindCUDA模块被移除。 </policy/CMP0146>
   CMP0145: Dart和FindDart模块被移除。 </policy/CMP0145>
   CMP0144: find_package使用大写的PACKAGENAME_ROOT变量。 </policy/CMP0144>

CMake 3.26引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0143: USE_FOLDERS全局属性默认为ON。 </policy/CMP0143>

CMake 3.25引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0142: Xcode生成器不会为库搜索路径附加每个配置的后缀。 </policy/CMP0142>
   CMP0141: MSVC调试信息格式标志是由一个抽象选择的。 </policy/CMP0141>
   CMP0140: return()命令检查其参数。 </policy/CMP0140>

CMake 3.24引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0139: if()命令支持使用PATH_EQUAL操作符比较路径。 </policy/CMP0139>
   CMP0138: CheckIPOSupported使用调用项目的标志。 </policy/CMP0138>
   CMP0137: try_compile()在项目模式下传递平台变量。 </policy/CMP0137>
   CMP0136: Watcom运行时库标志是由抽象选择的。 </policy/CMP0136>
   CMP0135: ExternalProject和FetchContent默认忽略URL下载方法存档中的时间戳。 </policy/CMP0135>
   CMP0134: 当“TARGET”视图不可用时，回退到“HOST”Windows注册表视图。 </policy/CMP0134>
   CMP0133: CPack模块默认在CPack DragNDrop Generator中禁用SLA。 </policy/CMP0133>
   CMP0132: 不要在第一次运行时设置编译器环境变量。 </policy/CMP0132>
   CMP0131: LINK_LIBRARIES支持LINK_ONLY生成器表达式。 </policy/CMP0131>
   CMP0130: while()诊断条件评估错误。 </policy/CMP0130>

CMake 3.23引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0129: MCST LCC编译器的编译器id现在是LCC，而不是GNU。 </policy/CMP0129>

CMake 3.22引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0128: 改进语言标准和扩展标志选择。 </policy/CMP0128>
   CMP0127: cmake_dependent_option()支持所有条件语法。 </policy/CMP0127>

CMake 3.21引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0126: set(CACHE)不会移除同名的普通变量。 </policy/CMP0126>
   CMP0125: find_(path|file|library|program)具有一致的缓存变量行为。 </policy/CMP0125>
   CMP0124: foreach()循环变量仅在循环作用域中可用。 </policy/CMP0124>
   CMP0123: ARMClang必须显式设置cpu/arch编译和链接标志。 </policy/CMP0123>
   CMP0122: UseSWIG使用csharp语言的标准库命名约定。 </policy/CMP0122>
   CMP0121: list命令会检测无效索引。 </policy/CMP0121>

CMake 3.20引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0120: 移除WriteCompilerDetectionHeader模块。 </policy/CMP0120>
   CMP0119: LANGUAGE源文件属性显式编译为语言。 </policy/CMP0119>
   CMP0118: GENERATED源代码可以跨目录使用，无需手动标记。 </policy/CMP0118>
   CMP0117: MSVC RTTI标志/GR默认不添加到CMAKE_CXX_FLAGS中。 </policy/CMP0117>
   CMP0116: Ninja生成器从add_custom_command()转换DEPFILE。 </policy/CMP0116>
   CMP0115: 源文件扩展名必须显示指定。 </policy/CMP0115>

CMake 3.19引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0114: ExternalProject步骤目标完全采用他们的步骤。 </policy/CMP0114>
   CMP0113: Makefile生成器不会重复目标依赖中的自定义命令。 </policy/CMP0113>
   CMP0112: 目标文件组件生成器表达式不添加目标依赖项。 </policy/CMP0112>
   CMP0111: 导入目标缺少其location属性会导致在生成过程中失败。 </policy/CMP0111>
   CMP0110: add_test()支持测试名中的任意字符。 </policy/CMP0110>
   CMP0109: find_program()需要执行权限，不需要读取权限。 </policy/CMP0109>

CMake 3.18引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0108: 目标不能通过别名链接自己。 </policy/CMP0108>
   CMP0107: ALIAS目标不能覆盖其他目标。 </policy/CMP0107>
   CMP0106: Documentation模块被移除。 </policy/CMP0106>
   CMP0105: 设备链接步骤使用链接选项。 </policy/CMP0105>
   CMP0104: CMAKE_CUDA_ARCHITECTURES现在检测到NVCC时，不允许空的CUDA_ARCHITECTURES。 </policy/CMP0104>
   CMP0103: 不允许对同一个FILE进行多次export()而不进行APPEND。 </policy/CMP0103>

CMake 3.17引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0102: 如果缓存项不存在，mark_as_advanced()什么也不做。 </policy/CMP0102>
   CMP0101: target_compile_options在所有作用域中都是BEFORE关键字。 </policy/CMP0101>
   CMP0100: 让AUTOMOC和AUTOUIC处理.hh头文件。 </policy/CMP0100>
   CMP0099: 链接属性在静态库的私有依赖关系之上是传递的。 </policy/CMP0099>
   CMP0098: FindFLEX执行时在CMAKE_CURRENT_BINARY_DIR中运行flex。 </policy/CMP0098>

CMake 3.16引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0097: 用GIT_SUBMODULES ""参数调用ExternalProject_Add不初始化子模块。 </policy/CMP0097>
   CMP0096: project()保留版本组件中的前面的零。 </policy/CMP0096>
   CMP0095: RPATH条目在中间的CMake安装脚本中被正确转义。 </policy/CMP0095>

CMake 3.15引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0094: FindPython3、FindPython2和FindPython都使用LOCATION作为查找策略。 </policy/CMP0094>
   CMP0093: FindBoost以x.y.z格式报告Boost_VERSION。 </policy/CMP0093>
   CMP0092: 默认情况下，MSVC警告标志不在CMAKE_{C，CXX}_FLAGS中。 </policy/CMP0092>
   CMP0091: MSVC运行时库标志是由抽象选择的。 </policy/CMP0091>
   CMP0090: export(PACKAGE)默认不填充包注册表。 </policy/CMP0090>
   CMP0089: 现在基于IBM clang的XL编译器id是XLClang。 </policy/CMP0089>

CMake 3.14引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0088: FindBISON执行时在CMAKE_CURRENT_BINARY_DIR中运行bison。 </policy/CMP0088>
   CMP0087: install(SCRIPT | CODE)支持生成器表达式。 </policy/CMP0087>
   CMP0086: UseSWIG通过-module标志来命名SWIG_MODULE_NAME。 </policy/CMP0086>
   CMP0085: IN_LIST生成器表达式处理空列表项。 </policy/CMP0085>
   CMP0084: find_package()不存在FindQt模块。 </policy/CMP0084>
   CMP0083: 链接可执行文件时添加PIE选项。 </policy/CMP0083>
   CMP0082: 来自add_subdirectory()的安装规则与调用者中的规则交叉。 </policy/CMP0082>


CMake 3.13引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0081: 相对路径不允许在LINK_DIRECTORIES目标属性。 </policy/CMP0081>
   CMP0080: 在配置时不能包含BundleUtilities。 </policy/CMP0080>
   CMP0079: target_link_libraries允许使用其他目录中的目标。 </policy/CMP0079>
   CMP0078: UseSWIG生成标准目标名称。 </policy/CMP0078>
   CMP0077: option()支持普通变量。 </policy/CMP0077>
   CMP0076: target_sources()命令将相对路径转换为绝对路径。 </policy/CMP0076>

CMake 3.12引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0075: 包含文件检查宏遵循CMAKE_REQUIRED_LIBRARIES。 </policy/CMP0075>
   CMP0074: find_package使用PackageName_ROOT变量。 </policy/CMP0074>
   CMP0073: 不生成遗留的_LIB_DEPENDS缓存条目。 </policy/CMP0073>

CMake 3.11引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0072: 当GLVND可用时，FindOpenGL默认选择GLVND。 </policy/CMP0072>

CMake 3.10引入的策略
---------------------------------

.. toctree::
   :maxdepth: 1

   CMP0071: 让AUTOMOC和AUTOUIC处理GENERATED文件。 </policy/CMP0071>
   CMP0070: 定义相对路径的file(GENERATE)行为。 </policy/CMP0070>

CMake 3.9引入的策略
--------------------------------

.. toctree::
   :maxdepth: 1

   CMP0069: INTERPROCEDURAL_OPTIMIZATION启用时强制执行。 </policy/CMP0069>
   CMP0068: macOS上的RPATH设置不影响install_name。 </policy/CMP0068>

CMake 3.8引入的策略
--------------------------------

.. toctree::
   :maxdepth: 1

   CMP0067: 尊重try_compile()源文件签名中的语言标准。 </policy/CMP0067>

CMake 3.7引入的策略
--------------------------------

.. toctree::
   :maxdepth: 1

   CMP0066: 尊重try_compile()源文件签名中每个配置的标志。 </policy/CMP0066>

Unsupported Policies
====================

The following policies are no longer supported.
Projects' calls to :command:`cmake_minimum_required(VERSION)` or
:command:`cmake_policy(VERSION)` must set them to ``NEW``.
Their ``OLD`` behaviors have been removed from CMake.

.. _`Policies Introduced by CMake 3.4`:

Policies Introduced by CMake 3.4, Removed by CMake 4.0
------------------------------------------------------

.. toctree::
   :maxdepth: 1

   CMP0065: 在没有ENABLE_EXPORTS目标属性的情况下，不要为从可执行文件中导出符号添加标志。 </policy/CMP0065>
   CMP0064: if()支持新的TEST运算符。 </policy/CMP0064>

.. _`Policies Introduced by CMake 3.3`:

Policies Introduced by CMake 3.3, Removed by CMake 4.0
------------------------------------------------------

.. toctree::
   :maxdepth: 1

   CMP0063: 尊重所有目标类型的可见属性。 </policy/CMP0063>
   CMP0062: 不允许export()结果的install()。 </policy/CMP0062>
   CMP0061: 默认情况下CTest不会告诉make忽略错误(-i)。 </policy/CMP0061>
   CMP0060: 通过全路径链接库，即使在隐式目录。 </policy/CMP0060>
   CMP0059: 不要将DEFINITIONS视为内置目录属性。 </policy/CMP0059>
   CMP0058: Ninja需要自定义的命令副产品是显式的。 </policy/CMP0058>
   CMP0057: if()支持新的IN_LIST运算符。 </policy/CMP0057>

.. _`Policies Introduced by CMake 3.2`:

Policies Introduced by CMake 3.2, Removed by CMake 4.0
------------------------------------------------------

.. toctree::
   :maxdepth: 1

   CMP0056: 尊敬try_compile()源文件签名中的链接标志。 </policy/CMP0056>
   CMP0055: 严格检查break()命令。 </policy/CMP0055>

.. _`Policies Introduced by CMake 3.1`:

Policies Introduced by CMake 3.1, Removed by CMake 4.0
------------------------------------------------------

.. toctree::
   :maxdepth: 1

   CMP0054: 只有当if()参数未加引号时，才将其解释为变量或关键字。 </policy/CMP0054>
   CMP0053: 简化变量引用和转义序列的计算。 </policy/CMP0053>
   CMP0052: 拒绝在已安装的INTERFACE_INCLUDE_DIRECTORIES目录下的源目录和构建目录。 </policy/CMP0052>
   CMP0051: 在SOURCES目标属性中列出TARGET_OBJECTS。 </policy/CMP0051>

.. _`Policies Introduced by CMake 3.0`:

Policies Introduced by CMake 3.0, Removed by CMake 4.0
------------------------------------------------------

.. toctree::
   :maxdepth: 1

   CMP0050: 禁止add_custom_command SOURCE签名。 </policy/CMP0050>
   CMP0049: 不要在目标源条目中展开变量。 </policy/CMP0049>
   CMP0048: project()命令管理VERSION变量。 </policy/CMP0048>
   CMP0047: 为QNX上的qcc驱动程序使用QCC编译器id。 </policy/CMP0047>
   CMP0046: 在add_dependencies中出现不存在依赖时报错。 </policy/CMP0046>
   CMP0045: 在get_target_property中不存在目标时报错。 </policy/CMP0045>
   CMP0044: Lang_COMPILER_ID生成器表达式区分大小写。 </policy/CMP0044>
   CMP0043: 忽略COMPILE_DEFINITIONS_Config属性。 </policy/CMP0043>
   CMP0042: 默认开启MACOSX_RPATH。 </policy/CMP0042>
   CMP0041: 生成器表达式使用相对包含会报错。 </policy/CMP0041>
   CMP0040: add_custom_command()的TARGET签名中的目标必须存在。 </policy/CMP0040>
   CMP0039: Utility目标可能没有链接依赖。 </policy/CMP0039>
   CMP0038: 目标不能直接链接到自己。 </policy/CMP0038>
   CMP0037: 目标名称不应该保留，并且应该匹配有效模式。 </policy/CMP0037>
   CMP0036: 不应该调用build_name命令。 </policy/CMP0036>
   CMP0035: 不应该调用variable_requires命令。 </policy/CMP0035>
   CMP0034: 不应该调用utility_source命令。 </policy/CMP0034>
   CMP0033: 不应该调用export_library_dependencies命令。 </policy/CMP0033>
   CMP0032: 不应该调用output_required_files命令。 </policy/CMP0032>
   CMP0031: 不应该调用load_command命令。 </policy/CMP0031>
   CMP0030: 不应该调用use_mangled_mesa命令。 </policy/CMP0030>
   CMP0029: 不应该调用subdir_depends命令。 </policy/CMP0029>
   CMP0028: 目标名称中双冒号表示ALIAS或IMPORTED目标。 </policy/CMP0028>
   CMP0027: 条件链接的导入目标缺少include目录。 </policy/CMP0027>
   CMP0026: 禁止使用LOCATION目标属性。 </policy/CMP0026>
   CMP0025: Apple Clang的编译器id现在是AppleClang。 </policy/CMP0025>
   CMP0024: 不允许包含导出结果。 </policy/CMP0024>

.. _`Policies Introduced by CMake 2.8`:

Policies Introduced by CMake 2.8, Removed by CMake 4.0
------------------------------------------------------

.. toctree::
   :maxdepth: 1

   CMP0023: 无修饰和关键字target_link_libraries签名不能混合使用。 </policy/CMP0023>
   CMP0022: INTERFACE_LINK_LIBRARIES定义链接接口。 </policy/CMP0022>
   CMP0021: 在INCLUDE_DIRECTORIES目标属性的相对路径上发生致命错误。 </policy/CMP0021>
   CMP0020: Windows上自动连接Qt可执行文件到qtmain目标。 </policy/CMP0020>
   CMP0019: 不要在包含和链接信息中重新扩展变量。 </policy/CMP0019>
   CMP0018: 忽略CMAKE_SHARED_LIBRARY_Lang_FLAGS变量。 </policy/CMP0018>
   CMP0017: 优先选择CMake模块目录下的文件。 </policy/CMP0017>
   CMP0016: 如果target_link_libraries()的唯一参数不是目标，它会报告错误。 </policy/CMP0016>
   CMP0015: link_directories()处理相对于源目录的路径。 </policy/CMP0015>
   CMP0014: 输入目录必须有CMakeLists.txt文件。 </policy/CMP0014>
   CMP0013: 不允许重复的二进制目录。 </policy/CMP0013>
   CMP0012: if()可以识别数字和布尔常量。 </policy/CMP0012>

.. _`Policies Introduced by CMake 2.6`:

Policies Introduced by CMake 2.6, Removed by CMake 4.0
------------------------------------------------------

.. toctree::
   :maxdepth: 1

   CMP0011: 包含的脚本可以自动PUSH和POP cmake_policy。 </policy/CMP0011>
   CMP0010: 坏变量引用语法是错误的。 </policy/CMP0010>
   CMP0009: 默认情况下，FILE的GLOB_RECURSE调用不应该跟随符号链接。 </policy/CMP0009>
   CMP0008: 通过全路径链接的库必须有一个有效的库文件名。 </policy/CMP0008>
   CMP0007: list命令不再忽略空元素。 </policy/CMP0007>
   CMP0006: 安装MACOSX_BUNDLE目标需要一个BUNDLE DESTINATION。 </policy/CMP0006>
   CMP0005: 预处理器定义值现在自动转义。 </policy/CMP0005>
   CMP0004: 链接的库前后不能有空格。 </policy/CMP0004>
   CMP0003: 通过全路径链接的库不再产生链接器搜索路径。 </policy/CMP0003>
   CMP0002: 逻辑目标名称必须全局唯一。 </policy/CMP0002>
   CMP0001: CMAKE_BACKWARDS_COMPATIBILITY不应该再使用。 </policy/CMP0001>
   CMP0000: 必须指定CMake的最小版本号。 </policy/CMP0000>
