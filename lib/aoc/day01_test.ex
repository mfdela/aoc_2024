defmodule Aoc.Day01Test do
  use ExUnit.Case

  import Elixir.Aoc.Day01

  def test_input() do
    """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 11
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 31
  end
end
