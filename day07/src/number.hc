/**
 * Convert a string to I64, finishing when a non-numeric character is
 * encountered.
 */
I64 StringToI64(U8 *str)
{
  I64 total = 0;
  for (I64 i = 0; str[i] >= '0' && str[i] <= '9'; i++)
  {
    total *= 10(I64);
    total += (str[i] - '0')(I64);
  }
  return total;
}

I32 I64NDigits(I64 i)
{
  I32 n_digits = 1;
  while (i >= 10) {
    i /= 10;
    n_digits += 1;
  }
  return n_digits;
}

I64 TenToPower(I64 n)
{
  I64 result = 1;
  for (; n > 0; n--)
  {
    result *= 10;
  }
  return result;
}

/** Concatenate the given I64 values */
I64 I64Cat(I64 a, I64 b)
{
  return a * TenToPower(I64NDigits(b)) + b;
}

