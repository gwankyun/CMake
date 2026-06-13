/* Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
   file LICENSE.rst or https://cmake.org/licensing for details.  */
#pragma once

#include <string>

class cmCMakePresetsArgsBase
{
public:
  virtual ~cmCMakePresetsArgsBase() = default;

  virtual bool HasPresetsArg() const { return !this->PresetName.empty(); };
  virtual void Clear() { this->PresetName.clear(); }

  std::string PresetName;
  std::string PresetsFile;

protected:
  cmCMakePresetsArgsBase() = default;
};

class cmCMakePresetsArgs : public cmCMakePresetsArgsBase
{
public:
  bool HasPresetsArg() const override
  {
    return this->cmCMakePresetsArgsBase::HasPresetsArg() || this->ListPresets;
  }

  void Clear() override
  {
    this->cmCMakePresetsArgsBase::Clear();
    this->ListPresets = false;
  }

  bool ListPresets = false;
};

class cmCMakePresetsConfigureArgs : public cmCMakePresetsArgsBase
{
public:
  enum class ListPresetsOption
  {
    None,
    Configure,
    Build,
    Test,
    Package,
    Workflow,
    All,
  };

  bool HasPresetsArg() const override
  {
    return this->cmCMakePresetsArgsBase::HasPresetsArg() ||
      this->ListPresets != ListPresetsOption::None;
  }

  void Clear() override
  {
    this->cmCMakePresetsArgsBase::Clear();
    this->ListPresets = ListPresetsOption::None;
  }

  ListPresetsOption ListPresets = ListPresetsOption::None;
};

class cmCMakePresetsWorkflowArgs : public cmCMakePresetsArgs
{
public:
  void Clear() override
  {
    this->cmCMakePresetsArgs::Clear();
    this->Fresh = false;
  }

  bool Fresh = false;
};
