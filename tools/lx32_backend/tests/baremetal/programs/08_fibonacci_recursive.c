__attribute__((noinline)) int fib_rec(int n) {
  if (n <= 1)
    return n;
  return fib_rec(n - 1) + fib_rec(n - 2);
}

int main(void) {
  return fib_rec(8);
}

