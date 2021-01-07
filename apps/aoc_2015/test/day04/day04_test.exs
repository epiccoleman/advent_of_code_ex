defmodule Day04Test do
  use ExUnit.Case
  import Day04

  @tag long: true
  test "Part 1" do
   input = "bgvyzdsv"
   assert part_1(input) == 254575
  end

  @tag long: true
  test "Part 2" do
   input = "bgvyzdsv"
   assert part_2(input) == 1038736
  end
end
