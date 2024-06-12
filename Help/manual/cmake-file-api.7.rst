.. cmake-manual-description: CMake File-Based API

cmake-file-api(7)
*****************

.. only:: html

   .. contents::

����
============

CMake�ṩ��һ�������ļ���API���ͻ��˿���ʹ��������ȡ����CMake���ɵĹ���ϵͳ��������Ϣ��\
�ͻ��˿���ͨ������ѯ�ļ�д�빹�������ض�λ���������������\ `��������`_\ ��ʹ��API��\
��CMake�ڹ����������ɹ���ϵͳʱ��������ȡ��ѯ�ļ���д��Ӧ���ļ����ͻ��˶�ȡ��

�����ļ���APIʹ�ù�����������\ ``<build>/.cmake/api/``\ Ŀ¼��API�Ѱ汾������֧�ָ���\
APIĿ¼�е��ļ����֡�API�ļ����ֵİ汾��������Ӧ��ʹ�õ�\ `��������`_\ �İ汾�����������ġ�\
�˰汾��CMakeֻ֧��һ��API�汾��\ `API v1`_��

.. versionadded:: 3.27
  ��ĿҲ����ʹ��\ :command:`cmake_file_api`\ �����ύ��ǰ���еĲ�ѯ��

.. _`file-api v1`:

API v1
======

API v1λ��\ ``<build>/.cmake/api/v1/``\ Ŀ¼�¡�����������Ŀ¼��

``query/``
  ����ͻ���д��Ĳ�ѯ�ļ�����Щ�ļ�������\ `v1������״̬��ѯ�ļ�`_��\ `v1�ͻ�����״̬��ѯ�ļ�`_\
  ��\ `v1�ͻ�����״̬��ѯ�ļ�`_��

``reply/``
  ����CMake�����ɹ���ϵͳʱ��д��Ӧ���ļ���������\ `v1Ӧ�������ļ�`_\ �ļ����������ļ�����\
  ��������\ `v1Ӧ���ļ�`_��CMakeӵ������Ӧ���ļ����ͻ�����Զ����ɾ�����ǡ�

  �ͻ��˿�����ʱ���ҺͶ�ȡӦ�������ļ����ͻ��˿���ѡ�����κ�ʱ�򴴽�\ ``reply/``\ Ŀ¼����\
  �������Ƿ�����µ�Ӧ�������ļ���

v1������״̬��ѯ�ļ�
-------------------------------

�������״̬��ѯ�ļ�����ͻ��˹���\ `��������`_\ ����Ҫ�汾�����󣬲�������е�CMake��ʶ��\
����������汾��

�ͻ��˿���ͨ����\ ``v1/query/``\ Ŀ¼�´������ļ��������������󡣸�ʽ���£�\ ::

  <build>/.cmake/api/v1/query/<kind>-v<major>

����\ ``<kind>``\ ��\ `��������`_\ ֮һ��\ ``-v``\ �����֣�\ ``<major>``\ �����汾�š�

������ʽ���ļ�����״̬�����ѯ���������κ��ض��Ŀͻ��ˡ�һ����������û���ⲿ�ͻ�Э�����˹���\
Ԥ������£���Ӧ��ɾ�����ǡ�

v1�ͻ�����״̬��ѯ�ļ�
-------------------------------

�ͻ�����״̬��ѯ�ļ�����ͻ���Ϊ\ `��������`_\ ����Ҫ�汾�����Լ������󣬲�������е�CMake\
��ʶ�����������汾��

�ͻ��˿���ͨ�����ض��ڿͻ��˵Ĳ�ѯ��Ŀ¼�д������ļ��������Լ������󡣸�ʽ���£�\ ::

  <build>/.cmake/api/v1/query/client-<client>/<kind>-v<major>

����\ ``client-``\ ����������\ ``<client>``\ ��Ψһ��ʶ�ͻ��˵��ַ�����\ ``<kind>``\
��\ `��������`_\ ֮һ��\ ``-v``\ ��������˼��\ ``<major>``\ �����汾�š�ÿ���ͻ��˱���ѡ\
��Ψһ��\ ``<client>``\ ��ʶ��ͨ�����Լ��ķ�ʽ��

������ʽ���ļ��ǿͻ���\ ``<client>``\ ӵ�е���״̬��ѯ��ӵ�����ǵĿͻ��˿�����ʱɾ�����ǡ�

v1�ͻ�����״̬��ѯ�ļ�
------------------------------

��״̬��ѯ�ļ�����ͻ�������ÿ��\ `��������`_\ �İ汾�б�����ֻ������е�CMake��ʶ�����\
�°汾��

�ͻ��˿���ͨ������\ ``query.json``\ �ļ��������ض��ڿͻ��˵���Ŀ¼����״̬��ѯ����ʽ���£�\ ::

  <build>/.cmake/api/v1/query/client-<client>/query.json

����\ ``client-``\ ����������\ ``<client>``\ ��Ψһ��ʶ�ͻ��˺Ͳ�ѯ���ַ�����\
``query.json``\ Ҳ����������ÿ���ͻ��˱���ͨ���Լ��ķ�ʽѡ��Ψһ��\ ``<client>``\ ��ʶ����

``query.json``\ �ļ��ǿͻ���\ ``<client>``\ ӵ�е���״̬��ѯ��ӵ�еĿͻ��˿�����ʱ���»�\
ɾ�����ǡ��������Ŀͻ��˰�װ����ʱ�������ܻ������д����״̬��ѯ���Թ�������������µĶ���汾��\
�������������Ҫ��CMake����Ҫ�����ɶ������汾��

һ��\ ``query.json``\ �ļ��������һ��JSON����

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

��Ա������

``requests``
  ����������������JSON���顣ÿ��������һ��JSON���󣬰������³�Ա��

  ``kind``
    ָ��Ҫ������Ӧ���е�\ `��������`_\ ֮һ��

  ``version``
    ��ʾ�ͻ��˿������Ķ������͵İ汾���汾����ѭ����汾Լ������Ҫ�ʹ�Ҫ�������ֵ����Ϊ

    * ָ�����Ǹ��ģ����汾�ŵ�JSON����������
    * ����ָ���Ǹ������汾�����\ ``major``\ ��Ա�ͣ���ѡ��\ ``minor``\ ��Ա��JSON���󣬻���
    * һ��JSON���飬��Ԫ�ؾ�Ϊ����Ԫ��֮һ��

  ``client``
    ��ѡ��Ա���������ͻ���ʹ�á���\ `v1Ӧ�������ļ�`_\ ��Ϊ�ͻ���д��Ӧ���б�����ֵ������\
    �����ԡ��ͻ��˿���ʹ�������Զ�����Ϣ������һ�𴫵ݵ�����Ӧ��

  ����ÿ������Ķ������ͣ�CMake�����������г��Ķ���������ѡ����ʶ���\ *��һ��*\ �汾����Ӧ\
  ��ʹ����ѡ�� *major* �汾�������е�CMake��֪�ĸ����汾�����\ *minor*\ �汾����ˣ��ͻ�\
  ��Ӧ�ð�����ѡ˳���г�����֧�ֵ���Ҫ�汾���Լ�ÿ����Ҫ�汾�������С��Ҫ�汾��

``client``
  ��ѡ��Ա���������ͻ���ʹ�á���\ `v1Ӧ�������ļ�`_\ ��Ϊ�ͻ���д��Ӧ���б�����ֵ�����򽫱�\
  ���ԡ��ͻ��˿���ʹ���������в�ѯ���Զ�����Ϣ���ݸ�����Ӧ��

����\ ``query.json``\ �����Ա�������Ա�����ʹ�á�������ڣ������������ʵ��ǰ������ԡ�

v1Ӧ�������ļ�
-------------------

���������ɹ���ϵͳʱ��CMakeдһ��\ ``index-*.json``\ �ļ��ŵ�\ ``v1/reply/``\ Ŀ¼�С�\
�ͻ��˱����ȶ�ȡӦ�������ļ�������\ `v1Ӧ���ļ�`_\ ֻ��ͨ�����ö�ȡ��Ӧ�������ļ����ĸ�ʽΪ��\ ::

  <build>/.cmake/api/v1/reply/index-<unspecified>.json

����\ ``index-``\ ����������\ ``<unspecified>``\ ��CMakeѡ���δָ�����ơ�ÿ�������µ�\
�����ļ�ʱ���������һ�������ƣ���ɾ���ɵ����ơ�����Щ����֮��Ķ�ʱ���ڣ����ܴ��ڶ�������ļ���\
���ֵ�˳������ǰ���ǵ�ǰ�����ļ���

Ӧ�������ļ�����һ��JSON����

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

��Ա������

``cmake``
  һ��JSON���󣬰����й�����Ӧ���CMakeʵ������Ϣ�����������³�Ա��

  ``version``
    һ��JSON���󣬳�Աָ��CMake�İ汾��

    ``major``, ``minor``, ``patch``
      ����ֵ��ָ�����汾���ΰ汾�Ͳ����汾�����
    ``suffix``
      ָ���汾��׺���ַ���������еĻ���������\ ``g0abc3``��
    ``string``
      ָ�������汾���ַ�������ʽΪ\ ``<major>.<minor>.<patch>[-<suffix>]``��
    ``isDirty``
      һ������ֵ��ָʾ�汾�Ƿ�Ӿ��������޸ĵİ汾����Դ���������ɡ�

  ``paths``
    һ��JSON����ָ��CMake�Դ��Ķ�����·��������\ :program:`cmake`��\ :program:`ctest`\
    ��\ :program:`cpack`\ ��Ա�����ǵ�ֵ��JSON�ַ�����ָ��ÿ�����ߵľ���·��������б�ܱ�\
    ʾ��������һ��\ ``root``\ ��Ա�����ڰ���CMake��Դ��Ŀ¼�ľ���·��������\ ``Modules/``\
    Ŀ¼����\ :variable:`CMAKE_ROOT`����

  ``generator``
    һ��JSON�����������ڹ�����CMake�����������ĳ�Ա�У�

    ``multiConfig``
      һ������ֵ��ָ���������Ƿ�֧�ֶ��������á�
    ``name``
      ָ�����������Ƶ��ַ�����
    ``platform``
      ���������֧��\ :variable:`CMAKE_GENERATOR_PLATFORM`������һ��ָ��������ƽ̨��\
      �Ƶ��ַ�����

``objects``
  һ��JSON���飬�г�����ΪӦ���һ�������ɵ�����\ `��������`_\ �����а汾��ÿ����������һ��\
  `v1Ӧ���ļ�����`_��

``reply``
  һ��JSON���󣬾���CMake���������ɻظ���\ ``query/``\ Ŀ¼�����ݡ���Ա�������ʽ��

  ``<kind>-v<major>``
    ������ĳ�Ա������ÿ��\ `v1������״̬��ѯ�ļ�`_\ �У�CMake����ʶ��Ϊ������Ҫ�汾\
    ``<major>``\ �Ķ���kind ``<kind>``\ �����󡣸�ֵ��һ��\ `v1Ӧ���ļ�����`_���Ըö�\
    �����ͺͰ汾��Ӧ��Ӧ���ļ������á�

  ``<unknown>``
    ������ĳ�Ա������ÿ��CMake����ʶ���\ `v1������״̬��ѯ�ļ�`_\ �С���ֵ��һ��JSON��\
    ���䵥��\ ``error``\ ��Ա����һ���ַ��������ַ������д�����Ϣ��ָʾ��ѯ�ļ�δ֪��

  ``client-<client>``
    ������ĳ�Ա������ÿ������\ `v1�ͻ�����״̬��ѯ�ļ�`_\ �Ŀͻ������е�Ŀ¼�С�����һ��\
    JSON���󣬾����ѯ\ ``query/client-<client>/``\ Ŀ¼�����ݡ���Ա�ĸ�ʽΪ��

    ``<kind>-v<major>``
      ������ĳ�Ա������ÿ��\ `v1�ͻ�����״̬��ѯ�ļ�`_\ �У���Щ�ļ���CMakeʶ��Ϊ����\
      ��Ҫ�汾\ ``<major>``\ �Ķ���kind ``<kind>``\ �����󡣸�ֵ��һ��\ `v1Ӧ���ļ�����`_��\
      �Ըö������ͺͰ汾��Ӧ��Ӧ���ļ������á�

    ``<unknown>``
      ������ĳ�Ա������ÿ��CMake����ʶ���\ `v1�ͻ�����״̬��ѯ�ļ�`_\ �С���ֵ��һ��\
      JSON�����䵥��\ ``error``\ ��Ա����һ���ַ��������ַ������д�����Ϣ��ָʾ��ѯ�ļ�\
      δ֪��

    ``query.json``
      �����Ա������ʹ��\ `v1�ͻ�����״̬��ѯ�ļ�`_\ �Ŀͻ��ˡ����\ ``query.json``\
      �ļ�δ�ܶ�ȡ�����ΪJSON���󣬴˳�Ա��һ��JSON�����䵥��\ ``error``\ ��Ա����һ��\
      ���д�����Ϣ���ַ��������򣬸ó�Ա��һ��JSON���󣬾���\ ``query.json``\ �ļ������ݡ�\
      ��Ա������

      ``client``
        ``query.json``\ �ļ�������\ ``client``\ ��Ա��������ڵĻ���

      ``requests``
        ``query.json``\ �ļ�������\ ``requests``\ ��Ա��������ڵĻ���

      ``responses``
        ���\ ``query.json``\ �ļ�\ ``requests``\ ��Աȱʧ����Ч���ó�Ա��һ��JSON����\
        �䵥��\ ``error``\ ��Ա����һ�����д�����Ϣ���ַ��������򣬸ó�Ա������һ��JSON��\
        �飬��������ͬ��˳������������ÿ����Ŀ������Ӧ��ÿ����Ӧ��

        * ���е���\ ``error``\ ��Ա��JSON���󣬸ó�Ա�������д�����Ϣ���ַ���������
        * һ��\ `v1Ӧ���ļ�����`_\ ��������������ͺ���ѡ�汾��Ӧ��Ӧ���ļ������á�

�ͻ��˶�ȡӦ�������ļ��󣬿��Զ�ȡ�����õ�����\ `v1Ӧ���ļ�`_��

v1Ӧ���ļ�����
^^^^^^^^^^^^^^^^^^^^^^^

Ӧ�������ļ�ʹ��JSON�����ʾ����һ���ظ��ļ������ã���JSON���������Ա��

``kind``
  ָ��\ `��������`_\ ֮һ���ַ�����
``version``
  һ��JSON�������Ա\ ``major``\ ��\ ``minor``\ ָ���������͵������汾�����
``jsonFile``
  һ��JSON�ַ�����ָ�������Ӧ�������ļ��������ö������һ��JSON�ļ���·����

v1Ӧ���ļ�
--------------

�����ض�\ `��������`_\ ��Ӧ���ļ���CMake��д����Щ�ļ���������δָ���ģ����Ҳ��ܱ��ͻ��˽��͡�\
�ͻ��˱������ȶ�ȡ\ `v1Ӧ�������ļ�`_������ѭ��������Ӧ�������Ƶ����á�

Ӧ���ļ������������ļ�����Զ���ᱻͬ�������ݲ�ͬ���ļ���ȡ����������ͻ���������CMake��ͬʱ\
��ȡ�ļ�������ܻ����һ���µ�Ӧ��Ȼ����������һ���µ�Ӧ���CMake�����Դ�֮ǰ��������ɾ\
����û��д���Ӧ���ļ�������ͻ�����ͼ��ȡ�������õ�Ӧ���ļ����������ļ���ʧ������ζ�Ų���\
CMake�Ѿ�������һ���µ�Ӧ�𡣿ͻ�������ͨ����ȡ�µ�Ӧ�������ļ����¿�ʼ��

.. _`file-api object kinds`:

��������
============

CMake�����ļ���APIʹ���������͵�JSON���󱨸湹��ϵͳ��������Ϣ��ÿ�ֶ���ʹ�ô�����Ҫ�ʹ�\
Ҫ���������汾�����������ؽ��а汾���ơ�ÿһ�ֶ����������ĸ�ʽ��

.. code-block:: json

  {
    "kind": "<kind>",
    "version": { "major": 1, "minor": 0 },
    "...": {}
  }

``kind``\ ��Ա��ָ�������������Ƶ��ַ�����\ ``version``\ ��Ա��һ��JSON����\ ``major``\
��Ա��\ ``minor``\ ��Աָ���������Ͱ汾��������ɲ��֡����ӵĶ����Ա���ض���ÿ�ֶ������͵ġ�

��codemodel����������
-----------------------

``codemodel``\ ����������������CMake��ģ�Ĺ���ϵͳ�ṹ��

ֻ��һ��\ ``codemodel``\ �������汾�����汾2���汾1��������Ϊ�˱�����\
:manual:`cmake-server(7)`\ ģʽ�İ汾������

��codemodel���汾2
^^^^^^^^^^^^^^^^^^^^^

``codemodel``\ ����汾2��һ��JSON����

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

�ض���\ ``codemodel``\ ����ĳ�Ա�У�

``paths``
  �������³�Ա��JSON����

  ``source``
    ָ������ԴĿ¼�ľ���·�����ַ���������б�ܱ�ʾ��

  ``build``
    ָ�����㹹��Ŀ¼�ľ���·�����ַ���������б�ܱ�ʾ��

``configurations``
  һ��JSON���飬��������ù����������Ӧ����Ŀ���ڵ������������У���һ����Ŀ����\
  :variable:`CMAKE_BUILD_TYPE`\ ������ֵ�����ڶ�������������\
  :variable:`CMAKE_CONFIGURATION_TYPES`\ �������г���ÿ�����ö���һ����Ŀ��ÿ����Ŀ��\
  һ��JSON���󣬰������³�Ա��

  ``name``
    ָ���������Ƶ��ַ���������\ ``Debug``��

  ``directories``
    ��Ŀ��JSON���飬ÿ����Ŀ��Ӧ�ڹ���ϵͳĿ¼����ԴĿ¼����\ ``CMakeLists.txt``\ �ļ���\
    ��һ����Ŀ��Ӧ�ڶ���Ŀ¼��ÿ����Ŀ��һ��JSON���󣬰������³�Ա��

    ``source``
      ָ��ԴĿ¼·�����ַ���������б�ܱ�ʾ�����Ŀ¼λ�ڶ���ԴĿ¼�У���ָ������ڸ�Ŀ¼��·\
      ����ʹ��\ ``.``\ ���ڶ���ԴĿ¼����������·���Ǿ��Եġ�

    ``build``
      ָ������Ŀ¼·�����ַ���������б�ܱ�ʾ�����Ŀ¼λ�ڶ��㹹��Ŀ¼�У���ָ������ڸ�Ŀ¼\
      ��·����ʹ��\ ``.``\ ���ڶ��㹹��Ŀ¼����������·���Ǿ��Եġ�

    ``parentIndex``
      ��Ŀ¼���Ƕ���Ŀ¼ʱ���ֵĿ�ѡ��Ա����ֵ����\ ``directories``\ ��������һ����Ŀ����\
      ������������0��ʼ��������������Ӧ�ڽ���Ŀ¼���Ϊ��Ŀ¼�ĸ�Ŀ¼��

    ``childIndexes``
      ��Ŀ¼����Ŀ¼ʱ���ֵĿ�ѡ��Ա����ֵΪJSON���飬������\ :command:`add_subdirectory`\
      ��\ :command:`subdirs`\ ���������Ŀ¼��Ӧ����Ŀ��ÿ����Ŀ������\ ``directories``\
      ��������һ����Ŀ�Ļ���0���޷�������������

    ``projectIndex``
      ��\ ``projects``\ �����л���0���޷�������������ָʾ��Ŀ¼����������ϵͳ��Ŀ��

    ``targetIndexes``
      ��Ŀ¼�������Ŀ��ʱ���ֵĿ�ѡ��Ա��������������Ŀ¼��Ŀ�ꡣ��ֵ��һ��JSON���飬����\
      ��Ŀ������Ӧ����Ŀ��ÿ����Ŀ����һ������0���޷�����������\ ``targets``\ �����������

    ``minimumCMakeVersion``
      ��Ŀ¼��֪CMake�����Ҫ��汾ʱ���ֵĿ�ѡ��Ա�����Ƕ�Ŀ¼�����������֮һ��\
      :command:`cmake_minimum_required(VERSION)`\ �������ص��ø�����\ ``<min>``\
      �汾����ֵ��һ��JSON����ֻ��һ����Ա��

      ``string``
        һ���ַ�����ָ���������С�汾����ʽΪ��\ ::

          <major>.<minor>[.<patch>[.<tweak>]][<suffix>]

        ÿ���������һ���޷�����������׺�����������ַ�����

    ``hasInstallRule``
      ��ѡ��Ա����Ŀ¼������Ŀ¼֮һ�����κ�\ :command:`install`\ ����ʱ����\
      ``make install``\ ���Ч�����Ƿ����ʱ���Բ���ֵ\ ``true``\ ���֡�

    ``jsonFile``
      һ��JSON�ַ�����ָ��һ������ڴ���ģ���ļ�����һ������\
      `��codemodel���汾2��directory������`_\ ��JSON�ļ���·����

      ���ֶ����ڴ���ģ�Ͱ汾2.3����ӵġ�

  ``projects``
    �빹��ϵͳ�ж���Ķ�����Ŀ������Ŀ���Ӧ����Ŀ��JSON���顣ÿ�����ӣ���Ŀ��Ӧ��һ��ԴĿ¼��\
    ��\ ``CMakeLists.txt``\ �ļ�����\ :command:`project`\ ����ʱʹ�õ���Ŀ�����븸Ŀ\
    ¼��ͬ����һ����Ŀ��Ӧ�ڶ�����Ŀ��

    ÿ����Ŀ��һ��JSON���󣬰������³�Ա��

    ``name``
      ָ��\ :command:`project`\ �������Ƶ��ַ�����

    ``parentIndex``
      ����Ŀ���Ƕ���ʱ���ֵĿ�ѡ��Ա����ֵ����\ ``projects``\ ��������һ����Ŀ�Ļ���0����\
      ����������������������Ӧ�ڽ�����Ŀ���Ϊ����Ŀ�ĸ���Ŀ��

    ``childIndexes``
      ����Ŀ������Ŀʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���飬����������Ŀ���Ӧ����Ŀ��ÿ����\
      Ŀ������\ ``projects``\ ��������һ����Ŀ�Ļ���0���޷�������������

    ``directoryIndexes``
      һ��JSON���飬��Ŀ��Ӧ����Ϊ��Ŀһ���ֵĹ���ϵͳĿ¼����һ����Ŀ��Ӧ����Ŀ�Ķ���Ŀ¼��\
      ÿ����Ŀ����һ������0���޷�����������\ ``directories``\ �����������

    ``targetIndexes``
      ����Ŀ�������Ŀ��ʱ���ֵĿ�ѡ��Ա����������������Ŀ��Ŀ�ꡣ��ֵ��һ��JSON���飬����\
      ��Ŀ������Ӧ����Ŀ��ÿ����Ŀ����һ������0���޷�����������\ ``targets``\ �����������

  ``targets``
    �빹��ϵͳĿ�����Ӧ����Ŀ��JSON���顣������Ŀ����ͨ������\ :command:`add_executable`��\
    :command:`add_library`\ ��\ :command:`add_custom_target`\ �����ģ������������\
    Ŀ��ͽӿڿ⣨���ǲ������κι������򣩡�ÿ����Ŀ��һ��JSON���󣬰������³�Ա��

    ``name``
      ָ��Ŀ�����Ƶ��ַ�����

    ``id``
      Ψһ��ʶĿ����ַ���������\ ``jsonFile``\ ���õ��ļ��е�\ ``id``\ �ֶ���ƥ�䡣

    ``directoryIndex``
      һ������0���޷�����������\ ``directories``\ �����������ָʾ�����ж���Ŀ��Ĺ���ϵ\
      ͳĿ¼��

    ``projectIndex``
      ����\ ``projects``\ �����л���0���޷�������������ָʾ�����ж���Ŀ��Ĺ���ϵͳ��Ŀ��

    ``jsonFile``
      һ��JSON�ַ�����ָ���Ӵ���ģ���ļ�������\ `��codemodel���汾2��target������`_\ ����\
      һ��JSON�ļ������·����

��codemodel���汾2��directory������
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

����ģ�͡�Ŀ¼��������\ `��codemodel���汾2`_\ �����\ ``directories``\ �������á�ÿ��\
��directory��������һ��JSON���󣬰������³�Ա��

``paths``
  �������³�Ա��JSON����

  ``source``
    ָ��ԴĿ¼·�����ַ���������б�ܱ�ʾ�����Ŀ¼λ�ڶ���ԴĿ¼�У���ָ������ڸ�Ŀ¼��·��\
    ��ʹ��\ ``.``\ ���ڶ���ԴĿ¼����������·���Ǿ��Եġ�

  ``build``
    ָ������Ŀ¼·�����ַ���������б�ܱ�ʾ�����Ŀ¼λ�ڶ��㹹��Ŀ¼�У���ָ������ڸ�Ŀ¼��\
    ·����ʹ��\ ``.``\ ���ڶ��㹹��Ŀ¼����������·���Ǿ��Եġ�

``installers``
  ��\ :command:`install`\ �������Ӧ����Ŀ��JSON���顣ÿ����Ŀ��һ��JSON���󣬰�������\
  ��Ա��

  ``component``
    ָ������Ӧ��\ :command:`install`\ �������ѡ���������ַ�����

  ``destination``
    Ϊ������ض�\ ``type``\ ֵ�ṩ�Ŀ�ѡ��Ա����ֵ��ָ����װĿ��·�����ַ�����·�������Ǿ�\
    �Եģ�Ҳ����������ڰ�װǰ׺�ġ�

  ``paths``
    Ϊ������ض�\ ``type``\ ֵ�ṩ�Ŀ�ѡ��Ա����ֵ�ǰ�����Ҫ��װ��·�����ļ���Ŀ¼����Ӧ��\
    ��Ŀ��JSON���顣ÿ����Ŀ�ǣ�

    * ָ��Ҫ��װ���ļ���Ŀ¼��·�����ַ�����·��ǰ��û��\ ``/``\ �Ĳ���Ҳָ����Ҫ��װ��Ŀ\
      ��Ŀ¼�µ��ļ���Ŀ¼��·�������ƣ���

    * һ��JSON���󣬰������³�Ա��

      ``from``
        ָ��Ҫ��װ���ļ���Ŀ¼��·�����ַ�����

      ``to``
        ָ��Ҫ��Ŀ��Ŀ¼�°�װ���ļ���Ŀ¼��·�����ַ�����

    ������������£�·��������б�ܱ�ʾ�������from��·��λ������Ӧ\ ``type``\ ֵ��¼�Ķ���\
    Ŀ¼�У���ָ������ڸ�Ŀ¼��·��������·���Ǿ��Եġ�

  ``type``
    ָ����װ�������͵��ַ�������ֵ������ֵ֮һ��һЩ�����ṩ�˶���ĳ�Ա��

    ``file``
      һ��\ :command:`install(FILES)`\ ��\ :command:`install(PROGRAMS)`\ ���á���\
      ���\ ``destination``\ ��\ ``paths``\ ��Ա����ʹ�����������ʾ�Ķ���\ *Դ*\ Ŀ\
      ¼�µ�·����\ ``isOptional``\ ��Ա���ܴ��ڡ�������û��������Ա��

    ``directory``
      һ��\ :command:`install(DIRECTORY)`\ ���á������\ ``destination``\ ��\
      ``paths``\ ��Ա����ʹ�����������ʾ�Ķ���\ *Դ*\ Ŀ¼�µ�·����\ ``isOptional``\
      ��Ա���ܴ��ڡ�������û��������Ա��

    ``target``
      һ��\ :command:`install(TARGETS)`\ ���á������\ ``destination``\ ��\ ``paths``\
      ��Ա����ʹ�����������ʾ�Ķ���\ *����*\ Ŀ¼�µ�·����\ ``isOptional``\ ��Ա���ܴ�\
      �ڡ���������ж���ĳ�Ա\ ``targetId``��\ ``targetIndex``��\ ``targetIsImportLibrary``\
      ��\ ``targetInstallNamelink``��

    ``export``
      һ��\ :command:`install(EXPORT)`\ ���á������\ ``destination``\ ��\ ``paths``\
      ��Ա����ʹ�����������ʾ�Ķ���\ *����*\ Ŀ¼�µ�·����\ ``paths``\ ��Ŀָ����CMake\
      Ϊ��װ�Զ����ɵ��ļ������ǵ�ʵ��ֵ����Ϊ��˽��ʵ��ϸ�ڡ������;��ж���ĳ�Ա\
      ``exportName``\ ��\ ``exportTargets``��

    ``script``
      һ��\ :command:`install(SCRIPT)`\ ���á���������ж���ĳ�Ա\ ``scriptFile``��

    ``code``
      һ��\ :command:`install(CODE)`\ ���á�������û��������Ա��

    ``importedRuntimeArtifacts``
      һ��\ :command:`install(IMPORTED_RUNTIME_ARTIFACTS)`\ ���á������\
      ``destination``\ ��Ա��\ ``isOptional``\ ��Ա���ܴ��ڡ�������û��������Ա��

    ``runtimeDependencySet``
      һ��\ :command:`install(RUNTIME_DEPENDENCY_SET)`\ ���û�һ������\
      ``RUNTIME_DEPENDENCIES``\ ��\ :command:`install(TARGETS)`\ ���á������\
      ``destination``\ ��Ա���������ж���ĳ�Ա\ ``runtimeDependencySetName``\ ��\
      ``runtimeDependencySetType``��

    ``fileSet``
      һ������\ ``FILE_SET``\ ��\ :command:`install(TARGETS)`\ ���á����\
      ``destination``\ ��\ ``paths``\ ��Ա��\ ``isOptional``\ ��Ա���ܴ��ڡ���������\
      ����ĳ�Ա\ ``fileSetName``��\ ``fileSetType``��\ ``fileSetDirectories``\ ��\
      ``fileSetTarget``��

      �������ڴ���ģ��2.4������ӡ�

  ``isExcludeFromAll``
    ��ѡ��Ա����ʹ��\ ``EXCLUDE_FROM_ALL``\ ѡ�����\ :command:`install`\ ʱ���Բ���ֵ\
    ``true``\ ���֡�

  ``isForAllComponents``
    ��ʹ��\ ``ALL_COMPONENTS``\ ѡ�����\ :command:`install(SCRIPT|CODE)`\ ʱ����\
    ����ֵ\ ``true``\ ���ֵĿ�ѡ��Ա��

  ``isOptional``
    ��ѡ��Ա����ʹ��\ ``OPTIONAL``\ ѡ�����\ :command:`install`\ ʱ�Բ���ֵ\ ``true``\
    ���֡���\ ``type``\ Ϊ\ ``file``��\ ``directory``\ ��\ ``target``\ ʱ��������������

  ``targetId``
    ��\ ``type``\ Ϊ\ ``target``\ ʱ���ֵĿ�ѡ��Ա���ַ�����ʽ��Ψһ��ʶ����װ��Ŀ������\
    ��������codemodel�������\ ``targets``\ ������Ŀ���\ ``id``\ ��Ա��ƥ�䡣

  ``targetIndex``
    ��\ ``type``\ Ϊ\ ``target``\ ʱ���ֵĿ�ѡ��Ա����ֵ��һ���޷�������������0��������\
    ָ��Ҫ��װ��Ŀ����������codemodel�������\ ``targets``\ ���顣

  ``targetIsImportLibrary``
    ��ѡ��Ա����\ ``type``\ Ϊ\ ``target``\ �Ұ�װ��������Windows DLL������ļ���AIX��\
    ���������ļ�ʱ���ó�Ա����֡�������ڣ����Ĳ���ֵΪ\ ``true``��

  ``targetInstallNamelink``
    ��ѡ��Ա����\ ``type``\ Ϊ\ ``target``\ ���Ұ�װ�����Ӧ�ڿ���ʹ�÷�������ʵ��\
    :prop_tgt:`VERSION` ��\ :prop_tgt:`SOVERSION`\ Ŀ�����Ե�Ŀ��ʱ���֡���ֵ��һ����\
    ������ָʾ��װ����Ӧ����δ���������ӣ�\ ``skip``\ ��ζ�Ű�װ����Ӧ�������������ӣ�ֻ\
    ��װ�������ļ�������\ ``only``\ ��ζ�Ű�װ����Ӧ��ֻ��װ�������ӣ��������������ļ�����\
    ��������£�\ ``paths``\ ��Ա�����г���ʵ�ʰ�װ�����ݡ�

  ``exportName``
    ��\ ``type``\ Ϊ\ ``export``\ ʱ���ֵĿ�ѡ��Ա����ֵ��һ���ַ�����ָ�����������ơ�

  ``exportTargets``
    ��\ ``type``\ Ϊ\ ``export``\ ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���飬�����뵼���а�\
    ����Ŀ�����Ӧ����Ŀ��ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

    ``id``
      Ψһ��ʶĿ����ַ�������������codemodel�������\ ``targets``\ ������Ŀ���\ ``id``\
      ��Ա��ƥ�䡣

    ``index``
      һ������0���޷���������������Ŀ�������codemodel�������\ ``targets``\ ���顣

  ``runtimeDependencySetName``
    ��ѡ��Ա����\ ``type``\ Ϊ\ ``runtimeDependencySet``\ ���Ұ�װ��������\
    :command:`install(RUNTIME_DEPENDENCY_SET)`\ ���ô���ʱ���֡���ֵ��һ���ַ�����ָ\
    ������װ������ʱ����������ơ�

  ``runtimeDependencySetType``
    ��\ ``type``\ Ϊ\ ``runtimeDependencySet``\ ʱ���ֵĿ�ѡ��Ա����ֵ�Ǿ�������ֵ֮\
    һ���ַ�����

    ``library``
      ָʾ�˰�װ����װ��macOS��ܵ������

    ``framework``
      ָʾ�˰�װ����װmacOS��ܵ������

  ``fileSetName``
    ��\ ``type``\ Ϊ\ ``fileSet``\ ʱ���ֵĿ�ѡ��Ա����ֵ�Ǵ����ļ������Ƶ��ַ�����

    ���ֶ��ڴ���ģ��2.4������ӡ�

  ``fileSetType``
    ��\ ``type``\ Ϊ\ ``fileSet``\ ʱ���ֵĿ�ѡ��Ա����ֵ�Ǵ����ļ������͵��ַ�����

    ���ֶ��ڴ���ģ��2.4������ӡ�

  ``fileSetDirectories``
    ��\ ``type``\ Ϊ\ ``fileSet``\ ʱ���ֵĿ�ѡ��Ա����ֵ�ǰ����ļ�������Ŀ¼���ַ�����\
    ����\ :prop_tgt:`HEADER_DIRS`\ ��\ :prop_tgt:`HEADER_DIRS_<NAME>`\ ��������\
    ���ʽֵ����)��

    ���ֶ��ڴ���ģ��2.4������ӡ�

  ``fileSetTarget``
    ��\ ``type``\ Ϊ\ ``fileSet``\ ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���󣬰������³�Ա��

    ``id``
      Ψһ��ʶĿ����ַ�������������codemodel�������\ ``targets``\ ������Ŀ���\ ``id``\
      ��Ա��ƥ�䡣

    ``index``
      һ������0���޷���������������Ŀ�������codemodel�������\ ``targets``\ ���顣

    ���ֶ��ڴ���ģ��2.4������ӡ�

  ``scriptFile``
    ��\ ``type``\ Ϊ\ ``script``\ ʱ���ֵĿ�ѡ��Ա����ֵ��һ���ַ�����ָ�������Ͻű��ļ�\
    ��·��������б�ܱ�ʾ������ļ�λ�ڶ���ԴĿ¼�У���ָ������ڸ�Ŀ¼��·��������·���Ǿ��Եġ�

  ``backtrace``
    ��CMake���Ի��ݵ���Ӵ˰�װ�����\ :command:`install`\ �������������ʱ���ֵĿ�ѡ��\
    Ա����ֵ��\ ``backtraceGraph``\ ��Ա��\ ``nodes``\ �����л���0���޷�������������

``backtraceGraph``
  һ��\ `��codemodel���汾2��backtrace graph������`_����ڵ�Ӵˡ�Ŀ¼�������������ط���\
  ``backtrace``\ ��Ա���á�

��codemodel���汾2��target������
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

����ģ�͡�Ŀ�ꡱ������\ `��codemodel���汾2`_\ �����\ ``targets``\ �������á�ÿ����Ŀ�ꡱ��\
����һ��JSON���󣬰������³�Ա��

``name``
  ָ��Ŀ���߼����Ƶ��ַ�����

``id``
  Ψһ��ʶĿ����ַ������ø�ʽδָ������Ӧ�ɿͻ��˽��͡�

``type``
  ָ��Ŀ�����͵��ַ�����ȡֵΪ\ ``EXECUTABLE``��\ ``STATIC_LIBRARY``��\
  ``SHARED_LIBRARY``��\ ``MODULE_LIBRARY``��\ ``OBJECT_LIBRARY``��\
  ``INTERFACE_LIBRARY``\ ��\ ``UTILITY``\ �е�һ����

``backtrace``
  ��CMake���Ի��ݵ�����Ŀ���Դ�����е�����ʱ���ֵĿ�ѡ��Ա����ֵ��\ ``backtraceGraph``\
  ��Ա��\ ``nodes``\ �����л���0���޷�������������

``folder``
  ����\ :prop_tgt:`FOLDER`\ Ŀ������ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON����ֻ��һ����Ա��

  ``name``
    ָ��Ŀ���ļ������Ƶ��ַ�����

``paths``
  �������³�Ա��JSON����

  ``source``
    ָ��Ŀ��ԴĿ¼·�����ַ���������б�ܱ�ʾ�����Ŀ¼λ�ڶ���ԴĿ¼�У���ָ������ڸ�Ŀ¼��\
    ·����ʹ��\ ``.``\ ���ڶ���ԴĿ¼����������·���Ǿ��Եġ�

  ``build``
    ָ��Ŀ�깹��Ŀ¼·�����ַ���������б�ܱ�ʾ�����Ŀ¼λ�ڶ��㹹��Ŀ¼�У���ָ������ڸ�Ŀ\
    ¼��·����ʹ��\ ``.``\ ���ڶ��㹹��Ŀ¼����������·���Ǿ��Եġ�

``nameOnDisk``
  ��ѡ��Ա���������ӻ�浵Ϊ�����������Ŀ�ִ��Ŀ��Ϳ�Ŀ�ꡣ��ֵ��һ���ַ�����ָ�������Ϲ���\
  ���ļ�����

``artifacts``
  ��ѡ��Ա���������ڿ�ִ��Ŀ��Ϳ�Ŀ���У���ЩĿ���ڴ��������ɹ�������ʹ�õĹ�������ֵ���빤\
  ����Ӧ����Ŀ��JSON���顣ÿ����Ŀ��һ��JSON���󣬰���һ����Ա��

  ``path``
    ָ���������ļ�·�����ַ���������б�ܱ�ʾ������ļ�λ�ڶ��㹹��Ŀ¼�У���ָ������ڸ�Ŀ¼\
    ��·��������·���Ǿ��Եġ�

``isGeneratorProvided``
  ��ѡ��Ա�����Ŀ����CMake�Ĺ���ϵͳ�������ṩ����������Դ�����е������ṩ�����Բ���ֵ\
  ``true``\ ���֡�

``install``
  ��Ŀ�����\ :command:`install`\ ����ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���󣬰������³�Ա��

  ``prefix``
    ָ����װǰ׺��JSON��������һ����Ա��

    ``path``
      ָ��\ :variable:`CMAKE_INSTALL_PREFIX`\ ֵ���ַ�����

  ``destinations``
    ָ����װĿ��·������Ŀ��JSON���顣ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

    ``path``
      ָ����װĿ��·�����ַ�����·�������Ǿ��Եģ�Ҳ����������ڰ�װǰ׺�ġ�

    ``backtrace``
      ��CMake���Ի��ݵ�ָ����Ŀ���\ :command:`install`\ �������ʱ���ֵĿ�ѡ��Ա����ֵ��\
      ``backtraceGraph``\ ��Ա��\ ``nodes``\ �����л���0���޷�������������

``launchers``
  ��ѡ��Ա���ó�Ա������������һ������Ŀָ������������Ŀ�ִ��Ŀ���ϡ���ֵ��һ��JSON���飬\
  ������ָ����������Ӧ����Ŀ��ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

  ``command``
    һ���ַ�����ָ�����������������·��������б�ܱ�ʾ������ļ�λ�ڶ���ԴĿ¼�У���ָ�����\
    �ڸ�Ŀ¼��·����

  ``arguments``
    ��ѡ��Ա����������������Ҫ�����Ŀ�ִ���ļ�֮ǰ�в���ʱ���ó�Ա����֡���ֵ�Ǳ�ʾ������\
    �ַ�����JSON���顣

  ``type``
    ָ�������������͵��ַ�����ȡֵΪ��������һ�֣�

    ``emulator``
      �������ʱĿ��ƽ̨��ģ�������μ�\ :prop_tgt:`CROSSCOMPILING_EMULATOR`\ Ŀ�����ԡ�

    ``test``
      ����ִ�в��Ե��������������\ :prop_tgt:`TEST_LAUNCHER`\ Ŀ�����ԡ�

  ���ֶ��ڴ���ģ�Ͱ汾2.7����ӡ�

``link``
  ��ѡ��Ա���������ӵ�����ʱ�������ļ��Ŀ�ִ���ļ��͹����Ŀ�ꡣ��ֵ��һ��JSON�������Ա��\
  �����Ӳ��裺

  ``language``
    ָ�������������ԣ���\ ``C``��\ ``CXX``��\ ``Fortran``�����ַ������ڵ�����������

  ``commandFragments``
    ��ѡ��Ա����link�����е��õ�Ƭ�ο���ʱ���֡���ֵ��һ��JSON���飬����ָ������Ƭ�ε���Ŀ��\
    ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

    ``fragment``
      ָ��link�����е���Ƭ�ε��ַ�������ֵ�Թ���ϵͳ�ı���shell��ʽ���롣

    ``role``
      ָ��Ƭ�����ݽ�ɫ���ַ�����

      * ``flags``�����ӱ�־��
      * ``libraries``�� ���ӿ��ļ�·�����־��
      * ``libraryPath``�� ������·����־��
      * ``frameworkPath``�� macOS�������·����־��

  ``lto``
    ��ѡ��Ա������������ʱ���Ż���Ҳ��Ϊ���̼��Ż�������ʱ��������ɣ�ʱ���Բ���ֵ\ ``true``\
    ���֡�

  ``sysroot``
    ��ѡ��Ա���ڶ���\ :variable:`CMAKE_SYSROOT_LINK`\ ��\ :variable:`CMAKE_SYSROOT`\
    ����ʱ���֡���ֵ��һ��JSON����ֻ��һ����Ա��

    ``path``
      ָ����ϵͳ���ľ���·�����ַ���������б�ܱ�ʾ��

``archive``
  Ϊ��̬��Ŀ���ṩ�Ŀ�ѡ��Ա����ֵ��һ��JSON�������Ա�����浵���裺

  ``commandFragments``
    �浵���������е���Ƭ�ο���ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���飬����ָ��Ƭ�ε���Ŀ��ÿ��\
    ��Ŀ����һ��JSON���󣬰������³�Ա��

    ``fragment``
      ָ���鵵���������е���Ƭ�ε��ַ�������ֵ�Թ���ϵͳ�ı���shell��ʽ���롣

    ``role``
      ָ��Ƭ�����ݽ�ɫ���ַ�����

      * ``flags``���鵵����־��

  ``lto``
    ��ѡ��Ա������������ʱ���Ż���Ҳ��Ϊ���̼��Ż�������ʱ��������ɣ�ʱ���Բ���ֵ\ ``true``\
    ���֡�

``dependencies``
  ��Ŀ������������Ŀ��ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���飬�������������Ӧ����Ŀ��ÿ����Ŀ\
  ����һ��JSON���󣬰������³�Ա��

  ``id``
    Ψһ��ʶ��Ŀ����������Ŀ����ַ�����������һ��Ŀ�����\ ``id``\ ��Ա��ƥ�䡣

  ``backtrace``
    ��CMake���Ի��ݵ�\ :command:`add_dependencies`��\ :command:`target_link_libraries`\
    �������������������������ʱ���ÿ�ѡ��Ա���á���ֵ��\ ``backtraceGraph``\ ��Ա��\
    ``nodes``\ �����л���0���޷�������������

``fileSets``
  ��Ŀ���ļ������Ӧ����Ŀ��JSON���顣ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

  ``name``
    ָ���ļ������Ƶ��ַ�����

  ``type``
    ָ���ļ������͵��ַ����������\ :command:`target_sources`\ ֧�ֵ��ļ������͡�

  ``visibility``
    ָ���ļ����ɼ��Ե��ַ�����\ ``PUBLIC``��\ ``PRIVATE``\ ��\ ``INTERFACE``\ ����֮һ��

  ``baseDirectories``
    �ַ�����JSON���飬ÿ���ַ���ָ��һ�������ļ����е�Դ�Ļ���Ŀ¼�����Ŀ¼λ�ڶ���ԴĿ¼�У�\
    ��ָ������ڸ�Ŀ¼��·��������·���Ǿ��Եġ�

  ���ֶ��ڴ���ģ�Ͱ汾2.5����ӡ�

``sources``
  ��Ŀ��Դ�ļ���Ӧ����Ŀ��JSON���顣ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

  ``path``
    ָ��������Դ�ļ�·�����ַ���������б�ܱ�ʾ������ļ�λ�ڶ���ԴĿ¼�У���ָ������ڸ�Ŀ¼\
    ��·��������·���Ǿ��Եġ�

  ``compileGroupIndex``
    ����Դ����ʱ���ֵĿ�ѡ��Ա����ֵ��һ���޷�����������0��ʼ������\ ``compileGroups``\
    ���顣

  ``sourceGroupIndex``
    ��Դ��Դ���һ����ʱ��ͨ��\ :command:`source_group`\ �����Ĭ������³��ֵĿ�ѡ��Ա��\
    ȡֵΪ�޷�����������0��ʼ����\ ``sourceGroups``\ ���顣

  ``isGenerated``
    ��ѡ��Ա�����Դ��\ :prop_sf:`GENERATED`�����Բ���ֵ\ ``true``\ ���֡�

  ``fileSetIndex``
    ��Դ���ļ�����һ����ʱ���ֵĿ�ѡ��Ա����ֵ��һ���޷�����������0��ʼ������\ ``fileSets``\
    ���顣

    ���ֶ��ڴ���ģ�Ͱ汾2.5����ӡ�

  ``backtrace``
    ��ѡ��Ա����CMake���Ի��ݵ�\ :command:`target_sources`��\ :command:`add_executable`��\
    :command:`add_library`��\ :command:`add_custom_target`\ ����������Դ��ӵ�Ŀ��\
    ���������ʱ���ó�Ա���á���ֵ��\ ``backtraceGraph``\ ��Ա��\ ``nodes``\ �����л���\
    0���޷�������������

``sourceGroups``
  ��ѡ��Ա����ͨ��\ :command:`source_group`\ �����Ĭ������½�Դ������һ��ʱ���֡���ֵ\
  ��һ��JSON���飬���������Ӧ����Ŀ��ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

  ``name``
    ָ��Դ�����Ƶ��ַ�����

  ``sourceIndexes``
    һ��JSON���飬�г����ڸ����Դ��ÿ����Ŀ����Ŀ����\ ``sources``\ �����л���0���޷���\
    ����������

``compileGroups``
  ��Ŀ����пɱ����Դʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���飬��Ŀ��Ӧ������ʹ����ͬ���ñ����\
  Դ�顣ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

  ``sourceIndexes``
    һ��JSON���飬�г����ڸ����Դ��ÿ����Ŀ����Ŀ����\ ``sources``\ �����л���0���޷���\
    ����������

  ``language``
    ָ�������������ԣ�����\ ``C``��\ ``CXX``��\ ``Fortran``�����ַ������ڱ���Դ�ļ���

  ``languageStandard``
    ��ѡ��Ա������ʽ�������Ա�׼������ͨ��\ :prop_tgt:`CXX_STANDARD`����ͨ������������ʽ\
    �������Ա�׼ʱ���֡�ÿ����Ŀ��һ��JSON���󣬰���������Ա��

    ``backtraces``
      ��CMake���Ի��ݵ�\ ``<LANG>_STANDARD``\ ���ÿ���ʱ���ֵĿ�ѡ��Ա��������Ա�׼��\
      �ɱ��빦����ʽ���õģ�����Щ�����������ݡ�����������Կ�����Ҫ��ͬ�����Ա�׼����˿���\
      ���ڶ�����ݡ���ֵ��һ��JSON���飬ÿ����Ŀ����\ ``backtraceGraph``\ ��Ա\ ``nodes``\
      �����л���0���޷�������������

    ``standard``
      ��ʾ���Ա�׼���ַ�����

    ���ֶ��ڴ���ģ��2.2������ӡ�

  ``compileCommandFragments``
    ��ѡ��Ա���������������е��õ�Ƭ�ο���ʱ���֡���ֵ��һ��JSON���飬����ָ������Ƭ�ε���Ŀ��\
    ÿ����Ŀ��һ��JSON���󣬰���һ����Ա��

    ``fragment``
      ָ�����������е���Ƭ�ε��ַ�������ֵ�Թ���ϵͳ�ı���shell��ʽ���롣

  ``includes``
    ���ڰ���Ŀ¼ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���飬ÿ��Ŀ¼����һ����Ŀ��ÿ����Ŀ����һ��\
    JSON���󣬰������³�Ա��

    ``path``
      ָ������Ŀ¼·�����ַ���������б�ܱ�ʾ��

    ``isSystem``
      ��ѡ��Ա���������Ŀ¼�����Ϊϵͳ����Ŀ¼�����Բ���ֵ\ ``true``\ ���֡�

    ``backtrace``
      ��ѡ��Ա����CMake���Ի��ݵ�\ :command:`target_include_directories`\ ���������\
      �˰���Ŀ¼���������ʱ���ó�Ա���á���ֵ��\ ``backtraceGraph``\ ��Ա��\ ``nodes``\
      �����л���0���޷�������������

  ``frameworks``
    ��ѡ��Ա������Appleƽ̨���п��ʱ���ڡ���ֵ��һ��JSON���飬ÿ��Ŀ¼����һ����Ŀ��ÿ����\
    Ŀ����һ��JSON���󣬰������³�Ա��

    ``path``
      ָ�����Ŀ¼·�����ַ���������б�ܱ�ʾ��

    ``isSystem``
      ��ѡ��Ա�������ܱ����Ϊϵͳ��ܣ���ó�Ա�Ĳ���ֵΪ\ ``true``��

    ``backtrace``
      ��ѡ��Ա����CMake���Ի��ݵ�\ :command:`target_link_libraries`\ ��������Ӵ˿��\
      ���������ʱ���ڡ���ֵ��\ ``backtraceGraph``\ ��Ա��\ ``nodes``\ �����л���0����\
      ��������������

    ���ֶ��ڴ���ģ��2.6������ӡ�

  ``precompileHeaders``
    ��\ :command:`target_precompile_headers`\ ���������������Ŀ��������\
    :prop_tgt:`PRECOMPILE_HEADERS`\ ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���飬ÿ����ͷ����\
    һ����Ŀ��ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

    ``header``
      Ԥ����ͷ�ļ�������·����

    ``backtrace``
      ��ѡ��Ա����CMake���Ի��ݵ�\ :command:`target_precompile_headers`\ ���������\
      ��Ԥ����ͷ���������ʱ���ڡ���ֵ��\ ``backtraceGraph``\ ��Ա��\ ``nodes``\ ����\
      �л���0���޷�������������

    ���ֶ��ڴ���ģ�Ͱ汾2.1����ӡ�

  ``defines``
    ����Ԥ����������ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON���飬ÿ�����嶼��һ����Ŀ��ÿ����Ŀ����\
    һ��JSON���󣬰������³�Ա��

    ``define``
      ָ��Ԥ������������ַ�������ʽΪ\ ``<name>[=<value>]``������\ ``DEF``\ ��\
      ``DEF=1``��

    ``backtrace``
      ��ѡ��Ա����CMake���Ի��ݵ�\ :command:`target_compile_definitions`\ ���������\
      ��Ԥ������������������ʱ���ó�Ա���á���ֵ��\ ``backtraceGraph``\ ��Ա��\
      ``nodes``\ �����л���0���޷�������������

  ``sysroot``
    ����\ :variable:`CMAKE_SYSROOT_COMPILE`\ ��\ :variable:`CMAKE_SYSROOT`\ ����\
    ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON����ֻ��һ����Ա��

    ``path``
      ָ����ϵͳ���ľ���·�����ַ���������б�ܱ�ʾ��

``backtraceGraph``
  һ��\ `��codemodel���汾2��backtrace graph������`_����ڵ�������Ŀ�ꡱ�����������ط���\
  ``backtrace``\ ��Ա���á�

��codemodel���汾2��backtrace graph������
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`��codemodel���汾2��directory������`_\ ��\ `��codemodel���汾2��target������`_\ ��\
``backtraceGraph``\ ��Ա��һ����������ͼ��JSON�������Ľڵ��ǴӰ�������������ط���\
``backtrace``\ ��Ա���õġ�����ͼ����ĳ�Ա�У�

``nodes``
  һ��JSON���飬�г�����ͼ�еĽڵ㡣ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

  ``file``
    ����\ ``files``\ �����л���0���޷�������������

  ``line``
    ���ڵ��ʾ�ļ��е�һ��ʱ���ֵĿ�ѡ��Ա���޷���������ʽ���кŴ�1��ʼ��

  ``command``
    ���ڵ��ʾ�ļ��е��������ʱ���ֵĿ�ѡ��Ա����ֵ��һ���޷����������ڻ���\ ``commands``\
    ��������0Ϊ������������

  ``parent``
    ���ڵ㲻�ǵ��ö�ջ�ĵײ�ʱ���ֵĿ�ѡ��Ա����ֵ�ǻ���\ ``nodes``\ ��������һ��Ļ���0��\
    �޷�������������

``commands``
  һ��JSON���飬�г����ݽڵ����õ���������ÿ����Ŀ����ָ���������Ƶ��ַ�����

``files``
  һ��JSON���飬�г��˻��ݽڵ����õ�CMake�����ļ���ÿ����Ŀ����һ���ַ�����ָ���ļ���·����\
  ����б�ܱ�ʾ������ļ�λ�ڶ���ԴĿ¼�У���ָ������ڸ�Ŀ¼��·��������Ϊ����·����

.. _`file-api configureLog`:

��configureLog����������
--------------------------

``configureLog``\ ��������������\ :manual:`cmake-configure-log(7)`\ �ļ���λ�ú����ݡ�

ֻ��һ��\ ``configureLog``\ �������Ҫ�汾�����汾1��

��configureLog���汾1
^^^^^^^^^^^^^^^^^^^^^^^^

``configureLog``\ ����汾1��һ��JSON����

.. code-block:: json

  {
    "kind": "configureLog",
    "version": { "major": 1, "minor": 0 },
    "path": "/path/to/top-level-build-dir/CMakeFiles/CMakeConfigureLog.yaml",
    "eventKindNames": [ "try_compile-v1", "try_run-v1" ]
  }

�ض���\ ``configureLog``\ ����ĳ�Ա�ǣ�

``path``
  ָ��������־�ļ�·�����ַ������ͻ��˱���Ӹ�·����ȡ��־�ļ�����·��������\
  :manual:`cmake-configure-log(7)`\ ��¼��·����ͬ�����û�м�¼�¼�����־�ļ����ܲ����ڡ�

``eventKindNames``
  һ��JSON���飬��ÿ����Ŀ����һ��JSON�ַ���������\ :manual:`cmake-configure-log(7)`\
  �汾�¼�����֮һ��ÿ��������־�¼��������ֻ�г�һ���汾����Ȼ������־���ܰ����������汾��\
  �Ƶģ��¼����ͣ����ͻ��˱������δ�ڴ��ֶ����г����¼����͡�

��cache����������
-------------------

``cache``\ ���������г��˻������Щ�Ǵ洢�ڹ������ĳ־û��棨\ ``CMakeCache.txt``\ ��\
�е�\ :ref:`CMake Language Variables`��

ֻ��һ��\ ``cache``\ �������汾�����汾2���汾1��������Ϊ�˱�����\ :manual:`cmake-server(7)`\
ģʽ�İ汾������

��cache���汾2
^^^^^^^^^^^^^^^^^

``cache``\ ����汾2��һ��JSON����

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

�ض���\ ``cache``\ ����ĳ�Ա�У�

``entries``
  һ��JSON���飬��ÿ����Ŀ����ָ��������Ŀ��JSON����ÿ������ĳ�Ա�ǣ�

  ``name``
    ָ����Ŀ���Ƶ��ַ�����

  ``value``
    ָ����Ŀֵ���ַ�����

  ``type``
    һ���ַ�����ָ��\ :manual:`cmake-gui(1)`\ ����ѡ��Ҫ�༭��С��������Ŀ���͡�

  ``properties``
    ָ������\ :ref:`���������� <Cache Entry Properties>`\ ����Ŀ��JSON���顣ÿ����Ŀ��\
    һ��JSON���󣬰������³�Ա��

    ``name``
      ָ���������������Ƶ��ַ�����

    ``value``
      ָ������������ֵ���ַ�����

��cmakeFiles����������
------------------------

``cmakeFiles``\ ���������г���CMake�����ú����ɹ���ϵͳʱʹ�õ��ļ�����Щ�ļ�����\
``CMakeLists.txt``\ �ļ��Լ�������\ ``.cmake``\ �ļ���

ֻ��һ��\ ``cmakeFiles``\ �������Ҫ�汾�����汾1��

��cmakeFiles���汾1
^^^^^^^^^^^^^^^^^^^^^^

``cmakeFiles``\ ����汾1��һ��JSON����

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

�ض���\ ``cmakeFiles``\ ����ĳ�Ա�У�

``paths``
  �������³�Ա��JSON����

  ``source``
    ָ������ԴĿ¼�ľ���·�����ַ���������б�ܱ�ʾ��

  ``build``
    ָ�����㹹��Ŀ¼�ľ���·�����ַ���������б�ܱ�ʾ��

``inputs``
  һ��JSON���飬��ÿ����Ŀ����һ��JSON����ָ��CMake�����ú����ɹ���ϵͳʱʹ�õ������ļ���
  ÿ������ĳ�Ա�ǣ�

  ``path``
    ָ��CMake�����ļ�·�����ַ���������б�ܱ�ʾ������ļ�λ�ڶ���ԴĿ¼�У���ָ������ڸ�Ŀ\
    ¼��·��������·���Ǿ��Եġ�

  ``isGenerated``
    ��ѡ��Ա�����·��ָ����λ�ڶ��㹹��Ŀ¼�µ��ļ����ҹ�����Դ��ģ���ó�Ա�Բ���ֵ\
    ``true``\ ���֡��˳�Ա��Դ�ڹ����в����á�

  ``isExternal``
    ��ѡ��Ա�����·��ָ�����ļ����ڶ���ԴĿ¼�򹹽�Ŀ¼�£����Բ���ֵ\ ``true``\ ���֡�

  ``isCMake``
    ��ѡ��Ա�����·��ָ����CMake��װ�е��ļ������Բ���ֵ\ ``true``\ ���֡�

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

��toolchains����������
------------------------

``toolchains``\ ���������г��˹���������ʹ�õĹ����������ԡ���Щ�������ԡ�������·����ID��\
�汾��

ֻ��һ��\ ``toolchains``\ �������汾�����汾1��

��toolchains���汾1
^^^^^^^^^^^^^^^^^^^^^^

``toolchains``\ ����汾1��һ��JSON����

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

�ض���\ ``toolchains``\ ����ĳ�Ա�ǣ�

``toolchains``
  һ��JSON���飬��ÿ����Ŀ����һ��JSON����ָ�����ض����Թ����Ĺ�������ÿ������ĳ�Ա�ǣ�

  ``language``
    ָ�����������Ե�JSON�ַ�������C��CXX��������������Դ��ݸ�\ :command:`project`\ ��\
    �������������ͬ����ΪCMake��ÿ������ֻ֧��һ������������������ֶο�����������

  ``compiler``
    �������³�Ա��JSON����

    ``path``
      Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_COMPILER`\ ����ʱ���ֵĿ�ѡ��Ա������ֵ\
      ��һ��JSON�ַ�����������������·����

    ``id``
      Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_COMPILER_ID`\ ����ʱ���ֵĿ�ѡ��Ա����\
      ��ֵ��һ��JSON�ַ�����������������ID ��GNU, MSVC�ȣ���

    ``version``
      Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ ����ʱ���ֵĿ�ѡ��\
      Ա������ֵ��һ��JSON�ַ����������������İ汾��

    ``target``
      Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_COMPILER_TARGET`\ ����ʱ���ֵĿ�ѡ��Ա��\
      ����ֵ��һ��JSON�ַ����������������Ľ������Ŀ�ꡣ

    ``implicit``
      �������³�Ա��JSON����

      ``includeDirectories``
        Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_IMPLICIT_INCLUDE_DIRECTORIES`\
        ����ʱ���ֵĿ�ѡ��Ա������ֵ��һ��JSON�ַ������飬����ÿ���ַ���������������ʽ\
        includeĿ¼��·����

      ``linkDirectories``
        Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_IMPLICIT_LINK_DIRECTORIES`\ ����ʱ\
        ���ֵĿ�ѡ��Ա������ֵ��һ����JSON�ַ�����ɵ�JSON���飬����ÿ���ַ���������һ��ָ\
        �����������ʽ����Ŀ¼��·����

      ``linkFrameworkDirectories``
        ��Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES`\
        ����ʱ���ֵĿ�ѡ��Ա������ֵ��һ����JSON�ַ�����ɵ�JSON���飬����ÿ���ַ���������\
        һ��ָ�����������ʽ���ӿ��Ŀ¼��·����

      ``linkLibraries``
        Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_IMPLICIT_LINK_LIBRARIES`\ ����ʱ��\
        �ֵĿ�ѡ��Ա������ֵ��һ��JSON�ַ������飬����ÿ���ַ���������һ��ָ���������ʽ��\
        �ӿ��·����

  ``sourceFileExtensions``
    Ϊ��ǰ���Զ���\ :variable:`CMAKE_<LANG>_SOURCE_FILE_EXTENSIONS`\ ����ʱ���ֵĿ�\
    ѡ��Ա������ֵ��һ��JSON�ַ������飬����ÿ���ַ��������������Ե��ļ���չ����û��ǰ��ĵ㣩��
