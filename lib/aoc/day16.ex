defmodule Aoc.Day16 do
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
    |> Enum.filter(fn {{_r, _c}, val} -> val != "#" end)
    |> Map.new()
  end

  def compute_weights(map) do
    for node <- Map.keys(map), td <- [:north, :south], lr <- [:east, :west], reduce: %{} do
      acc ->
        v1 = {node, td}
        v2 = {node, lr}
        neighbours1 = neighbours(map, v1)
        neighbours2 = neighbours(map, v2)

        acc
        |> Map.update(
          v1,
          %{:cost => 1_000_000_000_000, :paths => [[]], :neighbours => %{}},
          fn x ->
            x
          end
        )
        |> Map.update(
          v2,
          %{:cost => 1_000_000_000_000, :paths => [[]], :neighbours => %{}},
          fn x ->
            x
          end
        )
        |> update_in([v1, :neighbours], &Map.merge(&1, %{v2 => 1000}))
        |> update_in([v2, :neighbours], &Map.merge(&1, %{v1 => 1000}))
        |> update_in([v1, :neighbours], &Map.merge(&1, neighbours1))
        |> update_in([v2, :neighbours], &Map.merge(&1, neighbours2))
    end
  end

  def find_char(input, char) do
    input |> Enum.find(fn {{_, _}, val} -> val == char end) |> elem(0)
  end

  def dijkstra(map, queue, goal) do
    {result, pq} = PriorityQueue.pop(queue)

    node =
      case result do
        :empty -> :finished
        {:value, n} -> n
      end

    case node do
      :finished ->
        {pq, map}

      {^goal, _} ->
        {pq, map}

      _ ->
        node_paths =
          get_in(map, [node, :paths])
          |> Enum.map(&[node | &1])

        node_cost = get_in(map, [node, :cost])

        {new_queue, new_map} =
          for {neighbour, edge_cost} <- get_in(map, [node, :neighbours]),
              reduce: {pq, map} do
            acc ->
              {nq, np} = acc
              cost_through = node_cost + edge_cost
              neighbour_cost = get_in(np, [neighbour, :cost])
              {node_coord, _} = node

              cond do
                cost_through < neighbour_cost ->
                  {PriorityQueue.push(nq, neighbour, cost_through),
                   update_in(np, [neighbour, :cost], fn _ -> cost_through end)
                   |> update_in([neighbour, :paths], fn _ -> node_paths end)}

                cost_through == neighbour_cost ->
                  {nq,
                   update_in(np, [neighbour, :paths], fn x ->
                     node_paths ++ x
                   end)}

                true ->
                  acc
              end
          end

        dijkstra(new_map, new_queue, goal)
    end
  end

  def neighbours(map, node) do
    {{r, c}, dir} = node

    [
      {{r - 1, c}, :north},
      {{r + 1, c}, :south},
      {{r, c - 1}, :west},
      {{r, c + 1}, :east}
    ]
    |> Enum.filter(fn {{r, c}, facing} -> Map.get(map, {r, c}, "#") != "#" && dir == facing end)
    |> Enum.map(fn n -> {n, 1} end)
    |> Map.new()
  end

  def part1(args) do
    map =
      args
      |> process_input()

    start_node = find_char(map, "S")
    end_node = find_char(map, "E")

    {_, dist} =
      map
      |> compute_weights()
      |> update_in([{start_node, :east}, :cost], fn _ -> 0 end)
      |> dijkstra(
        PriorityQueue.new()
        |> PriorityQueue.push({start_node, :east}, 0),
        end_node
      )

    for(d <- [:east, :west, :north, :south], do: get_in(dist, [{end_node, d}, :cost]))
    |> Enum.min()
  end

  def part2(args) do
    map =
      args
      |> process_input()

    start_node = find_char(map, "S")
    end_node = find_char(map, "E")

    {_, dist} =
      map
      |> compute_weights()
      |> update_in([{start_node, :east}, :cost], fn _ -> 0 end)
      |> dijkstra(
        PriorityQueue.new()
        |> PriorityQueue.push({start_node, :east}, 0),
        end_node
      )

    for d <- [:west, :north, :south],
        reduce:
          {get_in(dist, [{end_node, :east}, :paths]), get_in(dist, [{end_node, :east}, :cost])} do
      acc ->
        {p, c} = acc

        case get_in(dist, [{end_node, d}, :cost]) <= c do
          true ->
            {get_in(dist, [{end_node, d}, :paths]), get_in(dist, [{end_node, d}, :cost])}

          false ->
            acc
        end
    end
    |> then(fn {p, _c} -> p end)
    |> List.flatten()
    |> Enum.map(fn {{r, c}, _} -> {r, c} end)
    |> Enum.uniq()
    |> Enum.count()
    |> Kernel.+(1)
  end
end
