#include "src/number.hc"

U0 Main()
{
    I32 nd = I64NDigits(10);
    "digits: %d\n", nd;
    I64 result = I64Cat(2, 10);
    "%lld\n", result;
}
