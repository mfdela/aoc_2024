defmodule Aoc.Day03 do
  def find_mul(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input, capture: :all_but_first)
    |> Enum.map(fn [a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def part1(args) do
    args
    |> find_mul()
  end

  def remove_dont(input) do
    Regex.replace(~r/don't\(\)[\s\S]*?(do\(\)|$)/, input, "")
  end

  def part2(args) do
    args
    |> remove_dont()
    |> find_mul()
  end
end
