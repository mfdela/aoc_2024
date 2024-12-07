defmodule Aoc.Day06 do
  def process_input(input) do
    dimr = input |> String.split("\n", trim: true) |> Enum.count()
    dimc = input |> String.split("\n", trim: true) |> Enum.at(0) |> String.length()

    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index(fn el, r ->
        el
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {val, _c} -> val != "." end)
        |> Enum.map(fn {val, c} -> {{r, c}, val} end)
      end)
      |> List.flatten()
      |> Map.new()

    {{r, c}, pointer} = find_start(map)
    {map, dimr, dimc, r, c, pointer}
  end

  def find_start(map) do
    map
    |> Enum.find(fn {{_r, _c}, val} -> val == "^" end)
  end

  def dir("^"), do: [-1, 0]
  def dir(">"), do: [0, 1]
  def dir("v"), do: [1, 0]
  def dir("<"), do: [0, -1]
  def turn("^"), do: ">"
  def turn(">"), do: "v"
  def turn("v"), do: "<"
  def turn("<"), do: "^"

  def next_move(_map, _pointer, r, c, maxr, maxc, visited)
      when r == -1 or c == -1 or r == maxr or c == maxc,
      do: {:ok, visited}

  def next_move(map, pointer, r, c, maxr, maxc, visited) do
    [dr, dc] = dir(pointer)

    v = Map.put_new(visited, {r, c}, pointer)

    cond do
      Map.get(map, {r + dr, c + dc}) == "#" ->
        next_move(map, turn(pointer), r, c, maxr, maxc, v)

      Map.get(visited, {r + dr, c + dc}) == pointer ->
        {:loop_detected, 1}

      true ->
        next_move(map, pointer, r + dr, c + dc, maxr, maxc, v)
    end
  end

  def part1(args) do
    {map, maxr, maxc, r_start, c_start, pointer} =
      args
      |> process_input()

    {:ok, visited} = next_move(map, pointer, r_start, c_start, maxr, maxc, Map.new())

    visited
    |> Enum.count()
  end

  def part2(args) do
    {map, maxr, maxc, r_start, c_start, pointer} =
      args
      |> process_input()

    # find first path
    {:ok, visited} = next_move(map, pointer, r_start, c_start, maxr, maxc, Map.new())

    for {{r, c}, _} <- visited, reduce: 0 do
      acc ->
        case next_move(
               Map.put(map, {r, c}, "#"),
               pointer,
               r_start,
               c_start,
               maxr,
               maxc,
               Map.new()
             ) do
          {:ok, _} -> acc
          {:loop_detected, _} -> acc + 1
        end
    end
  end
end
