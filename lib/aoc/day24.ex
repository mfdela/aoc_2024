defmodule Aoc.Day24 do
  import Bitwise

  def process_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> then(fn [i, g] ->
      {
        i
        |> Enum.map(&String.split(&1, ": "))
        |> Enum.map(fn [a, b] -> {a, String.to_integer(b)} end)
        |> Map.new(),
        g
        |> Enum.map(&String.split(&1, " -> "))
        |> Enum.map(fn [a, b] -> {b, {[], parse_gate(a)}} end)
        |> Map.new()
      }
    end)
  end

  def parse_gate(gate) do
    [i1, g, i2] = String.split(gate, " ")

    case g do
      "AND" ->
        {MapSet.new([i1, i2]), :and, fn [a, b] -> band(a, b) end}

      "OR" ->
        {MapSet.new([i1, i2]), :or, fn [a, b] -> bor(a, b) end}

      "XOR" ->
        {MapSet.new([i1, i2]), :xor, fn [a, b] -> bxor(a, b) end}
    end
  end

  def map_reduce(circuit) do
    c =
      circuit
      |> map()
      |> reduce()

    cond do
      elem(c, 1) |> map_size == 0 -> elem(c, 0)
      true -> map_reduce(c)
    end
  end

  def map({inputs, gates}) do
    for {i, b} <- inputs, reduce: {inputs, gates} do
      acc ->
        {ni, g} = acc

        {
          if(String.starts_with?(i, "z"), do: ni, else: Map.delete(ni, i)),
          for {o, {_, {inp, _op, _fun}}} <- g, reduce: g do
            inneracc ->
              cond do
                MapSet.member?(inp, i) and MapSet.size(inp) == 1 ->
                  Map.update!(inneracc, o, fn {_, g} -> {[b, b], g} end)

                MapSet.member?(inp, i) ->
                  Map.update!(inneracc, o, fn {bits, g} -> {bits ++ [b], g} end)

                true ->
                  inneracc
              end
          end
        }
    end
  end

  def reduce({inputs, gates}) do
    for {o, exp = {bits, {_gate_input, _op, fun}}} <- gates, reduce: {inputs, %{}} do
      acc ->
        {i, g} = acc

        case length(bits) == 2 do
          false ->
            {i, Map.put(g, o, exp)}

          true ->
            {Map.put(i, o, fun.(bits)), Map.delete(g, o)}
        end
    end
  end

  def output(inputs) do
    inputs
    |> Enum.sort()
    |> Enum.filter(fn {k, _v} -> String.starts_with?(k, "z") end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reverse()
    |> Enum.join("")
    |> Integer.parse(2)
    |> elem(0)
  end

  def part1(args) do
    args
    |> process_input()
    |> map_reduce()
    |> output()
  end

  def build_adder({inputs, gates}) do
    add0 =
      build_adder_block_0(gates)

    add = Map.put(%{}, 0, add0)

    for i <- 1..(div(Map.keys(inputs) |> length(), 2) - 1), reduce: {add, gates, []} do
      acc ->
        {a, g, wrong_wires} = acc
        carry = Map.get(a, i - 1) |> Map.get(:carry_out)
        add_block = build_adder_block(%{carry_in: carry}, g, i)

        if length(Map.keys(add_block)) < 6 do
          adder_fix(add_block, g, i, [])
          |> then(fn {bb, gg, ww} ->
            {Map.put(a, i, bb), gg, wrong_wires ++ ww}
          end)
        else
          {Map.put(a, i, add_block), g, wrong_wires}
        end
    end
  end

  def build_adder_block_0(gates) do
    for {o, {_bits, {gate_inputs, op, _fun}}} <- gates, reduce: %{} do
      acc ->
        wire_inputs = MapSet.new(["x00", "y00"])

        cond do
          gate_inputs == wire_inputs and op == :xor ->
            Map.put(acc, :sum, o)

          gate_inputs == wire_inputs and op == :and ->
            Map.put(acc, :carry_out, o)

          true ->
            acc
        end
    end
  end

  def build_adder_block(circuit, gates, n) do
    prev_wires = circuit |> Map.keys() |> length()

    add =
      gates
      |> map_adder(n, circuit)

    new_wires = add |> Map.keys() |> length()

    case new_wires == prev_wires do
      true ->
        add

      false ->
        build_adder_block(add, gates, n)
    end
  end

  def map_adder(gates, n, circuit) do
    for {o, {_bits, {gate_inputs, op, _fun}}} <- gates, reduce: circuit do
      acc ->
        wire = n |> Integer.to_string() |> String.pad_leading(2, "0")
        carry_n_1 = Map.get(circuit, :carry_in)
        partial_sum_n = Map.get(circuit, :partial_sum)
        partial_carry_1_n = Map.get(circuit, :partial_carry_1)
        partial_carry_2_n = Map.get(circuit, :partial_carry_2)

        xor_1_inputs = MapSet.new(["x" <> wire, "y" <> wire])
        xor_2_inputs = MapSet.new([carry_n_1, partial_sum_n])
        and_1_inputs = MapSet.new([carry_n_1, partial_sum_n])
        and_2_inputs = MapSet.new(["x" <> wire, "y" <> wire])
        or_inputs = MapSet.new([partial_carry_1_n, partial_carry_2_n])

        cond do
          gate_inputs == xor_1_inputs and op == :xor ->
            Map.put(acc, :partial_sum, o)

          gate_inputs == and_2_inputs and op == :and ->
            Map.put(acc, :partial_carry_2, o)

          gate_inputs == xor_2_inputs and op == :xor ->
            Map.put(acc, :sum, o)

          gate_inputs == and_1_inputs and op == :and ->
            Map.put(acc, :partial_carry_1, o)

          gate_inputs == or_inputs and op == :or ->
            Map.put(acc, :carry_out, o)

          true ->
            acc
        end
    end
  end

  def adder_fix(add_block, gates, i, wrong_wires) do
    adder_layout = %{
      :partial_sum => {MapSet.new([:x, :y]), :xor},
      :partial_carry_1 => {MapSet.new([:carry_in, :partial_sum]), :and},
      :partial_carry_2 => {MapSet.new([:x, :y]), :and},
      :sum => {MapSet.new([:carry_in, :partial_sum]), :xor},
      :carry_out => {MapSet.new([:partial_carry_1, :partial_carry_2]), :or},
      :carry_in => :carry_in
    }

    missings = Map.keys(adder_layout) -- Map.keys(add_block)

    wrongs =
      [:partial_sum, :partial_carry_1, :partial_carry_2, :sum, :carry_out]
      |> Enum.filter(&Enum.member?(missings, &1))
      |> Enum.map(&Map.get(adder_layout, &1))

    adder_fix_block(add_block, gates, wrongs, wrong_wires, i)
  end

  def adder_fix_block(add_block, gates, [], wrong_out, i),
    do: {build_adder_block(add_block, gates, i), gates, wrong_out}

  def adder_fix_block(add_block, gates, [{wrong_in, op} | rest], wrong_out, i) do
    signals =
      wrong_in
      |> Enum.map(fn w -> Map.get(add_block, w) end)
      |> MapSet.new()

    gates
    |> Enum.map(fn gate ->
      {_o, {_bits, {gate_inputs, gate_op, _fun}}} = gate
      diff = MapSet.symmetric_difference(gate_inputs, signals) |> MapSet.to_list()
      {diff, gate_op}
    end)
    |> Enum.find(fn {diff, gate_op} -> length(diff) == 2 and gate_op == op end)
    |> then(fn
      nil ->
        build_adder_block(add_block, gates, i)
        |> adder_fix_block(gates, rest, wrong_out, i)

      {dd, _op} ->
        gg = output_swap(gates, dd)
        carry = Map.get(add_block, :carry_in)

        case carry in dd do
          true ->
            build_adder_block(Map.put(add_block, :carry_in, hd(List.delete(dd, carry))), gg, i)

          false ->
            build_adder_block(add_block, gg, i)
        end
        |> adder_fix_block(gg, rest, wrong_out ++ dd, i)
    end)
  end

  def output_swap(gates, [signal1, signal2]) do
    s1 = Map.get(gates, signal1)
    s2 = Map.get(gates, signal2)

    gates
    |> Map.replace(signal1, s2)
    |> Map.replace(signal2, s1)
  end

  def part2(args) do
    args
    |> process_input()
    |> build_adder()
    |> elem(2)
    |> Enum.sort()
    |> Enum.join(",")
  end
end
