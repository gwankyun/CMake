endfunction
-----------

在foreach块中结束命令列表。

.. code-block:: cmake

  endfunction([<name>])

See the :command:`function` command.

The optional ``<name>`` argument is supported for backward compatibility
only. If used it must be a verbatim repeat of the ``<name>`` argument
of the opening ``function`` command.
