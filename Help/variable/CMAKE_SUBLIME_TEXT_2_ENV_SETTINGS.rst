CMAKE_SUBLIME_TEXT_2_ENV_SETTINGS
---------------------------------

.. versionadded:: 3.8

这个变量包含一个env变量列表，它是一个令牌列表，语法为\ ``var=value``。

Example:

.. code-block:: cmake

  set(CMAKE_SUBLIME_TEXT_2_ENV_SETTINGS
     "FOO=FOO1\;FOO2\;FOON"
     "BAR=BAR1\;BAR2\;BARN"
     "BAZ=BAZ1\;BAZ2\;BAZN"
     "FOOBAR=FOOBAR1\;FOOBAR2\;FOOBARN"
     "VALID="
     )

In case of malformed variables CMake will fail:

.. code-block:: cmake

  set(CMAKE_SUBLIME_TEXT_2_ENV_SETTINGS
      "THIS_IS_NOT_VALID"
      )
