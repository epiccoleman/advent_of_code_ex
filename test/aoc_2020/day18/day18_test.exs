defmodule Aoc2020.Day18Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

  import Checkov

  import Day18

  data_test "evaluate" do
    assert evaluate(expression) == result

    where [
      [:expression, :result],
      ["1 + 2 * 3 + 4 * 5 + 6", 71],
      ["1 + (2 * 3) + (4 * (5 + 6))", 51],
      ["2 * 3 + (4 * 5)", 26],
      ["5 + (8 * 3 + 9 + 3 * 4 * 3)", 437],
      ["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) ", 12240],
      ["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632]
    ]
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("./test/aoc_2020/day18/input.txt")
    assert Day18.part_1(input) == 202553439706
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("./test/aoc_2020/day18/input.txt")
    assert Day18.part_2(input) == 88534268715686
  end
end
