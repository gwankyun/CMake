#include <iostream>

#include <cuda_runtime.h>
#include <sanitizer.h>
#include <stddef.h>

namespace {

bool malloc_called = false;
bool free_called = false;

void sanitizer_callback(void* userdata, Sanitizer_CallbackDomain domain,
                        Sanitizer_CallbackId cbid, void const* cbdata)
{
  if (domain == SANITIZER_CB_DOMAIN_RESOURCE) {
    switch (cbid) {
      case SANITIZER_CBID_RESOURCE_DEVICE_MEMORY_ALLOC:
        malloc_called = true;
        break;
      case SANITIZER_CBID_RESOURCE_DEVICE_MEMORY_FREE:
        free_called = true;
        break;
      default:
        break;
    }
  }
}

}

#define SANITIZER_TRY(call)                                                   \
  do {                                                                        \
    SanitizerResult result;                                                   \
    if ((result = (call)) != SANITIZER_SUCCESS) {                             \
      const char* result_str;                                                 \
      sanitizerGetResultString(result, &result_str);                          \
      std::cerr << __FILE__ << ":" << __LINE__ << ": " << result_str << "\n"; \
      return 1;                                                               \
    }                                                                         \
  } while (0)

#define CUDA_TRY(call)                                                        \
  do {                                                                        \
    cudaError_t result;                                                       \
    if ((result = (call)) != cudaSuccess) {                                   \
      std::cerr << __FILE__ << ":" << __LINE__ << ": "                        \
                << cudaGetErrorName(result) << "\n";                          \
      return 1;                                                               \
    }                                                                         \
  } while (0)

int main()
{
  Sanitizer_SubscriberHandle handle;
  SANITIZER_TRY(sanitizerSubscribe(&handle, sanitizer_callback, NULL));
  SANITIZER_TRY(
    sanitizerEnableDomain(1, handle, SANITIZER_CB_DOMAIN_RESOURCE));

  void* dev_ptr;
  CUDA_TRY(cudaMalloc(&dev_ptr, 10));
  if (!malloc_called) {
    std::cerr << "cudaMalloc() did not invoke callback\n";
    return 1;
  }

  CUDA_TRY(cudaFree(dev_ptr));
  if (!free_called) {
    std::cerr << "cudaFree() did not invoke callback\n";
    return 1;
  }

  SANITIZER_TRY(sanitizerUnsubscribe(handle));
  return 0;
}
