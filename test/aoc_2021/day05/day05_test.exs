defmodule Aoc2021.Day05Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day05

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day05/input.txt")
   assert part_1(input) == 6189
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2021/day05/input.txt")
   assert part_2(input) == 19164
  end
end
