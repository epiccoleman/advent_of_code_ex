defmodule Aoc2024.Day01Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day01

  test "lists_from_input" do
    input = get_file_as_strings("./test/aoc_2024/day01/test_input.txt")

    {list1, list2} = lists_from_input(input)

    assert list1 == [3, 4, 2, 1, 3, 3]
    assert list2 == [4, 3, 5, 3, 9, 3]
  end

  test "list_distance" do
    list1 = [3, 4, 2, 1, 3, 3]
    list2 = [4, 3, 5, 3, 9, 3]

    assert list_distance({list1, list2}) == 11
  end

  test "similarity_score" do
    list1 = [3, 4, 2, 1, 3, 3]
    list2 = [4, 3, 5, 3, 9, 3]

    assert similarity_score({list1, list2}) == 31
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2024/day01/input.txt")
    assert part_1(input) == 1_882_714
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2024/day01/input.txt")
    assert part_2(input) == 0
  end
end
