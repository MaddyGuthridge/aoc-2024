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

Bool RecurseIsEquationPossible(I32 part, I64 target, I64 current, I64 *values, I64 num_values)
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
  Bool possible = RecurseIsEquationPossible(part, target, current + values[0], values + 1, num_values - 1);
  if (possible) {
    return TRUE;
  }
  // Then try multiplication
  possible = RecurseIsEquationPossible(part, target, current * values[0], values + 1, num_values - 1);
  if (possible) {
    return TRUE;
  }
  if (part == 2)
  {
    I64 cat = I64Cat(current, values[0]);
    // Then try concatenation (added)
    possible = RecurseIsEquationPossible(part, target, cat, values + 1, num_values - 1);
    if (possible) {
      return TRUE;
    }
  }
  // No combinations worked
  return FALSE;
}

/**
 * Returns whether it is possible to produce the target value from the given
 * values.
 */
Bool IsEquationPossible(I32 part, Equation *e)
{
  // Provide the first value, so that we don't begin by multiplying by zero
  return RecurseIsEquationPossible(part, e->target, e->values[0], e->values + 1, e->num_values - 1);
}

// ============================================================================

U0 Solve(I32 part, U8 *input)
{
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
      if (IsEquationPossible(part, e))
      {
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
  "\n=== PART %d ===\n", part;
  "%lld\n",total;
}

U0 Main(I64 argc, U8 **argv)
{
  if (argc == 1)
  {
    "Usage: %s [input file]\n",argv[0];
    Exit(1);
  }
  U8 *input = FileRead(argv[1]);
  if (input == NULL)
  {
    "%s: Failed to read\n", argv[1];
    Exit(1);
  }

  Solve(1, input);
  Solve(2, input);
  Free(input);
  Exit(0);
}
