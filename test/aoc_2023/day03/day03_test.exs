defmodule Aoc2023.Day03Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2023.Day03
  alias AocUtils.Grid2D, as: Grid

  test "get_part_number_at_location" do
    grid_strs = [
      "92.",
      ".x.",
      "..."
    ]

    grid = Grid.from_strs(grid_strs, ignore: ".")

    assert get_part_number_at_location(grid, {0, 0}) == %{n: 92, locs: [{0, 0}, {1, 0}]}
    assert get_part_number_at_location(grid, {1, 0}) == %{n: 92, locs: [{0, 0}, {1, 0}]}
    assert get_part_number_at_location(grid, {1, 1}) == nil
    assert get_part_number_at_location(grid, {2, 2}) == nil
  end

  test "get_surrounding_part_numbers" do
    grid_strs = [
      "92.4",
      ".x.5",
      "3.13"
    ]

    grid = Grid.from_strs(grid_strs, ignore: ".")

    expected_part_numbers = [92, 13, 3]

    assert get_surrounding_part_numbers(grid, {1, 1}) == expected_part_numbers
  end

  test "get_symbol_locations" do
    grid_strs = [
      "..@.",
      ".#.x",
      "...$"
    ]

    grid = Grid.from_strs(grid_strs, ignore: ".")

    expected_symbol_locs = [
      {1, 1},
      {2, 0},
      {3, 1},
      {3, 2}
    ]

    assert get_symbol_locations(grid) == expected_symbol_locs
  end

  test "Part 1 small" do
    input = get_file_as_strings("./test/aoc_2023/day03/input_small.txt")
    assert part_1(input) == 4361
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2023/day03/input.txt")
    assert part_1(input) == 527_364
  end

  test "get_gear_ratios" do
    input = get_file_as_strings("./test/aoc_2023/day03/input_small.txt")
    grid = Grid.from_strs(input, ignore: ".")

    expected_gear_ratio = [16345, 451_490]

    assert get_gear_ratios(grid) == expected_gear_ratio
  end

  test "Part 2 small" do
    input = get_file_as_strings("./test/aoc_2023/day03/input_small.txt")
    assert part_2(input) == 467_835
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2023/day03/input.txt")
    assert part_2(input) == 79_026_871
  end
end
