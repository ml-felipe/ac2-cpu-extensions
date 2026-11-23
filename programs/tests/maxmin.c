#include <stdio.h>
#include <limits.h> // Para LONG_MIN y LONG_MAX

void test_max_min(long a, long b) {
    long res_max, res_min;

    // Instrucción MAX (func3 = 011)
    __asm__ __volatile__ (
        "mv t0, %[rs1]\n"
        "mv t1, %[rs2]\n"
        ".word 0x0062B38B\n" // MAX t2, t0, t1
        "mv %[rd], t2\n"
        : [rd] "=&r" (res_max)
        : [rs1] "r" (a), [rs2] "r" (b)
        : "t0", "t1", "t2"
    );

    // Instrucción MIN (func3 = 100)
    __asm__ __volatile__ (
        "mv t0, %[rs1]\n"
        "mv t1, %[rs2]\n"
        ".word 0x0062C38B\n" // MIN t2, t0, t1
        "mv %[rd], t2\n"
        : [rd] "=&r" (res_min)
        : [rs1] "r" (a), [rs2] "r" (b)
        : "t0", "t1", "t2"
    );

    long expected_max = (a > b) ? a : b;
    long expected_min = (a < b) ? a : b;

    int max_ok = (res_max == expected_max);
    int min_ok = (res_min == expected_min);

    printf("MAX(%ld, %ld) = %ld [%s]\t", a, b, res_max, max_ok ? "PASS" : "FAIL");
    printf("MIN(%ld, %ld) = %ld [%s]\n", a, b, res_min, min_ok ? "PASS" : "FAIL");
}

int main() {
    printf("Pruebas de instrucciones MAX y MIN:\n\n");

    // Casos de prueba
    test_max_min(5, 10);                  // b > a
    test_max_min(10, 5);                  // a > b
    test_max_min(7, 7);                   // a == b
    test_max_min(-3, 4);                  // negativo y positivo
    test_max_min(-10, -2);                // ambos negativos
    test_max_min(0, 0);                   // ambos ceros
    test_max_min(123456789, -987654321);  // gran positivo y gran negativo

    // Casos extremos
	test_max_min(LONG_MIN, LONG_MAX);        // extremos opuestos
	test_max_min(LONG_MAX, LONG_MIN);        // inverso
	test_max_min(LONG_MIN, LONG_MIN);        // ambos mínimos
	test_max_min(LONG_MAX, LONG_MAX);        // ambos máximos

	// Diferencias de 1 en los extremos
	test_max_min(LONG_MIN + 1, LONG_MIN);    // cercano al mínimo
	test_max_min(LONG_MAX - 1, LONG_MAX);    // cercano al máximo
	test_max_min(LONG_MIN, LONG_MIN + 1);    // inverso
	test_max_min(LONG_MAX, LONG_MAX - 1);    // inverso

	// Casos con 0
	test_max_min(0, LONG_MIN);               // cero y mínimo
	test_max_min(0, LONG_MAX);               // cero y máximo
	test_max_min(0, -1);                     // cero y negativo
	test_max_min(0, 1);                      // cero y positivo
	test_max_min(0, 0);                      // ambos ceros

	// Simétricos
	test_max_min(-1, 1);
	test_max_min(-100, 100);
	test_max_min(-500000, 500000);
	test_max_min(-123456789, 123456789);

	// Aleatorios con signo
	test_max_min(-10, -20);
	test_max_min(-1000, 1000);
	test_max_min(-32768, 32767);

	// Inversos
	test_max_min(1, -1);
	test_max_min(100, -100);
	test_max_min(500000, -500000);


    return 0;
}
