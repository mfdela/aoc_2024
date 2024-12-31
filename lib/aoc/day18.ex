defmodule Aoc.Day18 do
  def process_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, ",", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def create_grid(dim) do
    for x <- 0..dim, y <- 0..dim, reduce: %{} do
      acc ->
        Map.put(acc, {x, y}, ".")
    end
  end

  def drop_bytes(map, bytes, first_bytes) do
    bytes
    |> Enum.take(first_bytes)
    |> Enum.reduce(map, fn {x, y}, acc -> Map.update!(acc, {x, y}, fn _ -> "#" end) end)
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

  def part1(args, dim \\ 70, first_bytes \\ 1024) do
    bytes =
      args
      |> process_input()

    create_grid(dim)
    |> drop_bytes(bytes, first_bytes)
    |> create_graph()
    |> Aoc.Graphs.shortest_paths({0, 0})
    |> elem(0)
    |> Map.get({dim, dim})
  end

  def find_cutoff(graph, bytes, end_node, last_grid, last_cut) do
    {_dist, predecessors} = Aoc.Graphs.shortest_paths(graph, {0, 0})
    shortest_path = Aoc.Graphs.get_path({0, 0}, end_node, predecessors) |> hd

    case shortest_path do
      [^end_node] ->
        last_cut

      _ ->
        first_drop_idx = Enum.find_index(bytes, fn b -> b in shortest_path end)
        [lc | new_bytes] = Enum.slice(bytes, first_drop_idx..-1//1)

        new_grid =
          last_grid
          |> drop_bytes(bytes, first_drop_idx + 1)

        new_graph = create_graph(new_grid)

        find_cutoff(
          new_graph,
          new_bytes,
          end_node,
          new_grid,
          lc
        )
    end
  end

  def part2(args, dim \\ 70, first_bytes \\ 1024) do
    bytes =
      args
      |> process_input()

    grid = create_grid(dim) |> drop_bytes(bytes, first_bytes)

    create_graph(grid)
    |> find_cutoff(bytes, {dim, dim}, grid, nil)
    |> Tuple.to_list()
    |> Enum.join(",")
  end
end
