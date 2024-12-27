defmodule Aoc.Day18Test do
  use ExUnit.Case

  import Elixir.Aoc.Day18

  def test_input() do
    """
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, 6, 12)

    assert result == 22
  end

  test "part2" do
    input = test_input()
    result = part2(input, 6, 12)

    assert result == "6,1"
  end
end
