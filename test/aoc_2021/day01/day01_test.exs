defmodule Aoc2021.Day01Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day01

  test "Part 1" do
   input = get_file_as_integers("./test/aoc_2021/day01/input.txt")
   assert part_1(input) == 1301
  end

  test "Part 2" do
   input = get_file_as_integers("./test/aoc_2021/day01/input.txt")
   assert part_2(input) == 1346
  end
end
