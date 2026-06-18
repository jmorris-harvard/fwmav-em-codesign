/* Implements Reading Program Inputs From Text File
 */

#include <fstream>
#include <iostream>
#include <string>

#include <Comm.h>

// Define Template usages
template STATUS Read<DECIMAL> (DECIMAL *);
template STATUS Read<INTEGER> (INTEGER *);

static struct TestFiles_T {
  const std::string ConfigFilename = "./Config.txt";
  const std::string InputFilename = "./Input.txt";
  std::ifstream ConfigFile;
  std::ifstream InputFile;
  bool IsOpen = 0;

  std::ifstream *CurrentStream = 0;

  ~TestFiles_T () {
    if (ConfigFile.is_open ()) {
      ConfigFile.close ();
    }

    if (InputFile.is_open ()) {
      InputFile.close ();
    }
  }
} TestFiles;

STATUS LoadFiles (void) {
  if (!TestFiles.IsOpen) {
    TestFiles.ConfigFile.open (TestFiles.ConfigFilename, std::ifstream::in);
    TestFiles.InputFile.open (TestFiles.InputFilename, std::ifstream::in);
    TestFiles.IsOpen = 1;
    TestFiles.CurrentStream = &TestFiles.ConfigFile;
  }
  return 0;
}

constexpr const size_t BufSize = 256;
char Buf[BufSize];
template <typename T>
STATUS Read (T *Output) {
  if (!TestFiles.IsOpen) {
    if (LoadFiles ()) {
      return 1;
    }
  }
  TestFiles.CurrentStream->getline (Buf, BufSize);
  if (Buf[0] == 0) {
    // std::cout << "Switching Streams" << std::endl;
    TestFiles.CurrentStream = &TestFiles.InputFile;
    TestFiles.CurrentStream->getline (Buf, BufSize);
    if (Buf[0] == 0) return 1;
  }
  double Got = std::__cxx11::stod (Buf);
  *Output = (T) Got;
  /* std::cout << Buf << " vs. " << Got 
            << " vs. " << *Output 
            << " vs. " << std::hex << *((uint64_t *) Output)
            << std::endl; */
  // std::cout << "Read Value" << std::endl;
  return 0;
}
