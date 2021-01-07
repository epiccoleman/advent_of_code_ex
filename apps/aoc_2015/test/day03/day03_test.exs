defmodule Day03Test do
  use ExUnit.Case
  import Day03

  test "Part 1" do
   input = File.read!("test/day03/input.txt")
   assert part_1(input) == 2592
  end

  test "Part 2" do
    input = File.read!("test/day03/input.txt")
   assert part_2(input) == 2360
  end
end
