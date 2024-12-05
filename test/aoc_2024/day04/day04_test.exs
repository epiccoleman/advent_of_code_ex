defmodule Aoc2024.Day04Test do
  alias AocUtils.Grid2D
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day04

  # the test grid
  #
  #  ....XXMAS.
  #  .SAMXMS...
  #  ...S..A...
  #  ..A.A.MS.X
  #  XMASAMX.MM
  #  X.....XA.A
  #  S.S.S.S.SS
  #  .A.A.A.A.A
  #  ..M.M.M.MM
  #  .X.X.XMASX

  test "count_xmas_horiz" do
    test_input = get_file_as_strings("./test/aoc_2024/day04/test_input.txt")
    test_grid = Grid2D.from_strs(test_input)

    assert count_xmas_horiz(test_grid) == 5
  end

  test "count_xmas_vert" do
    test_input = get_file_as_strings("./test/aoc_2024/day04/test_input.txt")
    test_grid = Grid2D.from_strs(test_input)

    assert count_xmas_vert(test_grid) == 3
  end

  # describe "count_xmas_diagonal simple" do
  #   test_grid = [
  #     "X...",
  #     ".M..",
  #     "..A."
  #   ]
  # end

  test "count_xmases" do
    test_input = get_file_as_strings("./test/aoc_2024/day04/test_input.txt")

    test_grid = Grid2D.from_strs(test_input)

    assert count_xmases(test_grid) == 18
  end

  test "count_x_mas" do
    test_input = get_file_as_strings("./test/aoc_2024/day04/test_input.txt")

    test_grid = Grid2D.from_strs(test_input)

    assert count_x_mas(test_grid) == 9
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2024/day04/input.txt")
    assert part_1(input) == 2591
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2024/day04/input.txt")
    assert part_2(input) == 1880
  end
end
