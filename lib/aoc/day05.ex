defmodule Aoc.Day05 do
  def part1(args) do
    args
    |> process_input()
    |> then(fn {before_rules, after_rules, updates} ->
      Enum.filter(updates, fn u -> u == sort_update(u, before_rules, after_rules) end)
      |> Enum.map(&extract_middle/1)
      |> Enum.sum()
    end)
  end

  def process_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, %{}, []}, fn x, acc ->
      {before_rules, after_rules, updates} = acc

      cond do
        String.contains?(x, "|") ->
          r =
            x
            |> String.split("|")
            |> Enum.map(&String.to_integer/1)

          b =
            Map.update(before_rules, Enum.at(r, 0), [Enum.at(r, 1)], fn l ->
              l ++ [Enum.at(r, 1)]
            end)

          a =
            Map.update(after_rules, Enum.at(r, 1), [Enum.at(r, 0)], fn l ->
              l ++ [Enum.at(r, 0)]
            end)

          {b, a, updates}

        String.contains?(x, ",") ->
          u =
            [
              x
              |> String.split(",")
              |> Enum.map(&String.to_integer/1)
            ] ++ updates

          {before_rules, after_rules, u}
      end
    end)
  end

  def comparison(x, y, before_rules, after_rules) do
    # IO.inspect("Sort #{x} #{y}")
    # IO.inspect(before_rules[y], label: "before_rules #{y}", charlists: :as_list)
    # IO.inspect(after_rules[x], label: "after_rules #{x}", charlists: :as_list)

    cond do
      !is_nil(before_rules[y]) && x in before_rules[y] -> false
      !is_nil(after_rules[x]) && y in after_rules[x] -> true
      true -> true
    end
  end

  def sort_update(list, before_rules, after_rules) do
    Enum.sort(list, &comparison(&1, &2, before_rules, after_rules))
  end

  def extract_middle(list), do: Enum.at(list, trunc(Enum.count(list) / 2))

  def part2(args) do
    args
    |> process_input()
    |> then(fn {before_rules, after_rules, updates} ->
      updates
      |> Enum.map(fn u ->
        su = sort_update(u, before_rules, after_rules)

        cond do
          su == u -> 0
          true -> extract_middle(su)
        end
      end)
      |> Enum.sum()
    end)
  end
end
