.. cmake-manual-description: CMake Generator Expressions

cmake-generator-expressions(7)
******************************

.. only:: html

   .. contents::

����
============

���������ʽ�����ɹ���ϵͳ�ڼ���м��㣬�������ض���ÿ���������õ���Ϣ�����ǵ���ʽ��\ ``$<...>``�����磺

.. code-block:: cmake

  target_include_directories(tgt PRIVATE /opt/include/$<CXX_COMPILER_ID>)

�⽫��չ��\ ``/opt/include/GNU``��\ ``/opt/include/Clang``\ �ȣ���ȡ������ʹ�õ�C++��������

���������ʽ���������Ŀ�����Ե���������ʹ�ã���\ :prop_tgt:`LINK_LIBRARIES`��\
:prop_tgt:`INCLUDE_DIRECTORIES`��:prop_tgt:`COMPILE_DEFINITIONS`\ �ȡ�\
����Ҳ������ʹ�����������Щ����ʱʹ�ã�����\ :command:`target_link_libraries`��\
:command:`target_include_directories`��:command:`target_compile_definitions`\ �ȡ�\
����֧���������ӡ�����ʱʹ�õ��������塢��������Ŀ¼�ȵȡ��������ܻ��ڹ������á�Ŀ�����ԡ�\
ƽ̨��Ϣ���κ������ɲ�ѯ��Ϣ��

���������ʽ����Ƕ�ף�

.. code-block:: cmake

  target_compile_definitions(tgt PRIVATE
    $<$<VERSION_LESS:$<CXX_COMPILER_VERSION>,4.2.0>:OLD_COMPILER>
  )

���\ :variable:`CMAKE_CXX_COMPILER_VERSION <CMAKE_<LANG>_COMPILER_VERSION>`\
С��4.2.0�����������ݽ���չΪ\ ``OLD_COMPILER``��

�ո������
======================

���������ʽͨ�����������֮����н�����������������ʽ�����ո����С��ֺŻ��������ܱ�����\
Ϊ��������ָ������ַ������������ʽ�ڴ��ݸ�����ʱӦ��������������������������������ܻᵼ��\
���ʽ����֣����ҿ��ܲ��ٽ���ʶ��Ϊ���������ʽ��

��ʹ��\ :command:`add_custom_command`\ ��\ :command:`add_custom_target`\ ʱ��\
ʹ��\ ``VERBATIM``\ ��\ ``COMMAND_EXPAND_LISTS``\ ѡ������ý�׳�Ĳ����ָ�����á�

.. code-block:: cmake

  # WRONG: Embedded space will be treated as an argument separator.
  # This ends up not being seen as a generator expression at all.
  add_custom_target(run_some_tool
    COMMAND some_tool -I$<JOIN:$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>, -I>
    VERBATIM
  )

.. code-block:: cmake

  # Better, but still not robust. Quotes prevent the space from splitting the
  # expression. However, the tool will receive the expanded value as a single
  # argument.
  add_custom_target(run_some_tool
    COMMAND some_tool "-I$<JOIN:$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>, -I>"
    VERBATIM
  )

.. code-block:: cmake

  # Nearly correct. Using a semicolon to separate arguments and adding the
  # COMMAND_EXPAND_LISTS option means that paths with spaces will be handled
  # correctly. Quoting the whole expression ensures it is seen as a generator
  # expression. But if the target property is empty, we will get a bare -I
  # with nothing after it.
  add_custom_target(run_some_tool
    COMMAND some_tool "-I$<JOIN:$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>,;-I>"
    COMMAND_EXPAND_LISTS
    VERBATIM
  )

ʹ�ñ������������ӵ����������ʽҲ�Ǽ��ٴ������߿ɶ��Եĺ÷�������������ӿ��Խ�һ���Ľ����£�

.. code-block:: cmake

  # The $<BOOL:...> check prevents adding anything if the property is empty,
  # assuming the property value cannot be one of CMake's false constants.
  set(prop "$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>")
  add_custom_target(run_some_tool
    COMMAND some_tool "$<$<BOOL:${prop}>:-I$<JOIN:${prop},;-I>>"
    COMMAND_EXPAND_LISTS
    VERBATIM
  )

�����������ӿ�����һ�ָ��򵥺ͽ�׳�ķ�ʽ����ʹ��һ��������������ʽ��

.. code-block:: cmake

  add_custom_target(run_some_tool
    COMMAND some_tool "$<LIST:TRANSFORM,$<TARGET_PROPERTY:tgt,INCLUDE_DIRECTORIES>,PREPEND,-I>"
    COMMAND_EXPAND_LISTS
    VERBATIM
  )

һ�������Ĵ����ǳ��������������������ʽ�ָ���У�

.. code-block:: cmake

  # WRONG: New lines and spaces all treated as argument separators, so the
  # generator expression is split and not recognized correctly.
  target_compile_definitions(tgt PRIVATE
    $<$<AND:
        $<CXX_COMPILER_ID:GNU>,
        $<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,5>
      >:HAVE_5_OR_LATER>
  )

ͬ����ʹ������ѡ�����õĸ��������������ɶ��ı��ʽ��

.. code-block:: cmake

  set(is_gnu "$<CXX_COMPILER_ID:GNU>")
  set(v5_or_later "$<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,5>")
  set(meet_requirements "$<AND:${is_gnu},${v5_or_later}>")
  target_compile_definitions(tgt PRIVATE
    "$<${meet_requirements}:HAVE_5_OR_LATER>"
  )

����
=========

�������������ʽ�������ɹ���ϵͳʱ����ģ��������ڴ���\ ``CMakeLists.txt``\ �ļ�ʱ����ģ�\
��˲�����ʹ��\ :command:`message()`\ ���������ǵĽ�������ɵ�����Ϣ��һ�ֿ��ܵķ�����\
���һ���Զ���Ŀ�꣺

.. code-block:: cmake

  add_custom_target(genexdebug COMMAND ${CMAKE_COMMAND} -E echo "$<...>")

����\ :program:`cmake`\ ֮������Թ���\ ``genexdebug``\ Ŀ���Դ�ӡ\ ``$<...>``\
���ʽ����ִ������\ :option:`cmake --build ... --target genexdebug <cmake--build --target>`����

��һ�ַ�����ʹ��\ :command:`file(GENERATE)`\ ��������Ϣд���ļ���

.. code-block:: cmake

  file(GENERATE OUTPUT filename CONTENT "$<...>")

���������ʽ�ο�
==============================

.. note::

  ����ο�ƫ���˴����CMake�ĵ�����Ϊ��ʡ���˼�����\ ``<...>``\ Χ��ռλ����\ ��\
  ``condition``��\ ``string``��\ ``target``\ �ȡ�����Ϊ�˷�ֹ��Щռλ��������ؽ���\
  Ϊ���������ʽ��

.. _`Conditional Generator Expressions`:

�������ʽ
-----------------------

���������ʽ��һ����������������߼��йء�֧��������ʽ���������������ʽ��

.. genex:: $<condition:true_string>

  ���\ ``condition``\ Ϊ\ ``1``���򷵻�\ ``true_string``�����\ ``condition``\ Ϊ\
  ``0``���򷵻ؿ��ַ�����\ ``condition``\ ���κ�����ֵ���ᵼ�´���

.. genex:: $<IF:condition,true_string,false_string>

  .. versionadded:: 3.8

  ���\ ``condition``\ Ϊ\ ``1``���򷵻�\ ``true_string``�����\ ``condition``\ Ϊ\
  ``0``���򷵻�\ ``false_string``��\ ``condition``\ ���κ�����ֵ���ᵼ�´���

  .. versionadded:: 3.28

    ������������ʽ���·����\ ``condition``\ Ϊ\ ``1``\ ʱ��\ ``false_string``\ ��\
    �����������ʽ������ֵ����\ ``condition``\ Ϊ\ ``0``\ ʱ��\ ``true_string``\ ��\
    �����������ʽ������ֵ��

ͨ����\ ``condition``\ �������һ�����������ʽ�����磬��ʹ��\ ``Debug``\ ����ʱ��\
����ı��ʽչ��Ϊ\ ``DEBUG_MODE``��������������������Ϊ���ַ�����

.. code-block:: cmake

  $<$<CONFIG:Debug>:DEBUG_MODE>

��\ ``1``\ ��\ ``0``\ ֮������Ʋ�����\ ``condition``\ ֵ������\ ``$<BOOL:...>``\
���������ʽ����������

.. genex:: $<BOOL:string>

  ��\ ``string``\ ת��Ϊ\ ``0``\ ��\ ``1``�������������һ��Ϊ�棬�����Ϊ\ ``0``��

  * ``string``\ �ǿյģ�
  * ``string``\ �����ִ�Сд���ȼ�Ϊ\ ``0``��``FALSE``��``OFF``��``N``��``NO``��\
    ``IGNORE``\ ��\ ``NOTFOUND``����
  * ``string``\ ��\ ``-NOTFOUND``\ ��׺���������ִ�Сд����

  �������\ ``1``��

��CMake�����ṩ\ ``condition``\ ʱ��ͨ��ʹ��\ ``$<BOOL:...>``\ ���������ʽ��

.. code-block:: cmake

  $<$<BOOL:${HAVE_SOME_FEATURE}>:-DENABLE_SOME_FEATURE>


.. _`Boolean Generator Expressions`:

�߼������
-----------------

֧�ֳ����Ĳ����߼��������

.. genex:: $<AND:conditions>

  ����\ ``conditions``\ ��һ���Զ��ŷָ��Ĳ������ʽ�б�������Щ���ʽ��ֵ����Ϊ\ ``1``\
  ��\ ``0``���������������Ϊ\ ``1``�����������ʽ��ֵΪ\ ``1``������κ�����Ϊ\ ``0``��\
  �������ʽ�ļ�����Ϊ\ ``0``��

.. genex:: $<OR:conditions>

  ����\ ``conditions``\ �Ƕ��ŷָ��Ĳ������ʽ�б�������Щ���������\ ``1``\ ��\ ``0``��\
  ���������һ������Ϊ\ ``1``�����������ʽ��ֵΪ\ ``1``���������������ֵΪ\ ``0``��\
  ���������ʽ��ֵΪ\ ``0``��

.. genex:: $<NOT:condition>

  ``condition`` must be ``0`` or ``1``.  The result of the expression is
  ``0`` if ``condition`` is ``1``, else ``1``.

.. versionadded:: 3.28

  �߼�������ᷢ����·��һ��ȷ���˷���ֵ���Ͳ���Բ����б��е����������ʽ������ֵ��

.. _`Comparison Expressions`:

��Ҫ�Ƚϱ��ʽ
------------------------------

CMake֧�ָ������������ʽ���бȽϡ����ڽ�������Ҫ�ĺ���㷺ʹ�õıȽ����͡�\
����������ıȽ����ͽ��ں��浥���Ĳ����н���˵����

�ַ����Ƚ�
^^^^^^^^^^^^^^^^^^

.. genex:: $<STREQUAL:string1,string2>

  ���\ ``string1``\ ��\ ``string2``\ ��ȣ���Ϊ\ ``1``������Ϊ\ ``0``���Ƚ������ִ�\
  Сд�ġ�Ҫ���в����ִ�Сд�ıȽϣ�����\
  :ref:`�ַ���ת�����������ʽ <String Transforming Generator Expressions>`\ ���ʹ\
  �á����磬���\ ``${foo}``\ ��\ ``BAR``��\ ``Bar``��\ ``bar``\ ���е�����һ��������\
  ��ļ�����Ϊ\ ``1``��

  .. code-block:: cmake

    $<STREQUAL:$<UPPER_CASE:${foo}>,BAR>

.. genex:: $<EQUAL:value1,value2>

  ���\ ``value1``\ ��\ ``value2``\ ����ֵ�������Ϊ\ ``1``������Ϊ\ ``0``��

�汾�Ƚ�
^^^^^^^^^^^^^^^^^^^

.. genex:: $<VERSION_LESS:v1,v2>

  ���\ ``v1``\ С��\ ``v2``����Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<VERSION_GREATER:v1,v2>

  ���\ ``v1``\ ����\ ``v2``\ ��Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<VERSION_EQUAL:v1,v2>

  ���\ ``v1``\ ��\ ``v2``\ ��ͬһ���汾����Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<VERSION_LESS_EQUAL:v1,v2>

  .. versionadded:: 3.7

  ���\ ``v1``\ ��С�ڵ���\ ``v2``\ �İ汾����Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<VERSION_GREATER_EQUAL:v1,v2>

  .. versionadded:: 3.7

  ���\ ``v1``\ �Ǵ��ڵ���\ ``v2``\ �İ汾����Ϊ\ ``1``������Ϊ\ ``0``��

.. _`String Transforming Generator Expressions`:

�ַ���ת��
----------------------

.. genex:: $<LOWER_CASE:string>

  ת��ΪСд��\ ``string``\ ���ݡ�

.. genex:: $<UPPER_CASE:string>

  ת��Ϊ��д��\ ``string``\ ���ݡ�

.. genex:: $<MAKE_C_IDENTIFIER:...>

  ``...``\ ������ת��ΪC��ʶ����ת����ѭ��\ :command:`string(MAKE_C_IDENTIFIER)`\
  ��ͬ����Ϊ��

�б���ʽ
----------------

�����еĴ�������ʽ����\ :command:`list`\ ����������أ��ṩ��ͬ�Ĺ��ܣ����������������\
ʽ����ʽ��

������ÿ�����б���ص����������ʽ�У�������������ʽϣ����\ ``list``\ ���ṩĳЩ���ݣ����\
``list``\ ���ð����κζ��š����磬���ʽ\ ``$<LIST:FIND,list,value>``\ ��\ ``list``\
������Ҫһ��\ ``value``������ʹ�ö��ŷָ�\ ``list``\ ��\ ``value``������б����ܰ�\
�����š������Ʋ�������\ :command:`list`\ ��������ض����б������������ʽ��

.. _GenEx List Comparisons:

�б�Ƚ�
^^^^^^^^^^^^^^^^

.. genex:: $<IN_LIST:string,list>

  .. versionadded:: 3.12

  ���\ ``string``\ �Ƿֺŷָ�\ ``list``\ �е����Ϊ\ ``1``������Ϊ\ ``0``��\
  ��ʹ�����ִ�Сд�ıȽϡ�

.. _GenEx List Queries:

�б��ѯ
^^^^^^^^^^^^

.. genex:: $<LIST:LENGTH,list>

  .. versionadded:: 3.27

  ����\ ``list``\ ����

.. genex:: $<LIST:GET,list,index,...>

  .. versionadded:: 3.27

  �����б���������ָ������\ ``list``��

.. genex:: $<LIST:SUBLIST,list,begin,length>

  .. versionadded:: 3.27

  ���ظ���\ ``list``\ �����б����\ ``length``\ Ϊ0���򷵻ؿ��б����\ ``length``\
  Ϊ-1���б�С��\ ``begin + length``���򷵻ش�\ ``begin``\ ��ʼ���б�������

.. genex:: $<LIST:FIND,list,value>

  .. versionadded:: 3.27

  ``list``\ �о���ָ��\ ``value``\ �ĵ�һ��������������\ ``value``\ ����\ ``list``\
  �У���Ϊ-1��

.. _GenEx List Transformations:

�б�ת��
^^^^^^^^^^^^^^^^^^^^

.. _GenEx LIST-JOIN:

.. genex:: $<LIST:JOIN,list,glue>

  .. versionadded:: 3.27

  ��\ ``list``\ ת��Ϊ�����ַ���������ÿ����֮�����\ ``glue``\ �ַ��������ݡ����ڸ�������\
  :genex:`$<JOIN:list,glue>`\ ������ͬ���������߶��ڿ������Ϊ��ͬ��\
  ``$<LIST:JOIN,list,glue>``\ �������п����\ :genex:`$<JOIN:list,glue>`\ ���б�\
  ��ɾ�����п��

.. genex:: $<LIST:APPEND,list,item,...>

  .. versionadded:: 3.27

  ��������\ ``item``\ ��\ ``list``�������֮��Ӧ���ö��ŷָ���

.. genex:: $<LIST:PREPEND,list,item,...>

  .. versionadded:: 3.27

  ��\ ``list``\ �Ŀ�ͷ����ÿ��\ ``item``������ж�����Ӧ�Զ��ŷָ���������ǰ�����˳��

.. genex:: $<LIST:INSERT,list,index,item,...>

  .. versionadded:: 3.27

  ��ָ������������\ ``item``\ ���������\ ``list``�������֮��Ӧ���ö��ŷָ���

  ָ��������Χ��\ ``index``\ �Ǵ���ġ���Ч��������Χ��0��N������N���б�ĳ��ȣ������б��\
  ���ȡ����б�ĳ���Ϊ0��

.. genex:: $<LIST:POP_BACK,list>

  .. versionadded:: 3.27

  ����һ��ɾ�����һ�����\ ``list``��

.. genex:: $<LIST:POP_FRONT,list>

  .. versionadded:: 3.27

  ����ɾ����һ�����\ ``list``��

.. genex:: $<LIST:REMOVE_ITEM,list,value,...>

  .. versionadded:: 3.27

  ɾ������\ ``value``\ ������ֵ��������ʵ����\ ``list``����������˶��ֵ������֮��Ӧ\
  ���ö��ŷָ���

.. genex:: $<LIST:REMOVE_AT,list,index,...>

  .. versionadded:: 3.27

  ����һ��\ ``list``�����и���\ ``index``\ ��������ֵ����ɾ����

.. _GenEx LIST-REMOVE_DUPLICATES:

.. genex:: $<LIST:REMOVE_DUPLICATES,list>

  .. versionadded:: 3.27

  ����ɾ���ظ����\ ``list``��������Ŀ�����˳�򣬵���������ظ����ֻ������һ��ʵ������\
  ����\ :genex:`$<REMOVE_DUPLICATES:list>`\ ��ͬ��

.. _GenEx LIST-FILTER:

.. genex:: $<LIST:FILTER,list,INCLUDE|EXCLUDE,regex>

  .. versionadded:: 3.27

  ``list``\ ��ƥ�䣨\ ``INCLUDE``\ ����ƥ�䣨\ ``EXCLUDE``\ ��������ʽ\ ``regex``\
  ������б������\ :genex:`$<FILTER:list,INCLUDE|EXCLUDE,regex>`\ ��ͬ��

.. genex:: $<LIST:TRANSFORM,list,ACTION[,SELECTOR]>

  .. versionadded:: 3.27

  ͨ����\ ``list``\ �е�������Ӧ��\ ``ACTION``\ ��ָ��һ��\ ``SELECTOR``������ת������б�

  .. note::

    ``TRANSFORM``\ ������ı��б���Ԫ�ص����������ָ����\ ``SELECTOR``����ֻ��һЩ��\
    �ᱻ���ģ������������ת��ǰ��ͬ��

  ``ACTION``\ ָ��Ӧ�����б���Ĳ���������������\ :command:`list(TRANSFORM)`\ ������\
  ȫ��ͬ�����塣\ ``ACTION``\ ����������ѡ��֮һ��

    :command:`APPEND <list(TRANSFORM_APPEND)>`, :command:`PREPEND <list(TRANSFORM_APPEND)>`
      ��ָ����ֵ׷�ӵ��б��ÿ���

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,(APPEND|PREPEND),value[,SELECTOR]>

    :command:`TOLOWER <list(TRANSFORM_TOLOWER)>`, :command:`TOUPPER <list(TRANSFORM_TOLOWER)>`
      ���б��е�ÿ����ת��Ϊ��Сд�ַ���

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,(TOLOWER|TOUPPER)[,SELECTOR]>

    :command:`STRIP <list(TRANSFORM_STRIP)>`
      ���б��ÿ������ɾ��ǰ����β��ո�

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,STRIP[,SELECTOR]>

    :command:`REPLACE <list(TRANSFORM_REPLACE)>`:
      �����ܶ��ƥ��������ʽ�������滻���ʽ�滻�б���ÿ�����ƥ���

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,REPLACE,regular_expression,replace_expression[,SELECTOR]>

  ``SELECTOR``\ �����б��е���Щ���ת����һ��ֻ��ָ��һ�����͵�ѡ������������ʱ��\
  ``SELECTOR``\ ����������֮һ��

    ``AT``
      ָ�������б�

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,ACTION,AT,index[,index...]>

    ``FOR``
      ָ��һ����Χ����ʹ�ÿ�ѡ�������������÷�Χ��

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,ACTION,FOR,start,stop[,step]>

    ``REGEX``
      ָ��������ʽ��ֻ��ƥ��������ʽ����Żᱻת����

      .. code-block:: cmake

        $<LIST:TRANSFORM,list,ACTION,REGEX,regular_expression>

.. genex:: $<JOIN:list,glue>

  �ò�����ÿ����Ŀ֮���\ ``glue``\ �ַ�����������\ ``list``�����ڸ�������\
  :ref:`$\<LIST:JOIN,list,glue\> <GenEx LIST-JOIN>`\ ������ͬ���������߶��ڿ������\
  Ϊ��ͬ��\ :ref:`$\<LIST:JOIN,list,glue\> <GenEx LIST-JOIN>`\ �������п����\
  ``$<JOIN,list,glue>``\ ���б���ɾ�����п��

.. genex:: $<REMOVE_DUPLICATES:list>

  .. versionadded:: 3.15

  ɾ������\ ``list``\ �е��ظ������������˳�򣬲�����������ظ����ֻ������һ��ʵ����\
  �����\ :ref:`$\<LIST:REMOVE_DUPLICATES,list\> <GenEx LIST-REMOVE_DUPLICATES>`\
  ��ͬ��

.. genex:: $<FILTER:list,INCLUDE|EXCLUDE,regex>

  .. versionadded:: 3.15

  ��\ ``list``\ �а�����ɾ����������ʽ\ ``regex``\ ƥ���������\
  :ref:`$\<LIST:FILTER,list,INCLUDE|EXCLUDE,regex\> <GenEx LIST-FILTER>`\ ��ͬ��

.. _GenEx List Ordering:

�б�����
^^^^^^^^^^^^^

.. genex:: $<LIST:REVERSE,list>

  .. versionadded:: 3.27

  ���������෴˳�����е�\ ``list``��

.. genex:: $<LIST:SORT,list[,(COMPARE:option|CASE:option|ORDER:option)]...>

  .. versionadded:: 3.27

  ���ذ�ָ��ѡ�������\ ``list``��

  ʹ��\ ``COMPARE``\ ѡ��֮һ��ѡ������ıȽϷ�����

    ``STRING``
      ����ĸ˳����ַ����б�����������û�и���\ ``COMPARE``\ ѡ�����Ĭ����Ϊ��

    ``FILE_BASENAME``
      ���������ƶ��ļ�·�����б��������

    ``NATURAL``
      ʹ����Ȼ˳����ַ����б�������������\ ``strverscmp(3)``\ ���ֲ�ҳ�����Ա㽫��\
      ��������Ϊ�������бȽϡ����磬���ѡ����\ ``NATURAL``\ �Ƚϣ�������б�\
      ``10.0 1.1 2.1 8.0 2.0 3.1``\ ��������Ϊ\ ``1.1 10.0 2.0 2.1 3.1 8.0``����\
      ���ѡ����\ ``STRING``\ �Ƚϣ�����������Ϊ\ ``1.1 10.0 2.0 2.1 3.1 8.0``��

  ʹ��\ ``CASE``\ ѡ��֮һ��ѡ�����ִ�Сд�����ִ�Сд������ģʽ��

    ``SENSITIVE``
      �б��������ִ�Сд�ķ�ʽ�������û�и���\ ``CASE``\ ѡ�����Ĭ����Ϊ��

    ``INSENSITIVE``
      �б�����������ִ�Сд������Сд��ͬ�����˳��δָ����

  Ҫ��������˳�򣬿��Ը���\ ``ORDER``\ ѡ��֮һ��

    ``ASCENDING``
      ��������б������������δ����\ ``ORDER``\ ѡ��ʱ��Ĭ����Ϊ��

    ``DESCENDING``
      ��������б��������

  ���԰�����˳��ָ������ѡ������ָ����ͬ��ѡ���Ǵ���ġ�

  .. code-block:: cmake

    $<LIST:SORT,list,CASE:SENSITIVE,COMPARE:STRING,ORDER:DESCENDING>

·�����ʽ
----------------

�����еĴ�������ʽ����\ :command:`cmake_path`\ ����������أ��ṩ��ͬ�Ĺ��ܣ�\
�����������������ʽ����ʽ��

���ڱ����е��������������ʽ��·����Ӧ����cmake��ʽ�ĸ�ʽ��:ref:`$\<PATH:CMAKE_PATH\> <GenEx PATH-CMAKE_PATH>`\
���������ʽ�����ڽ�����·��ת��Ϊcmake��ʽ��·����

.. _GenEx Path Comparisons:

·���Ƚ�
^^^^^^^^^^^^^^^^

.. genex:: $<PATH_EQUAL:path1,path2>

  .. versionadded:: 3.24

  �Ƚ�����·���Ĵʷ���ʾ�����κ�·���϶���ִ�й�һ�������·������򷵻�\ ``1``�����򷵻�\ ``0``��

  �йظ���ϸ�ڣ������\ :ref:`cmake_path(COMPARE) <Path COMPARE>`��

.. _GenEx Path Queries:

·����ѯ
^^^^^^^^^^^^

��Щ���ʽ�ṩ�˵�ͬ��\ :command:`cmake_path`\ �����\ :ref:`Query <Path Query>`\
ѡ�������ʱ���ܡ�����·����Ӧ����cmake��ʽ�ĸ�ʽ��

.. genex:: $<PATH:HAS_*,path>

  .. versionadded:: 3.24

  ��������ض���·��������򷵻�\ ``1``�����򷵻�\ ``0``���й�ÿ��·������ĺ��壬\
  �����\ :ref:`Path Structure And Terminology`��

  ::

    $<PATH:HAS_ROOT_NAME,path>
    $<PATH:HAS_ROOT_DIRECTORY,path>
    $<PATH:HAS_ROOT_PATH,path>
    $<PATH:HAS_FILENAME,path>
    $<PATH:HAS_EXTENSION,path>
    $<PATH:HAS_STEM,path>
    $<PATH:HAS_RELATIVE_PART,path>
    $<PATH:HAS_PARENT_PATH,path>

  ע���������������

  * ����\ ``HAS_ROOT_PATH``��ֻ�е�\ ``root-name``\ ��\ ``root-directory``\
    ��������һ���ǿ�ʱ���Ż᷵��true�����

  * ����\ ``HAS_PARENT_PATH``����Ŀ¼Ҳ����Ϊ��һ����Ŀ¼����������\
    ����·������\ :ref:`filename <FILENAME_DEF>`\ ��ɣ�������Ϊ�档

.. genex:: $<PATH:IS_ABSOLUTE,path>

  .. versionadded:: 3.24

  ���·����\ :ref:`absolute <IS_ABSOLUTE>`\ ·���򷵻�\ ``1``�����򷵻�\ ``0``��

.. genex:: $<PATH:IS_RELATIVE,path>

  .. versionadded:: 3.24

  �⽫������\ ``IS_ABSOLUTE``\ �෴�Ľ����

.. genex:: $<PATH:IS_PREFIX[,NORMALIZE],path,input>

  .. versionadded:: 3.24

  ���\ ``path``\ ��\ ``input``\ ��ǰ׺���򷵻�\ ``1``�����򷵻�\ ``0``��

  ��ָ��\ ``NORMALIZE``\ ѡ��ʱ��\ ``path``\ ��\ ``input``\ �ڼ��֮ǰ��\
  :ref:`normalized <Normalization>`��

.. _GenEx Path Decomposition:

·���ֽ�
^^^^^^^^^^^^^^^^^^

��Щ���ʽ�ṩ�˵�ͬ��\ :command:`cmake_path`\ �����\ :ref:`Decomposition <Path Decomposition>`\
ѡ�������ʱ���ܡ�����·����Ӧ����cmake��ʽ�ĸ�ʽ��

.. genex:: $<PATH:GET_*,...>

  .. versionadded:: 3.24

  ���²�����·���м�����ͬ�����������顣�й�ÿ��·������ĺ��壬�����\ :ref:`Path Structure And Terminology`��

  .. versionchanged:: 3.27
    �������еĲ���������һ��·���б���Ϊ��������ָ����·���б�ʱ���ò�����Ӧ����ÿ��·����

  ::

    $<PATH:GET_ROOT_NAME,path...>
    $<PATH:GET_ROOT_DIRECTORY,path...>
    $<PATH:GET_ROOT_PATH,path...>
    $<PATH:GET_FILENAME,path...>
    $<PATH:GET_EXTENSION[,LAST_ONLY],path...>
    $<PATH:GET_STEM[,LAST_ONLY],path...>
    $<PATH:GET_RELATIVE_PART,path...>
    $<PATH:GET_PARENT_PATH,path...>

  ���������������·���У��򷵻ؿ��ַ�����

.. _GenEx Path Transformations:

·��ת��
^^^^^^^^^^^^^^^^^^^^

��Щ���ʽ�ṩ�˵�ͬ��\ :command:`cmake_path`\ �����\ :ref:`Modification <Path Modification>`\
��\ :ref:`Generation <Path Generation>`\ ѡ�������ʱ���ܡ�����·����Ӧ����cmake��ʽ�ĸ�ʽ��

.. versionchanged:: 3.27
  �������еĲ���������һ��·���б���Ϊ��������ָ����·���б�ʱ���ò�����Ӧ����ÿ��·����


.. _GenEx PATH-CMAKE_PATH:

.. genex:: $<PATH:CMAKE_PATH[,NORMALIZE],path...>

  .. versionadded:: 3.24

  ����\ ``path``�����\ ``path``\ ��ԭ��·��������ת��Ϊ������б�ܣ�\ ``/``\ ����cmake\
  ��ʽ��·������Windows�ϣ����ļ�����ǻᱻ�������ڡ�

  ��ָ��\ ``NORMALIZE``\ ѡ��ʱ��ת���󽫶�·������\ :ref:`normalized
  <Normalization>`��

.. genex:: $<PATH:APPEND,path...,input,...>

  .. versionadded:: 3.24

  ������\ ``/``\ ��Ϊ\ ``directory-separator``\ ���ӵ�\ ``path``\ ������\ ``input``\
  ����������\ ``input``\ �Ĳ�ͬ��\ ``path``\ ��ֵ���ܻᱻ������

  �����\ :ref:`cmake_path(APPEND) <APPEND>`\ �˽������ϸ��Ϣ��

.. genex:: $<PATH:REMOVE_FILENAME,path...>

  .. versionadded:: 3.24

  ����ɾ�����ļ����������\ ``$<PATH:GET_FILENAME>``\ ���أ���\ ``path``��ɾ��֮��\
  �κ�β���\ ``directory-separator``\ ��������ڵĻ����������ֲ��䡣

  �μ�\ :ref:`cmake_path(REMOVE_FILENAME) <REMOVE_FILENAME>`\ �˽����ϸ�ڡ�

.. genex:: $<PATH:REPLACE_FILENAME,path...,input>

  .. versionadded:: 3.24

  ����\ ``path``�������ļ������\ ``input``\ �滻�����\ ``path``\ û���ļ������\
  ������\ ``$<PATH:HAS_FILENAME>``\ ����\ ``0``����\ ``path``\ ���䡣

  �μ�\ :ref:`cmake_path(REPLACE_FILENAME) <REPLACE_FILENAME>`\ �˽����ϸ�ڡ�

.. genex:: $<PATH:REMOVE_EXTENSION[,LAST_ONLY],path...>

  .. versionadded:: 3.24

  ������ɾ��\ :ref:`extension <EXTENSION_DEF>`\ ��\ ``path``������еĻ���

  �й���ϸ��Ϣ�������\ :ref:`cmake_path(REMOVE_EXTENSION) <REMOVE_EXTENSION>`��

.. genex:: $<PATH:REPLACE_EXTENSION[,LAST_ONLY],path...,input>

  .. versionadded:: 3.24

  ����\ ``path``������\ :ref:`extension <EXTENSION_DEF>`\ �滻Ϊ\ ``input``��\
  ����еĻ���

  ��ϸ��Ϣ��μ�\ :ref:`cmake_path(REPLACE_EXTENSION) <REPLACE_EXTENSION>`��

.. genex:: $<PATH:NORMAL_PATH,path...>

  .. versionadded:: 3.24

  ���ظ���\ :ref:`Normalization`\ �������Ĳ����һ����\ ``path``��

.. genex:: $<PATH:RELATIVE_PATH,path...,base_directory>

  .. versionadded:: 3.24

  ����\ ``path``���޸ĺ�ʹ�������\ ``base_directory``\ ������

  �йظ���ϸ�ڣ������\ :ref:`cmake_path(RELATIVE_PATH) <cmake_path-RELATIVE_PATH>`��

.. genex:: $<PATH:ABSOLUTE_PATH[,NORMALIZE],path...,base_directory>

  .. versionadded:: 3.24

  ���ؾ���\ ``path``�����\ ``path``\ ��һ�����·����\ ``$<PATH:IS_RELATIVE>``\ ����\
  ``1``�������������\ ``base_directory``\ ����ָ���ĸ�����Ŀ¼���м��㡣

  ��ָ��\ ``NORMALIZE``\ ѡ��ʱ����·������֮���·������\ :ref:`normalized <Normalization>`��

  �й���ϸ��Ϣ�������\ :ref:`cmake_path(ABSOLUTE_PATH) <ABSOLUTE_PATH>`��

Shell·��
^^^^^^^^^^^

.. genex:: $<SHELL_PATH:...>

  .. versionadded:: 3.4

  ``...``\ ������ת��Ϊshell·����ʽ�����磬Windows shell�н�б��ת��Ϊ��б�ܣ�\
  MSYS shell���̷�ת��Ϊposix·����\ ``...``\ ����Ϊ����·����

  .. versionadded:: 3.14
    ``...``\ ������һ����\ :ref:`�Էֺŷָ����б� <CMake Language Lists>`��\
    ����������£�ÿ��·����������ת��������ʹ��shell·���ָ�����\ ``:``\ ֮��POSIX��\
    ``;``\ ֮��Windows������CMakeԴ�����У�����ؽ�������genex�Ĳ�������˫�����У�\
    ��ȷ����������\ ``;``\ ������

���ñ��ʽ
-------------------------

.. genex:: $<CONFIG>

  �������ơ�ʹ�ô˱��ʽ���������õ�\ :genex:`CONFIGURATION`\ ���������ʽ��

.. genex:: $<CONFIG:cfgs>

  ���config�Ƕ��ŷָ����б�\ ``cfgs``\ �е��κ�һ���Ϊ\ ``1``������Ϊ\ ``0``��\
  ����һ�������ִ�Сд�ıȽϡ�����\ :prop_tgt:`IMPORTED`\ Ŀ��������ϼ���\
  :prop_tgt:`MAP_IMPORTED_CONFIG_<CONFIG>`\ �е�ӳ��ʱ���˱��ʽҲ�ῼ������

  .. versionchanged:: 3.19
    ����Ϊ\ ``cfgs``\ ָ���������á�CMake 3.18�͸���İ汾ֻ���ܵ�һ���á�

.. genex:: $<OUTPUT_CONFIG:...>

  .. versionadded:: 3.20

  ����\ :command:`add_custom_command`\ ��\ :command:`add_custom_target`\ ����Ϊ��\
  ���е���������������ʽ��Ч������\ :generator:`Ninja Multi-Config`\ ����������������\
  ��ʽ��\ ``...``\ ʹ���Զ�������ġ�������á����м��㡣ʹ��������������\ ``...``\ �������㡣

.. genex:: $<COMMAND_CONFIG:...>

  .. versionadded:: 3.20

  ����\ :command:`add_custom_command`\ ��\ :command:`add_custom_target`\ ����Ϊ��\
  ���е���������������ʽ��Ч������\ :generator:`Ninja Multi-Config`\ ����������������\
  ��ʽ��\ ``...``\ ʹ���Զ�������ġ��������á����м��㡣ʹ��������������\ ``...``\ �������㡣

�����������Ա��ʽ
----------------------------------

ƽ̨
^^^^^^^^

.. genex:: $<PLATFORM_ID>

  ��ǰϵͳ��CMakeƽ̨��ʶ���ο�\ :variable:`CMAKE_SYSTEM_NAME`\ ������

.. genex:: $<PLATFORM_ID:platform_ids>

  ���CMake��ƽ̨id�붺�ŷָ���\ ``platform_ids``\ �б��е��κ�һ����ƥ�䣬��Ϊ\ ``1``��\
  ����Ϊ\ ``0``���������\ :variable:`CMAKE_SYSTEM_NAME`\ ������

�������汾
^^^^^^^^^^^^^^^^

�������\ :variable:`CMAKE_<LANG>_COMPILER_VERSION`\ �������ñ����뱾С���еı��ʽ������ء�

.. genex:: $<C_COMPILER_VERSION>

  ʹ�õ�C�������汾��

.. genex:: $<C_COMPILER_VERSION:version>

  ���C�������İ汾��\ ``version``\ ƥ�䣬��Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<CXX_COMPILER_VERSION>

  ʹ�õ�CXX�������İ汾��

.. genex:: $<CXX_COMPILER_VERSION:version>

  ���C++�������İ汾��\ ``version``\ ƥ�䣬��Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<CUDA_COMPILER_VERSION>

  .. versionadded:: 3.15

  ʹ�õ�CUDA�������İ汾��

.. genex:: $<CUDA_COMPILER_VERSION:version>

  .. versionadded:: 3.15

  ���C++�������İ汾��\ ``version``\ ƥ�䣬��Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<OBJC_COMPILER_VERSION>

  .. versionadded:: 3.16

  ʹ�õ�Objective-C�������İ汾��

.. genex:: $<OBJC_COMPILER_VERSION:version>

  .. versionadded:: 3.16

  ���Objective-C�������İ汾��\ ``version``\ ƥ�䣬��Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<OBJCXX_COMPILER_VERSION>

  .. versionadded:: 3.16

  ʹ�õ�Objective-C++�������İ汾��

.. genex:: $<OBJCXX_COMPILER_VERSION:version>

  .. versionadded:: 3.16

  ���Objective-C++�������İ汾��\ ``version``\ ƥ�䣬��Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<Fortran_COMPILER_VERSION>

  ʹ�õ�Fortran�������İ汾��

.. genex:: $<Fortran_COMPILER_VERSION:version>

  ���Fortran�������İ汾��\ ``version``\ ƥ�䣬��Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<HIP_COMPILER_VERSION>

  .. versionadded:: 3.21

  ʹ�õ�HIP�������İ汾��

.. genex:: $<HIP_COMPILER_VERSION:version>

  .. versionadded:: 3.21

  ���HIP�������İ汾��\ ``version``\ ƥ�䣬��Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<ISPC_COMPILER_VERSION>

  .. versionadded:: 3.19

  ʹ�õ�ISPC�������İ汾��

.. genex:: $<ISPC_COMPILER_VERSION:version>

  .. versionadded:: 3.19

  ���ISPC�������İ汾��\ ``version``\ ƥ�䣬��Ϊ\ ``1``������Ϊ\ ``0``��

Compiler Language, ID, and Frontend-Variant
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

See also the :variable:`CMAKE_<LANG>_COMPILER_ID` and
:variable:`CMAKE_<LANG>_COMPILER_FRONTEND_VARIANT` variables, which are closely
related to most of the expressions in this sub-section.

.. genex:: $<C_COMPILER_ID>

  CMakeʹ�õ�C��������id��

.. genex:: $<C_COMPILER_ID:compiler_ids>

  ����\ ``compiler_ids``\ ��һ�����ŷָ����б����CMake��C������id��\ ``compiler_ids``\
  �е��κ�һ����Ŀƥ�䣬�򷵻�\ ``1``������Ϊ\ ``0``��

  .. versionchanged:: 3.15
    ����ָ�����\ ``compiler_ids``��CMake 3.14�͸���İ汾ֻ����һ��������ID��

.. genex:: $<CXX_COMPILER_ID>

  CMakeʹ�õ�C++��������id��

.. genex:: $<CXX_COMPILER_ID:compiler_ids>

  ����\ ``compiler_ids``\ ��һ�����ŷָ����б����CMake��C++������id��\ ``compiler_ids``\
  �е��κ�һ����Ŀƥ�䣬�򷵻�\ ``1``������Ϊ\ ``0``��

  .. versionchanged:: 3.15
    ����ָ�����\ ``compiler_ids``��CMake 3.14�͸���İ汾ֻ����һ��������ID��

.. genex:: $<CUDA_COMPILER_ID>

  .. versionadded:: 3.15

  CMakeʹ�õ�CUDA��������id��

.. genex:: $<CUDA_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.15

  ����\ ``compiler_ids``\ ��һ�����ŷָ����б����CMake��CUDA������id��\ ``compiler_ids``\
  �е��κ�һ����Ŀƥ�䣬�򷵻�\ ``1``������Ϊ\ ``0``��

.. genex:: $<OBJC_COMPILER_ID>

  .. versionadded:: 3.16

  CMakeʹ�õ�Objective-C��������id��

.. genex:: $<OBJC_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.16

  ����\ ``compiler_ids``\ ��һ�����ŷָ����б����CMake��Objective-C������id��\
  ``compiler_ids``\ �е��κ�һ����Ŀƥ�䣬�򷵻�\ ``1``������Ϊ\ ``0``��

.. genex:: $<OBJCXX_COMPILER_ID>

  .. versionadded:: 3.16

  CMakeʹ�õ�Objective-C++��������id��

.. genex:: $<OBJCXX_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.16

  ����\ ``compiler_ids``\ ��һ�����ŷָ����б����CMake��Objective-C++������id��\
  ``compiler_ids``\ �е��κ�һ����Ŀƥ�䣬�򷵻�\ ``1``������Ϊ\ ``0``��

.. genex:: $<Fortran_COMPILER_ID>

  CMakeʹ�õ�Fortran��������id��

.. genex:: $<Fortran_COMPILER_ID:compiler_ids>

  ����\ ``compiler_ids``\ ��һ�����ŷָ����б����CMake��Fortran������id��\
  ``compiler_ids``\ �е��κ�һ����Ŀƥ�䣬�򷵻�\ ``1``������Ϊ\ ``0``��

  .. versionchanged:: 3.15
    ����ָ�����\ ``compiler_ids``��CMake 3.14�͸���İ汾ֻ����һ��������ID��

.. genex:: $<HIP_COMPILER_ID>

  .. versionadded:: 3.21

  CMakeʹ�õ�HIP��������id��

.. genex:: $<HIP_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.21

  ����\ ``compiler_ids``\ ��һ�����ŷָ����б����CMake��HIP������id��\
  ``compiler_ids``\ �е��κ�һ����Ŀƥ�䣬�򷵻�\ ``1``������Ϊ\ ``0``��

.. genex:: $<ISPC_COMPILER_ID>

  .. versionadded:: 3.19

  CMakeʹ�õ�ISPC��������id��

.. genex:: $<ISPC_COMPILER_ID:compiler_ids>

  .. versionadded:: 3.19

  ����\ ``compiler_ids``\ ��һ�����ŷָ����б����CMake��ISPC������id��\
  ``compiler_ids``\ �е��κ�һ����Ŀƥ�䣬�򷵻�\ ``1``������Ϊ\ ``0``��

.. genex:: $<C_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake's compiler frontend variant of the C compiler used.

.. genex:: $<C_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  where ``compiler_ids`` is a comma-separated list.
  ``1`` if CMake's compiler frontend variant of the C compiler matches any one
  of the entries in ``compiler_ids``, otherwise ``0``.

.. genex:: $<CXX_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake's compiler frontend variant of the C++ compiler used.

.. genex:: $<CXX_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  where ``compiler_ids`` is a comma-separated list.
  ``1`` if CMake's compiler frontend variant of the C++ compiler matches any one
  of the entries in ``compiler_ids``, otherwise ``0``.

.. genex:: $<CUDA_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake's compiler id of the CUDA compiler used.

.. genex:: $<CUDA_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  where ``compiler_ids`` is a comma-separated list.
  ``1`` if CMake's compiler frontend variant of the CUDA compiler matches any one
  of the entries in ``compiler_ids``, otherwise ``0``.

.. genex:: $<OBJC_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake's compiler frontend variant of the Objective-C compiler used.

.. genex:: $<OBJC_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  where ``compiler_ids`` is a comma-separated list.
  ``1`` if CMake's compiler frontend variant of the Objective-C compiler matches any one
  of the entries in ``compiler_ids``, otherwise ``0``.

.. genex:: $<OBJCXX_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake's compiler frontend variant of the Objective-C++ compiler used.

.. genex:: $<OBJCXX_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  where ``compiler_ids`` is a comma-separated list.
  ``1`` if CMake's compiler frontend variant of the Objective-C++ compiler matches any one
  of the entries in ``compiler_ids``, otherwise ``0``.

.. genex:: $<Fortran_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake's compiler id of the Fortran compiler used.

.. genex:: $<Fortran_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  where ``compiler_ids`` is a comma-separated list.
  ``1`` if CMake's compiler frontend variant of the Fortran compiler matches any one
  of the entries in ``compiler_ids``, otherwise ``0``.

.. genex:: $<HIP_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake's compiler id of the HIP compiler used.

.. genex:: $<HIP_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  where ``compiler_ids`` is a comma-separated list.
  ``1`` if CMake's compiler frontend variant of the HIP compiler matches any one
  of the entries in ``compiler_ids``, otherwise ``0``.

.. genex:: $<ISPC_COMPILER_FRONTEND_VARIANT>

  .. versionadded:: 3.30

  CMake's compiler id of the ISPC compiler used.

.. genex:: $<ISPC_COMPILER_FRONTEND_VARIANT:compiler_ids>

  .. versionadded:: 3.30

  where ``compiler_ids`` is a comma-separated list.
  ``1`` if CMake's compiler frontend variant of the ISPC compiler matches any one
  of the entries in ``compiler_ids``, otherwise ``0``.

.. genex:: $<COMPILE_LANGUAGE>

  .. versionadded:: 3.3

  �������ѡ��ʱԴ�ļ��ı������ԡ��������������ʽ�Ŀ���ֲ�ԣ������\
  :ref:`��صĲ������ʽ <Boolean COMPILE_LANGUAGE Generator Expression>`\
  ``$<COMPILE_LANGUAGE:language>``��

.. _`Boolean COMPILE_LANGUAGE Generator Expression`:

.. genex:: $<COMPILE_LANGUAGE:languages>

  .. versionadded:: 3.3

  .. versionchanged:: 3.15
    ����Ϊ\ ``languages``\ ָ���������ԡ�CMake 3.14������汾ֻ���ܵ�һ���ԡ�

  �����ڱ��뵥Ԫ��������\ ``languages``\ ���κ��Զ��ŷָ�����Ŀƥ��ʱ����Ϊ\ ``1``��\
  ����Ϊ\ ``0``���˱��ʽ������ָ������ѡ����붨�壬����Ŀ���а����ض����Ե�Դ�ļ���Ŀ¼��\
  ���磺

  .. code-block:: cmake

    add_executable(myapp main.cpp foo.c bar.cpp zot.cu)
    target_compile_options(myapp
      PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
    )
    target_compile_definitions(myapp
      PRIVATE $<$<COMPILE_LANGUAGE:CXX>:COMPILING_CXX>
              $<$<COMPILE_LANGUAGE:CUDA>:COMPILING_CUDA>
    )
    target_include_directories(myapp
      PRIVATE $<$<COMPILE_LANGUAGE:CXX,CUDA>:/opt/foo/headers>
    )

  ��ָ���˽�����C++�ģ�������id���ʡ�ԣ�\ ``-fno-exceptions``\ ����ѡ�\
  ``COMPILING_CXX``\ ���붨���\ ``cxx_headers``\ ����Ŀ¼������ΪCUDAָ����\
  ``COMPILING_CUDA``\ ���붨�塣

  ע�⣬��\ :ref:`Visual Studio Generators`\ ��\ :generator:`Xcode`\ �У�\
  û�а취��ʾĿ�귶Χ�ı��붨�壬Ҳû�а취�ֱ����\ ``C``\ ��\ ``CXX``\ ���Ե�Ŀ¼�����ң�\
  ʹ��\ :ref:`Visual Studio Generators`���޷��ֱ�Ϊ\ ``C``\ ���Ժ�\ ``CXX``\ ���Ա�\
  ʾĿ�귶Χ�ı�־������Щ�������£�C��C++Դ�ı��ʽ������κ�C++Դ����ʹ��\ ``CXX``\ ��ֵ��\
  ����ʹ��\ ``C``\ ��ֵ��һ�����������Ϊÿ��Դ�ļ����Դ��������Ŀ⣺

  .. code-block:: cmake

    add_library(myapp_c foo.c)
    add_library(myapp_cxx bar.cpp)
    target_compile_options(myapp_cxx PUBLIC -fno-exceptions)
    add_executable(myapp main.cpp)
    target_link_libraries(myapp myapp_c myapp_cxx)

.. genex:: $<COMPILE_LANG_AND_ID:language,compiler_ids>

  .. versionadded:: 3.15

  �����뵥Ԫʹ�õ�������\ ``language``\ ƥ�䣬��\ ``language``\ ��������CMake�ı�����id��\
  ``compiler_ids``\ ���κ�һ���Զ��ŷָ�����Ŀƥ��ʱ����Ϊ\ ``1``������Ϊ\ ``0``��������ʽ��\
  ``$<COMPILE_LANGUAGE:language>``\ ��\ ``$<LANG_COMPILER_ID:compiler_ids>``\
  ��ϵļ�д��ʽ���˱��ʽ������ָ������ѡ����붨�壬��Ŀ�����ض����Ե�Դ�ļ��ͱ���\
  ����ϵİ���Ŀ¼�����磺

  .. code-block:: cmake

    add_executable(myapp main.cpp foo.c bar.cpp zot.cu)
    target_compile_definitions(myapp
      PRIVATE $<$<COMPILE_LANG_AND_ID:CXX,AppleClang,Clang>:COMPILING_CXX_WITH_CLANG>
              $<$<COMPILE_LANG_AND_ID:CXX,Intel>:COMPILING_CXX_WITH_INTEL>
              $<$<COMPILE_LANG_AND_ID:C,Clang>:COMPILING_C_WITH_CLANG>
    )

  ��ָ���˻��ڱ�����id�ͱ������ԵĲ�ͬ���붨���ʹ�á���Clang��CXX������ʱ��������ӽ���һ��\
  ``COMPILING_CXX_WITH_CLANG``\ ���붨�壬��Intel��CXX������ʱ��������ӽ���һ��\
  ``COMPILING_CXX_WITH_INTEL``\ ���붨�塣ͬ������C��������Clangʱ����ֻ�ܿ���\
  ``COMPILING_C_WITH_CLANG``\ ���塣

  ���û��\ ``COMPILE_LANG_AND_ID``\ ���������ʽ����ͬ���߼�����ʾΪ��

  .. code-block:: cmake

    target_compile_definitions(myapp
      PRIVATE $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CXX_COMPILER_ID:AppleClang,Clang>>:COMPILING_CXX_WITH_CLANG>
              $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CXX_COMPILER_ID:Intel>>:COMPILING_CXX_WITH_INTEL>
              $<$<AND:$<COMPILE_LANGUAGE:C>,$<C_COMPILER_ID:Clang>>:COMPILING_C_WITH_CLANG>
    )

��������
^^^^^^^^^^^^^^^^

.. genex:: $<COMPILE_FEATURES:features>

  .. versionadded:: 3.1

  ����\ ``features``\ ��һ�����ŷָ����б����'head'Ŀ�������\ ``features``\ �����ã�\
  �򷵻�\ ``1``�����򷵻�\ ``0``������ڼ���Ŀ�������ʵ��ʱʹ�ô˱��ʽ����������κ�����\
  ����Ե�������'head'Ŀ�������\ :prop_tgt:`C_STANDARD`\ ��\ :prop_tgt:`CXX_STANDARD`��\
  ��ᱨ������йر������Ե���Ϣ��֧�ֵı������б������\ :manual:`cmake-compile-features(7)`\
  �ֲᡣ

���뻷��
^^^^^^^^^^^^^^^

.. genex:: $<COMPILE_ONLY:...>

  .. versionadded:: 3.27

  Content of ``...``, when collecting
  :ref:`transitive compile properties <Transitive Compile Properties>`������Ϊ���ַ���������\
  ��\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ ��\ :prop_tgt:`LINK_LIBRARIES`\ Ŀ��\
  ���ԣ�ͨ��ͨ��\ :command:`target_link_libraries`\������䡣�ṩ����ʹ�����󣬶�����Ҫ\
  �κ���������

  ����������ͷ�ļ���ʹ�ã��������е�ʹ�ö���֪û�������������磬ȫ\ ``inline``\ ��C++ģ��⣩��

  ע�⣬Ҫ��ȷ����������ʽ����Ҫ������\ :policy:`CMP0099`\ ����Ϊ\ `NEW`��

���������Ժ�ID
^^^^^^^^^^^^^^^^^^^^^^

.. genex:: $<LINK_LANGUAGE>

  .. versionadded:: 3.18

  ��������ѡ��ʱ��Ŀ����������ԡ������\ :ref:`��صĲ������ʽ
  <Boolean LINK_LANGUAGE Generator Expression>` ``$<LINK_LANGUAGE:languages>``��\
  ���˽�����������ʽ�Ŀ���ֲ�ԡ�

  .. note::

    ���ӿ����Բ�֧�ִ����������ʽ���Ա���������Щ���Ե�˫����ֵ�������ĸ����á�


.. _`Boolean LINK_LANGUAGE Generator Expression`:

.. genex:: $<LINK_LANGUAGE:languages>

  .. versionadded:: 3.18

  ���������Ӳ��������ƥ��\ ``languages``\ ���κ��Զ��ŷָ�����Ŀʱ����Ϊ\ ``1``������Ϊ\
  ``0``���˱��ʽ������ָ��Ŀ�����ض����Ե����ӿ⡢����ѡ�����Ŀ¼��������������磺

  .. code-block:: cmake

    add_library(api_C ...)
    add_library(api_CXX ...)
    add_library(api INTERFACE)
    target_link_options(api   INTERFACE $<$<LINK_LANGUAGE:C>:-opt_c>
                                        $<$<LINK_LANGUAGE:CXX>:-opt_cxx>)
    target_link_libraries(api INTERFACE $<$<LINK_LANGUAGE:C>:api_C>
                                        $<$<LINK_LANGUAGE:CXX>:api_CXX>)

    add_executable(myapp1 main.c)
    target_link_options(myapp1 PRIVATE api)

    add_executable(myapp2 main.cpp)
    target_link_options(myapp2 PRIVATE api)

  ��ָ��ʹ��\ ``api``\ Ŀ��������Ŀ��\ ``myapp1``\ ��\ ``myapp2``��ʵ���ϣ�\ ``myapp1``\
  ����Ŀ��\ ``api_C``\ ��ѡ��\ ``-opt_c``\ �������ӣ���Ϊ����ʹ��\ ``C``\ ��Ϊ�������ԡ�\
  ``myapp2``\ ��ʹ��\ ``api_CXX``\ ��ѡ��\ ``-opt_cxx``\ ���ӣ���Ϊ\ ``CXX``\ �����������ԡ�

  .. _`Constraints LINK_LANGUAGE Generator Expression`:

  .. note::

    Ϊ��ȷ��Ŀ����������ԣ���Ҫ���ݵ��ռ������ӵ���������Ŀ�ꡣ��ˣ��������ӿ����ԣ�\
    ������˫�ؼ��㡣�ڵ�һ����ֵ�ڼ䣬\ ``$<LINK_LANGUAGE:..>``\ ���ʽ���Ƿ���\ ``0``��\
    �ڵ�һ�δ���֮�������������Խ����ڵڶ��δ��ݡ�Ϊ�˱��ⲻһ�£�Ҫ��ڶ��δ��ݲ��ı�����\
    ���ԡ����⣬Ϊ�˱�������ĸ����ã���Ҫָ��������ʵ����Ϊ\ ``$<LINK_LANGUAGE:..>``\
    ���ʽ�����磺

    .. code-block:: cmake

      add_library(lib STATIC file.cxx)
      add_library(libother STATIC file.c)

      # bad usage
      add_executable(myapp1 main.c)
      target_link_libraries(myapp1 PRIVATE lib$<$<LINK_LANGUAGE:C>:other>)

      # correct usage
      add_executable(myapp2 main.c)
      target_link_libraries(myapp2 PRIVATE $<$<LINK_LANGUAGE:C>:libother>)

    �ڱ����У�����\ ``myapp1``����һ�δ��ݽ������ȷ������������\ ``CXX``��\
    ��Ϊ���������ʽ�ļ��㽫��һ�����ַ��������\ ``myapp1``\ ��������\ ``C++``\ ��Ŀ��\
    ``lib``���෴������\ ``myapp2``����һ������������\ ``C``\ ��Ϊ�������ԣ�\
    ��˵ڶ�����������ȷ�����Ŀ��\ ``libother``\ ��Ϊ���������

.. genex:: $<LINK_LANG_AND_ID:language,compiler_ids>

  .. versionadded:: 3.18

  ���������Ӳ��������ƥ��\ ``language``\ ����������������CMake������idƥ��\
  ``compiler_ids``\ ���κ�һ�����ŷָ�����Ŀʱ����Ϊ\ ``1``������Ϊ\ ``0``��\
  �ñ��ʽ��\ ``$<LINK_LANGUAGE:language>``\ ��\ ``$<LANG_COMPILER_ID:compiler_ids>``\
  ��ϵļ�д��ʽ���˱��ʽ������ָ��Ŀ�����ض����Ժ���������ϵ����ӿ⡢����ѡ�����Ŀ¼��\
  ������������磺

  .. code-block:: cmake

    add_library(libC_Clang ...)
    add_library(libCXX_Clang ...)
    add_library(libC_Intel ...)
    add_library(libCXX_Intel ...)

    add_executable(myapp main.c)
    if (CXX_CONFIG)
      target_sources(myapp PRIVATE file.cxx)
    endif()
    target_link_libraries(myapp
      PRIVATE $<$<LINK_LANG_AND_ID:CXX,Clang,AppleClang>:libCXX_Clang>
              $<$<LINK_LANG_AND_ID:C,Clang,AppleClang>:libC_Clang>
              $<$<LINK_LANG_AND_ID:CXX,Intel>:libCXX_Intel>
              $<$<LINK_LANG_AND_ID:C,Intel>:libC_Intel>)

  ��ָ���˻��ڱ�����id���������ԵĲ�ͬ���ӿ��ʹ�á���\ ``Clang``\ ��\ ``AppleClang``\ ��\
  ``CXX``\ ������ʱ��������ӽ���Ŀ��\ ``libCXX_Intel``\ ��Ϊ�����������\ ``Intel``\
  ��\ ``CXX``\ ������ʱ������Ŀ��\ ``libCXX_Intel``\ ��Ϊ���������ͬ���أ���\ ``C``\
  ��������\ ``Clang``\ ��\ ``AppleClang``\ ʱ��Ŀ��\ ``libC_Clang``\ �������Ϊ������\
  �����\ ``Intel``\ ��\ ``C``\ ������ʱ��Ŀ��\ ``libC_Intel``\ �������Ϊ���������

  �й�ʹ�ô����������ʽ��Լ���������\ :ref:`��ص�˵��
  <Constraints LINK_LANGUAGE Generator Expression>`\
  ``$<LINK_LANGUAGE:language>``��

��������
^^^^^^^^^^^^^

.. genex:: $<LINK_LIBRARY:feature,library-list>

  .. versionadded:: 3.24

  ָ��һ��Ҫ���ӵ�Ŀ��Ŀ⣬�Լ��ṩ����Ӧ��\ *���*\ �������ǵ���ϸ��Ϣ��\ ``feature``�����磺

  .. code-block:: cmake

    add_library(lib1 STATIC ...)
    add_library(lib2 ...)
    target_link_libraries(lib2 PRIVATE "$<LINK_LIBRARY:WHOLE_ARCHIVE,lib1>")

  ��ָ��\ ``lib2``\ Ӧ�����ӵ�\ ``lib1``������������ʱʹ��\ ``WHOLE_ARCHIVE``\ ���ԡ�

  �����������ִ�Сд��ֻ�ܰ�����ĸ�����ֺ��»��ߡ����д�д���������ƶ�������CMake�Լ�������\
  ���ԡ�Ԥ��������ÿ����԰�����

  .. include:: ../variable/LINK_LIBRARY_PREDEFINED_FEATURES.txt

  ���ú��Զ���������Ǹ������±�������ģ�

  * :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`
  * :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>`
  * :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`
  * :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>`

  ����ÿ��������ֵ���ڴ���Ŀ���Ŀ¼�������ĩβ���õ�ֵ���÷����£�

  1. ����ض������Ե�\ :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`\
     ����Ϊ�棬���\ ``feature``\ ��������Ӧ��\ :variable:`CMAKE_<LANG>_LINK_LIBRARY_USING_<FEATURE>`\
     �������塣
  2. �����֧���ض������Ե�\ ``feature``\ ����\ :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>_SUPPORTED`\
     ��������Ϊ�棬���Ҹ�\ ``feature``\ ��������Ӧ��\ :variable:`CMAKE_LINK_LIBRARY_USING_<FEATURE>`\
     �������塣

  Ӧע���������ƣ�

  * ``library-list``\ ����ָ��CMakeĿ���⡣�κ�\ :ref:`OBJECT <Object Libraries>`\
    ��\ :ref:`INTERFACE <Interface Libraries>`\ ���͵�CMakeĿ�궼�����Ա��ʽ���������棬\
    �����Ա�׼��ʽ���ӡ�

  * ``$<LINK_LIBRARY:...>``\ ���������ʽֻ������ָ�����ӿ⡣ʵ���ϣ�����ζ�������Գ�����\
    :prop_tgt:`LINK_LIBRARIES`��:prop_tgt:`INTERFACE_LINK_LIBRARIES`\ ��\
    :prop_tgt:`INTERFACE_LINK_LIBRARIES_DIRECT`\ Ŀ�������У�����\
    :command:`target_link_libraries`\ ��\ :command:`link_libraries`\ ������ָ����

  * ���\ ``$<LINK_LIBRARY:...>``\ ���������ʽ������Ŀ���\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
    �����У�������������\ :command:`install(EXPORT)`\ �������ɵĵ���Ŀ���С�ʹ�ô˵���\
    �Ļ���������˱��ʽʹ�õ��������ԡ�

  * ���Ӳ������漰��ÿ��Ŀ�������ֻ����һ�ֿ����ԡ�һ�����Ե�ȱʧҲ�������������Բ����ݡ�\
    ���磺

    .. code-block:: cmake

      add_library(lib1 ...)
      add_library(lib2 ...)
      add_library(lib3 ...)

      # lib1 will be associated with feature1
      target_link_libraries(lib2 PUBLIC "$<LINK_LIBRARY:feature1,lib1>")

      # lib1 is being linked with no feature here. This conflicts with the
      # use of feature1 in the line above and would result in an error.
      target_link_libraries(lib3 PRIVATE lib1 lib2)

    ������������������������жԸ�����Ŀ����ʹ����ͬ�����ԣ������ʹ��\
    :prop_tgt:`LINK_LIBRARY_OVERRIDE`\ ��\ :prop_tgt:`LINK_LIBRARY_OVERRIDE_<LIBRARY>`\
    Ŀ��������������಻���������⡣

  * ``$<LINK_LIBRARY:...>``\ ���������ʽ����ָ֤��Ŀ��Ϳ���б����ַ�����һ��\
    Ҫ��GNU ``ld``\ ��������֧�ֵ���������\ ``--start-group``\ ��\ ``--end-group``\
    �����Ĺ��죬��ʹ��\ :genex:`LINK_GROUP`\ ���������ʽ��

.. genex:: $<LINK_GROUP:feature,library-list>

  .. versionadded:: 3.24

  ָ��Ҫ���ӵ�Ŀ��Ŀ��飬�Լ��������Ӧ������ӵ�\ ``feature``������:

  .. code-block:: cmake

    add_library(lib1 STATIC ...)
    add_library(lib2 ...)
    target_link_libraries(lib2 PRIVATE "$<LINK_GROUP:RESCAN,lib1,external>")

  ��ָ��\ ``lib2``\ Ӧ�����ӵ�\ ``lib1``\ ��\ ``external``\ �⣬���Ҹ���\ ``RESCAN``\
  ���ԵĶ��壬�������ⶼӦ�ð������������������С�

  �����������ִ�Сд��ֻ�ܰ�����ĸ�����ֺ��»��ߡ����д�д���������ƶ�������CMake�Լ�������\
  ���ԡ�Ŀǰ��ֻ��һ��Ԥ��������������ԣ�

  .. include:: ../variable/LINK_GROUP_PREDEFINED_FEATURES.txt

  ���ú��Զ����鹦���Ǹ������±�������ģ�

  * :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>_SUPPORTED`
  * :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>`
  * :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>_SUPPORTED`
  * :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>`

  ����ÿ��������ֵ���ڴ���Ŀ���Ŀ¼�������ĩβ���õ�ֵ���÷����£�

  1. ����ض������Ե�\ :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>_SUPPORTED`\
     ����Ϊ�棬���\ ``feature``\ ��������Ӧ��\ :variable:`CMAKE_<LANG>_LINK_GROUP_USING_<FEATURE>`\
     �������塣
  2. �����֧���ض������Ե� ``feature``����\ :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>_SUPPORTED`\
     ��������Ϊ�棬���Ҹ�\ ``feature``\ ��������Ӧ��\
     :variable:`CMAKE_LINK_GROUP_USING_<FEATURE>`\ �������塣

  ``LINK_GROUP``\ ���������ʽ��\ :genex:`LINK_LIBRARY`\ ���������ʽ���ݡ�����ʹ��\
  :genex:`LINK_LIBRARY`\ ���������ʽָ�������漰�Ŀ⡣

  ���Ӳ������漰��ÿ��Ŀ����ⲿ�ⶼ�����Ƕ�����һ���֣���ǰ���������漰���鶼ָ������ͬ��\
  ``feature``���������鲻�����������������ϱ��ϲ�������������Ȼ�ᱻ��������ֹΪ��ͬ��Ŀ��\
  ����ϲ�ͬ����������

  .. code-block:: cmake

    add_library(lib1 ...)
    add_library(lib2 ...)
    add_library(lib3 ...)
    add_library(lib4 ...)
    add_library(lib5 ...)

    target_link_libraries(lib3 PUBLIC  "$<LINK_GROUP:feature1,lib1,lib2>")
    target_link_libraries(lib4 PRIVATE "$<LINK_GROUP:feature1,lib1,lib3>")
    # lib4 will be linked with the groups {lib1,lib2} and {lib1,lib3}.
    # Both groups specify the same feature, so this is fine.

    target_link_libraries(lib5 PRIVATE "$<LINK_GROUP:feature2,lib1,lib3>")
    # An error will be raised here because both lib1 and lib3 are part of two
    # groups with different features.

  ��Ŀ����ⲿ����Ϊ���һ���ֲ������Ӳ��裬ͬʱ�ֲ������κ���ʱ���κγ��ֵķ������������\
  �����������滻��

  .. code-block:: cmake

    add_library(lib1 ...)
    add_library(lib2 ...)
    add_library(lib3 ...)
    add_library(lib4 ...)

    target_link_libraries(lib3 PUBLIC lib1)

    target_link_libraries(lib4 PRIVATE lib3 "$<LINK_GROUP:feature1,lib1,lib2>")
    # lib4 will only be linked with lib3 and the group {lib1,lib2}

  ��Ϊ\ ``lib1``\ ��Ϊ\ ``lib4``\ ��������һ���֣���������齫Ӧ�ûض�\ ``lib3``\ ʹ��\
  ``lib1``�����ս������\ ``lib3``\ �����ӹ�ϵ��ָ��Ϊ��

  .. code-block:: cmake

    target_link_libraries(lib3 PUBLIC "$<LINK_GROUP:feature1,lib1,lib2>")

  ע�⣬������ڷ�������������ȼ����ܵ�����֮���ѭ��������ϵ����������������������������\
  ������Ϊ��������ʹ��ѭ�������

  .. code-block:: cmake

    add_library(lib1A ...)
    add_library(lib1B ...)
    add_library(lib2A ...)
    add_library(lib2B ...)
    add_library(lib3 ...)

    # Non-group linking relationships, these are non-circular so far
    target_link_libraries(lib1A PUBLIC lib2A)
    target_link_libraries(lib2B PUBLIC lib1B)

    # The addition of these groups creates circular dependencies
    target_link_libraries(lib3 PRIVATE
      "$<LINK_GROUP:feat,lib1A,lib1B>"
      "$<LINK_GROUP:feat,lib2A,lib2B>"
    )

  ����Ϊ\ ``lib3``\ �������飬\ ``lib1A``\ ��\ ``lib2B``\ �����ӹ�ϵ��Ч����չΪ�ȼ۵ģ�

  .. code-block:: cmake

    target_link_libraries(lib1A PUBLIC "$<LINK_GROUP:feat,lib2A,lib2B>")
    target_link_libraries(lib2B PUBLIC "$<LINK_GROUP:feat,lib1A,lib1B>")

  ������֮�䴴����һ��ѭ��������\ ``lib1A --> lib2B --> lib1A``��

  ��Ӧע���������ƣ�

  * ``library-list``\ ����ָ��CMakeĿ���⡣�κ�\ :ref:`OBJECT <Object Libraries>`\
    ��\ :ref:`INTERFACE <Interface Libraries>`\ ���͵�CMakeĿ�궼�����Ա��ʽ���������棬\
    �����Ա�׼��ʽ���ӡ�

  * ``$<LINK_GROUP:...>``\ ���������ʽֻ������ָ�����ӿ⡣ʵ���ϣ�����ζ�������Գ�����\
    :prop_tgt:`LINK_LIBRARIES`��:prop_tgt:`INTERFACE_LINK_LIBRARIES`\ ��\
    :prop_tgt:`INTERFACE_LINK_LIBRARIES_DIRECT`\ Ŀ�������У�����\
    :command:`target_link_libraries`\ ��\ :command:`link_libraries`\ ������ָ����

  * ���\ ``$<LINK_GROUP:...>``\ ���������ʽ������Ŀ���\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\
    �����У�������������\ :command:`install(EXPORT)`\ �������ɵĵ���Ŀ���С�ʹ�ô˵���\
    �Ļ���������˱��ʽʹ�õ��������ԡ�

����������
^^^^^^^^^^^^

.. genex:: $<LINK_ONLY:...>

  .. versionadded:: 3.1

  Content of ``...``, except while collecting usage requirements from
  :ref:`transitive compile properties <Transitive Compile Properties>`������������£�\
  ���ǿ��ַ�����������\ :prop_tgt:`INTERFACE_LINK_LIBRARIES`\ Ŀ�������У�ͨ��ͨ��\
  :command:`target_link_libraries`\ ������䣬��ָ��˽������������ϵ��������Ҫ����ʹ��\
  Ҫ���������Ŀ¼�����ѡ�

  .. versionadded:: 3.24
    ``LINK_ONLY``\ Ҳ������\ :prop_tgt:`LINK_LIBRARIES`\ Ŀ��������ʹ�á��μ�����\
    :policy:`CMP0131`��

.. genex:: $<DEVICE_LINK:list>

  .. versionadded:: 3.18

  ������豸���Ӳ��裬�򷵻��б����򷵻ؿ��б��豸���Ӳ�����\ :prop_tgt:`CUDA_SEPARABLE_COMPILATION`\
  ��\ :prop_tgt:`CUDA_RESOLVE_DEVICE_SYMBOLS`\ ���ԺͲ���\ :policy:`CMP0105`\ ���ơ�\
  �˱��ʽֻ������ָ������ѡ�

.. genex:: $<HOST_LINK:list>

  .. versionadded:: 3.18

  �������ͨ�����Ӳ��裬�򷵻��б����򷵻ؿ��б������漰���豸���Ӳ���ʱ���˱��ʽ�൱����\
  �������\ :genex:`$<DEVICE_LINK:list>`\ ���������ʽ�����˱��ʽֻ������ָ������ѡ�


.. _`Target-Dependent Expressions`:

������Ŀ��ı��ʽ
----------------------------

Target Meta-Data
^^^^^^^^^^^^^^^^

These expressions look up information about a target.

.. genex:: $<TARGET_EXISTS:tgt>

  .. versionadded:: 3.12

  ���\ ``tgt``\ ��ΪCMakeĿ����ڣ���Ϊ\ ``1``������Ϊ\ ``0``��

.. genex:: $<TARGET_NAME_IF_EXISTS:tgt>

  .. versionadded:: 3.12

  ���Ŀ����ڣ���Ŀ����\ ``tgt``������Ϊ���ַ�����

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

.. genex:: $<TARGET_NAME:tgt>

  The target name ``tgt`` as written.  This marks ``tgt`` as being the name
  of a target inside a larger expression, which is required if exporting
  targets to multiple dependent export sets.  The ``tgt`` text must be a
  literal name of a target; it may not contain generator expressions.
  The target does not have to exist.

.. genex:: $<TARGET_POLICY:policy>

  ``1`` if the ``policy`` was ``NEW`` when the 'head' target was created,
  else ``0``.  If the ``policy`` was not set, the warning message for the policy
  will be emitted. This generator expression only works for a subset of
  policies.


Target Properties
^^^^^^^^^^^^^^^^^

These expressions look up the values of
:ref:`target properties <Target Properties>`.

.. genex:: $<TARGET_PROPERTY:tgt,prop>

  Ŀ��\ ``tgt``\ �ϵ�����\ ``prop``\ ��ֵ��or empty if
  the property is not set��

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

  .. versionchanged:: 3.26
    ��������\ :ref:`Target Usage Requirements`\ �ڼ�����ʱ��ͨ������\ ``INTERFACE_*``\
    Ŀ�������У���ָ�������Ŀ���Ŀ¼�в���\ ``tgt``\ ���ƣ��������ڼ�����ʽ������Ŀ\
    ���Ŀ¼�С�

.. genex:: $<TARGET_PROPERTY:prop>
  :target: TARGET_PROPERTY:prop

  ����\ ``prop``\ �ڱ��ʽ����ֵ��Ŀ���ϵ�ֵ��or empty if the property is not set��ע�⣬����\ :ref:`Target Usage Requirements`\
  �е����������ʽ����������Ŀ�꣬������ָ�������Ŀ�ꡣ

The expressions have special evaluation rules for some properties:

:ref:`Target Build Specification Properties <Target Build Specification>`
  These evaluate as a :ref:`semicolon-separated list <CMake Language Lists>`
  representing the union of the value on the target itself with the values
  of the corresponding :ref:`Target Usage Requirements` on targets named by
  the target's :prop_tgt:`LINK_LIBRARIES`:

  * For :ref:`Target Compile Properties`, evaluation of corresponding usage
    requirements is transitive over the closure of the linked targets'
    :prop_tgt:`INTERFACE_LINK_LIBRARIES` *excluding* entries guarded by the
    :genex:`LINK_ONLY` generator expression.

  * For :ref:`Target Link Properties`, evaluation of corresponding usage
    requirements is transitive over the closure of the linked targets'
    :prop_tgt:`INTERFACE_LINK_LIBRARIES` *including* entries guarded by the
    :genex:`LINK_ONLY` generator expression.  See policy :policy:`CMP0166`.

  Evaluation of :prop_tgt:`LINK_LIBRARIES` itself is not transitive.

:ref:`Target Usage Requirement Properties <Target Usage Requirements>`
  These evaluate as a :ref:`semicolon-separated list <CMake Language Lists>`
  representing the union of the value on the target itself with the values
  of the same properties on targets named by the target's
  :prop_tgt:`INTERFACE_LINK_LIBRARIES`:

  * For :ref:`Transitive Compile Properties`, evaluation is transitive over
    the closure of the target's :prop_tgt:`INTERFACE_LINK_LIBRARIES`
    *excluding* entries guarded by the :genex:`LINK_ONLY` generator expression.

  * For :ref:`Transitive Link Properties`, evaluation is transitive over
    the closure of the target's :prop_tgt:`INTERFACE_LINK_LIBRARIES`
    *including* entries guarded by the :genex:`LINK_ONLY` generator expression.
    See policy :policy:`CMP0166`.

  Evaluation of :prop_tgt:`INTERFACE_LINK_LIBRARIES` itself is not transitive.

:ref:`Custom Transitive Properties`
  .. versionadded:: 3.30

  These are processed during evaluation as follows:

  * Evaluation of :genex:`$<TARGET_PROPERTY:tgt,PROP>` for some property
    ``PROP``, named without an ``INTERFACE_`` prefix,
    checks the :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`
    and :prop_tgt:`TRANSITIVE_LINK_PROPERTIES` properties on target ``tgt``,
    on targets named by its :prop_tgt:`LINK_LIBRARIES`, and on the
    transitive closure of targets named by the linked targets'
    :prop_tgt:`INTERFACE_LINK_LIBRARIES`.

    If ``PROP`` is listed by one of those properties, then it evaluates as
    a :ref:`semicolon-separated list <CMake Language Lists>` representing
    the union of the value on the target itself with the values of the
    corresponding ``INTERFACE_PROP`` on targets named by the target's
    :prop_tgt:`LINK_LIBRARIES`:

    * If ``PROP`` is named by :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`,
      evaluation of the corresponding ``INTERFACE_PROP`` is transitive over
      the closure of the linked targets' :prop_tgt:`INTERFACE_LINK_LIBRARIES`,
      excluding entries guarded by the :genex:`LINK_ONLY` generator expression.

    * If ``PROP`` is named by :prop_tgt:`TRANSITIVE_LINK_PROPERTIES`,
      evaluation of the corresponding ``INTERFACE_PROP`` is transitive over
      the closure of the linked targets' :prop_tgt:`INTERFACE_LINK_LIBRARIES`,
      including entries guarded by the :genex:`LINK_ONLY` generator expression.

  * Evaluation of :genex:`$<TARGET_PROPERTY:tgt,INTERFACE_PROP>` for some
    property ``INTERFACE_PROP``, named with an ``INTERFACE_`` prefix,
    checks the :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`
    and :prop_tgt:`TRANSITIVE_LINK_PROPERTIES` properties on target ``tgt``,
    and on the transitive closure of targets named by its
    :prop_tgt:`INTERFACE_LINK_LIBRARIES`.

    If the corresponding ``PROP`` is listed by one of those properties,
    then ``INTERFACE_PROP`` evaluates as a
    :ref:`semicolon-separated list <CMake Language Lists>` representing the
    union of the value on the target itself with the value of the same
    property on targets named by the target's
    :prop_tgt:`INTERFACE_LINK_LIBRARIES`:

    * If ``PROP`` is named by :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`,
      evaluation of the corresponding ``INTERFACE_PROP`` is transitive over
      the closure of the target's :prop_tgt:`INTERFACE_LINK_LIBRARIES`,
      excluding entries guarded by the :genex:`LINK_ONLY` generator expression.

    * If ``PROP`` is named by :prop_tgt:`TRANSITIVE_LINK_PROPERTIES`,
      evaluation of the corresponding ``INTERFACE_PROP`` is transitive over
      the closure of the target's :prop_tgt:`INTERFACE_LINK_LIBRARIES`,
      including entries guarded by the :genex:`LINK_ONLY` generator expression.

  If a ``PROP`` is named by both :prop_tgt:`TRANSITIVE_COMPILE_PROPERTIES`
  and :prop_tgt:`TRANSITIVE_LINK_PROPERTIES`, the latter takes precedence.

:ref:`Compatible Interface Properties`
  These evaluate as a single value combined from the target itself,
  from targets named by the target's :prop_tgt:`LINK_LIBRARIES`, and
  from the transitive closure of the linked targets'
  :prop_tgt:`INTERFACE_LINK_LIBRARIES`.  Values of a compatible
  interface property from multiple targets combine based on the type
  of compatibility required by the ``COMPATIBLE_INTERFACE_*`` property
  defining it.


Target Artifacts
^^^^^^^^^^^^^^^^

These expressions look up information about artifacts associated with
a given target ``tgt``.  Unless otherwise stated, this can be any
runtime artifact, namely:

* An executable target created by :command:`add_executable`.
* A shared library target (``.so``, ``.dll`` but not their ``.lib`` import
  library) created by :command:`add_library`.
* A static library target created by :command:`add_library`.

In the following, the phrase "the ``tgt`` filename" means the name of the
``tgt`` binary file. This has to be distinguished from the phrase
"the target name", which is just the string ``tgt``.

.. genex:: $<TARGET_FILE:tgt>

  ``tgt``\ �������ļ�������·����

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵģ����Ǹñ��ʽ��\
  :command:`add_custom_command`\ ��\ :command:`add_custom_target`\ ��ʹ�á�

.. genex:: $<TARGET_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  ``tgt``\ �Ļ������ƣ�������ǰ׺�ͺ�׺��\ ``$<TARGET_FILE_NAME:tgt>``�����磬���\
  ``tgt``\ �ļ�����\ ``libbase.so``��������\ ``base``��

  �������\ :prop_tgt:`OUTPUT_NAME`��\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`��\
  :prop_tgt:`LIBRARY_OUTPUT_NAME`\ ��\ :prop_tgt:`RUNTIME_OUTPUT_NAME`\ Ŀ������\
  �����ض������õı���\ :prop_tgt:`OUTPUT_NAME_<CONFIG>`��\ :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`��\
  :prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>`\ ��\ :prop_tgt:`RUNTIME_OUTPUT_NAME_<CONFIG>`��

  Ҳ���Կ���\ :prop_tgt:`<CONFIG>_POSTFIX`\ ��\ :prop_tgt:`DEBUG_POSTFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

.. genex:: $<TARGET_FILE_PREFIX:tgt>

  .. versionadded:: 3.15

  ``tgt``\ �ļ�����ǰ׺������\ ``lib``����

  ��μ�\ :prop_tgt:`PREFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

.. genex:: $<TARGET_FILE_SUFFIX:tgt>

  .. versionadded:: 3.15

  ``tgt``\ �ļ����ĺ�׺����չ����\ ``.so``\ ��\ ``.exe``����

  ��μ�\ :prop_tgt:`SUFFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

.. genex:: $<TARGET_FILE_NAME:tgt>

  ``tgt``\ �ļ�����

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_FILE_DIR:tgt>

  ``tgt``\ �������ļ���Ŀ¼��

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_IMPORT_FILE:tgt>

  .. versionadded:: 3.27

  �����������ļ�������·������DLLƽ̨�ϣ�������\ ``.lib``\ �ļ�������AIX�ϵĿ�ִ���ļ���\
  ����macOS�ϵĹ���⣬�����Էֱ���\ ``.imp``\ ��\ ``.tbd``\ �����ļ�������ȡ����\
  :prop_tgt:`ENABLE_EXPORTS`\ ���Ե�ֵ��

  ���û����Ŀ������ĵ����ļ����򷵻ؿ��ַ�����

.. genex:: $<TARGET_IMPORT_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.27

  Ŀ���ļ������������ļ��Ļ���\ ``tgt``������ǰ׺���ߺ�׺�����磬Ŀ���ļ���Ϊ\
  ``libbase.tbd``������ļ���Ϊ\ ``base``��

  �������\ :prop_tgt:`OUTPUT_NAME`\ ��\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\ Ŀ������\
  �����ض������õı���\ :prop_tgt:`OUTPUT_NAME_<CONFIG>`\ ��\
  :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`��

  Ҳ���Կ���\ :prop_tgt:`<CONFIG>_POSTFIX`\ ��\ :prop_tgt:`DEBUG_POSTFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_IMPORT_FILE_PREFIX:tgt>

  .. versionadded:: 3.27

  Ŀ��\ ``tgt``\ �����ļ���ǰ׺��

  ����μ�\ :prop_tgt:`IMPORT_PREFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_IMPORT_FILE_SUFFIX:tgt>

  .. versionadded:: 3.27

  Ŀ�굼���ļ��ĺ�׺ ``tgt``��

  ��׺��Ӧ���ļ���չ������\ ``.lib``\ ��\ ``.tbd``����

  ����μ�\ :prop_tgt:`IMPORT_SUFFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_IMPORT_FILE_NAME:tgt>

  .. versionadded:: 3.27

  ``tgt``\ Ŀ��ĵ����ļ�����

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_IMPORT_FILE_DIR:tgt>

  ``tgt``\ Ŀ��ĵ����ļ�Ŀ¼��

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_FILE:tgt>

  ���ӵ�\ ``tgt``\ Ŀ��ʱʹ�õ��ļ�����ͨ����\ ``tgt``\ ��ʾ�Ŀ⣨\ ``.a``��\ ``.lib``��\
  ``.so``����������DLLƽ̨�ϵĹ���⣬��������DLL������\ ``.lib``\ ����⡣

  .. versionadded:: 3.27
    ��macOS�ϣ����������빲��������\ ``.tbd``\ �����ļ�������ȡ����\
    :prop_tgt:`ENABLE_EXPORTS`\ ���Ե�ֵ��

  �����������ʽ�ȼ���\ :genex:`$<TARGET_LINKER_LIBRARY_FILE>`\ ��\
  :genex:`$<TARGET_LINKER_IMPORT_FILE>`\ ���������ʽ������ȡ����Ŀ���ƽ̨��������

.. genex:: $<TARGET_LINKER_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  ��������Ŀ��\ ``tgt``\ �Ļ����ļ���������\ :genex:`$<TARGET_LINKER_FILE_NAME:tgt>` ��\
  ����ǰ׺�ͺ�׺�����磬Ŀ���ļ���Ϊ\ ``libbase.a``����������Ϊ\ ``base``��

  �������\ :prop_tgt:`OUTPUT_NAME`��\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\
  ��\ :prop_tgt:`LIBRARY_OUTPUT_NAME`\ Ŀ�����Լ����ض������õı���\
  :prop_tgt:`OUTPUT_NAME_<CONFIG>`��:prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`\
  ��\ :prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>`��

  Ҳ���Կ���\ :prop_tgt:`<CONFIG>_POSTFIX`\ ��\ :prop_tgt:`DEBUG_POSTFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

.. genex:: $<TARGET_LINKER_FILE_PREFIX:tgt>

  .. versionadded:: 3.15

  ��������Ŀ��\ ``tgt``\ ���ļ�ǰ׺��

  �������\ :prop_tgt:`PREFIX`\ ��\ :prop_tgt:`IMPORT_PREFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

.. genex:: $<TARGET_LINKER_FILE_SUFFIX:tgt>

  .. versionadded:: 3.15

  �������ӵ��ļ���׺������\ ``tgt``\ ��Ŀ������ơ�

  ��׺��Ӧ���ļ���չ��������".so"��".lib"����

  �������\ :prop_tgt:`SUFFIX`\ ��\ :prop_tgt:`IMPORT_SUFFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

.. genex:: $<TARGET_LINKER_FILE_NAME:tgt>

  ��������Ŀ��\ ``tgt``\ ���ļ�����

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_LINKER_FILE_DIR:tgt>

  ��������Ŀ��\ ``tgt``\ ���ļ�Ŀ¼��

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_LINKER_LIBRARY_FILE:tgt>

  .. versionadded:: 3.27

  ���ӵ�\ ``tgt``\ Ŀ��ʱʹ�õ��ļ���ֱ��ʹ�ÿ���ɵģ������ǵ����ļ�����ͨ����\ ``tgt``\
  ��ʾ�Ŀ⣨\ ``.a``��\ ``.so``��\ ``.dylib``������ˣ���DLLƽ̨�ϣ�������һ�����ַ�����

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �Ŀ��ļ��Ļ������ƣ���\
  :genex:`$<TARGET_LINKER_LIBRARY_FILE_NAME:tgt>`������ǰ׺�ͺ�׺�����磬Ŀ���ļ���Ϊ\
  ``libbase.a``������ļ���Ϊ\ ``base``��

  �������\ :prop_tgt:`OUTPUT_NAME`��\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\ ��\
  :prop_tgt:`LIBRARY_OUTPUT_NAME`\ Ŀ�����Լ��������ض��ı���\
  :prop_tgt:`OUTPUT_NAME_<CONFIG>`��\ :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`\
  ��\ :prop_tgt:`LIBRARY_OUTPUT_NAME_<CONFIG>`��

  Ҳ���Կ���\ :prop_tgt:`<CONFIG>_POSTFIX`\ ��\ :prop_tgt:`DEBUG_POSTFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_PREFIX:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �Ŀ��ļ�ǰ׺��

  ����μ�\ :prop_tgt:`PREFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_SUFFIX:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �Ŀ��ļ���׺��

  ��׺��Ӧ���ļ���չ�����硰.a����.dylib������

  ����μ�\ :prop_tgt:`SUFFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_NAME:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �Ŀ��ļ�����

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_LIBRARY_FILE_DIR:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �Ŀ��ļ�Ŀ¼��

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_IMPORT_FILE:tgt>

  .. versionadded:: 3.27

  ʹ�õ����ļ����ӵ�\ ``tgt``\ Ŀ��ʱʹ�õ��ļ�����ͨ����\ ``tgt``\ ��ʾ�ĵ����ļ���\
  ``.lib``��\ ``.tbd``������ˣ������Ӳ�����û���漰�����ļ�ʱ��������һ�����ַ�����

.. genex:: $<TARGET_LINKER_IMPORT_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �ĵ����ļ��Ļ������ƣ���\
  :genex:`$<TARGET_LINKER_IMPORT_FILE_NAME:tgt>`\ ������ǰ׺�ͺ�׺�����磬���Ŀ����\
  ����Ϊ\ ``libbase.tbd``������ļ���Ϊ\ ``base``��

  �������\ :prop_tgt:`OUTPUT_NAME`\ ��\ :prop_tgt:`ARCHIVE_OUTPUT_NAME`\ Ŀ������\
  ���������ض��ı���\ :prop_tgt:`OUTPUT_NAME_<CONFIG>`\ ��\
  :prop_tgt:`ARCHIVE_OUTPUT_NAME_<CONFIG>`��

  Ҳ���Կ���\ :prop_tgt:`<CONFIG>_POSTFIX`\ ��\ :prop_tgt:`DEBUG_POSTFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_IMPORT_FILE_PREFIX:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �ĵ����ļ���ǰ׺��

  ����μ�\ :prop_tgt:`IMPORT_PREFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_IMPORT_FILE_SUFFIX:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �ĵ����ļ��ĺ�׺��

  ��׺��Ӧ���ļ���չ�����硰.lib����.tbd������

  ����μ�\ :prop_tgt:`IMPORT_SUFFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_IMPORT_FILE_NAME:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �ĵ����ļ�����

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_LINKER_IMPORT_FILE_DIR:tgt>

  .. versionadded:: 3.27

  ��������Ŀ��\ ``tgt``\ �ĵ����ļ���Ŀ¼��

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_SONAME_FILE:tgt>

  ����soname��\ ``.so.3``�����ļ�������\ ``tgt``\ ��Ŀ������ơ�

.. genex:: $<TARGET_SONAME_FILE_NAME:tgt>

  ����soname��\ ``.so.3``�����ļ�����

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_SONAME_FILE_DIR:tgt>

  soname��\ ``.so.3``\ �����ļ�Ŀ¼��

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_SONAME_IMPORT_FILE:tgt>

  .. versionadded:: 3.27

  ʹ��soname��\ ``.3.tbd``\ �������ļ�������\ ``tgt``\ ��Ŀ������ơ�

.. genex:: $<TARGET_SONAME_IMPORT_FILE_NAME:tgt>

  .. versionadded:: 3.27

  ʹ��soname��\ ``.3.tbd``\ �������ļ������ơ�

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_SONAME_IMPORT_FILE_DIR:tgt>

  .. versionadded:: 3.27

  ʹ��sonname��\ ``.3.tbd``\ �������ļ���Ŀ¼��

  ��ע�⣬\ ``tgt``\ ��������Ϊ����ñ��ʽ��Ŀ�����������ӵġ�

.. genex:: $<TARGET_PDB_FILE:tgt>

  .. versionadded:: 3.1

  ���������ɵĳ������ݿ��ļ���.pdb��������·��������\ ``tgt``\ ��Ŀ������ơ�

  �������\ :prop_tgt:`PDB_NAME`\ ��\ :prop_tgt:`PDB_OUTPUT_DIRECTORY`\ Ŀ�����Լ�\
  ���ض������õı���\ :prop_tgt:`PDB_NAME_<CONFIG>`\ ��\
  :prop_tgt:`PDB_OUTPUT_DIRECTORY_<CONFIG>`��

.. genex:: $<TARGET_PDB_FILE_BASE_NAME:tgt>

  .. versionadded:: 3.15

  ���������ɵĳ������ݿ��ļ���.pdb���Ļ������ƣ�����\ ``tgt``\ ��Ŀ������ơ�

  �������ƶ�Ӧ�ڲ���ǰ׺�ͺ�׺��Ŀ��PDB�ļ������μ�\ ``$<TARGET_PDB_FILE_NAME:tgt>``����\
  ���磬���Ŀ���ļ�����\ ``base.pdb``����������Ϊ\ ``base``��

  �������\ :prop_tgt:`PDB_NAME`\ Ŀ�����Լ����ض������õı���\ :prop_tgt:`PDB_NAME_<CONFIG>`��

  Ҳ���Կ���\ :prop_tgt:`<CONFIG>_POSTFIX`\ ��\ :prop_tgt:`DEBUG_POSTFIX`\ Ŀ�����ԡ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӡ�

.. genex:: $<TARGET_PDB_FILE_NAME:tgt>

  .. versionadded:: 3.1

  ���������ɵĳ������ݿ��ļ���.pdb�������ơ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_PDB_FILE_DIR:tgt>

  .. versionadded:: 3.1

  ���������ɵĳ������ݿ��ļ���.pdb����Ŀ¼��

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_BUNDLE_DIR:tgt>

  .. versionadded:: 3.9

  bundleĿ¼������·����\ ``/path/to/my.app``��\ ``/path/to/my.framework``\ ����\
  ``/path/to/my.bundle``��������\ ``tgt``\ ��Ŀ������ơ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_BUNDLE_DIR_NAME:tgt>

  .. versionadded:: 3.24

  bundleĿ¼�����ƣ�\ ``my.app``��\ ``my.framework``\ ����\ ``my.bundle``��������\
  ``tgt``\ ��Ŀ������ơ�

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_BUNDLE_CONTENT_DIR:tgt>

  .. versionadded:: 3.9

  bundle����Ŀ¼������·��������\ ``tgt``\ ��Ŀ������ơ�����macOS SDK����ָ��\
  ``/path/to/my.app/Contents``��\ ``/path/to/my.framework``\ ��\
  ``/path/to/my.bundle/Contents``��������������SDK������iOS������ָ��\
  ``/path/to/my.app``��\ ``/path/to/my.framework``\ ��\ ``/path/to/my.bundle`` ��\
  ��Ϊ���ǵı�ƽbundle�ṹ��

  ��ע�⣬\ ``tgt``\ ��û����Ϊ����ñ��ʽ��Ŀ�����������ӣ�����Ĳ���\ :policy:`CMP0112`����

.. genex:: $<TARGET_OBJECTS:tgt>

  .. versionadded:: 3.1

  List of objects resulting from building ``tgt``.  This would typically be
  used on :ref:`object library <Object Libraries>` targets.

.. genex:: $<TARGET_RUNTIME_DLLS:tgt>

  .. versionadded:: 3.21

  Ŀ��������ʱ������DLL�б�������Ŀ��Ĵ��������������� ``SHARED`` Ŀ���λ�þ����ġ�\
  ���ֻ��ҪDLL���ڵ�Ŀ¼����μ�\ :genex:`TARGET_RUNTIME_DLL_DIRS`\ ���������ʽ��
  �ڿ�ִ���ļ���\ ``SHARED``\ ���\ ``MODULE``\ �������Ŀ����ʹ�ô����������ʽ�Ǵ���ġ�\
  **�ڷ�dllƽ̨�ϣ�������ʽ������ֵΪ���ַ���**��

  ����ʹ��\ :option:`cmake -E copy -t <cmake-E copy>`\
  ���Ŀ��������������DLL���Ƶ�\ ``POST_BUILD``\ �Զ�����������Ŀ¼�С����磺

  .. code-block:: cmake

    find_package(foo CONFIG REQUIRED) # package generated by install(EXPORT)

    add_executable(exe main.c)
    target_link_libraries(exe PRIVATE foo::foo foo::bar)
    add_custom_command(TARGET exe POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:exe> $<TARGET_RUNTIME_DLLS:exe>
      COMMAND_EXPAND_LISTS
    )

  .. note::

    :ref:`Imported Targets`\ ��Ŀ��ֻ����֪����\ ``.dll``\ �ļ���λ��ʱ�Żᱻ֧�֡�\
    �����\ ``SHARED``\ ����뽫\ :prop_tgt:`IMPORTED_LOCATION`\ ����Ϊ��\ ``.dll``\
    �ļ����й���ϸ��Ϣ�������\ :ref:`add_library����� <add_library imported libraries>`\
    ���֡�������ģ������\ ``UNKNOWN``\ ���͵ĵ���Ŀ�꣬��˽������ԡ�

  ��֧������ʱ·����\ ``RPATH``\ ����ƽ̨�ϣ���ο�\ :prop_tgt:`INSTALL_RPATH`\ Ŀ�����ԡ�\
  ��Appleƽ̨�ϣ���ο�\ :prop_tgt:`INSTALL_NAME_DIR`\ Ŀ�����ԡ�

.. genex:: $<TARGET_RUNTIME_DLL_DIRS:tgt>

  .. versionadded:: 3.27

  ����Ŀ������ʱ��������DLL��Ŀ¼�б��μ�\ :genex:`TARGET_RUNTIME_DLLS`\ ����������Ŀ\
  ��Ĵ���������������\ ``SHARED``\ Ŀ���λ�þ����ġ��ڿ�ִ���ļ���\ ``SHARED``\ ���\
  ``MODULE``\ �������Ŀ����ʹ�ô����������ʽ�Ǵ���ġ�\ **�ڷ�DLLƽ̨�ϣ��˱��ʽ�ļ���\
  ���ʼ��Ϊ���ַ���**��

  ������������ʽ������������һ���������ļ���ʹ��\ :command:`file(GENERATE)`\ ��������\
  Ӧ��PATH����������

�����Ͱ�װ���ʽ
------------------------------

.. genex:: $<INSTALL_INTERFACE:...>

  ``...``\ �����ݵ�ʹ��\ :command:`install(EXPORT)`\ ��������ʱ������Ϊ�ա�

.. genex:: $<BUILD_INTERFACE:...>

  ��ʹ��\ :command:`export`\ ��������ʱ��\ ``...``\ ���ݣ����ߵ�Ŀ�걻ͬһ����ϵͳ�е�\
  ��һ��Ŀ��ʹ��ʱ������չ��Ϊ���ַ�����

.. genex:: $<BUILD_LOCAL_INTERFACE:...>

  .. versionadded:: 3.26

  ``...``\ �����ݵ�Ŀ�걻ͬһ����ϵͳ�е���һ��Ŀ��ʹ��ʱ������չ��Ϊ���ַ�����

.. genex:: $<INSTALL_PREFIX>

  ��ͨ��\ :command:`install(EXPORT)`\ ����Ŀ��ʱ������\ :prop_tgt:`INSTALL_NAME_DIR`\
  ���ԡ�\ :command:`install(RUNTIME_DEPENDENCY_SET)`\ ��\ ``INSTALL_NAME_DIR``\
  ��������ֵʱ����װǰ׺�����ݣ�����Ϊ�ա�

  .. versionchanged:: 3.27
    ����Ϊ\ :command:`install(CODE)`\ ��code������\ :command:`install(SCRIPT)`\
    ���ļ������еİ�װǰ׺���ݡ�

�����ʽ��ֵ
---------------------------------

.. genex:: $<GENEX_EVAL:expr>

  .. versionadded:: 3.12

  �ڵ�ǰ����������Ϊ���������ʽ�����\ ``expr``\ �����ݡ�������ʹ�����������ʽ��\
  �����������������������ʽ��

.. genex:: $<TARGET_GENEX_EVAL:tgt,expr>

  .. versionadded:: 3.12

  ``expr``\ ��������\ ``tgt``\ Ŀ�������������Ϊ���������ʽ���㡣������ʹ�ñ����������\
  �����ʽ���Զ���Ŀ�����ԡ�

  ����ϣ������֧�����������ʽ���Զ�������ʱ�����м������������ʽ�Ĺ��ܷǳ����á����磺

  .. code-block:: cmake

    add_library(foo ...)

    set_property(TARGET foo PROPERTY
      CUSTOM_KEYS $<$<CONFIG:DEBUG>:FOO_EXTRA_THINGS>
    )

    add_custom_target(printFooKeys
      COMMAND ${CMAKE_COMMAND} -E echo $<TARGET_PROPERTY:foo,CUSTOM_KEYS>
    )

  ``printFooKeys``\ �Զ�������ļ�ʵ���Ǵ���ģ���Ϊ\ ``CUSTOM_KEYS``\ Ŀ������û�б����㣬\
  �������ݰ�ԭ�����ݣ���\ ``$<$<CONFIG:DEBUG>:FOO_EXTRA_THINGS>``����

  Ϊ�˵õ�Ԥ�ڵĽ�������磬���config��\ ``Debug``����\ ``FOO_EXTRA_THINGS``����\
  ��Ҫ����\ ``$<TARGET_PROPERTY:foo,CUSTOM_KEYS>``\ �������

  .. code-block:: cmake

    add_custom_target(printFooKeys
      COMMAND ${CMAKE_COMMAND} -E
        echo $<TARGET_GENEX_EVAL:foo,$<TARGET_PROPERTY:foo,CUSTOM_KEYS>>
    )

ת���ַ�
------------------

��Щ���ʽ��ֵΪ�ض����ַ�����������ʹ������������ʵ�ʵ��ַ������������Է�ֹ���Ǿ�������ĺ��塣

.. genex:: $<ANGLE-R>

  һ��\ ``>``\ �����������磬���ڱȽϰ���\ ``>``\ ���ַ�����

.. genex:: $<COMMA>

  һ��\ ``,``\ �����������ڱȽϰ���\ ``,``\ ���ַ�����

.. genex:: $<SEMICOLON>

  һ��\ ``;``\ �����������ڷ�ֹ\ ``;``\ �Բ��������б���չ��

.. genex:: $<QUOTE>

  .. versionadded:: 3.30

  A literal ``"``. Used to allow string literal quotes inside a generator expression.


���ñ��ʽ
----------------------

.. genex:: $<CONFIGURATION>

  �������ơ�CMake 3.0�������á���\ :genex:`CONFIG`\ ���档
