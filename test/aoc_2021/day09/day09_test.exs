defmodule Aoc2021.Day09Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day09
  import Checkov

  @test_input [
  "2199943210",
  "3987894921",
  "9856789892",
  "8767896789",
  "9899965678",
  ]

  test "find_low_points" do
    test_grid = input_to_grid(@test_input)

    low_point_count = find_low_points(test_grid) |> Enum.count()
    assert low_point_count == 4
  end

  data_test "basin_size" do
    test_grid = input_to_grid(@test_input)
    assert basin_size(test_grid, low_point) == result

    where [
      [:low_point, :result],
      [{1,0}, 3],
      [{9,0}, 9],
      [{2,2}, 14],
      [{6,4}, 9],
    ]
  end

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day09/input.txt")
   assert part_1(input) == 594
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2021/day09/input.txt")
   assert part_2(input) == 858494
  end
end
