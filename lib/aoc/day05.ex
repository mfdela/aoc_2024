defmodule Aoc.Day05 do
  def part1(args) do
    {rules, updates} =
      args
      |> process_input()

    updates
    |> Enum.filter(fn u -> u == sort(u, rules) end)
    |> Enum.map(&extract_middle/1)
    |> Enum.sum()
  end

  def process_input(input) do
    [rules_string, updates_string] = String.split(input, "\n\n", trim: true)

    rules =
      for r <- rules_string |> String.split("\n", trim: true),
          x = r |> String.split("|"),
          reduce: MapSet.new() do
        acc ->
          MapSet.put(acc, {Enum.at(x, 0), Enum.at(x, 1)})
      end

    updates =
      for u <- String.split(updates_string, "\n", trim: true),
          do: u |> String.split(",", trim: true)

    {rules, updates}
  end

  def sort(list, rules), do: Enum.sort(list, &comparison(&1, &2, rules))

  def comparison(x, y, rules), do: !MapSet.member?(rules, {y, x})

  def extract_middle(list), do: Enum.at(list, trunc(Enum.count(list) / 2)) |> String.to_integer()

  def part2(args) do
    {rules, updates} =
      args
      |> process_input()

    updates
    |> Enum.map(fn u ->
      su = sort(u, rules)

      cond do
        su == u -> 0
        true -> extract_middle(su)
      end
    end)
    |> Enum.sum()
  end
end
