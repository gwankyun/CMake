add_library
-----------

.. only:: html

   .. contents::

ʹ���ض���Դ�ļ�����Ŀ��ӿ⡣

������
^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> [<type>] [EXCLUDE_FROM_ALL] <sources>...)
  :target: normal

  ���һ����Ϊ\ ``<name>``\ �Ŀ�Ŀ�꣬��������������г���Դ�ļ�������

  ��ѡ��\ ``<type>``\ ָ��Ҫ�����Ŀ�����ͣ�

  ``STATIC``
    Ŀ���ļ��Ĵ浵��������������Ŀ��ʱʹ�á�

  ``SHARED``
    ���Ա�����Ŀ�����Ӳ�������ʱ���صĶ�̬�⡣

  ``MODULE``
    һ������������ܲ��ᱻ����Ŀ�����ӣ�������������ʱʹ��������dlopen�Ĺ��ܶ�̬���ء�

  ���û�и���\ ``<type>``�������\ :variable:`BUILD_SHARED_LIBS`\ ������ֵĬ��Ϊ\
  ``STATIC``\ ��\ ``SHARED``��

  ѡ���У�

  ``EXCLUDE_FROM_ALL``
    �Զ�����\ :prop_tgt:`EXCLUDE_FROM_ALL`\ Ŀ�����ԡ��й���ϸ��Ϣ������ĸ�Ŀ�����Ե��ĵ���

``<name>``\ ��Ӧ���߼�Ŀ�����ƣ���������Ŀ�б�����ȫ��Ψһ�ġ������Ŀ��ʵ���ļ����ǻ��ڱ�\
��ƽ̨��Լ��������\ ``lib<name>.a``\ ��\ ``<name>.lib``\ �������ġ�

.. versionadded:: 3.1
  ``add_library``\ ��Դ��������ʹ���﷨Ϊ\ ``$<...>``\ �ġ����������ʽ�����йؿ��õı��ʽ��\
  �����\ :manual:`���������ʽ <cmake-generator-expressions(7)>`\ �ֲᡣ

.. versionadded:: 3.11
  ����Ժ�ʹ��\ :command:`target_sources`\ ���Դ�ļ��������ʡ�����ǡ�

����\ ``SHARED``\ ��\ ``MODULE``\ �⣬\ :prop_tgt:`POSITION_INDEPENDENT_CODE`\
Ŀ�����Ա��Զ�����Ϊ\ ``ON``��\ ``SHARED``\ ����Ա����Ϊ\ :prop_tgt:`FRAMEWORK`\
Ŀ������������macOS��ܡ�

.. versionadded:: 3.8
  ������\ :prop_tgt:`FRAMEWORK`\ Ŀ�����Ա��\ ``STATIC``\ ���Դ�����̬��ܡ�

����ⲻ�����κη��ţ��򲻵ý�������Ϊ\ ``SHARED``\ �⡣���磬Windows��ԴDLL�򲻵�������\
�ܷ��ŵ��й�C++/CLI DLL��Ҫ��\ ``MODULE``\ �⡣������ΪCMakeϣ��\ ``SHARED``\ ����\
Windows��������һ�������ĵ���⡣

Ĭ������£����ļ����ڵ��������Դ��Ŀ¼��Ӧ�Ĺ�����Ŀ¼�д�����Ҫ���Ĵ�λ�ã������\
:prop_tgt:`ARCHIVE_OUTPUT_DIRECTORY`��\ :prop_tgt:`LIBRARY_OUTPUT_DIRECTORY`\ ��\
:prop_tgt:`RUNTIME_OUTPUT_DIRECTORY`\ Ŀ�����Ե��ĵ��������\ :prop_tgt:`OUTPUT_NAME`\
Ŀ�����Ե��ĵ��Ը��������ļ�����\ ``<name>``\ ���֡�

�йض���buildsystem���Եĸ�����Ϣ�������\ :manual:`cmake-buildsystem(7)`\ �ֲᡣ

���ĳЩԴ������Ԥ������ģ�����ϣ����IDE�п��Է��ʵ�ԭʼԴ���룬��μ�\
:prop_sf:`HEADER_FILE_ONLY` ��

.. versionchanged:: 3.30

  On platforms that do not support shared libraries, ``add_library``
  now fails on calls creating ``SHARED`` libraries instead of
  automatically converting them to ``STATIC`` libraries as before.
  See policy :policy:`CMP0164`.

�����
^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> OBJECT <sources>...)
  :target: OBJECT

  ���\ :ref:`����� <Object Libraries>`\ �Ա���Դ�ļ��������轫������ļ��鵵�����ӵ����С�

``add_library``\ ��\ :command:`add_executable`\ ����������Ŀ�����ʹ�ñ��ʽ���ö���\
��ʽΪ\ :genex:`$\<TARGET_OBJECTS:objlib\> <TARGET_OBJECTS>`\ ��ΪԴ������\
``objlib``\ �Ƕ��������ơ����磺

.. code-block:: cmake

  add_library(... $<TARGET_OBJECTS:objlib> ...)
  add_executable(... $<TARGET_OBJECTS:objlib> ...)

������һ�����е�objlib��Ŀ���ļ���һ����ִ���ļ����Լ���Щ�������Լ���Դ����Ŀ�ִ���ļ���\
��������ֻ��������Դ��ͷ�ļ��������ļ�����Щ�ļ�����Ӱ����ͨ������ӣ�����\ ``.txt``����\
���ǿ��ܰ������ɴ���Դ���Զ��������������\ ``PRE_BUILD``��\ ``PRE_LINK``\ ��\
``POST_BUILD``\ ���һЩԭ���Ĺ���ϵͳ������Xcode�����ܲ�ϲ��ֻ��Ŀ���ļ���Ŀ�꣬����\
�������κ�����\ :genex:`$\<TARGET_OBJECTS:objlib\> <TARGET_OBJECTS>`\ ��Ŀ�������\
��һ��������Դ�ļ���

.. versionadded:: 3.12
  Ŀ������ͨ��\ :command:`target_link_libraries`\ ���ӡ�

�ӿڿ�
^^^^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> INTERFACE)
  :target: INTERFACE

  ���һ��\ :ref:`�ӿڿ� <Interface Libraries>`\ Ŀ�꣬������ָ���������ʹ�����󣬵�\
  ������Դ���룬Ҳ�����ڴ��������ɿ⹤����

  û��Դ�ļ��Ľӿڿⲻ����ΪĿ����������ɵĹ���ϵͳ�С����ǣ������Ա��������ԣ����ҿ��Ա�\
  ��װ�͵�����ͨ����ʹ���������\ ``INTERFACE_*``\ ������䵽�ӿ�Ŀ�꣺

  * :command:`set_property`,
  * :command:`target_link_libraries(INTERFACE)`,
  * :command:`target_link_options(INTERFACE)`,
  * :command:`target_include_directories(INTERFACE)`,
  * :command:`target_compile_options(INTERFACE)`,
  * :command:`target_compile_definitions(INTERFACE)`, and
  * :command:`target_sources(INTERFACE)`,

  Ȼ��������Ŀ��һ������������\ :command:`target_link_libraries`\ �Ĳ�����

  .. versionadded:: 3.15
    �ӿڿ������\ :prop_tgt:`PUBLIC_HEADER`\ ��\ :prop_tgt:`PRIVATE_HEADER`\ ���ԡ�\
    ����Щ����ָ���ı�ͷ����ʹ��\ :command:`install(TARGETS)`\ ���װ��

.. signature::
  add_library(<name> INTERFACE [EXCLUDE_FROM_ALL] <sources>...)
  :target: INTERFACE-with-sources

  .. versionadded:: 3.19

  ��Ӵ���Դ�ļ���\ :ref:`�ӿڿ� <Interface Libraries>`\ Ŀ�꣨����\
  :command:`����ǩ�� <add_library(INTERFACE)>`\ ����¼��ʹ�����������֮�⣩��Դ�ļ�\
  ����ֱ����\ ``add_library``\ �������г��������Ժ�ͨ��ʹ��\ ``PRIVATE``\ ��\
  ``PUBLIC``\ �ؼ��ֵ���\ :command:`target_sources`\ ��ӡ�

  ����ӿڿ���Դ�ļ�����������\ :prop_tgt:`SOURCES`\ Ŀ�����ԣ�����ͷ������������\
  :prop_tgt:`HEADER_SETS`\ Ŀ�����ԣ���������Ϊ����Ŀ����������ɵĹ���ϵͳ�У��ǳ���\
  :command:`add_custom_target`\ ������Ŀ�ꡣ���������κ�Դ���룬��������\
  :command:`add_custom_command`\ ��������Զ�������Ĺ�������

  ѡ���У�

  ``EXCLUDE_FROM_ALL``
    �Զ�����Ŀ������\ :prop_tgt:`EXCLUDE_FROM_ALL`�����������Ŀ�����Ե��ĵ���

  .. note::
    �ڴ��������\ ``INTERFACE``\ �ؼ��ֵ�����ǩ���У�����֮���г�����Ŀֻ��ΪĿ��ʹ������\
    ��һ���֣�������Ŀ���Լ����õ�һ���֡���������\ ``add_library``\ ��ǩ���У�\
    ``INTERFACE``\ �ؼ���ֻ��ʾ������͡���\ ``add_library``\ �����У����������г���Դ\
    �ǽӿڿ�\ ``PRIVATE``\ �ģ��������������\ :prop_tgt:`INTERFACE_SOURCES`\ Ŀ�������С�

.. _`add_library imported libraries`:

�����
^^^^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> <type> IMPORTED [GLOBAL])
  :target: IMPORTED

  ���һ����Ϊ\ ``<name>``\ ��\ :ref:`IMPORTED��Ŀ¼<Imported Targets>` ��Ŀ������\
  ����������Ŀ�й������κ�Ŀ��һ�������ã�����Ĭ���������ֻ�ڴ�������Ŀ¼�пɼ�֮�⡣

  ``<type>``\ �����ǣ�

  ``STATIC``, ``SHARED``, ``MODULE``, ``UNKNOWN``
    ����λ����Ŀ�ⲿ�Ŀ��ļ���\ :prop_tgt:`IMPORTED_LOCATION`\ Ŀ�����ԣ������Ӧ������\
    ����\ :prop_tgt:`IMPORTED_LOCATION_<CONFIG>`\ ��ָ���������ļ��ڴ����ϵ�λ�ã�

    * ���ڴ������Windowsƽ̨�ϵ�\ ``SHARED``\ �⣬�����ļ����������Ͷ�̬��������ʹ�õ�\
      ``.so``\ ��\ ``.dylib``\ �ļ���������õĿ��ļ���һ��\ ``SONAME``\��������macOS\
      �ϣ���\ ``@rpath/``\ ����һ��\ ``LC_ID_DYLIB``\ �������ֶε�ֵӦ��������\
      :prop_tgt:`IMPORTED_SONAME`\ Ŀ�������С�������õĿ��ļ�û��\ ``SONAME``����ƽ\
      ̨֧��������ôӦ������\ :prop_tgt:`IMPORTED_NO_SONAME`\ Ŀ�����ԡ�

    * ����Windows�ϵ�\ ``SHARED``\ �⣬\ :prop_tgt:`IMPORTED_IMPLIB`\ Ŀ�����ԣ�\
      ����ÿ�����õı���\ :prop_tgt:`IMPORTED_IMPLIB_<CONFIG>`\ ��ָ����DLL������ļ�\
      ��\ ``.lib``\ ��\ ``.dll.a``\ ���ڴ����ϵ�λ�ã�\ ``IMPORTED_LOCATION``\ ��\
      ``.dll``\ ���п��λ�ã������ǿ�ѡ�ģ���\ :genex:`TARGET_RUNTIME_DLLS`\ ������\
      ���ʽ��Ҫ����

    ����ʹ��Ҫ�������\ ``INTERFACE_*``\ ������ָ����

    ``UNKNOWN``\ ������ͨ��ֻ��\ :ref:`Find Modules`\ ��ʵ����ʹ�á�������ʹ�õ�����\
    ·����ͨ��ʹ��\ :command:`find_library`\ �����ҵ�����������֪������ʲô���͵Ŀ⡣\
    ����Windows���ر����ã���Ϊ��̬���DLL�ĵ���ⶼ������ͬ���ļ���չ����

  ``OBJECT``
    ����һ��λ����Ŀ�ⲿ��Ŀ���ļ���\ :prop_tgt:`IMPORTED_OBJECTS`\ Ŀ�����ԣ�������ÿ\
    �����ñ���\ :prop_tgt:`IMPORTED_OBJECTS_<CONFIG>`\ ��ָ���˶����ļ��ڴ����ϵ�λ�á�\
    ����ʹ��Ҫ�������\ ``INTERFACE_*``\ ������ָ����

  ``INTERFACE``
    �����ô����ϵ��κο��Ŀ���ļ�����������\ ``INTERFACE_*``\ ������ָ��ʹ��Ҫ��

  ѡ���У�

  ``GLOBAL``
    ʹĿ������ȫ�ֿɼ���

���������κι��������������Ŀ�꣬����\ :prop_tgt:`IMPORTED`\ ��Ŀ������Ϊ ``True``��\
����Ŀ���ڴ�\ :command:`target_link_libraries`\ �������з�������÷ǳ����á�

ͨ������������\ ``IMPORTED_``\ ��\ ``INTERFACE_``\ ��ͷ��������ָ����������ϸ��Ϣ��\
�йظ�����Ϣ������Ĵ������Ե��ĵ���

������
^^^^^^^^^^^^^^^

.. signature::
  add_library(<name> ALIAS <target>)
  :target: ALIAS

  ����һ��\ :ref:`����Ŀ�� <Alias Targets>`������\ ``<name>``\ �Ϳ��������ں���������\
  ����\ ``<target>``��\ ``<name>``\ ������ΪmakeĿ����������ɵĹ���ϵͳ�С�\
  ``<target>``\ ������\ ``ALIAS``��

.. versionadded:: 3.11
  ``ALIAS``\ �������\ ``GLOBAL``\ :ref:`����Ŀ�� <Imported Targets>`

.. versionadded:: 3.18
  ``ALIAS``\ ������Է�\ ``GLOBAL``\ �����Ŀ�ꡣ�����ı������������Ǵ�������Ŀ¼������\
  Ŀ¼��\ :prop_tgt:`ALIAS_GLOBAL`\ Ŀ�����Կ����ڼ������Ƿ���ȫ�ֵġ�

``ALIAS``\ Ŀ��������������ӵ�Ŀ�꣬Ҳ�����������ж�ȡ���Ե�Ŀ�ꡣ������ʹ�ó���\
:command:`if(TARGET)`\ ��������������Ƿ���ڡ�\ ``<name>``\ ���������޸�\ ``<target>``\
�����ԣ���������Ϊ\ :command:`set_property`��\ :command:`set_target_properties`��\
:command:`target_link_libraries`\ �ȵĲ�������\ ``ALIAS``\ Ŀ�겻�ܰ�װ�򵼳���

�������
^^^^^^^^

* :command:`add_executable`
