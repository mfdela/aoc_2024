defmodule Aoc.Day12 do
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

  # Basic flood fill algorithm, unoptimized
  def flood_fill(map, {r, c}, plant, visited) do
    {final_region, all_regions, all_visited} =
      flood_fill({MapSet.new(), [], visited}, map, {r, c}, plant)

    {final_region, [Map.new([{plant, final_region}]) | all_regions], all_visited}
  end

  def flood_fill({region, regions, visited}, map, {r, c}, plant) do
    case {r, c} in Map.keys(map) and Map.get(visited, {r, c}) != true and
           Map.get(map, {r, c}) == plant do
      true ->
        {MapSet.put(region, {r, c}), regions, Map.put(visited, {r, c}, true)}
        |> flood_fill(map, {r + 1, c}, plant)
        |> flood_fill(map, {r - 1, c}, plant)
        |> flood_fill(map, {r, c - 1}, plant)
        |> flood_fill(map, {r, c + 1}, plant)

      false ->
        {region, regions, visited}
    end
  end

  def area(region) do
    MapSet.size(region)
  end

  def perimeter(region) do
    region
    |> MapSet.to_list()
    |> Enum.reduce(0, fn {r, c}, acc ->
      for {rr, cc} <- [{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c + 1}], reduce: acc do
        inneracc ->
          inneracc +
            case MapSet.member?(region, {rr, cc}) do
              true -> 0
              false -> 1
            end
      end
    end)
  end

  def find_all_regions(map) do
    for {k, v} <- map, reduce: {[], Map.new()} do
      acc ->
        {all_regions, visited} = acc

        case Map.get(visited, k) do
          true ->
            acc

          _ ->
            {_, regions, vis} = flood_fill(map, k, v, visited)
            {[regions | all_regions], vis}
        end
    end
    |> elem(0)
    |> List.flatten()
  end

  def find_area_perimeter(list_of_regions) do
    list_of_regions
    |> Enum.reduce(0, fn r, acc ->
      region = Map.values(r) |> hd
      acc + area(region) * perimeter(region)
    end)
  end

  def part1(args) do
    args
    |> process_input()
    |> find_all_regions()
    |> find_area_perimeter()
  end

  def find_corners(region) do
    region
    |> MapSet.to_list()
    |> Enum.reduce(0, fn {r, c}, acc ->
      outside_region =
        for [{r1, c1}, {r2, c2}, {rd, cd}] <- [
              [{r, c - 1}, {r - 1, c}, {r - 1, c - 1}],
              [{r - 1, c}, {r, c + 1}, {r - 1, c + 1}],
              [{r, c + 1}, {r + 1, c}, {r + 1, c + 1}],
              [{r + 1, c}, {r, c - 1}, {r + 1, c - 1}]
            ],
            not MapSet.member?(region, {r1, c1}),
            reduce: 0 do
          acc ->
            acc +
              case not MapSet.member?(region, {r2, c2}) do
                true ->
                  1

                false ->
                  case not MapSet.member?(region, {rd, cd}) do
                    true -> 0
                    false -> 1
                  end
              end
        end

      acc + outside_region
    end)
  end

  def find_area_sides(regions) do
    regions
    |> Enum.reduce(0, fn r, acc ->
      region = Map.values(r) |> hd
      acc + area(region) * find_corners(region)
    end)
  end

  def part2(args) do
    args
    |> process_input()
    |> find_all_regions()
    |> find_area_sides()
  end
end
