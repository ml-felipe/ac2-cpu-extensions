#include <stdio.h>
#include <stdint.h>
#include "syscalls.h"

#define SIZE 1024
uint64_t a[SIZE], b[SIZE];
uint64_t max_sum = 0, min_sum = 0;

int main( int argc, char* argv[] ) {
    for (int i = 0; i < SIZE; i++) {
        a[i] = i;
        b[i] = SIZE - i;
    }

    setStats(1);  

    for (int i = 0; i < SIZE; i++) {
        uint64_t x = a[i];
        uint64_t y = b[i];

        max_sum += (x > y) ? x : y;
        min_sum += (x < y) ? x : y;
    }

    setStats(0);  
    
    printf("Suma de máximos (naive): %lu\n", max_sum);
    printf("Suma de mínimos (naive): %lu\n", min_sum);
    return 0;
}
