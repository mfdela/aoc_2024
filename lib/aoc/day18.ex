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
    |> Enum.slice(0..(first_bytes - 1))
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

  def shortest_paths(graph, start_node) do
    initial_distances =
      Map.new(Map.keys(graph), fn node ->
        {node, if(node == start_node, do: 0, else: :infinity)}
      end)

    initial_predecessors = %{}
    unvisited = MapSet.new(Map.keys(graph))

    find_paths(graph, unvisited, initial_distances, initial_predecessors)
  end

  def find_paths(graph, unvisited, distances, predecessors) do
    case MapSet.size(unvisited) do
      0 ->
        {distances, predecessors}

      _ ->
        # Find unvisited node with minimum distance
        current =
          unvisited
          |> Enum.filter(fn node -> Map.get(distances, node) != :infinity end)
          |> Enum.min_by(fn node -> Map.get(distances, node) end, fn -> nil end)

        case current do
          # No more reachable nodes
          nil ->
            {distances, predecessors}

          node ->
            # Update distances to all neighbors
            {new_distances, new_predecessors} =
              update_neighbors(graph, node, unvisited, distances, predecessors)

            # Continue with remaining unvisited nodes
            find_paths(
              graph,
              MapSet.delete(unvisited, node),
              new_distances,
              new_predecessors
            )
        end
    end
  end

  def update_neighbors(graph, current, unvisited, distances, predecessors) do
    current_dist = Map.get(distances, current)

    # Get all unvisited neighbors
    neighbors =
      graph
      |> Map.get(current, %{})
      |> Map.take(MapSet.to_list(unvisited))

    # Update distances and predecessors for each neighbor
    Enum.reduce(neighbors, {distances, predecessors}, fn {neighbor, weight},
                                                         {dist_acc, pred_acc} ->
      new_distance = current_dist + weight

      if new_distance < Map.get(dist_acc, neighbor, :infinity) do
        {
          Map.put(dist_acc, neighbor, new_distance),
          Map.put(pred_acc, neighbor, current)
        }
      else
        {dist_acc, pred_acc}
      end
    end)
  end

  def get_path(_start_node, end_node, predecessors) do
    build_path(end_node, predecessors, [])
  end

  defp build_path(nil, _predecessors, _acc), do: nil

  defp build_path(node, predecessors, acc) do
    case Map.get(predecessors, node) do
      nil -> [node | acc]
      predecessor -> build_path(predecessor, predecessors, [node | acc])
    end
  end

  def part1(args, dim \\ 70, first_bytes \\ 1024) do
    bytes =
      args
      |> process_input()

    create_grid(dim)
    |> drop_bytes(bytes, first_bytes)
    |> create_graph()
    |> shortest_paths({0, 0})
    |> elem(0)
    |> Map.get({dim, dim})
  end

  def find_cutoff(graph, bytes, end_node, last_grid, last_cut) do
    {_dist, predecessors} = shortest_paths(graph, {0, 0})
    shortest_path = get_path({0, 0}, end_node, predecessors)

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
