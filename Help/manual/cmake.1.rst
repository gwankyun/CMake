.. cmake-manual-description: CMake Command-Line Reference

cmake(1)
********

��Ҫ
========

.. parsed-literal::

 `����һ����Ŀ����ϵͳ`_
  cmake [<options>] -B <path-to-build> [-S <path-to-source>]
  cmake [<options>] <path-to-source | path-to-existing-build>

 `����һ����Ŀ`_
  cmake --build <dir> [<options>] [-- <build-tool-options>]

 `��װһ����Ŀ`_
  cmake --install <dir> [<options>]

 `��һ����Ŀ`_
  cmake --open <dir>

 `���нű�`_
  cmake [-D <var>=<value>]... -P <cmake-script-file>

 `���������й���`_
  cmake -E <command> [<options>]

 `���а����ҹ���`_
  cmake --find-package [<options>]

 `���й�����Ԥ��`_
  cmake --workflow [<options>]

 `�鿴����`_
  cmake --help[-<topic>]

����
===========

:program:`cmake`\ ��ִ���ļ��ǿ�ƽ̨����ϵͳ������CMake�������н��档����\ `��Ҫ`_\ �г�\
�˹��߿���ִ�еĸ��ֲ�����������Ĳ���������

Ҫ��CMake����һ�������Ŀ����\ `����һ����Ŀ����ϵͳ`_������ѡ��ʹ��\ :program:`cmake`\ ��\
`����һ����Ŀ`_\ ��\ `��װһ����Ŀ`_������ֱ��������Ӧ�Ĺ������ߣ�����\ ``make``����\
:program:`cmake`\ Ҳ��������\ `�鿴����`_��

����������Ϊ�������������Աʹ��\ :manual:`CMake language <cmake-language(7)>`\ ��д\
�ű���֧�����ǵĹ�����

�й�\ :program:`cmake`\ ��ͼ���û���������������\ :manual:`ccmake <ccmake(1)>`\ ��\
:manual:`cmake-gui <cmake-gui(1)>`���й�CMake���Ժʹ�����ߵ������нӿڣ���ο�\
:manual:`ctest <ctest(1)>`\ ��\ :manual:`cpack <cpack(1)>`��

�й�CMake����ϸ��Ϣ����\ `���в���`_\ ���ֲ�ĩβ�����ӡ�


����CMake����ϵͳ
==================================

*����ϵͳ*\ ���������ʹ��\ *��������*\ ����Դ�����й�����Ŀ�Ŀ�ִ���ļ��Ϳ���Զ������̡�\
���磬����ϵͳ������һ��\ ``Makefile``\ �ļ�������������\ ``make``\ ���߻����ڼ��ɿ�����\
����IDE������Ŀ�ļ���Ϊ�˱���ά����������Ĺ���ϵͳ����Ŀ����ʹ��\
:manual:`CMake���� <cmake-language(7)>`\ ��д���ļ������ָ�����Ĺ���ϵͳ������Щ�ļ��У�\
CMakeͨ��һ����Ϊ\ *������*\ �ĺ��Ϊÿ���û��ڱ�������һ����ѡ�Ĺ���ϵͳ��

Ҫ��CMake����һ������ϵͳ��������������ѡ�

Դ������
  ��������Ŀ�ṩ��Դ�ļ��Ķ���Ŀ¼������Ŀʹ��\ :manual:`cmake-language(7)`\ �ֲ�������\
  ���ļ�ָ���乹��ϵͳ���Ӷ����ļ�\ ``CMakeLists.txt``\ ��ʼ����Щ�ļ�ָ����\
  :manual:`cmake-buildsystem(7)`\ �ֲ��������Ĺ���Ŀ�꼰��������ϵ��

������
  ���ڴ洢����ϵͳ�ļ��͹�����������������ִ���ļ��Ϳ⣩�Ķ���Ŀ¼��CMake����дһ��\
  ``CMakeCache.txt``\ �ļ�������Ŀ¼��ʶΪ�����������洢�־���Ϣ���繹��ϵͳ����ѡ�

  Ҫά��ԭʼ��Դ����������ʹ�õ�����ר�ù�����ִ��\ *Դ������*\ ������Ҳ֧�ֽ���������������\
  Դ��������ͬ��Ŀ¼�е�\ *Դ������*\ ����������������������

������
  �⽫ѡ��Ҫ���ɵĹ���ϵͳ�����͡������\ :manual:`cmake-generators(7)`\ �ֲ��ȡ������\
  �������ĵ�������\ :option:`cmake --help`\ �鿴���ؿ��õ��������б�����ѡ��ʹ�������\
  :option:`-G <cmake -G>`\ ѡ����ָ��һ�������������߼򵥵ؽ���CMakeΪ��ǰƽ̨ѡ���Ĭ��\
  ��������

  ��ʹ��\ :ref:`Command-Line Build Tool Generators`\ ʱ��CMake��������������������Ҫ\
  �Ļ����Ѿ���shell�����ú��ˡ���ʹ��\ :ref:`IDE Build Tool Generators`\ ʱ������Ҫ��\
  ���Ļ�����

.. _`Generate a Project Buildsystem`:

����һ����Ŀ����ϵͳ
==============================

ʹ����������ǩ��֮һ����CMake��ָ��Դ�͹�������������һ������ϵͳ��

``cmake [<options>] -B <path-to-build> [-S <path-to-source>]``

  .. versionadded:: 3.13

  ʹ��\ ``<path-to-build>``\ ��Ϊ����������ʹ��\ ``<path-to-source>``\ ��ΪԴ������ָ\
  ����·�������Ǿ��Եģ�Ҳ����������ڵ�ǰ����Ŀ¼�ġ�Դ����������һ��\ ``CMakeLists.txt``\
  �ļ�������������������ڣ����Զ������������磺

  .. code-block:: console

    $ cmake -S src -B build

``cmake [<options>] <path-to-source>``
  ʹ�õ�ǰ����Ŀ¼��Ϊ����������ʹ��\ ``<path-to-source>``\ ��ΪԴ����ָ����·�������Ǿ�\
  ��·����Ҳ����������ڵ�ǰ����Ŀ¼��·����Դ���������\ ``CMakeLists.txt``\ �ļ�����\
  *����*\ ����\ ``CMakeCache.txt``\ �ļ�����Ϊ���߱�ʶ��һ�����еĹ����������磺

  .. code-block:: console

    $ mkdir build ; cd build
    $ cmake ../src

``cmake [<options>] <path-to-existing-build>``
  ʹ��\ ``<path-to-existing-build>``\ ��Ϊ��������������\ ``CMakeCache.txt``\ �ļ���\
  �ص�Դ����·�������ļ�������֮ǰ����CMakeʱ���ɵġ�ָ����·�������Ǿ���·����Ҳ�����������\
  ��ǰ����Ŀ¼��·�������磺

  .. code-block:: console

    $ cd build
    $ cmake .

����������£�\ ``<options>``\ ������������������\ `ѡ��`_��

��������ָ��Դ���͹���������ʽ���Ի��ʹ�á���\ :option:`-S <cmake -S>`\ ��\
:option:`-B <cmake -B>`\ ָ����·�����Ƿֱ����ΪԴ���򹹽�����ʹ����ͨ����ָ����·������\
�����ݺ�ǰ�������·�����ͽ��з��ࡣ���ֻ����һ�����͵�·������ʹ�õ�ǰ����Ŀ¼��cwd����Ϊ��\
һ�����͵�·�������磺

============================== ============ ===========
 ������                          ԴĿ¼        ����Ŀ¼
============================== ============ ===========
 ``cmake -B build``             `cwd`        ``build``
 ``cmake -B build src``         ``src``      ``build``
 ``cmake -B build -S src``      ``src``      ``build``
 ``cmake src``                  ``src``      `cwd`
 ``cmake build`` (existing)     `loaded`     ``build``
 ``cmake -S src``               ``src``      `cwd`
 ``cmake -S src build``         ``src``      ``build``
 ``cmake -S src -B build``      ``src``      ``build``
============================== ============ ===========

.. versionchanged:: 3.23

  CMake��ָ�����Դ·��ʱ�������档�����û����ʽ���ĵ���֧�֣����Ͼɵİ汾������ؽ��ܶ��\
  Դ·������ʹ�����ָ����·�������⴫�ݶ��Դ·��������

�����ɹ���ϵͳ֮�󣬿���ʹ����Ӧ�ı��ع���������������Ŀ�����磬��ʹ��\
:generator:`Unix Makefiles`\ �������󣬿���ֱ������\ ``make``��

  .. code-block:: console

    $ make
    $ make install

���ߣ�����ʹ��\ :program:`cmake`\ ͨ���Զ�ѡ��͵����ʵ��ı��ع���������\ `����һ����Ŀ`_��

.. _`CMake Options`:

ѡ��
-------

.. program:: cmake

.. include:: OPTIONS_BUILD.txt

.. option:: --fresh

 .. versionadded:: 3.24

 ִ�й������������á��⽫ɾ���κ����е�\ ``CMakeCache.txt``\ �ļ�����ص�\ ``CMakeFiles/``\
 Ŀ¼������ͷ��ʼ���´������ǡ�

 .. versionchanged:: 3.30

   For dependencies previously populated by :module:`FetchContent` with the
   ``NEW`` setting for policy :policy:`CMP0168`, their stamp and script files
   from any previous run will be removed. The download, update, and patch
   steps will therefore be forced to re-execute.

.. option:: -L[A][H]

 �г��Ǹ߼����������

 �б�\ ``CACHE``\ ����������CMake���г�CMake ``CACHE``\ ��δ���Ϊ\ ``INTERNAL``\ ��\
 :prop_cache:`ADVANCED`\ �����б������⽫��Ч����ʾ��ǰ��CMake���ã�Ȼ�����ʹ��\
 :option:`-D <cmake -D>`\ ѡ����и��ġ�����һЩ�������ܻᵼ�´���������������ָ����\
 ``A``����ô��Ҳ����ʾ�߼����������ָ����\ ``H``����������ʾÿ�������İ�����

.. option:: -N

 ��֧�ֲ鿴ģʽ��

 ֻ���ػ��档��ʵ���������ú����ɲ��衣

.. option:: --graphviz=<file>

 ����������graphviz���μ�\ :module:`CMakeGraphVizOptions`\ ��ȡ������Ϣ��

 ����һ��graphviz�����ļ������ļ���������Ŀ�е����п�Ϳ�ִ�����������ϸ�������\
 :module:`CMakeGraphVizOptions`\ �ĵ���

.. option:: --system-information [file]

 ת��ϵͳ��Ϣ��

 ת�����ڵ�ǰϵͳ�ĸ�����Ϣ�������һ��CMake��Ŀ�Ķ�����Ŀ¼�������У�����ת���������Ϣ��\
 �绺�桢��־�ļ��ȡ�

.. option:: --log-level=<level>

 ������־\ ``<level>``��

 :command:`message`\ ����ֻ���ָ����־�������߼������Ϣ����Ч����־�������\
 ``ERROR``��\ ``WARNING``��\ ``NOTICE``��\ ``STATUS``\ ��Ĭ�ϣ���\ ``VERBOSE``��\
 ``DEBUG``\ ��\ ``TRACE``��

 Ҫ��CMake����֮�䱣����־���𣬿��Խ�\ :variable:`CMAKE_MESSAGE_LOG_LEVEL`\ ����Ϊ��\
 ����������ͬʱ������������ѡ��ͱ�������������ѡ�����ȡ�

 ���������ݵ�ԭ��\ ``--loglevel``\ Ҳ������Ϊ��ѡ���ͬ��ʡ�

 .. versionadded:: 3.25
   �й�\ :ref:`��ѯ��ǰ��Ϣ��¼���� <query_message_log_level>`\ �ķ����������\
   :command:`cmake_language`\ ���

.. option:: --log-context

 ���ø��ӵ�ÿ����Ϣ��\ :command:`message`\ ������������ġ�

 ���ѡ��򿪽���ʾ��ǰCMake���е������ġ�Ϊ�������к�����CMake���ж�������ʾ�����ģ����Խ�\
 :variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ ����Ϊ������������������������ѡ��ʱ��\
 :variable:`CMAKE_MESSAGE_CONTEXT_SHOW`\ �������ԡ�

.. option:: --debug-trycompile

 ��Ҫɾ��Ϊ\ :command:`try_compile`\ /\ :command:`try_run`\ ���ô������ļ���Ŀ¼��\
 ���ڵ���ʧ�ܵļ��ʱ�����á�

 ע�⣬:command:`try_compile`\ ��ĳЩ�÷�����ʹ����ͬ�Ĺ����������һ����Ŀִ�ж��\
 :command:`try_compile`���⽫���Ƹ�ѡ��������ԡ����磬������ʹ�ÿ��ܻ�ı�������Ϊ����\
 ��ǰ���Ա���Ĺ������ܻᵼ�²�ͬ�Ĳ��Դ����ͨ����ʧ�ܡ���ѡ����ý��ڵ���ʱʹ�á�

 ����ǰ���������ȣ�:command:`try_run`\ ����ʵ������\ :command:`try_compile`\ ���\
 ���ߵ��κ���϶��ܵ���������Ǳ�������Ӱ�졣��

 .. versionadded:: 3.25

   ���ô�ѡ���ÿ�γ��Ա����鶼���ӡһ����־��Ϣ������ִ�м���Ŀ¼��

.. option:: --debug-output

 ��cmake���ڵ���ģʽ��

 ��cmake�����ڼ��ӡ�������Ϣ������ʹ��\ :command:`message(SEND_ERROR)`\ ���ý��ж�ջ����һ����

.. option:: --debug-find

 .. versionadded:: 3.17

 ��cmake find�������ڵ���ģʽ��

 ��cmake���е���׼����ʱ��ӡ�����find������Ϣ�������Ϊ����ʹ�ö�����Ϊ��������Ƶġ��������\
 :variable:`CMAKE_FIND_DEBUG_MODE`\ �������Ե�����Ŀ�и��ֲ��Ĳ��֡�

.. option:: --debug-find-pkg=<pkg>[,...]

 .. versionadded:: 3.23

 �ڵ���\ :command:`find_package(\<pkg\>) <find_package>`\ ʱ����cmake find��������\
 ����ģʽ������\ ``<pkg>``\ �Ǹ������ŷָ������ִ�Сд�İ����б��е�һ����Ŀ��

 ������\ :option:`--debug-find <cmake --debug-find>`����������������Ϊָ���İ���

.. option:: --debug-find-var=<var>[,...]

 .. versionadded:: 3.23

 ʹ��\ ``<var>``\ ��cmake find�������ڵ���ģʽ����Ϊ�������������\ ``<var>``\ �Ǹ���\
 ���ŷָ��б��е���Ŀ��

 ������\ :option:`--debug-find <cmake --debug-find>`����������������Ϊָ���ı�������

.. option:: --trace

 ��cmake���ڸ���ģʽ��

 ��ӡ���к��еĹ켣�͵��õ���Դ��

.. option:: --trace-expand

 ��cmake���ڸ���ģʽ��

 ������\ :option:`--trace <cmake --trace>`�����Ǳ���չ���ˡ�

.. option:: --trace-format=<format>

 .. versionadded:: 3.17

 ��cmake���ڸ���ģʽ�����ø��������ʽ��

 ``<format>``\ ����������ֵ֮һ��

   ``human``
     ������ɶ��ĸ�ʽ��ӡÿ�������С�����Ĭ�ϸ�ʽ��

   ``json-v1``
     ��ÿһ�д�ӡΪһ��������JSON�ĵ���ÿ���ĵ��ɻ��з���``\n``���ָ������Ա�֤JSON�ĵ��в�����ֻ��з���

     .. code-block:: json
       :caption: JSON trace format

       {
         "file": "/full/path/to/the/CMake/file.txt",
         "line": 0,
         "cmd": "add_executable",
         "args": ["foo", "bar"],
         "time": 1579512535.9687231,
         "frame": 2,
         "global_frame": 4
       }

     ��Ա�У�

     ``file``
       ���ú�����CMakeԴ�ļ�������·����

     ``line``
       ``file``\ �к������ÿ�ʼ���С�

     ``line_end``
       ����������ÿ�Խ���У�����ֶν�����Ϊ�������ý������С�����������ÿ�Խ���У������\
       �ν���ȡ�����á����ֶ�����\ ``json-v1``\ ��ʽ�Ĵ�Ҫ�汾2����ӵġ�

     ``defer``
       ���������ñ�\ :command:`cmake_language(DEFER)`\ �ӳ�ʱ���ֵĿ�ѡ��Ա��������ڣ�\
       ����ֵ��һ�������ӳٵ���\ ``<id>``\ ���ַ�����

     ``cmd``
       �����õĺ��������ơ�

     ``args``
       �������к����������ַ����б�

     ``time``
       �������õ�ʱ�������epoch��������������

     ``frame``
       �ڵ�ǰ���ڴ����\ ``CMakeLists.txt``\ ���������У������ú����Ķ�ջ֡��ȡ�

     ``global_frame``
       �����ú����Ķ�ջ֡��ȣ��ڸ����漰������\ ``CMakeLists.txt``\ �ļ���ȫ�ָ��١���\
       �ֶ�����\ ``json-v1``\ ��ʽ�Ĵ�Ҫ�汾2����ӵġ�

     ���⣬����ĵ�һ��JSON�ĵ�������ǰ��Ҫ�ʹ�Ҫ�汾��\ ``version``\ ��

     .. code-block:: json
       :caption: JSON version format

       {
         "version": {
           "major": 1,
           "minor": 2
         }
       }

     ��Ա�У�

     ``version``
       JSON��ʽ�İ汾���ð汾������ѭ����汾Լ������Ҫ�ʹ�Ҫ�����

.. option:: --trace-source=<file>

 ��cmake���ڸ���ģʽ����ֻ���ָ���ļ����С�

 ������ѡ�

.. option:: --trace-redirect=<file>

 ��cmake���ڸ���ģʽ��������������ض����ļ�������stderr��

.. option:: --warn-uninitialized

 ����δ��ʼ����ֵ��

 ��ʹ��δ��ʼ���ı���ʱ��ӡ���档

.. option:: --warn-unused-vars

 ʲôҲ��������CMake 3.2�����°汾�У��˹��������˹���δʹ�ñ����ľ��档��CMake 3.3��\
 3.18�汾�У����ѡ��ƻ��ˡ���CMake 3.19�����ϰ汾�У���ѡ���ѱ�ɾ����

.. option:: --no-warn-unused-cli

 ��Ҫ��������ѡ������档

 ��Ҫ��������������������û��ʹ�õı�����

.. option:: --check-system-vars

 ��ϵͳ�ļ��в��ұ���ʹ�õ����⡣

 ͨ����δʹ�ú�δ��ʼ���ı���ֻ��\ :variable:`CMAKE_SOURCE_DIR`\
 ��\ :variable:`CMAKE_BINARY_DIR`\ �������������־����CMake�������ļ�Ҳ�������档

.. option:: --compile-no-warning-as-error

 .. versionadded:: 3.24

 ����Ŀ������\ :prop_tgt:`COMPILE_WARNING_AS_ERROR`\ �ͱ���\
 :variable:`CMAKE_COMPILE_WARNING_AS_ERROR`����ֹ�����ڱ���ʱ����Ϊ����

.. option:: --profiling-output=<path>

 .. versionadded:: 3.18

 ��\ :option:`--profiling-format <cmake --profiling-format>`\ һ��ʹ�ã����������\
 ��·����

.. option:: --profiling-format=<file>

 ����CMake�ű��Ը�����ʽ����������ݡ�

 ��������ִ��CMake�ű������ܷ�����Ӧ��ʹ�õ�����Ӧ�ó���������������ɶ��ĸ�ʽ��

 Ŀǰ֧�ֵ�ֵ�ǣ�\ ``google-trace``\ ����ȸ�Trace��ʽ������ͨ���ȸ�Chrome��\
 about:tracing\ ѡ���ʹ��Trace Compass�ȹ��ߵĲ�����н�����

.. option:: --preset <preset>, --preset=<preset>

 Reads a :manual:`preset <cmake-presets(7)>` from ``CMakePresets.json`` and
 ``CMakeUserPresets.json`` files, which must be located in the same directory
 as the top level ``CMakeLists.txt`` file. The preset may specify the
 generator, the build directory, a list of variables, and other arguments to
 pass to CMake. At least one of ``CMakePresets.json`` or
 ``CMakeUserPresets.json`` must be present.
 The :manual:`CMake GUI <cmake-gui(1)>` also recognizes and supports
 ``CMakePresets.json`` and ``CMakeUserPresets.json`` files. For full details
 on these files, see :manual:`cmake-presets(7)`.

 The presets are read before all other command line options, although the
 :option:`-S <cmake -S>` option can be used to specify the source directory
 containing the ``CMakePresets.json`` and ``CMakeUserPresets.json`` files.
 If :option:`-S <cmake -S>` is not given, the current directory is assumed to
 be the top level source directory and must contain the presets files. The
 options specified by the chosen preset (variables, generator, etc.) can all
 be overridden by manually specifying them on the command line. For example,
 if the preset sets a variable called ``MYVAR`` to ``1``, but the user sets
 it to ``2`` with a ``-D`` argument, the value ``2`` is preferred.

.. option:: --list-presets[=<type>]

 �г�ָ��\ ``<type>``\ �Ŀ���Ԥ�衣\ ``<type>``\ ����Чֵ��\ ``configure``��\
 ``build``��\ ``test``��\ ``package``\ ��\ ``all``�����ʡ��\ ``<type>``����ٶ�Ϊ\
 ``configure``��The current working
 directory must contain CMake preset files unless the :option:`-S <cmake -S>`
 option is used to specify a different top level source directory.

.. option:: --debugger

  ����CMake���ԵĽ���ʽ���ԡ�CMake����Ϊ\ :option:`--debugger-pipe <cmake --debugger-pipe>`\
  �Ĺܵ��Ϲ�����һ�����Խӿڣ��ýӿڷ���\ `Debug Adapter Protocol`_\ �淶���������������޸ġ�

  ``initialize``\ ��Ӧ����һ����Ϊ\ ``cmakeVersion``\ �ĸ����ֶΣ����ֶ�ָ�����ڵ��Ե�\
  CMake�汾��

  .. code-block:: json
    :caption: Debugger initialize response

    {
      "cmakeVersion": {
        "major": 3,
        "minor": 27,
        "patch": 0,
        "full": "3.27.0"
      }
    }

  ��Ա������

  ``major``
    ָ�����汾�ŵ�������

  ``minor``
    ָ����Ҫ�汾�ŵ�������

  ``patch``
    ָ�������汾�ŵ�������

  ``full``
    ָ������CMake�汾���ַ�����

.. _`Debug Adapter Protocol`: https://microsoft.github.io/debug-adapter-protocol/

.. option:: --debugger-pipe <pipe name>, --debugger-pipe=<pipe name>

  ���ڵ�����ͨ�ŵĹܵ�����Windows�ϣ������׽��֣���Unix�ϣ������ơ�

.. option:: --debugger-dap-log <log path>, --debugger-dap-log=<log path>

  �����е�����ͨ�ż�¼��ָ���ļ���

.. _`Build Tool Mode`:

����һ����Ŀ
===============

.. program:: cmake

CMake�ṩ��һ��������ǩ���������Ѿ����ɵ���Ŀ��������

.. code-block:: shell

  cmake --build <dir>             [<options>] [-- <build-tool-options>]
  cmake --build --preset <preset> [<options>] [-- <build-tool-options>]

�⽫ʹ������ѡ������һ�������������ߵ������н��棺

.. option:: --build <dir>

  Ҫ��������Ŀ������Ŀ¼�����Ǳ���ģ�����ָ����Ԥ�裩�����ұ��������λ��

.. program:: cmake--build

.. option:: --preset <preset>, --preset=<preset>

  ʹ�ù���Ԥ����ָ������ѡ���Ŀ������Ŀ¼�Ǵ�\ ``configurePreset``\ ���ƶϳ����ġ���ǰ\
  ����Ŀ¼�������CMakeԤ���ļ����йظ�����ϸ��Ϣ�������\ :manual:`preset <cmake-presets(7)>`��

.. option:: --list-presets

  �г����õĹ���Ԥ�衣��ǰ����Ŀ¼�������CMakeԤ���ļ���

.. option:: -j [<jobs>], --parallel [<jobs>]

  .. versionadded:: 3.12

  ����ʱҪʹ�õ���󲢷������������ʡ��\ ``<jobs>``����ʹ�ñ����������ߵ�Ĭ�����֡�

  ���������\ :envvar:`CMAKE_BUILD_PARALLEL_LEVEL`\ ��������������δ������ѡ��ʱָ��Ĭ\
  �ϲ��м���

  һЩ���ع����������ǲ��й�����\ ``<jobs>``\ ֵ\ ``1``\ ��ʹ�ÿ���������Ϊ������ҵ��

.. option:: -t <tgt>..., --target <tgt>...

  ����\ ``<tgt>``\ ������Ĭ��Ŀ�ꡣ���Ը������Ŀ�꣬�ÿո�ָ���

.. option:: --config <cfg>

  ���ڶ����ù��ߣ�ѡ��\ ``<cfg>``\ ���á�

.. option:: --clean-first

  �ȹ���Ŀ��\ ``clean``��Ȼ���ٹ����������ֻ������ʹ��\
  :option:`--target clean <cmake--build --target>`����

.. option:: --resolve-package-references=<value>

  .. versionadded:: 3.23

  �ڹ���֮ǰ���������ⲿ��������������NuGet����Զ�̰����á���\ ``<value>``\ ����Ϊ\ ``on``\
  ��Ĭ�ϣ�ʱ�����ڹ���Ŀ��֮ǰ�ָ�������\ ``<value>``\ ����Ϊ\ ``only``\ ʱ�����ָ�����\
  ������ִ�й�������\ ``<value>``\ ����Ϊ\ ``off``\ ʱ�����ָ��κΰ���

  ���Ŀ��δ�����κΰ����ã����ѡ�ִ���κβ�����

  �����ÿ����ڹ���Ԥ����ָ����ʹ��\ ``resolvePackageReferences``�������ָ���˴�������ѡ�\
  �򽫺���Ԥ�����á�

  ���û���ṩ�����в�����Ԥ��ѡ�������һ���ض��ڻ����Ļ���������Ծ����Ƿ�Ӧ��ִ�а��ָ���

  ��ʹ��Visual Studio������ʱ����������ʹ��\ :prop_tgt:`VS_PACKAGE_REFERENCES`\ ��\
  �Զ���ġ�ʹ��NuGet�ָ������á�����ͨ����\ ``CMAKE_VS_NUGET_PACKAGE_RESTORE``\ ����\
  ����Ϊ\ ``OFF``\ ����������

.. option:: --use-stderr

  ���ԡ���Ϊ��Ĭ�ϵ���CMake >= 3.0��

.. option:: -v, --verbose

  ������ϸ��������֧�ֵĻ�������Ҫִ�еĹ������

  ���������\ :envvar:`VERBOSE`\ ����������\ :variable:`CMAKE_VERBOSE_MAKEFILE`\
  ��������������ʡ�Դ�ѡ�


.. option:: --

  ������ѡ��ݸ��������ߡ�

����\ :option:`cmake --build`��û�п��ٰ���ѡ�

��װһ����Ŀ
=================

.. program:: cmake

CMake�ṩ��һ��������ǩ������װ�Ѿ����ɵ���Ŀ����������

.. code-block:: shell

  cmake --install <dir> [<options>]

������ڹ�����Ŀ��ʹ�ã������а�װ������ʹ�����ɵĹ���ϵͳ�򱾻��������ߡ�ѡ�����£�

.. option:: --install <dir>

  Ҫ��װ����Ŀ������Ŀ¼�����Ǳ���ģ����ұ��������λ��

.. program:: cmake--install

.. option:: --config <cfg>

  ���ڶ�������������ѡ��\ ``<cfg>``\ ���á�

.. option:: --component <comp>

  ��������İ�װ��ֻ��װ\ ``<comp>``\ �����

.. option:: --default-directory-permissions <permissions>

  Ĭ��Ŀ¼��װȨ�ޡ�Ȩ��Ϊ\ ``<u=rwx,g=rx,o=rx>``\ �ĸ�ʽ��

.. option:: --prefix <prefix>

  ���ǰ�װǰ׺\ :variable:`CMAKE_INSTALL_PREFIX`��

.. option:: --strip

  ��װǰȥ��ǰ��ո�

.. option:: -v, --verbose

  ������ϸ�����

  ���������\ :envvar:`VERBOSE`\ ���������������ʡ�Դ�ѡ�

����\ :option:`cmake --install`��û�п��ٰ���ѡ�

��һ����Ŀ
==============

.. program:: cmake

.. code-block:: shell

  cmake --open <dir>

�ڹ�����Ӧ�ó����д����ɵ���Ŀ��ֻ֧�ֲ�����������


.. _`Script Processing Mode`:

���нű�
============

.. program:: cmake

.. code-block:: shell

  cmake [-D <var>=<value>]... -P <cmake-script-file> [-- <unparsed-options>...]

.. program:: cmake-P

.. option:: -D <var>=<value>

 Ϊ�ű�ģʽ���������

.. program:: cmake

.. option:: -P <cmake-script-file>

 ��������cmake�ļ���Ϊ��CMake���Ա�д�Ľű�������ִ�����û����ɲ��裬���޸Ļ��档���ʹ��\
 ``-D``\ ����������������\ ``-P``\ ����֮ǰ���С�

``--``\ ������κ�ѡ����ᱻCMake��������������Ȼ������\
:variable:`CMAKE_ARGV<n> <CMAKE_ARGV0>`\ ���ݸ��ű��ı���\������ ``--``\ ������


.. _`Run a Command-Line Tool`:

���������й���
=======================

.. program:: cmake

CMakeͨ��ǩ���ṩ���������й���

.. code-block:: shell

  cmake -E <command> [<options>]

.. option:: -E [help]

  ִ��\ ``cmake -E``\ ��\ ``cmake -E help``\ �鿴����ժҪ��

.. program:: cmake-E

���õ������У�

.. option:: capabilities

  .. versionadded:: 3.7

  JSON��ʽ��cmake�������ɹ��ܡ������һ��JSON���󣬰������¹ؼ��֣�

  ``version``
    ���а汾��Ϣ��JSON���󡣼��ǣ�

    ``string``
      �����汾�ַ�������\ :option:`--version <cmake --version>`\ ��ʾ��
    ``major``
      ��������ʽ��ʾ�����汾�š�
    ``minor``
      ������ʽ�Ĵ�Ҫ�汾�š�
    ``patch``
      ������ʽ�Ĳ�������
    ``suffix``
      cmake�汾��׺�ַ�����
    ``isDirty``
      �����������������������һ��boolֵ��

  ``generators``
    һ�����õ��������б�ÿ������������һ��JSON���󣬾������¼���

    ``name``
      �������������Ƶ��ַ�����
    ``toolsetSupport``
      ���������֧�ֹ��߼�����Ϊ\ ``true``������Ϊ\ ``false``��
    ``platformSupport``
      ���������֧��ƽ̨����Ϊ\ ``true``������Ϊ\ ``false``��
    ``supportedPlatforms``
      .. versionadded:: 3.21

      ��������ͨ��\ :variable:`CMAKE_GENERATOR_PLATFORM` (\ :option:`-A ... <cmake -A>`\ )\
      ֧��ƽ̨�淶ʱ�����ܴ��ڵĿ�ѡ��Ա����ֵ����֪֧�ֵ�ƽ̨�б�
    ``extraGenerators``
      ����������������ݵ�����\ :ref:`Extra Generators`\ ���ַ����б�

  ``fileApi``
    :manual:`cmake-file-api(7)`\ ����ʱ���ֵĿ�ѡ��Ա����ֵ��һ��JSON����ֻ��һ����Ա��

    ``requests``
      һ��JSON���飬�����������֧�ֵ��ļ�api����ÿ��������һ��JSON���󣬰������³�Ա:

      ``kind``
        ָ��֧�ֵ�\ :ref:`file-api object kinds`\ ֮һ��

      ``version``
        һ��JSON���飬��ÿ��Ԫ�ض���һ��JSON�������а���ָ���Ǹ������汾�����\ ``major``\
        ��\ ``minor``\ ��Ա��

  ``serverMode``
    ���cmake֧�ַ�����ģʽ����Ϊ\ ``true``������Ϊ\ ``false``����CMake 3.20��������false��

  ``tls``
    .. versionadded:: 3.25

    ���������TLS֧�֣���Ϊ\ ``true``������Ϊ\ ``false``��

  ``debugger``
    .. versionadded:: 3.27

    ���֧��\ :option:`--debugger <cmake --debugger>`\ ģʽ����Ϊ\ ``true``������Ϊ\
    ``false``��

.. option:: cat [--] <files>...

  .. versionadded:: 3.18

  �����ļ����ڱ�׼����ϴ�ӡ��

  .. program:: cmake-E_cat

  .. option:: --

    .. versionadded:: 3.24

    �����˶�˫���ۺŲ�����֧��\ ``--``��\ ``cat``\ �Ļ���ʵ�ֲ�֧���κ�ѡ����ʹ����\
    ``-``\ ��ͷ��ѡ����´������ļ���\ ``-``\ ��ͷ������£�ʹ��\ ``--``\ ����ʾѡ��\
    �Ľ�����

  .. versionadded:: 3.29

    ``cat``\ ���ڿ���ͨ������\ ``-``\ ������ӡ��׼���롣

.. program:: cmake-E

.. option:: chdir <dir> <cmd> [<arg>...]

  ���ĵ�ǰ����Ŀ¼���������

.. option:: compare_files [--ignore-eol] <file1> <file2>

  ���\ ``<file1>``\ �Ƿ���\ ``<file2>``\ ��ͬ������ļ���ͬ���򷵻�\ ``0``�����򷵻�\
  ``1``�����������Ч���򷵻�2��

  .. program:: cmake-E_compare_files

  .. option:: --ignore-eol

    .. versionadded:: 3.14

    ��ѡ�ʾ���бȽϣ�����LF/CRLF���졣

.. program:: cmake-E

.. option:: copy <file>... <destination>, copy -t <destination> <file>...

  ���ļ����Ƶ�\ ``<destination>``\ ���ļ���Ŀ¼�������ָ���˶���ļ�������ָ����\ ``-t`` ��\
  ``<destination>`` \ ������Ŀ¼�����ұ�����ڡ����δָ��\ ``-t`` ����ٶ����һ������Ϊ\
  ``<destination>``����֧��ͨ�����\ ``copy``\ ��ѭ�������ӡ�����ζ���������Ʒ������ӣ�\
  ���Ǹ�������ָ����ļ���Ŀ¼��

  .. versionadded:: 3.5
    ֧�ֶ�������ļ���

  .. versionadded:: 3.26
    ֧��\ ``-t``\ ������

.. option:: copy_directory <dir>... <destination>

  ����\ ``<dir>...``\ Ŀ¼��\ ``<destination>``\ Ŀ¼�����\ ``<destination>``\
  Ŀ¼�����ڣ�������������\ ``copy_directory``\ ��ѭ�������ӡ�

  .. versionadded:: 3.5
    ֧�ֶ������Ŀ¼��

  .. versionadded:: 3.15
    ��ԴĿ¼������ʱ�������ʧ�ܡ�֮ǰ����ͨ������һ���յ�Ŀ��Ŀ¼���ɹ���

.. option:: copy_directory_if_different <dir>... <destination>

  .. versionadded:: 3.26

  ����\ ``<dir>...``\ Ŀ¼�ĸ������ݵ�\ ``<destination>``\ Ŀ¼�����\ ``<destination>``\
  Ŀ¼�����ڣ�������������

  ``copy_directory_if_different``\ ��ѭ�������ӡ���ԴĿ¼������ʱ������ִ��ʧ�ܡ�

.. option:: copy_if_different <file>... <destination>

  ����ļ��Ѹ��ģ����临�Ƶ�\ ``<destination>``\���ļ���Ŀ¼�������ָ���˶���ļ���\
  ``<destination>``\ ������Ŀ¼�ұ�����ڡ�\ ``copy_if_different``\ ��ѭ�������ӡ�

  .. versionadded:: 3.5
    ֧�ֶ�������ļ���

.. option:: create_symlink <old> <new>

  ����һ������Ϊ\ ``<old>``\ �ķ�������\ ``<new>``��

  .. versionadded:: 3.13
    ֧����Windows�ϴ����������ӡ�

  .. note::
    ����\ ``<new>``\ �������ӵ�·���������ȴ��ڡ�

.. option:: create_hardlink <old> <new>

  .. versionadded:: 3.19

  ����һ��Ӳ����\ ``<new>``\ ����Ϊ\ ``<old>``��

  .. note::
    Ҫ����\ ``<new>``\ Ӳ���ӵ�·���������ȴ��ڡ�\ ``<old>``\ �������ȴ��ڡ�

.. option:: echo [<string>...]

  ��������ʾΪ�ı���

.. option:: echo_append [<string>...]

  ��������ʾΪ�ı����������С�

.. option:: env [<options>] [--] <command> [<arg>...]

  .. versionadded:: 3.1

  ���޸ĺ�Ļ�����ִ�����ѡ���У�

  .. program:: cmake-E_env

  .. option:: NAME=VALUE

    ��\ ``NAME``\ �ĵ�ǰֵ�滻Ϊ\ ``VALUE``��

  .. option:: --unset=NAME

    ȡ��\ ``NAME``\ �ĵ�ǰֵ��

  .. option:: --modify ENVIRONMENT_MODIFICATION

    .. versionadded:: 3.25

    ���޸ĺ�Ļ���Ӧ�õ���\ :prop_test:`ENVIRONMENT_MODIFICATION`\ ������

    ``NAME=VALUE``\ ��\ ``--unset=NAME``\ ѡ��ֱ��൱��\ ``--modify NAME=set:VALUE``\
    ��\ ``--modify NAME=unset:``��ע��\ ``--modify NAME=reset:``\ ��\ ``NAME``\
    ����Ϊ\ :program:`cmake`\ ��������ȡ�����ã�ʱ��ֵ�������������\ ``NAME=VALUE``\ ѡ�

  .. option:: --

    .. versionadded:: 3.24

    �����˶�˫���ۺŲ�����֧��\ ``--``��ʹ��\ ``--``\ ֹͣ����ѡ��/����������������һ����\
    ����Ϊ�����ʹ����\ ``-``\ ��ͷ�����\ ``=``��

.. program:: cmake-E

.. option:: environment

  ��ʾ��ǰ����������

.. option:: false

  .. versionadded:: 3.16

  ʲô���������˳�����Ϊ1��

.. option:: make_directory <dir>...

  ����\ ``<dir>``\ Ŀ¼�������Ҫ��Ҳ������Ŀ¼�����һ��Ŀ¼�Ѿ����ڣ���������Ĭ���ԡ�

  .. versionadded:: 3.5
    ֧�ֶ������Ŀ¼��

.. option:: md5sum <file>...

  ��\ ``md5sum``\ ���ݸ�ʽ�����ļ���MD5У��ͣ�\ ::

     351abe79cd3800b38cdfb25d45015a15  file1.txt
     052f86c15bbde68af55c7f7b340ab639  file2.txt

.. option:: sha1sum <file>...

  .. versionadded:: 3.10

  ��\ ``sha1sum``\ ���ݸ�ʽ�����ļ���SHA1У��ͣ�\ ::

     4bb7932a29e6f73c97bb9272f2bdc393122f86e0  file1.txt
     1df4c8f318665f9a5f2ed38f55adadb7ef9f559c  file2.txt

.. option:: sha224sum <file>...

  .. versionadded:: 3.10

  ��\ ``sha224sum``\ ���ݸ�ʽ�����ļ���SHA224У��ͣ�\ ::

     b9b9346bc8437bbda630b0b7ddfc5ea9ca157546dbbf4c613192f930  file1.txt
     6dfbe55f4d2edc5fe5c9197bca51ceaaf824e48eba0cc453088aee24  file2.txt

.. option:: sha256sum <file>...

  .. versionadded:: 3.10

  ��\ ``sha256sum``\ ���ݸ�ʽ�����ļ���SHA256У��ͣ�\ ::

     76713b23615d31680afeb0e9efe94d47d3d4229191198bb46d7485f9cb191acc  file1.txt
     15b682ead6c12dedb1baf91231e1e89cfc7974b3787c1e2e01b986bffadae0ea  file2.txt

.. option:: sha384sum <file>...

  .. versionadded:: 3.10

  ��\ ``sha384sum``\ ���ݸ�ʽ�����ļ���SHA384У��ͣ�\ ::

     acc049fedc091a22f5f2ce39a43b9057fd93c910e9afd76a6411a28a8f2b8a12c73d7129e292f94fc0329c309df49434  file1.txt
     668ddeb108710d271ee21c0f3acbd6a7517e2b78f9181c6a2ff3b8943af92b0195dcb7cce48aa3e17893173c0a39e23d  file2.txt

.. option:: sha512sum <file>...

  .. versionadded:: 3.10

  ��\ ``sha512sum``\ ���ݸ�ʽ�����ļ���SHA512У��ͣ�\ ::

     2a78d7a6c5328cfb1467c63beac8ff21794213901eaadafd48e7800289afbc08e5fb3e86aa31116c945ee3d7bf2a6194489ec6101051083d1108defc8e1dba89  file1.txt
     7a0b54896fe5e70cca6dd643ad6f672614b189bf26f8153061c4d219474b05dad08c4e729af9f4b009f1a1a280cb625454bf587c690f4617c27e3aebdf3b7a2d  file2.txt

.. option:: remove [-f] <file>...

  .. deprecated:: 3.17

  ɾ���ļ����ƻ�����Ϊ�ǣ�����г����κ��ļ��Ѿ������ڣ�������ط����˳����룬������¼�κ�\
  ��Ϣ������������£�\ ``-f``\ ѡ���Ϊ����Ϊ�������˳����루���ɹ�����\ ``remove``\
  ������������ӡ�����ζ����ֻɾ���������ӣ�����ɾ����ָ����ļ���

  ���ʵ���кܶ����⣬���Ƿ���0��������ƻ��������ԣ����޷��޸�������ʹ��\ ``rm``\ ���档

.. option:: remove_directory <dir>...

  .. deprecated:: 3.17

  ɾ��\ ``<dir>``\ Ŀ¼�������ݡ����һ��Ŀ¼�����ڣ���������Ĭ���ԡ�ʹ��\ ``rm``\ ���档

  .. versionadded:: 3.15
    ֧�ֶ��Ŀ¼��

  .. versionadded:: 3.16
    ���\ ``<dir>``\ ��ָ��Ŀ¼�ķ������ӣ���ֻɾ���������ӡ�

.. option:: rename <oldname> <newname>

  �������ļ���Ŀ¼����һ�����ϣ����������Ϊ\ ``<newname>``\ ���ļ��Ѿ����ڣ���ô��������Ĭ�滻��

.. option:: rm [-rRf] [--] <file|dir>...

  .. versionadded:: 3.17

  ɾ���ļ�\ ``<file>``\ ��Ŀ¼\ ``<dir>``��ʹ��\ ``-r`` �� ``-R``\ �ݹ��ɾ��Ŀ¼����\
  ���ݡ�����г����κ��ļ�/Ŀ¼�����ڣ��������һ�������˳����룬������¼�κ���Ϣ����������\
  ���£�\ ``-f``\ ѡ���Ϊ����Ϊ�������˳����루���ɹ�����ʹ��\ ``--``\ ֹͣ����ѡ���\
  ������ʣ��Ĳ�����Ϊ·������ʹ������\ ``-``\ ��ͷ��

.. option:: sleep <number>

  .. versionadded:: 3.0

  ˯�߸�������\ ``<number>``��\ ``<number>``\ �����Ǹ���������������/ֹͣCMake��ִ����\
  ���Ŀ�����ʵ�ʵ���Сֵ��Լ��0.1�롣����CMake�ű��в����ӳ��Ǻ����õģ�

  .. code-block:: cmake

    # Sleep for about 0.5 seconds
    execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 0.5)

.. option:: tar [cxt][vf][zjJ] file.tar [<options>] [--] [<pathname>...]

  ��������ȡһ��tar��zip�鵵�ļ���ѡ���У�

  .. program:: cmake-E_tar

  .. option:: c

    ��������ָ���ļ����´浵�����ʹ��\ ``<pathname>...``\ ������ǿ���Եġ�

  .. option:: x

    �ӹ鵵�ļ�����ȡ�����̡�

    .. versionadded:: 3.15
      ``<pathname>...``\ ���������ڽ���ȡѡ�����ļ���Ŀ¼������ȡѡ�����ļ���Ŀ¼ʱ������\
      �ṩ���ǵ�ȷ�����ƣ�����·�������б��ӡ��\ ``-t``\ ����ʾ��

  .. option:: t

    �г��浵���ݡ�

    .. versionadded:: 3.15
      ``<pathname>...``\ ���������ڽ��г�ѡ�����ļ���Ŀ¼��

  .. option:: v

    ������ϸ�������

  .. option:: z

    ʹ��gzipѹ�����ɵĹ鵵�ļ���

  .. option:: j

    ʹ��bzip2ѹ�����ɵĹ鵵�ļ���

  .. option:: J

    .. versionadded:: 3.1

    ʹ��XZѹ�����ɵĹ鵵�ļ���

  .. option:: --zstd

    .. versionadded:: 3.15

    ʹ��Zstandardѹ�����ɵĹ鵵�ļ���

  .. option:: --files-from=<file>

    .. versionadded:: 3.1

    �Ӹ������ļ��ж�ȡ�ļ�����ÿ��һ�������н������ԡ��в�����\ ``-``\ ��ͷ������\
    ``--add-file=<name>``\ ����ļ�����\ ``-``\ ��ͷ���ļ���

  .. option:: --format=<format>

    .. versionadded:: 3.3

    ָ��Ҫ�����Ĺ鵵�ļ��ĸ�ʽ��֧�ֵĸ�ʽ�У�\ ``7zip``��\ ``gnutar``��\ ``pax``��\
    ``paxr``\ ������pax��Ĭ�ϣ���\ ``zip``��

  .. option:: --mtime=<date>

    .. versionadded:: 3.1

    ָ����tarball��Ŀ�м�¼���޸�ʱ�䡣

  .. option:: --touch

    .. versionadded:: 3.24

    ʹ�õ�ǰ����ʱ����������ǴӴ浵����ȡ�ļ�ʱ�����

  .. option:: --

    .. versionadded:: 3.1

    ֹͣ����ѡ���������ʣ��Ĳ�����Ϊ�ļ�������ʹ������\ ``-``\ ��ͷ��

  .. versionadded:: 3.1
    ֧��LZMA ��7zip����

  .. versionadded:: 3.15
    ���������ڼ�����浵������ļ�����ʹ����һЩ�ļ����ɶ���������Ϊ�뾭���\ ``tar``\ ����\
    ����һ�¡����������ڻ��������б�־������ṩ����Ч��־���򷢳����档

.. program:: cmake-E

.. option:: time <command> [<args>...]

  ����\ ``<command>``\ ����ʾ����ʱ�䡣������CMakeǰ�˵Ŀ�������

  .. versionadded:: 3.5
    ������������ȷ�ؽ����пո�������ַ��Ĳ������ݸ��ӽ��̡�����ܻ��ƻ���Щʹ���Լ��Ķ�����\
    �û�ת�����������Ľű���

.. option:: touch <file>...

  ����ļ������ڣ��򴴽�\ ``<file>``�����\ ``<file>``\ ���ڣ������ڸı�\ ``<file>``\
  �ķ��ʺ��޸�ʱ�䡣

.. option:: touch_nocreate <file>...

  ����һ���ļ�����������ڣ����������������һ���ļ������ڣ���������Ĭ���ԡ�

.. option:: true

  .. versionadded:: 3.16

  ʲô���������˳�����Ϊ0��

Windows�ض������й���
-----------------------------------

����\ ``cmake -E``\ �������Windows����ϵͳ�¿��ã�

.. option:: delete_regv <key>

  ɾ��Windowsע���ֵ��

.. option:: env_vs8_wince <sdkname>

  .. versionadded:: 3.2

  ��ʾһ���������ļ������ļ�ΪVS2005�а�װ��Windows CE SDK���û�����

.. option:: env_vs9_wince <sdkname>

  .. versionadded:: 3.2

  ��ʾһ���������ļ������ļ�Ϊ��װ��VS2008���ṩ��Windows CE SDK���û�����

.. option:: write_regv <key> <value>

  д��Windowsע���ֵ��

.. _`Find-Package Tool Mode`:

���а����ҹ���
=========================

.. program:: cmake--find-package

CMakeΪ����Makefile����Ŀ�ṩ��һ������pkg-config�����֣�

.. code-block:: shell

  cmake --find-package [<options>]

��ʹ��\ :command:`find_package()`\ �����������������Ǵ�ӡ��stdout������Դ���\
pkg-config����ͨ�Ļ���Makefile����Ŀ�����autoconf����Ŀ���ҵ��Ѱ�װ�Ŀ⣨ͨ��\
``share/aclocal/cmake.m4``����

.. note::
  ����һЩ�������ƣ�����ģʽû�еõ��ܺõ�֧�֡���������Ϊ�˼��ݣ�����Ӧ��������Ŀ��ʹ�á�

.. _`Workflow Mode`:

���й�����Ԥ��
=====================

.. versionadded:: 3.25

.. program:: cmake

:manual:`CMakeԤ�� <cmake-presets(7)>`\ �ṩ��һ�ְ�˳��ִ�ж����������ķ�����

.. code-block:: shell

  cmake --workflow [<options>]

ѡ���У�

.. option:: --workflow

  ʹ������ѡ��֮һѡ��\ :ref:`Workflow Preset` ��

.. program:: cmake--workflow

.. option:: --preset <preset>, --preset=<preset>

  ʹ�ù�����Ԥ����ָ������������Ŀ������Ŀ¼�Ǵӳ�ʼ����Ԥ���ƶϳ����ġ���ǰ����Ŀ¼�������\
  CMakeԤ���ļ����йظ�����ϸ��Ϣ�������\ :manual:`preset <cmake-presets(7)>` ��

.. option:: --list-presets

  �г����õĹ�����Ԥ�衣��ǰ����Ŀ¼�������CMakeԤ���ļ���

.. option:: --fresh

  ִ�й������������á�which has the same effect
  as :option:`cmake --fresh`��

�鿴����
=========

.. program:: cmake

Ҫ��CMake�ĵ��д�ӡѡ����ҳ�棬ʹ��

.. code-block:: shell

  cmake --help[-<topic>]

����������һ��ѡ��

.. include:: OPTIONS_HELP.txt

��Ҫ�鿴��Ŀ���õ�Ԥ�裬��ʹ��

.. code-block:: shell

  cmake <source-dir> --list-presets


.. _`CMake Exit Code`:

����ֵ���˳��룩
========================

�ڳ�����ֹʱ��:program:`cmake`\ ��ִ���ļ������˳���\ ``0``��

�����ֹ����������Ϣ\ :command:`message(FATAL_ERROR)`\ ������������������ģ��򷵻�һ��\
�����˳����롣


���в���
========

.. include:: LINKS.txt
