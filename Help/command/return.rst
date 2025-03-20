return
------

从文件、目录或函数中返回。

.. code-block:: cmake

  return([PROPAGATE <var-name>...])

当在包含的文件中（通过\ :command:`include`\ 或\ :command:`find_package`\ ）遇到此命令时，\
它将停止当前文件的处理，并将控制权返回给包含它的文件。如果在一个没有被其他文件包含的文件中遇到\
该命令，例如一个\ ``CMakeLists.txt``\ 文件，则会调用由\ :command:`cmake_language(DEFER)`\
安排的延迟调用，并且如果有父目录，控制权将返回给父目录。

如果在函数中调用\ ``return()``，控制权将返回给该函数的调用者。需要注意的是，与\
:command:`function`\ 不同，\ :command:`macro`\ 是就地展开的，因此无法处理\ ``return()``。

策略\ :policy:`CMP0140`\ 控制着该命令参数的行为。除非该策略设置为\ ``NEW``，否则所有参数\
都将被忽略。

``PROPAGATE``
  .. versionadded:: 3.25

  此选项会在父目录或函数调用者的作用域中设置或取消设置指定的变量。这等同于使用\
  :command:`set(PARENT_SCOPE)`\ 或\ :command:`unset(PARENT_SCOPE)`\ 命令，不过在与\
  :command:`block`\ 命令交互的方式上有所不同，具体如下所述。

  ``PROPAGATE``\ 选项与\ :command:`block`\ 命令结合使用时非常有用。使用\ ``return``\
  命令时，它会将指定的变量传播到由\ :command:`block`\ 命令创建的任何封闭块作用域中。\
  在函数内部，这可以确保变量被传播到函数的调用者，无论函数内部是否有块。如果不在函数内部，\
  它可以确保变量被传播到父文件或目录作用域。例如：

  .. code-block:: cmake
    :caption: CMakeLists.txt

    cmake_minimum_required(VERSION 3.25)
    project(example)

    set(var1 "top-value")

    block(SCOPE_FOR VARIABLES)
      add_subdirectory(subDir)
      # var1的值为"block-nested"
    endblock()

    # var1的值为"top-value"

  .. code-block:: cmake
    :caption: subDir/CMakeLists.txt

    function(multi_scopes result_var1 result_var2)
      block(SCOPE_FOR VARIABLES)
        # 这只会将变量传播出当前所在的块作用域，而不会传播到
        # 函数的调用者。
        #set(${result_var1} "new-value" PARENT_SCOPE)
        #unset(${result_var2} PARENT_SCOPE)

        # 这会将变量通过封闭块传播出去，并传递给
        # 函数的调用者。
        set(${result_var1} "new-value")
        unset(${result_var2})
        return(PROPAGATE ${result_var1} ${result_var2})
      endblock()
    endfunction()

    set(var1 "some-value")
    set(var2 "another-value")

    multi_scopes(var1 var2)
    # 现在，var1的值将为"new-value"，而var2将被取消设置。

    block(SCOPE_FOR VARIABLES)
      # 这个return()语句会在通过add_subdirectory()包含
      # 当前文件的目录作用域中设置var1。此处周围的block()
      # 不会将传播范围限制在当前文件内，但父目录作用域中的
      # block()会阻止其进一步传播。
      set(var1 "block-nested")
      return(PROPAGATE var1)
    endblock()

另请参阅
^^^^^^^^

* :command:`block`
* :command:`function`
