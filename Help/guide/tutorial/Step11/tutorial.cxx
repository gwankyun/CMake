// 一个简单的程序，计算一个数的平方根
#include <iostream>
#include <sstream>
#include <string>

#include "MathFunctions.h"
#include "TutorialConfig.h"

int main(int argc, char* argv[])
{
  if (argc < 2) {
    // 报告版本号
    std::cout << argv[0] << " Version " << Tutorial_VERSION_MAJOR << "."
              << Tutorial_VERSION_MINOR << std::endl;
    std::cout << "Usage: " << argv[0] << " number" << std::endl;
    return 1;
  }

  // 将输入转换为double类型
  const double inputValue = std::stod(argv[1]);

  const double outputValue = mathfunctions::sqrt(inputValue);

  std::cout << "The square root of " << inputValue << " is " << outputValue
            << std::endl;
  return 0;
}
