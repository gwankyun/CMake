.. cmake-manual-description: CMake Buildsystem Reference

cmake-buildsystem(7)
********************

.. only:: html

   .. contents::

����
============

����CMake�Ĺ���ϵͳ����֯Ϊһ��߼��߼�Ŀ�ꡣÿ��Ŀ���Ӧ��һ����ִ���ļ���⣬�����ǰ�����\
����������Զ���Ŀ�ꡣĿ��֮���������ϵ�ڹ���ϵͳ�б�ʾ����ȷ������˳�����Ӧ���ĵ��������ɹ���

������Ŀ��
==============

��ִ���ļ��Ϳ�ʹ��\ :command:`add_executable`\ ��\ :command:`add_library`\ ����塣\
���ɵĶ������ļ��������ƽ̨���ʵ�\ :prop_tgt:`PREFIX`��:prop_tgt:`SUFFIX`\ ����չ����\
������Ŀ��֮���������ϵʹ��\ :command:`target_link_libraries`\ �����ʾ��

.. code-block:: cmake

  add_library(archive archive.cpp zip.cpp lzma.cpp)
  add_executable(zipapp zipapp.cpp)
  target_link_libraries(zipapp archive)

``archive``\ ������Ϊһ��\ ``STATIC``\ �⡪��һ������\ ``archive.cpp``��\ ``zip.cpp``\
��\ ``lzma.cpp``\ �������Ĵ浵��\ ``zipapp``\ ������Ϊͨ�����������\ ``zipapp.cpp``\
���γɵĿ�ִ���ļ���������\ ``zipapp``\ ��ִ���ļ�ʱ��\ ``archive``\ ��̬��ᱻ���ӵ���

.. _`Binary Executables`:

�����ƿ�ִ���ļ�
------------------

:command:`add_executable`\ �������һ����ִ��Ŀ�꣺

.. code-block:: cmake

  add_executable(mytool mytool.cpp)

��\ :command:`add_custom_command`\ ���������������Ҫ�ڹ���ʱ���еĹ���\
����͸���ؽ�\ :prop_tgt:`EXECUTABLE <TYPE>`\ Ŀ����Ϊ��ִ��\ ``COMMAND``\ �ļ�ʹ�á�\
����ϵͳ����ȷ���ڳ�����������֮ǰ������ִ���ļ���

�����ƿ�����
--------------------

.. _`Normal Libraries`:

��ͨ��
^^^^^^^^^^^^^^^^

Ĭ������£�:command:`add_library`\ �������һ��\ ``STATIC``\ �⣬����ָ�������͡�\
ʹ���������ʱ������ָ��һ�����ͣ�

.. code-block:: cmake

  add_library(archive SHARED archive.cpp zip.cpp lzma.cpp)

.. code-block:: cmake

  add_library(archive STATIC archive.cpp zip.cpp lzma.cpp)

��������\ :variable:`BUILD_SHARED_LIBS`\ �������ı�\ :command:`add_library`\ ����Ϊ��\
Ĭ������¹�������⡣

����������ϵͳ����������ﾳ�У��ض��Ŀ���\ ``SHARED``\ ����\ ``STATIC``\ �ںܴ�̶�����\
�޹ؽ�Ҫ�ġ������ܿ��������Σ���������淶������API�Ĺ�����ʽ�������Ƶġ�\ ``MODULE``\
�����͵Ĳ�֮ͬ�����ڣ���ͨ�����ᱻ���ӵ�������������\ :command:`target_link_libraries`\
������Ҳ౻ʹ�á�����һ��ʹ������ʱ������Ϊ������ص����͡�����ⲻ�����κη��йܷ���\
������Windows��ԴDLL, C++/CLI DLL������Ҫ��ⲻ��\ ``SHARED``\ �⣬��ΪCMakeϣ��\
``SHARED``\ �����ٵ���һ�����š�

.. code-block:: cmake

  add_library(archive MODULE 7z.cpp)

.. _`Apple Frameworks`:

ƻ�����
""""""""""""""""

һ��\ ``SHARED``\ ����Ա����Ϊ\ :prop_tgt:`FRAMEWORK`\ Ŀ������������һ��macOS��iOS\
���Bundle������\ ``FRAMEWORK``\ Ŀ�����ԵĿ⻹Ӧ������\ :prop_tgt:`FRAMEWORK_VERSION`\
Ŀ�����ԡ�����macOSԼ����������ͨ������Ϊ��A����\ ``MACOSX_FRAMEWORK_IDENTIFIER``\ ����Ϊ\
``CFBundleIdentifier``\ ����������bundle��Ψһ��ʶ��

.. code-block:: cmake

  add_library(MyFramework SHARED MyFramework.cpp)
  set_target_properties(MyFramework PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A # Version "A" is macOS convention
    MACOSX_FRAMEWORK_IDENTIFIER org.cmake.MyFramework
  )

.. _`Object Libraries`:

Ŀ���
^^^^^^^^^^^^^^^^

``OBJECT``\ �����Ͷ������ɱ������Դ�ļ�������Ŀ���ļ��ķǹ鵵���ϡ�\
ͨ��ʹ���﷨\ :genex:`$<TARGET_OBJECTS:name>`�������ļ����Ͽ�����������Ŀ���Դ���롣\
����һ��\ :manual:`generator expression <cmake-generator-expressions(7)>`��\
��������������Ŀ���ṩ\ ``OBJECT``\ �����ݣ�

.. code-block:: cmake

  add_library(archive OBJECT archive.cpp zip.cpp lzma.cpp)

  add_library(archiveExtras STATIC $<TARGET_OBJECTS:archive> extras.cpp)

  add_executable(test_exe $<TARGET_OBJECTS:archive> test.cpp)

��Щ����Ŀ������ӣ���鵵�����轫ʹ�ö����ļ������Լ������Լ���Դ�ļ���

���ߣ������������ӵ�����Ŀ�꣺

.. code-block:: cmake

  add_library(archive OBJECT archive.cpp zip.cpp lzma.cpp)

  add_library(archiveExtras STATIC extras.cpp)
  target_link_libraries(archiveExtras PUBLIC archive)

  add_executable(test_exe test.cpp)
  target_link_libraries(test_exe archive)

����Ŀ������ӣ���鵵�����轫\ *ֱ��*\ ���ӵ�\ ``OBJECT``\ ���еĶ����ļ���\
���⣬��������Ŀ���б���Դ����ʱ��``OBJECT``\ ���ʹ�����󽫵õ����㡣\
���⣬��Щʹ�����󽫴��ݵ���Щ����Ŀ��������

��ʹ��\ :command:`add_custom_command(TARGET)`\ ����ǩ��ʱ������ⲻ������\ ``TARGET``��\
���ǣ������б����ͨ��\ :command:`add_custom_command(OUTPUT)`\ ��\
:command:`file(GENERATE)`\ ʹ��\ ``$<TARGET_OBJECTS:objlib>``��

�����淶��ʹ��Ҫ��
==========================================

Targets build according to their own
`build specification <Target Build Specification_>`_ in combination with
`usage requirements <Target Usage Requirements_>`_ propagated from their
link dependencies.  Both may be specified using target-specific
`commands <Target Commands_>`_.

For example:

.. code-block:: cmake

  add_library(archive SHARED archive.cpp zip.cpp)

  if (LZMA_FOUND)
    # Add a source implementing support for lzma.
    target_sources(archive PRIVATE lzma.cpp)

    # Compile the 'archive' library sources with '-DBUILDING_WITH_LZMA'.
    target_compile_definitions(archive PRIVATE BUILDING_WITH_LZMA)
  endif()

  target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

  add_executable(consumer consumer.cpp)

  # Link 'consumer' to 'archive'.  This also consumes its usage requirements,
  # so 'consumer.cpp' is compiled with '-DUSING_ARCHIVE_LIB'.
  target_link_libraries(consumer archive)


Target Commands
---------------

Target-specific commands populate the
`build specification <Target Build Specification_>`_ of `Binary Targets`_ and
`usage requirements <Target Usage Requirements_>`_ of `Binary Targets`_,
`Interface Libraries`_, and `Imported Targets`_.

.. _`Target Command Scope`:

Invocations must specify scope keywords, each affecting the visibility
of arguments following it.  The scopes are:

``PUBLIC``
  Populates both properties for `building <Target Build Specification_>`_
  and properties for `using <Target Usage Requirements_>`_ a target.

``PRIVATE``
  Populates only properties for `building <Target Build Specification_>`_
  a target.

``INTERFACE``
  Populates only properties for `using <Target Usage Requirements_>`_
  a target.

The commands are:

:command:`target_compile_definitions`
  Populates the :prop_tgt:`COMPILE_DEFINITIONS` build specification and
  :prop_tgt:`INTERFACE_COMPILE_DEFINITIONS` usage requirement properties.

  For example, the call

  .. code-block:: cmake

    target_compile_definitions(archive
      PRIVATE   BUILDING_WITH_LZMA
      INTERFACE USING_ARCHIVE_LIB
    )

  appends ``BUILDING_WITH_LZMA`` to the target's ``COMPILE_DEFINITIONS``
  property and appends ``USING_ARCHIVE_LIB`` to the target's
  ``INTERFACE_COMPILE_DEFINITIONS`` property.

:command:`target_compile_options`
  Populates the :prop_tgt:`COMPILE_OPTIONS` build specification and
  :prop_tgt:`INTERFACE_COMPILE_OPTIONS` usage requirement properties.

:command:`target_compile_features`
  .. versionadded:: 3.1

  Populates the :prop_tgt:`COMPILE_FEATURES` build specification and
  :prop_tgt:`INTERFACE_COMPILE_FEATURES` usage requirement properties.

:command:`target_include_directories`
  Populates the :prop_tgt:`INCLUDE_DIRECTORIES` build specification
  and :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` usage requirement
  properties.  With the ``SYSTEM`` option, it also populates the
  :prop_tgt:`INTERFACE_SYSTEM_INCLUDE_DIRECTORIES` usage requirement.

  For convenience, the :variable:`CMAKE_INCLUDE_CURRENT_DIR` variable
  may be enabled to add the source directory and corresponding build
  directory as ``INCLUDE_DIRECTORIES`` on all targets.  Similarly,
  the :variable:`CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE` variable may
  be enabled to add them as ``INTERFACE_INCLUDE_DIRECTORIES`` on all
  targets.

:command:`target_sources`
  .. versionadded:: 3.1

  Populates the :prop_tgt:`SOURCES` build specification and
  :prop_tgt:`INTERFACE_SOURCES` usage requirement properties.

  It also supports specifying :ref:`File Sets`, which can add C++ module
  sources and headers not listed in the ``SOURCES`` and ``INTERFACE_SOURCES``
  properties.  File sets may also populate the :prop_tgt:`INCLUDE_DIRECTORIES`
  build specification and :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES` usage
  requirement properties with the include directories containing the headers.

:command:`target_precompile_headers`
  .. versionadded:: 3.16

  Populates the :prop_tgt:`PRECOMPILE_HEADERS` build specification and
  :prop_tgt:`INTERFACE_PRECOMPILE_HEADERS` usage requirement properties.

:command:`target_link_libraries`
  Populates the :prop_tgt:`LINK_LIBRARIES` build specification
  and :prop_tgt:`INTERFACE_LINK_LIBRARIES` usage requirement properties.

  This is the primary mechanism by which link dependencies and their
  `usage requirements <Target Usage Requirements_>`_ are transitively
  propagated to affect compilation and linking of a target.

:command:`target_link_directories`
  .. versionadded:: 3.13

  Populates the :prop_tgt:`LINK_DIRECTORIES` build specification and
  :prop_tgt:`INTERFACE_LINK_DIRECTORIES` usage requirement properties.

:command:`target_link_options`
  .. versionadded:: 3.13

  Populates the :prop_tgt:`LINK_OPTIONS` build specification and
  :prop_tgt:`INTERFACE_LINK_OPTIONS` usage requirement properties.

.. _`Target Build Specification`:

Target Build Specification
--------------------------

The build specification of `Binary Targets`_ is represented by target
properties.  For each of the following `compile <Target Compile Properties_>`_
and `link <Target Link Properties_>`_ properties, compilation and linking
of the target is affected both by its own value and by the corresponding
`usage requirement <Target Usage Requirements_>`_ property, named with
an ``INTERFACE_`` prefix, collected from the transitive closure of link
dependencies.

.. _`Target Compile Properties`:

Target Compile Properties
^^^^^^^^^^^^^^^^^^^^^^^^^

These represent the `build specification <Target Build Specification_>`_
for compiling a target.

:prop_tgt:`COMPILE_DEFINITIONS`
  List of compile definitions for compiling sources in the target.
  These are passed to the compiler with ``-D`` flags, or equivalent,
  in an unspecified order.

  The :prop_tgt:`DEFINE_SYMBOL` target property is also used
  as a compile definition as a special convenience case for
  ``SHARED`` and ``MODULE`` library targets.

:prop_tgt:`COMPILE_OPTIONS`
  List of compile options for compiling sources in the target.
  These are passed to the compiler as flags, in the order of appearance.

  Compile options are automatically escaped for the shell.

  Some compile options are best specified via dedicated settings,
  such as the :prop_tgt:`POSITION_INDEPENDENT_CODE` target property.

:prop_tgt:`COMPILE_FEATURES`
  .. versionadded:: 3.1

  List of :manual:`compile features <cmake-compile-features(7)>` needed
  for compiling sources in the target.  Typically these ensure the
  target's sources are compiled using a sufficient language standard level.

:prop_tgt:`INCLUDE_DIRECTORIES`
  List of include directories for compiling sources in the target.
  These are passed to the compiler with ``-I`` or ``-isystem`` flags,
  or equivalent, in the order of appearance.

  For convenience, the :variable:`CMAKE_INCLUDE_CURRENT_DIR` variable
  may be enabled to add the source directory and corresponding build
  directory as ``INCLUDE_DIRECTORIES`` on all targets.

:prop_tgt:`SOURCES`
  List of source files associated with the target.  This includes sources
  specified when the target was created by the :command:`add_executable`,
  :command:`add_library`, or :command:`add_custom_target` command.
  It also includes sources added by the :command:`target_sources` command,
  but does not include :ref:`File Sets`.

:prop_tgt:`PRECOMPILE_HEADERS`
  .. versionadded:: 3.16

  List of header files to precompile and include when compiling
  sources in the target.

:prop_tgt:`AUTOMOC_MACRO_NAMES`
  .. versionadded:: 3.10

  List of macro names used by :prop_tgt:`AUTOMOC` to determine if a
  C++ source in the target needs to be processed by ``moc``.

:prop_tgt:`AUTOUIC_OPTIONS`
  .. versionadded:: 3.0

  List of options used by :prop_tgt:`AUTOUIC` when invoking ``uic``
  for the target.

.. _`Target Link Properties`:

Target Link Properties
^^^^^^^^^^^^^^^^^^^^^^

These represent the `build specification <Target Build Specification_>`_
for linking a target.

:prop_tgt:`LINK_LIBRARIES`
  List of link libraries for linking the target, if it is an executable,
  shared library, or module library.  Entries for `Normal Libraries`_ are
  passed to the linker either via paths to their link artifacts, or
  with ``-l`` flags or equivalent.  Entries for `Object Libraries`_ are
  passed to the linker via paths to their object files.

  Additionally, for compiling and linking the target itself,
  `usage requirements <Target Usage Requirements_>`_ are propagated from
  ``LINK_LIBRARIES`` entries naming `Normal Libraries`_,
  `Interface Libraries`_, `Object Libraries`_, and `Imported Targets`_,
  collected over the transitive closure of their
  :prop_tgt:`INTERFACE_LINK_LIBRARIES` properties.

:prop_tgt:`LINK_DIRECTORIES`
  .. versionadded:: 3.13

  List of link directories for linking the target, if it is an executable,
  shared library, or module library.  The directories are passed to the
  linker with ``-L`` flags, or equivalent.

:prop_tgt:`LINK_OPTIONS`
  .. versionadded:: 3.13

  List of link options for linking the target, if it is an executable,
  shared library, or module library.  The options are passed to the
  linker as flags, in the order of appearance.

  Link options are automatically escaped for the shell.

:prop_tgt:`LINK_DEPENDS`
  List of files on which linking the target depends, if it is an executable,
  shared library, or module library.  For example, linker scripts specified
  via :prop_tgt:`LINK_OPTIONS` may be listed here such that changing them
  causes binaries to be linked again.

.. _`Target Usage Requirements`:

Target Usage Requirements
-------------------------

The *usage requirements* of a target are settings that propagate to consumers,
which link to the target via :command:`target_link_libraries`, in order to
correctly compile and link with it.  They are represented by transitive
`compile <Transitive Compile Properties_>`_ and
`link <Transitive Link Properties_>`_ properties.

Note that usage requirements are not designed as a way to make downstreams
use particular :prop_tgt:`COMPILE_OPTIONS`, :prop_tgt:`COMPILE_DEFINITIONS`,
etc. for convenience only.  The contents of the properties must be
**requirements**, not merely recommendations.

See the :ref:`Creating Relocatable Packages` section of the
:manual:`cmake-packages(7)` manual for discussion of additional care
that must be taken when specifying usage requirements while creating
packages for redistribution.

The usage requirements of a target can transitively propagate to the dependents.
The :command:`target_link_libraries` command has ``PRIVATE``,
``INTERFACE`` and ``PUBLIC`` keywords to control the propagation.

Ŀ���ʹ��������Դ��ݵ������:command:`target_link_libraries`\ �������\
``PRIVATE``��\ ``INTERFACE``\ ��\ ``PUBLIC``\ �ؼ��������ƴ�����

.. code-block:: cmake

  add_library(archive archive.cpp)
  target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

  add_library(serialization serialization.cpp)
  target_compile_definitions(serialization INTERFACE USING_SERIALIZATION_LIB)

  add_library(archiveExtras extras.cpp)
  target_link_libraries(archiveExtras PUBLIC archive)
  target_link_libraries(archiveExtras PRIVATE serialization)
  # archiveExtras is compiled with -DUSING_ARCHIVE_LIB
  # and -DUSING_SERIALIZATION_LIB

  add_executable(consumer consumer.cpp)
  # consumer is compiled with -DUSING_ARCHIVE_LIB
  target_link_libraries(consumer archiveExtras)

��Ϊ\ ``archive``\ ��\ ``archiveExtras``\ ��\ ``PUBLIC``\ �������������ʹ������Ҳ\
�ᴫ����\ ``consumer``��

��Ϊ\ ``serialization``\ ��\ ``archiveExtras``\ ��\ ``PRIVATE``\ �������������ʹ\
�����󲻻ᴫ����\ ``consumer``��

ͨ�������������ֻ�ڿ��ʵ�֣�������ͷ�ļ���ʹ�ã���Ӧ��ʹ��\
:command:`target_link_libraries`\ ��\ ``PRIVATE``\ �ؼ���ָ����������һ�������ڿ�\
��ͷ�ļ��б�����ʹ�ã�����������̳У�����ô��Ӧ�ñ�ָ��Ϊ\ ``PUBLIC``\ ������һ�����ʵ��\
��û��ʹ�õ������ֻ������ͷ�ļ���ʹ��������Ӧ�ñ�ָ��Ϊһ��\ ``INTERFACE``\ �����\
:command:`target_link_libraries`\ ������Զ�ÿ���ؼ��ֽ��ж�ε��ã�

.. code-block:: cmake

  target_link_libraries(archiveExtras
    PUBLIC archive
    PRIVATE serialization
  )

ʹ��Ҫ����ͨ�����������ж�ȡĿ�����Ե�\ ``INTERFACE_``\ ��������ֵ���ӵ��������ķ�\
``INTERFACE_``\ �����������ġ����磬��ȡ������ϵ��\
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ �����丽�ӵ���������\
:prop_tgt:`INCLUDE_DIRECTORIES`\ �С����˳������ص��ұ�ά��������\
:command:`target_link_libraries`\ ���ò�����˳��������ȷ�ı��룬�����ʹ���ʵ�������\
ֱ����������������˳��

���磬���һ��Ŀ������ӿ���밴��\ ``lib1`` ``lib2`` ``lib3``\ ��˳��ָ����\
���ǰ���Ŀ¼���밴��\ ``lib3`` ``lib1`` ``lib2``\ ��˳��ָ����

.. code-block:: cmake

  target_link_libraries(myExe lib1 lib2 lib3)
  target_include_directories(myExe
    PRIVATE $<TARGET_PROPERTY:lib3,INTERFACE_INCLUDE_DIRECTORIES>)

��ע�⣬��ָ����ʹ��\ :command:`install(EXPORT)`\ ������Խ��а�װ��Ŀ���ʹ��Ҫ��ʱ��\
�������С�ġ��йظ�����Ϣ�������\ :ref:`Creating Packages`��

.. _`Transitive Compile Properties`:

Transitive Compile Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

These represent `usage requirements <Target Usage Requirements_>`_ for
compiling consumers.

:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`
  List of compile definitions for compiling sources in the target's consumers.
  Typically these are used by the target's header files.

:prop_tgt:`INTERFACE_COMPILE_OPTIONS`
  List of compile options for compiling sources in the target's consumers.

:prop_tgt:`INTERFACE_COMPILE_FEATURES`
  .. versionadded:: 3.1

  List of :manual:`compile features <cmake-compile-features(7)>` needed
  for compiling sources in the target's consumers.  Typically these
  ensure the target's header files are processed when compiling consumers
  using a sufficient language standard level.

:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`
  List of include directories for compiling sources in the target's consumers.
  Typically these are the locations of the target's header files.

:prop_tgt:`INTERFACE_SYSTEM_INCLUDE_DIRECTORIES`
  List of directories that, when specified as include directories, e.g., by
  :prop_tgt:`INCLUDE_DIRECTORIES` or :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`,
  should be treated as "system" include directories when compiling sources
  in the target's consumers.

:prop_tgt:`INTERFACE_SOURCES`
  List of source files to associate with the target's consumers.

:prop_tgt:`INTERFACE_PRECOMPILE_HEADERS`
  .. versionadded:: 3.16

  List of header files to precompile and include when compiling
  sources in the target's consumers.

:prop_tgt:`INTERFACE_AUTOMOC_MACRO_NAMES`
  .. versionadded:: 3.27

  List of macro names used by :prop_tgt:`AUTOMOC` to determine if a
  C++ source in the target's consumers needs to be processed by ``moc``.

:prop_tgt:`INTERFACE_AUTOUIC_OPTIONS`
  .. versionadded:: 3.0

  List of options used by :prop_tgt:`AUTOUIC` when invoking ``uic``
  for the target's consumers.

.. _`Transitive Link Properties`:

Transitive Link Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^

These represent `usage requirements <Target Usage Requirements_>`_ for
linking consumers.

:prop_tgt:`INTERFACE_LINK_LIBRARIES`
  List of link libraries for linking the target's consumers, for
  those that are executables, shared libraries, or module libraries.
  These are the transitive dependencies of the target.

  Additionally, for compiling and linking the target's consumers,
  `usage requirements <Target Usage Requirements_>`_ are collected from
  the transitive closure of ``INTERFACE_LINK_LIBRARIES`` entries naming
  `Normal Libraries`_, `Interface Libraries`_, `Object Libraries`_,
  and `Imported Targets`_,

:prop_tgt:`INTERFACE_LINK_DIRECTORIES`
  .. versionadded:: 3.13

  List of link directories for linking the target's consumers, for
  those that are executables, shared libraries, or module libraries.

:prop_tgt:`INTERFACE_LINK_OPTIONS`
  .. versionadded:: 3.13

  List of link options for linking the target's consumers, for
  those that are executables, shared libraries, or module libraries.

:prop_tgt:`INTERFACE_LINK_DEPENDS`
  .. versionadded:: 3.13

  List of files on which linking the target's consumers depends, for
  those that are executables, shared libraries, or module libraries.

.. _`Custom Transitive Properties`:

Custom Transitive Properties
----------------------------

.. versionadded:: 3.30

The :genex:`TARGET_PROPERTY` generator expression evaluates the above
`build specification <Target Build Specification_>`_ and
`usage requirement <Target Usage Requirements_>`_ properties
as builtin transitive properties.  It also supports custom transitive
properties defined by the :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`
and :prop_tgt:`TRANSITIVE_LINK_PROPERTIES` properties on the target
and its link dependencies.

For example:

.. code-block:: cmake

  add_library(example INTERFACE)
  set_target_properties(example PROPERTIES
    TRANSITIVE_COMPILE_PROPERTIES "CUSTOM_C"
    TRANSITIVE_LINK_PROPERTIES    "CUSTOM_L"

    INTERFACE_CUSTOM_C "EXAMPLE_CUSTOM_C"
    INTERFACE_CUSTOM_L "EXAMPLE_CUSTOM_L"
    )

  add_library(mylib STATIC mylib.c)
  target_link_libraries(mylib PRIVATE example)
  set_target_properties(mylib PROPERTIES
    CUSTOM_C           "MYLIB_PRIVATE_CUSTOM_C"
    CUSTOM_L           "MYLIB_PRIVATE_CUSTOM_L"
    INTERFACE_CUSTOM_C "MYLIB_IFACE_CUSTOM_C"
    INTERFACE_CUSTOM_L "MYLIB_IFACE_CUSTOM_L"
    )

  add_executable(myexe myexe.c)
  target_link_libraries(myexe PRIVATE mylib)
  set_target_properties(myexe PROPERTIES
    CUSTOM_C "MYEXE_CUSTOM_C"
    CUSTOM_L "MYEXE_CUSTOM_L"
    )

  add_custom_target(print ALL VERBATIM
    COMMAND ${CMAKE_COMMAND} -E echo
      # Prints "MYLIB_PRIVATE_CUSTOM_C;EXAMPLE_CUSTOM_C"
      "$<TARGET_PROPERTY:mylib,CUSTOM_C>"

      # Prints "MYLIB_PRIVATE_CUSTOM_L;EXAMPLE_CUSTOM_L"
      "$<TARGET_PROPERTY:mylib,CUSTOM_L>"

      # Prints "MYEXE_CUSTOM_C"
      "$<TARGET_PROPERTY:myexe,CUSTOM_C>"

      # Prints "MYEXE_CUSTOM_L;MYLIB_IFACE_CUSTOM_L;EXAMPLE_CUSTOM_L"
      "$<TARGET_PROPERTY:myexe,CUSTOM_L>"
    )

.. _`Compatible Interface Properties`:

���ݵĽӿ�����
-------------------------------

һЩĿ��������Ҫ��Ŀ���ÿ��������Ľӿ�֮����ݡ����磬\
:prop_tgt:`POSITION_INDEPENDENT_CODE`\ Ŀ�����Կ���ָ��һ������ֵ����ʾĿ���Ƿ�Ӧ�ñ�\
����Ϊλ���޹صĴ��룬������ض���ƽ̨�Ľ����Ŀ�껹����ָ��ʹ��Ҫ��\
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`\ ��֪ͨ�����߱��뱻����Ϊλ���޹ش��롣

.. code-block:: cmake

  add_executable(exe1 exe1.cpp)
  set_property(TARGET exe1 PROPERTY POSITION_INDEPENDENT_CODE ON)

  add_library(lib1 SHARED lib1.cpp)
  set_property(TARGET lib1 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1)

�����``exe1``\ ��\ ``exe2``\ ����������Ϊλ���޹ش��롣``lib1``\ Ҳ��������Ϊλ���޹�\
���룬��Ϊ����\ ``SHARED``\ ���Ĭ�����á����������ϵ�г�ͻ�ġ������ݵ�Ҫ��\
:manual:`cmake(1)`\ �ᷢ��һ����ϣ�

.. code-block:: cmake

  add_library(lib1 SHARED lib1.cpp)
  set_property(TARGET lib1 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

  add_library(lib2 SHARED lib2.cpp)
  set_property(TARGET lib2 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE OFF)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1)
  set_property(TARGET exe1 PROPERTY POSITION_INDEPENDENT_CODE OFF)

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1 lib2)

``lib1``\ Ҫ��\ ``INTERFACE_POSITION_INDEPENDENT_CODE``\ ��\ ``exe1``\ Ŀ���\
:prop_tgt:`POSITION_INDEPENDENT_CODE`\ ���Բ������ݡ�����Ҫ�������߹���Ϊλ���޹ش��룬\
����ִ���ļ�ָ��������Ϊλ���޹ش��룬��˻ᷢ����ϡ�

``lib1``\ ��\ ``lib2``\ Ҫ�󲻡����ݡ�������һ��Ҫ�������߹���Ϊ��λ���޹صĴ��룬����һ\
����δҪ�������߹���Ϊ��λ���޹صĴ��롣��Ϊ\ ``exe2``\ ���ӵ����ߣ����������ǳ�ͻ�ģ���\
�Իᷢ��һ��CMake������Ϣ�� ::

  CMake Error: The INTERFACE_POSITION_INDEPENDENT_CODE property of "lib2" does
  not agree with the value of POSITION_INDEPENDENT_CODE already determined
  for "exe2".

Ϊ�ˡ����ݡ������������\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ ���ԣ��ڲ��������ϣ�\
���������ø����Ե����д���ָ���������\ :prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`\
������ͬ��

ͨ����\ :prop_tgt:`COMPATIBLE_INTERFACE_BOOL`\ Ŀ�����Ե�������ָ�������ԣ������ݽӿ�Ҫ\
�󡱵����Կ�����չ���������ԡ�ÿ��ָ�������Ա���������Ŀ��Ͷ�Ӧ������֮����ݣ�ÿ����������һ��\
``INTERFACE_``\ ǰ׺��

.. code-block:: cmake

  add_library(lib1Version2 SHARED lib1_v2.cpp)
  set_property(TARGET lib1Version2 PROPERTY INTERFACE_CUSTOM_PROP ON)
  set_property(TARGET lib1Version2 APPEND PROPERTY
    COMPATIBLE_INTERFACE_BOOL CUSTOM_PROP
  )

  add_library(lib1Version3 SHARED lib1_v3.cpp)
  set_property(TARGET lib1Version3 PROPERTY INTERFACE_CUSTOM_PROP OFF)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1Version2) # CUSTOM_PROP will be ON

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1Version2 lib1Version3) # Diagnostic

�ǲ�������Ҳ���Բ��롰���ݽӿڡ����㡣��\ :prop_tgt:`COMPATIBLE_INTERFACE_STRING`\ ����\
��ָ�������Ա�����δָ���ģ����������д���ָ�����������е���ͬ�ַ�����Ƚϡ���������ȷ�����\
��������ݰ汾����ͨ��Ŀ��Ĵ���Ҫ��������һ��

.. code-block:: cmake

  add_library(lib1Version2 SHARED lib1_v2.cpp)
  set_property(TARGET lib1Version2 PROPERTY INTERFACE_LIB_VERSION 2)
  set_property(TARGET lib1Version2 APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING LIB_VERSION
  )

  add_library(lib1Version3 SHARED lib1_v3.cpp)
  set_property(TARGET lib1Version3 PROPERTY INTERFACE_LIB_VERSION 3)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1Version2) # LIB_VERSION will be "2"

  add_executable(exe2 exe2.cpp)
  target_link_libraries(exe2 lib1Version2 lib1Version3) # Diagnostic

:prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MAX`\ Ŀ������ָ�����ݽ�����ֵ���㣬���ҽ�����\
����ָ�������ֵ��

.. code-block:: cmake

  add_library(lib1Version2 SHARED lib1_v2.cpp)
  set_property(TARGET lib1Version2 PROPERTY INTERFACE_CONTAINER_SIZE_REQUIRED 200)
  set_property(TARGET lib1Version2 APPEND PROPERTY
    COMPATIBLE_INTERFACE_NUMBER_MAX CONTAINER_SIZE_REQUIRED
  )

  add_library(lib1Version3 SHARED lib1_v3.cpp)
  set_property(TARGET lib1Version3 PROPERTY INTERFACE_CONTAINER_SIZE_REQUIRED 1000)

  add_executable(exe1 exe1.cpp)
  # CONTAINER_SIZE_REQUIRED will be "200"
  target_link_libraries(exe1 lib1Version2)

  add_executable(exe2 exe2.cpp)
  # CONTAINER_SIZE_REQUIRED will be "1000"
  target_link_libraries(exe2 lib1Version2 lib1Version3)

���Ƶأ�����ʹ��\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MIN`\ ���������м������Ե���\
С��ֵ��

ÿ��������ġ����ݡ�����ֵ������������ʱʹ�����������ʽ���������ж�ȡ��

��ע�⣬����ÿ���������ߣ�ÿ�����ݽӿ�������ָ�������Լ��������κ�����������ָ�������Լ��ཻ��

������Դ����
-------------------------

��Ϊ�����淶������������ϵ����������Ŀ��͸������ù����淶�Ĵ���ȱ�����ػ����ܻ�ʹ���������\
��\ :manual:`cmake(1)`\ �ṩ��һ�����Թ��ߣ���ӡ�������ݵ���Դ�����������������ϵ����\
�ġ����Ե��Ե���������\ :variable:`CMAKE_DEBUG_TARGET_PROPERTIES`\ �����ĵ��У�

.. code-block:: cmake

  set(CMAKE_DEBUG_TARGET_PROPERTIES
    INCLUDE_DIRECTORIES
    COMPILE_DEFINITIONS
    POSITION_INDEPENDENT_CODE
    CONTAINER_SIZE_REQUIRED
    LIB_VERSION
  )
  add_executable(exe1 exe1.cpp)

������\ :prop_tgt:`COMPATIBLE_INTERFACE_BOOL`\ ��\
:prop_tgt:`COMPATIBLE_INTERFACE_STRING`\ ���г������ԣ����������ʾ�ĸ�Ŀ�긺�����ø�\
���ԣ��Լ��ĸ�����������Ҳ�����˸����ԡ���\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MAX`\
��\ :prop_tgt:`COMPATIBLE_INTERFACE_NUMBER_MIN`\ ������£����������ʾÿ�����������\
��ֵ���Լ���ֵ�Ƿ�������µļ�ֵ��

ʹ�����������ʽ�����淶
----------------------------------------------

�����淶����ʹ��\ :manual:`���������ʽ <cmake-generator-expressions(7)>`�����а�����\
�����Ļ�������ʱ��֪�������ݡ����磬����������ԡ�compatible��ֵ����ͨ��\
``TARGET_PROPERTY``\ ���ʽ��ȡ��

.. code-block:: cmake

  add_library(lib1Version2 SHARED lib1_v2.cpp)
  set_property(TARGET lib1Version2 PROPERTY
    INTERFACE_CONTAINER_SIZE_REQUIRED 200)
  set_property(TARGET lib1Version2 APPEND PROPERTY
    COMPATIBLE_INTERFACE_NUMBER_MAX CONTAINER_SIZE_REQUIRED
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1Version2)
  target_compile_definitions(exe1 PRIVATE
      CONTAINER_SIZE=$<TARGET_PROPERTY:CONTAINER_SIZE_REQUIRED>
  )

�ڱ����У���ʹ��\ ``-DCONTAINER_SIZE=200``\ ����\ ``exe1``\ Դ�ļ���

һԪ\ ``TARGET_PROPERTY``\ ���������ʽ��\ ``TARGET_POLICY``\ ���������ʽ��������Ŀ\
���������м���ġ�����ζ��ʹ��Ҫ��淶���Ը���ʹ���ߵĲ�ͬ����������

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  target_compile_definitions(lib1 INTERFACE
    $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:LIB1_WITH_EXE>
    $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:LIB1_WITH_SHARED_LIB>
    $<$<TARGET_POLICY:CMP0041>:CONSUMER_CMP0041_NEW>
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1)

  cmake_policy(SET CMP0041 NEW)

  add_library(shared_lib shared_lib.cpp)
  target_link_libraries(shared_lib lib1)

``exe1``\ ��ִ���ļ���ʹ��\ ``-DLIB1_WITH_EXE``\ ���룬\
��\ ``shared_lib``\ ����⽫ʹ��\ ``-DLIB1_WITH_SHARED_LIB``\ ��\
``-DCONSUMER_CMP0041_NEW``\ ���룬��Ϊ����\ :policy:`CMP0041`\ �ڴ���\
``shared_lib``\ Ŀ��ĵط���\ ``NEW``��

``BUILD_INTERFACE``\ ���ʽ��װ��������ڴ�ͬһ������ϵͳ�е�Ŀ������ʱʹ�ã�������ʹ��\
:command:`export`\ ����ӵ���������Ŀ¼��Ŀ������ʱʹ�á�\ ``INSTALL_INTERFACE``\ ���\
ʽ��װ��ֻ��ʹ��\ :command:`install(EXPORT)`\ ���װ��������Ŀ��ʱʹ�õ�����

.. code-block:: cmake

  add_library(ClimbingStats climbingstats.cpp)
  target_compile_definitions(ClimbingStats INTERFACE
    $<BUILD_INTERFACE:ClimbingStats_FROM_BUILD_LOCATION>
    $<INSTALL_INTERFACE:ClimbingStats_FROM_INSTALLED_LOCATION>
  )
  install(TARGETS ClimbingStats EXPORT libExport ${InstallArgs})
  install(EXPORT libExport NAMESPACE Upstream::
          DESTINATION lib/cmake/ClimbingStats)
  export(EXPORT libExport NAMESPACE Upstream::)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 ClimbingStats)

����������£�\ ``exe1``\ ��ִ���ļ���ʹ��\ ``-DClimbingStats_FROM_BUILD_LOCATION``\
���б��롣������������\ :prop_tgt:`IMPORTED`\ Ŀ�꣬����ʡ����\ ``INSTALL_INTERFACE``\
��\ ``BUILD_INTERFACE``��ȥ����\ ``*_INTERFACE``\ ��ǡ�ʹ��\ ``ClimbingStats``\
����һ��������Ŀ��������

.. code-block:: cmake

  find_package(ClimbingStats REQUIRED)

  add_executable(Downstream main.cpp)
  target_link_libraries(Downstream Upstream::ClimbingStats)

``Downstream``\ Ŀ�꽫ʹ��\ ``-DClimbingStats_FROM_BUILD_LOCATION``\ ��\
``-DClimbingStats_FROM_INSTALL_LOCATION``\ ���룬��ȡ����\ ``ClimbingStats``\ ����\
�ӹ���λ�û��ǰ�װλ��ʹ�õġ��йذ��͵����ĸ�����Ϣ�������\ :manual:`cmake-packages(7)`\
�ֲᡣ

.. _`Include Directories and Usage Requirements`:

����Ŀ¼��ʹ��Ҫ��
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

����Ŀ¼����Ϊʹ��Ҫ��ָ���������������ʽһ��ʹ��ʱ��ҪһЩ���⿼�ǡ�\
:command:`target_include_directories`\ ������Խ�����԰���Ŀ¼�;��԰���Ŀ¼��

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  target_include_directories(lib1 PRIVATE
    /absolute/path
    relative/path
  )

���·��������ڳ��������ԴĿ¼���н��͵ġ�:prop_tgt:`IMPORTED`\ Ŀ���\
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ �в����������·����

��ʹ�÷�ƽ�����������ʽ������£�������\ ``INSTALL_INTERFACE``\ ���ʽ�Ĳ�����ʹ��\
``INSTALL_PREFIX``\ ���ʽ������һ���滻��ǣ��ڱ�������Ŀ����ʱ��չΪ��װǰ׺��

�����������Ͱ�װ��֮���Ŀ¼ʹ������ͨ����ͬ��``BUILD_INTERFACE``\ ��\
``INSTALL_INTERFACE``\ ���������ʽ��������������ʹ��λ�õĵ���ʹ������\
``INSTALL_INTERFACE``\ ���ʽ������ʹ�����·������������ڰ�װǰ׺���н��͡����磺

.. code-block:: cmake

  add_library(ClimbingStats climbingstats.cpp)
  target_include_directories(ClimbingStats INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/generated>
    $<INSTALL_INTERFACE:/absolute/path>
    $<INSTALL_INTERFACE:relative/path>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/$<CONFIG>/generated>
  )

CMake�ṩ�������Ŀ¼ʹ��������ص��������API��\
����\ :variable:`CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE`\ ���Ա����ã��������൱�ڣ�

.. code-block:: cmake

  set_property(TARGET tgt APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR}>
  )

����ÿ����Ӱ���Ŀ�ꡣ�����Ѱ�װ��Ŀ����˵��\
ʹ��\ :command:`install(TARGETS)`\ ������Է����ʹ��\ ``INCLUDES DESTINATION``\ �����

.. code-block:: cmake

  install(TARGETS foo bar bat EXPORT tgts ${dest_args}
    INCLUDES DESTINATION include
  )
  install(EXPORT tgts ${other_args})
  install(FILES ${headers} DESTINATION include)

���൱������\ :command:`install(EXPORT)`\ ���ɵ�ÿ���Ѱ�װ��\ :prop_tgt:`IMPORTED`\
Ŀ���\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ �и���\
``${CMAKE_INSTALL_PREFIX}/include``��

��\ :ref:`�����Ŀ�� <Imported targets>`\ ��\
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`\ ��ʹ��ʱ���������е���Ŀ���ܱ���Ϊϵͳ����\
Ŀ¼����Ӱ��ȡ���ڹ���������һ��������Ӱ���Ǻ�������ЩĿ¼���ҵ���ͷ�ı��������档�Ѱ�װĿ���\
:prop_tgt:`SYSTEM`\ ���Ծ�����������Ϊ���й�����޸�Ŀ����Ѱ�װֵ�������\
:prop_tgt:`EXPORT_NO_SYSTEM`\ ���ԣ���������ͨ����\ *ʹ����*\ ������\
:prop_tgt:`NO_SYSTEM_FROM_IMPORTED`\ Ŀ������������ʹ������ν�����ʹ�õĵ���Ŀ���ϵͳ\
��Ϊ��

���һ��������Ŀ�걻���ݵ����ӵ�һ��macOS :prop_tgt:`FRAMEWORK`����ܵ�\ ``Headers``\
Ŀ¼Ҳ����Ϊʹ���������뽫���Ŀ¼��Ϊ����Ŀ¼���ݵ�Ч����ͬ��

���ӿ�����������ʽ
----------------------------------------

�빹���淶һ��������ʹ�����������ʽ����ָ��\ :prop_tgt:`���ӿ� <LINK_LIBRARIES>`��\
Ȼ��������ʹ������������ǻ�������������ļ��ϣ������һ����������ƣ�����������������γ�һ��\
�������޻�ͼ����Ҳ����˵��������ӵ�Ŀ��������Ŀ�����Ե�ֵ����ôĿ�����Կ��ܲ����������ӵ������

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  add_library(lib2 lib2.cpp)
  target_link_libraries(lib1 PUBLIC
    $<$<TARGET_PROPERTY:POSITION_INDEPENDENT_CODE>:lib2>
  )
  add_library(lib3 lib3.cpp)
  set_property(TARGET lib3 PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 lib1 lib3)

����\ ``exe1``\ Ŀ���\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\ ���Ե�ֵ���������ӵĿ�\
��\ ``lib3``\ ����������\ ``exe1``\ �ı�Ե��ͬһ��\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\
���Ծ����������������ͼ����һ��ѭ����:manual:`cmake(1)`\ ����������Ϣ��

.. _`Output Artifacts`:

�������
----------------

:command:`add_library`\ ��\ :command:`add_executable`\ ������Ĺ���ϵͳĿ�괴����\
��������������������������ļ���׼ȷ���λ��ֻ��������ʱȷ������Ϊ�������ڹ������ú���������\
���������Եȡ�\ ``TARGET_FILE``��\ ``TARGET_LINKER_FILE``\ ����صı��ʽ������������\
���ɵĶ������ļ������ƺ�λ�á�Ȼ������Щ���ʽ��������\ ``OBJECT``\ �⣬��Ϊ��Щ��û������\
����ʽ��صĵ����ļ���

Ŀ����Թ�����������������������ݽ�������Ĳ�������ϸ���ܡ����ǵķ�����DLLƽ̨�ͷ�DLLƽ̨֮\
���ǲ�ͬ�ġ�����Cygwin���ڵ����л���windows��ϵͳ����DLLƽ̨��

.. _`Runtime Output Artifacts`:

����ʱ�������
^^^^^^^^^^^^^^^^^^^^^^^^

����ϵͳĿ���\ *����ʱ*\ ������������ǣ�

* :command:`add_executable`\ ������Ŀ�ִ��Ŀ��Ŀ�ִ���ļ�������\ ``.exe``����

* ��DLLƽ̨�ϣ���\ :command:`add_library`\ �����\ ``SHARED``\ ѡ����Ĺ����Ŀ���\
  ��ִ���ļ�������\ ``.dll``����

:prop_tgt:`RUNTIME_OUTPUT_DIRECTORY`\ ��\ :prop_tgt:`RUNTIME_OUTPUT_NAME`\
Ŀ�����Կ������ڿ��ƹ������е�����ʱ�������λ�ú����ơ�

.. _`Library Output Artifacts`:

���������
^^^^^^^^^^^^^^^^^^^^^^^^

����ϵͳĿ���\ *��*\ ������������ǣ�

* ��\ :command:`add_library`\ ����ʹ��\ ``MODULE``\ ѡ�����ģ���Ŀ��Ŀɼ���ģ���ļ�\
  ������\ ``.dll``\ ��\ ``.so``����

* �ڷ�DLLƽ̨�ϣ���\ :command:`add_library`\ �����\ ``SHARED``\ ѡ����Ĺ����Ŀ��\
  �Ĺ�����ļ�������\ ``.so``\ ��\ ``.dylib``����

:prop_tgt:`LIBRARY_OUTPUT_DIRECTORY`\ ��\ :prop_tgt:`LIBRARY_OUTPUT_NAME`\
Ŀ�����Կ����������ƹ������еĿ��������λ�ú����ơ�

.. _`Archive Output Artifacts`:

�����������
^^^^^^^^^^^^^^^^^^^^^^^^

����ϵͳĿ���\ *�鵵*\ ������������ǣ�

* ��\ :command:`add_library`\ ����ʹ��\ ``STATIC``\ ѡ����ľ�̬��Ŀ��ľ�̬���ļ�\
  ������\ ``.lib``\ ��\ ``.a``����

* ��DLLƽ̨�ϣ���\ :command:`add_library`\ �����\ ``SHARED``\ ѡ����Ĺ����Ŀ���\
  ������ļ�������\ ``.lib``����ֻ�е��⵼������һ�����йܷ���ʱ���ű�֤���ļ����ڡ�

* ��DLLƽ̨�ϣ��������˿�ִ��Ŀ���\ :prop_tgt:`ENABLE_EXPORTS`\ Ŀ������ʱ��\
  ��\ :command:`add_executable`\ ������Ŀ�ִ��Ŀ��ĵ�����ļ�������\ ``.lib``����

* ��AIX�ϣ��������˿�ִ��Ŀ���\ :prop_tgt:`ENABLE_EXPORTS`\ Ŀ������ʱ��\
  :command:`add_executable`\ ������Ŀ�ִ��Ŀ��������������ļ�������\ ``.imp``����

* ��macOS�ϣ������Ŀ��������������ļ�������\ ``.tbd``����\ :command:`add_library`\
  �����������\ ``SHARED``\ ѡ�������\ :prop_tgt:`ENABLE_EXPORTS`\ Ŀ�����Ա���\
  ��ʱ��

:prop_tgt:`ARCHIVE_OUTPUT_DIRECTORY`\ ��\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\
Ŀ�����Կ������ڿ��ƹ������еĹ鵵�������λ�ú����ơ�

Ŀ¼����������
-------------------------

:command:`target_include_directories`��:command:`target_compile_definitions`\ ��\
:command:`target_compile_options`\ ����һ��ֻ�ܶ�һ��Ŀ�����Ӱ�졣\
:command:`add_compile_definitions`��:command:`add_compile_options`\ ��\
:command:`include_directories`\ ����������ƵĹ��ܣ���Ϊ�˷��������������Ŀ¼��Χ������\
Ŀ�귶Χ�ڲ�����

.. _`Build Configurations`:

��������
====================

����Ϊ�ض����͵Ĺ���ȷ���淶������\ ``Release``\ ��\ ``Debug``��\
ָ������ȡ������ʹ�õ�\ :manual:`generator <cmake-generators(7)>`\ �����͡�\
���ڵ�����������������\ :ref:`Makefile Generators`\ ��\ :generator:`Ninja`��\
������������ʱ��\ :variable:`CMAKE_BUILD_TYPE`\ ����ָ���ġ�\
������\ :ref:`Visual Studio <Visual Studio Generators>`��:generator:`Xcode`\ ��\
:generator:`Ninja Multi-Config`\ �����Ķ����������������������û��ڹ���ʱѡ��ģ�\
:variable:`CMAKE_BUILD_TYPE`\ �ᱻ���ԡ��ڶ���������£�\
*����*\ ���ü�������ʱ��\ :variable:`CMAKE_CONFIGURATION_TYPES`\ ����ָ����\
��ʹ�õ�ʵ������ֱ�������׶β���֪�������ֲ��쾭������⣬���³�������������룺

.. code-block:: cmake

  # WARNING: This is wrong for multi-config generators because they don't use
  #          and typically don't even set CMAKE_BUILD_TYPE
  string(TOLOWER ${CMAKE_BUILD_TYPE} build_type)
  if (build_type STREQUAL debug)
    target_compile_definitions(exe1 PRIVATE DEBUG_BUILD)
  endif()

:manual:`���������ʽ <cmake-generator-expressions(7)>`\ Ӧ��������ȷ�����ض������õ��߼���\
������ʹ�õ���������ʲô�����磺

.. code-block:: cmake

  # Works correctly for both single and multi-config generators
  target_compile_definitions(exe1 PRIVATE
    $<$<CONFIG:Debug>:DEBUG_BUILD>
  )

��\ :prop_tgt:`IMPORTED`\ Ŀ����ڵ�����£�\
:prop_tgt:`MAP_IMPORTED_CONFIG_DEBUG <MAP_IMPORTED_CONFIG_<CONFIG>>`\ ������Ҳ��\
�����\ :genex:`$<CONFIG:Debug>`\ ���ʽ����


���ִ�Сд
----------------

:variable:`CMAKE_BUILD_TYPE`\ ��\ :variable:`CMAKE_CONFIGURATION_TYPES`\ ��������\
����һ���������ǵ�ֵ���е��κ��ַ����Ƚ϶������ִ�Сд�ġ�:genex:`$<CONFIG>`\ ���������ʽ\
���������û���CMakeĬ�����õ����ô�Сд�����磺

.. code-block:: cmake

  # NOTE: Don't use these patterns, they are for illustration purposes only.

  set(CMAKE_BUILD_TYPE Debug)
  if(CMAKE_BUILD_TYPE STREQUAL DEBUG)
    # ... will never get here, "Debug" != "DEBUG"
  endif()
  add_custom_target(print_config ALL
    # Prints "Config is Debug" in this single-config case
    COMMAND ${CMAKE_COMMAND} -E echo "Config is $<CONFIG>"
    VERBATIM
  )

  set(CMAKE_CONFIGURATION_TYPES Debug Release)
  if(DEBUG IN_LIST CMAKE_CONFIGURATION_TYPES)
    # ... will never get here, "Debug" != "DEBUG"
  endif()

���֮�£�CMake���ڲ����������޸���Ϊ�ĵط�ʹ����������ʱ�����ִ�Сд�����磬\
:genex:`$<CONFIG:Debug>`\ ���������ʽ���ڲ�����\ ``Debug``��������\ ``DEBUG``��\
``debug``\ ����\ ``DeBuG``\ �����ö�������Ϊ1����ˣ���������\
:variable:`CMAKE_BUILD_TYPE`\ ��\ :variable:`CMAKE_CONFIGURATION_TYPES`\ ��ָ����\
���Сд��ϵ��������ͣ��������ϸ��Լ�����������һ�ڣ��������������ַ����Ƚ��в���ֵ��\
��ô���Ƚ�ֵת��Ϊ��д��Сд��Ȼ������Ӧ�ص������ԡ�

Ĭ�Ϻ��Զ�������
---------------------------------

Ĭ������£�CMake����������׼���ã�

* ``Debug``
* ``Release``
* ``RelWithDebInfo``
* ``MinSizeRel``

�ڶ������������У�Ĭ�������\ :variable:`CMAKE_CONFIGURATION_TYPES`\ ������ʹ�������б�\
�����������е�һ���Ӽ�����䣬���Ǳ���Ŀ���û����ǡ�ʹ�õ�ʵ���������û��ڹ���ʱѡ��

���ڵ�����������������������ʱʹ��\ :variable:`CMAKE_BUILD_TYPE`\ ����ָ���������ڹ���ʱ\
���ġ�Ĭ��ֵͨ������������׼���ã�����һ�����ַ�����һ������������ǣ�����\ ``Debug``\ ��ͬ��\
����ʵ������ˡ��û�Ӧ��ʼ����ʽ��ָ���������ͣ��Ա���˳������⡣

������׼���������ڴ����ƽ̨���ṩ�˺������Ϊ�������ǿ��Ա���չΪ�ṩ�������͡�ÿ�����ö�Ϊ\
��ʹ�õ����Զ�����һ�����������������־��������Щ������ѭ����\
:variable:`CMAKE_<LANG>_FLAGS_<CONFIG>`������\ ``<CONFIG>``\ ���Ǵ�д���������ơ�\
�ڶ����Զ�����������ʱ��ȷ���ʵ�����������Щ������ͨ���ǻ��������


αĿ��
==============

��ЩĿ�����Ͳ���ʾ����ϵͳ���������ֻ��ʾ���룬���ⲿ����������������ǹ������������ɵĹ�\
��ϵͳ�в���ʾαĿ�ꡣ

.. _`Imported Targets`:

�����Ŀ��
----------------

:prop_tgt:`IMPORTED`\ Ŀ���ʾԤ�ȴ��ڵ������ͨ�������������ΰ������Ŀ�꣬Ӧ�ñ���Ϊ\
���ɱ�ġ���������һ��\ :prop_tgt:`IMPORTED`\ Ŀ��֮�����ǿ�����ʹ����������Ŀ��һ����\
ʹ��ϰ������\ :command:`target_compile_definitions`��\
:command:`target_include_directories`��\ :command:`target_compile_options`\ ��\
:command:`target_link_libraries`\ ������\
����Ŀ�����ԡ�

:prop_tgt:`IMPORTED`\ ��Ŀ��������������Ŀ����ͬ��ʹ���������ԣ�����\
:prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`��\
:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`��\
:prop_tgt:`INTERFACE_COMPILE_OPTIONS`��\
:prop_tgt:`INTERFACE_LINK_LIBRARIES`\ ��\
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`��

:prop_tgt:`LOCATION`\ Ҳ���Դ�IMPORTEDĿ���ȡ�����������������ɺ��١�\
:command:`add_custom_command`\ ���������͸����ʹ��\
:prop_tgt:`IMPORTED` :prop_tgt:`EXECUTABLE <TYPE>`\ Ŀ����Ϊ\ ``COMMAND``\ ��ִ��\
�ļ���

:prop_tgt:`IMPORTED`\ Ŀ�궨��ķ�Χ�Ƕ�������Ŀ¼�����Դ���Ŀ¼���ʺ�ʹ�����������ܴӸ�\
Ŀ¼��ͬ��Ŀ¼���ʡ�������������cmake������������

�����Զ���һ���ڹ���ϵͳ��ȫ�ַ��ʵ�\ ``GLOBAL`` :prop_tgt:`IMPORTED`\ Ŀ�ꡣ

�����\ :manual:`cmake-packages(7)`\ �ֲ��˽�������ʹ��\ :prop_tgt:`IMPORTED`\ Ŀ\
�괴��������Ϣ��

.. _`Alias Targets`:

����Ŀ��
-------------

``ALIAS``\ Ŀ������ֻ���������п����������Ŀ�����ƻ���ʹ�õ����ơ�\
``ALIAS``\ Ŀ���һ����Ҫ�����ǰ���һ����ĵ�Ԫ���Կ�ִ���ļ�������������ͬ����ϵͳ��һ���֣�\
Ҳ�����ǻ����û����õ��������ġ�

.. code-block:: cmake

  add_library(lib1 lib1.cpp)
  install(TARGETS lib1 EXPORT lib1Export ${dest_args})
  install(EXPORT lib1Export NAMESPACE Upstream:: ${other_args})

  add_library(Upstream::lib1 ALIAS lib1)

����һ��Ŀ¼�У����ǿ��������������ӵ�\ ``Upstream::lib1``\ Ŀ�꣬�����������԰���\
:prop_tgt:`IMPORTED`\ Ŀ�꣬��������Ϊ��ͬ����ϵͳ��һ���ֹ�����\ ``ALIAS``\ Ŀ�ꡣ

.. code-block:: cmake

  if (NOT TARGET Upstream::lib1)
    find_package(lib1 REQUIRED)
  endif()
  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 Upstream::lib1)

``ALIAS``\ Ŀ���ǲ��ɱ�ġ����ɰ�װ�Ļ򲻿ɵ����ġ�������ȫ�����ڹ���ϵͳ������һ�����ƿ���\
ͨ����ȡ����\ :prop_tgt:`ALIASED_TARGET`\ �������������Ƿ���һ��\ ``ALIAS``\ ���ƣ�

.. code-block:: cmake

  get_target_property(_aliased Upstream::lib1 ALIASED_TARGET)
  if(_aliased)
    message(STATUS "The name Upstream::lib1 is an ALIAS for ${_aliased}.")
  endif()

.. _`Interface Libraries`:

�ӿڿ�
-------------------

``INTERFACE``\ ��Ŀ�겻�����Դ���룬Ҳ�����ڴ��������ɿ⹤���������û��\ :prop_tgt:`LOCATION`��

������ָ��ʹ��Ҫ����\ :prop_tgt:`INTERFACE_INCLUDE_DIRECTORIES`��\
:prop_tgt:`INTERFACE_COMPILE_DEFINITIONS`��:prop_tgt:`INTERFACE_COMPILE_OPTIONS`��\
:prop_tgt:`INTERFACE_LINK_LIBRARIES`��:prop_tgt:`INTERFACE_SOURCES`\ ��\
:prop_tgt:`INTERFACE_POSITION_INDEPENDENT_CODE`��ֻ��\
:command:`target_include_directories`��:command:`target_compile_definitions`��\
:command:`target_compile_options`��:command:`target_sources`\ ��\
:command:`target_link_libraries`\ �����\ ``INTERFACE``\ ģʽ������\ ``INTERFACE``\
��һ��ʹ�á�

��CMake 3.19��һ��\ ``INTERFACE``\ ��Ŀ�������ѡ��ذ���Դ�ļ�������Դ�ļ��Ľӿڿ⽫\
��Ϊ����Ŀ����������ɵĹ���ϵͳ�С���������Դ���룬�����ܰ���������������Դ������Զ������\
���⣬IDE����Դ�ļ���ΪĿ���һ������ʾ���Ա���н���ʽ��ȡ�ͱ༭��

``INTERFACE``\ ���һ����Ҫ�����ǽ���ͷ�ļ���header-only���Ŀ⡣CMake 3.23��\
����ͨ��ʹ��\ :command:`target_sources`\ ���ͷ�ļ���ӵ�ͷ�ļ�������ͷ�ļ��Ϳ������

.. code-block:: cmake

  add_library(Eigen INTERFACE)

  target_sources(Eigen PUBLIC
    FILE_SET HEADERS
      BASE_DIRS src
      FILES src/eigen.h src/vector.h src/matrix.h
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 Eigen)

������������ָ��\ ``FILE_SET``\ ʱ�����Ƕ����\ ``BASE_DIRS``\ �Զ���Ϊ\ ``Eigen``\
Ŀ��ʹ��Ҫ���еİ���Ŀ¼�����Դ�Ŀ���ʹ�������ڱ���ʱ�����ĺ�ʹ�ã�����������û��Ӱ�졣

��һ�������Ƕ�ʹ�����������ȫ��Ŀ��Ϊ���ĵ���ƣ�

.. code-block:: cmake

  add_library(pic_on INTERFACE)
  set_property(TARGET pic_on PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE ON)
  add_library(pic_off INTERFACE)
  set_property(TARGET pic_off PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE OFF)

  add_library(enable_rtti INTERFACE)
  target_compile_options(enable_rtti INTERFACE
    $<$<OR:$<COMPILER_ID:GNU>,$<COMPILER_ID:Clang>>:-rtti>
  )

  add_executable(exe1 exe1.cpp)
  target_link_libraries(exe1 pic_on enable_rtti)

������``exe1``\ �Ĺ����淶����ȫ��ʾΪ���ӵ�Ŀ�꣬���������ض���־�ĸ����Ա���װ��\
``INTERFACE``\ ��Ŀ���С�

���԰�װ�͵���\ ``INTERFACE``\ �⡣���ǿ�������Ŀ�갲װĬ�ϵ�ͷ�ļ�����

.. code-block:: cmake

  add_library(Eigen INTERFACE)

  target_sources(Eigen INTERFACE
    FILE_SET HEADERS
      BASE_DIRS src
      FILES src/eigen.h src/vector.h src/matrix.h
  )

  install(TARGETS Eigen EXPORT eigenExport
    FILE_SET HEADERS DESTINATION include/Eigen)
  install(EXPORT eigenExport NAMESPACE Upstream::
    DESTINATION lib/cmake/Eigen
  )

�����������ͷ�ļ����е�ͷ�ļ�����װ��\ ``include/Eigen``����װĿ���Զ���Ϊ�û�ʹ��Ҫ��\
�İ���Ŀ¼��
