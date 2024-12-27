defmodule Elixir.Mix.Tasks.D18.P1 do
  use Mix.Task

  import Elixir.Aoc.Day18

  @shortdoc "Day 18 Part 1"
  def run(args) do
    input = Aoc.Input.get!(18, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
