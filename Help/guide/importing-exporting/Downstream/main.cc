// A simple program that outputs the square root of a number
// 一个输出数字平方根的简单程序
#include <iostream>
#include <string>

#include "MathFunctions.h"

int main(int argc, char* argv[])
{
  if (argc < 2) {
    std::cout << "Usage: " << argv[0] << " number" << std::endl;
    return 1;
  }

  // convert input to double
  // 将输入转换为 double 类型
  double const inputValue = std::stod(argv[1]);

  // calculate square root
  // 计算平方根
  double const sqrt = MathFunctions::sqrt(inputValue);
  std::cout << "The square root of " << inputValue << " is " << sqrt
            << std::endl;

  return 0;
}
