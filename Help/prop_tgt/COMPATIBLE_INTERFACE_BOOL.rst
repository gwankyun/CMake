COMPATIBLE_INTERFACE_BOOL
-------------------------

属性，这些属性必须与其链接接口兼容

The ``COMPATIBLE_INTERFACE_BOOL`` property may contain a list of
properties for this target which must be consistent when evaluated as a
boolean with the ``INTERFACE`` variant of the property in all linked
dependees.  For example, if a property ``FOO`` appears in the list, then
for each dependee, the ``INTERFACE_FOO`` property content in all of its
dependencies must be consistent with each other, and with the ``FOO``
property in the depender.

Consistency in this sense has the meaning that if the property is set,
then it must have the same boolean value as all others, and if the
property is not set, then it is ignored.

Note that for each dependee, the set of properties specified in this
property must not intersect with the set specified in any of the other
:ref:`Compatible Interface Properties`.
