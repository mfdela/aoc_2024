defmodule Aoc.Day12Test do
  use ExUnit.Case

  import Elixir.Aoc.Day12

  def test_input1() do
    """
    AAAA
    BBCD
    BBCC
    EEEC
    """
  end

  def test_input2() do
    """
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """
  end

  def test_input3() do
    """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """
  end

  test "part1" do
    result1 =
      test_input1()
      |> part1()

    result2 =
      test_input2()
      |> part1()

    result3 =
      test_input3()
      |> part1()

    assert result1 == 140 and result2 == 772 and result3 == 1930
  end

  test "part2" do
    result1 =
      test_input1()
      |> part2()

    result2 =
      test_input2()
      |> part2()

    # && result2 == 436
    assert result1 == 80 && result2 == 436
  end
end
