defmodule Aoc.Day23Test do
  use ExUnit.Case

  import Elixir.Aoc.Day23

  def test_input() do
    """
    kh-tc
    qp-kh
    de-cg
    ka-co
    yn-aq
    qp-ub
    cg-tb
    vc-aq
    tb-ka
    wh-tc
    yn-cg
    kh-ub
    ta-co
    de-co
    tc-td
    tb-wq
    wh-td
    ta-ka
    td-qp
    aq-cg
    wq-ub
    ub-vc
    de-ta
    wq-aq
    wq-vc
    wh-yn
    ka-de
    kh-ta
    co-tc
    wh-qp
    tb-vc
    td-yn
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 7
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == "co,de,ka,ta"
  end
end
