defmodule Aoc2022.Day05Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2022.Day05

  test "Part 1" do
   input = File.read!("./test/aoc_2022/day05/input.txt")
   assert part_1(input) == "MQSHJMWNH"
  end

  test "Part 2" do
   input = File.read!("./test/aoc_2022/day05/input.txt")
   assert part_2(input) == "LLWJRBHVZ"
  end
end
