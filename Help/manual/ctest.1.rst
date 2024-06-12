.. cmake-manual-description: CTest Command-Line Reference

ctest(1)
********

.. contents::

���
========

.. parsed-literal::

 `���в���`_
  ctest [<options>] [--test-dir <path-to-build>]

 `Build and Test Mode`_
  ctest --build-and-test <path-to-source> <path-to-build>
        --build-generator <generator> [<options>...]
       [--build-options <opts>...]
       [--test-command <command> [<args>...]]

 `Dashboard Client`_
  ctest -D <dashboard>         [-- <dashboard-options>...]
  ctest -M <model> -T <action> [-- <dashboard-options>...]
  ctest -S <script>            [-- <dashboard-options>...]
  ctest -SP <script>           [-- <dashboard-options>...]

 `�鿴����`_
  ctest --help[-<topic>]


����
===========

:program:`ctest`\ ��ִ���ļ���CMake������������Ϊʹ��\ :command:`enable_testing`\
��\ :command:`add_test`\ �������Ŀ������CMake���ɵĹ��������в���֧�֡��˳������в���\
����������

.. _`Run Tests`:

���в���
=========

.. program:: ctest

.. option:: --preset <preset>, --preset=<preset>

 ʹ�ò���Ԥ����ָ������ѡ���Ŀ������Ŀ¼�Ǵ�\ ``configurePreset``\ ���ƶϳ����ġ���ǰ��\
 ��Ŀ¼�������CMakeԤ���ļ����йظ�����ϸ��Ϣ�������\ :manual:`preset <cmake-presets(7)>`��

.. option:: --list-presets

 �г����õĲ���Ԥ�衣��ǰ����Ŀ¼�������CMakeԤ���ļ���

.. option:: -C <cfg>, --build-config <cfg>

 ѡ��Ҫ���Ե����á�

 һЩCMake���ɵĹ�����������ͬһ�����ж���������á���ѡ�������ָ��Ӧ�ò�����һ����ʾ��������\
 ``Debug``\ ��\ ``Release``��

.. option:: --progress

 ���ò��ԵĶ̽��������

 ��\ :program:`ctest`\ �����ֱ�ӷ��͵��ն�ʱ��ͨ������ͬһ����������Լ��Ľ��ȣ���������\
 ������Ϊÿ�����Դ�ӡ��ʼ�ͽ�����Ϣ��������������ٲ���������߳��ԡ�����ʧ�ܵĲ��ԣ��������\
 ��Ϣ�Խ����䵥������������������Խ���¼���յĲ���ժҪ��

 ���ѡ��Ҳ����ͨ�����û�������\ :envvar:`CTEST_PROGRESS_OUTPUT`\ �����á�

.. option:: -V, --verbose

 ���ò��Ե���ϸ�����

 �������ͨ�������ƣ�ֻ��ʾժҪ��Ϣ����ѡ���ʾ���в��������

.. option:: -VV, --extra-verbose

 �Ӳ��������ø���ϸ�������

 �������ͨ�������ƣ�ֻ��ʾժҪ��Ϣ�����ѡ���ʾ����Ĳ��������

.. option:: --debug

 ��ʾCTest�ĸ���ϸ���ڲ���Ϣ��

 �����Խ����������������Щ����Ե����Ǳ������ǳ����á�

.. option:: --output-on-failure

 �������ʧ�ܣ�������Գ���������κ����ݡ����ѡ��Ҳ����ͨ������\
 :envvar:`CTEST_OUTPUT_ON_FAILURE`\ �������������á�

.. option:: --stop-on-failure

 �����ֵ�һ������ʱ��ֹͣ���в��ԡ�

.. option:: -F

 ֧�ֹ���ת�ơ�

 ��ѡ������CTest�ָ���ǰ�жϵĲ��Լ�ִ�С����û���жϷ�����\ ``-F``\ ѡ��������á�

.. option:: -j [<level>], --parallel [<level>]

 �������в��ԣ���ѡ�������ڸ����Ĳ��жȼ���

 .. versionadded:: 3.29

    ``<level>``\ ����ʡ�Ի�Ϊ\ ``0``������������£�

    * ��\ `��ҵ����������`_\ �£��������ܵ�������ҵ���Ƶ����ơ�

    * �������ʡ�Ը�ֵ������������Ϊ����������������Ϊ2���Խϴ���Ϊ׼��

    * ���������ֵΪ\ ``0``�����жȲ������ơ�

 ���ѡ�������\ :envvar:`CTEST_PARALLEL_LEVEL`\ ��������ָ����

 ���ѡ�������\ :prop_test:`PROCESSORS`\ ��������һ��ʹ�á���鿴\ `��ǩ������ĿժҪ`_��

.. option:: --resource-spec-file <file>

 ʹ��\ ``<file>``\ ��ָ����\
 :ref:`��Դ�淶�ļ� <ctest-resource-specification-file>`��������\
 :ref:`��Դ���� <ctest-resource-allocation>`\ �����������CTest��

 ��\ :program:`ctest`\ ��Ϊ\ `�Ǳ��ͻ���`_\ ����ʱ���⽫����\ `CTest���Բ���`_\ ��\
 ``ResourceSpecFile``\ ѡ�

.. option:: --test-load <level>

 �ڲ������в���ʱ������ʹ��\ :option:`-j <ctest -j>`���������Կ��ܵ���CPU���س���������\
 ֵʱ��������Ҫ�������ԡ�

 ��\ :program:`ctest`\ ��Ϊ\ `�Ǳ��ͻ���`_\ ����ʱ���⽫����\ `CTest���Բ���`_\ ��\
 ``TestLoad``\ ѡ�

.. option:: -Q, --quiet

 ��CTest���ְ�����

 ��ѡ�����������������ָ����\ :option:`--output-log <ctest --output-log>`����Ȼ\
 �����������־�ļ������ָ����\ ``--quiet``����ô\ :option:`--verbose <ctest --verbose>`��\
 :option:`--extra-verbose <ctest --extra-verbose>`\ ��\
 :option:`--debug <ctest --debug>`\ ��ѡ������ԡ�

.. option:: -O <file>, --output-log <file>

 �������־�ļ���

 ��ѡ�����CTest�����������д��\ ``<file>``\ ��־�ļ���

.. option:: --output-junit <file>

 .. versionadded:: 3.21

 ��JUnit��ʽ��д���Խ����

 ���ѡ�����CTest�����Խ��д��\ ``<file>``\ ��JUnit XML��ʽ�����\ ``<file>``\ �Ѿ�\
 ���ڣ����������ǡ����ʹ��\ :option:`-S <ctest -S>`\ ѡ�������Ǳ��ű�����ʹ��\
 ``OUTPUT_JUNIT``\ �ؼ��ֺ�\ :command:`ctest_test`\ ������档

.. option:: -N, --show-only[=<format>]

 ���ò��Ե�ʵ��ִ�С�

 ���ѡ�����CTest�г���Ҫ���е�û��ʵ�����еĲ��ԡ���\ :option:`-R <ctest -R>`\ ��\
 :option:`-E <ctest -E>`\ ѡ��һ��ʹ�á�

 .. versionadded:: 3.14

   ``--show-only``\ ѡ�����\ ``<format>``\ ֵ��

 ``<format>``\ ����������ֵ֮һ��

   ``human``
     ���Ի���������ⲻ�ܱ�֤���ȶ��ġ�����Ĭ��ֵ��

   ``json-v1``
     ��JSON��ʽת��������Ϣ���μ���ʾΪ\ `��ʾΪJSON����ģ��`_��

.. option:: -L <regex>, --label-regex <regex>

 ������\ :ref:`string(REGEX) <Regex Specification>`\ ��������������ʽƥ��ı�ǩ�Ĳ��ԡ�

 ��ѡ�����CTestֻ���б�ǩ�����������ʽƥ��Ĳ��ԡ����������\ ``-L``\ ѡ��ʱ��ֻ�е�ÿ\
 ��������ʽƥ������һ�����Եı�ǩ�������\ ``-L``\ ��ǩ�γ�һ��\ ``AND``\ ��ϵ��ʱ����\
 �����в��ԡ��μ�\ `��ǩƥ��`_��

.. option:: -R <regex>, --tests-regex <regex>

 ����ƥ��������ʽ�Ĳ��ԡ�

 ��ѡ�����CTestֻ�������������������ʽƥ��Ĳ��ԡ�

.. option:: -E <regex>, --exclude-regex <regex>

 �ų�ƥ��������ʽ�Ĳ��ԡ�

 ��ѡ�����CTest\ **��**\ �������������������ʽƥ��Ĳ��ԡ�

.. option:: -LE <regex>, --label-exclude <regex>

 �ų���ǩ��������ʽƥ��Ĳ��ԡ�

 ��ѡ�����CTest\ **��**\ ���б�ǩ�����������ʽƥ��Ĳ��ԡ����������\ ``-LE``\ ѡ��ʱ��\
 ֻ�е�ÿ��������ʽƥ������һ�����Եı�ǩ�������\ ``-LE``\ ��ǩ�γ�һ��\ ``AND``\
 ��ϵ��ʱ���Ż��ų����ԡ��ο�\ `��ǩƥ��`_��

.. option:: --tests-from-file <filename>

 .. versionadded:: 3.29

 ���и����ļ����г��Ĳ��ԡ�

 ��ѡ�����CTest���и����ļ����г��Ĳ��ԡ����ļ�ÿ�б������һ��ȷ�еĲ������ơ�����ȫƥ��\
 �κβ������Ƶ��н������ԡ���ѡ�������\ ``-R``��\ ``-E``��\ ``-L``\ ��\ ``-LE``\ ��\
 ����ѡ�����ʹ�á�

.. option:: --exclude-from-file <filename>

 .. versionadded:: 3.29

 �ų������ļ����г��Ĳ��ԡ�

 ���ѡ�����CTest\ **��**\ ���и����ļ����г��Ĳ��ԡ����ļ�ÿ�б������һ��ȷ�еĲ������ơ�\
 ����ȫƥ���κβ������Ƶ��н������ԡ���ѡ�������\ ``-R``��\ ``-E``��\ ``-L``\ ��\
 ``-LE``\ ������ѡ�����ʹ�á�

.. option:: -FA <regex>, --fixture-exclude-any <regex>

 �ų���\ ``<regex>``\ ƥ���fixture�Զ�����Լ�������κβ��ԡ�

 ���Ҫִ�еĲ��Լ��е�һ��������Ҫһ���ض���fixture����ô��fixture�����ú��������ͨ����\
 �Զ���ӵ����Լ��С���ѡ��ɷ�ֹΪƥ��\ ``<regex>``\ ��fixture��Ӱ�װ��������ԡ�ע�⣬\
 ������������fixture��Ϊ���������������������fixture���ò���ʧ�ܵĲ��ԡ�

.. option:: -FS <regex>, --fixture-exclude-setup <regex>

 ��\ :option:`-FA <ctest -FA>`\ ��ͬ����ֻ�ų�ƥ������ò��ԡ�

.. option:: -FC <regex>, --fixture-exclude-cleanup <regex>

 ��\ :option:`-FA <ctest -FA>`\ ��ͬ����ֻ�ų�ƥ���������ԡ�

.. option:: -I [Start,End,Stride,test#,test#|Test file], --tests-information

 ����������ض������Ĳ��ԡ�

 ��ѡ��ʹCTest���дӱ��\ ``Start``\ ��ʼ���Ա��\ ``End``\ ��������\ ``Stride``\ ��\
 ���Ĳ��ԡ�\ ``Stride``\ ֮����κθ������ֶ�����Ϊ�����Ĳ������֡�\ ``Start``��\ ``End``\
 ��\ ``Stride``\ ����Ϊ�ա�����ѡ��һ����������������ͬ�﷨���ļ���

.. option:: -U, --union

 ȡ\ :option:`-I <ctest -I>`\ ��\ :option:`-R <ctest -R>`\ �Ĳ�����

 Ĭ������£�ͬʱָ��\ :option:`-R <ctest -R>`\ ��\ :option:`-I <ctest -I>`\ ʱ����\
 ���в��Խ�����ͨ��ָ��\ ``-U``�������в��ԵĲ�����

.. option:: --rerun-failed

 ֻ������ǰʧ�ܵĲ��ԡ�

 ��ѡ�����CTestִֻ�����ϴ������ڼ�ʧ�ܵĲ��ԡ�ָ����ѡ���CTest�����������޸�Ҫ���еĲ�\
 ���б����������ѡ�:option:`-L <ctest -L>`��:option:`-R <ctest -R>`��\
 :option:`-E <ctest -E>`��:option:`-LE <ctest -LE>`��:option:`-I <ctest -I>`\ �ȣ���\
 ���CTest���в���û�в���ʧ�ܣ���ʹ��\ ``--rerun-failed``\ ѡ���CTest�ĺ������ý�����\
 ���ʧ�ܵĲ��Լ�������еĻ�����

.. option:: --repeat <mode>:<n>

  ���ݸ�����\ ``<mode>``\ �ظ����в��ԣ���������\ ``<n>``\ �Ρ�ģʽ�У�

  ``until-fail``
    Ҫ��ÿ����������\ ``<n>``\ �ζ���ʧ�ܲ���ͨ��������ڷ��ֲ��������е����ǹ��Ϻ����á�

  ``until-pass``
    ����ÿ�������������\ ``<n>``\ �β���ͨ��������������κ�ԭ��ʧ�ܣ����ظ����ԡ������\
    ���̲��������е����ǹ����Ǻ����õġ�

  ``after-timeout``
    ����ÿ�������������\ ``<n>``\ �β���ͨ����ֻ�е����Գ�ʱʱ���ظ����ԡ�������ڷ�æ��\
    ���������̲��������е����ǳ�ʱ�ǳ����á�

.. option:: --repeat-until-fail <n>

 �൱��\ :option:`--repeat until-fail:\<n\> <ctest --repeat>`��

.. option:: --max-width <width>

 ���ò����������������ȡ�

 ����Ҫ���������ʾ��ÿ���������Ƶ�����ȡ��������û�����������Ա�����в������ƣ������\
 �Ƿǳ����˵ġ�

.. option:: --interactive-debug-mode [0|1]

 ���ý���ģʽΪ\ ``0``\ ��\ ``1``��

 ��ѡ���ʹCTest�Խ���ģʽ��ǽ���ģʽ���в��ԡ����Ǳ��ģʽ�£�\ ``Experimental``��\
 ``Nightly``��\ ``Continuous``����Ĭ��Ϊ�ǽ���ʽ���ڷǽ���ģʽ�£����û�������\
 :envvar:`DASHBOARD_TEST_FROM_CTEST`��

 ��CMake 3.11֮ǰ��Windows�ϵĽ���ģʽ�������ϵͳ���Ե������ڡ����ڣ�����CTestʹ��\
 ``libuv``\ ���������Խ��̣�����ϵͳ���Ե����������Ǳ���ֹ��

.. option:: --no-label-summary

 ���ñ�ǩ�Ķ�ʱ������Ϣ��

 ��ѡ�����CTest��Ҫ��ӡ����������������ÿ����ǩ��ժҪ��Ϣ�����������û�б�ǩ���Ͳ����\
 ӡ�κζ�������ݡ�

 �����\ `��ǩ������ĿժҪ`_��

.. option:: --no-subproject-summary

 ��������Ŀ�Ķ�ʱժҪ��Ϣ��

 ��ѡ�����CTest��Ҫ��ӡ����������������ÿ������Ŀ��ժҪ��Ϣ�����������û������Ŀ���򲻻�\
 ��ӡ��������ݡ�

 �����\ `��ǩ������ĿժҪ`_��

.. option:: --test-dir <dir>

 .. versionadded:: 3.20

 ָ��Ҫ���Ҳ��Ե�Ŀ¼��ͨ����CMake��Ŀ����Ŀ¼�����δָ������ʹ�õ�ǰĿ¼��

.. option:: --test-output-size-passed <size>

 .. versionadded:: 3.4

 ��ͨ���Ĳ��Ե��������Ϊ\ ``<size>``\ �ֽڡ�

.. option:: --test-output-size-failed <size>

 .. versionadded:: 3.4

 ��ʧ�ܲ��Ե��������Ϊ\ ``<size>``\ �ֽڡ�

.. option:: --test-output-truncation <mode>

 .. versionadded:: 3.24

 һ���ﵽ��������С���ضϲ��������\ ``tail``\ ��Ĭ�ϣ���\ ``middle``\ ��\ ``head``��

.. option:: --overwrite

 ����CTest����ѡ�

 Ĭ������£�CTestʹ�������ļ��е�����ѡ���ѡ���������ѡ�

.. option:: --force-new-ctest-process

 ����CTestʵ����Ϊ�½������С�

 Ĭ������£�CTest����ͬһ������������CTestʵ�����������Ҫ������Ϊ�����������Ϊ��CTest��\
 ��ǿ���µĽ��̡�

.. option:: --schedule-random

 ʹ�����˳���Ų��ԡ�

 ��ѡ������˳�����в��ԡ���ͨ�����ڼ������׼��е���ʽ������ϵ��

.. option:: --submit-index

 �ɵ�Dart2�Ǳ����������ܵ�����ѡ�����ʹ�á�

.. option:: --timeout <seconds>

 ����Ĭ�ϲ��Գ�ʱʱ�䡣

 ��ѡ����Ч��Ϊ��δͨ��\ :prop_test:`TIMEOUT`\ ���Զ������ó�ʱ�����в������ó�ʱ��

.. option:: --stop-time <time>

 �������в���Ӧֹͣ���е�ʱ�䡣

 ����һ�������в���Ӧ�ó�ʱ��ʵ��ʱ�䡣����\ ``7:00:00 -0400``�����Խ���curl���ڽ�������\
 ����κ�ʱ���ʽ�����û��ָ��ʱ������ٶ�Ϊ����ʱ�䡣

.. option:: --print-labels

 ��ӡ���п��õĲ��Ա�ǩ��

 ��ѡ��������κβ��ԣ���ֻ���ӡ����Լ����������б�ǩ���б�

.. option:: --no-tests=<action>

 ��δ���ֵĲ�����Ϊ���󣨵�\ ``<action>``\ ����Ϊ\ ``error``\ ʱ�������������\
 ``<action>``\ ����Ϊ\ ``ignore``\ ʱ����

 ���δ�ҵ��κβ��ԣ�CTest��Ĭ����Ϊ��ʼ�ռ�¼������Ϣ�������ڽű�ģʽ�·��ش�����롣��ѡ��\
 ͨ����û���ҵ�����ʱ���ش��������������ͳһCTest����Ϊ��

 .. versionadded:: 3.26

 ���ѡ��Ҳ����ͨ������\ :envvar:`CTEST_NO_TESTS_ACTION`\ �������������á�

�鿴����
=========

Ҫ��ӡ�汾��ϸ��Ϣ���CMake�ĵ���ѡ���ҳ�棬ʹ������ѡ��֮һ��

.. include:: OPTIONS_HELP.txt

.. _`Label Matching`:

��ǩƥ��
==============

���Կ��ܸ��б�ǩ��ͨ��ɸѡ��ǩ�����Խ����԰����ڲ��������У�Ҳ���Խ������ų��ڲ��������С�ÿ\
�������Ĺ���������һ��������ʽ��Ӧ���ڸ��ӵ����Եı�ǩ��

��ʹ��\ :option:`-L <ctest -L>`\ ʱ��Ϊ�˽����԰����ڲ��������У�ÿ��������ʽ����ƥ��\
����һ����ǩ��ʹ�ö��\ :option:`-L <ctest -L>`\ ѡ����ζ�š�ƥ��\ **����**\ ��Щ����

:option:`-LE <ctest -LE>`\ ѡ��Ĺ���ԭ����\ :option:`-L <ctest -L>`\ ���ƣ������ų�\
���Զ����ǰ������ԡ����ÿ��������ʽƥ������һ����ǩ�����ų����ԡ�

���һ������û�и��ӱ�ǩ����ô\ :option:`-L <ctest -L>`\ ����Զ��������ò��ԣ�����\
:option:`-LE <ctest -LE>`\ ����Զ�����ų��ò��ԡ��Դ���ǩ�Ĳ���Ϊ��������������ԣ�����\
�������±�ǩ��

* *test1*\ ��\ *tuesday*\ ��\ *production*\ ��ǩ
* *test2*\ ��\ *tuesday*\ ��\ *test*\ ��ǩ
* *test3*\ ��\ *wednesday*\ ��\ *production*\ ��ǩ
* *test4*\ ��\ *wednesday*\ �ı�ǩ
* *test5*\ �б�ǩ\ *friday*\ ��\ *test*

��\ ``-L tuesday -L test``\ ��������\ :program:`ctest`����ѡ��\ *test2*������������ǩ��\
ʹ��\ ``-L test``\ ����CTest��ѡ��\ *test2*\ ��\ *test5*����Ϊ���Ƕ���һ����������ʽ\
ƥ��ı�ǩ��

��Ϊƥ��ʹ��������ʽ��������ע�⣬ʹ��\ ``-L es``\ ����CTest��ƥ������������ԡ���Ҫͬʱ\
ѡ��\ *tuesday*\ ��\ *wednesday*\ ���ԣ���ʹ��ƥ������һ���ĵ���������ʽ����\
``-L "tue|wed"``��

.. _`Label and Subproject Summary`:

��ǩ������ĿժҪ
============================

CTest��ӡ����������������ÿ��\ ``LABEL``\ ������Ŀ�ļ�ʱժҪ��Ϣ����ǩʱ��ժҪ��������ӳ\
�䵽����Ŀ�ı�ǩ��

.. versionadded:: 3.22
  �ڲ���ִ���ڼ䶯̬��ӵı�ǩҲ���ڼ�ʱժҪ�б��档�����\ :ref:`Additional Labels`��

�������� :prop_test:`PROCESSORS` ��������ʱ��CTest���ڱ�ǩ������ĿժҪ����ʾ��Ȩ���Լ�ʱ\
�����ʱ������\ `sec*proc`\ ����ģ�����������\ `sec`��

ÿ����ǩ������Ŀ\ ``j``\ ����ļ�Ȩʱ����ܼ���Ϊ��\ ::

  Weighted Time Summary for Label/Subproject j =
      sum(raw_test_time[j,i] * num_processors[j,i], i=1...num_tests[j])

  for labels/subprojects j=1...total

���У�

* ``raw_test_time[j,i]``�� ``j``\ ��ǩ������Ŀ��\ ``i``\ ���Ե�ʱ��ʱ��
* ``num_processors[j,i]``�� ����\ ``j``\ ��ǩ������Ŀ��\ ``i``\ ���Ե�CTest\
  :prop_test:`PROCESSORS`\ ���Ե�ֵ
* ``num_tests[j]``�� ��\ ``j``\ ��ǩ������Ŀ�����Ĳ�����
* ``total``�� ������һ���������еı�ǩ������Ŀ������

��ˣ�ÿ����ǩ������Ŀ�ļ�Ȩʱ��ժҪ��ʾCTestΪÿ����ǩ������Ŀ���в��������ѵ�ʱ����������\
�õر�ʾ����������ǩ������Ŀ��ȣ�ÿ����ǩ������Ŀ�Ĳ����ܷ��á�

���磬���\ ``SubprojectA``\ ��ʾ\ ``100 sec*proc``����\ ``SubprojectB``\ ��ʾ\
``10 sec*proc``����ôCTest�����Լ10����CPU/����ʱ��������\ ``SubprojectA``\ �Ĳ��ԣ�\
������\ ``SubprojectB``\ �Ĳ��ԣ����磬���Ҫ���Ѿ���������������Ŀ�����׼��ĳɱ�����ô����\
``SubprojectA``\ �����׼��ĳɱ����ܻ�ȼ���\ ``SubprojectB``\ �����׼��ĳɱ����������\
Ӱ�죩��

.. _`Build and Test Mode`:

�����Ͳ���ģʽ
===================

CTest�ṩ��һ��������ǩ�������ã�������cmake����������/��ִ�в��ԣ�\ ::

  ctest --build-and-test <path-to-source> <path-to-build>
        --build-generator <generator>
        [<options>...]
        [--build-options <opts>...]
        [--test-command <command> [<args>...]]

���úͲ��Բ����ǿ�ѡ�ġ��������еĲ�����ԴĿ¼�Ͷ�����Ŀ¼��\ *����*\ �ṩ\
``--build-generator``\ ѡ�����ʹ��\ ``--build-and-test``�����ָ����\
``--test-command``����ô�����ڹ�����ɺ����С�Ӱ���ģʽ������ѡ�������

.. option:: --build-and-test

 �л��������Ͳ���ģʽ��

.. option:: --build-target

 ָ��Ҫ�������ض�Ŀ�ꡣ����ʹ�ò�ͬ��Ŀ���θ�����ѡ�����������£����ι���ÿ��Ŀ�ꡣ����\
 ������\ :option:`--build-noclean`\ ѡ������ڹ���ÿ��Ŀ��֮ǰִ��һ������

 �����ָ��\ ``--build-target``���򹹽�\ ``all``\ Ŀ�ꡣ

.. option:: --build-nocmake

 ���й���������Ҫ������cmake��

 ����cmake���衣

.. option:: --build-run-dir

 ָ��Ҫ���г����Ŀ¼��

 �����������ڵ�Ŀ¼��

.. option:: --build-two-config

 ��������CMake��

.. option:: --build-exe-dir

 ָ����ִ���ļ���Ŀ¼��

.. option:: --build-generator

 ָ��Ҫʹ�õ��������������\ :manual:`cmake-generators(7)`\ �ֲᡣ

.. option:: --build-generator-platform

 ָ���ض�����������ƽ̨��

.. option:: --build-generator-toolset

 ָ���ض����������Ĺ��߼���

.. option:: --build-project

 ָ��Ҫ���ɵ���Ŀ�����ơ�

.. option:: --build-makeprogram

 ָ��CMake�����ú͹�����Ŀʱʹ�õ���ʽmake���򡣽������ڻ���Make��Ninja����������

.. option:: --build-noclean

 ���������衣

.. option:: --build-config-sample

 ����ȷ��Ӧ��ʹ�õ����õ�ʾ����ִ���ļ�������\ ``Debug``��\ ``Release``\ �ȡ�

.. option:: --build-options

 ���ù����ĸ���ѡ���CMake�������ǹ������ߣ���ע�⣬���ָ�������ѡ�\
 ``--build-options``\ �ؼ��ּ�������������������ϸ��������һ��ѡ����ܵ�������\
 ``--test-command``��

.. option:: --test-command

 ʹ��\ :option:`--build-and-test <ctest --build-and-test>`\ ѡ����Ϊ���Բ������е�\
 �������ؼ��ֺ�������в���������Ϊ��test�����е�һ���֣������������Ǹ��������һ��ѡ�

.. option:: --test-timeout

 ����Ϊ��λ��ʱ������

.. _`Dashboard Client`:

�Ǳ��ͻ���
================

CTest������Ϊ\ `CDash`_\ �������ָʾ��Ӧ�ó���Ŀͻ��˲�������Ϊ�Ǳ��ͻ�����CTestִ��\
һϵ�в��������á������Ͳ��������Ȼ�󽫽���ύ��CDash���������ύ��\ `CDash`_\ ��������\
ǩ���ǣ�\ ::

  ctest -D <dashboard>         [-- <dashboard-options>...]
  ctest -M <model> -T <action> [-- <dashboard-options>...]
  ctest -S <script>            [-- <dashboard-options>...]
  ctest -SP <script>           [-- <dashboard-options>...]

.. _`CDash`: https://www.cdash.org

�Ǳ��ͻ��˵�ѡ�������

.. option:: -D <dashboard>, --dashboard <dashboard>

 ִ���Ǳ����ԡ�

 ���ѡ�����CTest�䵱һ��CDash�ͻ��˲�ִ��һ��ָʾ����ԡ����в��Զ���\ ``<Mode><Test>``��\
 ����\ ``<Mode>``\ ������\ ``Experimental``��\ ``Nightly``\ ��\ ``Continuous``�� \
 ``<Test>``\ ������\ ``Start``��\ ``Update``��\ ``Configure``��\ ``Build``��\
 ``Test``��\ ``Coverage``\ ��\ ``Submit``��

 ���\ ``<dashboard>``\ ���ǿ�ʶ���\ ``<Mode><Test>``\ ֵ֮һ��������Ϊ�������壨��\
 ���������\ :ref:`dashboard-options <Dashboard Options>`����

.. option:: -M <model>, --test-model <model>

 ����ָʾ���ģ�͡�

 ���ѡ�����CTest�䵱һ��CDash�ͻ��ˣ�����\ ``<model>``\ ������\ ``Experimental``��\
 ``Nightly``\ ��\ ``Continuous``��\ ``-M``\ ��\ :option:`-T <ctest -T>`\ �������\
 ����\ :option:`-D <ctest -D>`��

.. option:: -T <action>, --test-action <action>

 ����Ҫִ�е�ָʾ�������

 ���ѡ�����CTest�䵱һ��CDash�ͻ��ˣ���ִ��һЩ��������\ ``start``��\ ``build``��\
 ``test``\ �ȡ��йز����������б������\ `�Ǳ��ͻ��˲���`_ ��\ :option:`-M <ctest -M>`\
 ��\ ``-T``\ �����������\ :option:`-D <ctest -D>`��

.. option:: -S <script>, --script <script>

 Ϊ����ִ��ָʾ�塣

 ���ѡ�����CTest����һ�����ýű����ýű�������һЩ����������������ļ���ԴĿ¼��Ȼ��\
 CTest��ִ�д����������Ǳ������Ĳ��������ѡ�������������һ��ָʾ�壬Ȼ��ʹ���ʵ���ѡ��\
 ����\ :option:`ctest -D`��

.. option:: -SP <script>, --script-new-process <script>

 Ϊ����ִ��ָʾ�塣

 ��ѡ��ִ����\ :option:`-S <ctest -S>`\ ��ͬ�Ĳ������������ڵ����Ľ�����ִ�С����ű�����\
 ���޸Ļ��������㲻ϣ���޸ĺ�Ļ���Ӱ������\ :option:`-S <ctest -S>`\ �ű�ʱ���൱���á�

.. _`Dashboard Options`:

���õ�\ ``<dashboard-options>``\ ���£�

.. option:: -D <var>:<type>=<value>

 Ϊ�ű�ģʽ���������

 ���������ϴ��ݱ���ֵ����\ :option:`-S <ctest -S>`\ һ��ʹ�ÿɽ�����ֵ���ݸ�ָʾ��ű���\
 ֻ�е�\ ``-D``\ �����ֵ���κ���֪��ָʾ�����Ͳ�ƥ��ʱ���Ż᳢�Խ�\ ``-D``\ ��������Ϊ��\
 ��ֵ��

.. option:: --group <group>

 ָ��Ҫ������ύ���ĸ���

 �ύ�Ǳ�嵽ָ���飬������Ĭ���顣Ĭ������£��Ǳ�屻�ύ��Nightly��Experimental��\
 Continuous�飬��ͨ��ָ����ѡ��������������ġ�

 �⽫ȡ�������õ�ѡ��\ ``--track``���������Ƹı���������Ϊ�ǲ���ġ�

.. option:: -A <file>, --add-notes <file>

 ��Ӵ����ύ��ע���ļ���

 ���ѡ�����CTest���ύָʾ��ʱ����һ��ע���ļ���

.. option:: --tomorrow-tag

 ``Nightly``\ ��\ ``Experimental``\ ��ʼ��ڶ����ǩ��

 �������������һ������ɣ����Ǻ����õġ�

.. option:: --extra-submit <file>[;<file>]

 ���Ǳ���ύ������ļ���

 ��ѡ���ָʾ���ύ������ļ���

.. option:: --http-header <header>

 .. versionadded:: 3.29

 �ύ���Ǳ��ʱ����HTTPͷ��

 ���ѡ�����CTest���ύ���Ǳ��ʱ����ָ����ͷ����ѡ�����ָ����Ρ�

.. option:: --http1.0

 ʹ��\ `HTTP 1.0`\ �ύ��

 ���ѡ�ǿ��CTestʹ��\ `HTTP 1.0`\ ���Ǳ���ύ�ļ���������\ `HTTP 1.1`��

.. option:: --no-compress-output

 �ύʱ��Ҫѹ�����������

 �˱�־���رղ���������Զ�ѹ����ʹ�������Ա�����ɰ汾��CDash�ļ����ԣ��ð汾��֧��ѹ������\
 �����

�Ǳ��ͻ��˲���
----------------------

CTest������һ������Ĳ��Բ����б�����һЩ��ȫ��������Ϊ�Ǳ��ͻ������У�

``Start``
  ����һ���µ��Ǳ���ύ�������²����¼�Ľ����ɡ�����������\ `CTest��ʼ����`_\ �½ڡ�

``Update``
  ����汾���ƴ洢�����Դ����������¼�¾ɰ汾�͸��µ�Դ�ļ��б�����������\
  `CTest���²���`_\ �½ڡ�

``Configure``
  ͨ���ڹ����������������������������¼���������־������������\ `CTest���ò���`_\ �½ڡ�

``Build``
  ͨ���ڹ����������������������������¼���������־����⾯��ʹ�������������\
  `CTest��������`_\ ���֡�

``Test``
  ͨ���ӹ������м���\ ``CTestTestfile.cmake``\ ��ִ�ж���Ĳ����������������¼ÿ�β���\
  ������ͽ��������������\ `CTest���Բ���`_\ �½ڡ�

``Coverage``
  ͨ�����и����ʷ������߲���¼�����������Դ����ĸ����ʡ�����������\ `CTest���ǲ���`_\
  �½ڡ�

``MemCheck``
  ͨ���ڴ��鹤��������������׼�����¼���߱���Ĳ����������������⡣����������\
  `CTest�ڴ���Բ���`_\ �½ڡ�

``Submit``
  ���������Բ����¼�Ľ���ύ����������Ǳ�������������������\ `CTest�ύ����`_\ �½ڡ�

�Ǳ��ͻ���ģʽ
----------------------

CTest��Ϊ�Ǳ��ͻ��˶��������ֲ���ģʽ��

``Nightly``
  ��ģʽ����ÿ�����һ�Σ�ͨ�������ϡ�Ĭ������£�������\ ``Start``��\ ``Update``��\
  ``Configure``��\ ``Build``��\ ``Test``��\ ``Coverage``\ ��\ ``Submit``\ ���衣\
  ��ʹ\ ``Update``\ ����û����Դ�������κθ��ģ�Ҳ��������ѡ���衣

``Continuous``
  ��ģʽ������һ���з������á�Ĭ������£�������\ ``Start``��\ ``Update``��\
  ``Configure``��\ ``Build``��\ ``Test``��\ ``Coverage``\ ��\ ``Submit``\ ���裬\
  ���������û����Դ�����������κθ��ģ�����\ ``Update``\ ����֮���˳���

``Experimental``
  ��ģʽּ���ɿ�����Ա�����Բ��Ա��ظ��ġ�Ĭ������£�������\ ``Start``��\ ``Configure``��\
  ``Build``��\ ``Test``��\ ``Coverage``\ ��\ ``Submit``\ ���衣

ͨ��CTest�����������Ǳ��ͻ���
---------------------------------------

CTest�������Ѿ����ɵĹ�������ִ�в��ԡ�����\ :program:`ctest`\ �������ǰ����Ŀ¼����\
Ϊ����������ʹ����\
��ǩ��֮һ��\ ::

  ctest -D <mode>[<step>]
  ctest -M <mode> [-T <step>]...

``<mode>``\ ����������\ `�Ǳ��ͻ���ģʽ`_\ ֮һ��ÿ��\ ``<step>``\ ����������\
`�Ǳ��ͻ��˲���`_\ ֮һ��

CTest�ӹ������е�һ����Ϊ\ ``CTestConfiguration.ini``\ ��\ ``DartConfiguration.tcl``\
����������ʷ�ģ����ļ��ж�ȡ\ `�Ǳ��ͻ�������`_\ ���á��ļ���ʽΪ��\ ::

  # Lines starting in '#' are comments.
  # Other non-blank lines are key-value pairs.
  <setting>: <value>

����\ ``<setting>``\ Ϊ�������ƣ�\ ``<value>``\ Ϊ����ֵ��

��CMake���ɵĹ������У���������ļ�����\ :module:`CTest`\ ģ�����ɵģ������������Ŀ�С�\
��ģ��ʹ�ñ�����ȡÿ�����õ�ֵ��������������ĵ���ʾ��

.. _`CTest Script`:

ͨ��CTest�ű������Ǳ��ͻ���
---------------------------------

CTest����ִ����\ :manual:`cmake-language(7)`\ �ű������Ĳ��ԣ��ýű�������ά��Դ�����\
���������Լ�ִ�в��Բ��衣����\ :program:`ctest`\ �������ǰ����Ŀ¼�������κι�����֮�⣬\
��ʹ������ǩ��֮һ��\ ::

  ctest -S <script>
  ctest -SP <script>

``<script>``\ �ļ��������\ :ref:`CTest Commands`\ ��������ʽ�����в��Բ��裬������ʾ��\
��Щ��������ǵĲ�����ű������õı����л�ȡ\ `�Ǳ��ͻ�������`_\ ���á�

�Ǳ��ͻ�������
==============================

`�Ǳ��ͻ��˲���`_\ �������ͨ�����²����м�¼���������ý������á�

.. _`CTest Start Step`:

CTest��ʼ����
----------------

����һ���µ��Ǳ���ύ�������²����¼�Ľ����ɡ�

��\ `CTest Script`_\ �У�\ :command:`ctest_start`\ �������д˲��衣����Ĳ�������ָ��\
һЩ�������á���������������\ ``CTEST_CHECKOUT_COMMAND`` \��������������ˣ�ָ���������У�\
�Գ�ʼ��ԴĿ¼��

�������ð�����

``BuildDirectory``
  ��Ŀ������������·����

  * `CTest Script`_\ ������:variable:`CTEST_BINARY_DIRECTORY`
  * :module:`CTest`\ ������:variable:`PROJECT_BINARY_DIR`

``SourceDirectory``
  ��ĿԴ������������·����

  * `CTest Script`_\ ������:variable:`CTEST_SOURCE_DIRECTORY`
  * :module:`CTest`\ ������:variable:`PROJECT_SOURCE_DIR`

.. _`CTest Update Step`:

CTest���²���
-----------------

��\ `CTest Script`_\ �У�\ :command:`ctest_update`\ �������д˲��衣����Ĳ�������ָ\
��һЩ�������á�

ָ���汾���ƹ��ߵ��������ð�����

``BZRCommand``
  ���Դ��������Bazaar������ʹ��\ ``bzr``\ �����й��ߡ�

  * `CTest Script`_\ ������:variable:`CTEST_BZR_COMMAND`
  * :module:`CTest`\ ��������

``BZRUpdateOptions``
  �ڸ���Դ����ʱ����������ѡ������Ϊ\ ``BZRCommand``��

  * `CTest Script`_\ ������:variable:`CTEST_BZR_UPDATE_OPTIONS`
  * :module:`CTest`\ ��������

``CVSCommand``
  ���Դ��������CVS������ʹ��\ ``cvs``\ �����й��ߡ�

  * `CTest Script`_\ ������:variable:`CTEST_CVS_COMMAND`
  * :module:`CTest`\ ������\ ``CVSCOMMAND``

``CVSUpdateOptions``
  �ڸ���Դ����ʱ����������ѡ������Ϊ\ ``CVSCommand``��

  * `CTest Script`_\ ������:variable:`CTEST_CVS_UPDATE_OPTIONS`
  * :module:`CTest`\ ������\ ``CVS_UPDATE_OPTIONS``

``GITCommand``
  ``git``\ �����й��ߣ����Դ����������Git����ġ�

  * `CTest Script`_\ ������:variable:`CTEST_GIT_COMMAND`
  * :module:`CTest`\ ������\ ``GITCOMMAND``

  Դ������ͨ��\ ``git fetch``\ ���£�Ȼ��\ ``git reset --hard``\ ���µ�\ ``FETCH_HEAD``��\
  �����\ ``git pull``\ ��ͬ��ֻ�����еı����޸Ķ��ᱻ���ǡ�ʹ��\ ``GITUpdateCustom``\
  ��ָ����ͬ�ķ�����

``GITInitSubmodules``
  ��������ˣ�CTest���ڸ���֮ǰ���´洢�����ģ�顣

  * `CTest Script`_\ ������:variable:`CTEST_GIT_INIT_SUBMODULES`
  * :module:`CTest`\ ������\ ``CTEST_GIT_INIT_SUBMODULES``

``GITUpdateCustom``
  ָ��һ���Զ��������У��Էֺŷָ����б���ʽ����Դ��������Git���������������Ը�������������\
  ����\ ``GITCommand``��

  * `CTest Script`_\ ������:variable:`CTEST_GIT_UPDATE_CUSTOM`
  * :module:`CTest`\ ������\ ``CTEST_GIT_UPDATE_CUSTOM``

``GITUpdateOptions``
  �ڸ���Դ����ʱ����������ѡ������Ϊ\ ``GITCommand``��

  * `CTest Script`_\ ������:variable:`CTEST_GIT_UPDATE_OPTIONS`
  * :module:`CTest`\ ������\ ``GIT_UPDATE_OPTIONS``

``HGCommand``
  ���Դ��������Mercurial������ʹ��\ ``hg``\ �����й��ߡ�

  * `CTest Script`_\ ������:variable:`CTEST_HG_COMMAND`
  * :module:`CTest`\ ��������

``HGUpdateOptions``
  �ڸ���Դ����ʱ����������ѡ������Ϊ\ ``HGCommand``��

  * `CTest Script`_\ ������:variable:`CTEST_HG_UPDATE_OPTIONS`
  * :module:`CTest`\ ��������

``P4Client``
  ``P4Command``\ ��\ ``-c``\ ѡ���ֵ��

  * `CTest Script`_\ ������:variable:`CTEST_P4_CLIENT`
  * :module:`CTest`\ ������\ ``CTEST_P4_CLIENT``

``P4Command``
  ``p4``\ �����й��ߣ����Դ����������Perforce����

  * `CTest Script`_\ ������:variable:`CTEST_P4_COMMAND`
  * :module:`CTest`\ ������\ ``P4COMMAND``

``P4Options``
  ``P4Command``\ ��������ѡ��������е��á�

  * `CTest Script`_\ ������:variable:`CTEST_P4_OPTIONS`
  * :module:`CTest`\ ������\ ``CTEST_P4_OPTIONS``

``P4UpdateCustom``
  ָ��Ҫ��Դ����Perforce���������е��Զ��������У��Էֺŷָ����б���ʽ��������Դ����������\
  ����\ ``P4Command``��

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ������\ ``CTEST_P4_UPDATE_CUSTOM``

``P4UpdateOptions``
  �ڸ���Դ����ʱ��������ѡ������Ϊ\ ``P4Command`` ��

  * `CTest Script`_\ ������:variable:`CTEST_P4_UPDATE_OPTIONS`
  * :module:`CTest`\ ������\ ``CTEST_P4_UPDATE_OPTIONS``

``SVNCommand``
  ``svn``\ �����й��ߣ����Դ����������Subversion����ġ�

  * `CTest Script`_\ ������:variable:`CTEST_SVN_COMMAND`
  * :module:`CTest`\ ������\ ``SVNCOMMAND``

``SVNOptions``
  ``SVNCommand``\ ���е��õ�������ѡ�

  * `CTest Script`_\ ������:variable:`CTEST_SVN_OPTIONS`
  * :module:`CTest`\ ������\ ``CTEST_SVN_OPTIONS``

``SVNUpdateOptions``
  ����Դʱ��\ ``SVNCommand``\ ��������ѡ�

  * `CTest Script`_\ ������:variable:`CTEST_SVN_UPDATE_OPTIONS`
  * :module:`CTest`\ ������\ ``SVN_UPDATE_OPTIONS``

``UpdateCommand``
  ָ��Ҫʹ�õİ汾���������й��ߣ�����������Դ��������VCS��

  * `CTest Script`_\ ������:variable:`CTEST_UPDATE_COMMAND`
  * :module:`CTest`\ ��������\ ``UPDATE_TYPE``\ Ϊ\ ``<vcs>``\ ʱΪ\
    ``<VCS>COMMAND``������Ϊ\ ``UPDATE_COMMAND``

``UpdateOptions``
  ``UpdateCommand``\ ��������ѡ�

  * `CTest Script`_\ ������:variable:`CTEST_UPDATE_OPTIONS`
  * :module:`CTest`\ ��������\ ``UPDATE_TYPE``\ Ϊ\ ``<vcs>``\ ʱΪ\
    ``<VCS>_UPDATE_OPTIONS``������Ϊ\ ``UPDATE_OPTIONS``

``UpdateType``
  ����޷��Զ���⵽Դ����������ָ�������Դ�������İ汾����ϵͳ��ȡֵΪ\ ``bzr``��\ ``cvs``��\
  ``git``��\ ``hg``��\ ``p4``\ ��\ ``svn``��

  * `CTest Script`_\ �������ޣ���Դ���������
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``UPDATE_TYPE``������Ϊ\
    ``CTEST_UPDATE_TYPE``

.. _`UpdateVersionOnly`:

``UpdateVersionOnly``
  ָ��ϣ���汾���Ƹ�������ֻ����ǩ���ĵ�ǰ�汾���������µ���ͬ�İ汾��

  * `CTest Script`_\ ������:variable:`CTEST_UPDATE_VERSION_ONLY`

.. _`UpdateVersionOverride`:

``UpdateVersionOverride``
  ָ��Դ�������ĵ�ǰ�汾��

  �����ñ�������Ϊ�ǿ��ַ���ʱ��CTest��������ָ����ֵ��������ʹ��update�����������Ѽ����\
  ��ǰ�汾�����������ʹ��ȡ����\ ``UpdateVersionOnly``����\ ``UpdateVersionOnly``\
  һ����ʹ�������������CTest��Ҫ��Դ������Ϊ��ͬ�İ汾��

  * `CTest Script`_\ ������:variable:`CTEST_UPDATE_VERSION_OVERRIDE`

�����������ð�����

``NightlyStartTime``
  ��\ ``Nightly``\ �Ǳ��ģʽ�£�ָ����ҹ�俪ʼʱ�䡱��ʹ�ü���ʽ�汾����ϵͳ��\ ``cvs``\
  ��\ ``svn``����\ ``Update``\ ���������ʱ������汾���Ա����ͻ���ѡ��һ��ͨ�ð汾\
  ���в��ԡ����ڷֲ�ʽ�汾����ϵͳ��û����ȷ���壬��˸����ñ����ԡ�

  * `CTest Script`_\ ������:variable:`CTEST_NIGHTLY_START_TIME`
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``NIGHTLY_START_TIME``������Ϊ\
    ``CTEST_NIGHTLY_START_TIME``

.. _`CTest Configure Step`:

CTest���ò���
--------------------

��\ `CTest Script`_\ �У�\ :command:`ctest_configure`\ �������д˲��衣����Ĳ�����\
��ָ��һЩ�������á�

�������ð�����

``ConfigureCommand``
  ����������������ù��̡�������\ ``BuildDirectory``\ ����ָ����λ��ִ�С�

  * `CTest Script`_\ ������:variable:`CTEST_CONFIGURE_COMMAND`
  * :module:`CTest`\ ������:variable:`CMAKE_COMMAND`���������\
    :variable:`PROJECT_SOURCE_DIR`

``LabelsForSubprojects``
  ָ��һ���ֺŷָ��ı�ǩ�б���Щ��ǩ������Ϊ����Ŀ�����ύ���á����Ի򹹽����ʱ����ӳ�佫\
  ���ݸ�CDash��

  * `CTest Script`_\ ������:variable:`CTEST_LABELS_FOR_SUBPROJECTS`
  * :module:`CTest`\ ������\ ``CTEST_LABELS_FOR_SUBPROJECTS``

  �����\ `��ǩ������ĿժҪ`_��

.. _`CTest Build Step`:

CTest��������
----------------

��\ `CTest Script`_\ �У�\ :command:`ctest_build`\ �������д˲��衣����Ĳ�������ָ��\
һЩ�������á�

�������ð�����

``DefaultCTestConfigurationType``
  ��Ҫ�����Ĺ���ϵͳ�����ڹ���ʱѡ�����ã�����\ ``Debug``��\ ``Release``��ʱ����ָ������\
  û�и�\ :program:`ctest`\ ����\ :option:`-C <ctest -C>`\ ѡ��ʱҪ������Ĭ�����á�\
  ������֣���ֵ�����滻Ϊ\ ``MakeCommand``\ ��ֵ�����滻�����ַ���\
  ``${CTEST_CONFIGURATION_TYPE}`` ��

  * `CTest Script`_\ ������:variable:`CTEST_CONFIGURATION_TYPE`
  * :module:`CTest`\ ������\ ``DEFAULT_CTEST_CONFIGURATION_TYPE``����\
    :envvar:`CMAKE_CONFIG_TYPE`\ ����������ʼֵ�� 

``LabelsForSubprojects``
  ָ��һ���ֺŷָ��ı�ǩ�б���Щ��ǩ������Ϊ����Ŀ�����ύ���á����Ի򹹽����ʱ����ӳ�佫\
  ���ݸ�CDash��

  * `CTest Script`_\ ������:variable:`CTEST_LABELS_FOR_SUBPROJECTS`
  * :module:`CTest`\ ������\ ``CTEST_LABELS_FOR_SUBPROJECTS``

  �����\ `��ǩ������ĿժҪ`_��

``MakeCommand``
  ��������������������̡�������\ ``BuildDirectory``\ ����ָ����λ��ִ�С�

  * `CTest Script`_\ ������:variable:`CTEST_BUILD_COMMAND`
  * :module:`CTest`\ ������\ ``MAKECOMMAND``����\
    :command:`build_command`\ �����ʼֵ�� 

``UseLaunchers``
  ����ʹ��\ :ref:`Makefile Generators`\ ��\ :generator:`Ninja`\ ������֮һ��CMake��\
  �ɵĹ�������ָ��\ ``CTEST_USE_LAUNCHERS``\ �����Ƿ�\ :module:`CTestUseLaunchers`\
  ģ�飨Ҳ������\ :module:`CTest`\ ģ���У����á�������ʱ�����ɵĹ���ϵͳ����������������\
  ���Զ��������е�ÿ�ε��ð�װΪһ���������������á���������ͨ�������������ļ���CTestͨ�ţ��Ա�\
  �����ȹ�������ʹ�����Ϣ������CTest���롰ץȡ�����������־�Խ�����ϡ�

  * `CTest Script`_\ ������:variable:`CTEST_USE_LAUNCHERS`
  * :module:`CTest`\ ������\ ``CTEST_USE_LAUNCHERS``

.. _`CTest Test Step`:

CTest���Բ���
---------------

��\ `CTest Script`_\ �У�\ :command:`ctest_test`\ �������д˲��衣����Ĳ�������ָ��\
һЩ�������á�

�������ð�����

``ResourceSpecFile``
  ָ��\ :ref:`��Դ�淶�ļ� <ctest-resource-specification-file>`��

  * `CTest Script`_\ ������:variable:`CTEST_RESOURCE_SPEC_FILE`
  * :module:`CTest`\ ������\ ``CTEST_RESOURCE_SPEC_FILE``

  �йظ�����Ϣ����μ�\ :ref:`ctest-resource-allocation`��

``LabelsForSubprojects``
  ָ��һ���ֺŷָ��ı�ǩ�б���Щ��ǩ������Ϊ����Ŀ�����ύ���á����Ի򹹽����ʱ����ӳ�佫\
  ���ݸ�CDash��

  * `CTest Script`_\ ������:variable:`CTEST_LABELS_FOR_SUBPROJECTS`
  * :module:`CTest`\ ������\ ``CTEST_LABELS_FOR_SUBPROJECTS``

  �����\ `��ǩ������ĿժҪ`_��

``TestLoad``
  �ڲ������в���ʱ������ʹ��\ :option:`-j <ctest -j>`���������Կ��ܵ���CPU���س���������\
  ֵʱ��������Ҫ�������ԡ�

  * `CTest Script`_\ ������:variable:`CTEST_TEST_LOAD`
  * :module:`CTest`\ ������\ ``CTEST_TEST_LOAD``

``TimeOut``
  ���δ��\ :prop_test:`TIMEOUT`\ ���Ի���\ :option:`--timeout <ctest --timeout>`\
  ��ʶָ������Ϊÿ�����Ե�Ĭ�ϳ�ʱ��

  * `CTest Script`_\ ������:variable:`CTEST_TEST_TIMEOUT`
  * :module:`CTest`\ ������\ ``DART_TESTING_TIMEOUT``

Ҫ��CDash�������Ĳ���ֵ�������\ :ref:`Additional Test Measurements`��

.. _`CTest Coverage Step`:

CTest���ǲ���
-------------------

��\ `CTest Script`_\ �У�\ :command:`ctest_coverage`\ ��������������衣����Ĳ�����\
��ָ��һЩ�������á�

�������ð�����

``CoverageCommand``
  ִ����������ʷ����������й��ߡ�������\ ``BuildDirectory``\ ����ָ����λ��ִ�С�

  * `CTest Script`_\ ������:variable:`CTEST_COVERAGE_COMMAND`
  * :module:`CTest`\ ������\ ``COVERAGE_COMMAND``

``CoverageExtraFlags``
  Ϊ\ ``CoverageCommand``\ ����ָ��������ѡ�

  * `CTest Script`_\ ������:variable:`CTEST_COVERAGE_EXTRA_FLAGS`
  * :module:`CTest`\ ������\ ``COVERAGE_EXTRA_FLAGS``

  ��Щѡ���Ǵ��ݸ�\ ``CoverageCommand``\ �ĵ�һ��������

.. _`CTest MemCheck Step`:

CTest�ڴ���Բ���
-------------------

��\ `CTest Script`_\ �У�\ :command:`ctest_memcheck`\ �������д˲��衣����Ĳ�������\
ָ��һЩ�������á�

�������ð�����

``MemoryCheckCommand``
  ִ�ж�̬�����������й��ߡ����������н�ͨ���������������

  * `CTest Script`_\ ������:variable:`CTEST_MEMORYCHECK_COMMAND`
  * :module:`CTest`\ ������\ ``MEMORYCHECK_COMMAND``

``MemoryCheckCommandOptions``
  Ϊ\ ``MemoryCheckCommand``\ ����ָ��������ѡ����ǽ��������ڲ���������֮ǰ��

  * `CTest Script`_\ ������:variable:`CTEST_MEMORYCHECK_COMMAND_OPTIONS`
  * :module:`CTest`\ ������\ ``MEMORYCHECK_COMMAND_OPTIONS``

``MemoryCheckType``
  ָ��Ҫִ�е��ڴ������͡�

  * `CTest Script`_\ ������:variable:`CTEST_MEMORYCHECK_TYPE`
  * :module:`CTest`\ ������\ ``MEMORYCHECK_TYPE``

``MemoryCheckSanitizerOptions``
  ��ʹ��������ɱ�����ܵĹ�������ʱ��ָ��ɱ�����ܵ�ѡ�

  * `CTest Script`_\ ������:variable:`CTEST_MEMORYCHECK_SANITIZER_OPTIONS`
  * :module:`CTest`\ ������\ ``MEMORYCHECK_SANITIZER_OPTIONS``

``MemoryCheckSuppressionFile``
  ָ������\ ``MemoryCheckCommand``\ �������ƹ�����ļ����������ʺ��ڹ��ߵ�ѡ��һ�𴫵ݡ�

  * `CTest Script`_\ ������:variable:`CTEST_MEMORYCHECK_SUPPRESSIONS_FILE`
  * :module:`CTest`\ ������\ ``MEMORYCHECK_SUPPRESSIONS_FILE``

�����������ð�����

``BoundsCheckerCommand``
  ָ����֪��߽��������ݵ�������\ ``MemoryCheckCommand``��

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ��������

``PurifyCommand``
  ָ��һ����֪��Purify�����м��ݵ�\ ``MemoryCheckCommand``��

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ������\ ``PURIFYCOMMAND``

``ValgrindCommand``
  ָ��һ����֪��Valgrind�����м��ݵ�\ ``MemoryCheckCommand``��

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ������\ ``VALGRIND_COMMAND``

``ValgrindCommandOptions``
  Ϊ\ ``ValgrindCommand``\ ����ָ��������ѡ����ǽ��������ڲ���������֮ǰ��

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ������\ ``VALGRIND_COMMAND_OPTIONS``

``DrMemoryCommand``
  ָ��һ����֪��DrMemory���ݵ�������\ ``MemoryCheckCommand``��

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ������\ ``DRMEMORY_COMMAND``

``DrMemoryCommandOptions``
  Ϊ\ ``DrMemoryCommand``\ ����ָ��������ѡ����ǽ��������ڲ���������֮ǰ��

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ������\ ``DRMEMORY_COMMAND_OPTIONS``

``CudaSanitizerCommand``
  ָ��һ��\ ``MemoryCheckCommand``����֪������cuda-memcheck��compute-sanitizer����\
  �������С�

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ������\ ``CUDA_SANITIZER_COMMAND``

``CudaSanitizerCommandOptions``
  Ϊ\ ``CudaSanitizerCommand``\ ����ָ��������ѡ����ǽ��������ڲ���������֮ǰ��

  * `CTest Script`_\ ��������
  * :module:`CTest`\ ������\ ``CUDA_SANITIZER_COMMAND_OPTIONS``

.. _`CTest Submit Step`:

CTest�ύ����
-----------------

��\ `CTest Script`_\ �У�\ :command:`ctest_submit`\ �������д˲��衣����Ĳ�������ָ\
��һЩ�������á�

�������ð�����

``BuildName``
  ��һ�����ַ��������Ǳ��ͻ���ƽ̨��������ϵͳ���������ȣ�

  * `CTest Script`_\ ������:variable:`CTEST_BUILD_NAME`
  * :module:`CTest`\ ������\ ``BUILDNAME``

``CDashVersion``
  ������ѡ����á�

  * `CTest Script`_\ �������ޣ��ɷ��������
  * :module:`CTest`\ ������\ ``CTEST_CDASH_VERSION``

``CTestSubmitRetryCount``
  ָ�����������ʱ�����ύ�Ĵ�����

  * `CTest Script`_\ �������ޣ�ʹ��\ :command:`ctest_submit` ``RETRY_COUNT``\ ѡ�
  * :module:`CTest`\ ������\ ``CTEST_SUBMIT_RETRY_COUNT``

``CTestSubmitRetryDelay``
  ָ�����������ʱ�����ύ֮ǰ���ӳ١�

  * `CTest Script`_\ �������ޣ�ʹ��\ :command:`ctest_submit` ``RETRY_DELAY``\ ѡ�
  * :module:`CTest`\ ������\ ``CTEST_SUBMIT_RETRY_DELAY``

``CurlOptions``
  .. deprecated:: 3.30

    Use ``TLSVerify`` instead.

  Specify a semicolon-separated list of options to control the
  Curl library that CTest uses internally to connect to the
  server.

  * `CTest Script`_\ ������:variable:`CTEST_CURL_OPTIONS`
  * :module:`CTest`\ ������\ ``CTEST_CURL_OPTIONS``

  Possible options are:

  ``CURLOPT_SSL_VERIFYPEER_OFF``
    Disable the ``CURLOPT_SSL_VERIFYPEER`` curl option.

  ``CURLOPT_SSL_VERIFYHOST_OFF``
    Disable the ``CURLOPT_SSL_VERIFYHOST`` curl option.

``DropLocation``
  ������ѡ�񡣵�δ���� ``SubmitURL`` ʱ������\ ``DropMethod``��\ ``DropSiteUser``��\
  ``DropSitePassword``��\ ``DropSite``\ ��\ ``DropLocation``\ ���졣

  * `CTest Script`_\ ������:variable:`CTEST_DROP_LOCATION`
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``DROP_LOCATION``������\
    ``CTEST_DROP_LOCATION``

``DropMethod``
  ������ѡ�񡣵�δ���� ``SubmitURL`` ʱ������\ ``DropMethod``��\ ``DropSiteUser``��\
  ``DropSitePassword``��\ ``DropSite``\ ��\ ``DropLocation``\ ���졣

  * `CTest Script`_\ ������:variable:`CTEST_DROP_METHOD`
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``DROP_METHOD``������\
    ``CTEST_DROP_METHOD``

``DropSite``
  ������ѡ�񡣵�δ���� ``SubmitURL`` ʱ������\ ``DropMethod``��\ ``DropSiteUser``��\
  ``DropSitePassword``��\ ``DropSite``\ ��\ ``DropLocation``\ ���졣

  * `CTest Script`_\ ������:variable:`CTEST_DROP_SITE`
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``DROP_SITE``������\ ``CTEST_DROP_SITE``

``DropSitePassword``
  ������ѡ�񡣵�δ���� ``SubmitURL`` ʱ������\ ``DropMethod``��\ ``DropSiteUser``��\
  ``DropSitePassword``��\ ``DropSite``\ ��\ ``DropLocation``\ ���졣

  * `CTest Script`_\ ������:variable:`CTEST_DROP_SITE_PASSWORD`
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``DROP_SITE_PASSWORD``������\
    ``CTEST_DROP_SITE_PASWORD``

``DropSiteUser``
  ������ѡ�񡣵�δ���� ``SubmitURL`` ʱ������\ ``DropMethod``��\ ``DropSiteUser``��\
  ``DropSitePassword``��\ ``DropSite``\ ��\ ``DropLocation``\ ���졣

  * `CTest Script`_\ ������:variable:`CTEST_DROP_SITE_USER`
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``DROP_SITE_USER``������\
    ``CTEST_DROP_SITE_USER``

``IsCDash``
  ������ѡ����á�

  * `CTest Script`_\ ������:variable:`CTEST_DROP_SITE_CDASH`
  * :module:`CTest`\ ������\ ``CTEST_DROP_SITE_CDASH``

``ScpCommand``
  ������ѡ����á�

  * `CTest Script`_\ ������:variable:`CTEST_SCP_COMMAND`
  * :module:`CTest`\ ������\ ``SCPCOMMAND``

``Site``
  �ö��ַ��������Ǳ��ͻ�������վ�㡣���������������ȣ�

  * `CTest Script`_\ ������:variable:`CTEST_SITE`
  * :module:`CTest`\ ������\ ``SITE``����\ :command:`site_name`\ �����ʼֵ�� 

``SubmitURL``
  ���ύ���͵����Ǳ���������\ ``http``\ ��\ ``https`` URL��

  * `CTest Script`_\ ������:variable:`CTEST_SUBMIT_URL`
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``SUBMIT_URL``������\ ``CTEST_SUBMIT_URL``

``SubmitInactivityTimeout``
  �ȴ��ύ��ʱ�䣬����ύδ��ɣ��ύ����ȡ����ָ��һ����ֵ�����ó�ʱ��

  * `CTest Script`_\ ������:variable:`CTEST_SUBMIT_INACTIVITY_TIMEOUT`
  * :module:`CTest`\ ������\ ``CTEST_SUBMIT_INACTIVITY_TIMEOUT``

``TLSVersion``
  .. versionadded:: 3.30

  Specify a minimum TLS version allowed when submitting to a dashboard
  via ``https://`` URLs.

  * `CTest Script`_ variable: :variable:`CTEST_TLS_VERSION`
  * :module:`CTest` module variable: ``CTEST_TLS_VERSION``

``TLSVerify``
  .. versionadded:: 3.30

  Specify a boolean value indicating whether to verify the server
  certificate when submitting to a dashboard via ``https://`` URLs.

  * `CTest Script`_ variable: :variable:`CTEST_TLS_VERIFY`
  * :module:`CTest` module variable: ``CTEST_TLS_VERIFY``

``TriggerSite``
  ������ѡ����á�

  * `CTest Script`_\ ������:variable:`CTEST_TRIGGER_SITE`
  * :module:`CTest`\ ��������������ˣ���Ϊ\ ``TRIGGER_SITE``������\
    ``CTEST_TRIGGER_SITE``

.. _`Show as JSON Object Model`:

��ʾΪJSON����ģ��
=========================

.. versionadded:: 3.14

������\ ``--show-only=json-v1``\ ������ѡ��ʱ��������Ϣ��JSON��ʽ������汾1.0��JSON��\
��ģ�Ͷ������£�

``kind``
  �ַ�����ctestInfo����

``version``
  ָ���汾�����JSON�������Ա��

  ``major``
    һ���Ǹ�������ָ�����汾�����
  ``minor``
    ָ����Ҫ�汾����ķǸ�������

``backtraceGraph``
    JSON����ʹ�����³�Ա��ʾ������Ϣ��

    ``commands``
      ���������б�
    ``files``
      �ļ����б�
    ``nodes``
      ������Ա�Ľڵ�JSON�����б�

      ``command``
        ������\ ``backtraceGraph``\ ��\ ``commands``\ ��Ա��
      ``file``
        ������\ ``backtraceGraph``\ ��\ ``files``\ ��Ա��
      ``line``
        ��ӻ��ݵ��ļ��е��кš�
      ``parent``
        ��������ʾͼ�и��ڵ��\ ``backtraceGraph``\ ��\ ``nodes``\ ��Ա��

``tests``
  һ��JSON���飬�г�����ÿ�����Ե���Ϣ��ÿ����Ŀ����һ��JSON���󣬰������³�Ա��

  ``name``
    �������ơ�
  ``config``
    ���Կ������е����á����ַ�����ʾ�κ����á�
  ``command``
    �б����е�һ��Ԫ���ǲ����������Ԫ�������������
  ``backtrace``
    ������\ ``backtraceGraph``\ ��\ ``nodes``\ ��Ա��
  ``properties``
    �������ԡ����԰���ÿ��֧�ֵĲ������Եļ���

.. _`ctest-resource-allocation`:

��Դ����
===================

CTestΪ�����ṩ��һ�ֻ��ƣ���ϸ���ȵķ�ʽָ�������������Դ����Ϊ�û�ָ���������еĻ����Ͽ�\
�õ���Դ��������CTest���ڲ�������Щ��Դ����ʹ�ã���Щ��Դ�ǿ��еģ���һ�ַ�ֹ������ͼ������\
���õ���Դ�ķ�ʽ���Ȳ��ԡ�

��ʹ����Դ��������ʱ��CTest������ȶ�����Դ�����磬���һ����Դ��8����ۣ�CTest����������һ\
���ܹ�ʹ�ó���8����۵Ĳ��ԡ���������Ч�����������κθ���ʱ���ڿ������еĲ�����������ʹʹ����\
��\ ``-j``\ �����������Щ���Զ�ʹ������ͬһ��Դ��һЩ��ۡ����⣬����ζ�ŵ�������ʹ�õ���Դ\
�����˻����Ͽ��õ���Դ���������������У����ҽ�����Ϊ\ ``Not Run``����

�˹��ܵ�һ��������������Ҫʹ��GPU�Ĳ��ԡ�������Կ���ͬʱ��һ��GPU�����ڴ棬���������̫���\
����ͼһ��������������һЩ���Խ�����ʧ�ܣ����²���ʧ�ܣ���ʹ�������ӵ��������ڴ�Ҳ��ɹ���\
ͨ��ʹ����Դ�������ԣ�ÿ�����Զ�����ָ������GPU��Ҫ�����ڴ棬�Ӷ�����CTest��һ��ͬʱ���м���\
���Զ�����ľ�GPU�ڴ�صķ�ʽ�����Ų��ԡ�

��ע�⣬CTestû��GPU��ʲô�����ж����ڴ�ĸ����û���κ���GPUͨ�ŵķ�ʽ��������Щ��Ϣ��\
ִ���κ��ڴ����������Ŀ���Զ���һ�����ԣ��ṩ�йز��Ի�������ϸ��Ϣ���μ�\
:ref:`ctest-resource-dynamically-generated-spec-file`����

CTest���ٳ�����Դ���͵��б�����ÿ�����Ͷ���һ�������Ĳۿɹ�����ʹ�á�ÿ������ָ������ĳ��\
��Դ����Ҫ�Ĳ��������Ȼ��CTest��һ�ַ�ֹ����ʹ�õĲ�����������г��������ķ�ʽ�������ǡ�\
��ִ�в���ʱ����Դ�еĲ�۱�������ò��ԣ����Կ��Լ��������ڲ��Խ��̵ĳ���ʱ���ڶ�ռʹ����Щ��ۡ�

CTest��Դ������������������������ɣ�

* :ref:`��Դ�淶�ļ� <ctest-resource-specification-file>`��������������������ϵͳ�Ͽ�\
  �õ���Դ��
* ���Ե�\ :prop_test:`RESOURCE_GROUPS`\ ���ԣ������������������Դ��

��CTest���в���ʱ��������ò��Ե���Դ��һ��\
:ref:`�������� <ctest-resource-environment-variables>`\ ����ʽ���ݣ�����������ʹ�ô�\
��Ϣ�����������ӵ��ĸ���Դ�������Ա�д�ߡ�

``RESOURCE_GROUPS``\ ���Ը���CTest��������ʹ��ʲô��Դ���ԶԲ���������ķ�ʽ���з��顣��\
�Ա�������ȡ\ :ref:`�������� <ctest-resource-environment-variables>`����ȷ�������\
ÿ�������Դ�����磬ÿ������ܶ�Ӧ�ڲ�����ִ��ʱ��������һ�����̡�

ע�⣬��ʹ����ָ����\ ``RESOURCE_GROUPS``\ ���ԣ�����û�û�д�����Դ�淶�ļ����ò�����Ȼ\
�п�����û���κ���Դ���䣨����û����Ӧ��\
:ref:`�������� <ctest-resource-environment-variables>`������������С�ͨ��\
``--resource-spec-file``\ �����в�����\ ``RESOURCE_SPEC_FILE``\ ���������ļ����ݸ�\
:command:`ctest_test`����������Դ�������ԡ�����Ӧ�ü��\ ``CTEST_RESOURCE_GROUP_COUNT``\
������������ȷ���Ƿ񼤻�����Դ���䡣�����������Դ���䣬���������ʼ�գ��ҽ��������塣���û��\
������Դ���䣬��ô\ ``CTEST_RESOURCE_GROUP_COUNT``\ �����������ڣ���ʹ�������ڸ�\
:program:`ctest`\ �����С�������Ծ��Ա�������Դ���䣬��ô�����Է���ʧ�ܵ��˳����룬����ʹ\
��\ :prop_test:`SKIP_RETURN_CODE`\ ��\ :prop_test:`SKIP_REGULAR_EXPRESSION`\ ����\
��ָʾ�����Ĳ��ԡ�

.. _`ctest-resource-specification-file`:

��Դ����ļ�
---------------------------

��Դ�淶�ļ���һ��JSON�ļ����Զ��ַ�ʽ���ݸ�CTest������������������ʹ��\
:option:`ctest --resource-spec-file`\ ѡ��ָ����Ҳ����ʹ��\ :command:`ctest_test`\
��\ ``RESOURCE_SPEC_FILE``\ ����ָ�������߿�����Ϊ����ִ�е�һ���ֶ�̬���ɣ��μ�\
:ref:`ctest-resource-dynamically-generated-spec-file`����

���ʹ���Ǳ��ű�������û��ָ��\ ``RESOURCE_SPEC_FILE``����ʹ���Ǳ��ű��е�\
:variable:`CTEST_RESOURCE_SPEC_FILE`\ ��ֵ�����û��ָ���Ǳ��ű��е�\
:option:`--resource-spec-file <ctest --resource-spec-file>`��\
``RESOURCE_SPEC_FILE``\ ��\ :variable:`CTEST_RESOURCE_SPEC_FILE`����ʹ��CMake����\
�е�\ :variable:`CTEST_RESOURCE_SPEC_FILE`\ ��ֵ�������Щ��û��ָ������ʹ����Դ�淶�ļ���

��Դ�淶�ļ�������һ��JSON���󡣱��ĵ��е��������Ӷ�������������Դ�淶�ļ���

.. code-block:: json

  {
    "version": {
      "major": 1,
      "minor": 0
    },
    "local": [
      {
        "gpus": [
          {
            "id": "0",
            "slots": 2
          },
          {
            "id": "1",
            "slots": 4
          },
          {
            "id": "2",
            "slots": 2
          },
          {
            "id": "3"
          }
        ],
        "crypto_chips": [
          {
            "id": "card0",
            "slots": 4
          }
        ]
      }
    ]
  }

The members are:

��Ա������

``version``
  ����һ��\ ``major``\ �����ֶκ�һ��\ ``minor``\ �����ֶεĶ���Ŀǰ��Ψһ֧�ֵİ汾��\
  major ``1``, minor ``0``���κ�����ֵ���Ǵ���ġ�

``local``
  ϵͳ�ϳ��ֵ���Դ����JSON���顣Ŀǰ���������Ĵ�С������Ϊ1��

  ÿ������Ԫ�ض���һ��JSON�������Ա�����Ƶ����������Դ���ͣ�����\ ``gpus``����Щ���Ʊ�\
  ����Сд��ĸ���»��߿�ͷ��������ַ�������Сд��ĸ�����ֻ��»��ߡ�������ʹ�ô�д��ĸ����Ϊ\
  ĳЩƽ̨�в����ִ�Сд�Ļ����������йظ�����Ϣ������������\ `��������`_\ ���֡�������Դ\
  ��������Ϊ���ʵĸ�����ʽ����\ ``gpus``\ ��\ ``crypto_chips``\ ��������\ ``gpu``\ ��\
  ``crypto_chip``����

  ��ע�⣬����\ ``gpus``\ ��\ ``crypto_chips``\ ֻ��ʾ����CTest�������κη�ʽ�������ǡ�\
  ��������ɵش����κ���Ҫ�����Լ��������Դ���͡�

  ÿ����Դ���͵�ֵ������JSON������ɵ�JSON���飬ÿ����������ָ����Դ���ض�ʵ������Щ������\
  ���³�Ա��

  ``id``
    ����Դ��ʶ����ɵ��ַ�������ʶ���е�ÿ���ַ�������Сд��ĸ�����ֻ��»��ߡ�������ʹ�ô�д��ĸ��

    ��ʶ������Դ�����б�����Ψһ�ġ����ǣ����ǲ�������Դ����֮����Ψһ�ġ����磬һ����Ϊ\
    ``0``\ ��\ ``gpus``\ ��Դ��һ����Ϊ\ ``0``\ ��\ ``crypto_chips``\ ��Դ����Ч�ģ�\
    ��������������Ϊ\ ``0``\ ��\ ``gpus``\ ��Դ��

    ��ע�⣬ID ``0``��\ ``1``��\ ``2``��\ ``3``\ ��\ ``card0``\ ֻ��ʾ����CTest����\
    ���κη�ʽ�������ǡ���������ɵش����κ�����Ҫ��ID���������Լ�������

  ``slots``
    һ����ѡ���޷�������ָ����Դ�Ͽ��õĲ���������磬�������GPU�ϵ����ֽ�RAM�������Ǽ���\
    оƬ�Ͽ��õļ��ܵ�Ԫ�����δָ��\ ``slots``����ٶ�ȱʡֵΪ\ ``1``��

�������ʾ���ļ��У����ĸ�IDΪ0��3��GPU��GPU 0��2����λ��GPU 1��4����λ��GPU 2��2����λ��\
GPU 3Ĭ����1����λ������һ����4��۵�����оƬ��

``RESOURCE_GROUPS``\ ����
----------------------------

�йش����Ե������������\ :prop_test:`RESOURCE_GROUPS`��

.. _`ctest-resource-environment-variables`:

��������
---------------------

һ��CTest��������Щ��Դ��������ԣ����ͻὫ��Щ��Ϣ��Ϊһϵ�л����������ݸ����Կ�ִ���ļ���\
���������ÿ��ʾ�������ǽ����������۵Ĳ��Ե�\ :prop_test:`RESOURCE_GROUPS`\ ����Ϊ\
``2,gpus:2;gpus:4,gpus:1,crypto_chips:2``��

���±��������ݸ����Թ��̣�

.. envvar:: CTEST_RESOURCE_GROUP_COUNT

  :prop_test:`RESOURCE_GROUPS`\ ����ָ����������������磺

  * ``CTEST_RESOURCE_GROUP_COUNT=3``

  ֻ���ڸ�\ :manual:`ctest(1)`\ ָ����\ ``--resource-spec-file``�����߸�\
  :command:`ctest_test`\ ָ����\ ``RESOURCE_SPEC_FILE``\ ʱ���Żᶨ��������������û\
  �и�����Դ�淶�ļ����򲻻ᶨ��ñ�����

.. envvar:: CTEST_RESOURCE_GROUP_<num>

  �����ÿ�������Դ�����б�ÿ����֮���ö��ŷָ���\ ``<num>``\ ��һ�����㵽\
  ``CTEST_RESOURCE_GROUP_COUNT``\ ��һ�����֡�\ ``CTEST_RESOURCE_GROUP_<num>``\ ��\
  Ϊ�����Χ�е�ÿ��\ ``<num>``\ ����ġ����磺

  * ``CTEST_RESOURCE_GROUP_0=gpus``
  * ``CTEST_RESOURCE_GROUP_1=gpus``
  * ``CTEST_RESOURCE_GROUP_2=crypto_chips,gpus``

.. envvar:: CTEST_RESOURCE_GROUP_<num>_<resource-type>

  ��ԴID���б�ͷ����������Դ���͵�ÿ�����ÿ��ID�Ĳ�����������������һϵ�ж���ɣ�ÿһ��\
  �ɷֺŷָ������е�������Ŀ�ɶ��ŷָ���ÿ���еĵ�һ����\ ``id:``\ ����������Ϊ\
  ``<resource-type>``\ ����Դ��ID���ڶ�����\ ``slots:``\ �����Ƿ�������������Դ�Ĳ��\
  �������磺

  * ``CTEST_RESOURCE_GROUP_0_GPUS=id:0,slots:2``
  * ``CTEST_RESOURCE_GROUP_1_GPUS=id:2,slots:2``
  * ``CTEST_RESOURCE_GROUP_2_GPUS=id:1,slots:4;id:3,slots:1``
  * ``CTEST_RESOURCE_GROUP_2_CRYPTO_CHIPS=id:card0,slots:2``

  �ڱ����У���0��GPU ``0``\ ���2����ۣ���1��GPU ``2``\ ���2����ۣ���2��GPU ``1``\
  ���4����ۣ���GPU ``3``\ ���1����ۣ��Ӽ���оƬ\ ``card0``\ ���2����ۡ�

  ``<num>``\ ��һ�����㵽\ ``CTEST_RESOURCE_GROUP_COUNT``\ ��һ�����֡�\
  ``<resource-type>``\ ����Դ���͵����ƣ�ת���ɴ�д��\
  ``CTEST_RESOURCE_GROUP_<num>_<resource-type>``\ ��Ϊ�����г��ķ�Χ�е�ÿ��\
  ``<num>``\ ��\ ``CTEST_RESOURCE_GROUP_<num>``\ ���г���ÿ����Դ���͵ĳ˻�����ġ�

  ����ĳЩƽ̨�Ի����������в����ִ�Сд�����ƣ������Դ���͵������ڲ����ִ�Сд�Ļ����п���\
  �����ͻ����ˣ�Ϊ�˼��������\ :ref:`��Դ�淶�ļ� <ctest-resource-specification-file>`\
  ��\ :prop_test:`RESOURCE_GROUPS`\ �����У�������Դ���Ͷ�������Сд��ʽ�г���������\
  ``CTEST_RESOURCE_GROUP_<num>_<resource-type>``\ ���������н�����ȫ��ת��Ϊ��д��ʽ��

.. _`ctest-resource-dynamically-generated-spec-file`:

��̬���ɵ���Դ�淶�ļ�
-------------------------------------------------

.. versionadded:: 3.28

��Ŀ����ѡ��ָ���������ԣ��ò��Խ����ڶ�̬������Դ�淶�ļ���CTest��ʹ�ø��ļ�����ʹ����Դ��\
���ԡ������ļ��Ĳ��Ա�������\ :prop_test:`GENERATED_RESOURCE_SPEC_FILE`\ ���ԣ�������\
��\ :prop_test:`FIXTURES_SETUP`\ �����б���ֻ��һ��fixture��CTest��Ϊ���fixture����\
����ĺ��壺����������Դ�淶�ļ���fixture��fixture�������κ����ơ��������������fixture��\
��ô������\ :prop_test:`RESOURCE_GROUPS`\ �����в��Ա�������\
:prop_test:`FIXTURES_REQUIRED`\ �а�����fixture��������Դ�淶�ļ�����ʹ��\
``--resource-spec-file``\ ������\ :variable:`CTEST_RESOURCE_SPEC_FILE`\ ����ָ����

.. _`ctest-job-server-integration`:

��ҵ����������
======================

.. versionadded:: 3.29

��POSIXϵͳ�ϣ�����\ `Job Server`_\ ������������ʱ��CTest��������ҵ�ۡ��������\
:prop_test:`PROCESSORS`\ �������ԣ���������Ȼ��CTest��\ :option:`-j <ctest -j>`\
���м�����м�����CTest������ÿ������֮ǰ����ҵ��������ȡһ�����ƣ����ڲ��Խ���ʱ��������

���磬����\ ``Makefile``��

.. literalinclude:: CTEST_EXAMPLE_MAKEFILE_JOB_SERVER.make
  :language: make

��ͨ��\ ``make -j 2 test``\ ����ʱ��\ ``ctest``\ ���ӵ���ҵ��������Ϊÿ�����Ի�ȡһ��\
���ƣ���ͬʱ�������2�����ԡ�

��Windowsϵͳ�ϣ���ҵ������������δʵ�֡�

.. _`Job Server`: https://www.gnu.org/software/make/manual/html_node/Job-Slots.html

�������
========

.. include:: LINKS.txt
