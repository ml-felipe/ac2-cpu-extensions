#include <stdio.h>
#include <stdint.h>
#include <stdio.h>
#include <limits.h>

// Función de referencia para POPCNT en software
unsigned int popcnt_sw(uint64_t val) {
    unsigned int count = 0;
    for (int i = 0; i < 64; i++) {
        if (val & (1ULL << i)) count++;
    }
    return count;
}

// Función que prueba un valor individual
void test_popcnt(uint64_t val) {
    uint64_t result_hw;

    // Instrucción POPCNT codificada en word
    __asm__ __volatile__ (
    "mv x10, %[rs1]\n"
		".word 0x0005050B\n"  // POPCNT x10, x10
		"mv %[rd], x10\n"
		: [rd] "=&r" (result_hw)
		: [rs1] "r" (val)
		: "x10"
	);

    unsigned int expected = popcnt_sw(val);
    if (result_hw == expected) {
        printf("POPCNT(0x%016lx) = %lu [PASS]\n", val, result_hw);
    } else {
        printf("POPCNT(0x%016lx) = %lu [FAIL] (expected %u)\n", val, result_hw, expected);
    }
}

int main() {
    printf("Pruebas de la instrucción POPCNT:\n\n");

    // Casos básicos
	test_popcnt(0x0000000000000000ULL);  // 0 bits a 1
	test_popcnt(0x0000000000000001ULL);  // 1 bit a 1 (LSB)
	test_popcnt(0x0000000000000010ULL);  // 1 bit a 1 (bit 4)
	test_popcnt(0xFFFFFFFFULL);          // 32 bits a 1 (los 32 LSB)
	test_popcnt(0xAAAAAAAAULL);          // 16 bits a 1 (patrón 1010 alternado)
	test_popcnt(0x55555555ULL);          // 16 bits a 1 (patrón 0101 alternado)

	// Casos con 1 solo bit en posiciones interesantes
	test_popcnt(1ULL << 0);   // bit 0 (LSB)
	test_popcnt(1ULL << 15);  // bit 15 (mitad baja)
	test_popcnt(1ULL << 31);  // bit 31 (fin 32 bits)
	test_popcnt(1ULL << 32);  // bit 32 (inicio parte alta)
	test_popcnt(1ULL << 63);  // bit 63 (MSB)

	// Casos intermedios con bloques de bits
	test_popcnt(0x0000FFFFULL);      // 16 bits bajos a 1
	test_popcnt(0x00FF00FFULL);      // 16 bits dispersos a 1
	test_popcnt(0xFFFF0000FFFF0000ULL); // bloques altos y bajos

	// Casos borde: todos bits a 1 en 64 bits
	test_popcnt(0xFFFFFFFFFFFFFFFFULL);  // 64 bits a 1

	// Casos patrón específicos
	test_popcnt(0x0F0F0F0F0F0F0F0FULL);  // 32 bits a 1 (patrón 00001111 alternado)
	test_popcnt(0x3333333333333333ULL);  // 32 bits a 1 (patrón 0011 repetido)
	test_popcnt(0x5555555555555555ULL);  // 32 bits a 1 (patrón 0101 repetido)


    return 0;
}
