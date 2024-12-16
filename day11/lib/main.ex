defmodule Day11 do
  @moduledoc """
  Documentation for `Day11`.
  """

  alias Day11.Stone

  def start(_type, _args) do
    input =
      case System.argv() do
        [file] -> File.read!(file)
        [] -> IO.read(:eof)
      end

    stones =
      String.trim(input)
      |> String.split()
      |> Enum.map(fn s -> Integer.parse(s) |> elem(0) end)

    part_1 =
      stones
      |> Enum.map(fn stone -> calculate_after_blinks(stone, 25) end)
      |> Enum.sum()

    IO.puts("Part 1: #{part_1}")

    part_2 =
      stones
      |> Enum.map(fn stone -> calculate_after_blinks(stone, 75) end)
      |> Enum.sum()

    IO.puts("Part 2: #{part_2}")

    {:ok, self()}
  end

  def calculate_after_blinks(_stone, 0) do
    1
  end

  def calculate_after_blinks(stone, n) when n > 0 do
    Stone.blink(stone)
    |> Stream.map(&calculate_after_blinks(&1, n - 1))
    |> Enum.sum()
  end
end
