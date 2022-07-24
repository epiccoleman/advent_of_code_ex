defmodule Aoc2015.Day05Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  alias Aoc2015.Day05

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2015/day05/input.txt")
   assert Day05.part_1(input) == 258
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2015/day05/input.txt")
   assert Day05.part_2(input) == 53
  end
end
