defmodule Day01Test do
  use ExUnit.Case

  import Day01

  test "Part 1" do
   input = File.read!("test/day01/input.txt")
   assert Day01.part_1(input) == 280
  end

  test "Part 2" do
   input = File.read!("test/day01/input.txt")
   assert Day01.part_2(input) == 1797
  end
end
