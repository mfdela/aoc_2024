defmodule Aoc.Day01 do
  def part1(args) do
    args
    |> clean_input()
    |> sort()
    |> list_difference()
  end

  def clean_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/\s+/))
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
    |> Enum.unzip()
  end

  def sort({list1, list2}), do: {Enum.sort(list1), Enum.sort(list2)}

  def list_difference({list1, list2}) do
    Enum.zip(list1, list2)
    |> Enum.reduce(0, fn {a, b}, s -> s + abs(a - b) end)
  end

  def part2(args) do
    {list1, list2} =
      args
      |> clean_input()

    Enum.reduce(list1, 0, fn x, acc -> acc + x * Enum.count(list2, &(&1 == x)) end)
  end

  def count_occurrence([], _), do: 0
  def count_occurrence([x | xs], x), do: 1 + count_occurrence(xs, x)
  def count_occurrence([_ | xs], x), do: count_occurrence(xs, x)
end
