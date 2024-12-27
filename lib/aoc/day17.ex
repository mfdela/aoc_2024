defmodule Aoc.Day17 do
  import Bitwise
  alias :math, as: Math

  def process_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(Map.new(), fn
      <<"Register ", register, ": ", value::binary>>, acc ->
        Map.update(acc, :registers, Map.new([{register, String.to_integer(value)}]), fn map ->
          Map.put(map, register, String.to_integer(value))
        end)

      # {:register, String.to_integer(value)}

      <<"Program: ", program::binary>>, acc ->
        Map.put(
          acc,
          :program,
          program
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer/1)
          |> Enum.with_index()
          |> Enum.map(fn {val, idx} -> {idx, val} end)
          |> Map.new()
        )
    end)
    |> update_in([:registers, :out], fn _ -> [] end)
  end

  def op(opscode, operand, code) do
    case opscode do
      0 ->
        {:adv, trunc(code[:registers][?A] / Math.pow(2, combo_operand(operand, code))), ?A, 2}

      1 ->
        {:bxl, bxor(code[:registers][?B], operand), ?B, 2}

      2 ->
        {:bxt, rem(combo_operand(operand, code), 8), ?B, 2}

      3 ->
        case code[:registers][?A] do
          0 -> {:nul, nil, nil, 2}
          _ -> {:jnz, nil, nil, operand}
        end

      4 ->
        {:bxc, bxor(code[:registers][?B], code[:registers][?C]), ?B, 2}

      5 ->
        {:out, rem(combo_operand(operand, code), 8), :out, 2}

      6 ->
        {:bdv, trunc(code[:registers][?A] / Math.pow(2, combo_operand(operand, code))), ?B, 2}

      7 ->
        {:cdv, trunc(code[:registers][?A] / Math.pow(2, combo_operand(operand, code))), ?C, 2}
    end
  end

  def combo_operand(operand, code) do
    case operand do
      0 -> 0
      1 -> 1
      2 -> 2
      3 -> 3
      4 -> code[:registers][?A]
      5 -> code[:registers][?B]
      6 -> code[:registers][?C]
      7 -> :error
    end
  end

  def parse_opscode(code, instruction_pointer) do
    case code[:program][instruction_pointer] do
      nil ->
        {code, instruction_pointer, :halt}

      opscode ->
        operand = code[:program][instruction_pointer + 1]
        {instr, result, register, offset} = op(opscode, operand, code)

        case instr do
          :nul ->
            {code, instruction_pointer + offset, :nul}

          :jnz ->
            {code, offset, :jnz}

          :out ->
            {code
             |> update_in([:registers, :out], fn x -> x ++ [result] end),
             instruction_pointer + offset, :out}

          _ ->
            {code
             |> update_in([:registers, register], fn _ -> result end),
             instruction_pointer + offset, instr}
        end
    end
  end

  def parse_program({code, instruction_pointer}) do
    parse_opscode(code, instruction_pointer)
    |> then(fn
      {_, _, :halt} ->
        {:halt, code[:registers][:out]}

      {new_code, next_instrunction_pointer, _} ->
        parse_program({new_code, next_instrunction_pointer})
    end)
  end

  def part1(args) do
    {args
     |> process_input(), 0}
    |> parse_program()
    |> then(fn
      {:halt, out} -> Enum.join(out, ",")
      _ -> :error
    end)
  end

  def find_quine(code) do
    prog_list =
      code[:program]
      |> Map.keys()
      |> Enum.sort()
      |> Enum.map(&code[:program][&1])
      |> Enum.reverse()

    parse_quine(code, 0, prog_list)
  end

  def parse_quine(_code, reg_a, []), do: reg_a

  def parse_quine(code, reg_a, [out | rest]) do
    Enum.find_value(0..7, fn i ->
      [program_out | _] = program_reg_a_out(code, reg_a * 8 + i)

      if program_out == out do
        case parse_quine(code, reg_a * 8 + i, rest) do
          0 -> false
          result -> result
        end
      else
        false
      end
    end)
  end

  def program_reg_a_out(code, reg_a) do
    inject_reg_a =
      update_in(code, [:registers, ?A], fn _ -> reg_a end)

    case parse_program({inject_reg_a, 0}) do
      {:halt, out} -> out
      _ -> :error
    end
  end

  def part2(args) do
    args
    |> process_input()
    |> find_quine()
  end
end
