// 一个简单的程序，计算一个数的平方根

// TODO3: Include <format>

#include <iostream>
#include <string>

#include <MathFunctions.h>

int main(int argc, char* argv[])
{
  if (argc < 2) {
    // TODO4: Convert the print to use std::format
    std::cout << "Usage: " << argv[0] << " number" << std::endl;
    return 1;
  }

  // 将输入转换为double类型
  double const inputValue = std::stod(argv[1]);

  // calculate square root
  double const outputValue = mathfunctions::sqrt(inputValue);
  // TODO5: Convert the print to use std::format
  std::cout << "The square root of " << inputValue << " is " << outputValue
            << std::endl;
}
