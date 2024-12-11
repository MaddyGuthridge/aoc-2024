/**
 * main.hc
 *
 * Implementation of AOC 2024 Day 7 in Holy C.
 *
 * Not relying on most stdlib functions, since they appear to be very different
 * between the stdlib of https://github.com/Jamesbarford/holyc-lang and of
 * TempleOS. I want my solution to (ideally) run on both.
 */
#include "src/equation.hc"

// ============================================================================

Bool RecurseIsEquationPossible(I64 target, I64 current, I64 *values, I64 num_values)
{
  // Base case: exceeded target value
  if (current > target)
  {
    return FALSE;
  }
  // Base case: no values remain
  if (num_values == 0)
  {
    return target == current;
  }
  // First try addition
  Bool possible = RecurseIsEquationPossible(target, current + values[0], values + 1, num_values - 1);
  if (possible) return TRUE;
  // Then try multiplication
  possible = RecurseIsEquationPossible(target, current * values[0], values + 1, num_values - 1);
  if (possible) return TRUE;
  // No combinations worked
  return FALSE;
}

/**
 * Returns whether it is possible to produce the target value from the given
 * values.
 */
Bool IsEquationPossible(Equation *e)
{
  // Provide the first value, so that we don't begin by multiplying by zero
  return RecurseIsEquationPossible(e->target, e->values[0], e->values + 1, e->num_values - 1);
}

// ============================================================================

I64 Part1(U8 *file)
{
  U8 *input = FileRead(file);
  if (input == NULL)
  {
    "%s: Failed to read\n", file;
    Exit(1);
  }
  // Produce each equation
  Bool line_start = TRUE;
  I64 total = 0;
  for (I64 i = 0; input[i] != '\0'; i++)
  {
    if (line_start)
    {
      line_start = FALSE;
      // More yucky pointer arithmetic
      Equation *e = EquationFromLine(input + i);
      PrintEquation(e);
      if (IsEquationPossible(e))
      {
        "^^^ Possible\n";
        total += e->target;
      }
      FreeEquation(e);
    } else
    {
      if (input[i] == '\n')
      {
        line_start = TRUE;
      }
    }
  }
  Free(input);
  return total;
}

U0 Main(I64 argc, U8 **argv)
{
  if (argc == 1)
  {
    "Usage: %s [input file]\n",argv[0];
    Exit(1);
  }
  I64 part_1 = Part1(argv[1]);
  "\n === PART 1 ===\n";
  U8 *str = I64ToString(part_1);
  "%s\n",str;
  Free(str);
  Exit(0);
}
