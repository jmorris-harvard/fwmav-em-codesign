#include <iostream>
#include <string.h>
#include <Unified.h>

#define REPEATS 800

using namespace std;
using namespace std::__cxx11;

int main (int Argc, char **Argv) {
  int error;

	DECIMAL Left[SIG_BUF_SIZE];
	DECIMAL Right[SIG_BUF_SIZE];
  
	// cout << "Bias,Left,Right" << endl;
  // Initialization Step
  InitModel ();
  // cout << "Done Init Model" << endl;
  DECIMAL Timestamp, BiasD2A, LeftD2A, RightD2A;
  for (int i = 0; i < REPEATS; ++i) {
    error = SAMPLE_MODEL_BUFFER (&Timestamp, &BiasD2A, &LeftD2A, &RightD2A, Left, Right);
    // cout << BiasD2A << ",";
    // cout << LeftD2A << ",";
    // cout << RightD2A << endl;
		for (int i = 0; i < SIG_BUF_SIZE; ++i) {
			cout << Left[i] << ",";
		}
		cout << endl;
  }

  return 0;
}
