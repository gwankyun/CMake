// 一个简单的程序，计算一个数的平方根
#include <cmath>
#include <iostream>
#include <string>

// TODO8: Include the MathFunctions header

int main(int argc, char* argv[])
{
  if (argc < 2) {
    std::cout << "Usage: " << argv[0] << " number" << std::endl;
    return 1;
  }

  // 将输入转换为double类型
  double const inputValue = std::stod(argv[1]);

  // TODO9: Use the mathfunctions::sqrt function
  // calculate square root
  double const outputValue = std::sqrt(inputValue);
  std::cout << "The square root of " << inputValue << " is " << outputValue
            << std::endl;
}
