defmodule Aoc.Day14 do
  def process_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&process_line/1)
  end

  def process_line(line) do
    ["p", p, "v", v] =
      line
      |> String.split(" ", trim: true)
      |> Enum.flat_map(&String.split(&1, "="))

    {String.split(p, ",") |> Enum.map(&String.to_integer/1),
     String.split(v, ",") |> Enum.map(&String.to_integer/1)}
  end

  def move({[px, py], [vx, vy]}, max_x, max_y) do
    {[wrap(px + vx, max_x), wrap(py + vy, max_y)], [vx, vy]}
  end

  def wrap(x, max) do
    if x < 0, do: wrap(x + max, max), else: rem(x, max)
  end

  def move_all_robots(robots, max_x, max_y) do
    Enum.map(robots, &move(&1, max_x, max_y))
  end

  def count_quadrants(robots, max_x, max_y) do
    robots
    |> Enum.map(&elem(&1, 0))
    |> Enum.reject(fn [x, y] -> x == floor(max_x / 2) or y == floor(max_y / 2) end)
    |> Enum.group_by(&quadrant(&1, max_x, max_y))
    |> Enum.reduce(1, fn {_, v}, acc -> acc * length(v) end)
  end

  def quadrant([x, y], max_x, max_y) do
    case {x, y} do
      {x, y} when x < floor(max_x / 2) and y < floor(max_y / 2) -> 1
      {x, y} when x > floor(max_x / 2) and y < floor(max_y / 2) -> 2
      {x, y} when x < floor(max_x / 2) and y > floor(max_y / 2) -> 3
      {x, y} when x > floor(max_x / 2) and y > floor(max_y / 2) -> 4
    end
  end

  def part1(args, max_x \\ 101, max_y \\ 103) do
    robots =
      args
      |> process_input()

    for _ <- 1..100, reduce: robots do
      acc ->
        move_all_robots(acc, max_x, max_y)
    end
    |> count_quadrants(max_x, max_y)
  end

  def find_easter_egg(_robots, _max_x, _max_y, count, true), do: count - 1

  def find_easter_egg(robots, max_x, max_y, count, false) do
    new_robots =
      move_all_robots(robots, max_x, max_y)

    rr =
      robots
      |> Enum.map(&elem(&1, 0))

    all_unique = rr |> MapSet.new() |> MapSet.size() == length(rr)

    find_easter_egg(new_robots, max_x, max_y, count + 1, all_unique)
  end

  def part2(args, max_x \\ 101, max_y \\ 103) do
    robots =
      args
      |> process_input()

    find_easter_egg(robots, max_x, max_y, 0, false)
  end
end
