defmodule Day11.Cache do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(stone, n) do
    Agent.get(__MODULE__, fn map -> Map.get(map, {stone, n}) end)
  end

  def put(stone, n, value) do
    Agent.update(__MODULE__, fn map -> Map.put(map, {stone, n}, value) end)
    value
  end
end
