defmodule Aoc2021.Day07Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day07

  test "Part 1" do
   input = get_file_as_integers("./test/aoc_2021/day07/input.txt")
   assert part_1(input) == 351901
  end

  test "Part 2" do
   input = get_file_as_integers("./test/aoc_2021/day07/input.txt")
   assert part_2(input) == 101079875
  end
end
