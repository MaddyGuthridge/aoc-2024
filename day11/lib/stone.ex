defmodule Day11.Stone do
  def n_digits(value) do
    String.length("#{value}")
  end

  def parse_int(value) do
    case String.replace_leading(value, "0", "") do
      "" -> 0
      s -> Integer.parse(s) |> elem(0)
    end
  end

  def split_number(n) do
    s = "#{n}"
    midpoint = floor(String.length(s) / 2)
    [parse_int(String.slice(s, 0, midpoint)), parse_int(String.slice(s, midpoint, midpoint))]
  end

  def blink(value) do
    cond do
      value == 0 -> [1]
      rem(n_digits(value), 2) == 0 -> split_number(value)
      true -> [value * 2024]
    end
  end
end
