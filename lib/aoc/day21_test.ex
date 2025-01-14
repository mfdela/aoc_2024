defmodule Aoc.Day21Test do
  use ExUnit.Case

  import Elixir.Aoc.Day21

  def test_input() do
    """
    029A
    """
  end

  @tag timeout: :infinity
  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 1972
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 2_379_451_789_590
  end
end
