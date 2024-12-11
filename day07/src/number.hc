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

/**
 * Convert an I64 to a Str. The Str must be freed after use.
 */
U8 *I64ToString(I64 i)
{
    // First find the number of digits
    I32 n_digits = 1;
    I64 copy = i;
    while (copy > 10) {
        copy /= 10;
        n_digits += 1;
    }
    U8 *str = MAlloc(sizeof(U8) * (n_digits + 1));
    str[n_digits] = '\0';

    for (I32 digit = n_digits - 1; digit >= 0; digit--) {
        str[digit] = '0' + i % 10;
        i /= 10;
    }

    return str;
}

// U0 Main()
// {
//     U8 *str = I64ToString(1234123412341234);
//     "%s\n", str;
//     Free(str);
// }
