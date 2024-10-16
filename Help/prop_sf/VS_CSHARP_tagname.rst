VS_CSHARP_<tagname>
-------------------

.. versionadded:: 3.8

Visual Studio和CSharp特定于源文件的配置。

Tell the :manual:`Visual Studio generators <cmake-generators(7)>`
to set the source file tag ``<tagname>``
to a given value in the generated Visual Studio CSharp
project. Ignored on other generators and languages. This property
can be used to define dependencies between source files or set any
other Visual Studio specific parameters.

Example usage:

.. code-block:: cmake

  set_source_files_properties(<filename>
           PROPERTIES
           VS_CSHARP_DependentUpon <other file>
           VS_CSHARP_SubType "Form")
