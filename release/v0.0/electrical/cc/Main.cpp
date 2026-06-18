#include <Unified.h>

#define REPEATS 80000

int main (int Argc, char **Argv) {
  int Error;
  InitModel ();
  DECIMAL Timestamp, BiasD2A, LeftD2A, RightD2A;
  for (int i = 0; i < REPEATS; ++i) {
    Error = SAMPLE_MODEL (&Timestamp, &BiasD2A, &LeftD2A, &RightD2A);
  }

  return 0;
}
