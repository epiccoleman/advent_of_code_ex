defmodule Aoc2021.Day08Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day08
  doctest Aoc2021.Day08, import: true

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day08/input.txt")
   assert part_1(input) == 534
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2021/day08/input.txt")
   assert part_2(input) == 1070188
  end
end
