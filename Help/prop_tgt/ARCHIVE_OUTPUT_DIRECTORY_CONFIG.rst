ARCHIVE_OUTPUT_DIRECTORY_<CONFIG>
---------------------------------

:ref:`ARCHIVE <Archive Output Artifacts>`\ 目标文件的配置输出目录。

This is a per-configuration version of the
:prop_tgt:`ARCHIVE_OUTPUT_DIRECTORY` target property, but
multi-configuration generators (VS, Xcode) do NOT append a
per-configuration subdirectory to the specified directory.  This
property is initialized by the value of the
:variable:`CMAKE_ARCHIVE_OUTPUT_DIRECTORY_<CONFIG>` variable if
it is set when a target is created.

Contents of ``ARCHIVE_OUTPUT_DIRECTORY_<CONFIG>`` may use
:manual:`generator expressions <cmake-generator-expressions(7)>`.
