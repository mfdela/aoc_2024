defmodule Aoc.Day09Test do
  use ExUnit.Case

  import Elixir.Aoc.Day09

  def test_input() do
    """
    2333133121414131402
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 1928
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 2858
  end
end
