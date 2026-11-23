#include <stdio.h>
#include <stdint.h>
#include "syscalls.h"

#define SIZE 1024

extern uint64_t vec1[SIZE];
extern uint64_t vec2[SIZE];
extern uint64_t popcnt_custom();

int main(int argc, char* argv[]) {
    for (int i = 0; i < SIZE; i++) {
        vec1[i] = i;
        vec2[i] = SIZE - i;
    }

    setStats(1);
    uint64_t result = popcnt_custom();
    setStats(0);

    printf("Distancia Hamming (custom): %lu\n", result);
    return 0;
}

