defmodule Day23Test do
  use ExUnit.Case
  import Day23

  test "take three cups" do
    cups = [ 1, 2, 3, 4, 5, 6, 7, 8 ]
    assert take_three_cups(cups, 1) == {[ 2, 3, 4], [1, 5, 6, 7, 8]}
    assert take_three_cups(cups, 7) == {[ 8, 1, 2], [7, 3, 4, 5, 6]}

  end

  test "Part 1" do
    input = 589174263
    assert Day23.part_1(input) == 43896725
  end

  # takes about 3 minutes

  @tag slow: true
  @tag timeout: :infinity
  test "Part 2" do
    input = 589174263
    assert Day23.part_2(input) == 2911418906
  end
end
