#include "src/number.hc"

/** Represents a line of an equation */
class Equation
{
  I64 target;
  I64 *values;
  I64 num_values;
};

Equation *EquationFromLine(U8 *line)
{
  Equation *e = MAlloc(sizeof(Equation));
  // Target value
  e->target = StringToI64(line);
  e->num_values = 0;

  // Manually determine how much space to allocate
  for (I64 i = 0; line[i] != '\n'; i++)
  {
    if (line[i] == ' ') e->num_values++;
  }
  e->values = MAlloc(sizeof(I64) * e->num_values);

  // Find all given values
  Bool found_new_int = FALSE;
  I64 value_index = 0;
  for (I64 i = 0; line[i] != '\n'; i++)
  {
    if (line[i] != ' ')
    {
      if (found_new_int)
      {
        // Need to do pointer arithmetic, since using `&line[i]` didn't seem to
        // work nicely
        I64 result = StringToI64(line + i);
        e->values[value_index++] = result;
        found_new_int = FALSE;
      }
    } else {
      found_new_int = TRUE;
    }
  }

  return e;
}

U0 FreeEquation(Equation *e)
{
  Free(e->values);
  Free(e);
}

U0 PrintEquation(Equation *e)
{
  "%lld:", e->target;
  for (I64 i = 0; i < e->num_values; i++)
  {
    " %lld", e->values[i];
  }
  "\n";
}
