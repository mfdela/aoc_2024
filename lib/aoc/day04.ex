defmodule Aoc.Day04 do
  def part1(args) do
    args
    |> parse_input()
    |> find_xmas()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {val, c} -> {{r, c}, val} end)
    end)
    |> Map.new()
  end

  def find_xmas(map) do
    map
    |> Enum.reduce(0, fn {{r, c}, v}, acc ->
      if v == "X" do
        acc + find_next(map, r, c, next("X"), 0)
      else
        acc
      end
    end)
  end

  def next(char) do
    case char do
      "X" -> "M"
      "M" -> "A"
      "A" -> "S"
      "S" -> :end
      _ -> :not_found
    end
  end

  def find_next(map, r, c, char, sum) do
    for di <- -1..1, dj <- -1..1, di != 0 or dj != 0, reduce: sum do
      acc ->
        if Map.get(map, {r + di, c + dj}) == char do
          acc + find_next(map, r + di, c + dj, di, dj, next(char), sum)
        else
          acc
        end
    end
  end

  def find_next(_map, _r, _c, _di, _dj, :end, sum), do: sum + 1

  def find_next(_map, _r, _c, _di, _dj, :not_found, sum), do: sum

  def find_next(map, r, c, di, dj, char, sum) do
    if Map.get(map, {r + di, c + dj}) == char do
      find_next(map, r + di, c + dj, di, dj, next(char), sum)
    else
      sum
    end
  end

  def part2(args) do
    args
    |> parse_input()
    |> find_x_mas()
  end

  def find_x_mas(map) do
    map
    |> Enum.reduce(0, fn {{r, c}, v}, acc ->
      if v == "A" && find_x(map, r, c) do
        acc + 1
      else
        acc
      end
    end)
  end

  def find_x(map, r, c) do
    l =
      Enum.join([Map.get(map, {r - 1, c - 1}), Map.get(map, {r + 1, c + 1})])

    r =
      Enum.join([Map.get(map, {r - 1, c + 1}), Map.get(map, {r + 1, c - 1})])

    (l == "MS" || l == "SM") && (r == "MS" || r == "SM")
  end
end
