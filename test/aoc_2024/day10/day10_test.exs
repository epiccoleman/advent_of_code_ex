defmodule Aoc2024.Day10Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day10

  test "Part 1 test" do
   input = get_file_as_strings("./test/aoc_2024/day10/test_input.txt")

   assert part_1(input) == 36
  end

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2024/day10/input.txt")
   assert part_1(input) == 694
  end

  test "rate_trailhead" do
    input = get_file_as_strings("./test/aoc_2024/day10/test_input.txt")
    grid = parse_input(input)

    assert rate_trailhead(grid, {2,0}) == 20
  end

  test "Part 2 test" do
   input = get_file_as_strings("./test/aoc_2024/day10/test_input.txt")

   assert part_2(input) == 81
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2024/day10/input.txt")
   assert part_2(input) == 0
  end
end
