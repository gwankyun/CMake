.. cmake-manual-description: CMake Developer Reference

cmake-developer(7)
******************

.. only:: html

   .. contents::

����
============

���ֲ�ּ�ڹ�ʹ��\ :manual:`cmake-language(7)`\ ����Ŀ�����Ա�ο��������Ǳ�д�Լ���ģ�飬\
�Լ��Ĺ���ϵͳ������CMake����

��μ�\ https://cmake.org/get-involved/\ ����CMake���εĿ�����������������˵�������ӣ�\
������˵�������ӵ�CMake����Ŀ���ָ�ϡ�

����Windowsע���
==========================

CMake�ṩ��һЩ����������\ ``Windows``\ ƽ̨�ϵ�ע���

��ѯWindowsע���
----------------------

.. versionadded:: 3.24

:command:`cmake_host_system_information`\ �����ṩ���ڱ��ؼ�����ϲ�ѯע���Ŀ����ԡ�\
�鿴\ :ref:`cmake_host_system(QUERY_WINDOWS_REGISTRY) <Query Windows registry>`\
��ȡ������Ϣ��

.. _`Find Using Windows Registry`:

ʹ��Windowsע������
---------------------------

.. versionchanged:: 3.24

:command:`find_file`��:command:`find_library`��:command:`find_path`��\
:command:`find_program`\ ��\ :command:`find_package`\ �����\ ``HINTS``\ ��\
``PATHS``\ ѡ���ṩ����\ ``Windows``\ ƽ̨�ϲ�ѯע���Ŀ����ԡ�

ע����ѯ����ʽ�﷨��ʹ�ô��г�����չ��\
`BNF <https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form>`_\ ��ʾ��ָ��������\
��ʾ��

.. raw:: latex

   \begin{small}

.. productionlist::
  registry_query: '[' `sep_definition`? `root_key`
                :     ((`key_separator` `sub_key`)? (`value_separator` `value_name`_)?)? ']'
  sep_definition: '{' `value_separator` '}'
  root_key: 'HKLM' | 'HKEY_LOCAL_MACHINE' | 'HKCU' | 'HKEY_CURRENT_USER' |
          : 'HKCR' | 'HKEY_CLASSES_ROOT' | 'HKCC' | 'HKEY_CURRENT_CONFIG' |
          : 'HKU' | 'HKEY_USERS'
  sub_key: `element` (`key_separator` `element`)*
  key_separator: '/' | '\\'
  value_separator: `element` | ';'
  value_name: `element` | '(default)'
  element: `character`\+
  character: <any character except `key_separator` and `value_separator`>

.. raw:: latex

   \end{small}

:token:`sep_definition`\ ��ѡ���ṩ��ָ�����ڷָ�\ :token:`sub_key`\ ��\
:token:`value_name`\ ����ַ����Ŀ����ԡ����δָ������ʹ��\ ``;``\ �ַ������Խ����\
:token:`registry_query`\ ��ָ��Ϊ·����һ���֡�

.. code-block:: cmake

  # example using default separator
  find_file(... PATHS "/root/[HKLM/Stuff;InstallDir]/lib[HKLM\\\\Stuff;Architecture]")

  # example using different specified separators
  find_library(... HINTS "/root/[{|}HKCU/Stuff|InstallDir]/lib[{@@}HKCU\\\\Stuff@@Architecture]")

���\ :token:`value_name`\ ��δָ��������������\ ``(default)``���򷵻�Ĭ��ֵ������\
������У���:token:`value_name`\ ֧�ֵ������У�

* ``REG_SZ``��
* ``REG_EXPAND_SZ``�����ر���չ�����ݡ�
* ``REG_DWORD``��
* ``REG_QWORD``��

��ע����ѯʧ��ʱ��ͨ������Ϊ�������ڻ�֧���������ͣ����ַ���\ ``/REGISTRY-NOTFOUND``\
�����滻Ϊ\ ``[]``\ ��ѯ���ʽ��

.. _`Find Modules`:

����ģ��
============

������ģ�顱��һ��\ ``Find<PackageName>.cmake``\ �ļ����ڵ���ʱ��\
:command:`find_package`\ ������ء�

����ģ�����Ҫ������ȷ�����Ƿ���ã�����\ ``<PackageName>_FOUND``\ �����Է�ӳ��һ�㣬����\
��ʹ�ð�������κα�������͵���Ŀ�ꡣ�����ο�û���ṩ\
:ref:`�����ļ��� <Config File Packages>`\ ������£�����ģ������á�

��ͳ�ķ����Ƕ����ж�����ʹ�ñ�����������Ϳ�ִ���ļ�������������\ `��׼������`_\ ���֡�\
����CMake�ṩ�Ĵ�������в���ģ�������ġ�

���ִ��ķ�����ͨ���ṩ\ :ref:`����Ŀ�� <Imported targets>`�������ܵ���\
:ref:`�����ļ��� <Config File Packages>`\ �ļ��������С��������Խ�\
:ref:`usage requirements <Target Usage Requirements>`\ �������ߡ�

���κ�һ������£�������ͬʱ�ṩ�����͵���Ŀ��ʱ��������ģ�鶼Ӧ���ṩ�������ͬ���Ƶľɰ�\
�����������ԡ�

FindFoo.cmakeģ��ͨ��ͨ������������أ�\ ::

  find_package(Foo [major[.minor[.patch[.tweak]]]]
               [EXACT] [QUIET] [REQUIRED]
               [[COMPONENTS] [components...]]
               [OPTIONAL_COMPONENTS components...]
               [NO_POLICY_SCOPE])

�йز���ģ����������Щ��������ϸ��Ϣ�������\ :command:`find_package`\ �ĵ������д����\
����ͨ��ʹ��\ :module:`FindPackageHandleStandardArgs`\ ������ġ�

�򵥵�˵��ģ��Ӧ��ֻ��λ������汾���ݵİ��İ汾�����������\ ``Foo_FIND_VERSION``\ ����\
�������������\ ``Foo_FIND_QUIETLY``\ ����Ϊtrue����Ӧ�ñ����ӡ��Ϣ������û���ҵ�������\
�α�Թ�����\ ``Foo_FIND_REQUIRED``\ ������Ϊtrue������Ҳ�������ģ��Ӧ�÷���\
``FATAL_ERROR``��������߶�����Ϊtrue����������Ҳ���������Ӧ�ô�ӡһ����������Ϣ��

�ҵ��������������İ���������Ӧ������\ ``Foo_FIND_COMPONENTS``\ ���г�������������\
��Ϊtrue������ֻ����ÿ���������\ ``<c>``\ δ�ҵ�ʱ�Ž�\ ``Foo_FOUND``\ ����Ϊtrue, \
``Foo_FIND_REQUIRED_<c>``\ δ����Ϊtrue��\ ``find_package_handle_standard_args()``\
��\ ``HANDLE_COMPONENTS``\ ����������ʵ�ִ˹��ܡ�

���û������\ ``Foo_FIND_COMPONENTS``����ô������Щģ�����Ҫ��Щģ��ȡ���ڲ���ģ�飬��Ӧ\
�ñ���������

�����ڲ�ʵ�֣����»��߿�ͷ�ı���������ʱʹ����һ���ձ���ܵ�Լ����


.. _`CMake Developer Standard Variable Names`:

��׼������
-----------------------

���ڲ������ñ���������\ ``FindXxx.cmake``\ ģ�飨�������Ӵ�������Ŀ�꣩��Ӧ��ʹ�����±�\
���������ֲ���ģ��֮���һ���ԡ���ע�⣬���б�������\ ``Xxx_``\ ��ͷ����������˵���������\
����\ ``FindXxx.cmake``\ �ļ���������ȫƥ�䣬������д/Сд���������ϵ�ǰ׺ȷ�����ǲ�����\
��������ģ��ı�����ͻ�����ڲ���ģ�鶨����κκꡢ�����͵���Ŀ�꣬ҲӦ����ѭ��ͬ��ģʽ��

``Xxx_INCLUDE_DIRS``
  ���һ�����Ŀ¼����һ�������У����ͻ��˴���ʹ�á��ⲻӦ����һ��������Ŀ��ע�⣬��Ҳ��ζ��\
  ���������Ӧ������\ :command:`find_path`\ ����Ľ��������������������\
  ``Xxx_INCLUDE_DIR``����

``Xxx_LIBRARIES``
  ��ģ��һ��ʹ�õĿ⡣��Щ������CMakeĿ�꣬��������ļ�����������·����������������������·\
  �����ҵ��Ŀ�����ơ��ⲻӦ����һ��������Ŀ��ע�⣬��Ҳ��ζ�����������Ӧ������\
  :command:`find_library`\ ����Ľ��������������������\ ``Xxx_LIBRARY``����

``Xxx_DEFINITIONS``
  ����ʹ�ø�ģ��Ĵ���ʱҪʹ�õı��붨�塣����Ĳ�Ӧ�ð�����\ ``-DHAS_JPEG``\ ������ѡ�\
  �ͻ���Դ�����ļ�ʹ����Щѡ���������Ƿ�\ ``#include <jpeg.h>``

``Xxx_EXECUTABLE``
  ��ִ���ļ�����������·��������������£�\ ``Xxx``\ ���ܲ���ģ������ƣ��������ǹ��ߵ�����\
  ��ͨ��ת��Ϊȫ��д�������蹤�߾������֪�������ƣ���˲�̫���ܴ��ھ�����ͬ���Ƶ��������ߡ�\
  ��������\ :command:`find_program`\ ����Ľ�������Ǻ��ʵġ�

``Xxx_YYY_EXECUTABLE``
  ������\ ``Xxx_EXECUTABLE``����������\ ``Xxx``\ ����ģ������\ ``YYY``\ �ǹ�������ͬ����\
  ͨ����ȫ��д��������������Ʋ��Ƿǳ���Ϊ��֪�������п������������߳�ͻ������ѡ����ʽ��Ϊ��\
  �����һ���ԣ����ģ���ṩ�˶����ִ���ļ���Ҳ��ϲ��������ʽ��

``Xxx_LIBRARY_DIRS``
  ��ѡ�أ���һ���������г����ͻ��˴���ʹ�õĿ�Ŀ¼�����ռ����ⲻӦ���ǻ����

``Xxx_ROOT_DIR``
  ����������ҵ�ģ��Ļ�Ŀ¼��

``Xxx_VERSION_VV``
  �ñ��ı���ָ�����ṩ��\ ``Xxx``\ ģ���Ƿ�Ϊ��ģ���\ ``VV``\ �汾�����ڸ�����ģ�飬\
  ��Ӧ���ж��������ʽ�ı�������Ϊtrue�����磬һ��ģ��\ ``Barry``\ �����Ѿ���չ�˺ܶ��꣬\
  ���Ҿ�������಻ͬ����Ҫ�汾���汾3��\ ``Barry``\ ģ����ܻὫ����\ ``Barry_VERSION_3``\
  ����Ϊtrue�����ɰ汾��ģ����ܻὫ\ ``Barry_VERSION_2``\ ����Ϊtrue��\
  ``Barry_VERSION_3``\ ��\ ``Barry_VERSION_2``\ ������Ϊtrue���Ǵ���ġ�

``Xxx_WRAP_YY``
  ��������ʽ�ı���������Ϊfalseʱ������ʾ��Ӧ��ʹ����صİ�װ�����װ����ȡ����ģ�飬����\
  ����ģ������ʾ��Ҳ�����ɱ�����\ ``YY``\ ����ָ����

``Xxx_Yy_FOUND``
  ����������ʽ�ı�����\ ``Yy``\ ��ģ������������Ӧ����ȫƥ����ܴ��ݸ�ģ���\
  :command:`find_package`\ �������Ч�����֮һ�������������ʽ�ı�������Ϊfalse�����ʾ\
  û���ҵ�ģ��\ ``Xxx``\ ��\ ``Yy``\ ����򲻿��á��˱��ı���ͨ�����ڿ�ѡ������Ա����\
  �����Լ���ѡ����Ƿ���á�

``Xxx_FOUND``
  ��\ :command:`find_package`\ ����ظ�������ʱ�������Ϊģ���ѱ��ɹ��ҵ�����ñ�����\
  ������Ϊtrue��

``Xxx_NOT_FOUND_MESSAGE``
  �ڽ�\ ``Xxx_FOUND``\ ����ΪFALSE������£�Ӧ����config-files���á���������Ϣ����\
  :command:`find_package`\ �����\ :command:`find_package_handle_standard_args`\
  �����ӡ����֪ͨ�û��й����⡣ʹ�ô˷���������ֱ�ӵ���\ :command:`message`\ �������޷�\
  �ҵ�ģ������ԭ��

``Xxx_RUNTIME_LIBRARY_DIRS``
  ��ѡ�أ�����ʱ������·�������������ӵ������Ŀ�ִ���ļ�ʱʹ�á��û�����Ӧ��ʹ�ø��б�����\
  ��windows�ϵ�\ ``PATH``\ ��UNIX�ϵ�\ ``LD_LIBRARY_PATH``���ⲻӦ���ǻ����

``Xxx_VERSION``
  �ҵ��İ��������汾�ַ���������еĻ���ע�⣬�������ģ���ṩ����\ ``Xxx_VERSION_STRING``��

``Xxx_VERSION_MAJOR``
  �ҵ��İ�����Ҫ�汾������еĻ���

``Xxx_VERSION_MINOR``
  �ҵ��İ��Ĵ�Ҫ�汾������еĻ���

``Xxx_VERSION_PATCH``
  �ҵ��İ��Ĳ����汾������еĻ���

��������ͨ����Ӧ����\ ``CMakeLists.txt``\ �ļ���ʹ�á��������ڲ���ģ��ָ���ͻ����ض��ļ���\
Ŀ¼��λ�á��û�ͨ���ܹ����úͱ༭��Щ���������Ʋ���ģ�����Ϊ�������ֶ�������·����:

``Xxx_LIBRARY``
  ���·��������ģ���ṩ������ʱ��ʹ�ô˱�����������\ :command:`find_library`\ ������\
  �Ľ�������Ǻ��ʵġ�

``Xxx_Yy_LIBRARY``
  ģ��\ ``Xxx``\ �ṩ�Ŀ�\ ``Yy``\ ��·������ģ���ṩ����������ģ��Ҳ�����ṩ��ͬ���Ƶ�\
  ��ʱ��ʹ�ô˱�����������ʽ����\ :command:`find_library`\ �����еĽ������Ҳ�Ǻ��ʵġ�

``Xxx_INCLUDE_DIR``
  ��ģ��ֻ�ṩһ����ʱ���ñ���������ָ���ںδ�����ʹ�øÿ��ͷ�ļ������߸�׼ȷ��˵���Ǹÿ��\
  ������Ӧ����ӵ���ͷ�ļ�����·���е�·��������������\ :command:`find_path`\ �����еĽ�\
  �������Ǻ��ʵġ�

``Xxx_Yy_INCLUDE_DIR``
  ���ģ���ṩ����⣬��������ģ��Ҳ�����ṩͬ���⣬����ʹ�ô˱�ָ���ںδ�����ʹ��ģ����\
  ���Ŀ�\ ``Yy``\ ��ͷ�ļ���ͬ������������\ :command:`find_path`\ �����еĽ�������Ǻ�\
  �ʵġ�

Ϊ�˷�ֹ�û�����Ҫ���õ�����Ū�ò�֪���룬�����ڻ����б��������ܶ��ѡ���������һ��ѡ�\
�����ڽ���ģ���ʹ�ã���λδ�ҵ��Ŀ⣨����\ ``Xxx_ROOT_DIR``��������ͬ����ԭ�򣬽������\
����ѡ����Ϊ�߼�������ͬʱ�ṩ���Ժͷ����������ļ��İ���ͨ��ʹ��\ ``_LIBRARY_<CONFIG>``\
��׺�����������������\ ``Foo_LIBRARY_RELEASE``\ ��\ ``Foo_LIBRARY_DEBUG``��\
:module:`SelectLibraryConfigurations`\ ģ�������������а�����

��Ȼ��Щ���Ǳ�׼�ı�����������Ӧ��Ϊʵ��ʹ�õ��κξ������ṩ�������ԡ�ȷ��������ע��Ϊ����\
�ã������Ͳ������˿�ʼʹ�����ǡ�

����ģ��ʾ��
--------------------

���ǽ��������Ϊ��\ ``Foo``\ ����һ���򵥵Ĳ���ģ�顣

ģ��Ķ���Ӧ�������������ʼ��Ȼ���ǿհ��У�Ȼ����\ :ref:`Bracket Comment`��ע��Ӧ����\
``.rst:``\ ��ͷ���Ա���������������restructuredtext��ʽ���ĵ������磺

::

  # Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
  # file Copyright.txt or https://cmake.org/licensing for details.

  #[=======================================================================[.rst:
  FindFoo
  -------

  Finds the Foo library.

  Imported Targets
  ^^^^^^^^^^^^^^^^

  This module provides the following imported targets, if found:

  ``Foo::Foo``
    The Foo library

  Result Variables
  ^^^^^^^^^^^^^^^^

  This will define the following variables:

  ``Foo_FOUND``
    True if the system has the Foo library.
  ``Foo_VERSION``
    The version of the Foo library which was found.
  ``Foo_INCLUDE_DIRS``
    Include directories needed to use Foo.
  ``Foo_LIBRARIES``
    Libraries needed to link to Foo.

  Cache Variables
  ^^^^^^^^^^^^^^^

  The following cache variables may also be set:

  ``Foo_INCLUDE_DIR``
    The directory containing ``foo.h``.
  ``Foo_LIBRARY``
    The path to the Foo library.

  #]=======================================================================]

ģ���ĵ�������

* ���»��ߵı��⣬ָ��ģ�����ơ�

* ��ģ��������ݵļ�������ĳЩ��������Ҫ��������������ģ����û�Ӧ��֪��һЩ���������ϸ\
  �ڣ���������ָ����

* �г���ģ���ṩ�ĵ���Ŀ��Ĳ��֣�����еĻ���

* �г�ģ���ṩ�Ľ�������Ĳ��֡�

* ��ѡ���г�ģ��ʹ�õĻ�������Ĳ��֣�����еĻ���

������ṩ���κκ����������Ӧ�ñ�����һ������Ĳ����У����ǿ���ͨ���ڶ�����Щ�������λ\
���Ϸ��ĸ���\ ``.rst:``\ ע�Ϳ���м�¼��

����ģ���ʵ�ֿ��Դ��ĵ������濪ʼ��������Ҫ�ҵ�ʵ�ʵĿ�ȵȡ�����Ĵ�����Ȼ����ģ�����\
���Ͼ���������������ǲ���ģ����ص㣩�����ǿ�������һ����ͬ��ģʽ��

���ȣ����ǳ���ʹ��\ ``pkg-config``\ �����ҿ⡣��ע�⣬���ǲ�������������Ϊ�����ܲ����ã�\
�����ṩ��һ���ܺõ���㡣

.. code-block:: cmake

  find_package(PkgConfig)
  pkg_check_modules(PC_Foo QUIET Foo)

��Ӧ�ö���һЩ��\ ``PC_Foo_``\ ��ʼ�ı��������а�������\ ``Foo.pc``\ �ļ�����Ϣ��

����������Ҫ�ҵ��Ⲣ�����ļ�������ʹ��\ ``pkg-config``\ �е���ϢΪCMake�ṩ�йز���λ�õ�\
��ʾ��

.. code-block:: cmake

  find_path(Foo_INCLUDE_DIR
    NAMES foo.h
    PATHS ${PC_Foo_INCLUDE_DIRS}
    PATH_SUFFIXES Foo
  )
  find_library(Foo_LIBRARY
    NAMES foo
    PATHS ${PC_Foo_LIBRARY_DIRS}
  )

���ߣ�������ж�����ÿ��ã������ʹ��\ :module:`SelectLibraryConfigurations`\ ���Զ�\
����\ ``Foo_LIBRARY``\ ������

.. code-block:: cmake

  find_library(Foo_LIBRARY_RELEASE
    NAMES foo
    PATHS ${PC_Foo_LIBRARY_DIRS}/Release
  )
  find_library(Foo_LIBRARY_DEBUG
    NAMES foo
    PATHS ${PC_Foo_LIBRARY_DIRS}/Debug
  )

  include(SelectLibraryConfigurations)
  select_library_configurations(Foo)

�������һ����ð汾�ĺ÷��������磬��ͷ�ļ����������ʹ�ø���Ϣ������\ ``Foo_VERSION``\
������ע�⣬����ģ�鴫ͳ��ʹ�õ���\ ``Foo_VERSION_STRING``�������������Ҫ�������ߣ���\
���򣬳���ʹ��\ ``pkg-config``\ �е���Ϣ

.. code-block:: cmake

  set(Foo_VERSION ${PC_Foo_VERSION})

�������ǿ���ʹ��\ :module:`FindPackageHandleStandardArgs`\ Ϊ�������ʣ�µĴ󲿷ֹ���

.. code-block:: cmake

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(Foo
    FOUND_VAR Foo_FOUND
    REQUIRED_VARS
      Foo_LIBRARY
      Foo_INCLUDE_DIR
    VERSION_VAR Foo_VERSION
  )

�⽫���\ ``REQUIRED_VARS``\ �Ƿ����ֵ������\ ``-NOTFOUND``\ ��β�������ʵ�������\
``Foo_FOUND``��������������Щֵ�����������\ ``Foo_VERSION``����������İ汾�����ݸ�\
:command:`find_package`����������\ ``Foo_VERSION``\ �еİ汾���������İ汾����������\
���ӡ��Ϣ��ע�⣬����ҵ��˰���������ӡ��һ��������������ݣ���ָʾ�ҵ�����λ�á�

��ʱ�����Ǳ���Ϊ����ģ����û��ṩһ�ַ��������ӵ��ҵ��Ŀ⡣�������\ `����ģ��`_\
���������������ַ�������ͳ�ı���������������

.. code-block:: cmake

  if(Foo_FOUND)
    set(Foo_LIBRARIES ${Foo_LIBRARY})
    set(Foo_INCLUDE_DIRS ${Foo_INCLUDE_DIR})
    set(Foo_DEFINITIONS ${PC_Foo_CFLAGS_OTHER})
  endif()

����ҵ��˶���⣬��Ӧ�����пⶼ��������Щ�����У��йظ�����Ϣ�������\ `��׼������`_\ ���Ʋ��֣���

���ṩ�����Ŀ��ʱ����ЩĿ��Ӧ���������ռ䣨���ʹ��\ ``Foo::``\ ǰ׺����CMake��ʶ�𴫵ݸ�\
:command:`target_link_libraries`\ �������а���\ ``::``\ ��ֵӦ���ǵ����Ŀ�꣨��������\
�ǿ����������������Ŀ�겻���ڣ��μ�����\ :policy:`CMP0028`�����������ʵ��������Ϣ��

.. code-block:: cmake

  if(Foo_FOUND AND NOT TARGET Foo::Foo)
    add_library(Foo::Foo UNKNOWN IMPORTED)
    set_target_properties(Foo::Foo PROPERTIES
      IMPORTED_LOCATION "${Foo_LIBRARY}"
      INTERFACE_COMPILE_OPTIONS "${PC_Foo_CFLAGS_OTHER}"
      INTERFACE_INCLUDE_DIRECTORIES "${Foo_INCLUDE_DIR}"
    )
  endif()

������һ����Ҫע���һ���ǣ�\ ``INTERFACE_INCLUDE_DIRECTORIES``\ �����Ƶ�����Ӧ��ֻ��\
������Ŀ�걾�����Ϣ���������������κ�������෴����Щ������ҲӦ����Ŀ�꣬����CMakeӦ�ñ�\
��֪���������Ŀ��������Ȼ��CMake���Զ�������б�Ҫ����Ϣ��

ʹ��\ :command:`add_library`\ �������\ :prop_tgt:`IMPORTED`\ Ŀ����������ǿ���ָ\
��Ϊ\ ``UNKNOWN``\ ���͡��ڿ��ܷ��־�̬�������������£�����˴��룬CMake��ͨ�������\
����ȷ�����͡�

���������ڶ�����ã�:prop_tgt:`IMPORTED_CONFIGURATIONS`\ Ŀ������ҲӦ�ñ���䣺

.. code-block:: cmake

  if(Foo_FOUND)
    if (NOT TARGET Foo::Foo)
      add_library(Foo::Foo UNKNOWN IMPORTED)
    endif()
    if (Foo_LIBRARY_RELEASE)
      set_property(TARGET Foo::Foo APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE
      )
      set_target_properties(Foo::Foo PROPERTIES
        IMPORTED_LOCATION_RELEASE "${Foo_LIBRARY_RELEASE}"
      )
    endif()
    if (Foo_LIBRARY_DEBUG)
      set_property(TARGET Foo::Foo APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG
      )
      set_target_properties(Foo::Foo PROPERTIES
        IMPORTED_LOCATION_DEBUG "${Foo_LIBRARY_DEBUG}"
      )
    endif()
    set_target_properties(Foo::Foo PROPERTIES
      INTERFACE_COMPILE_OPTIONS "${PC_Foo_CFLAGS_OTHER}"
      INTERFACE_INCLUDE_DIRECTORIES "${Foo_INCLUDE_DIR}"
    )
  endif()

``RELEASE``\ ����Ӧ���������������г����Ա㵱�û�ʹ�õ��������κ��г���\
``IMPORTED_CONFIGURATIONS``\ ����ȫƥ��ʱѡ��ñ�����

������������Ӧ��������\ :program:`ccmake`\ �ӿ��У������û���ʽҪ��༭���ǡ�

.. code-block:: cmake

  mark_as_advanced(
    Foo_INCLUDE_DIR
    Foo_LIBRARY
  )

�����ģ���滻�ɰ汾����Ӧ�����ü����Ա����Ծ����ܼ����жϡ�

.. code-block:: cmake

  # compatibility variables
  set(Foo_VERSION_STRING ${Foo_VERSION})
