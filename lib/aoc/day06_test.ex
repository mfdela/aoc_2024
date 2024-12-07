defmodule Aoc.Day06Test do
  use ExUnit.Case

  import Elixir.Aoc.Day06

  def test_input() do
    """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 41
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 6
  end
end
