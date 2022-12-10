defmodule Aoc2022.Day04Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2022.Day04

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2022/day04/input.txt")
   assert part_1(input) == 431
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2022/day04/input.txt")
   assert part_2(input) == 823
  end
end
