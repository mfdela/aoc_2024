defmodule Elixir.Mix.Tasks.D21.P1 do
  use Mix.Task

  import Elixir.Aoc.Day21

  @shortdoc "Day 21 Part 1"
  def run(args) do
    {:ok, _} = Application.ensure_all_started(:memoize)
    input = Aoc.Input.get!(21, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
