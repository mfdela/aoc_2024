defmodule Aoc.Day25 do
  def process_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.split_with(fn x ->
      String.starts_with?(hd(x), "#")
    end)
    |> then(fn {locks, keys} ->
      for l <- [locks, keys] do
        l
        |> Enum.map(fn row -> Enum.map(row, &String.split(&1, "", trim: true)) end)
      end
    end)
  end

  def transpose([[] | _]), do: []

  def transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end

  def find_heights([locks, keys]) do
    for l <- [locks, keys] do
      for m <- l do
        m
        |> transpose()
        |> Enum.map(fn row -> Enum.count(row, fn x -> x == "#" end) - 1 end)
      end
    end
  end

  def find_fit([locks, keys]) do
    for l <- locks, k <- keys, reduce: 0 do
      acc ->
        case lock_key(l, k) do
          true -> acc + 1
          false -> acc
        end
    end
  end

  def lock_key(lock, key) do
    Enum.zip(lock, key)
    |> Enum.all?(fn {l, k} -> l + k <= 5 end)
  end

  def part1(args) do
    args
    |> process_input()
    |> find_heights()
    |> find_fit()
  end

  def part2(args) do
    args
  end
end
