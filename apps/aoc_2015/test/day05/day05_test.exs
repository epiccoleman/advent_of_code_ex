defmodule Day05Test do
  use ExUnit.Case
  import AOCUtils.FileUtils
  import Day05

  test "Part 1" do
   input = get_file_as_strings("test/day05/input.txt")
   assert part_1(input) == 258
  end

  test "Part 2" do
   input = get_file_as_strings("test/day05/input.txt")
   assert part_2(input) == 53
  end
end
