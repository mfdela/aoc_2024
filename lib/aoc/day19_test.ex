defmodule Aoc.Day19Test do
  use ExUnit.Case

  import Elixir.Aoc.Day19

  def test_input() do
    """
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 6
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 16
  end
end
