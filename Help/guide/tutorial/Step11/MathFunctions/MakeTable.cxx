// һ��������������ļ򵥳���
#include <cmath>
#include <fstream>
#include <iostream>

int main(int argc, char* argv[])
{
  // ȷ�����㹻�Ĳ���
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
    // ��0������
    fout << "0};" << std::endl;
    fout.close();
  }
  return fileOpen ? 0 : 1; // ���д���ļ����򷵻�0
}
