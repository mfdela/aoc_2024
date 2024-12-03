defmodule Aoc.Day03Test do
  use ExUnit.Case

  import Elixir.Aoc.Day03

  def test_input() do
    """
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """
  end

  def test_input2() do
    """
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 161
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 48
  end
end
