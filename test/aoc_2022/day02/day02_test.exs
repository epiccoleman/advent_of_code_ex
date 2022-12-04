defmodule Aoc2022.Day02Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2022.Day02

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2022/day02/input.txt")
   assert part_1(input) == 15337
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2022/day02/input.txt")
   assert part_2(input) == 11696
  end
end
