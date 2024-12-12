defmodule Aoc.Day10Test do
  use ExUnit.Case

  import Elixir.Aoc.Day10

  def test_input() do
    """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 36
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 81
  end
end
