defmodule Aoc2021.Day13Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day13

  alias AocUtils.Grid2D

  test "fold_left" do
    grid = Grid2D.from_strs([
      "#.##..#..#.",
      "#...#......",
      "......#...#",
      "#...#......",
      ".#.#..#.###"
    ])

    expected_grid = Grid2D.from_strs([
      "#####",
      "#...#",
      "#...#",
      "#...#",
      "#####"
    ])

    actual_grid = fold_left(grid, 5)

    assert actual_grid == expected_grid
  end

  test "fold_up" do
    grid = Grid2D.from_strs([
      "#..#",
      "...#",
      "....",
      "##..",
      "#.##",
    ])

    expected_grid = Grid2D.from_strs([
      "#.##",
      "##.#"
    ])

    actual_grid = fold_up(grid, 2)

    assert actual_grid == expected_grid
  end

  test "fold_up 2" do
    grid = Grid2D.from_strs([
      "#..#",
      "...#",
      "....",
      "##..",
      "#.##",
    ])

    expected_grid = Grid2D.from_strs([
      "#..#",
      "...#",
      "#.##",
    ])

    actual_grid = fold_up(grid, 3)

    assert actual_grid == expected_grid
  end

  # test "Part 1 - test input" do
  #  input = File.read!("./test/aoc_2021/day13/sample_input.txt")
  #  assert part_1(input) == 17
  # end

  test "Part 1" do
   input = File.read!("./test/aoc_2021/day13/input.txt")
   assert part_1(input) == 751
  end

  #test "Part 2" do
  #  input = File.read!("./test/aoc_2021/day13/input.txt")
  #  assert part_2(input) == 0
  #end
end
