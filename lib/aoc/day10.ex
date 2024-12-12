defmodule Aoc.Day10 do
  def process_input(input) do
    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        x |> String.graphemes() |> Enum.map(fn y -> String.to_integer(y) end) |> Enum.with_index()
      end)
      |> Enum.with_index()

    for {row, row_index} <- map, {val, col_index} <- row, reduce: {Map.new(), []} do
      acc ->
        {m, s} = acc
        nm = Map.put(m, {row_index, col_index}, val)

        case val do
          0 -> {nm, s ++ [{row_index, col_index}]}
          _ -> {nm, s}
        end
    end
  end

  def find_neighbours({r, c}, 9, _map, set, curr_path, paths),
    do: {MapSet.put(set, {r, c}), MapSet.put(paths, curr_path ++ [{r, c, 9}])}

  def find_neighbours({r, c}, val, map, set, curr_path, paths) do
    for dr <- [-1, 0, 1], dc <- [-1, 0, 1], dr == 0 != (dc == 0) do
      {r + dr, c + dc}
    end
    |> Enum.filter(fn {r, c} -> Map.get(map, {r, c}) == val + 1 end)
    |> Enum.reduce({set, paths}, fn {dr, dc}, acc ->
      {curr_set, p} = acc

      {new_set, new_p} =
        find_neighbours({dr, dc}, val + 1, map, set, curr_path ++ [{r, c, val}], p)

      {MapSet.union(curr_set, new_set), MapSet.union(paths, new_p)}
    end)
  end

  def part1(args) do
    {map, start} =
      args
      |> process_input()

    Enum.reduce(start, 0, fn {r, c}, acc ->
      {set, _paths} = find_neighbours({r, c}, 0, map, MapSet.new(), [], MapSet.new())
      acc + MapSet.size(set)
    end)
  end

  def part2(args) do
    {map, start} =
      args
      |> process_input()

    IO.inspect(start |> hd, label: "start")

    Enum.reduce(start, 0, fn {r, c}, acc ->
      {_set, paths} = find_neighbours({r, c}, 0, map, MapSet.new(), [], MapSet.new())
      acc + MapSet.size(paths)
    end)
  end
end
