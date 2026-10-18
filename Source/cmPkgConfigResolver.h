/* Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
   file LICENSE.rst or https://cmake.org/licensing for details.  */

#pragma once

#include "cmConfigure.h" // IWYU pragma: keep

#include <string>
#include <vector>

#include <cm/optional>

#include "cmPkgConfigParser.h"

struct cmPkgConfigCflagsResult
{
  std::string Flagline;
  std::vector<std::string> Includes;
  std::vector<std::string> CompileOptions;
};

struct cmPkgConfigLibsResult
{
  std::string Flagline;
  std::vector<std::string> LibDirs;
  std::vector<std::string> LibNames;
  std::vector<std::string> LinkOptions;
};

struct cmPkgConfigEnv
{
  cm::optional<std::vector<std::string>> Path;
  cm::optional<std::vector<std::string>> LibDirs;
  cm::optional<std::vector<std::string>> SysCflags;
  cm::optional<std::vector<std::string>> SysLibs;

  cm::optional<std::string> SysrootDir;
  cm::optional<std::string> TopBuildDir;
  std::vector<std::string> search;

  cm::optional<bool> DisableUninstalled;

  bool AllowSysCflags = true;
  bool AllowSysLibs = true;
};

class cmPkgConfigResolver
{
public:
  enum class Strictness
  {
    Strict,
    Permissive,
    BestEffort,
  };

  cmPkgConfigResolver(cmPkgConfigParser parser, cmPkgConfigEnv const& env,
                      std::string const& pcFileDir);

  static cm::optional<cmPkgConfigResolver> Resolve(
    cmPkgConfigParser parser, cmPkgConfigEnv const& env, Strictness strictness,
    std::string const& pcFileDir);

  static cm::optional<cmPkgConfigResolver> ResolveStrict(
    cmPkgConfigParser parser, cmPkgConfigEnv const& env,
    std::string const& pcFileDir);

  static cm::optional<cmPkgConfigResolver> ResolvePermissive(
    cmPkgConfigParser parser, cmPkgConfigEnv const& env,
    std::string const& pcFileDir);

  static cmPkgConfigResolver ResolveBestEffort(cmPkgConfigParser parser,
                                               cmPkgConfigEnv const& env,
                                               std::string const& pcFileDir);

  std::string Literal(std::string const& key) const;

  std::string Name() const;
  std::string Description() const;
  std::string Version() const;

  std::vector<cmPkgConfigDependencySpec> Conflicts() const;
  std::vector<cmPkgConfigDependencySpec> Provides() const;
  std::vector<cmPkgConfigDependencySpec> Requires(bool priv = false) const;

  cmPkgConfigCflagsResult Cflags(bool priv = false) const;
  cmPkgConfigLibsResult Libs(bool priv = false) const;

  static std::string VersionReqString(cmPkgConfigDependencySpec const& spec);

  static bool CheckVersion(cmPkgConfigDependencySpec const& desired,
                           std::string const& provided);

  static void ReplaceSep(std::string& list);

#ifdef _WIN32
  static char const Sep = ';';
#else
  static char const Sep = ':';
#endif

private:
  void ConfigureParser(std::string const& pcFileDir);
  bool HasRequiredFields() const;
  bool HasStrictConflicts() const;

  std::vector<std::string> Fragments(std::string const& key) const;
  std::vector<cmPkgConfigDependencySpec> Dependencies(
    std::string const& key) const;

  static cmPkgConfigCflagsResult MangleCflags(
    std::vector<std::string> const& flags, cmPkgConfigEnv const& env);

  static cmPkgConfigLibsResult MangleLibs(
    std::vector<std::string> const& flags, cmPkgConfigEnv const& env);

  static std::string Reroot(std::string const& flag, char const* prefix,
                            std::string const& sysroot);

  mutable cmPkgConfigParser Parser;
  cmPkgConfigEnv const* Env;
};
