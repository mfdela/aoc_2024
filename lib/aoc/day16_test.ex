defmodule Aoc.Day16Test do
  use ExUnit.Case

  import Elixir.Aoc.Day16

  def test_input() do
    """
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 7036
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 45
  end
end
