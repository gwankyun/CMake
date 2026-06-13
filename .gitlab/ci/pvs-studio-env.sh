.gitlab/ci/pvs-studio.sh
export PATH=$PWD/.gitlab/pvs-studio/bin:$PATH
pvs-studio --version

if test -f "$CMAKE_CI_PVS_STUDIO_LICENSE_USER" -a -f "$CMAKE_CI_PVS_STUDIO_LICENSE_KEY"; then
  pvs-studio-analyzer credentials "$(<"$CMAKE_CI_PVS_STUDIO_LICENSE_USER")" "$(<"$CMAKE_CI_PVS_STUDIO_LICENSE_KEY")"
else
 echo "The CMAKE_CI_PVS_STUDIO_LICENSE_USER and CMAKE_CI_PVS_STUDIO_LICENSE_KEY files were not both provided!"
 exit 1
fi
rm -f "$CMAKE_CI_PVS_STUDIO_LICENSE_USER" "$CMAKE_CI_PVS_STUDIO_LICENSE_KEY"
unset CMAKE_CI_PVS_STUDIO_LICENSE_KEY
unset CMAKE_CI_PVS_STUDIO_LICENSE_USER
