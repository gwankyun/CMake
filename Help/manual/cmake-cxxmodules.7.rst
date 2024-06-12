.. cmake-manual-description: CMake C++ Modules Support Reference

cmake-cxxmodules(7)
*******************

.. versionadded:: 3.28

C++ 20�����ˡ�ģ�顱�ĸ�������Ҫ�󹹽�ϵͳ֮��Ա�����������Կɿ�������\ ``import``\
��䡣CMake��ʵ��Ҫ��������ڹ���������ɨ��Դ�ļ��е�ģ������������ɨ�������ƶ�����Լ����\
�����߹���������ζ�̬���¹���ͼ��

Compilation Strategy
====================

With C++ modules, compiling a set of C++ sources is no longer embarrassingly
parallel. That is, any given source may first require the compilation of
another source file first in order to provide a "CMI" (compiled module
interface) or "BMI" (binary module interface) that C++ compilers use to
satisfy ``import`` statements in other sources. With headers, sources could
share their declarations so that any consumers could compile independently.
With modules, declarations are now generated into these BMI files by the
compiler during compilation based on the contents of the source file and its
``export`` statements.

The order necessary for compilation requires build-time resolution of the
ordering because the order is controlled by the contents of the sources. This
means that the ordering needs extracted from the source during the build to
avoid regenerating the build graph via a configure and generate phase for
every source change to get a correct build.

The general strategy is to use a "scanner" to extract the ordering dependency
information and update the build graph with new edges between existing edges
by taking the per-source scan results (represented by `P1689R5`_ files) and
"collating" the dependencies within a target and to modules produced by
targets visible to the target. The primary task is to generate "module map"
files to pass to each compile rule with the paths to the BMIs needed to
satisfy ``import`` statements. The collator also has tasks to use the
build-time information to fill out information including ``install`` rules for
the module interface units, their BMIs, and properties for any exported
targets with C++ modules.

.. _`P1689R5`: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/p1689r5.html

.. note:

   CMake is focusing on correct builds before looking at performance
   improvements. There are known tactics within the chosen strategy which may
   offer build performance improvements. However, they are being deferred
   until we have a working model against which to compare them. It is also
   important to note that a tactic useful in one situation (e.g., clean
   builds) may not be performant in a different situation (e.g., incremental
   builds). Finding a balance and offering controls to select the tactics is
   future work.

ɨ�����
================

�Ƿ�ɨ��Դ�����Բ���C++ģ���ʹ�����ȡ�������²�ѯ��ʹ�õ�һ���ṩyes/no�𰸵Ĳ�ѯ��

- ���Դ�ļ�����\ ``CXX_MODULES``\ ���͵��ļ��������������ɨ�衣
- ���Ŀ�겻ʹ������C++ 20���򲻻�������ɨ�衣
- ���Դ�ļ�����\ ``CXX``\ ���ԣ��������ᱻɨ�衣
- ���������\ :prop_sf:`CXX_SCAN_FOR_MODULES`\ Դ�ļ����ԣ���ʹ����ֵ��
- ���������\ :variable:`CMAKE_CXX_SCAN_FOR_MODULES`\ Ŀ�����ԣ���ʹ����ֵ������\
  :variable:`CMAKE_CXX_SCAN_FOR_MODULES`\ �������Ա��ڴ�������Ŀ��ʱ��ʼ�������ԡ�
- ���򣬽��ڱ�������������֧�ֵ�ǰ���£�ɨ��Դ�ļ����μ�����\ :policy:`CMP0155`��

��ע�⣬�κ�ɨ���Դ���붼�����ų����κ�ͳһ�����У��μ�\ :prop_tgt:`UNITY_BUILD`����\
��Ϊ��ģ����ص����ֻ�ܷ�����C++���뵥Ԫ�е�һ���ط���

������֧��
================

CMakeԭ��֧��ģ������ɨ��ı�����������

* MSVC���߼�14.34�����°汾����Visual Studio 17.4�����°汾һ���ṩ��
* LLVM/Clang 16.0�����°汾
* GCC 14�����ڿ�����֧��2023-09-20֮�󣩼����°汾

``import std`` Support
======================

Support for ``import std`` is limited to the following toolchain and standard
library combinations:

* Clang 18.1.2 and newer with ``-stdlib=libc++``
* MSVC toolset 14.36 and newer (provided with Visual Studio 17.6 Preview 2 and
  newer)

The :variable:`CMAKE_CXX_COMPILER_IMPORT_STD` variable may be used to detect
support for a standard level with the active C++ toolchain.

.. note ::

   This support is provided only when experimental support for
   ``import std;`` has been enabled by the
   ``CMAKE_EXPERIMENTAL_CXX_IMPORT_STD`` gate.

������֧��
=================

֧��ɨ��C++ģ��Դ���������б������

- :generator:`Ninja`
- :generator:`Ninja Multi-Config`
- :generator:`Visual Studio 17 2022`

����
-----------

��CMake�У���ǰ��C++ģ��֧���������֪�����ơ���û�м�¼��֪�����ƻ�������е���Щbug������\
ʱ������ƶ��ı䡣

����������������

- ��֧�ֱ�ͷ��Ԫ��
- û�ж�\ ``import std;``\ ������֧�֣������������������ṩ��ģ�顣

����Ninja��������

- ��Ҫ\ ``ninja`` 1.11����°汾��

����\ :ref:`Visual Studio Generators`��

- ��֧��Visual Studio 2022��MSVC���߼�14.34��Visual Studio 17.4�������°汾��
- ��֧�ֵ�����װBMI��ģ����Ϣ��
- ��֧����C++ģ���\ ``IMPORTED``\ ��Ŀ�����BMI������\ ``import std``����
- û�д�\ ``PUBLIC``\ ģ��Դ��ʹ��\ ``PRIVATE``\ Դ�ṩ��ģ����ϡ�
