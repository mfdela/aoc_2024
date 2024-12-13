defmodule Aoc.Day11 do
  alias :math, as: Math

  def process_input(input) do
    input
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  def blink_stone(0, cache), do: {%{1 => 1}, cache}

  def blink_stone(x, cache) when x > 0 and x < 10 do
    if Map.has_key?(cache, x) do
      {Map.get(cache, x), cache}
    else
      {%{(x * 2024) => 1}, Map.put(cache, x, %{(x * 2024) => 1})}
    end
  end

  def blink_stone(x, cache) do
    if Map.has_key?(cache, x) do
      {Map.get(cache, x), cache}
    else
      a = floor(Math.log10(x)) + 1

      case rem(a, 2) do
        0 ->
          m =
            [
              binary_part("#{x}", 0, div(a, 2)),
              binary_part("#{x}", div(a, 2), div(a, 2))
            ]
            |> Enum.map(&String.to_integer/1)
            |> Enum.frequencies()

          {m, Map.put(cache, x, m)}

        1 ->
          {%{(x * 2024) => 1}, Map.put(cache, x, %{(x * 2024) => 1})}
      end
    end
  end

  def blink_stones_cycle(m, 0, cache), do: {m, cache}

  def blink_stones_cycle(m, times, cache) do
    {new_map, new_cache} =
      Enum.reduce(m, {%{}, cache}, fn {n, freq}, {map_f, cc} ->
        {nl, nc} = blink_stone(n, cc)

        {
          for {k, v} <- nl, reduce: map_f do
            acc ->
              Map.update(acc, k, v * freq, &(&1 + v * freq))
          end,
          nc
        }
      end)

    blink_stones_cycle(new_map, times - 1, new_cache)
  end

  def part1(args) do
    args
    |> process_input()
    |> blink_stones_cycle(25, %{})
    |> elem(0)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> process_input()
    |> blink_stones_cycle(75, %{})
    |> elem(0)
    |> Map.values()
    |> Enum.sum()
  end
end
