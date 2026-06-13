cmake_minimum_required(VERSION 4.3)
project(Sanitizer CUDA)

enable_testing()

# Goal for this example:
# Validate that we can use CUDAToolkit sanitizer
find_package(CUDAToolkit REQUIRED)

if(CUDAToolkit_VERSION VERSION_GREATER_EQUAL 10.1)
  add_executable(CudaOnlySanitizer test_sanitizer.cu)
  target_link_libraries(CudaOnlySanitizer PRIVATE CUDA::sanitizer)

  add_test(NAME CudaOnlySanitizer COMMAND CudaOnlySanitizer)
  if(WIN32)
    get_property(sanitizer_path TARGET CUDA::sanitizer PROPERTY IMPORTED_LOCATION)
    get_filename_component(sanitizer_dir "${sanitizer_path}" DIRECTORY)
    set_property(TEST CudaOnlySanitizer PROPERTY ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:${sanitizer_dir}")
  endif()
endif()
