defmodule Aoc2021.Day12Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day12

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day12/input.txt")
   assert part_1(input) == 3679
  end

  #test "Part 2" do
  #  input = get_file_as_strings("./test/aoc_2021/day12/input.txt")
  #  assert part_2(input) == 0
  #end
end
