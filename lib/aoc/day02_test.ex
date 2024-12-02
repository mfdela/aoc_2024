defmodule Aoc.Day02Test do
  use ExUnit.Case

  import Elixir.Aoc.Day02

  def test_input() do
    """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 2
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 4
  end
end
