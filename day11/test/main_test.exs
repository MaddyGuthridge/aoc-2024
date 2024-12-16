defmodule MainTest do
  use ExUnit.Case
  doctest Day11

  test "calculate_after_blinks works for simple input" do
    # 1
    # 2024
    # 20 24
    # 2 0 2 4
    # 2024 1 2024 4048
    assert Day11.calculate_after_blinks(1, 4) == 4
  end

  test "calculate_after_blinks works for less simple input" do
    # 10
    # 1 0
    # 2024 1
    # 20 24 2024
    assert Day11.calculate_after_blinks(10, 3) == 3
  end
end
