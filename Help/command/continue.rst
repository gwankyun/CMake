continue
--------

.. versionadded:: 3.2

跳到foreach或者while循环的开头。

.. code-block:: cmake

  continue()

The ``continue()`` command allows a cmake script to abort the rest of the
current iteration of a :command:`foreach` or :command:`while` loop, and start
at the top of the next iteration.

See also the :command:`break` command.
