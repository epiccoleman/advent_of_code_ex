defmodule Aoc2021.Day06Test do
  use ExUnit.Case
  import Checkov
  import AOCUtils.FileUtils
  import Aoc2021.Day06

  data_test "simulate_lanternfish_reproduction" do
    initial_state = [ 3,4,3,1,2 ]
    assert Enum.sort(simulate_lanternfish_reproduction(initial_state, t)) == expected_state

    where [
      [:t, :expected_state],
      [1, Enum.sort([2,3,2,0,1])],
      [2, Enum.sort([1,2,1,6,0,8])],
      [3, Enum.sort([0,1,0,5,6,7,8])],
      [4, Enum.sort([6,0,6,4,5,6,7,8,8])],
      [5, Enum.sort([5,6,5,3,4,5,6,7,7,8])]
    ]
  end

  test "simulate_lanternfish_reproduction count is correct" do
    initial_state = [ 3,4,3,1,2 ]
    assert Enum.count(simulate_lanternfish_reproduction(initial_state, 18)) == 26
    assert Enum.count(simulate_lanternfish_reproduction(initial_state, 80)) == 5934
  end

  test "Part 1" do
   input = get_file_as_integers("./test/aoc_2021/day06/input.txt")
   assert part_1(input) == 379114
  end

  test "Part 2" do
   input = get_file_as_integers("./test/aoc_2021/day06/input.txt")
   assert part_2(input) == 1702631502303
  end
end
