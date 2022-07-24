defmodule Aoc2021.Day02Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day02

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day02/input.txt")
   assert part_1(input) == 2117664
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2021/day02/input.txt")
   assert part_2(input) == 2073416724
  end
end
