/* Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
   file LICENSE.rst or https://cmake.org/licensing for details.  */

#pragma once

#include "cmConfigure.h" // IWYU pragma: keep

#include <cmext/enum_set>

#include "cmLinkedTree.h"

namespace cmStateDetail {
struct SnapshotDataType;
using PositionType = cmLinkedTree<cmStateDetail::SnapshotDataType>::iterator;
}

namespace cmStateEnums {

enum SnapshotType
{
  BaseType,
  BuildsystemDirectoryType,
  DeferCallType,
  FunctionCallType,
  MacroCallType,
  IncludeFileType,
  InlineListFileType,
  PolicyScopeType,
  VariableScopeType
};

enum SnapshotUnwindType
{
  NO_UNWIND,
  CAN_UNWIND
};

enum SnapshotUnwindState
{
  NOT_UNWINDING,
  UNWINDING
};

enum class CommandType
{
  Macro,
  Function
};

enum CacheEntryType
{
  BOOL = 0,
  PATH,
  FILEPATH,
  STRING,
  INTERNAL,
  STATIC,
  UNINITIALIZED
};

enum ArtifactType
{
  RuntimeBinaryArtifact,
  ImportLibraryArtifact
};

enum class IntermediateDirKind
{
  ObjectFiles,
  QtAutogenMetadata,
};
}

namespace cmTraceEnums {

/** \brief Define supported trace formats **/
enum class TraceOutputFormat
{
  Undefined,
  Human,
  JSONv1
};
};
