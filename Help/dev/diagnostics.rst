CMake Diagnostics Guide
***********************

The following is a guide on how CMake should issue diagnostics.
See documentation on `CMake Development`_ for more information.

.. _`CMake Development`: README.rst

TL;DR Porting Guide (from CMake < 4.4)
======================================

I want to write ``IssueMessage(MessageType::AUTHOR_WARNING, ...``:
  Write ``IssueDiagnostic(cmDiagnostics::CMD_AUTHOR, ...`` instead.

I want to write ``IssueMessage(MessageType::DEPRECATION_WARNING, ...``:
  Write ``IssueDiagnostic(cmDiagnostics::CMD_DEPRECATED, ...`` instead.

I want to write ``IssueMessage(MessageType::AUTHOR_ERROR, ...``:
  No, you don't.  Under the old system, there isn't a meaningful difference
  between ``AUTHOR_WARNING`` and ``AUTHOR_ERROR``; at least, not as arguments
  to ``IssueMessage``.

I want to write ``IssueMessage(MessageType::DEPRECATION_ERROR, ...``:
  See ``AUTHOR_ERROR``.

History
=======

Prior to CMake 4.4, CMake did not have a formal system for issuing diagnostics.
The messaging system had message types for author diagnostics and deprecation
diagnostics which conflated category and severity.  Worse, although these types
*purported* to allow the caller to specify severity, this information is not
actually honored.  Other diagnostics existed which did not use these types.

More importantly, the mechanisms for managing severity differed depending on
the diagnostic.  Variables to control a diagnostic might be documented,
undocumented, or non-existent.  Spelling of command-line options to control
diagnostics was inconsistent, as was the ability to make diagnostics fatal.
Adding new categories required significant effort, as the logic to handle a
diagnostic was bespoke at every layer.

CMake Diagnostic Framework
==========================

CMake 4.4 introduced a structured framework for issuing and managing
diagnostics.  The ``cmDiagnostics.h`` header enumerates all available
diagnostic categories.  All code to manage diagnostics leverages either this
table or helper code generated from the same, such that it is the *only*
non-documentation location that needs to be updated to add a new diagnostic
category.  The framework is also responsible for determining the severity of a
diagnostic, based on the combination of category defaults and user preferences,
and for presenting the user with a consistent set of control mechanisms.

Numeric identifiers associated with diagnostic categories are only used
internally and are never persisted. This means that numbers can be reassigned
at any time. This also permits ensuring that numbers are consecutive, which
allows iterating over all categories using a simple ``for`` loop.  (Note that
such loops will typically start from ``1``, not ``0``, as ``0`` is reserved
for the 'NONE' category which is used primarily as a virtual parent.)  Where
necessary, macros provided by ``cmDiagnostics.h`` can generate code for each
diagnostic category.

Refer to ``Help/manual/cmake-diagnostics.7.rst`` for user-facing documentation.

Issuing Diagnostics
===================

Diagnostics are the CMake equivalent of compiler warnings, with categorization
providing both additional information and additional response control to users.

Diagnostics are issued via the ``IssueDiagnostic`` method.  This method is
provided on various objects, with ``cmMakefile`` being the most prominent, and
typically exists alongside an ``IssueMessage`` method.  The latter is not
deprecated, and should still be used to issue messages outside of the
diagnostic categories, such as hard errors or informational messages.

The historic ``{AUTHOR,DEPRECATION}_{WARNING,ERROR}`` message types, however,
have been removed.  These are replaced by ``IssueDiagnostic`` and the
``CMD_{AUTHOR,DEPRECATED}`` diagnostic categories.  Because the methods have
similar signatures, porting in many cases can be accomplished by replacing the
method name and first argument (the former message type, newly the diagnostic
category).  For example, where prior versions of CMake wrote:

.. code:: c++

  mf->IssueMessage(MessageType::AUTHOR_WARNING, ...);

CMake 4.4 and later should write:

.. code:: c++

  mf->IssueDiagnostic(cmDiagnostics::CMD_AUTHOR, ...);

(Note that the ``"cmDiagnostics.h"`` header may need to be newly included.)

As previously mentioned, the purported severity was ignored by ``cmMessenger``,
which instead used its own internal state to decide whether a message should
be a warning or an error.  This logic overrode the severity component of the
message type as passed into the method.  As a result, although the new method
does not accept a severity, this is actually consistent with the historic
behavior and does not represent any loss of functionality.

.. note::

  When issuing diagnostics targeted at build-system authors, please consult the
  complete list of available diagnostics, as a more specific category may be
  available.  In some cases, it may even make sense to add a new category.

Adding Diagnostic Categories
============================

Adding new diagnostic categories involves four steps.

1.  The new category must be added to ``cmDiagnostics.h``.  The diagnostics
    table looks like this:

    .. code:: c++

      #define CM_FOR_EACH_DIAGNOSTIC_TABLE(ACTION, SELECT)      \
        SELECT(ACTION, Warn, CMD_NONE, CMD_AUTHOR, 12)          \
        SELECT(ACTION, Warn, CMD_AUTHOR, CMD_DEPRECATED, 1)     \
        ...

    Add a new entry.  All entries must begin with ``SELECT(ACTION,``.  The
    second argument is the *default* state of the diagnostic and should
    typically be ``Warn``, but may be ``Ignore`` if the diagnostic should be
    opt-in.  Defaulting to ``SendError`` would be exceptional, and defaulting
    to ``FatalError`` is not recommended under any circumstances.  The third
    argument is the *parent* of the diagnostic (see below).  The fourth is the
    actual name of the diagnostic.  The fifth and final argument is the CMake
    preset version corresponding to the introduction of the argument, which
    should be the latest preset version as used by the version of CMake under
    development.

    .. note::

      In the event that the development version has not already introduced a
      new preset version, adding a new diagnostic will additionally require
      introducing a new preset version.

    Diagnostics are hierarchical and **must** be listed in order of a
    depth-first search.  (If you imagine the order of items in a typical tree
    view which has been fully expanded, that is depth-first order.)  Each
    diagnostic has a direct parent.  Recursive alterations to a diagnostic will
    also affect all descendant diagnostics.

2.  A documentation page for the new diagnostic must be created under
    ``Help/diagnostic``, and a link to the same added to the Diagnostics
    manual, ``Help/manual/cmake-diagnostics.7.rst``.

3.  The new presets fields must be mentioned in the CMake presets version
    history, found at the bottom of ``Help/manual/cmake-presets.7.rst``.  Note
    that the documentation of the fields themselves is generated.

4.  The ``Utilities/Scripts/regenerate-presets.py`` script must be run to
    generate the updated presets schema and documentation.  Don't forget to
    review and commit the changes made by this script.
