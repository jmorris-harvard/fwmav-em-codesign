#pragma once

#include <ac_std_float.h>

typedef ac_ieee_float64 dtype;

void fpu (
    const dtype &A,
    const dtype &B,
    dtype &C_add,
    dtype &C_sub,
    dtype &C_div,
    dtype &C_mult) {

  C_add  = A + B;
  C_sub  = A - B;
  C_mult = A * B;
  C_div  = A / B;
}
