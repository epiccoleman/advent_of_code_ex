defmodule Aoc2024.Day05Test do
  use ExUnit.Case
  import Checkov
  import AocUtils.FileUtils
  import Aoc2024.Day05

  test "update_valid_for_rule?" do
    update = [75, 47, 61, 53, 29]
    rule = {75, 47}
    bad_rule = {61, 47}

    assert update_valid_for_rule?(update, rule)
    assert not update_valid_for_rule?(update, bad_rule)
  end

  data_test "update_valid?" do
    input = get_file_as_strings("./test/aoc_2024/day05/test_input.txt")
    {rules, _updates} = process_input(input)

    assert update_valid?(update, rules) == result

    where([
      [:update, :result],
      [[75, 47, 61, 53, 29], true],
      [[97, 61, 53, 29, 13], true],
      [[75, 29, 13], true],
      [[75, 97, 47, 61, 53], false],
      [[61, 13, 29], false],
      [[97, 13, 75, 29, 47], false]
    ])
  end

  data_test "middle_num" do
    assert middle_num(list) == expected

    where([
      [:list, :expected],
      [[1, 2, 3], 2],
      [[1, 2, 3, 4, 5], 3],
      [[1, 2, 3, 4, 5, 6, 7], 4]
    ])
  end

  test "Part 1 test" do
    input = get_file_as_strings("./test/aoc_2024/day05/test_input.txt")
    assert part_1(input) == 143
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2024/day05/input.txt")
    assert part_1(input) == 5452
  end

  test "Part 2 test" do
    input = get_file_as_strings("./test/aoc_2024/day05/test_input.txt")
    assert part_2(input) == 123
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2024/day05/input.txt")
    assert part_2(input) == 4598
  end
end
