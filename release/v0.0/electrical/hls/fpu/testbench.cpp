#include <iostream>

#include <mc_scverify.h>

#include "FPMMM64_Func.h"

CCS_MAIN (int argc, char **argv) {
  ctype Ac, Bc, Cc;

  CCS_DESIGN (FPMMM64) (Ac, Bc, Cc);
  for (int i = 0; i < 9; ++i) {
    Ac.write (dtype (1.0));
    Bc.write (dtype (1.0));
  }
  for (int i = 0; i < 9; ++i) {
    std::cout << Cc.read () << "\n";
  }
  std::cout << std::endl;

  CCS_RETURN (0);
}
