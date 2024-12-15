defmodule Aoc.Day14Test do
  use ExUnit.Case

  import Elixir.Aoc.Day14

  def test_input() do
    """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, 7, 11)

    assert result == 12
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
