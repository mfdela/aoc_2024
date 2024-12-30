defmodule Aoc.Day20Test do
  use ExUnit.Case

  import Elixir.Aoc.Day20

  def test_input() do
    """
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
