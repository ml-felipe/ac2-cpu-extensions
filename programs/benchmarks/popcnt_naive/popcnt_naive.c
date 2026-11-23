#include <stdio.h>
#include <stdint.h>
#include "syscalls.h"

#define SIZE 1024
uint64_t vec1[SIZE];
uint64_t vec2[SIZE];
uint64_t hamming_naive = 0;

int main( int argc, char* argv[] ) {
    // Inicialización
    for (int i = 0; i < SIZE; i++) {
        vec1[i] = i;
        vec2[i] = SIZE - i;
    }

    setStats(1);  

    // Cálculo Hamming con bucle clásico
    for (int i = 0; i < SIZE; i++) {
        uint64_t xor = vec1[i] ^ vec2[i];
        for (int b = 0; b < 64; b++) {
            hamming_naive += (xor >> b) & 1;
        }
    }

    setStats(0);  
    
    printf("Distancia Hamming (naive): %lu\n", hamming_naive);
    return 0;
}
