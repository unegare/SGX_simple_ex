.PHONY: all
all:
	cd App && ${SGX_PREFIX}/bin/x64/sgx_edger8r --untrusted ../Enclave/Enclave.edl --search-path ../Enclave --search-path ${SGX_PREFIX}/include
	cd ..
	cc -m64 -O0 -g -Wall -Wextra -Winit-self -Wpointer-arith -Wreturn-type -Waddress -Wsequence-point -Wformat-security -Wmissing-include-dirs -Wfloat-equal -Wundef -Wshadow -Wcast-align -Wcast-qual -Wconversion -Wredundant-decls -Wjump-misses-init -Wstrict-prototypes -Wunsuffixed-float-constants -fPIC -Wno-attributes -IApp -I${SGX_PREFIX}/include -DDEBUG -UNDEBUG -UEDEBUG -c App/Enclave_u.c -o App/Enclave_u.o
	g++ -m64 -O0 -g -Wall -Wextra -Winit-self -Wpointer-arith -Wreturn-type -Waddress -Wsequence-point -Wformat-security -Wmissing-include-dirs -Wfloat-equal -Wundef -Wshadow -Wcast-align -Wcast-qual -Wconversion -Wredundant-decls -Wnon-virtual-dtor -std=c++11 -fPIC -Wno-attributes -IApp -I${SGX_PREFIX}/include -DDEBUG -UNDEBUG -UEDEBUG -c App/App.cpp -o App/App.o
	g++ App/App.o App/Enclave_u.o -o app -L${SGX_PREFIX}/lib64 -lsgx_urts_sim -lpthread  -lsgx_uae_service_sim
	cd Enclave && ${SGX_PREFIX}/bin/x64/sgx_edger8r --trusted ../Enclave/Enclave.edl --search-path ../Enclave --search-path ${SGX_PREFIX}/include
	cd ..
	cc -m64 -O0 -g -Wall -Wextra -Winit-self -Wpointer-arith -Wreturn-type -Waddress -Wsequence-point -Wformat-security -Wmissing-include-dirs -Wfloat-equal -Wundef -Wshadow -Wcast-align -Wcast-qual -Wconversion -Wredundant-decls -Wjump-misses-init -Wstrict-prototypes -Wunsuffixed-float-constants -nostdinc -fvisibility=hidden -fpie -fstack-protector -IEnclave -I${SGX_PREFIX}/include -I${SGX_PREFIX}/include/libcxx -I${SGX_PREFIX}/include/tlibc  -c ./Enclave/Enclave_t.c -o ./Enclave/Enclave_t.o
	g++ -m64 -O0 -g -Wall -Wextra -Winit-self -Wpointer-arith -Wreturn-type -Waddress -Wsequence-point -Wformat-security -Wmissing-include-dirs -Wfloat-equal -Wundef -Wshadow -Wcast-align -Wcast-qual -Wconversion -Wredundant-decls -Wnon-virtual-dtor -std=c++11 -nostdinc -fvisibility=hidden -fpie -fstack-protector -IEnclave -I${SGX_PREFIX}/include -I${SGX_PREFIX}/include/libcxx -I/SGX_SDK_my/sgxsdk/include/tlibc  -nostdinc++ -c Enclave/Enclave.cpp -o Enclave/Enclave.o
	g++ Enclave/Enclave_t.o Enclave/Enclave.o -o enclave.so -Wl,--no-undefined -nostdlib -nodefaultlibs -nostartfiles -L${SGX_PREFIX}/lib64 -Wl,--whole-archive -lsgx_trts_sim -Wl,--no-whole-archive -Wl,--start-group -lsgx_tstdc -lsgx_tcxx -lsgx_tcrypto -lsgx_tservice_sim -Wl,--end-group -Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined -Wl,-pie,-eenclave_entry -Wl,--export-dynamic -Wl,--defsym,__ImageBase=0 -Wl,--version-script=Enclave/Enclave_debug.lds
	${SGX_PREFIX}/bin/x64/sgx_sign sign -key Enclave/Enclave_private.pem -enclave enclave.so -out enclave.signed.so -config Enclave/Enclave.config.xml

.PHONY: clean
clean:
	rm -f app enclave.signed.so App/App.o App/Enclave_u.* Enclave/Enclave.o Enclave/Enclave_t.* enclave.so
