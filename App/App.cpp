#include <iostream>


#include "sgx_urts.h"
#include "Enclave_u.h"

#define ENCLAVE_FILE "enclave.signed.so"

sgx_enclave_id_t global_eid = 0;

int main () {
  std::cout << "Hello!" << std::endl;

  sgx_status_t ret = SGX_ERROR_UNEXPECTED;
  ret = sgx_create_enclave(ENCLAVE_FILE, SGX_DEBUG_FLAG, NULL, NULL, &global_eid, NULL);
  if (ret != SGX_SUCCESS) {
    std::cout << "ERROR 1" << std::endl;
    return 0;
  }

  int res = 0;

  ret = ecall_ex(global_eid, &res);
  if (ret != SGX_SUCCESS) {
    std::cout << "ERROR 2" << std::endl;
    sgx_destroy_enclave (global_eid);
    return 0;
  }

  std::cout << res << std::endl;

  sgx_destroy_enclave (global_eid);
  return 0;
}
