CMake
*****

���
============

`���ķ���˵��`_

.. _`���ķ���˵��`: zh_CN.rst

CMake��һ����ƽ̨����Դ�Ĺ���ϵͳ���������������ĵ������\ `CMake��ҳ`_\ ��\
`CMake�ĵ�ҳ`_��Ҳ����ȥ\ `CMake����ά��`_\ �ο����õ����ϡ�

.. _`CMake��ҳ`: https://cmake.org
.. _`CMake�ĵ�ҳ`: https://cmake.org/documentation
.. _`CMake����ά��`: https://gitlab.kitware.com/cmake/community/-/wikis/home

`Kitware`_\ ά����֧��CMake�����ͬʱҲ���븻�г�Ч�Ĺ���������������

.. _`Kitware`: https://www.kitware.com/cmake

���
=======

CMake����OSI��֤BSD 3��������·����ġ������\ `Copyright.txt`_��

.. _`Copyright.txt`: Copyright.txt

����CMake
==============

֧�ֵ�ƽ̨
-------------------

* Microsoft Windows
* Apple macOS
* Linux
* FreeBSD
* OpenBSD
* Solaris
* AIX

������UNIX����ϵͳӦ��Ҳ�ܿ��伴�ã�������ǵĻ�����CMake��ֲ�����ƽ̨Ӧ�ò���ʲô�����⡣\
����\ `CMake��̳`_\ ����ѯ���������Ƿ��и�ƽ̨����ؾ��顣

.. _`CMake��̳`: https://discourse.cmake.org

Building CMake with CMake
-------------------------

You can build CMake as any other project with a CMake-based build system:
run the installed CMake on the sources of this CMake with your preferred
options and generators. Then build it and install it.
For instructions how to do this, see documentation on `Running CMake`_.

.. _`Running CMake`: https://cmake.org/runningcmake

To build the documentation, install `Sphinx`_ and configure CMake with
``-DSPHINX_HTML=ON`` and/or ``-DSPHINX_MAN=ON`` to enable the "html" or
"man" builder.  Add ``-DSPHINX_EXECUTABLE=/path/to/sphinx-build`` if the
tool is not found automatically.

.. _`Sphinx`: https://sphinx-doc.org

��ͷ��ʼ����CMake
---------------------------

UNIX/Mac OSX/MinGW/MSYS/Cygwin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

����Ҫ��һ��֧��C++11��C++��������һ��\ ``make``����������CMake��ԴĿ¼���ҵ���\
``bootstrap``\ �ű�������ʹ��\ ``--help``\ ѡ�����鿴֧�ֵ�ѡ�����ʹ��\
``--prefix=<install_prefix>``\ ѡ��ָ��CMake���Զ��尲װĿ¼��ִ�����������\
``make``\ ��\ ``make install``��

���磬�����ֻ�����Դ���빹���Ͱ�װCMake�������ֱ����Դ�������й�����\ ::

  $ ./bootstrap && make && sudo make install

���ߣ������ƻ�����CMake����������ʽ���в����׼�������
һ�������Ĺ�������\ ::

  $ mkdir build && cd build
  $ ../bootstrap && make

Windows
^^^^^^^

��Windows�������ֹ���CMake�ķ�����
   
1. ʹ��VS 2015����߰汾VS��MSVC��������
   ����Ҫ���ز���װCMake�Ķ����ư汾�����Դ�\ `CMake����ҳ`_\ �����Щ�汾��Ȼ�����\
   `ʹ��CMake����CMake`_\ �Ĳ��衣
   
2. ʹ��MSYS2�µ�MinGW��
   ���ز���װ\ `MSYS2`_��Ȼ��װ����Ĺ������ߣ�\ ::

1. Compile with MSVC from VS 2015 or later.
   You need to download and install a binary release of CMake.  You can get
   these releases from the `CMake Download Page`_.  Then proceed with the
   instructions above for `Building CMake with CMake`_.

2. Bootstrap with MinGW under MSYS2.
   Download and install `MSYS2`_.  Then install the required build tools::

     $ pacman -S --needed git base-devel mingw-w64-x86_64-gcc
     
   Ȼ�������һ��������

.. _`CMake����ҳ`: https://cmake.org/download
.. _`MSYS2`: https://www.msys2.org/

�������
==============

����㷢���˴���
   
1. ������в��������Ķ�\ `CONTRIBUTING.rst`_\ �ĵ���

2. �����뷢����\ `CMake��̳`_��ѯ��Ԥ�ں͹۲쵽����Ϊ����ȷ�����Ƿ���һ�������Ĵ���

3. �������������費�ܽ�����⣬��\ `CMake�������`_\ ���¿�һ����Ŀ��

.. _`CMake�������`: https://gitlab.kitware.com/cmake/cmake/-/issues

����
============

�����\ `CONTRIBUTING.rst`_���˽���ι��ס�

.. _`CONTRIBUTING.rst`: CONTRIBUTING.rst
