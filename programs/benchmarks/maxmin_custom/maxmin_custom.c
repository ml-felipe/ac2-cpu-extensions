#include <stdint.h>
#include <stdio.h>
#include "syscalls.h"

#define SIZE 1024

uint64_t a[SIZE];
uint64_t b[SIZE];
uint64_t sum_max = 0;
uint64_t sum_min = 0;

// Declaración externa de la función en ensamblador
extern void maxmin_custom(uint64_t* a, uint64_t* b, uint64_t size, uint64_t* out_max, uint64_t* out_min);

int main( int argc, char* argv[] ) {
    // Inicialización de vectores
    for (int i = 0; i < SIZE; i++) {
        a[i] = i;
        b[i] = SIZE - i;
    }

    setStats(1);
    maxmin_custom(a, b, SIZE, &sum_max, &sum_min);
    setStats(0);

    printf("Suma de máximos (custom): %lu\n", sum_max);
    printf("Suma de mínimos (custom): %lu\n", sum_min);

    return 0;
}
