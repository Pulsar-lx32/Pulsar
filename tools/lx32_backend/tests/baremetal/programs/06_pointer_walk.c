__attribute__((noinline)) int sum_words(volatile int *ptr, int count) {
  int acc = 0;
  int i = 0;

  while (i < count) {
    acc += ptr[i];
    i += 1;
  }

  return acc;
}

int main(void) {
  volatile int *mmio = (volatile int *)0x1000;
  mmio[0] = 11;
  mmio[1] = 13;
  mmio[2] = 17;
  return sum_words(mmio, 3);
}

