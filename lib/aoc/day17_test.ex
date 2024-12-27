defmodule Aoc.Day17Test do
  use ExUnit.Case

  import Elixir.Aoc.Day17

  def test_input() do
    """
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """
  end

  def test_input2() do
    """
    Register A: 2024
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == "4,6,3,5,6,3,5,2,1,0"
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 117_440
  end
end
