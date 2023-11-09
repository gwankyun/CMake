INTERFACE_SOURCES
-----------------

.. versionadded:: 3.1

要编译成消费目标的接口源列表。

Targets may populate this property to publish the sources
for consuming targets to compile.  The :command:`target_sources` command
populates this property with values given to the ``PUBLIC`` and
``INTERFACE`` keywords.  Projects may also get and set the property directly.

When target dependencies are specified using :command:`target_link_libraries`,
CMake will read this property from all target dependencies to determine the
sources of the consumer.

Contents of ``INTERFACE_SOURCES`` may use "generator expressions"
with the syntax ``$<...>``.  See the :manual:`cmake-generator-expressions(7)`
manual for available expressions.  See the :manual:`cmake-buildsystem(7)`
manual for more on defining buildsystem properties.
