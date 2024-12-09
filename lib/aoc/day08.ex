defmodule Aoc.Day08 do
  def process_input(input) do
    dimr = input |> String.split("\n", trim: true) |> Enum.count()
    dimc = input |> String.split("\n", trim: true) |> Enum.at(0) |> String.length()

    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index(fn el, r ->
        el
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {val, _c} -> val != "." end)
        |> Enum.map(fn {val, c} -> {val, {r, c}} end)
      end)
      |> List.flatten()
      |> Enum.reduce(Map.new(), fn {val, {r, c}}, acc ->
        Map.update(acc, val, [[r, c]], fn x -> [[r, c] | x] end)
      end)

    {map, dimr, dimc}
  end

  def diff_vector(v1, v2) do
    Enum.zip(v1, v2)
    |> Enum.map(fn {a, b} -> a - b end)
  end

  def sum_vector(v1, v2) do
    Enum.zip(v1, v2)
    |> Enum.map(fn {a, b} -> a + b end)
  end

  def generate_antinode(map, dimr, dimc) do
    for {_freq, points} <- map,
        [v1, v2] <- Aoc.comb(2, points),
        reduce: MapSet.new() do
      acc ->
        diff = diff_vector(v1, v2)

        for [r, c] <- [sum_vector(v1, diff), diff_vector(v2, diff)],
            r >= 0 and c >= 0 and r < dimr and c < dimc,
            reduce: acc do
          inneracc ->
            MapSet.put(inneracc, {r, c})
        end
    end
  end

  def part1(args) do
    {map, dimr, dimc} =
      args
      |> process_input()

    generate_antinode(map, dimr, dimc)
    |> MapSet.size()
  end

  def scalar_vector(v, scalar) do
    Enum.map(v, &(&1 * scalar))
  end

  def generate_all_antinode(map, dimr, dimc) do
    for {_freq, points} <- map,
        [v1, v2] <- Aoc.comb(2, points),
        reduce: MapSet.new() do
      acc ->
        diff = diff_vector(v1, v2)
        s = sum_all_vectors(v1, diff, 0, dimr, dimc, [])

        d = diff_all_vectors(v2, diff, 0, dimr, dimc, [])

        for n <- s ++ d, reduce: acc do
          inneracc ->
            MapSet.put(inneracc, n)
        end
    end
  end

  def sum_all_vectors(v1, v2, scalar, dimr, dimc, acc) do
    [r, c] = sum_vector(v1, scalar_vector(v2, scalar))

    cond do
      r >= 0 and c >= 0 and r < dimr and c < dimc ->
        sum_all_vectors(v1, v2, scalar + 1, dimr, dimc, [[r, c] | acc])

      true ->
        acc
    end
  end

  def diff_all_vectors(v1, v2, scalar, dimr, dimc, acc) do
    [r, c] = diff_vector(v1, scalar_vector(v2, scalar))

    cond do
      r >= 0 and c >= 0 and r < dimr and c < dimc ->
        diff_all_vectors(v1, v2, scalar + 1, dimr, dimc, [[r, c] | acc])

      true ->
        acc
    end
  end

  def part2(args) do
    {map, dimr, dimc} =
      args
      |> process_input()

    generate_all_antinode(map, dimr, dimc)
    |> MapSet.size()
  end
end
