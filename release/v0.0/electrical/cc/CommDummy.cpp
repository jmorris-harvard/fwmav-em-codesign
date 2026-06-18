/* Implements Reading Program Inputs From Text File
 */
 
#include <Comm.h>

// Define Template usages
template STATUS Read<DECIMAL> (DECIMAL *);
template STATUS Read<INTEGER> (INTEGER *);

template <typename T>
STATUS Read (T *Output) {
	*Output = 2.0;
  return 0;
}
