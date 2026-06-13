ctest_run_script
----------------

运行\ :option:`ctest -S`\ 脚本。

.. code-block:: cmake

  ctest_run_script([NEW_PROCESS]
                   <script-file>...
                   [RETURN_VALUE <result-var>]
                   )

Runs a script or scripts much like if it was run from :option:`ctest -S`.
The options are:

``NEW_PROCESS``
  Run each script in a separate process.

``RETURN_VALUE <result-var>``
  Store in the ``<result-var>`` variable ``0`` for success and
  non-zero on failure.
