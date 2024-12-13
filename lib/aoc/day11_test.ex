defmodule Aoc.Day11Test do
  use ExUnit.Case

  import Elixir.Aoc.Day11

  def test_input() do
    """
    125 17
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 55312
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
