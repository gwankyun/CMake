# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindCygwin
----------

查找Cygwin，这是一个与POSIX兼容的环境，原生运行在Microsoft Windows上
#]=======================================================================]

if (WIN32)
  if(CYGWIN_INSTALL_PATH)
    set(CYGWIN_BAT "${CYGWIN_INSTALL_PATH}/cygwin.bat")
  endif()

  find_program(CYGWIN_BAT
    NAMES cygwin.bat
    PATHS
      "C:/Cygwin"
      "C:/Cygwin64"
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Cygwin\\setup;rootdir]"
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Cygnus Solutions\\Cygwin\\mounts v2\\/;native]"
  )
  get_filename_component(CYGWIN_INSTALL_PATH "${CYGWIN_BAT}" DIRECTORY)
  mark_as_advanced(CYGWIN_BAT)

endif ()
