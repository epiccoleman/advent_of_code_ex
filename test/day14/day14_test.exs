defmodule Day14Test do
  use ExUnit.Case
  import Day14

  test "apply_bitmask" do
    mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"

    assert apply_bitmask(11, mask) == 73
    assert apply_bitmask(101, mask) == 101
    assert apply_bitmask(0, mask) == 64
  end

  test "Part 1" do

    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day14/input.txt")
    assert Day14.part_1(input) == 10452688630537
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day14/input.txt")
    assert Day14.part_2(input) == 2881082759597
  end
end
