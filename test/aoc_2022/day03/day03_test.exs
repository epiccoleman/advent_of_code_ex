defmodule Aoc2022.Day03Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2022.Day03

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2022/day03/input.txt")
   assert part_1(input) == 8039
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2022/day03/input.txt")
   assert part_2(input) == 2510
  end
end
