// 一个构建开方根表的简单程序
#include <cmath>
#include <fstream>
#include <iostream>

int main(int argc, char* argv[])
{
  // 确保有足够的参数
  if (argc < 2) {
    return 1;
  }

  std::ofstream fout(argv[1], std::ios_base::out);
  const bool fileOpen = fout.is_open();
  if (fileOpen) {
    fout << "double sqrtTable[] = {" << std::endl;
    for (int i = 0; i < 10; ++i) {
      fout << sqrt(static_cast<double>(i)) << "," << std::endl;
    }
    // 用0结束表
    fout << "0};" << std::endl;
    fout.close();
  }
  return fileOpen ? 0 : 1; // 如果写入文件，则返回0
}
