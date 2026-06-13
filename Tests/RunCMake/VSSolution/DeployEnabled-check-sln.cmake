#
# Test solution file for deployment.
#

set(vcSlnFile "${RunCMake_TEST_BINARY_DIR}/DeployEnabled.sln")
if(NOT EXISTS "${vcSlnFile}")
  set(RunCMake_TEST_FAILED "Solution file ${vcSlnFile} does not exist.")
  return()
endif()

file(STRINGS "${vcSlnFile}" lines)

# Foo
set(FooProjGUID "")
set(FoundFooProj FALSE)
set(InFooProj FALSE)
set(FoundReleaseDeploy FALSE)
set(FooDeployConfigs Debug MinSizeRel RelWithDebInfo )

foreach(line IN LISTS lines)
#message(STATUS "${line}")
  if( (NOT InFooProj ) AND (line MATCHES "^[ \\t]*Project\\(\"{[A-F0-9-]+}\"\\) = \"foo\", \"foo.vcxproj\", \"({[A-F0-9-]+})\"[ \\t]*$"))
    # First, identify the GUID for the foo project, and record it.
    set(FoundFooProj TRUE)
    set(InFooProj TRUE)
    set(FooProjGUID ${CMAKE_MATCH_1})
  elseif(InFooProj AND line MATCHES "EndProject")
    set(InFooProj FALSE)
  elseif((NOT InFooProj) AND line MATCHES "${FooProjGUID}\\.Release.*\\.Deploy\\.0")
    # If foo's Release configuration is set to deploy, this is the error.
    set(FoundReleaseDeploy TRUE)
  endif()
  if( line MATCHES "{[A-F0-9-]+}\\.([^\\|]+).*\\.Deploy\\.0" )
    # Check that the other configurations ARE set to deploy.
    list( REMOVE_ITEM FooDeployConfigs ${CMAKE_MATCH_1})
  endif()
endforeach()

if(FoundReleaseDeploy)
  set(RunCMake_TEST_FAILED "Release deployment enabled.")
  return()
endif()

if(NOT FoundFooProj)
  set(RunCMake_TEST_FAILED "Failed to find 'foo' project in the solution.")
  return()
endif()

list(LENGTH FooDeployConfigs length)
if(  length GREATER 0 )
  set(RunCMake_TEST_FAILED "Failed to find 'foo' Deploy lines for non-Release configurations. (${length})")
  return()
endif()

# Utility
set(UtilityProjGUID "")
set(InUtilityProj FALSE)
set(FoundUtilityProj FALSE)
set(UtilityDeployConfigs Debug MinSizeRel RelWithDebInfo Release)

foreach(line IN LISTS lines)
  if( (NOT InUtilityProj) AND (line MATCHES "^[ \\t]*Project\\(\"{[A-F0-9-]+}\"\\) = \"utility\", \"utility.vcxproj\", \"({[A-F0-9-]+})\"[ \\t]*$"))
    # First, identify the GUID for the utility project, and record it.
    set(FoundUtilityProj TRUE)
    set(InUtilityProj TRUE)
    set(UtilityProjGUID ${CMAKE_MATCH_1})
  elseif(InUtilityProj AND line MATCHES "EndProject")
    set(InUtilityProj FALSE)
  endif()

  if( line MATCHES "{[A-F0-9-]+}\\.([^\\|]+).*\\.Deploy\\.0" )
    # Check that the other configurations ARE set to deploy.
    list( REMOVE_ITEM UtilityDeployConfigs ${CMAKE_MATCH_1})
  endif()
endforeach()

if(NOT FoundUtilityProj)
  set(RunCMake_TEST_FAILED "Failed to find 'utility' project in the solution.")
  return()
endif()

list(LENGTH UtilityDeployConfigs length)
if( length GREATER 0 )
  set(RunCMake_TEST_FAILED "Failed to find 'utility' Deploy lines for all configurations. (${length})")
  return()
endif()
