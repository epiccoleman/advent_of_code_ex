defmodule Aoc2020.Day09Test do
  use ExUnit.Case
  alias AocUtils.FileUtils
  alias Aoc2020.Day09


  test "get_pairs/2 simple" do
    input = [ 35, 20, 15, 25, 47, 40, 62 ]

    assert Day09.get_pairs(input, 5) == [
      %{pairs: [{20, 20}, {15, 25}, {25, 15}], target: 40},
      %{pairs: [{15, 47}, {47, 15}], target: 62}
    ]
  end

  test "find_weak_number" do
    input = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219,
    299, 277, 309, 576]

    assert Day09.find_weak_number(input, 5) == 127
  end

  test "find_encryption_weakness" do
    input = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219,
    299, 277, 309, 576]

    assert Day09.find_encryption_weakness(input, 127) == [15, 25, 47, 40]
  end

  test "Part 1" do
    input = FileUtils.get_file_as_integers("./test/aoc_2020/day09/input.txt")
    assert Day09.part_1(input) == 731031916
  end

  # disabled because it takes a while

  @tag slow: true
  test "Part 2" do
    input = FileUtils.get_file_as_integers("./test/aoc_2020/day09/input.txt")
    assert Day09.part_2(input) == 93396727
  end
end
