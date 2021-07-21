#include <iostream>

#include "MathFunctions.h"

// 包括生成的表
#include "Table.h"

namespace mathfunctions {
namespace detail {
// 一种使用简单操作进行平方根计算的hack
double mysqrt(double x)
{
  if (x <= 0) {
    return 0;
  }

  // 使用表格帮助查找初始值
  double result = x;
  if (x >= 1 && x < 10) {
    std::cout << "Use the table to help find an initial value " << std::endl;
    result = sqrtTable[static_cast<int>(x)];
  }

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
