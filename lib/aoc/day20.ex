defmodule Aoc.Day20 do
  use Memoize

  def process_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {val, c} -> {{r, c}, val} end)
    end)
    |> Map.new()
  end

  def create_graph(map) do
    for {x, y} <- Map.keys(map), reduce: %{} do
      acc ->
        Map.put(
          acc,
          {x, y},
          [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
          |> Enum.filter(&(Map.get(map, &1) == "."))
          |> Enum.map(&{&1, 1})
          |> Map.new()
        )
    end
  end

  def find_extreme(map, char) do
    map
    |> Map.keys()
    |> Enum.find(fn {x, y} -> Map.get(map, {x, y}) == char end)
  end

  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def find_cheats(map, start_node, end_node, part) do
    {_dists, pred} =
      map
      |> create_graph()
      |> Aoc.Graphs.shortest_paths(start_node)

    best_path_dists =
      Aoc.Graphs.get_path(start_node, end_node, pred)
      |> hd()
      |> Enum.with_index()
      |> Enum.reduce(map, fn {pos, index}, acc ->
        Map.put(acc, pos, index)
      end)

    valid =
      map
      |> Map.filter(fn {_, val} -> val == "." end)

    case part do
      1 ->
        for {pos1, _} <- valid,
            {pos2, _} <- valid,
            manhattan_distance(pos1, pos2) == 2 do
          Map.get(best_path_dists, pos2) - Map.get(best_path_dists, pos1)
        end

      2 ->
        for {pos1, _} <- valid,
            {pos2, _} <- valid,
            manhattan_distance(pos1, pos2) <= 20 do
          {pos2, pos1}
        end
        |> Enum.uniq()
        |> Enum.map(fn {pos1, pos2} ->
          Map.get(best_path_dists, pos2) - Map.get(best_path_dists, pos1) -
            manhattan_distance(pos1, pos2) + 1
        end)
    end
  end

  def part1(args) do
    map =
      args
      |> process_input()

    start_node = find_extreme(map, "S")
    end_node = find_extreme(map, "E")

    map
    |> Map.put(start_node, ".")
    |> Map.put(end_node, ".")
    |> find_cheats(start_node, end_node, 1)
    |> Enum.count(&(&1 > 100))
  end

  def part2(args) do
    map =
      args
      |> process_input()

    start_node = find_extreme(map, "S")
    end_node = find_extreme(map, "E")

    map
    |> Map.put(start_node, ".")
    |> Map.put(end_node, ".")
    |> find_cheats(start_node, end_node, 2)
    |> Enum.count(&(&1 > 100))
  end
end
