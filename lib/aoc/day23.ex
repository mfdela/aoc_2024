defmodule Aoc.Day23 do
  def process_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(Graph.new(type: :undirected), fn [a, b], graph ->
      Graph.add_edge(graph, a, b)
    end)
  end

  def filter_clicques(cliques, size) do
    Enum.filter(cliques, fn clique ->
      length(clique) >= size && Enum.any?(clique, &String.starts_with?(&1, "t"))
    end)
    |> Enum.reduce(MapSet.new(), fn
      clique, acc when length(clique) == size ->
        MapSet.put(acc, Enum.sort(clique))

      clique, acc ->
        Aoc.comb(3, clique)
        |> Enum.filter(fn c -> Enum.any?(c, &String.starts_with?(&1, "t")) end)
        |> Enum.map(&Enum.sort/1)
        |> Enum.reduce(acc, &MapSet.put(&2, &1))
    end)
  end

  def part1(args) do
    args
    |> process_input()
    |> Graph.cliques()
    |> filter_clicques(3)
    |> MapSet.size()
  end

  def part2(args) do
    args
    |> process_input()
    |> Graph.cliques()
    |> Enum.max_by(&length/1)
    |> Enum.sort()
    |> Enum.join(",")
  end
end
