defmodule Aoc.Day13 do
  # alias Nx.LinAlg

  def process_input(input, skew \\ 0) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&process_machine(&1, skew))
  end

  def process_machine(machine, skew) do
    ["Button A: " <> a, "Button B: " <> b, "Prize: " <> p] =
      machine |> String.split("\n", trim: true)

    [parse(a, "+"), parse(b, "+"), parse(p, "=") |> Enum.map(&(&1 + skew))]
  end

  def parse(s, comma) do
    s
    |> String.split(", ")
    |> Enum.map(&(&1 |> String.split(comma) |> Enum.at(1) |> String.to_integer()))
  end

  def solve_machine([[xa, ya], [xb, yb], [xp, yp]]) do
    # Tried Nx.LinAlg, but the rounding errors make
    # the solution not work for the second part
    x = (yb * xp - xb * yp) / (xa * yb - xb * ya)
    y = (xa * yp - ya * xp) / (xa * yb - xb * ya)

    if floor(x) == x and floor(y) == y do
      [trunc(x), trunc(y)]
    else
      [-1, -1]
    end
  end

  def part1(args) do
    args
    |> process_input()
    |> Enum.map(&solve_machine/1)
    |> Enum.filter(fn [x, y] -> x <= 100 && y <= 100 && x >= 0 && y >= 0 end)
    |> Enum.reduce(0, fn [x, y], acc -> acc + x * 3 + y end)
  end

  def part2(args) do
    args
    |> process_input(10_000_000_000_000)
    |> Enum.map(&solve_machine/1)
    |> Enum.filter(fn [x, y] -> x >= 0 && y >= 0 end)
    |> Enum.reduce(0, fn [x, y], acc -> acc + x * 3 + y end)
  end
end
