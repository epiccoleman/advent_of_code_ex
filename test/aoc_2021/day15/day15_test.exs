defmodule Aoc2021.Day15Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day15
  alias AocUtils.Grid2D

  test "small dijkstra" do
    grid = Grid2D.from_rows([
      [1, 1,  1],
      [4, 42, 1],
      [7, 11, 1]
    ])

    result = dijkstra(grid, {0,0}, {2, 2})

    assert Map.get(result.distances, {2, 2}) == 4
  end

  @tag slow: true
  test "Part 2 with sample input" do
   input = get_file_as_strings("./test/aoc_2021/day15/sample_input.txt")
   assert part_2(input) == 315
  end

  @tag slow: true
  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day15/input.txt")
   assert part_1(input) == 363
  end

  # this currently takes an hour to run, so commenting for now.
  # @tag timeout: :infinity
  # @tag slow: true
  # test "Part 2" do
  #  input = get_file_as_strings("./test/aoc_2021/day15/input.txt")
  #  assert part_2(input) == 2835
  # end
end
