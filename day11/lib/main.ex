defmodule Day11 do
  @moduledoc """
  Documentation for `Day11`.
  """

  alias Day11.Stone
  alias Day11.Cache

  def start(_type, _args) do
    Cache.start_link()

    {input, iterations} =
      case System.argv() do
        [file, n] -> {File.read!(file), Integer.parse(n) |> elem(0)}
        [file] -> {File.read!(file), 1}
        [] -> {IO.read(:eof), 1}
      end

    stones =
      String.trim(input)
      |> String.split()
      |> Enum.map(fn s -> Integer.parse(s) |> elem(0) end)

    answer =
      stones
      |> Enum.map(fn stone -> calculate_after_blinks(stone, iterations) end)
      |> Enum.sum()

    IO.puts("#{answer}")
    {:ok, self()}
  end

  def calculate_after_blinks(_stone, 0) do
    1
  end

  def calculate_after_blinks(stone, n) when n > 0 do
    case Cache.get(stone, n) do
      nil ->
        Stone.blink(stone)
        |> Stream.map(&calculate_after_blinks(&1, n - 1))
        |> Enum.sum()
        |> then(fn value -> Cache.put(stone, n, value) end)

      x ->
        x
    end
  end
end
