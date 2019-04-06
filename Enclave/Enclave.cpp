#include "Enclave.h"

void ecall_ex (int *res) {
  int a = 3;
  int b = 4;
  int c = a + b;
  *res = c;
}
