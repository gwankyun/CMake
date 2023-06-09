#include "mysqrt.h"

#include <iostream>

namespace mathfunctions {
namespace detail {
// 使用简单的操作进行平方根计算
double mysqrt(double x)
{
  if (x <= 0) {
    return 0;
  }

  double result = x;

  // 迭代十次
  for (int i = 0; i < 10; ++i) {
    if (result <= 0) {
      result = 0.1;
    }
    double delta = x - (result * result);
    result = result + 0.5 * delta / result;
    std::cout << "Computing sqrt of " << x << " to be " << result << std::endl;
  }
  return result;
}
}
}
