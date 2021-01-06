defmodule Day22Test do
  use ExUnit.Case

  import Day22

  test "recursive combat terminates on small input" do
    p1 = [43, 19]
    p2 = [2, 29, 14]

    assert recursive_combat(%{p1: p1, p2: p2, seen: [], winner: nil}).winner == :p1
  end

  test "part 2 sample" do
    p1 = [9, 2, 6, 3, 1]
    p2 = [5, 8, 4, 7, 10]

    combat_results = recursive_combat(%{p1: p1, p2: p2, seen: [], winner: nil})
    assert combat_results.winner == :p2
    assert score_deck(combat_results.p2) == 291
  end

  test "Part 1" do
    input = File.read!("test/day22/input.txt")
    assert Day22.part_1(input) == 35005
  end

  test "Part 2" do
    input = File.read!("test/day22/input.txt")
    assert Day22.part_2(input) == 32751
  end
end
