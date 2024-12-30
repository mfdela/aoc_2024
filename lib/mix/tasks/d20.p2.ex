defmodule Elixir.Mix.Tasks.D20.P2 do
  use Mix.Task

  import Elixir.Aoc.Day20

  @shortdoc "Day 20 Part 2"
  def run(args) do
    {:ok, _} = Application.ensure_all_started(:memoize)
    input = Aoc.Input.get!(20, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
