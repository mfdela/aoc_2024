defmodule Aoc.Graphs do
  def shortest_paths(graph, start_node, all \\ false) do
    initial_distances =
      Map.new(Map.keys(graph), fn node ->
        {node, if(node == start_node, do: 0, else: :infinity)}
      end)

    initial_predecessors = %{}
    unvisited = MapSet.new(Map.keys(graph))

    find_paths(graph, unvisited, initial_distances, initial_predecessors, all)
  end

  def find_paths(graph, unvisited, distances, predecessors, all \\ false) do
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
              update_neighbors(graph, node, unvisited, distances, predecessors, all)

            # Continue with remaining unvisited nodes
            find_paths(
              graph,
              MapSet.delete(unvisited, node),
              new_distances,
              new_predecessors,
              all
            )
        end
    end
  end

  def update_neighbors(graph, current, unvisited, distances, predecessors, all \\ false) do
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

      cond do
        new_distance < Map.get(dist_acc, neighbor, :infinity) ->
          {
            Map.put(dist_acc, neighbor, new_distance),
            Map.put(pred_acc, neighbor, current)
          }

        all == true and new_distance == Map.get(dist_acc, neighbor, :infinity) ->
          {
            dist_acc,
            Map.update(pred_acc, neighbor, current, fn x -> List.wrap(x) ++ [current] end)
          }

        true ->
          {dist_acc, pred_acc}
      end
    end)
  end

  def get_path(_start_node, end_node, predecessors) do
    build_path(end_node, predecessors, [], [])
  end

  defp build_path(nil, _predecessors, _path, _paths), do: nil

  defp build_path(node, predecessors, path, paths) do
    case Map.get(predecessors, node) do
      nil ->
        [[node | path]] ++ paths

      predecessor ->
        Enum.reduce(List.wrap(predecessor), paths, fn p, acc ->
          build_path(p, predecessors, [node | path], acc)
        end)
    end
  end
end
