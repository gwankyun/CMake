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

``codemodel``\ 对象版本2是一个JSON对象：

.. code-block:: json

  {
    "kind": "codemodel",
    "version": { "major": 2, "minor": 7 },
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

特定于\ ``codemodel``\ 对象的成员有：

``paths``
  包含以下成员的JSON对象：

  ``source``
    指定顶层源目录的绝对路径的字符串，用正斜杠表示。

  ``build``
    指定顶层构建目录的绝对路径的字符串，用正斜杠表示。

``configurations``
  一个JSON数组，包含与可用构建配置相对应的条目。在单配置生成器中，有一个条目用于\
  :variable:`CMAKE_BUILD_TYPE`\ 变量的值。对于多配置生成器，\
  :variable:`CMAKE_CONFIGURATION_TYPES`\ 变量中列出的每个配置都有一个条目。每个条目是\
  一个JSON对象，包含以下成员：

  ``name``
    指定配置名称的字符串，例如\ ``Debug``。

  ``directories``
    条目的JSON数组，每个条目对应于构建系统目录，其源目录包含\ ``CMakeLists.txt``\ 文件。\
    第一个条目对应于顶层目录。每个条目是一个JSON对象，包含以下成员：

    ``source``
      指定源目录路径的字符串，用正斜杠表示。如果目录位于顶层源目录中，则指定相对于该目录的路\
      径（使用\ ``.``\ 对于顶层源目录本身）。否则路径是绝对的。

    ``build``
      指定构建目录路径的字符串，用正斜杠表示。如果目录位于顶层构建目录中，则指定相对于该目录\
      的路径（使用\ ``.``\ 对于顶层构建目录本身）。否则路径是绝对的。

    ``parentIndex``
      当目录不是顶层目录时出现的可选成员。该值是主\ ``directories``\ 数组中另一个条目的无\
      符号整数，从0开始索引，该索引对应于将该目录添加为子目录的父目录。

    ``childIndexes``
      当目录有子目录时出现的可选成员。该值为JSON数组，包含由\ :command:`add_subdirectory`\
      或\ :command:`subdirs`\ 命令创建的子目录对应的条目。每个条目都是主\ ``directories``\
      数组中另一个条目的基于0的无符号整数索引。

    ``projectIndex``
      主\ ``projects``\ 数组中基于0的无符号整数索引，指示此目录所属的生成系统项目。

    ``targetIndexes``
      当目录本身具有目标时出现的可选成员，不包括属于子目录的目标。该值是一个JSON数组，包含\
      与目标器对应的条目。每个条目都是一个基于0的无符号整数到主\ ``targets``\ 数组的索引。

    ``minimumCMakeVersion``
      当目录已知CMake的最低要求版本时出现的可选成员。这是对目录本身或其祖先之一的\
      :command:`cmake_minimum_required(VERSION)`\ 命令的最本地调用给出的\ ``<min>``\
      版本。该值是一个JSON对象，只有一个成员：

      ``string``
        一个字符串，指定所需的最小版本，格式为：\ ::

          <major>.<minor>[.<patch>[.<tweak>]][<suffix>]

        每个组件都是一个无符号整数，后缀可以是任意字符串。

    ``hasInstallRule``
      可选成员，当目录或其子目录之一包含任何\ :command:`install`\ 规则时，即\
      ``make install``\ 或等效规则是否可用时，以布尔值\ ``true``\ 出现。

    ``jsonFile``
      一个JSON字符串，指定一个相对于代码模型文件到另一个包含\
      `“codemodel”版本2“directory”对象`_\ 的JSON文件的路径。

      此字段是在代码模型版本2.3中添加的。

  ``projects``
    与构建系统中定义的顶层项目和子项目相对应的条目的JSON数组。每个（子）项目对应于一个源目录，\
    其\ ``CMakeLists.txt``\ 文件调用\ :command:`project`\ 命令时使用的项目名称与父目\
    录不同。第一个条目对应于顶层项目。

    每个条目是一个JSON对象，包含以下成员：

    ``name``
      指定\ :command:`project`\ 命令名称的字符串。

    ``parentIndex``
      当项目不是顶层时出现的可选成员。该值是主\ ``projects``\ 数组中另一个条目的基于0的无\
      符号整数索引，该索引对应于将此项目添加为子项目的父项目。

    ``childIndexes``
      当项目有子项目时出现的可选成员。该值是一个JSON数组，包含与子项目相对应的条目。每个条\
      目都是主\ ``projects``\ 数组中另一个条目的基于0的无符号整数索引。

    ``directoryIndexes``
      一个JSON数组，条目对应于作为项目一部分的构建系统目录。第一个条目对应于项目的顶层目录。\
      每个条目都是一个基于0的无符号整数到主\ ``directories``\ 数组的索引。

    ``targetIndexes``
      当项目本身具有目标时出现的可选成员，不包括属于子项目的目标。该值是一个JSON数组，包含\
      与目标器对应的条目。每个条目都是一个基于0的无符号整数到主\ ``targets``\ 数组的索引。

  ``targets``
    与构建系统目标相对应的条目的JSON数组。这样的目标是通过调用\ :command:`add_executable`、\
    :command:`add_library`\ 和\ :command:`add_custom_target`\ 创建的，不包括导入的\
    目标和接口库（它们不生成任何构建规则）。每个条目是一个JSON对象，包含以下成员：

    ``name``
      指定目标名称的字符串。

    ``id``
      唯一标识目标的字符串。这与\ ``jsonFile``\ 引用的文件中的\ ``id``\ 字段相匹配。

    ``directoryIndex``
      一个基于0的无符号整数到主\ ``directories``\ 数组的索引，指示在其中定义目标的构建系\
      统目录。

    ``projectIndex``
      在主\ ``projects``\ 数组中基于0的无符号整数索引，指示在其中定义目标的构建系统项目。

    ``jsonFile``
      一个JSON字符串，指定从代码模型文件到包含\ `“codemodel”版本2“target”对象`_\ 的另\
      一个JSON文件的相对路径。

“codemodel”版本2“directory”对象
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

代码模型“目录”对象由\ `“codemodel”版本2`_\ 对象的\ ``directories``\ 数组引用。每个\
“directory”对象都是一个JSON对象，包含以下成员：

``paths``
  包含以下成员的JSON对象：

  ``source``
    指定源目录路径的字符串，用正斜杠表示。如果目录位于顶层源目录中，则指定相对于该目录的路径\
    （使用\ ``.``\ 对于顶层源目录本身）。否则路径是绝对的。

  ``build``
    指定构建目录路径的字符串，用正斜杠表示。如果目录位于顶层构建目录中，则指定相对于该目录的\
    路径（使用\ ``.``\ 对于顶层构建目录本身）。否则路径是绝对的。

``installers``
  与\ :command:`install`\ 规则相对应的条目的JSON数组。每个条目是一个JSON对象，包含以下\
  成员：

  ``component``
    指定由相应的\ :command:`install`\ 命令调用选择的组件的字符串。

  ``destination``
    为下面的特定\ ``type``\ 值提供的可选成员。该值是指定安装目标路径的字符串。路径可以是绝\
    对的，也可以是相对于安装前缀的。

  ``paths``
    为下面的特定\ ``type``\ 值提供的可选成员。该值是包含需要安装的路径（文件或目录）对应的\
    条目的JSON数组。每个条目是：

    * 指定要安装的文件或目录的路径的字符串。路径前面没有\ ``/``\ 的部分也指定了要安装到目\
      标目录下的文件或目录的路径（名称）。

    * 一个JSON对象，包含以下成员：

      ``from``
        指定要安装的文件或目录的路径的字符串。

      ``to``
        指定要在目标目录下安装的文件或目录的路径的字符串。

    在这两种情况下，路径都用正斜杠表示。如果“from”路径位于由相应\ ``type``\ 值记录的顶层\
    目录中，则指定相对于该目录的路径。否则路径是绝对的。

  ``type``
    指定安装规则类型的字符串。该值是下列值之一，一些变体提供了额外的成员：

    ``file``
      一个\ :command:`install(FILES)`\ 或\ :command:`install(PROGRAMS)`\ 调用。将\
      填充\ ``destination``\ 和\ ``paths``\ 成员，并使用相对于它表示的顶层\ *源*\ 目\
      录下的路径。\ ``isOptional``\ 成员可能存在。此类型没有其他成员。

    ``directory``
      一个\ :command:`install(DIRECTORY)`\ 调用。将填充\ ``destination``\ 和\
      ``paths``\ 成员，并使用相对于它表示的顶层\ *源*\ 目录下的路径。\ ``isOptional``\
      成员可能存在。此类型没有其他成员。

    ``target``
      一个\ :command:`install(TARGETS)`\ 调用。将填充\ ``destination``\ 和\ ``paths``\
      成员，并使用相对于它表示的顶层\ *构建*\ 目录下的路径。\ ``isOptional``\ 成员可能存\
      在。这个类型有额外的成员\ ``targetId``、\ ``targetIndex``、\ ``targetIsImportLibrary``\
      和\ ``targetInstallNamelink``。

    ``export``
      一个\ :command:`install(EXPORT)`\ 调用。将填充\ ``destination``\ 和\ ``paths``\
      成员，并使用相对于它表示的顶层\ *构建*\ 目录下的路径。\ ``paths``\ 条目指的是CMake\
      为安装自动生成的文件，它们的实际值被认为是私有实现细节。此类型具有额外的成员\
      ``exportName``\ 和\ ``exportTargets``。

    ``script``
      一个\ :command:`install(SCRIPT)`\ 调用。这个类型有额外的成员\ ``scriptFile``。

    ``code``
      一个\ :command:`install(CODE)`\ 调用。此类型没有其他成员。

    ``importedRuntimeArtifacts``
      一个\ :command:`install(IMPORTED_RUNTIME_ARTIFACTS)`\ 调用。已填充\
      ``destination``\ 成员。\ ``isOptional``\ 成员可能存在。此类型没有其他成员。

    ``runtimeDependencySet``
      一个\ :command:`install(RUNTIME_DEPENDENCY_SET)`\ 调用或一个带有\
      ``RUNTIME_DEPENDENCIES``\ 的\ :command:`install(TARGETS)`\ 调用。已填充\
      ``destination``\ 成员。该类型有额外的成员\ ``runtimeDependencySetName``\ 和\
      ``runtimeDependencySetType``。

    ``fileSet``
      一个带有\ ``FILE_SET``\ 的\ :command:`install(TARGETS)`\ 调用。填充\
      ``destination``\ 和\ ``paths``\ 成员。\ ``isOptional``\ 成员可能存在。该类型有\
      额外的成员\ ``fileSetName``、\ ``fileSetType``、\ ``fileSetDirectories``\ 和\
      ``fileSetTarget``。

      此类型在代码模型2.4版中添加。

  ``isExcludeFromAll``
    可选成员，当使用\ ``EXCLUDE_FROM_ALL``\ 选项调用\ :command:`install`\ 时，以布尔值\
    ``true``\ 出现。

  ``isForAllComponents``
    当使用\ ``ALL_COMPONENTS``\ 选项调用\ :command:`install(SCRIPT|CODE)`\ 时，以\
    布尔值\ ``true``\ 呈现的可选成员。

  ``isOptional``
    可选成员，当使用\ ``OPTIONAL``\ 选项调用\ :command:`install`\ 时以布尔值\ ``true``\
    出现。当\ ``type``\ 为\ ``file``、\ ``directory``\ 或\ ``target``\ 时，允许这样做。

  ``targetId``
    当\ ``type``\ 为\ ``target``\ 时出现的可选成员。字符串形式，唯一标识待安装的目标器。\
    这与主“codemodel”对象的\ ``targets``\ 数组中目标的\ ``id``\ 成员相匹配。

  ``targetIndex``
    当\ ``type``\ 为\ ``target``\ 时出现的可选成员。该值是一个无符号整数，基于0的索引，\
    指向要安装的目标器的主“codemodel”对象的\ ``targets``\ 数组。

  ``targetIsImportLibrary``
    可选成员，当\ ``type``\ 为\ ``target``\ 且安装程序用于Windows DLL导入库文件或AIX链\
    接器导入文件时，该成员会出现。如果存在，它的布尔值为\ ``true``。

  ``targetInstallNamelink``
    可选成员，当\ ``type``\ 为\ ``target``\ 并且安装程序对应于可以使用符号链接实现\
    :prop_tgt:`VERSION` 和\ :prop_tgt:`SOVERSION`\ 目标属性的目标时出现。该值是一个字\
    符串，指示安装程序应该如何处理符号链接：\ ``skip``\ 意味着安装程序应该跳过符号链接，只\
    安装真正的文件，并且\ ``only``\ 意味着安装程序应该只安装符号链接，而不是真正的文件。在\
    所有情况下，\ ``paths``\ 成员都会列出它实际安装的内容。

  ``exportName``
    当\ ``type``\ 为\ ``export``\ 时出现的可选成员。该值是一个字符串，指定导出的名称。

  ``exportTargets``
    当\ ``type``\ 为\ ``export``\ 时出现的可选成员。该值是一个JSON数组，包含与导出中包\
    含的目标相对应的条目。每个条目都是一个JSON对象，包含以下成员：

    ``id``
      唯一标识目标的字符串。这与主“codemodel”对象的\ ``targets``\ 数组中目标的\ ``id``\
      成员相匹配。

    ``index``
      一个基于0的无符号整数，索引到目标的主“codemodel”对象的\ ``targets``\ 数组。

  ``runtimeDependencySetName``
    可选成员，当\ ``type``\ 为\ ``runtimeDependencySet``\ 并且安装程序是由\
    :command:`install(RUNTIME_DEPENDENCY_SET)`\ 调用创建时出现。该值是一个字符串，指\
    定所安装的运行时依赖项集的名称。

  ``runtimeDependencySetType``
    当\ ``type``\ 为\ ``runtimeDependencySet``\ 时出现的可选成员。该值是具有以下值之\
    一的字符串：

    ``library``
      指示此安装程序安装非macOS框架的依赖项。

    ``framework``
      指示此安装程序安装macOS框架的依赖项。

  ``fileSetName``
    当\ ``type``\ 为\ ``fileSet``\ 时出现的可选成员。该值是带有文件集名称的字符串。

    此字段在代码模型2.4版中添加。

  ``fileSetType``
    当\ ``type``\ 为\ ``fileSet``\ 时出现的可选成员。该值是带有文件集类型的字符串。

    此字段在代码模型2.4版中添加。

  ``fileSetDirectories``
    当\ ``type``\ 为\ ``fileSet``\ 时出现的可选成员。该值是包含文件集基本目录的字符串列\
    表（由\ :prop_tgt:`HEADER_DIRS`\ 或\ :prop_tgt:`HEADER_DIRS_<NAME>`\ 的生成器\
    表达式值决定)。

    此字段在代码模型2.4版中添加。

  ``fileSetTarget``
    当\ ``type``\ 为\ ``fileSet``\ 时出现的可选成员。该值是一个JSON对象，包含以下成员：

    ``id``
      唯一标识目标的字符串。这与主“codemodel”对象的\ ``targets``\ 数组中目标的\ ``id``\
      成员相匹配。

    ``index``
      一个基于0的无符号整数，索引到目标的主“codemodel”对象的\ ``targets``\ 数组。

    此字段在代码模型2.4版中添加。

  ``scriptFile``
    当\ ``type``\ 为\ ``script``\ 时出现的可选成员。该值是一个字符串，指定磁盘上脚本文件\
    的路径，用正斜杠表示。如果文件位于顶层源目录中，则指定相对于该目录的路径。否则路径是绝对的。

  ``backtrace``
    当CMake语言回溯到添加此安装程序的\ :command:`install`\ 或其他命令调用时出现的可选成\
    员。该值是\ ``backtraceGraph``\ 成员的\ ``nodes``\ 数组中基于0的无符号整数索引。

``backtraceGraph``
  一个\ `“codemodel”版本2“backtrace graph”对象`_，其节点从此“目录”对象中其他地方的\
  ``backtrace``\ 成员引用。

“codemodel”版本2“target”对象
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

代码模型“目标”对象由\ `“codemodel”版本2`_\ 对象的\ ``targets``\ 数组引用。每个“目标”对\
象都是一个JSON对象，包含以下成员：

``name``
  指定目标逻辑名称的字符串。

``id``
  唯一标识目标的字符串。该格式未指定，不应由客户端解释。

``type``
  指定目标类型的字符串。取值为\ ``EXECUTABLE``、\ ``STATIC_LIBRARY``、\
  ``SHARED_LIBRARY``、\ ``MODULE_LIBRARY``、\ ``OBJECT_LIBRARY``、\
  ``INTERFACE_LIBRARY``\ 或\ ``UTILITY``\ 中的一个。

``backtrace``
  当CMake语言回溯到创建目标的源代码中的命令时出现的可选成员。该值是\ ``backtraceGraph``\
  成员的\ ``nodes``\ 数组中基于0的无符号整数索引。

``folder``
  设置\ :prop_tgt:`FOLDER`\ 目标属性时出现的可选成员。该值是一个JSON对象，只有一个成员：

  ``name``
    指定目标文件夹名称的字符串。

``paths``
  包含以下成员的JSON对象：

  ``source``
    指定目标源目录路径的字符串，用正斜杠表示。如果目录位于顶层源目录中，则指定相对于该目录的\
    路径（使用\ ``.``\ 对于顶层源目录本身）。否则路径是绝对的。

  ``build``
    指定目标构建目录路径的字符串，用正斜杠表示。如果目录位于顶层构建目录中，则指定相对于该目\
    录的路径（使用\ ``.``\ 对于顶层构建目录本身）。否则路径是绝对的。

``nameOnDisk``
  可选成员，用于链接或存档为单个主工件的可执行目标和库目标。该值是一个字符串，指定磁盘上工件\
  的文件名。

``artifacts``
  可选成员，它存在于可执行目标和库目标中，这些目标在磁盘上生成供依赖项使用的工件。该值是与工\
  件对应的条目的JSON数组。每个条目是一个JSON对象，包含一个成员：

  ``path``
    指定磁盘上文件路径的字符串，用正斜杠表示。如果文件位于顶层构建目录中，则指定相对于该目录\
    的路径。否则路径是绝对的。

``isGeneratorProvided``
  可选成员，如果目标由CMake的构建系统生成器提供，而不是由源代码中的命令提供，则以布尔值\
  ``true``\ 呈现。

``install``
  当目标具有\ :command:`install`\ 规则时出现的可选成员。该值是一个JSON对象，包含以下成员：

  ``prefix``
    指定安装前缀的JSON对象。它有一个成员：

    ``path``
      指定\ :variable:`CMAKE_INSTALL_PREFIX`\ 值的字符串。

  ``destinations``
    指定安装目标路径的条目的JSON数组。每个条目都是一个JSON对象，包含以下成员：

    ``path``
      指定安装目标路径的字符串。路径可以是绝对的，也可以是相对于安装前缀的。

    ``backtrace``
      当CMake语言回溯到指定此目标的\ :command:`install`\ 命令调用时出现的可选成员。该值是\
      ``backtraceGraph``\ 成员的\ ``nodes``\ 数组中基于0的无符号整数索引。

``launchers``
  可选成员，该成员存在于至少有一个由项目指定的启动程序的可执行目标上。该值是一个JSON数组，\
  包含与指定启动器对应的条目。每个条目都是一个JSON对象，包含以下成员：

  ``command``
    一个字符串，指定磁盘上启动程序的路径，用正斜杠表示。如果文件位于顶层源目录中，则指定相对\
    于该目录的路径。

  ``arguments``
    可选成员，当启动器命令在要启动的可执行文件之前有参数时，该成员会出现。该值是表示参数的\
    字符串的JSON数组。

  ``type``
    指定启动程序类型的字符串。取值为以下任意一种：

    ``emulator``
      交叉编译时目标平台的模拟器。参见\ :prop_tgt:`CROSSCOMPILING_EMULATOR`\ 目标属性。

    ``test``
      用于执行测试的启动程序。请参阅\ :prop_tgt:`TEST_LAUNCHER`\ 目标属性。

  此字段在代码模型版本2.7中添加。

``link``
  可选成员，用于链接到运行时二进制文件的可执行文件和共享库目标。该值是一个JSON对象，其成员描\
  述链接步骤：

  ``language``
    指定工具链的语言（如\ ``C``、\ ``CXX``、\ ``Fortran``）的字符串用于调用链接器。

  ``commandFragments``
    可选成员，当link命令行调用的片段可用时出现。该值是一个JSON数组，包含指定有序片段的条目。\
    每个条目都是一个JSON对象，包含以下成员：

    ``fragment``
      指定link命令行调用片段的字符串。该值以构建系统的本机shell格式编码。

    ``role``
      指定片段内容角色的字符串：

      * ``flags``：链接标志。
      * ``libraries``： 链接库文件路径或标志。
      * ``libraryPath``： 库搜索路径标志。
      * ``frameworkPath``： macOS框架搜索路径标志。

  ``lto``
    可选成员，当启用链接时间优化（也称为过程间优化或链接时间代码生成）时，以布尔值\ ``true``\
    出现。

  ``sysroot``
    可选成员，在定义\ :variable:`CMAKE_SYSROOT_LINK`\ 或\ :variable:`CMAKE_SYSROOT`\
    变量时出现。该值是一个JSON对象，只有一个成员：

    ``path``
      指定到系统根的绝对路径的字符串，用正斜杠表示。

``archive``
  为静态库目标提供的可选成员。该值是一个JSON对象，其成员描述存档步骤：

  ``commandFragments``
    存档程序命令行调用片段可用时出现的可选成员。该值是一个JSON数组，包含指定片段的条目。每个\
    条目都是一个JSON对象，包含以下成员：

    ``fragment``
      指定归档程序命令行调用片段的字符串。该值以构建系统的本机shell格式编码。

    ``role``
      指定片段内容角色的字符串：

      * ``flags``：归档器标志。

  ``lto``
    可选成员，当启用链接时间优化（也称为过程间优化或链接时间代码生成）时，以布尔值\ ``true``\
    出现。

``dependencies``
  当目标依赖于其他目标时出现的可选成员。该值是一个JSON数组，包含与依赖项对应的条目。每个条目\
  都是一个JSON对象，包含以下成员：

  ``id``
    唯一标识此目标所依赖的目标的字符串。这与另一个目标的主\ ``id``\ 成员相匹配。

  ``backtrace``
    当CMake语言回溯到\ :command:`add_dependencies`、\ :command:`target_link_libraries`\
    或其他创建此依赖的命令调用时，该可选成员可用。该值是\ ``backtraceGraph``\ 成员的\
    ``nodes``\ 数组中基于0的无符号整数索引。

``fileSets``
  与目标文件集相对应的条目的JSON数组。每个条目都是一个JSON对象，包含以下成员：

  ``name``
    指定文件集名称的字符串。

  ``type``
    指定文件集类型的字符串。请参阅\ :command:`target_sources`\ 支持的文件集类型。

  ``visibility``
    指定文件集可见性的字符串；\ ``PUBLIC``、\ ``PRIVATE``\ 或\ ``INTERFACE``\ 其中之一。

  ``baseDirectories``
    字符串的JSON数组，每个字符串指定一个包含文件集中的源的基本目录。如果目录位于顶层源目录中，\
    则指定相对于该目录的路径。否则路径是绝对的。

  此字段在代码模型版本2.5中添加。

``sources``
  与目标源文件对应的条目的JSON数组。每个条目都是一个JSON对象，包含以下成员：

  ``path``
    指定磁盘上源文件路径的字符串，用正斜杠表示。如果文件位于顶层源目录中，则指定相对于该目录\
    的路径。否则路径是绝对的。

  ``compileGroupIndex``
    编译源代码时出现的可选成员。该值是一个无符号整数，从0开始索引到\ ``compileGroups``\
    数组。

  ``sourceGroupIndex``
    当源是源组的一部分时，通过\ :command:`source_group`\ 命令或默认情况下出现的可选成员。\
    取值为无符号整数，从0开始索引\ ``sourceGroups``\ 数组。

  ``isGenerated``
    可选成员，如果源是\ :prop_sf:`GENERATED`，则以布尔值\ ``true``\ 出现。

  ``fileSetIndex``
    当源是文件集的一部分时出现的可选成员。该值是一个无符号整数，从0开始索引到\ ``fileSets``\
    数组。

    此字段在代码模型版本2.5中添加。

  ``backtrace``
    可选成员，当CMake语言回溯到\ :command:`target_sources`、\ :command:`add_executable`、\
    :command:`add_library`、\ :command:`add_custom_target`\ 或其他将此源添加到目标\
    的命令调用时，该成员可用。该值是\ ``backtraceGraph``\ 成员的\ ``nodes``\ 数组中基于\
    0的无符号整数索引。

``sourceGroups``
  可选成员，当通过\ :command:`source_group`\ 命令或默认情况下将源分组在一起时出现。该值\
  是一个JSON数组，包含与组对应的条目。每个条目都是一个JSON对象，包含以下成员：

  ``name``
    指定源组名称的字符串。

  ``sourceIndexes``
    一个JSON数组，列出属于该组的源。每个条目都是目标主\ ``sources``\ 数组中基于0的无符号\
    整数索引。

``compileGroups``
  当目标具有可编译的源时出现的可选成员。该值是一个JSON数组，条目对应于所有使用相同设置编译的\
  源组。每个条目都是一个JSON对象，包含以下成员：

  ``sourceIndexes``
    一个JSON数组，列出属于该组的源。每个条目都是目标主\ ``sources``\ 数组中基于0的无符号\
    整数索引。

  ``language``
    指定工具链的语言（例如\ ``C``、\ ``CXX``、\ ``Fortran``）的字符串用于编译源文件。

  ``languageStandard``
    可选成员，当显式设置语言标准（例如通过\ :prop_tgt:`CXX_STANDARD`）或通过编译特性隐式\
    设置语言标准时出现。每个条目是一个JSON对象，包含两个成员：

    ``backtraces``
      当CMake语言回溯到\ ``<LANG>_STANDARD``\ 设置可用时出现的可选成员。如果语言标准是\
      由编译功能隐式设置的，则这些功能用作回溯。多个编译特性可能需要相同的语言标准，因此可能\
      存在多个回溯。该值是一个JSON数组，每个条目都是\ ``backtraceGraph``\ 成员\ ``nodes``\
      数组中基于0的无符号整数索引。

    ``standard``
      表示语言标准的字符串。

    此字段在代码模型2.2版中添加。

  ``compileCommandFragments``
    可选成员，当编译器命令行调用的片段可用时出现。该值是一个JSON数组，包含指定有序片段的条目。\
    每个条目是一个JSON对象，包含一个成员：

    ``fragment``
      指定编译命令行调用片段的字符串。该值以构建系统的本机shell格式编码。

  ``includes``
    存在包含目录时出现的可选成员。该值是一个JSON数组，每个目录都有一个条目。每个条目都是一个\
    JSON对象，包含以下成员：

    ``path``
      指定包含目录路径的字符串，用正斜杠表示。

    ``isSystem``
      可选成员，如果包含目录被标记为系统包含目录，则以布尔值\ ``true``\ 出现。

    ``backtrace``
      可选成员，当CMake语言回溯到\ :command:`target_include_directories`\ 或其他添加\
      此包含目录的命令调用时，该成员可用。该值是\ ``backtraceGraph``\ 成员的\ ``nodes``\
      数组中基于0的无符号整数索引。

  ``frameworks``
    可选成员，当在Apple平台上有框架时存在。该值是一个JSON数组，每个目录都有一个条目。每个条\
    目都是一个JSON对象，包含以下成员：

    ``path``
      指定框架目录路径的字符串，用正斜杠表示。

    ``isSystem``
      可选成员，如果框架被标记为系统框架，则该成员的布尔值为\ ``true``。

    ``backtrace``
      可选成员，当CMake语言回溯到\ :command:`target_link_libraries`\ 或其他添加此框架\
      的命令调用时存在。该值是\ ``backtraceGraph``\ 成员的\ ``nodes``\ 数组中基于0的无\
      符号整数索引。

    此字段在代码模型2.6版中添加。

  ``precompileHeaders``
    当\ :command:`target_precompile_headers`\ 或其他命令调用在目标上设置\
    :prop_tgt:`PRECOMPILE_HEADERS`\ 时出现的可选成员。该值是一个JSON数组，每个标头都有\
    一个条目。每个条目都是一个JSON对象，包含以下成员：

    ``header``
      预编译头文件的完整路径。

    ``backtrace``
      可选成员，当CMake语言回溯到\ :command:`target_precompile_headers`\ 或其他添加\
      此预编译头的命令调用时存在。该值是\ ``backtraceGraph``\ 成员的\ ``nodes``\ 数组\
      中基于0的无符号整数索引。

    此字段在代码模型版本2.1中添加。

  ``defines``
    存在预处理器定义时出现的可选成员。该值是一个JSON数组，每个定义都有一个条目。每个条目都是\
    一个JSON对象，包含以下成员：

    ``define``
      指定预处理器定义的字符串，格式为\ ``<name>[=<value>]``，例如\ ``DEF``\ 或\
      ``DEF=1``。

    ``backtrace``
      可选成员，当CMake语言回溯到\ :command:`target_compile_definitions`\ 或其他添加\
      此预处理器定义的命令调用时，该成员可用。该值是\ ``backtraceGraph``\ 成员的\
      ``nodes``\ 数组中基于0的无符号整数索引。

  ``sysroot``
    定义\ :variable:`CMAKE_SYSROOT_COMPILE`\ 或\ :variable:`CMAKE_SYSROOT`\ 变量\
    时出现的可选成员。该值是一个JSON对象，只有一个成员：

    ``path``
      指定到系统根的绝对路径的字符串，用正斜杠表示。

``backtraceGraph``
  一个\ `“codemodel”版本2“backtrace graph”对象`_，其节点从这个“目标”对象中其他地方的\
  ``backtrace``\ 成员引用。

“codemodel”版本2“backtrace graph”对象
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`“codemodel”版本2“directory”对象`_\ 或\ `“codemodel”版本2“target”对象`_\ 的\
``backtraceGraph``\ 成员是一个描述回溯图的JSON对象。它的节点是从包含对象的其他地方的\
``backtrace``\ 成员引用的。回溯图对象的成员有：

``nodes``
  一个JSON数组，列出回溯图中的节点。每个条目都是一个JSON对象，包含以下成员：

  ``file``
    回溯\ ``files``\ 数组中基于0的无符号整数索引。

  ``line``
    当节点表示文件中的一行时出现的可选成员。无符号整数形式，行号从1开始。

  ``command``
    当节点表示文件中的命令调用时出现的可选成员。该值是一个无符号整数，在回溯\ ``commands``\
    数组中以0为基础的索引。

  ``parent``
    当节点不是调用堆栈的底部时出现的可选成员。该值是回溯\ ``nodes``\ 数组中另一项的基于0的\
    无符号整数索引。

``commands``
  一个JSON数组，列出回溯节点引用的命令名。每个条目都是指定命令名称的字符串。

``files``
  一个JSON数组，列出了回溯节点引用的CMake语言文件。每个条目都是一个字符串，指定文件的路径，\
  用正斜杠表示。如果文件位于顶层源目录中，则指定相对于该目录的路径。否则为绝对路径。

.. _`file-api configureLog`:

“configureLog”对象类型
--------------------------

``configureLog``\ 对象类型描述了\ :manual:`cmake-configure-log(7)`\ 文件的位置和内容。

只有一个\ ``configureLog``\ 对象的主要版本，即版本1。

“configureLog”版本1
^^^^^^^^^^^^^^^^^^^^^^^^

``configureLog``\ 对象版本1是一个JSON对象：

.. code-block:: json

  {
    "kind": "configureLog",
    "version": { "major": 1, "minor": 0 },
    "path": "/path/to/top-level-build-dir/CMakeFiles/CMakeConfigureLog.yaml",
    "eventKindNames": [ "try_compile-v1", "try_run-v1" ]
  }

特定于\ ``configureLog``\ 对象的成员是：

``path``
  指定配置日志文件路径的字符串。客户端必须从该路径读取日志文件，该路径可能与\
  :manual:`cmake-configure-log(7)`\ 记录的路径不同。如果没有记录事件，日志文件可能不存在。

``eventKindNames``
  一个JSON数组，其每个条目都是一个JSON字符串，命名\ :manual:`cmake-configure-log(7)`\
  版本事件类型之一。每种配置日志事件类型最多只列出一个版本。虽然配置日志可能包含其他（版本控\
  制的）事件类型，但客户端必须忽略未在此字段中列出的事件类型。

“cache”对象类型
-------------------

``cache``\ 对象类型列出了缓存项。这些是存储在构建树的持久缓存（\ ``CMakeCache.txt``\ ）\
中的\ :ref:`CMake Language Variables`。

只有一个\ ``cache``\ 对象主版本，即版本2。版本1不存在是为了避免与\ :manual:`cmake-server(7)`\
模式的版本混淆。

“cache”版本2
^^^^^^^^^^^^^^^^^

``cache``\ 对象版本2是一个JSON对象：

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

特定于\ ``cache``\ 对象的成员有：

``entries``
  一个JSON数组，其每个条目都是指定缓存条目的JSON对象。每个表项的成员是：

  ``name``
    指定条目名称的字符串。

  ``value``
    指定条目值的字符串。

  ``type``
    一个字符串，指定\ :manual:`cmake-gui(1)`\ 用来选择要编辑的小部件的条目类型。

  ``properties``
    指定关联\ :ref:`缓存项属性 <Cache Entry Properties>`\ 的条目的JSON数组。每个条目是\
    一个JSON对象，包含以下成员：

    ``name``
      指定缓存项属性名称的字符串。

    ``value``
      指定缓存项属性值的字符串。

“cmakeFiles”对象类型
------------------------

``cmakeFiles``\ 对象类型列出了CMake在配置和生成构建系统时使用的文件。这些文件包括\
``CMakeLists.txt``\ 文件以及包含的\ ``.cmake``\ 文件。

只有一个\ ``cmakeFiles``\ 对象的主要版本，即版本1。

“cmakeFiles”版本1
^^^^^^^^^^^^^^^^^^^^^^

``cmakeFiles``\ 对象版本1是一个JSON对象：

.. code-block:: json

  {
    "kind": "cmakeFiles",
    "version": { "major": 1, "minor": 1 },
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
    ],
    "globsDependent": [
      {
        "expression": "src/*.cxx",
        "recurse": true,
        "files": [
          "src/foo.cxx",
          "src/bar.cxx"
        ]
      }
    ]
  }

特定于\ ``cmakeFiles``\ 对象的成员有：

``paths``
  包含以下成员的JSON对象：

  ``source``
    指定顶层源目录的绝对路径的字符串，用正斜杠表示。

  ``build``
    指定顶层构建目录的绝对路径的字符串，用正斜杠表示。

``inputs``
  一个JSON数组，其每个条目都是一个JSON对象，指定CMake在配置和生成构建系统时使用的输入文件。
  每个表项的成员是：

  ``path``
    指定CMake输入文件路径的字符串，用正斜杠表示。如果文件位于顶层源目录中，则指定相对于该目\
    录的路径。否则路径是绝对的。

  ``isGenerated``
    可选成员，如果路径指定了位于顶层构建目录下的文件并且构建是源外的，则该成员以布尔值\
    ``true``\ 出现。此成员在源内构建中不可用。

  ``isExternal``
    可选成员，如果路径指定的文件不在顶层源目录或构建目录下，则以布尔值\ ``true``\ 出现。

  ``isCMake``
    可选成员，如果路径指定了CMake安装中的文件，则以布尔值\ ``true``\ 出现。

``globsDependent``
  Optional member that is present when the project calls :command:`file(GLOB)`
  or :command:`file(GLOB_RECURSE)` with the ``CONFIGURE_DEPENDS`` option.
  The value is a JSON array of JSON objects, each specifying a globbing
  expression and the list of paths it matched.  If the globbing expression
  no longer matches the same list of paths, CMake considers the build system
  to be out of date.

  This field was added in ``cmakeFiles`` version 1.1.

  The members of each entry are:

  ``expression``
    A string specifying the globbing expression.

  ``recurse``
    Optional member that is present with boolean value ``true``
    if the entry corresponds to a :command:`file(GLOB_RECURSE)` call.
    Otherwise the entry corresponds to a :command:`file(GLOB)` call.

  ``listDirectories``
    Optional member that is present with boolean value ``true`` if
    :command:`file(GLOB)` was called without ``LIST_DIRECTORIES false`` or
    :command:`file(GLOB_RECURSE)` was called with ``LIST_DIRECTORIES true``.

  ``followSymlinks``
    Optional member that is present with boolean value ``true`` if
    :command:`file(GLOB)` was called with the ``FOLLOW_SYMLINKS`` option.

  ``relative``
    Optional member that is present if :command:`file(GLOB)` was called
    with the ``RELATIVE <path>`` option.  The value is a string containing
    the ``<path>`` given.

  ``paths``
    A JSON array of strings specifying the paths matched by the call
    to :command:`file(GLOB)` or :command:`file(GLOB_RECURSE)`.

“toolchains”对象类型
------------------------

``toolchains``\ 对象类型列出了构建过程中使用的工具链的属性。这些包括语言、编译器路径、ID和\
版本。

只有一个\ ``toolchains``\ 对象主版本，即版本1。

“toolchains”版本1
^^^^^^^^^^^^^^^^^^^^^^

``toolchains``\ 对象版本1是一个JSON对象：

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

特定于\ ``toolchains``\ 对象的成员是：

``toolchains``
  一个JSON数组，其每个条目都是一个JSON对象，指定与特定语言关联的工具链。每个表项的成员是：

  ``language``
    指定工具链语言的JSON字符串，如C或CXX。语言名称与可以传递给\ :command:`project`\ 命\
    令的语言名称相同。因为CMake对每种语言只支持一个工具链，所以这个字段可以用作键。

  ``compiler``
    包含以下成员的JSON对象：

    ``path``
      为当前语言定义\ :variable:`CMAKE_<LANG>_COMPILER`\ 变量时出现的可选成员。它的值\
      是一个JSON字符串，包含编译器的路径。

    ``id``
      为当前语言定义\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ 变量时出现的可选成员。它\
      的值是一个JSON字符串，包含编译器的ID （GNU, MSVC等）。

    ``version``
      为当前语言定义\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ 变量时出现的可选成\
      员。它的值是一个JSON字符串，包含编译器的版本。

    ``target``
      为当前语言定义\ :variable:`CMAKE_<LANG>_COMPILER_TARGET`\ 变量时出现的可选成员。\
      它的值是一个JSON字符串，包含编译器的交叉编译目标。

    ``implicit``
      包含以下成员的JSON对象：

      ``includeDirectories``
        为当前语言定义\ :variable:`CMAKE_<LANG>_IMPLICIT_INCLUDE_DIRECTORIES`\
        变量时出现的可选成员。它的值是一个JSON字符串数组，其中每个字符串包含编译器隐式\
        include目录的路径。

      ``linkDirectories``
        为当前语言定义\ :variable:`CMAKE_<LANG>_IMPLICIT_LINK_DIRECTORIES`\ 变量时\
        出现的可选成员。它的值是一个由JSON字符串组成的JSON数组，其中每个字符串都包含一个指\
        向编译器的隐式链接目录的路径。

      ``linkFrameworkDirectories``
        当为当前语言定义\ :variable:`CMAKE_<LANG>_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES`\
        变量时出现的可选成员。它的值是一个由JSON字符串组成的JSON数组，其中每个字符串都包含\
        一个指向编译器的隐式链接框架目录的路径。

      ``linkLibraries``
        为当前语言定义\ :variable:`CMAKE_<LANG>_IMPLICIT_LINK_LIBRARIES`\ 变量时出\
        现的可选成员。它的值是一个JSON字符串数组，其中每个字符串都包含一个指向编译器隐式链\
        接库的路径。

  ``sourceFileExtensions``
    为当前语言定义\ :variable:`CMAKE_<LANG>_SOURCE_FILE_EXTENSIONS`\ 变量时出现的可\
    选成员。它的值是一个JSON字符串数组，其中每个字符串都包含该语言的文件扩展名（没有前面的点）。
