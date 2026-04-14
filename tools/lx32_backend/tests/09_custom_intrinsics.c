#include <stdint.h>
void test_pulsar_custom_isa() {
    volatile int32_t s = __builtin_lx_sensor(3);
    volatile uint16_t* m = __builtin_lx_matrix(0);
    volatile int32_t d = __builtin_lx_delta(42);
    volatile uint32_t c = __builtin_lx_chord(0b101010);
    __builtin_lx_wait(10);
    __builtin_lx_report((void*)m);
}
