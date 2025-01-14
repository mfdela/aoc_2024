defmodule Aoc.Day21 do
  use Memoize

  defmemo create_num_keypad() do
    ["789", "456", "123", " 0A"]
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {val, c} -> {{r, c}, val} end)
    end)
    |> Map.new()

  end

  defmemo create_dir_keypad() do
    [" ^A", "<v>"]
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {val, c} -> {{r, c}, val} end)
    end)
    |> Map.new()
  end

  def move(dir, {r, c}) do
   case dir do
      ">" -> {r, c + 1}
      "<" -> {r, c - 1}
      "^" -> {r-1, c}
      "v" -> {r+1, c}
   end
  end

  def create_paths_keypad(keypad) do
    for {{r1, c1}, start_k} <- keypad,
        {{r2, c2}, end_k} <- keypad,
        reduce: %{} do
      acc ->
        case start_k == end_k do
          true -> acc
          false -> Map.put(acc, {start_k, end_k}, paths(keypad, {r1, c1}, {r2, c2}))
        end
    end
  end

  def paths(keypad, start_key, end_key) do
    {r1, c1} = Enum.find(keypad, fn {_, v} -> v == start_key end) |> elem(0)
    {r2, c2} = Enum.find(keypad, fn {_, v} -> v == end_key end) |> elem(0)
    dr = abs(r1 - r2)
    dc = abs(c1 - c2)

    rp =
      case r1 > r2 do
        false -> "v"
        true -> "^"
      end
      |> List.duplicate(dr)

    cp =
      case c1 > c2 do
        false -> ">"
        true -> "<"
      end
      |> List.duplicate(dc)

    [rp ++ cp, cp ++ rp]
    |> Enum.filter(&valid_path?(keypad, {r1, c1}, &1))
    |> Enum.uniq()
    |> Enum.map(&(&1 ++ ["A"]))
  end

  def valid_path?(keypad, {r, c}, path) do
    Enum.reduce_while(path, {{r, c}, true}, fn
      d, {{r1, c1}, true} ->
        {r2, c2} = move(d, {r1, c1})
        case Map.get(keypad, {r2, c2}) do
          " " -> {:halt, {{r2, c2}, false}}
          _ -> {:cont, {{r2, c2}, true}}
        end
    end)
    |> elem(1)
  end



  defmemo find_shortest(key, keypad, depth) do
    ["A" | key]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&shortest_path(&1, keypad, depth))
    |> Enum.sum()
  end

  defmemo(shortest_path(_pair, _keypad, 0), do: 1)

  defmemo(shortest_path([start_key, end_key], _keypad, _depth) when start_key == end_key,
    do: 1
  )

  defmemo shortest_path([start_key, end_key], keypad, depth) do
    dir = create_dir_keypad()
    paths(keypad, start_key, end_key)
    |> Enum.map(&find_shortest(&1, dir, depth - 1))
    |> Enum.min()
  end

  def part1(args) do
     n = create_num_keypad()

    args
     |> String.split("\n", trim: true)
     |> Enum.map(&{Integer.parse(&1), String.split(&1, "", trim: true)})
     |> Enum.map(&((elem(&1, 0) |> elem(0)) * (elem(&1, 1) |> find_shortest(n, 3))))
     |> Enum.sum()
  end

  def part2(args) do
    n = create_num_keypad()

    args
    |> String.split("\n", trim: true)
    |> Enum.map(&{Integer.parse(&1), String.split(&1, "", trim: true)})
    |> Enum.map(&((elem(&1, 0) |> elem(0)) * (elem(&1, 1) |> find_shortest(n, 26))))
    |> Enum.sum()
  end
end
