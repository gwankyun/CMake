/* Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
   file LICENSE.rst or https://cmake.org/licensing for details.  */

#pragma once

#include <string>

class cmRuntimeDependencyArchive;

namespace cm {
enum class TargetType;
} // namespace cm

class cmBinUtilsLinker
{
public:
  cmBinUtilsLinker(cmRuntimeDependencyArchive* archive);
  virtual ~cmBinUtilsLinker() = default;

  virtual bool Prepare() { return true; }

  virtual bool ScanDependencies(std::string const& file,
                                cm::TargetType type) = 0;

protected:
  cmRuntimeDependencyArchive* Archive;

  void SetError(std::string const& e);

  void NormalizePath(std::string& path) const;
};
