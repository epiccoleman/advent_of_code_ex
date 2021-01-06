defmodule Day10Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

  test "Part 1" do
    input = FileUtils.get_file_as_integers("/Users/eric/src/aoc_2020/test/day10/input.txt")
    assert Day10.part_1(input) == 2343
  end

  test "Part 2" do
    input = FileUtils.get_file_as_integers("/Users/eric/src/aoc_2020/test/day10/input.txt")
    assert Day10.part_2(input) == 31581162962944
  end
end
