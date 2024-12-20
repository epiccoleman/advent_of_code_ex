defmodule Aoc2020.Day10Test do
  use ExUnit.Case
  alias AocUtils.FileUtils

  test "Part 1" do
    input = FileUtils.get_file_as_integers("./test/aoc_2020/day10/input.txt")
    assert Day10.part_1(input) == 2343
  end

  test "Part 2" do
    input = FileUtils.get_file_as_integers("./test/aoc_2020/day10/input.txt")
    assert Day10.part_2(input) == 31581162962944
  end
end
