__attribute__((noinline)) int fib_iter(int n) {
  int a = 0;
  int b = 1;

  while (n > 0) {
    int next = a + b;
    a = b;
    b = next;
    n -= 1;
  }

  return a;
}

int main(void) {
  return fib_iter(10);
}

