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

  This option sets or unsets the specified variables in the parent directory or
  function caller scope. This is equivalent to :command:`set(PARENT_SCOPE)` or
  :command:`unset(PARENT_SCOPE)` commands, except for the way it interacts
  with the :command:`block` command, as described below.

  The ``PROPAGATE`` option can be very useful in conjunction with the
  :command:`block` command.  A ``return`` will propagate the
  specified variables through any enclosing block scopes created by the
  :command:`block` commands.  Inside a function, this ensures the variables
  are propagated to the function's caller, regardless of any blocks within
  the function.  If not inside a function, it ensures the variables are
  propagated to the parent file or directory scope. For example:

  .. code-block:: cmake
    :caption: CMakeLists.txt

    cmake_minimum_required(VERSION 3.25)
    project(example)

    set(var1 "top-value")

    block(SCOPE_FOR VARIABLES)
      add_subdirectory(subDir)
      # var1 has the value "block-nested"
    endblock()

    # var1 has the value "top-value"

  .. code-block:: cmake
    :caption: subDir/CMakeLists.txt

    function(multi_scopes result_var1 result_var2)
      block(SCOPE_FOR VARIABLES)
        # This would only propagate out of the immediate block, not to
        # the caller of the function.
        #set(${result_var1} "new-value" PARENT_SCOPE)
        #unset(${result_var2} PARENT_SCOPE)

        # This propagates the variables through the enclosing block and
        # out to the caller of the function.
        set(${result_var1} "new-value")
        unset(${result_var2})
        return(PROPAGATE ${result_var1} ${result_var2})
      endblock()
    endfunction()

    set(var1 "some-value")
    set(var2 "another-value")

    multi_scopes(var1 var2)
    # Now var1 will hold "new-value" and var2 will be unset

    block(SCOPE_FOR VARIABLES)
      # This return() will set var1 in the directory scope that included us
      # via add_subdirectory(). The surrounding block() here does not limit
      # propagation to the current file, but the block() in the parent
      # directory scope does prevent propagation going any further.
      set(var1 "block-nested")
      return(PROPAGATE var1)
    endblock()

See Also
^^^^^^^^

* :command:`block`
* :command:`function`
