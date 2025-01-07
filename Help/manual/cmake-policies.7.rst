.. cmake-manual-description: CMake Policies Reference

cmake-policies(7)
*****************

.. only:: html

   .. contents::

引言
============

CMake中的策略用于保持跨多个版本的向后兼容行为。当引入新策略时，新的CMake版本将开始警告向后\
兼容行为。可以通过使用\ :command:`cmake_policy`\ 命令显式请求OLD或向后兼容行为来禁用警告。\
也可以请求\ ``NEW``\ 或策略的非向后兼容行为，这样也可以避免警告。还可以在命令行中用\
:variable:`CMAKE_POLICY_DEFAULT_CMP<NNNN>`\ 变量显式地将每个策略设置为\ ``NEW``\
或\ ``OLD``\ 行为。

策略是一种弃用机制，不是可靠的特性切换。策略几乎不应该设置为\ ``OLD``，除非在冻结或稳定的代\
码库中冻结警告，或者暂时作为更大迁移路径的一部分。每个策略的\ ``OLD``\ 行为都是不可取的，\
并将在未来的版本中被错误条件替换。

如果使用太旧的CMake版本构建项目，:command:`cmake_minimum_required`\ 命令的作用不仅仅是\
报告错误。它还将该CMake版本或更早版本中引入的所有策略设置为\ ``NEW``\ 行为。如果需要管理策\
略而不增加CMake的最低版本，可以使用\ :command:`if(POLICY)`\ 命令：

.. code-block:: cmake

  if(POLICY CMP0990)
    cmake_policy(SET CMP0990 NEW)
  endif()

这就产生了在用户可能正在使用的较新的CMake版本中使用\ ``NEW``\ 行为而不发出兼容性警告的效果。

在某些情况下，策略的设置被限制为不传播到父作用域。例如，如果\ :command:`include`\ 命令或\
:command:`find_package`\ 命令读取的文件包含使用了\ :command:`cmake_policy`，默认情况下，\
该策略设置不会影响调用者。这两个命令都接受一个可选的\ ``NO_POLICY_SCOPE``\ 关键字来控制此\
行为。

:variable:`CMAKE_MINIMUM_REQUIRED_VERSION`\ 变量也可以用来决定是否报告在使用弃用宏或\
函数时的错误。

CMake 3.31引入的策略
=================================

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
=================================

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
=================================

.. toctree::
   :maxdepth: 1

   CMP0161: CPACK_PRODUCTBUILD_DOMAINS默认值为true。 </policy/CMP0161>
   CMP0160: 更多只读目标属性在试图设置它们时报错。 </policy/CMP0160>
   CMP0159: file(STRINGS)用REGEX更新CMAKE_MATCH_<n>。 </policy/CMP0159>
   CMP0158: add_test()仅在交叉编译时启用CMAKE_CROSSCOMPILING_EMULATOR。 </policy/CMP0158>
   CMP0157: Swift编译模式由抽象选择。 </policy/CMP0157>
   CMP0156: 基于链接器功能对链接上的库进行去重。 </policy/CMP0156>

CMake 3.28引入的策略
=================================

.. toctree::
   :maxdepth: 1

   CMP0155: 在支持的情况下，会扫描目标中C++源代码，至少需要C++20支持。 </policy/CMP0155>
   CMP0154: 生成的文件在使用文件集的目标中默认是私有的。 </policy/CMP0154>
   CMP0153: 不应该调用exec_program命令。 </policy/CMP0153>
   CMP0152: file(REAL_PATH)在解析符号链接之前折叠../组件。 </policy/CMP0152>

CMake 3.27引入的策略
=================================

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
=================================

.. toctree::
   :maxdepth: 1

   CMP0143: USE_FOLDERS全局属性默认为ON。 </policy/CMP0143>

CMake 3.25引入的策略
=================================

.. toctree::
   :maxdepth: 1

   CMP0142: Xcode生成器不会为库搜索路径附加每个配置的后缀。 </policy/CMP0142>
   CMP0141: MSVC调试信息格式标志是由一个抽象选择的。 </policy/CMP0141>
   CMP0140: return()命令检查其参数。 </policy/CMP0140>

CMake 3.24引入的策略
=================================

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

Policies Introduced by CMake 3.23
=================================

.. toctree::
   :maxdepth: 1

   CMP0129: Compiler id for MCST LCC compilers is now LCC, not GNU. </policy/CMP0129>

Policies Introduced by CMake 3.22
=================================

.. toctree::
   :maxdepth: 1

   CMP0128: Selection of language standard and extension flags improved. </policy/CMP0128>
   CMP0127: cmake_dependent_option() supports full Condition Syntax. </policy/CMP0127>

Policies Introduced by CMake 3.21
=================================

.. toctree::
   :maxdepth: 1

   CMP0126: set(CACHE) does not remove a normal variable of the same name. </policy/CMP0126>
   CMP0125: find_(path|file|library|program) have consistent behavior for cache variables. </policy/CMP0125>
   CMP0124: foreach() loop variables are only available in the loop scope. </policy/CMP0124>
   CMP0123: ARMClang cpu/arch compile and link flags must be set explicitly. </policy/CMP0123>
   CMP0122: UseSWIG use standard library name conventions for csharp language. </policy/CMP0122>
   CMP0121: The list command detects invalid indices. </policy/CMP0121>

Policies Introduced by CMake 3.20
=================================

.. toctree::
   :maxdepth: 1

   CMP0120: The WriteCompilerDetectionHeader module is removed. </policy/CMP0120>
   CMP0119: LANGUAGE source file property explicitly compiles as language. </policy/CMP0119>
   CMP0118: GENERATED sources may be used across directories without manual marking. </policy/CMP0118>
   CMP0117: MSVC RTTI flag /GR is not added to CMAKE_CXX_FLAGS by default. </policy/CMP0117>
   CMP0116: Ninja generators transform DEPFILEs from add_custom_command(). </policy/CMP0116>
   CMP0115: Source file extensions must be explicit. </policy/CMP0115>

Policies Introduced by CMake 3.19
=================================

.. toctree::
   :maxdepth: 1

   CMP0114: ExternalProject step targets fully adopt their steps. </policy/CMP0114>
   CMP0113: Makefile generators do not repeat custom commands from target dependencies. </policy/CMP0113>
   CMP0112: Target file component generator expressions do not add target dependencies. </policy/CMP0112>
   CMP0111: An imported target missing its location property fails during generation. </policy/CMP0111>
   CMP0110: add_test() supports arbitrary characters in test names. </policy/CMP0110>
   CMP0109: find_program() requires permission to execute but not to read. </policy/CMP0109>

Policies Introduced by CMake 3.18
=================================

.. toctree::
   :maxdepth: 1

   CMP0108: A target cannot link to itself through an alias. </policy/CMP0108>
   CMP0107: An ALIAS target cannot overwrite another target. </policy/CMP0107>
   CMP0106: The Documentation module is removed. </policy/CMP0106>
   CMP0105: Device link step uses the link options. </policy/CMP0105>
   CMP0104: CMAKE_CUDA_ARCHITECTURES now detected for NVCC, empty CUDA_ARCHITECTURES not allowed. </policy/CMP0104>
   CMP0103: Multiple export() with same FILE without APPEND is not allowed. </policy/CMP0103>

Policies Introduced by CMake 3.17
=================================

.. toctree::
   :maxdepth: 1

   CMP0102: mark_as_advanced() does nothing if a cache entry does not exist. </policy/CMP0102>
   CMP0101: target_compile_options honors BEFORE keyword in all scopes. </policy/CMP0101>
   CMP0100: Let AUTOMOC and AUTOUIC process .hh header files. </policy/CMP0100>
   CMP0099: Link properties are transitive over private dependencies of static libraries. </policy/CMP0099>
   CMP0098: FindFLEX runs flex in CMAKE_CURRENT_BINARY_DIR when executing. </policy/CMP0098>

Policies Introduced by CMake 3.16
=================================

.. toctree::
   :maxdepth: 1

   CMP0097: ExternalProject_Add with GIT_SUBMODULES "" initializes no submodules. </policy/CMP0097>
   CMP0096: project() preserves leading zeros in version components. </policy/CMP0096>
   CMP0095: RPATH entries are properly escaped in the intermediary CMake install script. </policy/CMP0095>

Policies Introduced by CMake 3.15
=================================

.. toctree::
   :maxdepth: 1

   CMP0094: FindPython3, FindPython2 and FindPython use LOCATION for lookup strategy. </policy/CMP0094>
   CMP0093: FindBoost reports Boost_VERSION in x.y.z format. </policy/CMP0093>
   CMP0092: MSVC warning flags are not in CMAKE_{C,CXX}_FLAGS by default. </policy/CMP0092>
   CMP0091: MSVC runtime library flags are selected by an abstraction. </policy/CMP0091>
   CMP0090: export(PACKAGE) does not populate package registry by default. </policy/CMP0090>
   CMP0089: Compiler id for IBM Clang-based XL compilers is now XLClang. </policy/CMP0089>

Policies Introduced by CMake 3.14
=================================

.. toctree::
   :maxdepth: 1

   CMP0088: FindBISON runs bison in CMAKE_CURRENT_BINARY_DIR when executing. </policy/CMP0088>
   CMP0087: install(SCRIPT | CODE) supports generator expressions. </policy/CMP0087>
   CMP0086: UseSWIG honors SWIG_MODULE_NAME via -module flag. </policy/CMP0086>
   CMP0085: IN_LIST generator expression handles empty list items. </policy/CMP0085>
   CMP0084: The FindQt module does not exist for find_package(). </policy/CMP0084>
   CMP0083: Add PIE options when linking executable. </policy/CMP0083>
   CMP0082: Install rules from add_subdirectory() are interleaved with those in caller. </policy/CMP0082>


Policies Introduced by CMake 3.13
=================================

.. toctree::
   :maxdepth: 1

   CMP0081: Relative paths not allowed in LINK_DIRECTORIES target property. </policy/CMP0081>
   CMP0080: BundleUtilities cannot be included at configure time. </policy/CMP0080>
   CMP0079: target_link_libraries allows use with targets in other directories. </policy/CMP0079>
   CMP0078: UseSWIG generates standard target names. </policy/CMP0078>
   CMP0077: option() honors normal variables. </policy/CMP0077>
   CMP0076: target_sources() command converts relative paths to absolute. </policy/CMP0076>

Policies Introduced by CMake 3.12
=================================

.. toctree::
   :maxdepth: 1

   CMP0075: Include file check macros honor CMAKE_REQUIRED_LIBRARIES. </policy/CMP0075>
   CMP0074: find_package uses PackageName_ROOT variables. </policy/CMP0074>
   CMP0073: Do not produce legacy _LIB_DEPENDS cache entries. </policy/CMP0073>

Policies Introduced by CMake 3.11
=================================

.. toctree::
   :maxdepth: 1

   CMP0072: FindOpenGL prefers GLVND by default when available. </policy/CMP0072>

Policies Introduced by CMake 3.10
=================================

.. toctree::
   :maxdepth: 1

   CMP0071: Let AUTOMOC and AUTOUIC process GENERATED files. </policy/CMP0071>
   CMP0070: Define file(GENERATE) behavior for relative paths. </policy/CMP0070>

Policies Introduced by CMake 3.9
================================

.. toctree::
   :maxdepth: 1

   CMP0069: INTERPROCEDURAL_OPTIMIZATION is enforced when enabled. </policy/CMP0069>
   CMP0068: RPATH settings on macOS do not affect install_name. </policy/CMP0068>

Policies Introduced by CMake 3.8
================================

.. toctree::
   :maxdepth: 1

   CMP0067: Honor language standard in try_compile() source-file signature. </policy/CMP0067>

Policies Introduced by CMake 3.7
================================

.. toctree::
   :maxdepth: 1

   CMP0066: Honor per-config flags in try_compile() source-file signature. </policy/CMP0066>

Policies Introduced by CMake 3.4
================================

.. toctree::
   :maxdepth: 1

   CMP0065: Do not add flags to export symbols from executables without the ENABLE_EXPORTS target property. </policy/CMP0065>
   CMP0064: Support new TEST if() operator. </policy/CMP0064>

Policies Introduced by CMake 3.3
================================

.. toctree::
   :maxdepth: 1

   CMP0063: Honor visibility properties for all target types. </policy/CMP0063>
   CMP0062: Disallow install() of export() result. </policy/CMP0062>
   CMP0061: CTest does not by default tell make to ignore errors (-i). </policy/CMP0061>
   CMP0060: Link libraries by full path even in implicit directories. </policy/CMP0060>
   CMP0059: Do not treat DEFINITIONS as a built-in directory property. </policy/CMP0059>
   CMP0058: Ninja requires custom command byproducts to be explicit. </policy/CMP0058>
   CMP0057: Support new IN_LIST if() operator. </policy/CMP0057>

Policies Introduced by CMake 3.2
================================

.. toctree::
   :maxdepth: 1

   CMP0056: Honor link flags in try_compile() source-file signature. </policy/CMP0056>
   CMP0055: Strict checking for break() command. </policy/CMP0055>

Policies Introduced by CMake 3.1
================================

.. toctree::
   :maxdepth: 1

   CMP0054: Only interpret if() arguments as variables or keywords when unquoted. </policy/CMP0054>
   CMP0053: Simplify variable reference and escape sequence evaluation. </policy/CMP0053>
   CMP0052: Reject source and build dirs in installed INTERFACE_INCLUDE_DIRECTORIES. </policy/CMP0052>
   CMP0051: List TARGET_OBJECTS in SOURCES target property. </policy/CMP0051>

Policies Introduced by CMake 3.0
================================

.. toctree::
   :maxdepth: 1

   CMP0050: Disallow add_custom_command SOURCE signatures. </policy/CMP0050>
   CMP0049: Do not expand variables in target source entries. </policy/CMP0049>
   CMP0048: project() command manages VERSION variables. </policy/CMP0048>
   CMP0047: Use QCC compiler id for the qcc drivers on QNX. </policy/CMP0047>
   CMP0046: Error on non-existent dependency in add_dependencies. </policy/CMP0046>
   CMP0045: Error on non-existent target in get_target_property. </policy/CMP0045>
   CMP0044: Case sensitive Lang_COMPILER_ID generator expressions. </policy/CMP0044>
   CMP0043: Ignore COMPILE_DEFINITIONS_Config properties. </policy/CMP0043>
   CMP0042: MACOSX_RPATH is enabled by default. </policy/CMP0042>
   CMP0041: Error on relative include with generator expression. </policy/CMP0041>
   CMP0040: The target in the TARGET signature of add_custom_command() must exist. </policy/CMP0040>
   CMP0039: Utility targets may not have link dependencies. </policy/CMP0039>
   CMP0038: Targets may not link directly to themselves. </policy/CMP0038>
   CMP0037: Target names should not be reserved and should match a validity pattern. </policy/CMP0037>
   CMP0036: The build_name command should not be called. </policy/CMP0036>
   CMP0035: The variable_requires command should not be called. </policy/CMP0035>
   CMP0034: The utility_source command should not be called. </policy/CMP0034>
   CMP0033: The export_library_dependencies command should not be called. </policy/CMP0033>
   CMP0032: The output_required_files command should not be called. </policy/CMP0032>
   CMP0031: The load_command command should not be called. </policy/CMP0031>
   CMP0030: The use_mangled_mesa command should not be called. </policy/CMP0030>
   CMP0029: The subdir_depends command should not be called. </policy/CMP0029>
   CMP0028: Double colon in target name means ALIAS or IMPORTED target. </policy/CMP0028>
   CMP0027: Conditionally linked imported targets with missing include directories. </policy/CMP0027>
   CMP0026: Disallow use of the LOCATION target property. </policy/CMP0026>
   CMP0025: Compiler id for Apple Clang is now AppleClang. </policy/CMP0025>
   CMP0024: Disallow include export result. </policy/CMP0024>

Policies Introduced by CMake 2.8
================================

.. toctree::
   :maxdepth: 1

   CMP0023: Plain and keyword target_link_libraries signatures cannot be mixed. </policy/CMP0023>
   CMP0022: INTERFACE_LINK_LIBRARIES defines the link interface. </policy/CMP0022>
   CMP0021: Fatal error on relative paths in INCLUDE_DIRECTORIES target property. </policy/CMP0021>
   CMP0020: Automatically link Qt executables to qtmain target on Windows. </policy/CMP0020>
   CMP0019: Do not re-expand variables in include and link information. </policy/CMP0019>
   CMP0018: Ignore CMAKE_SHARED_LIBRARY_Lang_FLAGS variable. </policy/CMP0018>
   CMP0017: Prefer files from the CMake module directory when including from there. </policy/CMP0017>
   CMP0016: target_link_libraries() reports error if its only argument is not a target. </policy/CMP0016>
   CMP0015: link_directories() treats paths relative to the source dir. </policy/CMP0015>
   CMP0014: Input directories must have CMakeLists.txt. </policy/CMP0014>
   CMP0013: Duplicate binary directories are not allowed. </policy/CMP0013>
   CMP0012: if() recognizes numbers and boolean constants. </policy/CMP0012>

Policies Introduced by CMake 2.6
================================

.. toctree::
   :maxdepth: 1

   CMP0011: Included scripts do automatic cmake_policy PUSH and POP. </policy/CMP0011>
   CMP0010: Bad variable reference syntax is an error. </policy/CMP0010>
   CMP0009: FILE GLOB_RECURSE calls should not follow symlinks by default. </policy/CMP0009>
   CMP0008: Libraries linked by full-path must have a valid library file name. </policy/CMP0008>
   CMP0007: list command no longer ignores empty elements. </policy/CMP0007>
   CMP0006: Installing MACOSX_BUNDLE targets requires a BUNDLE DESTINATION. </policy/CMP0006>
   CMP0005: Preprocessor definition values are now escaped automatically. </policy/CMP0005>
   CMP0004: Libraries linked may not have leading or trailing whitespace. </policy/CMP0004>
   CMP0003: Libraries linked via full path no longer produce linker search paths. </policy/CMP0003>
   CMP0002: Logical target names must be globally unique. </policy/CMP0002>
   CMP0001: CMAKE_BACKWARDS_COMPATIBILITY should no longer be used. </policy/CMP0001>
   CMP0000: A minimum required CMake version must be specified. </policy/CMP0000>
