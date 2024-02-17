# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindPackageMessage
------------------

.. code-block:: cmake

  find_package_message(<name> "message for user" "find result details")

这个函数打算在FindXXX.cmake模块文件中使用。它将为每个唯一的查找结果打印一条消息。这用于告\
诉用户找到包的位置。第一个参数指定包的名称（XXX）。第二个参数指定要显示的消息。第三个参数列\
出了查找结果的详细信息，因此如果它们更改了消息将再次显示。宏还遵守find_package命令的QUIET\
参数。

Example:

.. code-block:: cmake

  if(X11_FOUND)
    find_package_message(X11 "Found X11: ${X11_X11_LIB}"
      "[${X11_X11_LIB}][${X11_INCLUDE_DIR}]")
  else()
   ...
  endif()
#]=======================================================================]

function(find_package_message pkg msg details)
  # Avoid printing a message repeatedly for the same find result.
  if(NOT ${pkg}_FIND_QUIETLY)
    string(REPLACE "\n" "" details "${details}")
    set(DETAILS_VAR FIND_PACKAGE_MESSAGE_DETAILS_${pkg})
    if(NOT "${details}" STREQUAL "${${DETAILS_VAR}}")
      # The message has not yet been printed.
      string(STRIP "${msg}" msg)
      message(STATUS "${msg}")

      # Save the find details in the cache to avoid printing the same
      # message again.
      set("${DETAILS_VAR}" "${details}"
        CACHE INTERNAL "Details about finding ${pkg}")
    endif()
  endif()
endfunction()
