.. cmake-manual-description: CMake File-Based API

cmake-file-api(7)
*****************

.. only:: html

   .. contents::

引言
============

CMake提供了一个基于文件的API，客户端可以使用它来获取关于CMake生成的构建系统的语义信息。\
客户端可以通过将查询文件写入构建树的特定位置来请求零个或多个\ `对象类型`_\ 来使用API。\
当CMake在构建树中生成构建系统时，它将读取查询文件并写入应答文件供客户端读取。

基于文件的API使用构建树顶级的\ ``<build>/.cmake/api/``\ 目录。API已版本化，以支持更改\
API目录中的文件布局。API文件布局的版本控制与响应中使用的\ `对象类型`_\ 的版本控制是正交的。\
此版本的CMake只支持一个API版本：\ `API v1`_。

.. versionadded:: 3.27
  项目也可以使用\ :command:`cmake_file_api`\ 命令提交当前运行的查询。

.. _`file-api v1`:

API v1
======

API v1位于\ ``<build>/.cmake/api/v1/``\ 目录下。它有以下子目录：

``query/``
  保存客户端写入的查询文件。这些文件可能是\ `v1共享无状态查询文件`_、\ `v1客户端无状态查询文件`_\
  或\ `v1客户端有状态查询文件`_。

``reply/``
  保存CMake在生成构建系统时所写的应答文件。它们由\ `v1应答索引文件`_\ 文件索引，该文件可能\
  引用其他\ `v1应答文件`_。CMake拥有所有应答文件。客户端永远不能删除它们。

  客户端可以随时查找和读取应答索引文件。客户端可以选择在任何时候创建\ ``reply/``\ 目录，并\
  监视它是否出现新的应答索引文件。

v1共享无状态查询文件
-------------------------------

共享的无状态查询文件允许客户端共享\ `对象类型`_\ 的主要版本的请求，并获得运行的CMake所识别\
的所有请求版本。

客户端可以通过在\ ``v1/query/``\ 目录下创建空文件来创建共享请求。格式如下：\ ::

  <build>/.cmake/api/v1/query/<kind>-v<major>

其中\ ``<kind>``\ 是\ `对象类型`_\ 之一，\ ``-v``\ 是文字，\ ``<major>``\ 是主版本号。

这种形式的文件是无状态共享查询，不属于任何特定的客户端。一旦创建，在没有外部客户协调或人工干\
预的情况下，不应该删除它们。

v1客户端无状态查询文件
-------------------------------

客户端无状态查询文件允许客户端为\ `对象类型`_\ 的主要版本创建自己的请求，并获得运行的CMake\
所识别的所有请求版本。

客户端可以通过在特定于客户端的查询子目录中创建空文件来创建自己的请求。格式如下：\ ::

  <build>/.cmake/api/v1/query/client-<client>/<kind>-v<major>

其中\ ``client-``\ 是字面量，\ ``<client>``\ 是唯一标识客户端的字符串，\ ``<kind>``\
是\ `对象类型`_\ 之一，\ ``-v``\ 是字面意思，\ ``<major>``\ 是主版本号。每个客户端必须选\
择唯一的\ ``<client>``\ 标识符通过它自己的方式。

这种形式的文件是客户端\ ``<client>``\ 拥有的无状态查询。拥有它们的客户端可以随时删除它们。

v1客户端有状态查询文件
------------------------------

有状态查询文件允许客户端请求每个\ `对象类型`_\ 的版本列表，并且只获得运行的CMake所识别的最\
新版本。

客户端可以通过创建\ ``query.json``\ 文件来创建特定于客户端的子目录自有状态查询。格式如下：\ ::

  <build>/.cmake/api/v1/query/client-<client>/query.json

其中\ ``client-``\ 是字面量，\ ``<client>``\ 是唯一标识客户端和查询的字符串。\
``query.json``\ 也是字面量。每个客户端必须通过自己的方式选择唯一的\ ``<client>``\ 标识符。

``query.json``\ 文件是客户端\ ``<client>``\ 拥有的有状态查询。拥有的客户端可以随时更新或\
删除它们。当给定的客户端安装更新时，它可能会更新它写的有状态查询，以构建树以请求更新的对象版本。\
这可以用来避免要求CMake不必要地生成多个对象版本。

一个\ ``query.json``\ 文件必须包含一个JSON对象：

.. code-block:: json

  {
    "requests": [
      { "kind": "<kind>" , "version": 1 },
      { "kind": "<kind>" , "version": { "major": 1, "minor": 2 } },
      { "kind": "<kind>" , "version": [2, 1] },
      { "kind": "<kind>" , "version": [2, { "major": 1, "minor": 2 }] },
      { "kind": "<kind>" , "version": 1, "client": {} },
      { "kind": "..." }
    ],
    "client": {}
  }

成员包括：

``requests``
  包含零个或多个请求的JSON数组。每个请求都是一个JSON对象，包含以下成员：

  ``kind``
    指定要包含在应答中的\ `对象类型`_\ 之一。

  ``version``
    显示客户端可以理解的对象类型的版本。版本有遵循语义版本约定的主要和次要组件。该值必须为

    * 指定（非负的）主版本号的JSON整数，或者
    * 包含指定非负整数版本组件的\ ``major``\ 成员和（可选）\ ``minor``\ 成员的JSON对象，或者
    * 一个JSON数组，其元素均为上述元素之一。

  ``client``
    可选成员，保留给客户端使用。在\ `v1应答索引文件`_\ 中为客户端写的应答中保留该值，否则将\
    被忽略。客户端可以使用它将自定义信息与请求一起传递到它的应答。

  对于每个请求的对象类型，CMake将在请求中列出的对象类型中选择它识别的\ *第一个*\ 版本。响应\
  将使用所选的 *major* 版本和运行中的CMake已知的该主版本的最高\ *minor*\ 版本。因此，客户\
  端应该按照首选顺序列出所有支持的主要版本，以及每个主要版本所需的最小次要版本。

``client``
  可选成员，保留给客户端使用。在\ `v1应答索引文件`_\ 中为客户端写的应答中保留该值，否则将被\
  忽略。客户端可以使用它将带有查询的自定义信息传递给它的应答。

其他\ ``query.json``\ 顶层成员被保留以备将来使用。如果存在，则忽略它们以实现前向兼容性。

v1应答索引文件
-------------------

当运行生成构建系统时，CMake写一个\ ``index-*.json``\ 文件放到\ ``v1/reply/``\ 目录中。\
客户端必须先读取应答索引文件，其他\ `v1应答文件`_\ 只能通过引用读取。应答索引文件名的格式为：\ ::

  <build>/.cmake/api/v1/reply/index-<unspecified>.json

其中\ ``index-``\ 是字面量，\ ``<unspecified>``\ 是CMake选择的未指定名称。每当生成新的\
索引文件时，都会给它一个新名称，并删除旧的名称。在这些步骤之间的短时间内，可能存在多个索引文件；\
按字典顺序排最前的是当前索引文件。

应答索引文件包含一个JSON对象：

.. code-block:: json

  {
    "cmake": {
      "version": {
        "major": 3, "minor": 14, "patch": 0, "suffix": "",
        "string": "3.14.0", "isDirty": false
      },
      "paths": {
        "cmake": "/prefix/bin/cmake",
        "ctest": "/prefix/bin/ctest",
        "cpack": "/prefix/bin/cpack",
        "root": "/prefix/share/cmake-3.14"
      },
      "generator": {
        "multiConfig": false,
        "name": "Unix Makefiles"
      }
    },
    "objects": [
      { "kind": "<kind>",
        "version": { "major": 1, "minor": 0 },
        "jsonFile": "<file>" },
      { "...": "..." }
    ],
    "reply": {
      "<kind>-v<major>": { "kind": "<kind>",
                           "version": { "major": 1, "minor": 0 },
                           "jsonFile": "<file>" },
      "<unknown>": { "error": "unknown query file" },
      "...": {},
      "client-<client>": {
        "<kind>-v<major>": { "kind": "<kind>",
                             "version": { "major": 1, "minor": 0 },
                             "jsonFile": "<file>" },
        "<unknown>": { "error": "unknown query file" },
        "...": {},
        "query.json": {
          "requests": [ {}, {}, {} ],
          "responses": [
            { "kind": "<kind>",
              "version": { "major": 1, "minor": 0 },
              "jsonFile": "<file>" },
            { "error": "unknown query file" },
            { "...": {} }
          ],
          "client": {}
        }
      }
    }
  }

成员包括：

``cmake``
  一个JSON对象，包含有关生成应答的CMake实例的信息。它包含以下成员：

  ``version``
    一个JSON对象，成员指定CMake的版本：

    ``major``, ``minor``, ``patch``
      整数值，指定主版本、次版本和补丁版本组件。
    ``suffix``
      指定版本后缀的字符串（如果有的话），例如\ ``g0abc3``。
    ``string``
      指定完整版本的字符串，格式为\ ``<major>.<minor>.<patch>[-<suffix>]``。
    ``isDirty``
      一个布尔值，指示版本是否从经过本地修改的版本控制源代码树生成。

  ``paths``
    一个JSON对象，指定CMake自带的东西的路径。它有\ :program:`cmake`、\ :program:`ctest`\
    和\ :program:`cpack`\ 成员，它们的值是JSON字符串，指定每个工具的绝对路径，用正斜杠表\
    示。它还有一个\ ``root``\ 成员，用于包含CMake资源的目录的绝对路径，比如\ ``Modules/``\
    目录（见\ :variable:`CMAKE_ROOT`）。

  ``generator``
    一个JSON对象，描述用于构建的CMake生成器。它的成员有：

    ``multiConfig``
      一个布尔值，指定生成器是否支持多个输出配置。
    ``name``
      指定生成器名称的字符串。
    ``platform``
      如果生成器支持\ :variable:`CMAKE_GENERATOR_PLATFORM`，这是一个指定生成器平台名\
      称的字符串。

``objects``
  一个JSON数组，列出了作为应答的一部分生成的所有\ `对象类型`_\ 的所有版本。每个数组项是一个\
  `v1应答文件引用`_。

``reply``
  一个JSON对象，镜像CMake加载以生成回复的\ ``query/``\ 目录的内容。成员是这个格式的

  ``<kind>-v<major>``
    这个表单的成员出现在每个\ `v1共享无状态查询文件`_\ 中，CMake将其识别为具有主要版本\
    ``<major>``\ 的对象kind ``<kind>``\ 的请求。该值是一个\ `v1应答文件引用`_，对该对\
    象类型和版本对应的应答文件的引用。

  ``<unknown>``
    这个表单的成员出现在每个CMake不能识别的\ `v1共享无状态查询文件`_\ 中。该值是一个JSON对\
    象，其单个\ ``error``\ 成员包含一个字符串，该字符串带有错误消息，指示查询文件未知。

  ``client-<client>``
    这个表单的成员出现在每个持有\ `v1客户端无状态查询文件`_\ 的客户端所有的目录中。这是一个\
    JSON对象，镜像查询\ ``query/client-<client>/``\ 目录的内容。成员的格式为：

    ``<kind>-v<major>``
      这个表单的成员出现在每个\ `v1客户端无状态查询文件`_\ 中，这些文件被CMake识别为具有\
      主要版本\ ``<major>``\ 的对象kind ``<kind>``\ 的请求。该值是一个\ `v1应答文件引用`_，\
      对该对象类型和版本对应的应答文件的引用。

    ``<unknown>``
      这个表单的成员出现在每个CMake不能识别的\ `v1客户端无状态查询文件`_\ 中。该值是一个\
      JSON对象，其单个\ ``error``\ 成员包含一个字符串，该字符串带有错误消息，指示查询文件\
      未知。

    ``query.json``
      这个成员出现在使用\ `v1客户端有状态查询文件`_\ 的客户端。如果\ ``query.json``\
      文件未能读取或解析为JSON对象，此成员是一个JSON对象，其单个\ ``error``\ 成员包含一个\
      带有错误消息的字符串。否则，该成员是一个JSON对象，镜像\ ``query.json``\ 文件的内容。\
      成员包括：

      ``client``
        ``query.json``\ 文件副本的\ ``client``\ 成员，如果存在的话。

      ``requests``
        ``query.json``\ 文件副本的\ ``requests``\ 成员，如果存在的话。

      ``responses``
        如果\ ``query.json``\ 文件\ ``requests``\ 成员缺失或无效，该成员是一个JSON对象，\
        其单个\ ``error``\ 成员包含一个带有错误消息的字符串。否则，该成员将包含一个JSON数\
        组，其中以相同的顺序对请求数组的每个条目进行响应。每个响应是

        * 带有单个\ ``error``\ 成员的JSON对象，该成员包含带有错误消息的字符串，或者
        * 一个\ `v1应答文件引用`_\ 对所请求对象类型和所选版本对应的应答文件的引用。

客户端读取应答索引文件后，可以读取它引用的其他\ `v1应答文件`_。

v1应答文件引用
^^^^^^^^^^^^^^^^^^^^^^^

应答索引文件使用JSON对象表示对另一个回复文件的引用，该JSON对象包含成员：

``kind``
  指定\ `对象类型`_\ 之一的字符串。
``version``
  一个JSON对象，其成员\ ``major``\ 和\ ``minor``\ 指定对象类型的整数版本组件。
``jsonFile``
  一个JSON字符串，指定相对于应答索引文件到包含该对象的另一个JSON文件的路径。

v1应答文件
--------------

包含特定\ `对象类型`_\ 的应答文件由CMake编写。这些文件的名称是未指定的，并且不能被客户端解释。\
客户端必须首先读取\ `v1应答索引文件`_，并遵循对所需响应对象名称的引用。

应答文件（包括索引文件）永远不会被同名但内容不同的文件所取代。这允许客户端在运行CMake的同时\
读取文件，这可能会产生一个新的应答。然而，在生成一个新的应答后，CMake将尝试从之前的运行中删\
除它没有写入的应答文件。如果客户端试图读取索引引用的应答文件，但发现文件丢失，这意味着并发\
CMake已经生成了一个新的应答。客户机可以通过读取新的应答索引文件重新开始。

.. _`file-api object kinds`:

对象类型
============

CMake基于文件的API使用以下类型的JSON对象报告构建系统的语义信息。每种对象都使用带有主要和次\
要组件的语义版本控制来独立地进行版本控制。每一种对象都有这样的格式：

.. code-block:: json

  {
    "kind": "<kind>",
    "version": { "major": 1, "minor": 0 },
    "...": {}
  }

``kind``\ 成员是指定对象类型名称的字符串。\ ``version``\ 成员是一个JSON对象，\ ``major``\
成员和\ ``minor``\ 成员指定对象类型版本的整数组成部分。附加的顶层成员是特定于每种对象类型的。

“codemodel”对象类型
-----------------------

``codemodel``\ 对象类型描述了由CMake建模的构建系统结构。

只有一个\ ``codemodel``\ 对象主版本，即版本2。版本1不存在是为了避免与\
:manual:`cmake-server(7)`\ 模式的版本混淆。

“codemodel”版本2
^^^^^^^^^^^^^^^^^^^^^

``codemodel`` object version 2 is a JSON object:

.. code-block:: json

  {
    "kind": "codemodel",
    "version": { "major": 2, "minor": 6 },
    "paths": {
      "source": "/path/to/top-level-source-dir",
      "build": "/path/to/top-level-build-dir"
    },
    "configurations": [
      {
        "name": "Debug",
        "directories": [
          {
            "source": ".",
            "build": ".",
            "childIndexes": [ 1 ],
            "projectIndex": 0,
            "targetIndexes": [ 0 ],
            "hasInstallRule": true,
            "minimumCMakeVersion": {
              "string": "3.14"
            },
            "jsonFile": "<file>"
          },
          {
            "source": "sub",
            "build": "sub",
            "parentIndex": 0,
            "projectIndex": 0,
            "targetIndexes": [ 1 ],
            "minimumCMakeVersion": {
              "string": "3.14"
            },
            "jsonFile": "<file>"
          }
        ],
        "projects": [
          {
            "name": "MyProject",
            "directoryIndexes": [ 0, 1 ],
            "targetIndexes": [ 0, 1 ]
          }
        ],
        "targets": [
          {
            "name": "MyExecutable",
            "directoryIndex": 0,
            "projectIndex": 0,
            "jsonFile": "<file>"
          },
          {
            "name": "MyLibrary",
            "directoryIndex": 1,
            "projectIndex": 0,
            "jsonFile": "<file>"
          }
        ]
      }
    ]
  }

The members specific to ``codemodel`` objects are:

``paths``
  A JSON object containing members:

  ``source``
    A string specifying the absolute path to the top-level source directory,
    represented with forward slashes.

  ``build``
    A string specifying the absolute path to the top-level build directory,
    represented with forward slashes.

``configurations``
  A JSON array of entries corresponding to available build configurations.
  On single-configuration generators there is one entry for the value
  of the :variable:`CMAKE_BUILD_TYPE` variable.  For multi-configuration
  generators there is an entry for each configuration listed in the
  :variable:`CMAKE_CONFIGURATION_TYPES` variable.
  Each entry is a JSON object containing members:

  ``name``
    A string specifying the name of the configuration, e.g. ``Debug``.

  ``directories``
    A JSON array of entries each corresponding to a build system directory
    whose source directory contains a ``CMakeLists.txt`` file.  The first
    entry corresponds to the top-level directory.  Each entry is a
    JSON object containing members:

    ``source``
      A string specifying the path to the source directory, represented
      with forward slashes.  If the directory is inside the top-level
      source directory then the path is specified relative to that
      directory (with ``.`` for the top-level source directory itself).
      Otherwise the path is absolute.

    ``build``
      A string specifying the path to the build directory, represented
      with forward slashes.  If the directory is inside the top-level
      build directory then the path is specified relative to that
      directory (with ``.`` for the top-level build directory itself).
      Otherwise the path is absolute.

    ``parentIndex``
      Optional member that is present when the directory is not top-level.
      The value is an unsigned integer 0-based index of another entry in
      the main ``directories`` array that corresponds to the parent
      directory that added this directory as a subdirectory.

    ``childIndexes``
      Optional member that is present when the directory has subdirectories.
      The value is a JSON array of entries corresponding to child directories
      created by the :command:`add_subdirectory` or :command:`subdirs`
      command.  Each entry is an unsigned integer 0-based index of another
      entry in the main ``directories`` array.

    ``projectIndex``
      An unsigned integer 0-based index into the main ``projects`` array
      indicating the build system project to which the this directory belongs.

    ``targetIndexes``
      Optional member that is present when the directory itself has targets,
      excluding those belonging to subdirectories.  The value is a JSON
      array of entries corresponding to the targets.  Each entry is an
      unsigned integer 0-based index into the main ``targets`` array.

    ``minimumCMakeVersion``
      Optional member present when a minimum required version of CMake is
      known for the directory.  This is the ``<min>`` version given to the
      most local call to the :command:`cmake_minimum_required(VERSION)`
      command in the directory itself or one of its ancestors.
      The value is a JSON object with one member:

      ``string``
        A string specifying the minimum required version in the format::

          <major>.<minor>[.<patch>[.<tweak>]][<suffix>]

        Each component is an unsigned integer and the suffix may be an
        arbitrary string.

    ``hasInstallRule``
      Optional member that is present with boolean value ``true`` when
      the directory or one of its subdirectories contains any
      :command:`install` rules, i.e. whether a ``make install``
      or equivalent rule is available.

    ``jsonFile``
      A JSON string specifying a path relative to the codemodel file
      to another JSON file containing a
      `“codemodel”版本2“directory”对象`_.

      This field was added in codemodel version 2.3.

  ``projects``
    A JSON array of entries corresponding to the top-level project
    and sub-projects defined in the build system.  Each (sub-)project
    corresponds to a source directory whose ``CMakeLists.txt`` file
    calls the :command:`project` command with a project name different
    from its parent directory.  The first entry corresponds to the
    top-level project.

    Each entry is a JSON object containing members:

    ``name``
      A string specifying the name given to the :command:`project` command.

    ``parentIndex``
      Optional member that is present when the project is not top-level.
      The value is an unsigned integer 0-based index of another entry in
      the main ``projects`` array that corresponds to the parent project
      that added this project as a sub-project.

    ``childIndexes``
      Optional member that is present when the project has sub-projects.
      The value is a JSON array of entries corresponding to the sub-projects.
      Each entry is an unsigned integer 0-based index of another
      entry in the main ``projects`` array.

    ``directoryIndexes``
      A JSON array of entries corresponding to build system directories
      that are part of the project.  The first entry corresponds to the
      top-level directory of the project.  Each entry is an unsigned
      integer 0-based index into the main ``directories`` array.

    ``targetIndexes``
      Optional member that is present when the project itself has targets,
      excluding those belonging to sub-projects.  The value is a JSON
      array of entries corresponding to the targets.  Each entry is an
      unsigned integer 0-based index into the main ``targets`` array.

  ``targets``
    A JSON array of entries corresponding to the build system targets.
    Such targets are created by calls to :command:`add_executable`,
    :command:`add_library`, and :command:`add_custom_target`, excluding
    imported targets and interface libraries (which do not generate any
    build rules).  Each entry is a JSON object containing members:

    ``name``
      A string specifying the target name.

    ``id``
      A string uniquely identifying the target.  This matches the ``id``
      field in the file referenced by ``jsonFile``.

    ``directoryIndex``
      An unsigned integer 0-based index into the main ``directories`` array
      indicating the build system directory in which the target is defined.

    ``projectIndex``
      An unsigned integer 0-based index into the main ``projects`` array
      indicating the build system project in which the target is defined.

    ``jsonFile``
      A JSON string specifying a path relative to the codemodel file
      to another JSON file containing a
      `“codemodel”版本2“target”对象`_.

“codemodel”版本2“directory”对象
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A codemodel "directory" object is referenced by a `“codemodel”版本2`_
object's ``directories`` array.  Each "directory" object is a JSON object
with members:

``paths``
  A JSON object containing members:

  ``source``
    A string specifying the path to the source directory, represented
    with forward slashes.  If the directory is inside the top-level
    source directory then the path is specified relative to that
    directory (with ``.`` for the top-level source directory itself).
    Otherwise the path is absolute.

  ``build``
    A string specifying the path to the build directory, represented
    with forward slashes.  If the directory is inside the top-level
    build directory then the path is specified relative to that
    directory (with ``.`` for the top-level build directory itself).
    Otherwise the path is absolute.

``installers``
  A JSON array of entries corresponding to :command:`install` rules.
  Each entry is a JSON object containing members:

  ``component``
    A string specifying the component selected by the corresponding
    :command:`install` command invocation.

  ``destination``
    Optional member that is present for specific ``type`` values below.
    The value is a string specifying the install destination path.
    The path may be absolute or relative to the install prefix.

  ``paths``
    Optional member that is present for specific ``type`` values below.
    The value is a JSON array of entries corresponding to the paths
    (files or directories) to be installed.  Each entry is one of:

    * A string specifying the path from which a file or directory
      is to be installed.  The portion of the path not preceded by
      a ``/`` also specifies the path (name) to which the file
      or directory is to be installed under the destination.

    * A JSON object with members:

      ``from``
        A string specifying the path from which a file or directory
        is to be installed.

      ``to``
        A string specifying the path to which the file or directory
        is to be installed under the destination.

    In both cases the paths are represented with forward slashes.  If
    the "from" path is inside the top-level directory documented by the
    corresponding ``type`` value, then the path is specified relative
    to that directory.  Otherwise the path is absolute.

  ``type``
    A string specifying the type of installation rule.  The value is one
    of the following, with some variants providing additional members:

    ``file``
      An :command:`install(FILES)` or :command:`install(PROGRAMS)` call.
      The ``destination`` and ``paths`` members are populated, with paths
      under the top-level *source* directory expressed relative to it.
      The ``isOptional`` member may exist.
      This type has no additional members.

    ``directory``
      An :command:`install(DIRECTORY)` call.
      The ``destination`` and ``paths`` members are populated, with paths
      under the top-level *source* directory expressed relative to it.
      The ``isOptional`` member may exist.
      This type has no additional members.

    ``target``
      An :command:`install(TARGETS)` call.
      The ``destination`` and ``paths`` members are populated, with paths
      under the top-level *build* directory expressed relative to it.
      The ``isOptional`` member may exist.
      This type has additional members ``targetId``, ``targetIndex``,
      ``targetIsImportLibrary``, and ``targetInstallNamelink``.

    ``export``
      An :command:`install(EXPORT)` call.
      The ``destination`` and ``paths`` members are populated, with paths
      under the top-level *build* directory expressed relative to it.
      The ``paths`` entries refer to files generated automatically by
      CMake for installation, and their actual values are considered
      private implementation details.
      This type has additional members ``exportName`` and ``exportTargets``.

    ``script``
      An :command:`install(SCRIPT)` call.
      This type has additional member ``scriptFile``.

    ``code``
      An :command:`install(CODE)` call.
      This type has no additional members.

    ``importedRuntimeArtifacts``
      An :command:`install(IMPORTED_RUNTIME_ARTIFACTS)` call.
      The ``destination`` member is populated. The ``isOptional`` member may
      exist. This type has no additional members.

    ``runtimeDependencySet``
      An :command:`install(RUNTIME_DEPENDENCY_SET)` call or an
      :command:`install(TARGETS)` call with ``RUNTIME_DEPENDENCIES``. The
      ``destination`` member is populated. This type has additional members
      ``runtimeDependencySetName`` and ``runtimeDependencySetType``.

    ``fileSet``
      An :command:`install(TARGETS)` call with ``FILE_SET``.
      The ``destination`` and ``paths`` members are populated.
      The ``isOptional`` member may exist.
      This type has additional members ``fileSetName``, ``fileSetType``,
      ``fileSetDirectories``, and ``fileSetTarget``.

      This type was added in codemodel version 2.4.

  ``isExcludeFromAll``
    Optional member that is present with boolean value ``true`` when
    :command:`install` is called with the ``EXCLUDE_FROM_ALL`` option.

  ``isForAllComponents``
    Optional member that is present with boolean value ``true`` when
    :command:`install(SCRIPT|CODE)` is called with the
    ``ALL_COMPONENTS`` option.

  ``isOptional``
    Optional member that is present with boolean value ``true`` when
    :command:`install` is called with the ``OPTIONAL`` option.
    This is allowed when ``type`` is ``file``, ``directory``, or ``target``.

  ``targetId``
    Optional member that is present when ``type`` is ``target``.
    The value is a string uniquely identifying the target to be installed.
    This matches the ``id`` member of the target in the main
    "codemodel" object's ``targets`` array.

  ``targetIndex``
    Optional member that is present when ``type`` is ``target``.
    The value is an unsigned integer 0-based index into the main "codemodel"
    object's ``targets`` array for the target to be installed.

  ``targetIsImportLibrary``
    Optional member that is present when ``type`` is ``target`` and
    the installer is for a Windows DLL import library file or for an
    AIX linker import file.  If present, it has boolean value ``true``.

  ``targetInstallNamelink``
    Optional member that is present when ``type`` is ``target`` and
    the installer corresponds to a target that may use symbolic links
    to implement the :prop_tgt:`VERSION` and :prop_tgt:`SOVERSION`
    target properties.
    The value is a string indicating how the installer is supposed to
    handle the symlinks: ``skip`` means the installer should skip the
    symlinks and install only the real file, and ``only`` means the
    installer should install only the symlinks and not the real file.
    In all cases the ``paths`` member lists what it actually installs.

  ``exportName``
    Optional member that is present when ``type`` is ``export``.
    The value is a string specifying the name of the export.

  ``exportTargets``
    Optional member that is present when ``type`` is ``export``.
    The value is a JSON array of entries corresponding to the targets
    included in the export.  Each entry is a JSON object with members:

    ``id``
      A string uniquely identifying the target.  This matches
      the ``id`` member of the target in the main "codemodel"
      object's ``targets`` array.

    ``index``
      An unsigned integer 0-based index into the main "codemodel"
      object's ``targets`` array for the target.

  ``runtimeDependencySetName``
    Optional member that is present when ``type`` is ``runtimeDependencySet``
    and the installer was created by an
    :command:`install(RUNTIME_DEPENDENCY_SET)` call. The value is a string
    specifying the name of the runtime dependency set that was installed.

  ``runtimeDependencySetType``
    Optional member that is present when ``type`` is ``runtimeDependencySet``.
    The value is a string with one of the following values:

    ``library``
      Indicates that this installer installs dependencies that are not macOS
      frameworks.

    ``framework``
      Indicates that this installer installs dependencies that are macOS
      frameworks.

  ``fileSetName``
    Optional member that is present when ``type`` is ``fileSet``. The value is
    a string with the name of the file set.

    This field was added in codemodel version 2.4.

  ``fileSetType``
    Optional member that is present when ``type`` is ``fileSet``. The value is
    a string with the type of the file set.

    This field was added in codemodel version 2.4.

  ``fileSetDirectories``
    Optional member that is present when ``type`` is ``fileSet``. The value
    is a list of strings with the file set's base directories (determined by
    genex-evaluation of :prop_tgt:`HEADER_DIRS` or
    :prop_tgt:`HEADER_DIRS_<NAME>`).

    This field was added in codemodel version 2.4.

  ``fileSetTarget``
    Optional member that is present when ``type`` is ``fileSet``. The value
    is a JSON object with members:

    ``id``
      A string uniquely identifying the target.  This matches
      the ``id`` member of the target in the main "codemodel"
      object's ``targets`` array.

    ``index``
      An unsigned integer 0-based index into the main "codemodel"
      object's ``targets`` array for the target.

    This field was added in codemodel version 2.4.

  ``scriptFile``
    Optional member that is present when ``type`` is ``script``.
    The value is a string specifying the path to the script file on disk,
    represented with forward slashes.  If the file is inside the top-level
    source directory then the path is specified relative to that directory.
    Otherwise the path is absolute.

  ``backtrace``
    Optional member that is present when a CMake language backtrace to
    the :command:`install` or other command invocation that added this
    installer is available.  The value is an unsigned integer 0-based
    index into the ``backtraceGraph`` member's ``nodes`` array.

``backtraceGraph``
  A `“codemodel”版本2“backtrace graph”对象`_ whose nodes are referenced
  from ``backtrace`` members elsewhere in this "directory" object.

“codemodel”版本2“target”对象
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A codemodel "target" object is referenced by a `“codemodel”版本2`_
object's ``targets`` array.  Each "target" object is a JSON object
with members:

``name``
  A string specifying the logical name of the target.

``id``
  A string uniquely identifying the target.  The format is unspecified
  and should not be interpreted by clients.

``type``
  A string specifying the type of the target.  The value is one of
  ``EXECUTABLE``, ``STATIC_LIBRARY``, ``SHARED_LIBRARY``,
  ``MODULE_LIBRARY``, ``OBJECT_LIBRARY``, ``INTERFACE_LIBRARY``,
  or ``UTILITY``.

``backtrace``
  Optional member that is present when a CMake language backtrace to
  the command in the source code that created the target is available.
  The value is an unsigned integer 0-based index into the
  ``backtraceGraph`` member's ``nodes`` array.

``folder``
  Optional member that is present when the :prop_tgt:`FOLDER` target
  property is set.  The value is a JSON object with one member:

  ``name``
    A string specifying the name of the target folder.

``paths``
  A JSON object containing members:

  ``source``
    A string specifying the path to the target's source directory,
    represented with forward slashes.  If the directory is inside the
    top-level source directory then the path is specified relative to
    that directory (with ``.`` for the top-level source directory itself).
    Otherwise the path is absolute.

  ``build``
    A string specifying the path to the target's build directory,
    represented with forward slashes.  If the directory is inside the
    top-level build directory then the path is specified relative to
    that directory (with ``.`` for the top-level build directory itself).
    Otherwise the path is absolute.

``nameOnDisk``
  Optional member that is present for executable and library targets
  that are linked or archived into a single primary artifact.
  The value is a string specifying the file name of that artifact on disk.

``artifacts``
  Optional member that is present for executable and library targets
  that produce artifacts on disk meant for consumption by dependents.
  The value is a JSON array of entries corresponding to the artifacts.
  Each entry is a JSON object containing one member:

  ``path``
    A string specifying the path to the file on disk, represented with
    forward slashes.  If the file is inside the top-level build directory
    then the path is specified relative to that directory.
    Otherwise the path is absolute.

``isGeneratorProvided``
  Optional member that is present with boolean value ``true`` if the
  target is provided by CMake's build system generator rather than by
  a command in the source code.

``install``
  Optional member that is present when the target has an :command:`install`
  rule.  The value is a JSON object with members:

  ``prefix``
    A JSON object specifying the installation prefix.  It has one member:

    ``path``
      A string specifying the value of :variable:`CMAKE_INSTALL_PREFIX`.

  ``destinations``
    A JSON array of entries specifying an install destination path.
    Each entry is a JSON object with members:

    ``path``
      A string specifying the install destination path.  The path may
      be absolute or relative to the install prefix.

    ``backtrace``
      Optional member that is present when a CMake language backtrace to
      the :command:`install` command invocation that specified this
      destination is available.  The value is an unsigned integer 0-based
      index into the ``backtraceGraph`` member's ``nodes`` array.

``link``
  Optional member that is present for executables and shared library
  targets that link into a runtime binary.  The value is a JSON object
  with members describing the link step:

  ``language``
    A string specifying the language (e.g. ``C``, ``CXX``, ``Fortran``)
    of the toolchain is used to invoke the linker.

  ``commandFragments``
    Optional member that is present when fragments of the link command
    line invocation are available.  The value is a JSON array of entries
    specifying ordered fragments.  Each entry is a JSON object with members:

    ``fragment``
      A string specifying a fragment of the link command line invocation.
      The value is encoded in the build system's native shell format.

    ``role``
      A string specifying the role of the fragment's content:

      * ``flags``: link flags.
      * ``libraries``: link library file paths or flags.
      * ``libraryPath``: library search path flags.
      * ``frameworkPath``: macOS framework search path flags.

  ``lto``
    Optional member that is present with boolean value ``true``
    when link-time optimization (a.k.a. interprocedural optimization
    or link-time code generation) is enabled.

  ``sysroot``
    Optional member that is present when the :variable:`CMAKE_SYSROOT_LINK`
    or :variable:`CMAKE_SYSROOT` variable is defined.  The value is a
    JSON object with one member:

    ``path``
      A string specifying the absolute path to the sysroot, represented
      with forward slashes.

``archive``
  Optional member that is present for static library targets.  The value
  is a JSON object with members describing the archive step:

  ``commandFragments``
    Optional member that is present when fragments of the archiver command
    line invocation are available.  The value is a JSON array of entries
    specifying the fragments.  Each entry is a JSON object with members:

    ``fragment``
      A string specifying a fragment of the archiver command line invocation.
      The value is encoded in the build system's native shell format.

    ``role``
      A string specifying the role of the fragment's content:

      * ``flags``: archiver flags.

  ``lto``
    Optional member that is present with boolean value ``true``
    when link-time optimization (a.k.a. interprocedural optimization
    or link-time code generation) is enabled.

``dependencies``
  Optional member that is present when the target depends on other targets.
  The value is a JSON array of entries corresponding to the dependencies.
  Each entry is a JSON object with members:

  ``id``
    A string uniquely identifying the target on which this target depends.
    This matches the main ``id`` member of the other target.

  ``backtrace``
    Optional member that is present when a CMake language backtrace to
    the :command:`add_dependencies`, :command:`target_link_libraries`,
    or other command invocation that created this dependency is
    available.  The value is an unsigned integer 0-based index into
    the ``backtraceGraph`` member's ``nodes`` array.

``fileSets``
  A JSON array of entries corresponding to the target's file sets. Each entry
  is a JSON object with members:

  ``name``
    A string specifying the name of the file set.

  ``type``
    A string specifying the type of the file set.  See
    :command:`target_sources` supported file set types.

  ``visibility``
    A string specifying the visibility of the file set; one of ``PUBLIC``,
    ``PRIVATE``, or ``INTERFACE``.

  ``baseDirectories``
    A JSON array of strings specifying the base directories containing sources
    in the file set.

  This field was added in codemodel version 2.5.

``sources``
  A JSON array of entries corresponding to the target's source files.
  Each entry is a JSON object with members:

  ``path``
    A string specifying the path to the source file on disk, represented
    with forward slashes.  If the file is inside the top-level source
    directory then the path is specified relative to that directory.
    Otherwise the path is absolute.

  ``compileGroupIndex``
    Optional member that is present when the source is compiled.
    The value is an unsigned integer 0-based index into the
    ``compileGroups`` array.

  ``sourceGroupIndex``
    Optional member that is present when the source is part of a source
    group either via the :command:`source_group` command or by default.
    The value is an unsigned integer 0-based index into the
    ``sourceGroups`` array.

  ``isGenerated``
    Optional member that is present with boolean value ``true`` if
    the source is :prop_sf:`GENERATED`.

  ``fileSetIndex``
    Optional member that is present when the source is part of a file set.
    The value is an unsigned integer 0-based index into the ``fileSets``
    array.

    This field was added in codemodel version 2.5.

  ``backtrace``
    Optional member that is present when a CMake language backtrace to
    the :command:`target_sources`, :command:`add_executable`,
    :command:`add_library`, :command:`add_custom_target`, or other
    command invocation that added this source to the target is
    available.  The value is an unsigned integer 0-based index into
    the ``backtraceGraph`` member's ``nodes`` array.

``sourceGroups``
  Optional member that is present when sources are grouped together by
  the :command:`source_group` command or by default.  The value is a
  JSON array of entries corresponding to the groups.  Each entry is
  a JSON object with members:

  ``name``
    A string specifying the name of the source group.

  ``sourceIndexes``
    A JSON array listing the sources belonging to the group.
    Each entry is an unsigned integer 0-based index into the
    main ``sources`` array for the target.

``compileGroups``
  Optional member that is present when the target has sources that compile.
  The value is a JSON array of entries corresponding to groups of sources
  that all compile with the same settings.  Each entry is a JSON object
  with members:

  ``sourceIndexes``
    A JSON array listing the sources belonging to the group.
    Each entry is an unsigned integer 0-based index into the
    main ``sources`` array for the target.

  ``language``
    A string specifying the language (e.g. ``C``, ``CXX``, ``Fortran``)
    of the toolchain is used to compile the source file.

  ``languageStandard``
    Optional member that is present when the language standard is set
    explicitly (e.g. via :prop_tgt:`CXX_STANDARD`) or implicitly by
    compile features.  Each entry is a JSON object with two members:

    ``backtraces``
      Optional member that is present when a CMake language backtrace to
      the ``<LANG>_STANDARD`` setting is available.  If the language
      standard was set implicitly by compile features those are used as
      the backtrace(s).  It's possible for multiple compile features to
      require the same language standard so there could be multiple
      backtraces. The value is a JSON array with each entry being an
      unsigned integer 0-based index into the ``backtraceGraph``
      member's ``nodes`` array.

    ``standard``
      String representing the language standard.

    This field was added in codemodel version 2.2.

  ``compileCommandFragments``
    Optional member that is present when fragments of the compiler command
    line invocation are available.  The value is a JSON array of entries
    specifying ordered fragments.  Each entry is a JSON object with
    one member:

    ``fragment``
      A string specifying a fragment of the compile command line invocation.
      The value is encoded in the build system's native shell format.

  ``includes``
    Optional member that is present when there are include directories.
    The value is a JSON array with an entry for each directory.  Each
    entry is a JSON object with members:

    ``path``
      A string specifying the path to the include directory,
      represented with forward slashes.

    ``isSystem``
      Optional member that is present with boolean value ``true`` if
      the include directory is marked as a system include directory.

    ``backtrace``
      Optional member that is present when a CMake language backtrace to
      the :command:`target_include_directories` or other command invocation
      that added this include directory is available.  The value is
      an unsigned integer 0-based index into the ``backtraceGraph``
      member's ``nodes`` array.

  ``frameworks``
    Optional member that is present when, on Apple platforms, there are
    frameworks. The value is a JSON array with an entry for each directory.
    Each entry is a JSON object with members:

    ``path``
      A string specifying the path to the framework directory,
      represented with forward slashes.

    ``isSystem``
      Optional member that is present with boolean value ``true`` if
      the framework is marked as a system one.

    ``backtrace``
      Optional member that is present when a CMake language backtrace to
      the :command:`target_link_libraries` or other command invocation
      that added this framework is available.  The value is
      an unsigned integer 0-based index into the ``backtraceGraph``
      member's ``nodes`` array.

    This field was added in codemodel version 2.6.

  ``precompileHeaders``
    Optional member that is present when :command:`target_precompile_headers`
    or other command invocations set :prop_tgt:`PRECOMPILE_HEADERS` on the
    target.  The value is a JSON array with an entry for each header.  Each
    entry is a JSON object with members:

    ``header``
      Full path to the precompile header file.

    ``backtrace``
      Optional member that is present when a CMake language backtrace to
      the :command:`target_precompile_headers` or other command invocation
      that added this precompiled header is available.  The value is an
      unsigned integer 0-based index into the ``backtraceGraph`` member's
      ``nodes`` array.

    This field was added in codemodel version 2.1.

  ``defines``
    Optional member that is present when there are preprocessor definitions.
    The value is a JSON array with an entry for each definition.  Each
    entry is a JSON object with members:

    ``define``
      A string specifying the preprocessor definition in the format
      ``<name>[=<value>]``, e.g. ``DEF`` or ``DEF=1``.

    ``backtrace``
      Optional member that is present when a CMake language backtrace to
      the :command:`target_compile_definitions` or other command invocation
      that added this preprocessor definition is available.  The value is
      an unsigned integer 0-based index into the ``backtraceGraph``
      member's ``nodes`` array.

  ``sysroot``
    Optional member that is present when the
    :variable:`CMAKE_SYSROOT_COMPILE` or :variable:`CMAKE_SYSROOT`
    variable is defined.  The value is a JSON object with one member:

    ``path``
      A string specifying the absolute path to the sysroot, represented
      with forward slashes.

``backtraceGraph``
  A `“codemodel”版本2“backtrace graph”对象`_ whose nodes are referenced
  from ``backtrace`` members elsewhere in this "target" object.

“codemodel”版本2“backtrace graph”对象
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``backtraceGraph`` member of a `“codemodel”版本2“directory”对象`_,
or `“codemodel”版本2“target”对象`_ is a JSON object describing a
graph of backtraces.  Its nodes are referenced from ``backtrace`` members
elsewhere in the containing object.  The backtrace graph object members are:

``nodes``
  A JSON array listing nodes in the backtrace graph.  Each entry
  is a JSON object with members:

  ``file``
    An unsigned integer 0-based index into the backtrace ``files`` array.

  ``line``
    An optional member present when the node represents a line within
    the file.  The value is an unsigned integer 1-based line number.

  ``command``
    An optional member present when the node represents a command
    invocation within the file.  The value is an unsigned integer
    0-based index into the backtrace ``commands`` array.

  ``parent``
    An optional member present when the node is not the bottom of
    the call stack.  The value is an unsigned integer 0-based index
    of another entry in the backtrace ``nodes`` array.

``commands``
  A JSON array listing command names referenced by backtrace nodes.
  Each entry is a string specifying a command name.

``files``
  A JSON array listing CMake language files referenced by backtrace nodes.
  Each entry is a string specifying the path to a file, represented
  with forward slashes.  If the file is inside the top-level source
  directory then the path is specified relative to that directory.
  Otherwise the path is absolute.

.. _`file-api configureLog`:

Object Kind "configureLog"
--------------------------

The ``configureLog`` object kind describes the location and contents of
a :manual:`cmake-configure-log(7)` file.

There is only one ``configureLog`` object major version, version 1.

"configureLog" version 1
^^^^^^^^^^^^^^^^^^^^^^^^

``configureLog`` object version 1 is a JSON object:

.. code-block:: json

  {
    "kind": "configureLog",
    "version": { "major": 1, "minor": 0 },
    "path": "/path/to/top-level-build-dir/CMakeFiles/CMakeConfigureLog.yaml",
    "eventKindNames": [ "try_compile-v1", "try_run-v1" ]
  }

The members specific to ``configureLog`` objects are:

``path``
  A string specifying the path to the configure log file.
  Clients must read the log file from this path, which may be
  different than the path documented by :manual:`cmake-configure-log(7)`.
  The log file may not exist if no events are logged.

``eventKindNames``
  A JSON array whose entries are each a JSON string naming one
  of the :manual:`cmake-configure-log(7)` versioned event kinds.
  At most one version of each configure log event kind will be listed.
  Although the configure log may contain other (versioned) event kinds,
  clients must ignore those that are not listed in this field.

“cache”对象类型
-------------------

The ``cache`` object kind lists cache entries.  These are the
:ref:`CMake Language Variables` stored in the persistent cache
(``CMakeCache.txt``) for the build tree.

There is only one ``cache`` object major version, version 2.
Version 1 does not exist to avoid confusion with that from
:manual:`cmake-server(7)` mode.

“cache”版本2
^^^^^^^^^^^^^^^^^

``cache`` object version 2 is a JSON object:

.. code-block:: json

  {
    "kind": "cache",
    "version": { "major": 2, "minor": 0 },
    "entries": [
      {
        "name": "BUILD_SHARED_LIBS",
        "value": "ON",
        "type": "BOOL",
        "properties": [
          {
            "name": "HELPSTRING",
            "value": "Build shared libraries"
          }
        ]
      },
      {
        "name": "CMAKE_GENERATOR",
        "value": "Unix Makefiles",
        "type": "INTERNAL",
        "properties": [
          {
            "name": "HELPSTRING",
            "value": "Name of generator."
          }
        ]
      }
    ]
  }

The members specific to ``cache`` objects are:

``entries``
  A JSON array whose entries are each a JSON object specifying a
  cache entry.  The members of each entry are:

  ``name``
    A string specifying the name of the entry.

  ``value``
    A string specifying the value of the entry.

  ``type``
    A string specifying the type of the entry used by
    :manual:`cmake-gui(1)` to choose a widget for editing.

  ``properties``
    A JSON array of entries specifying associated
    :ref:`cache entry properties <Cache Entry Properties>`.
    Each entry is a JSON object containing members:

    ``name``
      A string specifying the name of the cache entry property.

    ``value``
      A string specifying the value of the cache entry property.

“cmakeFiles”对象类型
------------------------

The ``cmakeFiles`` object kind lists files used by CMake while
configuring and generating the build system.  These include the
``CMakeLists.txt`` files as well as included ``.cmake`` files.

There is only one ``cmakeFiles`` object major version, version 1.

“cmakeFiles”版本1
^^^^^^^^^^^^^^^^^^^^^^

``cmakeFiles`` object version 1 is a JSON object:

.. code-block:: json

  {
    "kind": "cmakeFiles",
    "version": { "major": 1, "minor": 0 },
    "paths": {
      "build": "/path/to/top-level-build-dir",
      "source": "/path/to/top-level-source-dir"
    },
    "inputs": [
      {
        "path": "CMakeLists.txt"
      },
      {
        "isGenerated": true,
        "path": "/path/to/top-level-build-dir/.../CMakeSystem.cmake"
      },
      {
        "isExternal": true,
        "path": "/path/to/external/third-party/module.cmake"
      },
      {
        "isCMake": true,
        "isExternal": true,
        "path": "/path/to/cmake/Modules/CMakeGenericSystem.cmake"
      }
    ]
  }

The members specific to ``cmakeFiles`` objects are:

``paths``
  A JSON object containing members:

  ``source``
    A string specifying the absolute path to the top-level source directory,
    represented with forward slashes.

  ``build``
    A string specifying the absolute path to the top-level build directory,
    represented with forward slashes.

``inputs``
  A JSON array whose entries are each a JSON object specifying an input
  file used by CMake when configuring and generating the build system.
  The members of each entry are:

  ``path``
    A string specifying the path to an input file to CMake, represented
    with forward slashes.  If the file is inside the top-level source
    directory then the path is specified relative to that directory.
    Otherwise the path is absolute.

  ``isGenerated``
    Optional member that is present with boolean value ``true``
    if the path specifies a file that is under the top-level
    build directory and the build is out-of-source.
    This member is not available on in-source builds.

  ``isExternal``
    Optional member that is present with boolean value ``true``
    if the path specifies a file that is not under the top-level
    source or build directories.

  ``isCMake``
    Optional member that is present with boolean value ``true``
    if the path specifies a file in the CMake installation.

“toolchains”对象类型
------------------------

The ``toolchains`` object kind lists properties of the toolchains used during
the build.  These include the language, compiler path, ID, and version.

There is only one ``toolchains`` object major version, version 1.

“toolchains”版本1
^^^^^^^^^^^^^^^^^^^^^^

``toolchains`` object version 1 is a JSON object:

.. code-block:: json

  {
    "kind": "toolchains",
    "version": { "major": 1, "minor": 0 },
    "toolchains": [
      {
        "language": "C",
        "compiler": {
          "path": "/usr/bin/cc",
          "id": "GNU",
          "version": "9.3.0",
          "implicit": {
            "includeDirectories": [
              "/usr/lib/gcc/x86_64-linux-gnu/9/include",
              "/usr/local/include",
              "/usr/include/x86_64-linux-gnu",
              "/usr/include"
            ],
            "linkDirectories": [
              "/usr/lib/gcc/x86_64-linux-gnu/9",
              "/usr/lib/x86_64-linux-gnu",
              "/usr/lib",
              "/lib/x86_64-linux-gnu",
              "/lib"
            ],
            "linkFrameworkDirectories": [],
            "linkLibraries": [ "gcc", "gcc_s", "c", "gcc", "gcc_s" ]
          }
        },
        "sourceFileExtensions": [ "c", "m" ]
      },
      {
        "language": "CXX",
        "compiler": {
          "path": "/usr/bin/c++",
          "id": "GNU",
          "version": "9.3.0",
          "implicit": {
            "includeDirectories": [
              "/usr/include/c++/9",
              "/usr/include/x86_64-linux-gnu/c++/9",
              "/usr/include/c++/9/backward",
              "/usr/lib/gcc/x86_64-linux-gnu/9/include",
              "/usr/local/include",
              "/usr/include/x86_64-linux-gnu",
              "/usr/include"
            ],
            "linkDirectories": [
              "/usr/lib/gcc/x86_64-linux-gnu/9",
              "/usr/lib/x86_64-linux-gnu",
              "/usr/lib",
              "/lib/x86_64-linux-gnu",
              "/lib"
            ],
            "linkFrameworkDirectories": [],
            "linkLibraries": [
              "stdc++", "m", "gcc_s", "gcc", "c", "gcc_s", "gcc"
            ]
          }
        },
        "sourceFileExtensions": [
          "C", "M", "c++", "cc", "cpp", "cxx", "mm", "CPP"
        ]
      }
    ]
  }

The members specific to ``toolchains`` objects are:

``toolchains``
  A JSON array whose entries are each a JSON object specifying a toolchain
  associated with a particular language. The members of each entry are:

  ``language``
    A JSON string specifying the toolchain language, like C or CXX. Language
    names are the same as language names that can be passed to the
    :command:`project` command. Because CMake only supports a single toolchain
    per language, this field can be used as a key.

  ``compiler``
    A JSON object containing members:

    ``path``
      Optional member that is present when the
      :variable:`CMAKE_<LANG>_COMPILER` variable is defined for the current
      language. Its value is a JSON string holding the path to the compiler.

    ``id``
      Optional member that is present when the
      :variable:`CMAKE_<LANG>_COMPILER_ID` variable is defined for the current
      language. Its value is a JSON string holding the ID (GNU, MSVC, etc.) of
      the compiler.

    ``version``
      Optional member that is present when the
      :variable:`CMAKE_<LANG>_COMPILER_VERSION` variable is defined for the
      current language. Its value is a JSON string holding the version of the
      compiler.

    ``target``
      Optional member that is present when the
      :variable:`CMAKE_<LANG>_COMPILER_TARGET` variable is defined for the
      current language. Its value is a JSON string holding the cross-compiling
      target of the compiler.

    ``implicit``
      A JSON object containing members:

      ``includeDirectories``
        Optional member that is present when the
        :variable:`CMAKE_<LANG>_IMPLICIT_INCLUDE_DIRECTORIES` variable is
        defined for the current language. Its value is a JSON array of JSON
        strings where each string holds a path to an implicit include
        directory for the compiler.

      ``linkDirectories``
        Optional member that is present when the
        :variable:`CMAKE_<LANG>_IMPLICIT_LINK_DIRECTORIES` variable is
        defined for the current language. Its value is a JSON array of JSON
        strings where each string holds a path to an implicit link directory
        for the compiler.

      ``linkFrameworkDirectories``
        Optional member that is present when the
        :variable:`CMAKE_<LANG>_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES` variable
        is defined for the current language. Its value is a JSON array of JSON
        strings where each string holds a path to an implicit link framework
        directory for the compiler.

      ``linkLibraries``
        Optional member that is present when the
        :variable:`CMAKE_<LANG>_IMPLICIT_LINK_LIBRARIES` variable is defined
        for the current language. Its value is a JSON array of JSON strings
        where each string holds a path to an implicit link library for the
        compiler.

  ``sourceFileExtensions``
    Optional member that is present when the
    :variable:`CMAKE_<LANG>_SOURCE_FILE_EXTENSIONS` variable is defined for
    the current language. Its value is a JSON array of JSON strings where each
    each string holds a file extension (without the leading dot) for the
    language.
