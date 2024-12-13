defmodule Aoc2024.Day07Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day07
  import Checkov

  data_test("check_line") do
    assert check_line(target, nums) == result

    where([
      [:target, :nums, :result],
      [190, [10, 19], true],
      [3267, [81, 40, 27], true],
      [292, [11, 6, 16, 20], true],
      [83, [17, 5], false],
      [156, [15, 6], false],
      [7290, [6, 8, 6, 15], false],
      [161_011, [16, 10, 13], false],
      [192, [17, 8, 14], false],
      [21037, [9, 7, 8, 13], false]
    ])
  end

  test "Part 1 test" do
    input = get_file_as_strings("./test/aoc_2024/day07/test_input.txt")
    assert part_1(input) == 3749
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2024/day07/input.txt")
    assert part_1(input) == 303_766_880_536
  end

  test "Part 2 test" do
    input = get_file_as_strings("./test/aoc_2024/day07/test_input.txt")
    assert part_2(input) == 11387
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2024/day07/input.txt")
    assert part_2(input) == 337_041_851_384_440
  end
end
