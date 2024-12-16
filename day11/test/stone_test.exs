defmodule StoneTest do
  use ExUnit.Case
  alias Day11.Stone
  doctest Stone

  test "zero stones produce [1]" do
    assert Stone.blink(0) == [1]
  end

  test "stone with even digits is split" do
    assert Stone.blink(12) == [1, 2]
  end

  test "other stones are multiplied" do
    assert Stone.blink(1) == [2024]
  end
end
