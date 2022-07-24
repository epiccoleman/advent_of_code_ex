defmodule Aoc2021.Day04Test do
  use ExUnit.Case
  import Aoc2021.Day04

  test "Part 1 - test input" do
   input = File.read!("./test/aoc_2021/day04/test_input.txt")
   assert part_1(input) == 4512
  end

  test "Part 1 " do
   input = File.read!("./test/aoc_2021/day04/input.txt")
   assert part_1(input) == 49686
  end

  test "Part 2" do
   input = File.read!("./test/aoc_2021/day04/input.txt")
   assert part_2(input) == 26878
  end
end
