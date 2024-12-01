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
    |> Tuple.to_list()
  end

  def sort([list1, list2]), do: [Enum.sort(list1), Enum.sort(list2)]

  def list_difference([list1, list2]) do
    Enum.zip(list1, list2)
    |> Enum.reduce(0, fn {a, b}, s -> s + abs(a - b) end)
  end

  def part2(args) do
    args
    |> clean_input()
    |> Enum.map(&Enum.frequencies/1)
    |> then(fn [map1, map2] ->
      Enum.reduce(Map.keys(map1), 0, fn x, acc -> acc + x * map1[x] * Map.get(map2, x, 0) end)
    end)
  end
end
