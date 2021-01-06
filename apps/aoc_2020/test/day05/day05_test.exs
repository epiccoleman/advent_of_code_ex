defmodule Day05Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

  import Checkov

  data_test "find_column" do
    assert Day05.find_column(input |> String.graphemes) == result

    where [
      [:input, :result],
      ["LLL", 0],
      ["LLR", 1],
      ["LRL", 2],
      ["LRR", 3],
      ["RLL", 4],
      ["RLR", 5],
      ["RRL", 6],
      ["RRR", 7],
    ]
  end

  data_test "find_row" do
    assert Day05.find_row(input |> String.graphemes) == result

    where [
      [:input, :result],
      ["BFFFBBF", 70],
      ["FFFBBBF", 14],
      ["BBFFBBF", 102],
    ]
  end

  data_test "convert_passport" do
    assert Day05.convert_passport(passport_str) == passport

    where [
      [:passport_str, :passport],
      [ "BFFFBBFRRR", %{ row: 70, column: 7, seat_id: 567 }],
      [ "FFFBBBFRRR", %{ row: 14, column: 7, seat_id: 119 }],
      [ "BBFFBBFRLL", %{ row: 102, column: 4, seat_id: 820 }],
    ]
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day05/input.txt")
    assert Day05.part_1(input) == 922
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day05/input.txt")
    assert Day05.part_2(input) == 747
  end
end
