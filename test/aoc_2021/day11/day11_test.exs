defmodule Aoc2021.Day11Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2021.Day11

  test "do_step" do
    grid_before_step =
      input_to_grid([
        "11111",
        "19991",
        "19191",
        "19991",
        "11111",
      ])

    expected_grid_after_step =
      input_to_grid([
        "34543",
        "40004",
        "50005",
        "40004",
        "34543",
      ])

    expected = %{grid: expected_grid_after_step, total_flashes: 9}

    actual = do_steps(grid_before_step, 1)

    assert expected == actual
  end

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day11/input.txt")
   assert part_1(input) == 1585
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2021/day11/input.txt")
   assert part_2(input) == 382
  end
end
