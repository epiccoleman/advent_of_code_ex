defmodule Aoc2015.Day01Test do
  use ExUnit.Case
  alias Aoc2015.Day01

  test "Part 1" do
   input = File.read!("./test/aoc_2015/day01/input.txt")
   assert Day01.part_1(input) == 280
  end

  test "Part 2" do
   input = File.read!("./test/aoc_2015/day01/input.txt")
   assert Day01.part_2(input) == 1797
  end
end
