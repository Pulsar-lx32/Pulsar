__attribute__((noinline)) int score_cmp(int a, int b, int c) {
  int score = 0;

  if (a < b)
    score += 3;
  else
    score -= 3;

  if (b == c)
    score += 5;

  if (a != c)
    score += 7;

  return score;
}

int main(void) {
  return score_cmp(4, 9, 4);
}

