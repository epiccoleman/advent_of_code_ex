defmodule Aoc2015.Day03Test do
  use ExUnit.Case
  alias Aoc2015.Day03

  test "Part 1" do
   input = File.read!("./test/aoc_2015/day03/input.txt")
   assert Day03.part_1(input) == 2592
  end

  test "Part 2" do
    input = File.read!("./test/aoc_2015/day03/input.txt")
   assert Day03.part_2(input) == 2360
  end
end
