#include <iostream>

#include "MathFunctions.h"

// �������ɵı�
#include "Table.h"

namespace mathfunctions {
namespace detail {
// ʹ�ü򵥵Ĳ�������ƽ��������
double mysqrt(double x)
{
  if (x <= 0) {
    return 0;
  }

  // ʹ�ñ��������ҳ�ʼֵ
  double result = x;
  if (x >= 1 && x < 10) {
    std::cout << "Use the table to help find an initial value " << std::endl;
    result = sqrtTable[static_cast<int>(x)];
  }

  // ����ʮ��
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
