defmodule Aoc.Day01 do
  def part1(args) do
    args
    |> clean_input()
    |> extract_lists()
    |> sort()
    |> list_difference()
  end

  def clean_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/\s+/))
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
  end

  def extract_lists(list),
    do: Enum.reduce(list, [[], []], fn [x, y], [list1, list2] -> [[x | list1], [y | list2]] end)

  def sort(list_of_lists), do: Enum.map(list_of_lists, fn list -> Enum.sort(list) end)

  def list_difference([list1, list2]) do
    Enum.reduce(0..(length(list1) - 1), 0, fn i, acc ->
      acc + abs(Enum.at(list1, i) - Enum.at(list2, i))
    end)
  end

  def part2(args) do
    [list1, list2] =
      args
      |> clean_input()
      |> extract_lists()

    Enum.reduce(list1, 0, fn x, acc -> acc + x * count_occurrence(list2, x) end)
  end

  def count_occurrence([], _), do: 0
  def count_occurrence([x | xs], x), do: 1 + count_occurrence(xs, x)
  def count_occurrence([_ | xs], x), do: count_occurrence(xs, x)
end
