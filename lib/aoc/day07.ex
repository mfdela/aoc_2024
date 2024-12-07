defmodule Aoc.Day07 do
  def process_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [result, operands] ->
      [
        String.to_integer(result),
        operands |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      ]
      |> List.flatten()
    end)
  end

  def fun_operators() do
    %{
      "+" => fn a, b -> a + b end,
      "*" => fn a, b -> a * b end,
      "||" => fn a, b -> String.to_integer("#{a}#{b}") end
    }
  end

  def check_result([result | operands], operators) do
    [first | others] = operands
    check_result(result, first, others, operators)
  end

  def check_result(result, partial, [a], operators) do
    for op <- operators, fun = Map.get(fun_operators(), op), reduce: false do
      acc ->
        acc || result == fun.(partial, a)
    end

    # |> IO.inspect(label: "check_result")
  end

  def check_result(result, partial, [a | operands], operators) do
    for op <- operators, fun = Map.get(fun_operators(), op), reduce: false do
      acc ->
        acc ||
          (result >= fun.(partial, a) &&
             check_result(result, fun.(partial, a), operands, operators))
    end
  end

  def part1(args) do
    args
    |> process_input()
    |> Enum.map(fn x ->
      case check_result(x, ["+", "*"]) do
        true -> Enum.at(x, 0)
        false -> 0
      end
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> process_input()
    |> Enum.map(fn x ->
      case check_result(x, ["+", "*", "||"]) do
        true -> Enum.at(x, 0)
        false -> 0
      end
    end)
    |> Enum.sum()
  end
end
