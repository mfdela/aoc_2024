defmodule Aoc.Day02 do
  def part1(args) do
    args
    |> clean_input()
    |> Enum.map(&safe/1)
    |> Enum.sum()
  end

  def clean_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn a -> Enum.map(a, &String.to_integer/1) end)
  end

  def safe(array) do
    diff =
      array
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [x, y] -> y - x end)

    cond do
      Enum.all?(diff, &(&1 in 1..3)) -> 1
      Enum.all?(diff, &(&1 in -3..-1)) -> 1
      true -> 0
    end
  end

  def safe_minus_one(array) do
    array
    |> Enum.with_index()
    |> Enum.any?(fn {_, i} -> array |> List.delete_at(i) |> safe() == 1 end)
  end

  def part2(args) do
    args
    |> clean_input()
    |> Enum.map(&safe_minus_one/1)
    |> Enum.count(& &1)
  end
end
