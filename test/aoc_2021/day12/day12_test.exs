defmodule Aoc2021.Day12Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day12

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day12/input.txt")
   assert part_1(input) == 3679
  end

  test "Small input" do
    small_input = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """ |> String.split("\n", trim: true)

    assert part_2(small_input) == 36
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2021/day12/input.txt")
   assert part_2(input) == 107395
  end
end
