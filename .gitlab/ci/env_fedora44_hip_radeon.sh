export HIPCXX=/usr/bin/clang++
export HIPFLAGS='--rocm-path=/usr --rocm-device-lib-path=/usr/lib64/rocm/llvm/lib/clang/20/lib/amdgcn/bitcode'

git apply --unsafe-paths --directory=/ .gitlab/ci/env_fedora44_hip_radeon.patch
