defmodule Aoc2020.Day01Test do
  use ExUnit.Case
  alias Aoc2020.Day01

  test "find_pairs_that_sum" do
    input = [ 1721, 979, 366, 299, 675, 1456 ]

    assert Day01.find_pairs_that_sum(input, 2020) == [{ 1721, 299 },{ 299, 1721 }]
  end

  test "find_triple" do
    input = [ 1721, 979, 366, 299, 675, 1456 ]

    assert Day01.find_triple(input, 2020) == %{candidates: [366, 299, 675], pairs: [{366, 675}, {675, 366}], solution: 241861950, target: 1041, tl_value: 979}
  end

  test "Part 1" do
    input = AocUtils.FileUtils.get_file_as_integers("./test/aoc_2020/day01/input.txt")
    assert Day01.part_1(input) == 969024
  end

  test "Part 2" do
    input = AocUtils.FileUtils.get_file_as_integers("./test/aoc_2020/day01/input.txt")
    assert Day01.part_2(input) == 230057040
  end
end
