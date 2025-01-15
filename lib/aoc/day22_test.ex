defmodule Aoc.Day22Test do
  use ExUnit.Case

  import Elixir.Aoc.Day22

  def test_input() do
    """
    1
    10
    100
    2024
    """
  end

  def test_input2() do
    """
    1
    2
    3
    2024
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 37_327_623
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 23
  end
end
